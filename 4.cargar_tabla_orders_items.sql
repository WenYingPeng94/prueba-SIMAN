DROP PROCEDURE IF EXISTS cargar_tabla_orders_items;
DELIMITER // 
create procedure cargar_tabla_orders_items()
begin
  insert into olist_order_items(
    order_id, 
    order_item_id, 
    product_id,
    seller_id, 
    shipping_limit_date,
    price, 
    freight_date
  )
  select
    order_id, 
    order_item_id, 
    product_id,
    seller_id, 
    shipping_limit_date,
    price, 
    freight_date
  from olist_order_items_temp a
  where
    not exists
    (
      select * from olist_order_items b
      where
        a.order_id = b.order_id
        and a.product_id = b.product_id
    );
  commit;
  
END //
DELIMITER ; 