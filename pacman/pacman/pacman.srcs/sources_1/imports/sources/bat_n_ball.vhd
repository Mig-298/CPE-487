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
    

TYPE food_coord IS ARRAY(0 TO 2) OF INTEGER;
TYPE food_coord_list IS ARRAY(129 DOWNTO 0) OF food_coord;
    TYPE food_coord IS ARRAY(0 TO 2) OF INTEGER;
TYPE food_coord_list IS ARRAY(129 DOWNTO 0) OF food_coord;

constant FOOD_LIST : food_coord_list <= (
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
END Behavioral;