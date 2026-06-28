# cs301-Assignment-3

### 1. What is the difference between a function and a procedure in PostgreSQL?
A function must always return a value and a procedure doesn't return anything. A procedure can influence somehow on table or make a mathematical calculation and for example store it into a variable, while through a function we can retrieve this value into a variable or query.

### 2. Can a trigger be executed manually? Why or why not?
No, you can't just execute a trigger manually like a function. It works strictly like an automatic reaction, t only 'triggers' when a specific event happens in the table like INSERT, UPDATE or DELETE.

### 3. What are the advantages and disadvantages of storing business logic inside the database?
The main advantage is speed and data safety, because the logic works directly where the data lives. This is especially perfect for operational databases (like in retail stores, hospitals, or manufacturing), where data is in a state of constant change and needs strict, real-time rules. The big disadvantage is that SQL code is much harder to test and track in Git. 

## Query Analysis 
<img width="807" height="401" alt="image" src="https://github.com/user-attachments/assets/8376ae07-89a1-410f-977f-ee1cae042fd1" />

Based on the execution plan, PostgreSQL uses a Hash Join. First, it does a Sequential Scan on the "products" table to build a hash table. Then, it does a Sequential Scan on "order_items", filters for order_id = 1, and joins them together. It uses Sequential Scans instead of Index Scans because our tables are very small, so reading them directly is much faster.
