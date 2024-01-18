USE WENDB;

#CREACION DE TABLAS TEMPORALES
CREATE TABLE olist_customers_temp(
    customer_id VARCHAR(32), 
    customer_unique_id VARCHAR(32), 
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(50), 
    customer_state VARCHAR(10)
);

CREATE TABLE olist_orders_temp(
    order_id VARCHAR(32), 
    customer_id VARCHAR(32), 
    order_status VARCHAR(50),
    order_purchase_timestamp VARCHAR(19), 
    order_approved_at VARCHAR(19),
    order_delivered_carrier_date VARCHAR(19), 
    order_delivered_customer_date VARCHAR(19), 
    order_estimated_delivery_date VARCHAR(19)
);

CREATE TABLE olist_order_items_temp(
    order_id VARCHAR(32), 
    order_item_id VARCHAR(32), 
    product_id VARCHAR(50),
    seller_id VARCHAR(19), 
    shipping_limit_date VARCHAR(19),
    price VARCHAR(19), 
    freight_date VARCHAR(19)
);

#CREACION DE TABLAS DEFINITIVAS
CREATE TABLE olist_customers_dataset(
    customer_id VARCHAR(32) PRIMARY KEY NOT NULL, -- PK
    customer_unique_id VARCHAR(32) NOT NULL, 
    customer_zip_code_prefix VARCHAR(10) NOT NULL,
    customer_city VARCHAR(50) NOT NULL, 
    customer_state VARCHAR(10) NOT NULL
);

CREATE TABLE olist_orders_dataset(
    order_id VARCHAR(32) PRIMARY KEY NOT NULL, -- PK
    customer_id VARCHAR(32) NOT NULL, -- FK
    order_status VARCHAR(50) NOT NULL,
    order_purchase_timestamp DATETIME NULL, 
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL, 
    order_delivered_customer_date DATETIME NULL, 
    order_estimated_delivery_date DATETIME NULL, 
    FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset(customer_id)
);

CREATE TABLE olist_order_items(
    order_id VARCHAR(32), 
    order_item_id VARCHAR(32), 
    product_id VARCHAR(50),
    seller_id VARCHAR(19), 
    shipping_limit_date VARCHAR(19),
    price float, 
    freight_date float
);
