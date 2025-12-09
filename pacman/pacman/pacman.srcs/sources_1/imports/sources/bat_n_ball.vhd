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
    TYPE cord is array(0 to 1) of INTEGER;
    TYPE wall_cord is array(0 to 1) of cord;
    TYPE wall_cord_list is array(0 to 7) of wall_cord;
    --CONSTANT wall_w : unsigned(10 downto 0) := to_unsigned(10,11);
    SIGNAL wall_int : integer := 10;
    CONSTANT pac_size : INTEGER := 10;
    SIGNAL pac_on : std_logic;
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
    SIGNAL wall_on : STD_LOGIC;
    SIGNAL game_on : STD_LOGIC := '0'; -- indicates whether ball is in play

BEGIN
    red <= NOT wall_on; -- color setup for red ball and cyan bat on white background
    green <= '0';
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
END Behavioral;