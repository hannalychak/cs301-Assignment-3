# Query Analysis
<img width="733" height="348" alt="image" src="https://github.com/user-attachments/assets/13cebeba-aacd-4d82-b362-2bac57fe82c8" />

Based on the execution plan, PostgreSQL uses a Hash Join. First, it does a Sequential Scan on the "products" table to build a hash table. Then, it does a Sequential Scan on "order_items", filters for order_id = 1, and joins them together. It uses Sequential Scans instead of Index Scans because our tables are very small, so reading them directly is much faster.
