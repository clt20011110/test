# T6 2021-7-20
## Ex1
### 1

    a) b)
        1) The ball can be stuck in the brick. It is easy to find. We update the ball out of the brick once the collison is detected to fix this bug.

        2) When the ball collides with the brick at the corner, there will be a "second" collision. This meight not be fixed because the update frequency  is not high enough.

        There might not be so many bugs in p1...

### 2

    How to track and reproduce the bug is very essential in p2. Since there is a lot of uncertainty and possibility in our football game, some bugs are hard to reproduce and track. If we make some variable or state visible, the tracking will be easier, and we only need to follow the variables and states to where the bug happens.

### 3

    Operating System, browser, what's the issue, how to reproduce the issue, product version number, what should be the result.

### 4

        **Operating System**

        Windows

        **Browser**

        Edge
        
        ** version number **
        
        m2

        **Issue description**

        The ball can be stuck in the brick.

        **Steps to reproduce the issue**

        It is easy to find 


        **What's the expected result?**

        The ball should bounce back.

### 5 
    Track the probelm-> judge collision function-> change the coordinates when colliding to the outside of the brick -> fixed.
