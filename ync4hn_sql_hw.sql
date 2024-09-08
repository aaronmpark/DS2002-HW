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
