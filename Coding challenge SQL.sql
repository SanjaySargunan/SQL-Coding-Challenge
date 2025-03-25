CREATE DATABASE VehicleLease;
USE VehicleLease;

--Vehicle Table
Create Table Vehicle (
    Vehicleid Int Primary Key,
    Make Varchar(50),
    Model Varchar(50),
    Year Int,
    Dailyrate Decimal(10, 2),
    Status Varchar(20),
    Passengercapacity Int,
    Enginecapacity Int);

--Customer Table
Create Table Customer (
    Customerid Int Primary Key,
    Firstname Varchar(50),
    Lastname Varchar(50),
    Email Varchar(100),
    Phonenumber Varchar(20));

--Lease Table
Create Table Lease (
    Leaseid Int Primary Key,
    Vehicleid Int Foreign Key References Vehicle(Vehicleid),
    Customerid Int Foreign Key References Customer(Customerid),
    Startdate Date,
    Enddate Date,
    Type Varchar(20));

--Payment Table
Create Table Payment (
    Paymentid Int Primary Key,
    Leaseid Int Foreign Key References Lease(Leaseid),
    Paymentdate Date,
    Amount Decimal(10, 2));

-- Inserting in Vehicle Table
Insert Into Vehicle Values
(1,'Toyota', 'Corolla', 2022, 50.00, 'Available', 5, 1400),
(2,'Honda', 'Accord', 2023, 45.00, 'Available', 5, 1500),
(3,'Ford', 'Fiesta', 2022, 48.00, 'Notavailable', 4, 1300),
(4,'Nissan', 'Rogue', 2023, 52.00, 'Available', 7, 1600),
(5,'Chevrolet', 'Impala', 2022, 47.00, 'Available', 6, 2000),
(6,'Hyundai', 'Tucson', 2023, 49.00, 'Notavailable', 7, 1800),
(7,'Bmw', 'X5', 2023, 60.00, 'Available', 5, 2500),
(8,'Mercedes', 'Gla', 2022, 58.00, 'Available', 5, 2400),
(9,'Audi', 'Q5', 2022, 55.00, 'Notavailable', 5, 2600),
(10,'Lexus', 'Rx', 2023, 54.00, 'Available', 7, 2700);

-- Inserting in Customer Table
Insert Into Customer Values	
(1,'Arjun', 'Sharma', 'Arjunsharma@gmail.com', '9876543210'),
(2,'Priya', 'Mehta', 'Priyamehta@gmail.com', '9123456789'),
(3,'Rahul', 'Gupta', 'Rahulgupta@gmail.com', '9012345678'),
(4,'Ananya', 'Rao', 'Ananyarao@gmail.com', '9321567890'),
(5,'Karthik', 'Menon', 'Karthikmenon@gmail.com', '9009876543'),
(6,'Kavya', 'Iyer', 'Kavyaiyer@gmail.com', '9201234567'),
(7,'Suresh', 'Kumar', 'Sureshkumar@gmail.com', '9198765432'),
(8,'Pooja', 'Verma', 'Poojaverma@gmail.com', '9101234987'),
(9,'Vikram', 'Reddy', 'Vikramreddy@gmail.com', '9213456789'),
(10,'Sneha', 'Patel', 'Snehapatel@gmail.com', '9187654321');

-- Inserting in Lease Table
Insert Into Lease Values
(1,1,1,'2024-01-10','2024-01-20','Daily'),
(2,2,2,'2024-02-01','2024-02-28','Monthly'),
(3,3,3,'2024-03-05','2024-03-10','Daily'),
(4,4,4,'2024-04-15','2024-04-30','Monthly'),
(5,5,5,'2024-05-01','2024-05-07','Daily'),
(6,6,6,'2024-06-01','2024-06-30','Monthly'),
(7,7,7,'2024-07-05','2024-07-15','Daily'),
(8,8,8,'2024-08-10','2024-08-30','Monthly'),
(9,9,9,'2024-09-05','2024-09-12','Daily'),
(10,10,10,'2024-10-01','2024-10-31','Monthly');

