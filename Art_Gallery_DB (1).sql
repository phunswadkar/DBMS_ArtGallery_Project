
/*Create a new database*/
CREATE DATABASE Art_Gallery_Management;
USE Art_Gallery_Management;

/* Create table Piece of work Exhibition */
create table Exhibition_T
( Exhibition_id int(11) Not Null,
Exhibition_name varchar(30),
Exhibition_type varchar(30),
Exhibition_location varchar(20),
Start_date date,
End_date date,
CONSTRAINT exhibition_pk primary key(Exhibition_id)
);


create table Staff_T
( Staff_id int(11) not null,
Staff_name varchar(30) not null,
Staff_designation varchar(30) not null,
Staff_address varchar(35),
Staff_phone int(11),
constraint staff_pk primary key (Staff_id));

create table Artist_T
( Artist_id int(11) Not Null,
Artist_name varchar(20),
Artist_address varchar(35),
Artist_phone int(11),
Artist_dob date,
Age int(11),
CONSTRAINT artist_pk primary key(Artist_id)
);

create table Artist_interest_T
( 
Artist_id int(11),
Artist_interest varchar(50),
constraint Artist_interest_pk primary key(Artist_id,Artist_interest),
constraint Artist_interest_fk foreign key (Artist_id) REFERENCES Artist_T(Artist_id)
);

create table Gallery_T
( Gallery_id int(11) not null,
Gallery_name varchar(30) not null,
No_of_arts int(11),
Capacity int(11),
Staff_id int(11),
Exhibition_id int(11),
constraint gallery_pk primary key(Gallery_id),
constraint gallery_fk1 foreign key (Staff_id) REFERENCES Staff_T(Staff_id),
constraint gallery_fk2 foreign key (Exhibition_id) REFERENCES Exhibition_T(Exhibition_id)
);


create table Auction_T
( Auction_id int(11) not null,
Auctioneer varchar(15),
Auction_date date,
Auction_start_time time,
Auction_end_time time,
Bid_price int(15),
Staff_id int(11),
constraint auction_pk primary key(Auction_id),
constraint auction_fk foreign key(Staff_id) REFERENCES Staff_T(Staff_id)
);


create table Customer_T
( Customer_registration_id int(11) not null,
Customer_name varchar(11),
Customer_dob date,
Customer_address varchar(35),
No_of_art_work_purchased int(11),
Amount_spent int(10),
Gallery_id int(11),
Auction_id int(11),
constraint customer_pk primary key(Customer_registration_id),
constraint customer_fk1 foreign key (Gallery_id) REFERENCES Gallery_T(Gallery_id),
constraint customer_fk2 foreign key (Auction_id) REFERENCES Auction_T(Auction_id)
);

create table Customer_interest_T
( Customer_registration_id int(20),
Customer_interest varchar(20), 
constraint customer_interest_pk primary key(Customer_interest,Customer_registration_id),
constraint customer_interest_fk foreign key (Customer_registration_id) REFERENCES Customer_T(Customer_registration_id)
);

create table Participation_T
( Customer_registration_id int(20),
Auction_id int(20),
constraint participation_pk primary key(Auction_id,Customer_registration_id),
constraint participation_fk1 foreign key (Auction_id) REFERENCES Auction_T(Auction_id),
constraint participation_fk2 foreign key (Customer_registration_id) REFERENCES Customer_T(Customer_registration_id)
);



create table Registration_T
( Gallery_id int(11),
Customer_registration_id int(11),
constraint registration_pk primary key(Gallery_id,Customer_registration_id),
constraint registration_fk1 foreign key (Gallery_id) REFERENCES Gallery_T(Gallery_id),
constraint registration_fk2 foreign key (Customer_registration_id) REFERENCES Customer_T(Customer_registration_id)
);

create table Transaction_T
( 
Transaction_id int(11) not null,
Transaction_date date,
Total_amount int(10),
Customer_registration_id int(11),
constraint transaction_pk primary key(Transaction_id),
constraint transaction_fk1 foreign key (Customer_registration_id) REFERENCES Customer_T(Customer_registration_id)
);

create table Art_T
( Art_id int(11) not null,
Art_name varchar(50),
Year_of_creation int(5),
Art_title varchar(50),
Type_of_art varchar(50),
Artist_id int (11),
Gallery_id int(11),
Transaction_id int(11),
Auction_id int(11),
Customer_registration_id int(11),
constraint art_pk primary key(Art_id),
constraint art_fk1 foreign key (Artist_id) REFERENCES Artist_T(Artist_id),
constraint art_fk2 foreign key (Gallery_id) REFERENCES Gallery_T(Gallery_id),
constraint art_fk3 foreign key (Transaction_id) REFERENCES Transaction_T(Transaction_id),
constraint art_fk4 foreign key (Auction_id) REFERENCES Auction_T(Auction_id),
constraint art_fk5 foreign key (Customer_registration_id) REFERENCES Customer_T(Customer_registration_id)
);


create table Colors_used_T
( Art_id int(20),
Colors_used varchar(50),
constraint colors_pk primary key(Art_id,Colors_used),
constraint colors_fk1 foreign key (Art_id) REFERENCES Art_T(Art_id)
);
