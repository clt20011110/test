T3 2021/6/1
Ex1
    2
        a) sum types can preserve the information and the intent of what the Boolen value represents. This feature is readable and convenient for users to read and debug and understand the code.
        b) sum types are used in the Model State to represent three states: Paused, Playing and Stopped. It is used in the renderGameButton and RenderInfo function to get message from the button and change the game state accordingly.
    3
        a)use type alias to define Model ={ race : Race, class : Class, armor : Armor }use union type to define type Race= Human| Elf type Class= Base|Middle| Domain type Armor= Shield|Plate|Mail
        use html to show the model with three show functions.
Ex2
    1 add four types of fruit:grape 10pt;banana 20pt; orange 50pt; apple 100pt. the score of each fruit is inversely proportional to the appearing frequency. All process is randomized.
    2 judge the fruit type and add the score when updating the fruit.
    3 add a function of judgeSnake to judge whether it is alive and accordingly update it in the updateSnake function. add snake_life in type snake.
Ex3
    2 
        a)Goto renderGameButton function ,change the background color to #00f(blue)
        b)Goto tetriminos add a single block (yellow, (0,0))and two blocks(blue,(0,0),(0,1))
        c)Goto RenderInfo function ,add "Have fun!" at the bottom.
    3
        a)Grid.elm fullLine clearLine function are needed for detecting and clearing lines.
        b)Adjust clearLine function. First remove all the blocks that are below the line from the list, calculate its height and subtract the above lines with it.
    4 Nothing and Just is the union type in Maybe. It can be used if you don't know something has nothing in it or has a value. This Maybe type can help you check whether it is null and get the value if is is not empty at the smae time so that you don't need to write if-else and keep you code clear and you are prevented from calling for a value from an empty thing, which will cause some undefined behaviour.
