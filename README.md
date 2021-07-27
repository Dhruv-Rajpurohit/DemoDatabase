CRUD Operations in sqlite table using Swift.




If you don`t want to use protocols and delegates then do below steps :

First Create outlets of Edit and Delete button in InfoTable file 
Shift btn click events of Edit and Delete on Main View Controller 
Delete all delegate functions 
Write all the code in btn events of resp clicks
and finally in cellForRowAt write code for cell.OutletName.tag = indexpath.row for both outlets i.e edit and delete
