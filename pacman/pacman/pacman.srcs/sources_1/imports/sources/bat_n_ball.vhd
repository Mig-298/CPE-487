LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;

ENTITY pacman IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN UNSIGNED(10 DOWNTO 0);
        pixel_col : IN UNSIGNED(10 DOWNTO 0);
        reset : IN STD_LOGIC; 
        pac_dir : IN STD_LOGIC;
        clk_in : IN STD_LOGIC;
        btn_left : IN STD_LOGIC;
        btn_right : IN STD_LOGIC;
        btn_up : IN STD_LOGIC;
        btn_down : IN STD_LOGIC;
        currscore : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END pacman;

ARCHITECTURE Behavioral OF pacman IS
    -- wall variables
<<<<<<< Updated upstream
=======
    TYPE direction_list is array (2 downto 0) of STD_LOGIC_VECTOR(1 downto 0);


>>>>>>> Stashed changes
    SIGNAL wall_int : integer := 10;
    TYPE cord is array(0 to 1) of INTEGER;
    TYPE wall_cord is array(0 to 1) of cord;
    TYPE wall_cord_list is array(0 to 20) of wall_cord;
    CONSTANT walls_to_draw : wall_cord_list := 
    (
    0  => ((  0,   60), (799,   60-wall_int)),   -- bottom
    1  => ((  0,  560), (799, 560-wall_int)),   -- top  
    2  => ((  0,  560), (0+wall_int,   60)),   -- left
    3  => ((799-wall_int,  560), (799,   60)),   -- right
    4  => ((60,  180), (200, 120)),   
    5  => ((260,  180), (290, 120)),   
    6  => ((350,  210), (420, 120)),   
    7  => ((670,  130), (720, 60)),   
    8  => ((550,  250), (600, 200)),  
    9  => ((510,  250), (600, 200)),  
    10 => ((60,  370), (90, 260)),   
    11 => ((60,  260), (170, 230)),   
    12 => ((220,  300), (250, 230)),   
    13 => ((520,  340), (600, 310)),   
    14 => ((670,  450), (720, 200)),   
    15 => ((720,  330), (799, 280)),
    16 => ((470,  490), (600, 400)),
    17 => ((350,  560), (400, 400)),
    18 => ((60,  500), (280, 420)),
    19 => ((150,  420), (200, 340)),
    20 => ((550, 200), (600, 120))
);
    
    TYPE food_coord is array(0 to 2) of INTEGER;
    TYPE food_coord_list is array(129 downto 0) of food_coord;
    CONSTANT FOOD_LIST_INIT : food_coord_list := (
<<<<<<< Updated upstream
    129 => (1, 715, 165),
    128 => (1, 675, 165),
    127 => (1, 755, 245),
    126 => (1, 755, 205),
    125 => (1, 755, 165),
    124 => (1, 755, 125),
    123 => (1, 755, 85),
    122 => (1, 755, 445),
    121 => (1, 755, 405),
    120 => (1, 755, 365),
    119 => (1, 715, 485),
    118 => (1, 675, 485),
    117 => (1, 755, 525),
    116 => (1, 715, 525),
    115 => (1, 675, 525),
    114 => (1, 635, 525),
    113 => (1, 595, 525),
    112 => (1, 555, 525),
    111 => (1, 515, 525),
    110 => (1, 475, 525),
    109 => (1, 435, 525),
    108 => (1, 435, 485),
    107 => (1, 435, 445),
    106 => (1, 435, 405),
    105 => (1, 475, 365),
    104 => (1, 515, 365),
    103 => (1, 555, 365),
    102 => (1, 595, 365),
    101 => (1, 355, 365),
    100 => (1, 395, 365),
    99  => (1, 435, 365),
    98  => (1, 475, 365),
    97  => (1, 475, 325),
    96  => (1, 475, 285),
    95  => (1, 435, 245),
    94  => (1, 395, 245),
    93  => (1, 355, 245),
    92  => (1, 315, 245),
    91  => (1, 315, 485),
    90  => (1, 315, 445),
    89  => (1, 315, 405),
    88  => (1, 315, 365),
    87  => (1, 275, 405),
    86  => (1, 275, 365),
    85  => (1, 275, 325),
    84  => (1, 275, 285),
    83  => (1, 275, 245),
    82  => (1, 235, 405),
    81  => (1, 235, 365),
    80  => (1, 235, 325),
    79  => (1, 315, 525),
    78  => (1, 275, 525),
    77  => (1, 235, 525),
    76  => (1, 195, 525),
    75  => (1, 155, 525),
    74  => (1, 115, 525),
    73  => (1, 75, 525),
    72  => (1, 115, 405),
    71  => (1, 75, 405),
    70  => (1, 115, 365),
    69  => (1, 195, 325),
    68  => (1, 155, 325),
    67  => (1, 115, 325),
    66  => (1, 195, 245),
    65  => (1, 315, 165),
    64  => (1, 315, 125),
    63  => (1, 235, 165),
    62  => (1, 235, 125),
    61  => (1, 315, 205),
    60  => (1, 275, 205),
    59  => (1, 235, 205),
    58  => (1, 195, 205),
    57  => (1, 155, 205),
    56  => (1, 115, 205),
    55  => (1, 75, 205),
    54  => (1, 35, 525),
    53  => (1, 35, 485),
    52  => (1, 35, 445),
    51  => (1, 35, 405),
    50  => (1, 35, 365),
    49  => (1, 35, 325),
    48  => (1, 35, 285),
    47  => (1, 35, 245),
    46  => (1, 35, 205),
    45  => (1, 35, 165),
    44  => (1, 35, 125),
    43  => (1, 635, 85),
    42  => (1, 595, 85),
    41  => (1, 555, 85),
    40  => (1, 515, 85),
    39  => (1, 475, 85),
    38  => (1, 435, 85),
    37  => (1, 395, 85),
    36  => (1, 355, 85),
    35  => (1, 315, 85),
    34  => (1, 275, 85),
    33  => (1, 235, 85),
    32  => (1, 195, 85),
    31  => (1, 155, 85),
    30  => (1, 115, 85),
    29  => (1, 75, 85),
    28  => (1, 35, 85),
    27  => (1, 475, 325),
    26  => (1, 435, 405),
    25  => (1, 355, 365),
    24  => (1, 595, 365),
    23  => (1, 475, 525),
    22  => (1, 635, 485),
    21  => (1, 475, 245),
    20  => (1, 315, 245),
    19  => (1, 315, 365),
    18  => (1, 315, 405),
    17  => (1, 315, 485),
    16  => (1, 275, 245),
    15  => (1, 275, 285),
    14  => (1, 275, 325),
    13  => (1, 275, 365),
    12  => (1, 275, 405),
    11  => (1, 235, 325),
    10  => (1, 235, 365),
    9   => (1, 235, 405),
    8   => (1, 75, 405),
    7   => (1, 115, 365),
    6   => (1, 115, 325),
    5   => (1, 155, 325),
    4   => (1, 195, 325),
    3   => (1, 195, 245),
    2   => (1, 315, 125),
    1   => (1, 315, 165),
    0   => (1, 315, 205)
);
=======
        147 => (1, 755, 485),
        146 => (1, 635, 125),
        145 => (1, 635, 165),
        144 => (1, 635, 285), 
        143 => (1, 635, 325), 
        142 => (1, 635, 365), 
        141 => (1, 635, 405), 
        140 => (1, 635, 445), 
        ---
        139 => (1, 515, 125),
        138 => (1, 515, 165),   
        137 => (1, 475, 125),
        136 => (1, 435, 125),   
        135 => (1, 475, 165),
        134 => (1, 435, 165),
        133 => (1, 475, 205),
        132 => (1, 435, 205),
        ---
        131 => (1, 195, 285),
        130 => (1, 115, 285),
        ----
        129 => (1, 715, 165),
        128 => (1, 675, 165),
        127 => (1, 755, 245),
        126 => (1, 755, 205),
        125 => (1, 755, 165),
        124 => (1, 755, 125),
        123 => (1, 755, 85),
        122 => (1, 755, 445),
        121 => (1, 755, 405),
        120 => (1, 755, 365),
        119 => (1, 715, 485),
        118 => (1, 675, 485),
        117 => (1, 755, 525),
        116 => (1, 715, 525),
        115 => (1, 675, 525),
        114 => (1, 635, 525),
        113 => (1, 595, 525),
        112 => (1, 555, 525),
        111 => (1, 515, 525),
        110 => (1, 475, 525),
        109 => (1, 435, 525),
        108 => (1, 435, 485),
        107 => (1, 435, 445),
        106 => (1, 435, 405),
        105 => (1, 475, 365),
        104 => (1, 515, 365),
        103 => (1, 555, 365),
        102 => (1, 595, 365),
        101 => (1, 355, 365),
        100 => (1, 395, 365),
        99  => (1, 435, 365),
        98  => (1, 475, 365),
        97  => (1, 475, 325),
        96  => (1, 475, 285),
        95  => (1, 435, 245),
        94  => (1, 395, 245),
        93  => (1, 355, 245),
        92  => (1, 315, 245),
        91  => (1, 315, 485),
        90  => (1, 315, 445),
        89  => (1, 315, 405),
        88  => (1, 315, 365),
        87  => (1, 275, 405),
        86  => (1, 275, 365),
        85  => (1, 275, 325),
        84  => (1, 275, 285),
        83  => (1, 275, 245),
        82  => (1, 235, 405),
        81  => (1, 235, 365),
        80  => (1, 235, 325),
        79  => (1, 315, 525),
        78  => (1, 275, 525),
        77  => (1, 235, 525),
        76  => (1, 195, 525),
        75  => (1, 155, 525),
        74  => (1, 115, 525),
        73  => (1, 75, 525),
        72  => (1, 115, 405),
        71  => (1, 75, 405),
        70  => (1, 115, 365),
        69  => (1, 195, 325),
        68  => (1, 155, 325),
        67  => (1, 115, 325),
        66  => (1, 195, 245),
        65  => (1, 315, 165),
        64  => (1, 315, 125),
        63  => (1, 235, 165),
        62  => (1, 235, 125),
        61  => (1, 315, 205),
        60  => (1, 275, 205),
        59  => (1, 235, 205),
        58  => (1, 195, 205),
        57  => (1, 155, 205),
        56  => (1, 115, 205),
        55  => (1, 75, 205),
        54  => (1, 35, 525),
        53  => (1, 35, 485),
        52  => (1, 35, 445),
        51  => (1, 35, 405),
        50  => (1, 35, 365),
        49  => (1, 35, 325),
        48  => (1, 35, 285),
        47  => (1, 35, 245),
        46  => (1, 35, 205),
        45  => (1, 35, 165),
        44  => (1, 35, 125),
        43  => (1, 635, 85),
        42  => (1, 595, 85),
        41  => (1, 555, 85),
        40  => (1, 515, 85),
        39  => (1, 475, 85),
        38  => (1, 435, 85),
        37  => (1, 395, 85),
        36  => (1, 355, 85),
        35  => (1, 315, 85),
        34  => (1, 275, 85),
        33  => (1, 235, 85),
        32  => (1, 195, 85),
        31  => (1, 155, 85),
        30  => (1, 115, 85),
        29  => (1, 75, 85),
        28  => (1, 35, 85),
        27  => (1, 475, 325),
        26  => (1, 435, 405),
        25  => (1, 355, 365),
        24  => (1, 595, 365),
        23  => (1, 475, 525),
        22  => (1, 635, 485),
        21  => (1, 475, 245),
        20  => (1, 315, 245),
        19  => (1, 315, 365),
        18  => (1, 315, 405),
        17  => (1, 315, 485),
        16  => (1, 275, 245),
        15  => (1, 275, 285),
        14  => (1, 275, 325),
        13  => (1, 275, 365),
        12  => (1, 275, 405),
        11  => (1, 235, 325),
        10  => (1, 235, 365),
        9   => (1, 235, 405),
        8   => (1, 75, 405),
        7   => (1, 115, 365),
        6   => (1, 115, 325),
        5   => (1, 155, 325),
        4   => (1, 195, 325),
        3   => (1, 195, 245),
        2   => (1, 315, 125),
        1   => (1, 315, 165),
        0   => (1, 315, 205)
    );
