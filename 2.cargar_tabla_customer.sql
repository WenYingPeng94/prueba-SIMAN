DROP PROCEDURE IF EXISTS cargar_tabla_customer;

DELIMITER // 
CREATE PROCEDURE cargar_tabla_customer()
BEGIN 
	#insertando datos de tabla temporal "olist_customers_temp" a "olist_customers_dataset"
    INSERT INTO olist_customers_dataset(
		 customer_id, 
         customer_unique_id, 
         customer_zip_code_prefix, 
         customer_city, 
         customer_state
	) 
	SELECT 
		customer_id, 
		customer_unique_id,
		customer_zip_code_prefix, 
		customer_city, 
		customer_state
	FROM olist_customers_temp as A 
    WHERE NOT EXISTS (SELECT * FROM olist_customers_dataset B WHERE A.CUSTOMER_ID=B.CUSTOMER_ID);
    
    COMMIT;
END //
DELIMITER ; 