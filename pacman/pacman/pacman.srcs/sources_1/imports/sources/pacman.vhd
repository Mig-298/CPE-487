LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.math_real.all;
USE IEEE.numeric_std.all;

ENTITY pacman IS
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
        alive_out : OUT STD_LOGIC  
    );
END pacman;

ARCHITECTURE Behavioral OF pacman IS
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    -- wall variables
=======
    -- Wall Coordinates
>>>>>>> Stashed changes
=======
    -- Wall Coordinates
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    SIGNAL wall_int : integer := 10;
    TYPE cord is array(0 to 1) of INTEGER;
    TYPE wall_cord is array(0 to 1) of cord;
    TYPE wall_cord_list is array(0 to 20) of wall_cord;
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    CONSTANT walls_to_draw : wall_cord_list := 
    (
    0  => ((  0,   60), (799,   60-wall_int)),   -- bottom
    1  => ((  0,  540), (799, 540-wall_int)),   -- top  
    2  => ((  0,  560), (0+wall_int,   60)),   -- left
    3  => ((799-wall_int,  560), (799,   60)),   -- right
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    CONSTANT walls_to_draw : wall_cord_list := ( -- Input two different points and it will fill in between the points.
    -- Border Walls
    0  => ((0, 60), (799, 60-wall_int)),   -- bottom wall
    1  => ((0, 560), (799, 560-wall_int)),   -- top wall
    2  => ((0, 560), (0+wall_int, 60)),   -- left wall
    3  => ((799-wall_int,  560), (799, 60)),   -- right wall
    -- Center maze area
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
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
    17 => ((350,  540), (400, 400)),
    18 => ((60,  500), (280, 420)),
    19 => ((150,  420), (200, 340)),
    20 => ((550, 200), (600, 120))
);
    
    TYPE food_coord is array(0 to 2) of INTEGER;
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    TYPE food_coord_list is array(129 downto 0) of food_coord;
    CONSTANT FOOD_LIST_INIT : food_coord_list := (
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
    signal FOOD_LIST : food_coord_list := FOOD_LIST_INIT;
    
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    TYPE food_coord_list is array(147 downto 0) of food_coord;
    CONSTANT FOOD_LIST_INIT : food_coord_list := ( -- Find a coordinate point and it will draw a box around it.
        147 => (1, 755, 485),
        146 => (1, 635, 125),
        145 => (1, 635, 165),
        144 => (1, 635, 285), 
        143 => (1, 635, 325), 
        142 => (1, 635, 365), 
        141 => (1, 635, 405), 
        140 => (1, 635, 445), 
        --
        139 => (1, 515, 125),
        138 => (1, 515, 165),   
        137 => (1, 475, 125),
        136 => (1, 435, 125),   
        135 => (1, 475, 165),
        134 => (1, 435, 165),
        133 => (1, 475, 205),
        132 => (1, 435, 205),
        --
        131 => (1, 195, 285),
        130 => (1, 115, 285),
        ---
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
    SIGNAL FOOD_LIST : food_coord_list := FOOD_LIST_INIT;
    
    -- Sizing Variables
>>>>>>> Stashed changes
    CONSTANT pac_size : INTEGER := 15; 
    CONSTANT ghost_size : INTEGER := 10; 
    CONSTANT food_size : INTEGER := 5;
    
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    -- Movement variables / Ghost helpers
    type rand_direction_list is array (0 to 19) of std_logic_vector(1 downto 0);  -- Change the director list to change the movement of the ghost.
    CONSTANT directions : rand_direction_list := ( -- 00 UP, 01 RIGHT, 11 DOWN, 10 LEFT
    "01", "11", "01", "10", "00",
    "01", "00", "01", "10", "11",
    "01", "00", "01", "11", "00",
    "10", "11", "01", "00", "10"
    );
    SIGNAL ghost_dir : STD_LOGIC_VECTOR(1 downto 0) := "01";
    SIGNAL ghost_cnt  : UNSIGNED(19 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ghost_tick : STD_LOGIC := '0';
    
    -- Position Starting Values
>>>>>>> Stashed changes
    CONSTANT STARTING_GHOST_X : UNSIGNED(10 downto 0) := to_unsigned(315, 11); 
    CONSTANT STARTING_GHOST_Y : UNSIGNED(10 downto 0) := to_unsigned(365, 11);
    SIGNAL ghost1_x : UNSIGNED(10 downto 0) := STARTING_GHOST_X;
    SIGNAL ghost1_y : UNSIGNED(10 downto 0) := STARTING_GHOST_Y;
    
    
    CONSTANT STARTING_PAC_X : UNSIGNED(10 downto 0) := to_unsigned(350, 11);
    CONSTANT STARTING_PAC_Y : UNSIGNED(10 downto 0) := to_unsigned(285, 11);
    SIGNAL pac_x : UNSIGNED(10 downto 0) := STARTING_PAC_X; 
    SIGNAL pac_y : UNSIGNED(10 downto 0) := STARTING_PAC_Y; 
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
     CONSTANT MOVE_SPEED : INTEGER := 1;
=======
    CONSTANT MOVE_SPEED : INTEGER := 1; -- Change movespeed of the pacman.
>>>>>>> Stashed changes
=======
    CONSTANT MOVE_SPEED : INTEGER := 1; -- Change movespeed of the pacman.
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd

    SIGNAL curr_score : INTEGER := 0;
    SIGNAL curr_alive : STD_LOGIC := '1';

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
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    SIGNAL lfsr       : UNSIGNED(7 DOWNTO 0) := x"5A";  -- non-zero seed
    SIGNAL ghost_dir : STD_LOGIC_VECTOR(1 downto 0) := "01";
    SIGNAL ghost_cnt  : UNSIGNED(19 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ghost_tick : STD_LOGIC := '0';
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd

BEGIN
    red <=  color_on(2);
    green <= color_on(1);
    blue <=  color_on(0);
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    score_out <= curr_score;
    alive_out <= curr_alive;
    
    select_color: PROCESS(ghost1_on, wall_on, pac_on, food_on) IS
=======
    
    select_color: PROCESS(curr_alive, ghost1_on, wall_on, pac_on, food_on) IS -- Change the color itself of each game component
>>>>>>> Stashed changes
=======
    
    select_color: PROCESS(curr_alive, ghost1_on, wall_on, pac_on, food_on) IS -- Change the color itself of each game component
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
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
    
    bcd_convert: PROCESS(clk_in)
        VARIABLE temp : INTEGER;
    BEGIN
        IF rising_edge(clk_in) THEN
            temp := curr_score;
        
            IF temp > 9999 THEN
                temp := 9999;
            END IF;
        
            currscore(3 DOWNTO 0)   <= STD_LOGIC_VECTOR(TO_UNSIGNED(temp MOD 10, 4));
            currscore(7 DOWNTO 4)   <= STD_LOGIC_VECTOR(TO_UNSIGNED((temp/10) MOD 10, 4));
            currscore(11 DOWNTO 8)  <= STD_LOGIC_VECTOR(TO_UNSIGNED((temp/100) MOD 10, 4));
            currscore(15 DOWNTO 12) <= STD_LOGIC_VECTOR(TO_UNSIGNED((temp/1000) MOD 10, 4));
        END IF;
    END PROCESS;

<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    pacdraw: PROCESS(pac_x, pac_y, pixel_row, pixel_col, pac_dir) IS 
        VARIABLE vx, vy : UNSIGNED(10 DOWNTO 0);
        constant PAC_R2 : unsigned(10 downto 0) := to_unsigned(pac_size * pac_size, 11);
        VARIABLE xd, yd : STD_LOGIC;  --whether pixel_col/row is to the right/above pacx/y
        CONSTANT pi : REAL := 3.14159;
        CONSTANT tan0 : REAL := 1.73205; -- tan(2pi/6)
        CONSTANT tan1 : REAL := 0.57735; -- tan(pi/6)
=======
    pacdraw: PROCESS(pac_x, pac_y, pixel_row, pixel_col) IS -- Draw the pacman on screen.
        VARIABLE vx, vy : UNSIGNED(10 DOWNTO 0);
        constant PAC_R2 : unsigned(10 downto 0) := to_unsigned(pac_size * pac_size, 11);
        VARIABLE xd, yd : STD_LOGIC; --whether pixel_col/row is to the right/above pacx/y
>>>>>>> Stashed changes
=======
    pacdraw: PROCESS(pac_x, pac_y, pixel_row, pixel_col) IS -- Draw the pacman on screen.
        VARIABLE vx, vy : UNSIGNED(10 DOWNTO 0);
        constant PAC_R2 : unsigned(10 downto 0) := to_unsigned(pac_size * pac_size, 11);
        VARIABLE xd, yd : STD_LOGIC; --whether pixel_col/row is to the right/above pacx/y
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
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
    
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    die: PROCESS(pac_on, ghost1_on, curr_score) IS 
    BEGIN
        IF pac_on = '1' AND ghost1_on = '1' THEN
            curr_alive <= '0';
        END IF;
    END PROCESS;
    
    rst: PROCESS(pac_on, food_on, food_list, pac_x, pac_y, reset) IS 
        VARIABLE food_x, food_y : INTEGER;
    BEGIN 
        IF reset = '1' THEN
            curr_score <= 0;
            curr_alive <= '1';
            -- reset food 
            FOOD_LIST <= FOOD_LIST_INIT;
            game_on <= '1';
        ELSE
            IF food_on = '1' THEN
                FOR index IN food_list'RANGE LOOP
                    food_x := food_list(index)(1);
                    food_y := food_list(index)(2);
                    IF ((pac_x + pac_size) >= (food_x - food_size)) AND ((pac_x + pac_size) <= (food_x + food_size)) AND 
                       ((pac_y + pac_size) >= (food_y - food_size)) AND ((pac_y <= food_y) <= (pac_size + food_size)) THEN
                            food_list(index)(0) <= 0; -- mark as eaten 
                    END IF;
                END LOOP;
            END IF;        
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    die: PROCESS(clk_in) IS -- Actual function that makes the player "die" to the ghost.
        VARIABLE pac_min_x, pac_max_x : INTEGER;
        VARIABLE pac_min_y, pac_max_y : INTEGER;
        VARIABLE gh_min_x,  gh_max_x  : INTEGER;
        VARIABLE gh_min_y,  gh_max_y  : INTEGER;
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                curr_alive <= '1';
            ELSE
                -- Pacman hitbox
                pac_min_x := TO_INTEGER(pac_x) - pac_size;
                pac_max_x := TO_INTEGER(pac_x) + pac_size;
                pac_min_y := TO_INTEGER(pac_y) - pac_size;
                pac_max_y := TO_INTEGER(pac_y) + pac_size;

                -- Ghost hitbox 
                gh_min_x  := TO_INTEGER(ghost1_x) - ghost_size;
                gh_max_x  := TO_INTEGER(ghost1_x) + ghost_size;
                gh_min_y  := TO_INTEGER(ghost1_y) - 2*ghost_size;
                gh_max_y  := TO_INTEGER(ghost1_y) + 2*ghost_size;

                -- Actual death script
                IF (pac_min_x <= gh_max_x) AND
                    (pac_max_x >= gh_min_x) AND
                    (pac_min_y <= gh_max_y) AND
                    (pac_max_y >= gh_min_y) THEN
                        curr_alive <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    -- Function to eat food and reset the food on the screen using the middle button (BTNC)
    eatfood: PROCESS(curr_score, pac_on, food_on, food_list, pac_x, pac_y, reset) IS
        VARIABLE food_min_x, food_max_y, food_max_x ,food_min_y : INTEGER;
        VARIABLE pac_min_x, pac_max_x, pac_min_y ,pac_max_y : INTEGER;
        VARIABLE not_eaten : INTEGER;
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN -- Resets the food to go back to the initial position which is listed at the top of the variables.
                curr_score <= 0;
                FOOD_LIST <= FOOD_LIST_INIT;
                game_on <= '1';
            else
                IF pac_on = '1' AND food_on = '1' THEN
                    FOR index IN food_list'RANGE LOOP
                        not_eaten := food_list(index)(0);
                
                        food_min_x := food_list(index)(1)-food_size;
                        food_max_x := food_list(index)(1)+food_size;
                        food_min_y := food_list(index)(2)-food_size;
                        food_max_y := food_list(index)(2)+food_size;
                
                        pac_min_x := TO_INTEGER(pac_x) - pac_size;
                        pac_max_x := TO_INTEGER(pac_x) + pac_size;
                        pac_min_y := TO_INTEGER(pac_y) - pac_size;
                        pac_max_y := TO_INTEGER(pac_y) + pac_size;
                
                        IF not_eaten = 1 AND (pac_min_x <= food_max_x AND pac_max_x >= food_min_x) AND
                                             (pac_max_y >= food_min_y AND pac_min_y <= food_max_y) THEN
                                food_list(index)(0) <= 0; -- mark as eaten
                                curr_score <= curr_score + 1;
                        END IF;
                    END LOOP;
                END IF;
            END IF;
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
        END IF;
    END PROCESS;
    
    -- Clock management to prevent pacman from not moving smoothly.
    -- Without this function, pacman essential teleports aroudn the screen due to the pixels not updating fast enough.
    movehelper : PROCESS(clk_in)
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                movecount  <= (OTHERS => '0');
                tickspeed <= '0';
            ELSE
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
                if movecount = TO_UNSIGNED(120000-1, movecount'length) THEN  -- tune this value
=======
                if movecount = TO_UNSIGNED(150000-1, movecount'length) THEN  -- tune this value. Higher the number the slower he moves, lower it is the faster he moves.
>>>>>>> Stashed changes
=======
                if movecount = TO_UNSIGNED(150000-1, movecount'length) THEN  -- tune this value. Higher the number the slower he moves, lower it is the faster he moves.
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                    movecount  <= (OTHERS => '0');
                    tickspeed <= '1';  
                ELSE
                    movecount  <= movecount + 1;
                    tickspeed <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
   move_pac: process(clk_in) is 
    variable new_pac_x    : unsigned(10 downto 0);
    variable new_pac_y    : unsigned(10 downto 0);
    variable wall_collide : std_logic;
    variable starting_cord : cord; 
    variable ending_cord   : cord; 
   BEGIN
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    -- Movement script for player movement. 
    -- Use 4 buttons, BTNU = UP, BTNR = RIGHT, BTND = DOWN, BTNL = LEFT.
    move_pac: process(clk_in) is 
        variable new_pac_x    : unsigned(10 downto 0);
        variable new_pac_y    : unsigned(10 downto 0);
        variable wall_collide : std_logic;
        VARIABLE p_min_x, p_max_x : UNSIGNED(10 DOWNTO 0);
        VARIABLE p_min_y, p_max_y : UNSIGNED(10 DOWNTO 0);
        variable starting_cord : cord; 
        variable ending_cord   : cord; 
    BEGIN
>>>>>>> Stashed changes
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN -- Reset the position of PACMAN when pressing the middle button back to the starting position.
                pac_x <= STARTING_PAC_X;
                pac_y <= STARTING_PAC_Y;
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
            ELSIF tickspeed = '1' THEN        -- only move on slow tick
=======
            ELSIF tickspeed = '1' AND curr_alive = '1' THEN
>>>>>>> Stashed changes
=======
            ELSIF tickspeed = '1' AND curr_alive = '1' THEN
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
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
                
                p_min_x := new_pac_x - TO_UNSIGNED(pac_size, new_pac_x'LENGTH);
                p_max_x := new_pac_x + TO_UNSIGNED(pac_size, new_pac_x'LENGTH);
                p_min_y := new_pac_y - TO_UNSIGNED(pac_size, new_pac_y'LENGTH);
                p_max_y := new_pac_y + TO_UNSIGNED(pac_size, new_pac_y'LENGTH);
                                   
                FOR index in walls_to_draw'RANGE LOOP -- Checking to see if the pacman is making contact with the wall.
                    starting_cord := walls_to_draw(index)(0);
                    ending_cord   := walls_to_draw(index)(1); 
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
                    IF(new_pac_x >= to_unsigned(starting_cord(0), new_pac_x'length) AND
                        new_pac_x <= to_unsigned(ending_cord(0),   new_pac_x'length) AND 
                        new_pac_y >= to_unsigned(ending_cord(1),   new_pac_y'length) AND
                        new_pac_y <= to_unsigned(starting_cord(1), new_pac_y'length) ) THEN
                        wall_collide := '1';
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                    IF( p_max_x  >= to_unsigned(starting_cord(0), p_max_x'length) AND
                        p_min_x <= to_unsigned(ending_cord(0), p_min_x'length) AND 
                        p_max_y >= to_unsigned(ending_cord(1), p_max_y'length) AND
                        p_min_y <= to_unsigned(starting_cord(1), p_min_y'length) ) THEN
                            wall_collide := '1'; -- Flag to make sure that pacman cannot move through the wall essentially.
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                        EXIT;
                    END IF;
                END LOOP;
                IF wall_collide = '0' THEN -- Checking if pacman is able to move through the wall.
                    pac_x <= new_pac_x;
                    pac_y <= new_pac_y;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    walldraw : PROCESS (pixel_row, pixel_col) is -- Essential function to create the walls around the map.
        VARIABLE starting_cord : cord;           -- Given the array list, it is able to draw between two points to draw the walls.
        VARIABLE ending_cord : cord;
        VARIABLE in_wall : std_logic := '0';
    BEGIN
        in_wall := '0';
        for index in wall_cord_list'range loop
            starting_cord := walls_to_draw(index)(0);
            ending_cord := walls_to_draw(index)(1);
            
            if(pixel_col >= starting_cord(0) AND pixel_col <= ending_cord(0) 
               AND pixel_row <= starting_cord(1) AND pixel_row >= ending_cord(1)) THEN -- checking to see certain points. Basic function is x1 < x2 and y1 > y2
                 in_wall := '1';
            end if;
            wall_on <= in_wall;
        end loop;
    END PROCESS;

<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    fooddraw : PROCESS (pixel_row, pixel_col, food_list) IS
    VARIABLE in_food : std_logic := '0';
    VARIABLE food_x, food_y, not_eaten : INTEGER;
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    fooddraw : PROCESS (pixel_row, pixel_col, food_list, clk_in) IS -- Essential function to draw the food around a certain coordinate.
        VARIABLE in_food : std_logic := '0';
        VARIABLE food_x, food_y, not_eaten : INTEGER;
>>>>>>> Stashed changes
    BEGIN
        in_food := '0';
        FOR index IN food_list'RANGE LOOP
            not_eaten := food_list(index)(0);  -- integer 0/1
            food_x := food_list(index)(1);
            food_y := food_list(index)(2);
            
            IF not_eaten = 1 AND
            (pixel_col >= food_x - food_size AND pixel_col <= food_x + food_size) AND 
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
            (pixel_row >= food_y - food_size AND pixel_row <= food_y + food_size) THEN
                in_food := '1';  -- mark that this pixel is on a food
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
            (pixel_row >= food_y - food_size AND pixel_row <= food_y + food_size) THEN -- Draw around one certain coordinate on the screen.
                in_food := '1'; 
>>>>>>> Stashed changes
            END IF;
        END LOOP;
        food_on <= in_food; 
    END PROCESS;
    
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
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
    
            ghost_timer : PROCESS(clk_in)
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
    ghostdraw : PROCESS(pixel_row, pixel_col, ghost1_x, ghost1_y) IS -- Essential to draw the ghost itself on the screen.
        VARIABLE ghost_left, ghost_right  : UNSIGNED(10 DOWNTO 0);
        VARIABLE ghost_top,  ghost_bottom : UNSIGNED(10 DOWNTO 0);
        VARIABLE in_body  : STD_LOGIC;
        VARIABLE in_head  : STD_LOGIC;
        VARIABLE in_feet  : STD_LOGIC;
        VARIABLE dx, dy   : UNSIGNED(10 DOWNTO 0);
        VARIABLE head  : UNSIGNED(10 DOWNTO 0);
        VARIABLE dx2, dy2, r2 : UNSIGNED(21 DOWNTO 0);
        CONSTANT ghost_under  : UNSIGNED(10 DOWNTO 0) := TO_UNSIGNED(ghost_size, 11);
        CONSTANT ghost_under2 : UNSIGNED(10 DOWNTO 0) := TO_UNSIGNED(2*ghost_size, 11);
    BEGIN
        ghost_left  := ghost1_x - ghost_under;
        ghost_right := ghost1_x + ghost_under;
        ghost_top   := ghost1_y - ghost_under2;
        ghost_bottom:= ghost1_y + ghost_under2;
        ghost1_on <= '0';
        in_body   := '0';
        in_head   := '0';
        in_feet   := '0';

        IF (pixel_col >= ghost_left) AND (pixel_col <= ghost_right) AND
           (pixel_row >= ghost_top)  AND (pixel_row <= ghost_bottom) THEN
           -- Different body parts allow for the ghosty looking ghost by dividing up the different parts and seperatly drawing them.
            -- Body
           IF (pixel_row >= ghost1_y - ghost_under) AND
               (pixel_row <= ghost1_y + ghost_under) THEN
                    in_body := '1';
            END IF;

           -- Head
           head := ghost_top + ghost_under;

            IF pixel_col <= ghost1_x THEN
                dx := ghost1_x - pixel_col;
            ELSE
                dx := pixel_col - ghost1_x;
            END IF;

            IF pixel_row <= head THEN
                dy := head - pixel_row;
            ELSE
                dy := pixel_row - head;
            END IF;

            dx2 := RESIZE(dx * dx, dx2'LENGTH);
            dy2 := RESIZE(dy * dy, dy2'LENGTH);
            r2  := TO_UNSIGNED(ghost_size * ghost_size, r2'LENGTH);

            IF (dx2 + dy2) <= r2 THEN
                in_head := '1';
            END IF;

            -- Feet
            in_feet := '0';
            IF (pixel_row >= ghost1_y + ghost_under) AND
               (pixel_row <= ghost1_y + ghost_under + (ghost_under2 / 2)) then
                -- left foot
                IF (pixel_col >= ghost1_x - ghost_under) AND
                   (pixel_col <= ghost1_x - (ghost_under / 3)) THEN
                    in_feet := '1';
                END IF;

                -- middle foot
                IF (pixel_col >= ghost1_x - (ghost_under / 3)) AND
                   (pixel_col <= ghost1_x + (ghost_under / 3)) THEN
                        in_feet := '1';
                END IF;

                -- right foot
                IF (pixel_col >= ghost1_x + (ghost_under / 3)) AND
                    (pixel_col <= ghost1_x + ghost_under) THEN
                        in_feet := '1';
                    END IF;
            END IF;
               
            -- Final Check (Basically combining all of the different body parts)
            IF (in_head = '1') OR (in_body = '1') OR (in_feet = '1') THEN
                 ghost1_on <= '1';
            ELSE
                 ghost1_on <= '0';
            END IF;
       END IF;
    END PROCESS;

    -- Function to make sure that the ghost is also not teleporting around the screen by creating a timer in which it updates.
    ghost_timer : PROCESS(clk_in)
>>>>>>> Stashed changes
    BEGIN
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN
                ghost_cnt  <= (OTHERS => '0');
                ghost_tick <= '0';
                lfsr       <= x"5A";
            ELSE
                IF ghost_cnt = TO_UNSIGNED(150000-1, ghost_cnt'LENGTH) THEN -- Tune for ghost speed, same thing as the pacman tick speed. Think of it like most video games (like csgo)
                    ghost_cnt  <= (OTHERS => '0');
                    ghost_tick <= '1';
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream

                    -- 8-bit maximal LFSR taps (example: x^8 + x^6 + x^5 + x^4 + 1)
                    lfsr <= lfsr(6 DOWNTO 0) & (lfsr(7) XOR lfsr(5) XOR lfsr(4) XOR lfsr(3));
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                ELSE
                    ghost_cnt  <= ghost_cnt + 1;
                    ghost_tick <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
    ghost_move : PROCESS(clk_in)
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
-- Multiple failed attempts of ghost_move (We tried our best)
--    ghost_move : PROCESS(clk_in)
--        VARIABLE new_gx : UNSIGNED(10 DOWNTO 0);
--        VARIABLE new_gy : UNSIGNED(10 DOWNTO 0);
--        VARIABLE blocked: STD_LOGIC;
--        VARIABLE wall_start : cord;
--        VARIABLE wall_end : cord;
--        VARIABLE g_min_x, g_max_x : UNSIGNED(10 DOWNTO 0);
--        VARIABLE g_min_y, g_max_y : UNSIGNED(10 DOWNTO 0);
--        VARIABLE wallindex, moveindex : INTEGER;
--    BEGIN
--        if rising_edge(clk_in) THEN
--            IF reset = '1' THEN
--                ghost1_x <= STARTING_GHOST_X;
--                ghost1_y <= STARTING_GHOST_Y;
--                ghost_dir <= directions(moveindex);
--            ELSIF ghost_tick = '1' THEN
--                new_gx := ghost1_x;
--                new_gy := ghost1_y;
                
--                IF ghost_dir = "00" THEN       -- UP
--                    new_gy := ghost1_y - TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
--                ELSIF ghost_dir = "01" THEN    -- RIGHT
--                    new_gx := ghost1_x + TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
--                ELSIF ghost_dir = "11" THEN    -- DOWN
--                    new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
--                ELSE                           -- "10" = LEFT
--                    new_gx := ghost1_x - TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
--                END IF;
                
--                blocked := '0';
--                FOR wallindex IN walls_to_draw'RANGE LOOP
--                    wall_start := walls_to_draw(wallindex)(0); -- (minX, maxY)
--                    wall_end   := walls_to_draw(wallindex)(1); -- (maxX, minY)

--                    IF ( g_max_x >= TO_UNSIGNED(wall_start(0), g_max_x'LENGTH) AND
--                         g_min_x <= TO_UNSIGNED(wall_end(0),   g_min_x'LENGTH) AND
--                         g_max_y >= TO_UNSIGNED(wall_end(1),   g_max_y'LENGTH) AND
--                         g_min_y <= TO_UNSIGNED(wall_start(1), g_min_y'LENGTH) ) THEN
--                            blocked := '1';
--                        EXIT;
--                    END IF;
--                END LOOP;
                
--                IF blocked = '0' THEN
--                    -- move in current direction
--                    ghost1_x <= new_gx;
--                    ghost1_y <= new_gy;
--                ELSE
--                    -- bounce: rotate direction (up→right→down→left→up)
--                    moveindex := moveindex + 1;
--                    ghost_dir <= directions(moveindex);
--                    -- recompute candidate move in new direction from current center
--                    new_gx := ghost1_x;
--                    new_gy := ghost1_y;

--                    IF ghost_dir = "00" THEN       -- UP
--                        new_gy := ghost1_y - TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
--                    ELSIF ghost_dir = "01" THEN    -- RIGHT
--                        new_gx := ghost1_x + TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
--                    ELSIF ghost_dir = "11" THEN    -- DOWN
--                        new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
--                    ELSE                           -- LEFT
--                        new_gx := ghost1_x - TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
--                    END IF;

--                    -- ghost AABB for bounce attempt
--                    g_min_x := new_gx - TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
--                    g_max_x := new_gx + TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
--                    g_min_y := new_gy - TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);
--                    g_max_y := new_gy + TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);

--                    blocked := '0';
--                    FOR i IN walls_to_draw'RANGE LOOP
--                        wall_start := walls_to_draw(i)(0);
--                        wall_end   := walls_to_draw(i)(1);

--                        IF ( g_max_x >= TO_UNSIGNED(wall_start(0), g_max_x'LENGTH) AND
--                             g_min_x <= TO_UNSIGNED(wall_end(0),   g_min_x'LENGTH) AND
--                             g_max_y >= TO_UNSIGNED(wall_end(1),   g_max_y'LENGTH) AND
--                             g_min_y <= TO_UNSIGNED(wall_start(1), g_min_y'LENGTH) ) THEN
--                                blocked := '1';
--                            EXIT;
--                        END IF;
--                    END LOOP;
                    
--                    IF blocked = '0' THEN
--                        ghost1_x <= new_gx;
--                        ghost1_y <= new_gy;
--                    END IF;  -- else stay put this tick
--                END IF;
--            END IF;
--        END IF;
--END PROCESS;
                

    ghost_move : PROCESS(clk_in) -- Essential ghost move function, update the directiors list at the top to make the ghost move around the maze however you want.
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
        VARIABLE new_gx   : UNSIGNED(10 DOWNTO 0);
        VARIABLE new_gy   : UNSIGNED(10 DOWNTO 0);
        VARIABLE blocked  : STD_LOGIC;
        VARIABLE wc_start : cord;
<<<<<<< Updated upstream
        VARIABLE wc_end   : cord;   
    BEGIN
        -- up: 00 
        --right: 01 
        --down: 10 
        --left: 11
    IF rising_edge(clk_in) THEN
        IF reset = '1' THEN
            ghost1_x  <= STARTING_GHOST_X;
            ghost1_y  <= STARTING_GHOST_Y;
            ghost_dir <= "01";  -- start moving right
        ELSIF ghost_tick = '1' THEN
            new_gx := ghost1_x;
            new_gy := ghost1_y;

            IF ghost_dir = "00" THEN -- UP
                new_gy := ghost1_y - TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
            ELSIF ghost_dir = "01" THEN  -- RIGHT                 
                new_gx := ghost1_x + TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
             ELSIF ghost_dir = "11" THEN -- DOWN
                new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH);
             ELSE -- LEFT
                new_gx := ghost1_x - TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
            END IF;

            -- check for wall hit
            blocked := '0';
            FOR i IN walls_to_draw'RANGE LOOP
                wc_start := walls_to_draw(i)(0);
                wc_end   := walls_to_draw(i)(1);

                IF ( new_gx >= TO_UNSIGNED(wc_start(0), new_gx'LENGTH) AND
                     new_gx <= TO_UNSIGNED(wc_end(0),   new_gx'LENGTH) AND
                     new_gy >= TO_UNSIGNED(wc_end(1),   new_gy'LENGTH) AND
                     new_gy <= TO_UNSIGNED(wc_start(1), new_gy'LENGTH) ) THEN
                    blocked := '1';
                    EXIT;
=======
        VARIABLE wc_end   : cord;
        VARIABLE g_min_x, g_max_x : UNSIGNED(10 DOWNTO 0);
        VARIABLE g_min_y, g_max_y : UNSIGNED(10 DOWNTO 0);
        VARIABLE moveindex : INTEGER := 1;
        VARIABLE moveflag : STD_LOGIC;
    BEGIN
        -- dir encoding:
        -- "00" = up, "01" = right, "11" = down, "10" = left
        IF rising_edge(clk_in) THEN
            IF reset = '1' THEN -- when reset is hit, make the ghost go back to the starting position.
                ghost1_x  <= STARTING_GHOST_X;
                ghost1_y  <= STARTING_GHOST_Y;
                ghost_dir <= directions(0);  -- start moving right
                moveindex := 0;
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
>>>>>>> Stashed changes
                END IF;
            END LOOP;

<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
<<<<<<< Updated upstream
            IF blocked = '0' THEN
                -- move in current direction
                ghost1_x <= new_gx;
                ghost1_y <= new_gy;
            ELSE
                -- bounce
                WHILE blocked = '1' loop
                    IF ghost_dir = "00" THEN -- was going up
                        ghost_dir <= "01"; -- start going right 
                        new_gx    := ghost1_x + TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
                    ELSIF ghost_dir = "01" THEN --was going right 
                        ghost_dir <= "11"; --start going downn
                        new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH); 
                    ELSIF ghost_dir = "11" THEN  -- was going down 
                        ghost_dir <= "10"; --start going left 
                        new_gx    := ghost1_x - TO_UNSIGNED(MOVE_SPEED, ghost1_x'LENGTH);
                    ELSE  --was going left
                        ghost_dir <= "00"; --start going right
                        new_gy := ghost1_y + TO_UNSIGNED(MOVE_SPEED, ghost1_y'LENGTH); 
                    END IF;
                END LOOP;
                
                
=======
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                g_min_x := new_gx - TO_UNSIGNED(ghost_size, new_gx'LENGTH);
                g_max_x := new_gx + TO_UNSIGNED(ghost_size, new_gx'LENGTH);
                g_min_y := new_gy - TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);
                g_max_y := new_gy + TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);

                -- first collision check
                blocked := '0';
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd

>>>>>>> Stashed changes
                FOR i IN walls_to_draw'RANGE LOOP
                    wc_start := walls_to_draw(i)(0);
                    wc_end   := walls_to_draw(i)(1);

<<<<<<< Updated upstream
                    IF ( new_gx >= TO_UNSIGNED(wc_start(0), new_gx'LENGTH) AND
                         new_gx <= TO_UNSIGNED(wc_end(0),   new_gx'LENGTH) AND
                         new_gy >= TO_UNSIGNED(wc_end(1),   new_gy'LENGTH) AND
                         new_gy <= TO_UNSIGNED(wc_start(1), new_gy'LENGTH) ) THEN
                        blocked := '1';
=======
=======

                FOR i IN walls_to_draw'RANGE LOOP
                    wc_start := walls_to_draw(i)(0); -- (minX, maxY)
                    wc_end   := walls_to_draw(i)(1); -- (maxX, minY)

>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                    IF ( g_max_x >= TO_UNSIGNED(wc_start(0), g_max_x'LENGTH) AND
                         g_min_x <= TO_UNSIGNED(wc_end(0), g_min_x'LENGTH) AND
                         g_max_y >= TO_UNSIGNED(wc_end(1), g_max_y'LENGTH) AND
                         g_min_y <= TO_UNSIGNED(wc_start(1), g_min_y'LENGTH) ) THEN
                            blocked := '1';
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
                        EXIT;
                    END IF;
                END LOOP;

                IF blocked = '0' THEN
                    ghost1_x <= new_gx;
                    ghost1_y <= new_gy;
<<<<<<< Updated upstream
                END IF;  -- else stay put this tick
            END IF;
        END IF;
    END IF;
END PROCESS;
=======
                ELSE
                    -- bounce: rotate direction (up→right→down→left→up)
                    ghost_dir <= directions(moveindex); -- change the direction of the ghost manually
                    
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

                    g_min_x := new_gx - TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
                    g_max_x := new_gx + TO_UNSIGNED(ghost_size,  new_gx'LENGTH);
                    g_min_y := new_gy - TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);
                    g_max_y := new_gy + TO_UNSIGNED(2*ghost_size, new_gy'LENGTH);

                    blocked := '0';
                    moveindex := moveindex + 1; -- Update the moveindex so it goes farther into the list of directions.
                    FOR i IN walls_to_draw'RANGE LOOP
                        wc_start := walls_to_draw(i)(0);
                        wc_end   := walls_to_draw(i)(1);
                        IF ( g_max_x >= TO_UNSIGNED(wc_start(0), g_max_x'LENGTH) AND
                             g_min_x <= TO_UNSIGNED(wc_end(0), g_min_x'LENGTH) AND
                             g_max_y >= TO_UNSIGNED(wc_end(1), g_max_y'LENGTH) AND
                             g_min_y <= TO_UNSIGNED(wc_start(1), g_min_y'LENGTH) ) THEN
                                blocked := '1';
                            EXIT;
                        END IF;
                    END LOOP;

                    IF blocked = '0' THEN
                        ghost1_x <= new_gx;
                        ghost1_y <= new_gy;
                    END IF;
                END IF;
            END IF;
        END IF;
        
        IF moveindex = 19 THEN
            moveindex := 0;
        END IF;
    END PROCESS;
<<<<<<< Updated upstream:pacman/pacman/pacman.srcs/sources_1/imports/sources/pacman.vhd
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes:pacman/pacman/pacman.srcs/sources_1/imports/sources/bat_n_ball.vhd
END Behavioral;