# T4 2021/6/8
## Ex1
### 1.
####  a) 
The main limitations of Javascript are:
- Client-side JavaScript does not allow the reading or writing of files. It has been kept for the security reason.
- JavaScript could not used for networking applications because there is no such support available.
- JavaScript doesn't have any multithreading or multiprocessor capabilities. [1]
#### b) 
It is suitable for its popularity, simplicity and speed.
#### c)
- commands are used to make an HTTP request or to get a random thing in Elm
- subscriptions are used to subscribe to the runtime system when being called.
- JavaScript Interop is needed when interating elm with JavaScript.
### 2.
JavaScript Interop is used in elm-tetris to read the keyboard messages and decode and encode them.




## Ex2
If the number is greater than the length of the list, some undefined behaviour and unexpected bugs.

## Ex3
This has already been done in T3 with my own idea. So, I just reuse my code in T3.

## Ex4
### 1. 
I change the model and remove the stopped and paused state and accordingly remove all the related things.
### 2. 
I map several generators into one shape and color generator by using Random.map2 Random.map3 function.
### 3.
 I just change the fullLine function so that when the length of grid list in one line is equal to n-1 it will also be detected.
### 4. 
I just change the shape list so all the tetriminos are substituted by pentiminos.

## Reference
[1] https://www.tutorialspoint.com/What-are-the-limitations-of-JavaScript



