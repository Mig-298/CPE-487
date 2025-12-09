LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEE.numeric_std.ALL; 
use IEEE.math_real.all


ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN UNSIGNED(10 DOWNTO 0);
        pixel_col : IN UNSIGNED(10 DOWNTO 0);
        pac_dir : IN UNSIGNED (1 DOWNTO 0); -- current pacman direction
        reset : IN STD_LOGIC; 
        clk_in : IN STD_LOGIC;
        btn_left : IN STD_LOGIC;
        btn_right : IN STD_LOGIC;
        btn_up : IN STD_LOGIC;
        btn_down : IN STD_LOGIC;
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC; 
        score_out: OUT INTEGER;
        alive_out : OUT STD_LOGIC;  
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS;
    TYPE coord is array(0 to 1) of INTEGER; -- x and y value 
    TYPE wall_coord is array(0 to 1) of coord;  -- coord of begin and end 
    TYPE wall_coord_list is array(0 downto 0) of wall_coord; --list of walls to draw 
    CONSTANT wall_w :  INTEGER := 10;-- wall width 
    CONSTANT walls_to_draw : wall_coord_list := 
    (
    0 => ( (0, 50+wall_w),  (799, 50) )
    );
    
    TYPE food_coord is array(0 to 2) of INTEGER; 
    TYPE food_coord_list is array(56 downto 0) of food_coord;

    --I gave chatgpt coordinate range and had it generate this list 
    constant FOOD_LIST : food_coord_list :=
(
    -- New coordinate
    55 => (1, 275, 285),

    -- New box at 235..275 × 325..405
    54 => (1, 275, 405),
    53 => (1, 235, 405),
    52 => (1, 275, 365),
    51 => (1, 235, 365),
    50 => (1, 275, 325),
    49 => (1, 235, 325),

    -- Previously added box at 155..195 × 285..325
    48 => (1, 195, 325),
    47 => (1, 155, 325),
    46 => (1, 195, 285),
    45 => (1, 155, 285),

    -- Additional single coordinate
    44 => (1, 195, 245),

    -- Vertical segment at x = 115 (285 → 405)
    43 => (1, 115, 405),
    42 => (1, 115, 365),
    41 => (1, 115, 325),
    40 => (1, 115, 285),

    -- Horizontal row at y = 85
    39 => (1, 635,  85),
    38 => (1, 595,  85),
    37 => (1, 555,  85),
    36 => (1, 515,  85),
    35 => (1, 475,  85),
    34 => (1, 435,  85),
    33 => (1, 395,  85),
    32 => (1, 355,  85),
    31 => (1, 315,  85),
    30 => (1, 275,  85),
    29 => (1, 235,  85),
    28 => (1, 195,  85),
    27 => (1, 155,  85),
    26 => (1, 115,  85),
    25 => (1,  75,  85),

    -- Vertical column at x = 35 (125 → 525)
    24 => (1,  35, 525),
    23 => (1,  35, 485),
    22 => (1,  35, 445),
    21 => (1,  35, 405),
    20 => (1,  35, 365),
    19 => (1,  35, 325),
    18 => (1,  35, 285),
    17 => (1,  35, 245),
    16 => (1,  35, 205),
    15 => (1,  35, 165),
    14 => (1,  35, 125),

    -- Horizontal segment at y = 525 (75 → 315)
    13 => (1, 315, 525),
    12 => (1, 275, 525),
    11 => (1, 235, 525),
    10 => (1, 195, 525),
     9 => (1, 155, 525),
     8 => (1, 115, 525),
     7 => (1,  75, 525),

    -- Horizontal segment at y = 205 (75 → 195)
     6 => (1, 195, 205),
     5 => (1, 155, 205),
     4 => (1, 115, 205),
     3 => (1,  75, 205),

    -- Vertical segment at x = 235 (125 → 205)
     2 => (1, 235, 205),
     1 => (1, 235, 165),
     0 => (1, 235, 125)
);



    
    CONSTANT pac_size : INTEGER := 10; 
    CONSTANT ghost_size : INTEGER := 10; 
    CONSTANT food_size : INTEGER := 5;

    CONSTANT COLORS : ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(2 DOWNTO 0) := (
        "100", -- red
        "010", -- green
        "001", -- blue
        "110", -- yellow
        "101", -- magenta
        "011", -- cyan
        "111", -- white
        "000"  -- black
    );

    CONSTANT PAC_COLOR : INTEGER := 3; -- yellow
    CONSTANT WALL_COLOR : INTEGER := 7; -- black
    CONSTANT BACKGROUND_COLOR : INTEGER := 6; -- white
    CONSTANT FOOD_COLOR : INTEGER := 0; -- red
    CONSTANT GHOST_COLORS : ARRAY (0 TO 3) OF INTEGER := (4, 5); -- green, blue, magenta



    
    SIGNAL wall_on : STD_LOGIC; 
    SIGNAL pac_on : STD_LOGIC; 
    SIGNAL food_on : STD_LOGIC;
    SIGNAL color_on : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ghost1_on : STD_LOGIC;

    CONSTANT STARTING_PAC_X : UNSIGNED(10 downto 0) := to_unsigned(350, 11);
    CONSTANT STARTING_PAC_Y : UNSIGNED(10 downto 0) := to_unsigned(2850, 11);

    SIGNAL pac_x : UNSIGNED(10 downto 0) := STARTING_PAC_X; 
    SIGNAL pac_y : UNSIGNED(10 downto 0) := STARTING_PAC_Y; 

    CONSTANT STARTING_GHOST_X : UNSIGNED(10 downto 0) := to_unsigned(400, 11); 
    CONSTANT STARTING_GHOST_Y : UNSIGNED(10 downto 0) := to_unsigned(300, 11);
    SIGNAL ghost1_x : UNSIGNED(10 downto 0) := STARTING_GHOST_X;
    SIGNAL ghost1_y : UNSIGNED(10 downto 0) := STARTING_GHOST_Y;

    CONSTANT MOVE_SPEED : INTEGER := 5;

    SIGNAL curr_score : INTEGER := 0;
    SIGNAL curr_alive : STD_LOGIC := '1';

