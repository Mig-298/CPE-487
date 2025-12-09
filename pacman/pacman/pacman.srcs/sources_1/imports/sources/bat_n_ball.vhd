LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN UNSIGNED(10 DOWNTO 0);
        pixel_col : IN UNSIGNED(10 DOWNTO 0);
        pac_x : IN UNSIGNED(10 DOWNTO 0);
        pac_y : IN UNSIGNED(10 DOWNTO 0);
        pac_dir : IN UNSIGNED(1 DOWNTO 0);
        bat_x : IN UNSIGNED (10 DOWNTO 0); -- current bat x position
        serve : IN STD_LOGIC; -- initiates serve
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    -- wall variables
    SIGNAL wall_int : integer := 10;
    TYPE cord is array(0 to 1) of INTEGER;
    TYPE wall_cord is array(0 to 1) of cord;
    TYPE wall_cord_list is array(0 to 7) of wall_cord;
    CONSTANT walls_to_draw : wall_cord_list := 
    (
        0 => ((0, 1+wall_int), (799, 1)), -- Bottom Wall
        1 => ((0, 599), (799, 599-wall_int)), -- Top Wall
        2 => ((0, 599), (0+wall_int, 0)), -- Left Wall
        3 => ((799-wall_int, 599), (799, 0)), -- Right Wall, Last Outer Wall
        
        4 => ((60, 180), (200, 110)),
        5 => ((230, 170), (260, 60)),
        6 => ((260, 100), (370, 60)),
        7 => ((350, 220), (420, 150))
    );
    
    TYPE food_coord is array(0 to 2) of INTEGER;
    TYPE food_coord_list is array(55 downto 0) of food_coord;
    --I gave chatgpt coordinate range and had it generate this list 
    SIGNAL food_list : food_coord_list :=
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
    CONSTANT food_size : INTEGER := 5;

    SIGNAL pac_on : STD_LOGIC;
    SIGNAL food_on : STD_LOGIC;
    SIGNAL wall_on : STD_LOGIC;
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play

BEGIN
    red <= NOT wall_on; -- color setup for red ball and cyan bat on white background
    green <= food_on; 
    blue <= '1';
    -- process to draw walls
    pacdraw: PROCESS(pac_x, pac_y, pixel_row, pixel_col, pac_dir) IS 
        VARIABLE vx, vy : UNSIGNED(10 DOWNTO 0);
        VARIABLE xd, yd : STD_LOGIC;  --whether pixel_col/row is to the right/above pacx/y
        CONSTANT pi : REAL := 3.14159;
        CONSTANT tan0 : REAL := 1.73205; -- tan(2pi/6)
        CONSTANT tan1 : REAL := 0.57735; -- tan(pi/6)
    BEGIN
        IF pixel_col <= pac_x THEN -- vx = |ball_x - pixel_col|
            vx := pac_x - pixel_col;
        ELSE
            vx := pixel_col - pac_x;
        END IF;
        IF pixel_row <= pac_y THEN -- vy = |ball_y - pixel_row|
            vy := pac_y - pixel_row;
        ELSE
            vy := pixel_row - pac_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (pac_size * pac_size) THEN -- test if radial distance < bsize
            pac_on <= game_on;
        ELSE
            pac_on <= '0';
        END IF;
    END PROCESS;

    walldraw : PROCESS (pixel_row, pixel_col) is
        VARIABLE starting_cord : cord; 
        VARIABLE ending_cord : cord;
        VARIABLE in_wall : std_logic := '0';
        VARIABLE col_i, row_i : INTEGER;
    BEGIN
        in_wall := '0';
        for index in wall_cord_list'range loop
            starting_cord := walls_to_draw(index)(0);
            ending_cord := walls_to_draw(index)(1);
            
            if(pixel_col >= starting_cord(0) AND pixel_col <= ending_cord(0) 
               AND pixel_row <= starting_cord(1) AND pixel_row >= ending_cord(1)) THEN
                 in_wall := '1';
            end if;
            wall_on <= in_wall;
        end loop;
    END PROCESS;

    fooddraw : PROCESS (pixel_row, pixel_col, food_list) is
        VARIABLE not_eaten, food_x, food_y : INTEGER;
        VARIABLE in_food : std_logic := '0';
    BEGIN
        in_food := '0';
        FOR index IN food_list'RANGE LOOP
            not_eaten := food_list(index)(0);
            food_x := food_list(index)(1);
            food_y := food_list(index)(2);
            
            IF not_eaten = '1' AND (pixel_col >= food_x - food_size AND pixel_col <= food_x + food_size) AND 
                (pixel_row >= food_y - food_size AND pixel_row <= food_y + food_size) THEN
                is_in_food := '1';
            END IF;
            food_on <= in_food;
        END LOOP;
    END PROCESS;
END Behavioral;