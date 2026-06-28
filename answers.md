# cs301-Assignment-3

### 1. What is the difference between a function and a procedure in PostgreSQL?
A function must always return a value and a procedure doesn't return anything. A procedure can influence somehow on table or make a mathematical calculation and for example store it into a variable, while through a function we can retrieve this value into a variable or query.

### 2. Can a trigger be executed manually? Why or why not?
No, you can't just execute a trigger manually like a function. It works strictly like an automatic reaction, t only 'triggers' when a specific event happens in the table like INSERT, UPDATE or DELETE.

### 3. What are the advantages and disadvantages of storing business logic inside the database?
The main advantage is speed and data safety, because the logic works directly where the data lives. This is especially perfect for operational databases (like in retail stores, hospitals, or manufacturing), where data is in a state of constant change and needs strict, real-time rules. The big disadvantage is that SQL code is much harder to test and track in Git. 