-- Inserting in Payment Table
Insert Into Payment Values
(1, 1, '2024-01-15', 250.00),
(2, 2, '2024-02-20', 1250.00),
(3, 3, '2024-03-08', 200.00),
(4, 4, '2024-04-20', 1400.00),
(5, 5, '2024-05-04', 350.00),
(6, 6, '2024-06-15', 1500.00),
(7, 7, '2024-07-10', 600.00),
(8, 8, '2024-08-25', 1600.00),
(9, 9, '2024-09-10', 400.00),
(10, 10, '2024-10-25', 2000.00);

-- 1. Update the daily rate for a Mercedes car to 68
Update Vehicle
Set Dailyrate = 68
Where Make ='Mercedes';

-- 2. Delete a specific customer and all associated leases and payments
Delete From Payment
Where Leaseid In (Select Leaseid From Lease Where Customerid = 2);

Delete From Lease
Where Customerid = 2;

Delete From Customer
Where Customerid = 2;

-- 3. Rename the "paymentDate" column in the Payment table to "transactionDate".
Alter Table Payment
Rename Column Paymentdate To Transactiondate;

-- 4. Find a specific customer by email.
Select * From Customer
Where Email = 'Rahulgupta@gmail.com';

-- 5. Get active leases for a specific customer.
Select * From Lease
Where Customerid = 3 And Enddate >= Getdate();

-- 6. Find all payments made by a customer with a specific phone number.
Select * From Payment P
Join Lease L On P.Leaseid = L.Leaseid
Join Customer C On L.Customerid = C.Customerid
Where C.Phonenumber = '9876543210';

-- 7. Calculate the average daily rate of all available cars.
Select Avg(Dailyrate) As AvgRate
From Vehicle
Where Status = 'Available';

-- 8. Find the car with the highest daily rate
Select Top 1 * From Vehicle
Order By Dailyrate Desc;

-- 9. Retrieve all cars leased by a specific customer
Select * From Vehicle V
Join Lease L On V.Vehicleid = L.Vehicleid
Where L.Customerid = 3;

-- 10. Find the details of the most recent lease
Select Top 1 * From Lease
Order By Enddate Desc;

-- 11. List all payments made in the year 2023.(2024)
Select * From Payment
Where Year(Paymentdate) = 2023;

-- 12. Retrieve customers who have not made any payments.
Select * From Customer
Where Customerid Not In (
    Select L.Customerid From Lease L
    Join Payment P On L.Leaseid = P.Leaseid);

-- 13. Retrieve Car Details and Their Total Payments.
Select V.*, Sum(P.Amount) As TotalPayments
From Vehicle V
Join Lease L On V.Vehicleid = L.Vehicleid
Join Payment P On L.Leaseid = P.Leaseid
Group By V.Vehicleid, V.Make, V.Model, V.Year, V.Dailyrate, V.Status, V.Passengercapacity, V.Enginecapacity;

-- 14. Calculate Total Payments for Each Customer
Select C.Customerid, C.Firstname, C.Lastname, Sum(P.Amount) As TotalPayments
From Customer C
Join Lease L On C.Customerid = L.Customerid
Join Payment P On L.Leaseid = P.Leaseid
Group By C.Customerid, C.Firstname, C.Lastname;

-- 15. List Car Details for Each Lease.
Select L.Leaseid, V.*
From Lease L
Join Vehicle V On L.Vehicleid = V.Vehicleid;

-- 16. Retrieve Details of Active Leases with Customer and Car Information.
Select L.*, C.Firstname, C.Lastname, V.Make, V.Model
From Lease L
Join Customer C On L.Customerid = C.Customerid
Join Vehicle V On L.Vehicleid = V.Vehicleid
Where L.Enddate >= Getdate();

-- 17. Find the Customer Who Has Spent the Most on Leases.
Select Top 1 C.*, Sum(P.Amount) As TotalSpent
From Customer C
Join Lease L On C.Customerid = L.Customerid
Join Payment P On L.Leaseid = P.Leaseid
Group By C.Customerid, C.Firstname, C.Lastname, C.Email, C.Phonenumber
Order By TotalSpent Desc;

-- 18. List All Cars with Their Current Lease Information
Select V.*, L.*
From Vehicle V
Left Join Lease L On V.Vehicleid = L.Vehicleid
Where L.Enddate >= Getdate();
