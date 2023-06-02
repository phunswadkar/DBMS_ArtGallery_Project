/*Stored Procedure to Calculate the Art age and List the Art details like Art ID, Art name, Art Title and Art Old*/
DELIMITER //
CREATE PROCEDURE artage()
BEGIN 
SELECT Art_id, Art_name,Art_title,Type_of_art,
year(curdate())-Year_of_creation as Artold from Art_T
ORDER BY Artold;
END//   
call artage();


