# CPE-487 Final Project - Pacman

-Nicole Young, Miguel Rodriguez, Matthew Kemenosh

## Expected Behavior 

The program aims to mimic the behavior of a typical game of Pacman, with some modifications. 

- The walls of the maze are static obstacles. Neither pacman or the ghost can pass through them.

https://github.com/user-attachments/assets/64751e84-f4d2-4a92-b368-7526d2338d80

- Pacman will start slightly up and to the left of the center.
- The ghost will start slightly below the center, and begin moving immediately.
 ![IMG_7328](https://github.com/user-attachments/assets/e3bca2d5-407d-4faf-a025-5081a7b5abe4)

- Pacman can move in four directions, which is done using the buttons on the NEXUS.    

https://github.com/user-attachments/assets/830020f0-afcd-49e6-9774-332b4a3440ef

- The ghost changes directions once it encounters a wall, and can move in all 4 directions.  
- The ghost travels along a predetermined path. 

https://github.com/user-attachments/assets/b001b24c-1a91-44ff-8644-91f6e50227c8

https://github.com/user-attachments/assets/c354aae4-9235-46af-824e-0bb3930e9441

- There is food evenly distributed throughout the maze. 
- Pacman eats by colliding with the food. This increases the score. 
- The score is displayed on the NEXUS. 

https://github.com/user-attachments/assets/21affd04-f168-49f1-b71c-21d9e7e20002

- If pacman collides with the ghost, the screen will go to black. 

https://github.com/user-attachments/assets/f65e6bb6-4c28-42c3-831d-c11477dc7f98

- Pressing the center button will reset the game. 

https://github.com/user-attachments/assets/8d38131d-deaf-4442-8f29-538bdbc43647

## Necessary Hardware: 
Nexus  A7-100T FPGA Board 

Computer with a USB port and Vivado installed.

Monitor with VGA port or VGA adapter. 

Micro-USB to USB Cable 

VGA connector. 


## Project Setup Instructions 
1. Download the following files from the repository to your computer. clk_wiz_0.vhd , clk_wiz_0_clk_wiz.vhd, leddec16.vhd, pacman.vhd, pacman_main.vhd, pong.vhd, vga_sync.vhd, pong.xdc
1. Once you have downloaded the files, follow these steps: 
1. Open AMD Vivado Design Suite and create a new RTL project called NAME 
1. In the “Add Sources” section, click on “Add Files” and add all of the .vhd files from this repository 
1. In the “Add Constraints” section, click on “Add Files” and add the .xdc files from this repository 
1. In the “Default Part” section, click on 
1. Connect the Nexus Board to the computer via the Micro-USB to

## Architectural Overview
![PNG image](https://github.com/user-attachments/assets/25f8a908-01b9-477d-8362-45b40939ab10)

The highest level architecture is pacman_main. Our code was based on the pong lab, so the architecture of pacman_main resembles that.

### Pacman_main

Pacman_main has subcomponents clk_wiz_0, vga_sync, leddec16, and pacman. Only pacman is different from previous labs. 

## Inputs to and from the Nexus Board
<img width="607" height="1065" alt="image" src="https://github.com/user-attachments/assets/c3750e8f-44c4-40b1-9795-d20a22e4d386" />

### Pacman
This component handles all of the game mechanics. This is done through many subprocesses, which will be described below. 

_select_color_

Chooses which color to display at pixel_row, pixel_col 
This depends on whether pacman is alive, if a coordinate is in a wall, if a coordinate is in the ghost, if a coordinate is in pacman, island if the coordinate is in a food particle.

_pacdraw_

Draws the pacman on screen using pac_x, pac_y, pixel_row, pixel_col. 
This process compares pixel_row and pixel_col against pac_x and pac_y to determine if the current pixel lies within Pacman’s bounding region, asserting pac_on when the condition is met.

_die_

Actual function that makes the player "die" to the ghost.
Handles player death logic when Pacman comes into contact with the ghost.
This process detects overlap between Pacman and ghost coordinate ranges and updates the alive state, disabling Pacman movement and rendering until a reset occurs.

_eatfood_

Function to eat food and reset the food on the screen using the middle button (BTNC). 
When pac_on and food_on overlap, the process increments curr_score, marks the food as eaten in food_list, and prevents re-scoring using the not_eaten flag. The middle button (BTNC) resets the food list and score when pressed.

_movehelper_

Clock management to prevent pacman from not moving smoothly. Without this function, pacman essential teleports aroudn the screen due to the pixels not updating fast enough. Uses clk_in to manage.

_move_pac_

Movement script for player movement. Use 4 buttons, BTNU = UP, BTNR = RIGHT, BTND = DOWN, BTNL = LEFT. Deals with potential collisions against walls or ghost.

_walldraw_

Essential function to create the walls around the map. Given the array list, it is able to draw between two start and end points to draw the walls and flagging wall_on when the current pixel falls within a wall region.

_fooddraw_

Essential function to draw the food around a certain coordinate.
This process checks pixel_row and pixel_col against stored food positions and enables food_on only for food items that have not yet been marked as eaten.

_ghostdraw_

Essential to draw the ghost itself on the screen.
Similar to Pacman drawing logic, this process asserts ghost_on when the current pixel lies within the ghost’s positional boundaries defined by its x and y coordinates.

_ghosttimer_

Function to make sure that the ghost is also not teleporting around the screen by creating a timer in which it updates. By using an internal timer or clock divider, this process limits how frequently the ghost’s position is updated, ensuring smooth and visually consistent motion.

_ghost_move_

Essential ghost move function, update the directiors list at the top to make the ghost move around the maze however you want. This process updates the ghost’s direction based on a predefined direction list and wall collision checks, allowing the ghost to navigate the maze without user input.

## Modifications
This project builds directly upon Lab 6, the Pong Lab, which served as the conceptual and structural baseline for our VGA graphics, timing, and basic object movement. bat_n_ball.vhd and pong.vhd were the main modules we modified and improved upon, converting to the modules pacman.vhd and pacman_main.vhd respectively. The supporting modules such as clk_wiz_0.vhd, vga_sync.vhd, and leddec16.vhd were reused with minimal to no functional changes. Our main work focused on significantly extending and transforming the original Pong gameplay into a fully interactive Pacman style game.

The original bat_n_ball.vhd module implemented a single moving ball, a user controlled bat, drawing, and simple collision logic with screen boundaries. Our main game logic file, pacman.vhd, was inspired by this architecture where we extensively redesigned and expanded it to support our maze based Pacman game. The pong.vhd file from the lab served as the baseline for VGA setup, clock generation, and module interconnection. This was modified into pacman_main.vhd to support the expanded game logic and additional inputs.

Key modifications include:
- Entity Replacement and Role Expansion: The single ball object from pong was replaced with multiple independent entities, including Pacman, a ghost, and static maze walls, in which our design manages multiple interacting objects with separate dynamic and static behaviors. Pacman and the ghost are given starting coordinate positions for their x and y. The coordinates of the walls of the maze are created in an array list at the start and called to draw later through walldraw to establish the boundaries, which include both the screen edge border walls from pong and the new in maze walls. The food for pacman to eat was also established around specific coordinates in an array coord list and materialized with foodraw.
- Maze Based Collision Detection: Pong collision logic only handled boundary reflections and bat contact. Our implementation introduces wall based collision detection, preventing Pacman and the ghost from passing through maze walls. This required replacing simple screen edge checking conditions with grid based positional checks against wall coordinates. The ghost also uses this collision detection when it bounces into a wall to change its direction.
  - Collision hitbox logic is also utilized to determine when Pacman “eats” a food object and removes it from the screen increasing the score, as well as to make Pacman die when the ghost makes contact with its hitbox. Pacman and the ghost’s hitboxes are initialized using min and max x and y values alongside their size.
- Directional Movement Instead of Reflection: In Pong, the ball reflects around the walls automatically upon collision, and the bat only supports left/right paddle movement and a serve button. In our Pacman implementation, movement is directional and state driven, controlled by user input and internal direction registers. Pacman requires four directional movement, so additional button inputs for BTNU (up), BTND (down), BTNL (left), BTNR (right), and BTNC (a game reset button) were integrated and routed to the game logic. When a collision with a wall is detected, movement in that direction is halted rather than reflected. Rising_edge clk concepts were utilized for both pacman and the ghost in order for them to move around the maze seamlessly and not teleport by creating timers that update regularly for smooth movement. 
- Ghost Movement Behavior: A major addition beyond the Pong lab is the ghost movement logic. The ghost navigates the maze following a direction list and changes direction upon encountering walls detected, introducing a semi-nonuser controlled behavior that did not exist in the original starter code. We tried very hard to make the ghost’s movement more autonomous and random, but kept running into soft locks with it so we gave it a mapped direction list that follows the same scripted movement patterns, but it can be edited by the user easily to encounter different pathing options while playing.
- Object Rendering Logic: The circular ball drawing logic from bat_n_ball.vhd was replaced with simple pixel drawing logic for Pacman, the ghost, and maze walls. These shapes are rendered using coordinate based comparisons. For example, the pacdraw function uses pac_x, pac_y, pixel_row, and pixel_col to create Pacman, following similar logic for the rest.
- Game State and Scoring Enhancements: The hit counter from Pong was repurposed into a Pacman score system, integrated when a food pellet is “eaten”, with the updating signal routing score displayed on the seven segment display. We also updated the scoring method from counting in hexadecimal since it would mess up the true score tracking (like going from 10, to 1A, to 1F, then 20 etc.), and were able to properly count up by 1 through the leddec16.vhd module. This represents a functional expansion beyond simple hit counting. A dedicated reset input was also added to allow instant restarting of the game anytime.

## Conclusion
Throughout the project, we organized the components that were essential for the game. These were divided up into three different “categories”, walls, movement and fruits. These were the core components that basically made pacman to be pacman. The walls were handled by Matt Kemenosh, movement by Miguel Rodriguez/Nicole Young and the eating/fruits by Miguel Rodriguez/Nicole Young. Miguel and Nicole handled many of the coding/bug fixing while Matt would handle code testing and researching/suggesting fixes. For the GitHub write up, Nicole helped write the beginning, Matt wrote most of the details from mid-beginning to end, and Miguel helped write the ending. By dividing up the work, we were able to attempt to structure our timeline to develop all the components by certain points. Below is the outline of the project with date estimates:

_Week of November 25th:_ Begin outline of the project itself with the goals we want to achieve. Research basic functions that were necessary for the creation of our game.

_Week of December 2nd:_ Begin working on the basic components, Matthew worked on the drawing of the maze while the others worked on the actual drawing functions that were being incorporated.

_Week of December 9th:_ With the drawing functions completed, Matthew worked on the coordinates for the walls and fruit to feed into the function while the others worked on the movement position to ensure that there is a gameplay. Also, the eatfood function was fully completed so you were able to eat the fruit. 

_Week of December 16th:_ Completed the ghost functions throughout the week before the poster session, making sure that the ghosts at least moved constantly throughout the gameplay. 

Obviously, with any project, there were difficulties. The first challenge we encountered was the wall drawing function. At certain points, the walls simply would not draw themselves based on the information we fed it. It took us a week to figure out what the problem was with the wall drawing function but once we did, we were able to create as many walls as we needed. We fixed this by looking at the bat_and_ball function that was given to us and followed a similar if statement to feed it two coordinates to draw between, creating a wall. The second challenge we faced was the movement function of Pacman. We were able to figure out decently quickly how to keep him inside of the walls using a basic check similar to the one inside of bat_and_ball, but the speed at which he was walking was weird. We figured out that it was due to a clock issue which we simply just put in a timer to slow him down so it looks smooth as he walks. We implemented a simple clock tick speed that allows for more time between the frame movement so it isn’t so harsh. The third challenge we faced was the ghost movement. We attempted to make the movement random around the maze but we failed. We found he got stuck at many different points or he would have a flickering between all the directions constantly. We tried many different methods to make it truly random but we couldn’t find a form to do it. LFSR, direction lists, flags and other techniques were attempted for the ghost movement. We fixed this by simply just creating an array that is iterated through once they hit a wall that feeds it a direction to go. This array just gets iterated through constantly throughout the gameplay.