>>>>>>> Stashed changes
    SIGNAL FOOD_LIST : food_coord_list := FOOD_LIST_INIT;
    
    CONSTANT pac_size : INTEGER := 15; 
    CONSTANT ghost_size : INTEGER := 10; 
    CONSTANT food_size : INTEGER := 5;
    
    CONSTANT STARTING_GHOST_X : UNSIGNED(10 downto 0) := to_unsigned(315, 11); 
    CONSTANT STARTING_GHOST_Y : UNSIGNED(10 downto 0) := to_unsigned(365, 11);
    SIGNAL ghost1_x : UNSIGNED(10 downto 0) := STARTING_GHOST_X;
    SIGNAL ghost1_y : UNSIGNED(10 downto 0) := STARTING_GHOST_Y;
    
    
    CONSTANT STARTING_PAC_X : UNSIGNED(10 downto 0) := to_unsigned(350, 11);
    CONSTANT STARTING_PAC_Y : UNSIGNED(10 downto 0) := to_unsigned(285, 11);
    SIGNAL pac_x : UNSIGNED(10 downto 0) := STARTING_PAC_X; 
    SIGNAL pac_y : UNSIGNED(10 downto 0) := STARTING_PAC_Y; 
     CONSTANT MOVE_SPEED : INTEGER := 1;

    SIGNAL curr_alive : STD_LOGIC := '1';
    SIGNAL curr_score : INTEGER := 0;

    SIGNAL wall_on : STD_LOGIC; 
    SIGNAL pac_on : STD_LOGIC; 
    SIGNAL food_on : STD_LOGIC;
    SIGNAL color_on : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL ghost1_on : STD_LOGIC;
    SIGNAL game_on : STD_LOGIC := '0';
    
    signal movecount  : UNSIGNED(19 DOWNTO 0) := (OTHERS => '0'); -- adjust width
    signal tickspeed : std_logic := '0';

    
    TYPE color_array_t      IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(2 DOWNTO 0);
    CONSTANT COLORS : color_array_t := (
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
    
    TYPE ghost_color_array_t IS ARRAY (0 TO 1) OF INTEGER;
    CONSTANT GHOST_COLORS : ghost_color_array_t := (4, 5); -- green, blue, magenta
    SIGNAL lfsr       : UNSIGNED(7 DOWNTO 0) := x"5A";  -- non-zero seed
    SIGNAL ghost_dir : STD_LOGIC_VECTOR(1 downto 0) := "01";
    SIGNAL ghost_cnt  : UNSIGNED(19 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ghost_tick : STD_LOGIC := '0';

BEGIN
    red <=  color_on(2);
    green <= color_on(1);
    blue <=  color_on(0);
    currscore <= std_logic_vector(to_unsigned(curr_score, 16));
    
    select_color: PROCESS(curr_alive, ghost1_on, wall_on, pac_on, food_on) IS
    BEGIN
        IF curr_alive = '0' then
            color_on <= "000";
        ELSIF wall_on = '1' THEN
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

    pacdraw: PROCESS(pac_x, pac_y, pixel_row, pixel_col, pac_dir) IS
        VARIABLE vx, vy : UNSIGNED(10 DOWNTO 0);
        constant PAC_R2 : unsigned(10 downto 0) := to_unsigned(pac_size * pac_size, 11);
        VARIABLE xd, yd : STD_LOGIC; --whether pixel_col/row is to the right/above pacx/y
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
        IF ((vx * vx) + (vy * vy) < PAC_R2) THEN -- test if radial distance < bsize
            pac_on <= '1';
        ELSE
            pac_on <= '0';
        END IF;
    END PROCESS;
    
    die: PROCESS(clk_in) IS
        VARIABLE pac_min_x, pac_max_x : INTEGER;
        VARIABLE pac_min_y, pac_max_y : INTEGER;
        VARIABLE gh_min_x,  gh_max_x  : INTEGER;
        VARIABLE gh_min_y,  gh_max_y  : INTEGER;
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                curr_alive <= '1';
            ELSE
                -- build Pac-Man box around center
                pac_min_x := TO_INTEGER(pac_x) - pac_size;
                pac_max_x := TO_INTEGER(pac_x) + pac_size;
                pac_min_y := TO_INTEGER(pac_y) - pac_size;
                pac_max_y := TO_INTEGER(pac_y) + pac_size;

                -- build ghost box around center (w = 2*ghost_size, h = 4*ghost_size)
                gh_min_x  := TO_INTEGER(ghost1_x) - ghost_size;
                gh_max_x  := TO_INTEGER(ghost1_x) + ghost_size;
                gh_min_y  := TO_INTEGER(ghost1_y) - 2*ghost_size;
                gh_max_y  := TO_INTEGER(ghost1_y) + 2*ghost_size;

                -- AABB overlap: collide if boxes intersectf
                IF (pac_min_x <= gh_max_x) AND
                    (pac_max_x >= gh_min_x) AND
                    (pac_min_y <= gh_max_y) AND
                    (pac_max_y >= gh_min_y) THEN
                        curr_alive <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    rst: PROCESS(curr_score, pac_on, food_on, food_list, pac_x, pac_y, reset) IS
        VARIABLE food_x, food_y : INTEGER;
    BEGIN
        IF reset = '1' THEN
            curr_score <= 0;
            FOOD_LIST <= FOOD_LIST_INIT;
            game_on <= '1';
        else
        IF pac_on = '1' AND food_on = '1' THEN
            FOR index IN food_list'RANGE LOOP
                food_x := food_list(index)(1);
                food_y := food_list(index)(2);
                IF (pac_x >= food_x - food_size AND pac_x <= food_x + food_size) AND
                    (pac_y >= food_y - food_size AND pac_y <= food_y + food_size) THEN
                        food_list(index)(0) <= 0; -- mark as eaten
                        curr_score <= curr_score + 1;
                END IF;
            END LOOP;
        END IF;
        END IF;
    END PROCESS;
    
    movehelper : PROCESS(clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                movecount  <= (OTHERS => '0');
                tickspeed <= '0';
            ELSE
                if movecount = TO_UNSIGNED(150000-1, movecount'length) THEN  -- tune this value
                    movecount  <= (OTHERS => '0');
                    tickspeed <= '1';   -- one-cycle pulse
                ELSE
                    movecount  <= movecount + 1;
                    tickspeed <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
   move_pac: process(clk_in) is 
    variable new_pac_x    : unsigned(10 downto 0);
    variable new_pac_y    : unsigned(10 downto 0);
    variable wall_collide : std_logic;
    variable starting_cord : cord; 
    variable ending_cord   : cord; 
   BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                pac_x <= STARTING_PAC_X;
                pac_y <= STARTING_PAC_Y;
            ELSIF tickspeed = '1' AND curr_alive = '1' THEN        -- only move on slow tick
                new_pac_x := pac_x;
                new_pac_y := pac_y;

                IF btn_left = '1' THEN 
                    new_pac_x := pac_x - to_unsigned(MOVE_SPEED, pac_x'length);
                ELSIF btn_right = '1' THEN
                    new_pac_x := pac_x + to_unsigned(MOVE_SPEED, pac_x'length);
                ELSIF btn_up = '1' THEN
                    new_pac_y := pac_y - to_unsigned(MOVE_SPEED, pac_y'length);
                ELSIF btn_down = '1' THEN
                    new_pac_y := pac_y + to_unsigned(MOVE_SPEED, pac_y'length);
                END IF;

                wall_collide := '0';
                FOR index in walls_to_draw'RANGE LOOP
                    starting_cord := walls_to_draw(index)(0);
                    ending_cord   := walls_to_draw(index)(1); 
                    IF(new_pac_x  >= to_unsigned(starting_cord(0), new_pac_x'length) AND
                        new_pac_x <= to_unsigned(ending_cord(0),   new_pac_x'length) AND 
                        new_pac_y >= to_unsigned(ending_cord(1),   new_pac_y'length) AND
                        new_pac_y <= to_unsigned(starting_cord(1), new_pac_y'length) ) THEN
                        wall_collide := '1';
                        EXIT;
                    END IF;
                END LOOP;
                IF wall_collide = '0' THEN
                    pac_x <= new_pac_x;
                    pac_y <= new_pac_y;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    walldraw : PROCESS (pixel_row, pixel_col) is
        VARIABLE starting_cord : cord; 
        VARIABLE ending_cord : cord;
        VARIABLE in_wall : std_logic := '0';
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

    fooddraw : PROCESS (pixel_row, pixel_col, food_list) IS
        VARIABLE in_food : std_logic := '0';
        VARIABLE food_x, food_y, not_eaten : INTEGER;
    BEGIN
        in_food := '0';
        FOR index IN food_list'RANGE LOOP
            not_eaten := food_list(index)(0);  -- integer 0/1
            food_x := food_list(index)(1);
            food_y := food_list(index)(2);
            
            IF not_eaten = 1 AND
            (pixel_col >= food_x - food_size AND pixel_col <= food_x + food_size) AND 
            (pixel_row >= food_y - food_size AND pixel_row <= food_y + food_size) THEN
                in_food := '1';  -- mark that this pixel is on a food
            END IF;
        END LOOP;
        food_on <= in_food; 
    END PROCESS;
    
    ghost1draw : PROCESS(pixel_row, pixel_col, ghost1_x, ghost1_y) IS
        VARIABLE gx_left, gx_right  : UNSIGNED(10 DOWNTO 0);
        VARIABLE gy_top,  gy_bottom : UNSIGNED(10 DOWNTO 0);
        VARIABLE in_body  : STD_LOGIC;
        VARIABLE in_head  : STD_LOGIC;
        VARIABLE in_feet  : STD_LOGIC;
        VARIABLE dx, dy   : UNSIGNED(10 DOWNTO 0);
        VARIABLE head_cy  : UNSIGNED(10 DOWNTO 0);
        VARIABLE dx2, dy2, r2 : UNSIGNED(21 DOWNTO 0);
        CONSTANT GSIZE_U  : UNSIGNED(10 DOWNTO 0) := TO_UNSIGNED(ghost_size, 11);
        CONSTANT G2SIZE_U : UNSIGNED(10 DOWNTO 0) := TO_UNSIGNED(2*ghost_size, 11);
    BEGIN
        -- bounding box around ghost center
        gx_left  := ghost1_x - GSIZE_U;
        gx_right := ghost1_x + GSIZE_U;
        gy_top   := ghost1_y - G2SIZE_U;
        gy_bottom:= ghost1_y + G2SIZE_U;

        -- default off
        ghost1_on <= '0';
        in_body   := '0';
        in_head   := '0';
        in_feet   := '0';

        -- only draw if inside bbox
        IF (pixel_col >= gx_left) AND (pixel_col <= gx_right) AND
           (pixel_row >= gy_top)  AND (pixel_row <= gy_bottom) THEN

        ----------------------------------------------------------------
        -- Body: middle rectangle
        ----------------------------------------------------------------
            IF (pixel_row >= ghost1_y - GSIZE_U) AND
               (pixel_row <= ghost1_y + GSIZE_U) THEN
                    in_body := '1';
            END IF;

        ----------------------------------------------------------------
        -- Head: top half-circle of radius ghost_size
        -- head center Y = gy_top + ghost_size
        ----------------------------------------------------------------
            head_cy := gy_top + GSIZE_U;

        -- dx = |pixel_col - ghost1_x|
            IF pixel_col <= ghost1_x THEN
                dx := ghost1_x - pixel_col;
            ELSE
                dx := pixel_col - ghost1_x;
            END IF;

        -- dy = |pixel_row - head_cy|
            IF pixel_row <= head_cy THEN
                dy := head_cy - pixel_row;
            ELSE
                dy := pixel_row - head_cy;
            END IF;

            dx2 := RESIZE(dx * dx, dx2'LENGTH);
            dy2 := RESIZE(dy * dy, dy2'LENGTH);
            r2  := TO_UNSIGNED(ghost_size * ghost_size, r2'LENGTH);

            IF (dx2 + dy2) <= r2 THEN
                in_head := '1';
            END IF;

        ----------------------------------------------------------------
        -- Feet: three rounded bumps along bottom
        ----------------------------------------------------------------
            in_feet := '0';

        -- feet vertical band: just below body, e.g. 0.5*ghost_size tall
            IF (pixel_row >= ghost1_y + GSIZE_U) AND
               (pixel_row <= ghost1_y + GSIZE_U + (GSIZE_U / 2)) THEN

            -- normalize X around center: left/mid/right thirds
            -- left foot: from center - ghost_size to center - ghost_size/3
                IF (pixel_col >= ghost1_x - GSIZE_U) AND
                   (pixel_col <= ghost1_x - (GSIZE_U / 3)) THEN
                    in_feet := '1';
                END IF;

            -- middle foot: from center - ghost_size/3 to center + ghost_size/3
                IF (pixel_col >= ghost1_x - (GSIZE_U / 3)) AND
                   (pixel_col <= ghost1_x + (GSIZE_U / 3)) THEN
                        in_feet := '1';
                END IF;

            -- right foot: from center + ghost_size/3 to center + ghost_size
                IF (pixel_col >= ghost1_x + (GSIZE_U / 3)) AND
                    (pixel_col <= ghost1_x + GSIZE_U) THEN
                        in_feet := '1';
                    END IF;
               END IF;

        ----------------------------------------------------------------
        -- Final combine
        ----------------------------------------------------------------
                IF (in_head = '1') OR (in_body = '1') OR (in_feet = '1') THEN
                    ghost1_on <= '1';
                ELSE
                    ghost1_on <= '0';
                END IF;
            END IF;
    END PROCESS;

    ghost_timer : PROCESS(clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                ghost_cnt  <= (OTHERS => '0');
                ghost_tick <= '0';
                lfsr       <= x"5A";
            ELSE
                -- slow ghost step rate; tune value for speed
                IF ghost_cnt = TO_UNSIGNED(150000-1, ghost_cnt'LENGTH) THEN
                    ghost_cnt  <= (OTHERS => '0');
                    ghost_tick <= '1';

                    -- 8-bit maximal LFSR taps (example: x^8 + x^6 + x^5 + x^4 + 1)
                    lfsr <= lfsr(6 DOWNTO 0) & (lfsr(7) XOR lfsr(5) XOR lfsr(4) XOR lfsr(3));
                ELSE
                    ghost_cnt  <= ghost_cnt + 1;
                    ghost_tick <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    ghost_move : PROCESS(clk_in)
        VARIABLE new_gx   : UNSIGNED(10 DOWNTO 0);
        VARIABLE new_gy   : UNSIGNED(10 DOWNTO 0);
        VARIABLE blocked  : STD_LOGIC;
        VARIABLE wc_start : cord;
        VARIABLE wc_end   : cord;
        VARIABLE g_min_x, g_max_x : UNSIGNED(10 DOWNTO 0);
        VARIABLE g_min_y, g_max_y : UNSIGNED(10 DOWNTO 0);
    BEGIN
        -- dir encoding:
        -- "00" = up, "01" = right, "11" = down, "10" = left
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                ghost1_x  <= STARTING_GHOST_X;
                ghost1_y  <= STARTING_GHOST_Y;
                ghost_dir <= "01";  -- start moving right
            ELSIF ghost_tick = '1' THEN
                -- start from current center
                new_gx := ghost1_x;
                new_gy := ghost1_y;

                -- propose move by direction
                IF ghost_dir = "00" THEN       -- UP
                    new_gy := ghost1_y - TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
                ELSIF ghost_dir = "01" THEN    -- RIGHT
                    new_gx := ghost1_x + TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
                ELSIF ghost_dir = "11" THEN    -- DOWN
                    new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
                ELSE                           -- "10" = LEFT
                    new_gx := ghost1_x - TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
                END IF;

                -- build ghost AABB from new center:
                -- width = 2*ghost_size, height = 4*ghost_size (matching your draw)
                g_min_x := new_gx - TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
                g_max_x := new_gx + TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
                g_min_y := new_gy - TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);
                g_max_y := new_gy + TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);

                -- first collision check
                blocked := '0';
                FOR i IN walls_to_draw'RANGE LOOP
                    wc_start := walls_to_draw(i)(0); -- (minX, maxY)
                    wc_end   := walls_to_draw(i)(1); -- (maxX, minY)

                    IF ( g_max_x >= TO_UNSIGNED(wc_start(0), g_max_x'LENGTH) AND
                         g_min_x <= TO_UNSIGNED(wc_end(0),   g_min_x'LENGTH) AND
                         g_max_y >= TO_UNSIGNED(wc_end(1),   g_max_y'LENGTH) AND
                         g_min_y <= TO_UNSIGNED(wc_start(1), g_min_y'LENGTH) ) THEN
                        blocked := '1';
                        EXIT;
                    END IF;
                END LOOP;

                IF blocked = '0' THEN
                    -- move in current direction
                    ghost1_x <= new_gx;
                    ghost1_y <= new_gy;
                ELSE
<<<<<<< Updated upstream
                    -- bounce: rotate direction (up→right→down→left→up)
                    IF ghost_dir = "00" THEN       -- was going up
                        ghost_dir <= "01";         -- try right
                    ELSIF ghost_dir = "01" THEN    -- was going right
                        ghost_dir <= "11";         -- try down
                    ELSIF ghost_dir = "11" THEN    -- was going down
                        ghost_dir <= "10";         -- try left
                    ELSE                           -- was going left ("10")
                        ghost_dir <= "00";         -- try up
                    END IF;
=======
                    count = count + 1; 
                    -- pick new somewhat-random direction
                    if i = -1 then  -- first time running into a blocked wall 
                        if ghost_dir = "00" or ghost_dir = "11" then -- try horizontal movement first 
                            if count mod 3 = 0 then 
                                dir_choice_list := ("01", "10", not ghost_dir); -- try right first
                            else
                                dir_choice_list :=  "01"("10", not ghost_dir); -- try left first 
                            end if;
                        else
                            if count mod 3 = 0 then 
                                dir_choice_list := ("00", "11", not ghost_dir); -- try up first
                            else
                                dir_choice_list := ("11", "00", not ghost_dir); -- try down first 
                        end if;
                    elsif i>3 then 
                        i=-1;
                    end if;
>>>>>>> Stashed changes

                    -- recompute candidate move in new direction from current center
                    new_gx := ghost1_x;
                    new_gy := ghost1_y;

                    IF ghost_dir = "00" THEN       -- UP
                        new_gy := ghost1_y - TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
                    ELSIF ghost_dir = "01" THEN    -- RIGHT
                        new_gx := ghost1_x + TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
                    ELSIF ghost_dir = "11" THEN    -- DOWN
                        new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
                    ELSE                           -- LEFT
                        new_gx := ghost1_x - TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
                    END IF;

                    -- ghost AABB for bounce attempt
                    g_min_x := new_gx - TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
                    g_max_x := new_gx + TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
                    g_min_y := new_gy - TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);
                    g_max_y := new_gy + TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);

                    blocked := '0';
                    FOR i IN walls_to_draw'RANGE LOOP
                        wc_start := walls_to_draw(i)(0);
                        wc_end   := walls_to_draw(i)(1);

                        IF ( g_max_x >= TO_UNSIGNED(wc_start(0), g_max_x'LENGTH) AND
                             g_min_x <= TO_UNSIGNED(wc_end(0),   g_min_x'LENGTH) AND
                             g_max_y >= TO_UNSIGNED(wc_end(1),   g_max_y'LENGTH) AND
                             g_min_y <= TO_UNSIGNED(wc_start(1), g_min_y'LENGTH) ) THEN
                            blocked := '1';
                            EXIT;
                        END IF;
                    END LOOP;

                    IF blocked = '0' THEN
                        ghost1_x <= new_gx;
                        ghost1_y <= new_gy;
                    END IF;  -- else stay put this tick
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;