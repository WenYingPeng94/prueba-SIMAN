DROP PROCEDURE IF EXISTS cargar_tabla_order;

DELIMITER // 
CREATE PROCEDURE cargar_tabla_order()
BEGIN 
	#inserta datos de tabla temporal "olist_orders_temp" a "olist_orders_dataset"
    INSERT INTO olist_orders_dataset(
		order_id, 
        customer_id, 
        order_status, 
        order_purchase_timestamp, 
        order_approved_at, 
        order_delivered_carrier_date, 
        order_delivered_customer_date, 
        order_estimated_delivery_date
	) 
	SELECT 
		order_id, 
		customer_id,
		order_status, 
		CASE WHEN (order_purchase_timestamp = 'nan' or order_purchase_timestamp IS NULL) THEN NULL ELSE STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') END order_purchase_timestamp, 
		CASE WHEN (order_approved_at = 'nan' or order_approved_at IS NULL) THEN NULL ELSE STR_TO_DATE(order_approved_at, '%Y-%m-%d %H:%i:%s') END order_approved_at, 
		CASE WHEN (order_delivered_carrier_date = 'nan' or order_delivered_carrier_date IS NULL) THEN NULL ELSE STR_TO_DATE(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')END order_delivered_carrier_date, 
        CASE WHEN (order_delivered_customer_date= 'nan' or order_delivered_customer_date IS NULL) THEN NULL ELSE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s') END order_delivered_customer_date, 
        CASE WHEN (order_estimated_delivery_date = 'nan' or order_estimated_delivery_date IS NULL) THEN NULL ELSE STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s') END order_estimated_delivery_date
	FROM olist_orders_temp as A 
    WHERE NOT EXISTS (SELECT * FROM olist_orders_dataset B WHERE A.ORDER_ID=B.ORDER_ID);
    
    COMMIT;
END //
DELIMITER ; 