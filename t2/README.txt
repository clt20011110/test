T2 2021/5/28
E1
2/a)
 Tuple: two or three elements in order within brackets separated by commas. It is useful when you want to present coordinates in 2D or 3D. But it cannot be updated.
Records: a data structure which can contain a lot of variants with different types. It can be updated. It is useful we you want to construct a model.
Lists: a data structure which contains variants with same types. It is useful when you want to handle or store a bunch of data with the same type and sort or transverse it.
*Important note:Since the use of lists, tuples, and records are enough to present their functions and abilities, I will just take the code in ex3 as an example to illustrate.
For tuple, look into the Main.elm and find snake_body, fruit_place, they are all presented in the tuple form to stand for a coordinate, which is readable and brief.
for record, look into the Main.elm and find Model and Snake. These two records consists of various kinds of variants and is very important in the whole game, supporting the view and update function. This shows the importance of the updating features in records 
For list, look into the Main.elm and find snake_body: List(Int,Int).Under this situation, using lists are convenient to store the snake positions.

b)elm: a functional programming language ---complied into--->HTML(HyperText Markup Language) the most basic building block of the Web. It defines the meaning and structure of web content. Other technologies besides HTML are generally used to describe a web page's appearance/presentation (CSS) or functionality/behavior (JavaScript).
Hypertext Transfer Protocol (HTTP) is an application-layer protocol for transmitting hypermedia documents, such as HTML. It was designed for communication between web browsers and web servers, but it can also be used for other purposes. HTTP follows a classical client-server model, with a client opening a connection to make a request, then waiting until it receives a response.[1]
a diagram may be like this:
 elm           CSS       JavaScript
  |             |            |
  |_____________|____________|compiling
                |   
               HTML: used to develop web pages-----------|
                |                                        |  
                |                                    HTTP/HTTPS: transmitting HTML
               browser(client) <---------------------------------------------------------------------->server
                                                     making requests--------->
                                                     <--------making responses



c){a|field1=  anothervalue}

d)
elm init ---init an initial model--> view -----HTML----->user interface-----get message---->update----change the model---->new model
                                        ^                                                                                       |
                                        |                                                                                       |
                                        |_______________________________________________________________________________________| 

E2
6. add a function called isRepeat to check whether an element appears more than two times. func6 use it to filter the list.
7. add a function called find to return the place of the assigned element. func7 uses it to partition the list. take the first n-1 element, add ("",0) and the rest together.

E3
1.a)change the model to {snake, time-mover, and fruit-place} and snake:{snake_body,snake_dir and snake_status} and adjusts the code accordingly.
b) changedir direction is used so that four pieces of similar codes in updateFruit function is reduced to one.Msg is changed to {Key dir,Key_None,Place_fruit (Int,Int),Tick Float}
2.Notice that in headLegal function, Wall means dead and Free means Alive. Accordingly, I change the legalForward function which calls the headLegal function and returns the live_state to determing the dead situation.
*3.(Since it is optional and I think it is clean,brief and readable already, I didn't chage the lambda function.)
*4 Notice that the length of the snake_body list is linear to the score. I use it to calculate the score and add a text in the div to show it in view function.

[1]https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview