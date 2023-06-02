/*Stored Procedure to List the Customers who purchased some Art works and 
the Amount they spent at Auction and Customers who did not Buy any Art works*/
DELIMITER $$
CREATE PROCEDURE amountspent()
BEGIN
SELECT Customer_registration_id,Customer_name,Amount_spent
FROM Customer_T
ORDER BY Amount_spent desc;    
END$$
call amountspent();