BEGIN
    red <=  color_on(2);
    green <= color_on(1);
    blue <=  color_on(0);
    score_out <= curr_score;
    alive_out <= curr_alive;


    select_color: PROCESS(wall_on, pac_on, food_on) IS
    BEGIN
        IF wall_on = '1' THEN
            color_on <= COLORS(WALL_COLOR);
        ELSIF pac_on = '1' THEN
            color_on <= COLORS(PAC_COLOR);
        ELSIF food_on = '1' THEN
            color_on <= COLORS(FOOD_COLOR);
        ELSIF ghost1_on = '1' THEN
            color_on <= COLORS(GHOST_COLORS(0));
        ELSE
            color_on <= COLORS(BACKGROUND_COLOR);
        END IF;
    END PROCESS;

    -- draws walls lol 
    walldraw: PROCESS(pixel_row, pixel_col) IS 
        VARIABLE starting_coord : coord; 
        VARIABLE ending_coor: coord; 
        VARIABLE is_in_wall : std_logic := '0'; 
    BEGIN 
        -- determine if wall is horizontal or veritcal 
        is_in_wall := '0';
        FOR index IN walls_to_draw'RANGE LOOP
            starting_coord := walls_to_draw(index)(0);
            ending_coord := walls_to_draw(index)(1); 
            IF (pixel_col >= starting_coord(0) AND pixel_col <= ending_coord(0)) AND 
                (pixel_row >= starting_coord(1) AND pixel_row <= ending_coord(1)) THEN
                is_in_wall := '1';
                EXIT;
            END IF;
        END LOOP; 
        wall_on <= is_in_wall; 
    END PROCESS: 

    pacdraw: PROCESS(pac_x, pac_y, pixel_row, pixel_col, pac_dir) IS 
        VARIABLE vx, vy : UNSIGNED(10 DOWNTO 0);  
        VARIABLE xd, yd : STD_LOGIC;  --whether pixel_col/row is to the right/above pacx/y
        CONSTANT pi : REAL := 3.14159;
        CONSTANT tan0 = 1.73205; -- tan(2*pi/6)
        CONSTANT tan1 = 0.57735; -- tan(pi/6)
    BEGIN
        IF pixel_col <= pac_x THEN -- vx = |pac_x - pixel_col|
            vx := pac_x - pixel_col;
            xd := '0';  -- pixel is left of pac_x
        ELSE
            vx := pixel_col - pac_x;
            xd := '1'; -- pixel is right of pac_x
        END IF;
        IF pixel_row <= pac_y THEN -- vy = |pac_y - pixel_row|
            vy := pac_y - pixel_row;
            yd := '1'; -- pixel is above pac_y
        ELSE
            vy := pixel_row - pac_y;
            yd := '0'; -- pixel is below pac_y
        END IF;

        IF pac_dir == "00" THEN -- up 
            IF ((vx*vx) + (vy*vy) <= 100) AND --circle equation 
                (--not in mouth
                    (yd=='0') OR  -- bottom half 
                    (vy <= (tan0*vx)) OR  --right half 
                    (vy <= (-tan0*vx))  --left half ( f(-x) flips horizontally)
                )  
            THEN
                 pac_on <= '1';
            ELSE
                pac_on <= '0';
            END IF;
        ELSIF pac_dir == "01" THEN -- right 
            IF (vx*vx + vy*vy <= pac_size*pac_size) AND --circle equation 
                ((vy >= -tan1*vx) OR  (vx <= tan1*vy) OR ())  --not in mouth
            THEN
                 pac_on <= '1';
            ELSE
                pac_on <= '0';
            END IF;
        ELSIF pac_dir == "10" THEN -- down 
            IF (vx*vx + vy*vy <= pac_size*pac_size) AND --circle equation 
                ((vy >= tan0*vx) OR  (vy >= -tan0*vx))  --not in mouth
            THEN
                 pac_on <= '1';
            ELSE
                pac_on <= '0';
            END IF;
        END IF; 
            

    END PROCESS;
        
    fooddraw: PROCESS(food_list, pixel_row, pixel_col) IS 
        VARIABLE not_eaten, food_x, food_y : INTEGER; 
        VARIABLE is_in_food : std_logic := '0';

        for index in food_list'range LOOP
            not_eaten := food_list(index)(0);
            food_x := food_list(index)(1);
            food_y := food_list(index)(2);
            IF not_eaten = '1' AND (pixel_col >= food_x - food_size AND pixel_col <= food_x + food_size) AND 
                (pixel_row >= food_y - food_size AND pixel_row <= food_y + food_size) THEN
                is_in_food := '1';
            END IF;
        END LOOP;
        food_on <= is_in_food;
    END PROCESS;


    ghost1draw: PROCESS(pixel_row, pixel_col, ghost1_x, ghost1_y) IS 
    BEGIN
        IF (pixel_col <= ghost1_x + ghost_size) AND (pixel_col >= ghost1_x - ghost_size) AND 
           (pixel_row <= ghost1_y + 2*ghost_size) AND (pixel_row >= ghost1_y - 2*ghost_size) THEN
            -- draw ghost 
            ghost1_on <= '1';
        ELSE
            ghost1_on <= '0';
        END IF;
    END PROCESS;

    eatfood: PROCESS(pac_on, food_on, food_list, pac_x, pac_y) IS 
        VARIABLE food_x, food_y : INTEGER; 
    BEGIN
        IF pac_on = '1' AND food_on = '1' THEN
            FOR index IN food_list'RANGE LOOP
                food_x := food_list(index)(1);
                food_y := food_list(index)(2);
                IF (pac_x >= food_x - food_size AND pac_x <= food_x + food_size) AND 
                   (pac_y >= food_y - food_size AND pac_y <= food_y + food_size) THEN
                    food_list(index)(0) := 0; -- mark as eaten 
                END IF;
            END LOOP;
        END IF;
    END PROCESS;

    die: PROCESS(pac_on, ghost1_on, curr_score) IS 
    BEGIN
        IF pac_on = '1' AND ghost1_on = '1' THEN
            curr_alive <= '0';
        END IF;
    END PROCESS;

    rst: PROCESS(reset) IS 
    BEGIN 
        IF reset = '1' THEN
            curr_score <= 0;
            curr_alive <= '1';
            -- reset food 
            FOR index IN food_list'RANGE LOOP
                food_list(index)(0) := 1; 
            END LOOP;
            ghost1_x <= STARTING_GHOST_X;
            ghost1_y <= STARTING_GHOST_Y;
            pac_x <= STARTING_PAC_X;
            pac_y <= STARTING_PAC_Y;
        END IF;
    END PROCESS;


    move_pac: PROCESS(clk_in) IS 
        new_pac_x : UNSIGNED(10 downto 0);
        new_pac_y : UNSIGNED(10 downto 0);
        wall_collide : STD_LOGIC := '0';
    BEGIN
        IF rising_edge(clk_in) THEN
            IF btn_left = '1' THEN 
                new_pac_x := pac_x - to_unsigned(MOVE_SPEED, 11);
            ELSIF btn_right = '1' THEN
                new_pac_x := pac_x + to_unsigned(MOVE_SPEED, 11);
            ELSIF btn_up = '1' THEN
                new_pac_y := pac_y - to_unsigned(MOVE_SPEED, 11);
            ELSIF btn_down = '1' THEN
                new_pac_y := pac_y + to_unsigned(MOVE_SPEED, 11);
            END IF;
        END IF;

        --check if new position collides with wall
        --if not, update pac_x and pac_y
        FOR index IN walls_to_draw'RANGE LOOP
            starting_coord := walls_to_draw(index)(0);
            ending_coord := walls_to_draw(index)(1); 
            IF (new_pac_x >= starting_coord(0) AND new_pac_x <= ending_coord(0)) AND 
                (new_pac_y >= starting_coord(1) AND new_pac_y <= ending_coord(1)) THEN
                wall_collide := '1';
                EXIT;
            END IF;
        END LOOP;
        IF wall_collide = '0' THEN
            pac_x <= new_pac_x;
            pac_y <= new_pac_y;
        END IF; 
    END PROCESS;




END Behavioral;