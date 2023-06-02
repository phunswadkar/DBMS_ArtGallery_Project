/*List of Colors Used by Different Artists and the respective Art Details*/
SELECT Artist_T.Artist_id, Artist_T.Artist_name, Art_T.Art_id, 
Art_T.Art_name, Art_T.Art_title, Colors_used_T.Colors_used
FROM Artist_T, Art_T, Colors_used_T WHERE
Artist_T.Artist_id =  Art_T.Artist_id AND Art_T.Art_id = Colors_used_T.Art_id;

/*List of Customers and the transaction details like Amount, Transaction ID, and Transaction Date*/
SELECT Transaction_T.Transaction_id,Transaction_T.Transaction_date,
Transaction_T.Total_amount,Customer_T.Customer_name 
FROM Transaction_T
JOIN Customer_T  
ON Customer_T.Customer_registration_id = Transaction_T.Customer_registration_id;

/*List of Customers Details like Customer name, Customer Address that have purchased 
atleast 1 Art and the respective Auctioneer present at the Auction*/
SELECT Customer_T.Customer_name, Customer_T.Customer_address,
Customer_T.No_of_art_work_purchased, Auction_T.Auctioneer 
FROM Customer_T
JOIN Auction_T
ON Auction_T.Auction_id = Customer_T.Auction_id
WHERE No_of_art_work_purchased>0
ORDER BY No_of_art_work_purchased DESC;

/*List of Art Names, Title and Name of the Artist who created the respective 
Art in the year 2018 and 2020*/
SELECT Art_T.Art_name, Art_T.Type_of_art,Art_T.Year_of_creation,Artist_T.Artist_name
FROM Art_T JOIN Artist_T
ON Art_T.Artist_id=Artist_T.Artist_id
WHERE Year_of_creation IN (2018,2020);

/*List of Staff Details like Staff name, Designation and Phone number 
of the Staff who was in charge of Auction on a Particular Date-2022/05/01*/
SELECT Staff_T.Staff_name,Staff_designation,Staff_T.Staff_phone
FROM STAFF_T, Auction_T
WHERE Staff_T.Staff_id=Auction_T.Staff_id
and Auction_T.Auction_date='2022-05-01';

/*View of Art details like Art id, Art Name Art Title, Year of creation and 
Artist Name who created that particular Art*/
CREATE VIEW Art_by_artist AS 
SELECT Artist_T.Artist_id,Artist_T.Artist_name,
Art_T.Art_id,Art_T.Art_name,Art_T.Year_of_creation,
Art_T.Art_title,Art_T.Type_of_art
FROM Artist_T
INNER JOIN Art_T
ON Artist_T.Artist_id = Art_T.Artist_id;

/*View of Customers details like Customer name and Customer Address who attended 
the Auction and who spent more than 1000$ at the Auction*/
CREATE VIEW  Customers_attend_Auction AS 
SELECT Customer_T.Customer_name,Customer_T.Customer_Address,Customer_T.Amount_spent
FROM Customer_T,Auction_T
WHERE Customer_T.Auction_id=Auction_T.Auction_id
AND Amount_spent>1000
ORDER BY Amount_spent desc;





