CREATE database sulivan;
use sulivan;
CREATE TABLE beverage (
	beveragename CHAR(50),
	price CHAR(10) ,
	convenience CHAR(20) 
);
CREATE TABLE deadline (
	name CHAR(50) ,
	end CHAR(50)
);
CREATE TABLE event (
	shopname CHAR(30) ,
	beveragename CHAR(30) ,
	eventname CHAR(10) ,
	price CHAR(10) );
CREATE TABLE member (
	email VARCHAR(30) ,
	creditcard VARCHAR(20) ,
	mmyy VARCHAR(5) ,
	pwd VARCHAR(5)
);
CREATE TABLE nutritionfacts (
	foodname CHAR(30) ,
	kcal CHAR(10) ,sulivan
	carbohydrate CHAR(10) ,
	protein CHAR(10) ,
	Fat CHAR(10) 
);