CREATE DATABASE sportscar_development;
USE sportscar_development;
CREATE TABLE sportscars( 
  id INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY, 
  model VARCHAR(30), 
  make VARCHAR(30), 
  year INT(11), 
  description TEXT, 
  purchase_price DECIMAL(9,2));

CREATE DATABASE sportscar_test;
USE sportscar_test;
CREATE TABLE sportscars( 
  id INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY, 
  model VARCHAR(30), 
  make VARCHAR(30), 
  year INT(11), 
  description TEXT, 
  purchase_price DECIMAL(9,2));

CREATE DATABASE sportscar_production;
USE sportscar_production;
CREATE TABLE sportscars( 
  id INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY, 
  model VARCHAR(30), 
  make VARCHAR(30), 
  year INT(11), 
  description TEXT, 
  purchase_price DECIMAL(9,2));

