-- Part 1

-- World Database Questions

-- Easy
-- 1. List All countries in South America
SELECT Name from country where continent = "South America";

-- 2. Find the Population of 'Germany'
SELECT Population from country where Name = 'Germany';

-- 3. Retrieve all cities in the country 'Japan'

-- Medium
SELECT city.Name
FROM city
JOIN country ON city.CountryCode = country.Code
WHERE country.Name = 'Japan';

-- 4. Find the 3 most populated countries in the 'Africa' region.
Select Name, Population
FROM country
WHERE Continent = 'Africa'
ORDER by Population DESC
LIMIT 3;

-- 5. Retrieve the country and its life expectancy where the population is between 1 and 5 million.
Select Name, LifeExpectancy
from country
WHERE Population between 1000000 AND 5000000;

-- 6. List countries with an official language of 'French'.
Select Name
from country
JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE countrylanguage.Language = 'French' AND countrylanguage.IsOfficial = 'T';

-- Chinook Database Questions

-- Easy:

-- 7. Retrieve all album titles by the artist 'AC/DC'.
SELECT Title
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId
WHERE Artist.Name = 'AC/DC';

-- 8. Find the name and email of customers located in 'Brazil'.
SELECT FirstName, LastName, Email
FROM Customer
WHERE Customer.Country = 'Brazil';

-- 9. List all playlists in the database.
Select Name from Playlist;

-- Medium:

-- 10. Find the total number of tracks in the 'Rock' genre.
Select COUNT(Track.TrackId) AS TrackCount
FROM Track
JOIN Genre ON Track.GenreId = Genre.GenreId
WHERE Genre.Name = 'Rock';

-- 11. List all employees who report to 'Nancy Edwards'.
Select FirstName, LastName
FROM Employee
WHERE Employee.ReportsTo = (
    SELECT EmployeeId
    FROM Employee
    WHERE FirstName = 'Nancy' AND LastName = 'Edwards'
    );

-- 12. Calculate the total sales per customer by summing the total amount in invoices.
Select Customer.FirstName, Customer.LastName, SUM(Invoice.Total) As TotalSales
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP By Customer.CustomerId;

-- Part 2

-- Design Database

USE `ync4hn`;
    
-- Create Tables
CREATE TABLE `Customer`
(
    `CustomerId` INT NOT NULL AUTO_INCREMENT,
    `FirstName` varchar(40) NOT NULL,
    `LastName` varchar(20) NOT NULL,
    `Email` varchar(60) NOT NULL,
    `Phone` varchar(24),
    PRIMARY KEY (`CustomerId`)
    );

CREATE TABLE `Sales`
(
    `ItemId` INT NOT NULL AUTO_INCREMENT,
    `Item` varchar(50) NOT NULL,
    `Sales` INTEGER NOT NULL,
    `Price` DECIMAL(10,2) NOT NULL,
    `SaleDate` DATE NOT NULL,
    `Location` varchar(50),
    PRIMARY KEY (`ItemId`)
    );

CREATE TABLE `Menu`
(
    `MenuItemId` INT NOT NULL AUTO_INCREMENT,
    `Item` varchar(50) NOT NULL,
    `ItemDescription` varchar(100) NOT NULL,
    `Price` DECIMAL(10,2) NOT NULL,
    `Category` varchar(50) NOT NULL,
    PRIMARY KEY (`MenuItemId`)
    );
    
-- Insert Data
INSERT INTO `Customer` (`FirstName`, `LastName`, `Email`, `Phone`) VALUES
('Anthony', 'Odish', 'blobfishboy@gmail.com', '571-111-2222'),
('Aaron', 'Park', 'aaroniscool@gmail.com', '325-215-6832'),
('John', 'Smith', 'johnsmith12@outlook.com', '591-333-4515'),
('Bob','Tran', 'bobtran64@gmail.com', '515-515-5151'),
('Adrian','Lucas', 'adrianlook@gmail.com', '596-414-7376');

INSERT INTO `Sales` (`Item`, `Sales`, `Price`, `SaleDate`, `Location`) VALUES
('Margherita Pizza', 200, 15.99, '2024-08-02', 'Charlottesville'),
('Sausage Pizza', 100, 13.99, '2024-04-03', 'Charlottesville'),
('Pepperoni Pizza', 350, 12.99, '2024-05-08', 'Charlottesville'),
('Cheese Pizza', 500, 11.99, '2024-03-06', 'Charlottesville'),
('Caesar Salad', 10, 12.99, '2024-01-04', 'Charlottesville');

INSERT INTO `Menu` (`Item`, `ItemDescription`, `Price`, `Category`) VALUES
('Margherita Pizza', 'Fresh Pizza topped with tomatoes, mozzarella, and bazil', 15.99, 'Pizza'),
('Sausage Pizza', 'Classic Pizza topped with italian sausage', 13.99, 'Pizza'),
('Pepperoni Pizza', 'Classic Pizza topped with our highest quality pepperonis', 12.99, 'Pizza'),
('Cheese Pizza', 'Classic Cheese Pizza', 11.99, 'Pizza'),
('Caesar Salad', 'Salad with romaince lettuce, croutons, parmesan cheese, and our special caesar dressing', 12.99, 'Salad');

-- Write Queries
SELECT FirstName, LastName FROM Customer;

SELECT Item
FROM Sales
WHERE Price > 13.00;

SELECT Item
From Menu
WHERE Category = 'Pizza';