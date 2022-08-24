SELECT 
        `a`.`order_id` AS `order_id`,
        YEAR(`a`.`shipped_date`) AS `year`,
        QUARTER(`a`.`shipped_date`) AS `Quarter`,
        MONTH(`a`.`shipped_date`) AS `month`,
        `b`.`product_id` AS `product_id`,
        `b`.`quantity` AS `quantity`,
        `b`.`list_price` AS `list_price`,
        `b`.`discount` AS `discount`,
        `c`.`product_name` AS `product_name`,
        `d`.`brand_id` AS `brand_id`,
        `d`.`brand_name` AS `brand_name`,
        `e`.`store_id` AS `store_id`,
        `e`.`store_name` AS `store_name`,
        `f`.`staff_id` AS `staff_id`,
        CONCAT(`f`.`first_name`, ' ', `f`.`last_name`) AS `Full name`,
        `g`.`category_id` AS `category_id`,
        `g`.`category_name` AS `category_name`,
        ROUND(((`b`.`quantity` * `b`.`list_price`) * (1 - `b`.`discount`)),
                0) AS `Sales`
    FROM
        ((((((`sales`.`orders` `a`
        JOIN `sales`.`order_items` `b` ON ((`a`.`order_id` = `b`.`order_id`)))
        JOIN `products` `c` ON ((`b`.`product_id` = `c`.`product_id`)))
        JOIN `brands` `d` ON ((`c`.`brand_id` = `d`.`brand_id`)))
        JOIN `sales`.`stores` `e` ON ((`a`.`store_id` = `e`.`store_id`)))
        JOIN `sales`.`staffs` `f` ON ((`a`.`staff_id` = `f`.`staff_id`)))
        JOIN `categories` `g` ON ((`c`.`category_id` = `g`.`category_id`)))
    WHERE
        `a`.`order_status` IN (SELECT 
                `sales`.`order_status`.`id`
            FROM
                `sales`.`order_status`
            WHERE
                (`sales`.`order_status`.`Status` = 'Completed'));
                
SELECT 
        `a`.`order_id` AS `order_id`,
        YEAR(`a`.`order_date`) AS `Year`,
        QUARTER(`a`.`order_date`) AS `Quarter`,
        MONTH(`a`.`order_date`) AS `Month`,
        `b`.`product_id` AS `product_id`,
        `c`.`product_name` AS `product_name`,
        `b`.`quantity` AS `quantity`,
        `b`.`list_price` AS `list_price`,
        `b`.`discount` AS `discount`,
        `d`.`brand_id` AS `brand_id`,
        `d`.`brand_name` AS `brand_name`,
        `e`.`category_id` AS `category_id`,
        `e`.`category_name` AS `category_name`,
        `g`.`staff_id` AS `staff_id`,
        CONCAT(`g`.`first_name`, ' ', `g`.`last_name`) AS `Staff fullname`,
        `h`.`store_id` AS `store_id`,
        `h`.`store_name` AS `store_name`,
        `i`.`id` AS `id`,
        `i`.`Status` AS `Order status`,
        `j`.`customer_id` AS `customer_id`,
        CONCAT(`j`.`first_name`, ' ', `j`.`last_name`) AS `Customer fullname`
    FROM
        ((((((((`sales`.`orders` `a`
        JOIN `sales`.`order_items` `b` ON ((`a`.`order_id` = `b`.`order_id`)))
        JOIN `products` `c` ON ((`b`.`product_id` = `c`.`product_id`)))
        JOIN `brands` `d` ON ((`c`.`brand_id` = `d`.`brand_id`)))
        JOIN `categories` `e` ON ((`c`.`category_id` = `e`.`category_id`)))
        JOIN `sales`.`staffs` `g` ON ((`a`.`staff_id` = `g`.`staff_id`)))
        JOIN `sales`.`stores` `h` ON ((`a`.`store_id` = `h`.`store_id`)))
        JOIN `sales`.`order_status` `i` ON ((`a`.`order_status` = `i`.`id`)))
        JOIN `sales`.`customers` `j` ON ((`a`.`customer_id` = `j`.`customer_id`)))
    WHERE
        `a`.`order_status` IN (SELECT 
                `sales`.`order_status`.`id`
            FROM
                `sales`.`order_status`
            WHERE
                (`sales`.`order_status`.`Status` = 'Completed'))
            IS FALSE;