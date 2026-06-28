-- ==========================================
-- Task 1
-- ==========================================

CREATE OR REPLACE FUNCTION calculate_order_total(p_order_id int)
RETURNS numeric AS $$
DECLARE
    v_total numeric;
BEGIN
    SELECT COALESCE(SUM(quantity * price), 0) INTO v_total
    FROM order_items
    WHERE order_id = p_order_id;
    
    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Task 2
-- ==========================================

CREATE OR REPLACE PROCEDURE create_order(p_customer_id int)
AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = p_customer_id) THEN
        RAISE EXCEPTION 'Customer does not exist';
    END IF;
    INSERT INTO orders (customer_id, order_date, total_amount)
    VALUES (p_customer_id, current_timestamp, 0);
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Task 3
-- ==========================================

CREATE OR REPLACE PROCEDURE add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
AS $$
DECLARE
    v_price numeric;
    v_stock int;
BEGIN
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be greater than zero';
    END IF;

    SELECT price, stock_quantity INTO v_price, v_stock
    FROM products
    WHERE product_id = p_product_id;

    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Not enough stock';
    END IF;

    UPDATE products
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;

    INSERT INTO order_items (order_id, product_id, quantity, price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price);
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- Task 4
-- ==========================================

CREATE OR REPLACE FUNCTION trg_update_order_total()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        UPDATE orders SET total_amount = calculate_order_total(OLD.order_id) WHERE order_id = OLD.order_id;
        RETURN OLD;
    ELSE
        UPDATE orders SET total_amount = calculate_order_total(NEW.order_id) WHERE order_id = NEW.order_id;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_total_trigger
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW EXECUTE FUNCTION trg_update_order_total();

-- ==========================================
-- Task 5
-- ==========================================

CREATE OR REPLACE FUNCTION trg_log_new_order()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO order_log (order_id, customer_id, action)
    VALUES (NEW.order_id, NEW.customer_id, 'ORDER_CREATED');
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_new_order_trigger
AFTER INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION trg_log_new_order();

-- ==========================================
-- Task 6 
-- ==========================================

INSERT INTO customers (full_name, email, balance) 
VALUES ('Hanna Lychak', 'hanna@kse.org.ua', 52);

INSERT INTO products (product_name, price, stock_quantity) 
VALUES ('Mascara', 300, 6), ('Iced latte', 100, 7);

CALL create_order(1);

CALL add_product_to_order(1, 1, 2);

CALL add_product_to_order(1, 2, 4);

SELECT * FROM orders;      -- 1000 = (300*2 + 100*4)
SELECT * FROM products;  
SELECT * FROM order_log;   




--- бонус
EXPLAIN ANALYZE
SELECT
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.price,
    oi.quantity * oi.price as item_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;
