CREATE DATABASE Smart_Parking_Management_System;

USE Smart_Parking_Management_System;

CREATE TABLE Employee (
    EmployeeId VARCHAR(50) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(50),
    JobTitle VARCHAR(50) NOT NULL
);

CREATE TABLE Shift (
    ShiftId VARCHAR(50) PRIMARY KEY NOT NULL,
    EmployeeId VARCHAR(50),
    ShiftTime TIME,
    EndTime TIME,
    ShiftDate DATE NOT NULL,
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);

CREATE TABLE EmployeePhoneNumber (
    PhoneId VARCHAR(20) PRIMARY KEY NOT NULL,
    EmployeeId VARCHAR(50),
    EmployeePhoneNumber VARCHAR(20),
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);


CREATE TABLE ParkingLot (
    ParkingLotId VARCHAR(20) NOT NULL,
    PRIMARY KEY (ParkingLotId),
    TotalSpace INT NOT NULL,
    AvailableSpace INT NOT NULL,
    Location VARCHAR(50) ,
    Name VARCHAR(100) NOT NULL,
    OccupancyRate DECIMAL(5,2)
);

CREATE TABLE MaintenanceRequest (
    RequestId VARCHAR(20) PRIMARY KEY NOT NULL,#
    EmployeeId VARCHAR(50) NOT NULL,
    RequestedDate DATE NOT NULL,
    ParkingLotId VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    CompletedDate DATE,
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId),
    FOREIGN KEY (ParkingLotId) REFERENCES ParkingLot(ParkingLotId)
);

CREATE TABLE ParkingSpace (
    ParkingSpaceId VARCHAR(20) PRIMARY KEY NOT NULL,
    ParkingLotId VARCHAR(20) NOT NULL,
    SpaceNumber INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (ParkingLotId) REFERENCES ParkingLot(ParkingLotId)
);

CREATE TABLE SecurityCamera (
    SecurityCameraId VARCHAR(20) NOT NULL PRIMARY KEY,
    ParkingLotId VARCHAR(20) NOT NULL,
    Location VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (ParkingLotId) REFERENCES ParkingLot(ParkingLotId)
);

CREATE TABLE ParkingLotMaintenance (
    ParkingLotMaintenanceId VARCHAR(20) NOT NULL,
	MaintenanceId VARCHAR(20) NOT NULL,
    RequestId VARCHAR(20) NOT NULL,
    EmployeeId VARCHAR(50) NOT NULL,
    PRIMARY KEY(ParkingLotMaintenanceId,MaintenanceId),
    FOREIGN KEY (RequestId) REFERENCES MaintenanceRequest(RequestId),
    FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);

CREATE TABLE ParkingSpotHistory (
    ParkingSpotHistoryId VARCHAR(20) NOT NULL,
    ParkingSpaceId VARCHAR(20) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    PRIMARY KEY(ParkingSpotHistoryId,ParkingSpaceId),
    FOREIGN KEY (ParkingSpaceId) REFERENCES ParkingSpace(ParkingSpaceId)
);

CREATE TABLE Vehicle (
    VehicleId VARCHAR(50) NOT NULL,
    LicensePlate VARCHAR(50) NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    PRIMARY KEY(VehicleId,LicensePlate)
);

CREATE TABLE ParkingTicket (
    ParkingTicketId VARCHAR(50) PRIMARY KEY,
    VehicleId VARCHAR(50) NOT NULL,
    ParkingLotId VARCHAR(20) NOT NULL,
    TicketStatus VARCHAR(20) NOT NULL,
    Reason VARCHAR(50) ,
    IssueDate DATE NOT NULL,
    FOREIGN KEY (VehicleId) REFERENCES Vehicle(VehicleId),
    FOREIGN KEY (ParkingLotId) REFERENCES ParkingLot(ParkingLotId)
);

CREATE TABLE Payment (
    PaymentId VARCHAR(20) PRIMARY KEY NOT NULL,
    PaymentAmount VARCHAR(20) NOT NULL,
    ParkingTicketId VARCHAR(50) NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(10) NOT NULL,
    FOREIGN KEY (ParkingTicketId) REFERENCES ParkingTicket(ParkingTicketId)
);

CREATE TABLE User (
    UserId VARCHAR(50) NOT NULL PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    BirthDay DATE NOT NULL,
    PassWord VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

CREATE TABLE Reservation (
    ReservationId VARCHAR(50) PRIMARY KEY NOT NULL,
    ParkingSpaceId VARCHAR(20) NOT NULL,
    UserId VARCHAR(50) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    ReservationStatus VARCHAR(20) NOT NULL,
    Duration TIME,
    FOREIGN KEY (ParkingSpaceId) REFERENCES ParkingSpace(ParkingSpaceId),
    FOREIGN KEY (UserId) REFERENCES User(UserId)
);

CREATE TABLE UserPhoneNumber (
    UserPhoneNumberId VARCHAR(50) PRIMARY KEY NOT NULL,
    UserId VARCHAR(50) NOT NULL,
    UserPhoneNumber VARCHAR(20) NOT NULL,
    FOREIGN KEY (UserId) REFERENCES User(UserId)
);

CREATE TABLE SpotHistoryDate (
    DateId VARCHAR(20) PRIMARY KEY NOT NULL,
    ParkingSpotHistoryId VARCHAR(20) NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    FOREIGN KEY (ParkingSpotHistoryId) REFERENCES ParkingSpotHistory(ParkingSpotHistoryId)
);

-- Creating the Recursive Relationship with Supervise Table

CREATE TABLE Supervise(
	SupervisorId VARCHAR(50) PRIMARY KEY NOT NULL,
    EmployeeId VARCHAR(50) NOT NULL,
	SuperviseId VARCHAR(50)
);


-- Add constraint Foreign key to Tables
-- 1) Shift
ALTER TABLE Shift 
ADD CONSTRAINT FK_EmloyeeId 
FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId) ON DELETE SET NULL ON UPDATE CASCADE;


-- 2) EmployeePhoneNumber
ALTER TABLE EmployeePhoneNumber
DROP FOREIGN KEY employeephonenumber_ibfk_1;

ALTER TABLE EmployeePhoneNumber
ADD CONSTRAINT fk_emplyid
FOREIGN KEY (EmployeeId) 
REFERENCES Employee (EmployeeId) 
ON DELETE SET NULL;

-- 3)maintenancerequest
ALTER TABLE maintenancerequest
DROP FOREIGN KEY maintenancerequest_ibfk_1;

ALTER TABLE maintenancerequest
ADD CONSTRAINT fk_employeeid 
FOREIGN KEY (EmployeeId) 
REFERENCES Employee (EmployeeId) 
ON DELETE CASCADE;

-- 4)parkinglotmaintenance

ALTER TABLE parkinglotmaintenance
DROP FOREIGN KEY parkinglotmaintenance_ibfk_1;

ALTER TABLE parkinglotmaintenance
ADD CONSTRAINT fk_requestid 
FOREIGN KEY (RequestId) 
REFERENCES maintenancerequest (RequestId) 
ON DELETE CASCADE;

-- 5)parkingticket

ALTER TABLE parkingticket
ADD CONSTRAINT fk_parkinglot_id 
FOREIGN KEY (ParkingLotId) 
REFERENCES ParkingLot (ParkingLotId) 
ON DELETE CASCADE;

ALTER TABLE ParkingTicket
DROP FOREIGN KEY parkingticket_ibfk_1;

ALTER TABLE ParkingTicket
ADD CONSTRAINT fk_vehicleid
FOREIGN KEY (VehicleId) 
REFERENCES Vehicle(VehicleId)
ON DELETE CASCADE;

-- 6) payment
ALTER TABLE payment
ADD CONSTRAINT fk_parkingticket_id 
FOREIGN KEY (ParkingTicketId) 
REFERENCES parkingticket (ParkingTicketId) 
ON DELETE CASCADE;

-- 7)Reservation
ALTER TABLE Reservation
ADD CONSTRAINT fk_parking_space_id 
FOREIGN KEY (ParkingSpaceId) 
REFERENCES ParkingSpace (ParkingSpaceId) 
ON DELETE CASCADE;

-- 8)SpotHistoryDate

ALTER TABLE SpotHistoryDate
DROP FOREIGN KEY spothistorydate_ibfk_1;

ALTER TABLE SpotHistoryDate
ADD CONSTRAINT fk_parking_spot_history_id
FOREIGN KEY (ParkingSpotHistoryId)
REFERENCES ParkingSpotHistory(ParkingSpotHistoryId)
ON DELETE CASCADE;

-- 9)UserPhoneNumber

ALTER TABLE UserPhoneNumber
ADD CONSTRAINT fk_user_id
FOREIGN KEY (UserId)
REFERENCES User(UserId)
ON DELETE CASCADE;


-- Inserting Values to the Tables

-- 1) Employee Table

INSERT INTO Employee (EmployeeId, FirstName, LastName, Email, JobTitle) VALUES

('EMP001', 'Alice', 'Smith', 'alice.smith@gmail.com', 'Parking Attendant'),
('EMP002', 'Bob', 'Johnson', 'bob.johnson@gmail.com', 'Parking Supervisor'),
('EMP003', 'Charlie', 'Brown', 'charlie.brown@gmail.com', 'Maintenance Technician'),
('EMP004', 'Diana', 'Wilson', 'diana.wilson@gmail.com', 'Customer Service Representative');

INSERT INTO Employee (EmployeeId, FirstName, LastName, Email, JobTitle) VALUES
('EMP005','Nimwsha','Yasith','nimesha@gmail.com','Security Officer'),
('EMP006','Parakrama','Dasanayaka','parakrama@gmail.com','Manager'),
('EMP007','Dilepa','Desilva','dileepa@gmail.com','Valet Parking Supervisor'),
('EMP008','Lahiru','Nisal','lahiru@gmail.com','Accountant');

INSERT INTO Employee (EmployeeId, FirstName, LastName, Email, JobTitle) VALUES
('EMP009', 'Saman', 'Perera', 'saman.perera@gmail.com', 'Parking Attendant'),
('EMP010', 'Kamal', 'Fernando', 'kamal.fernando@gmail.com', 'Parking Supervisor'),
('EMP011', 'Nilani', 'Silva', 'nilani.silva@gmail.com', 'Maintenance Technician'),
('EMP012', 'Rohan', 'Gunawardana', 'rohan.gunawardana@gmail.com', 'Customer Service Representative');

-- 2) Shift Table
INSERT INTO Shift (ShiftId, EmployeeId, ShiftTime, EndTime, ShiftDate) VALUES

('SHIFT001', 'EMP001', '08:00:00', '16:00:00', '2024-03-20'),
('SHIFT002', 'EMP002', '09:00:00', '17:00:00', '2024-03-20'),
('SHIFT003', 'EMP003', '10:00:00', '18:00:00', '2024-03-20'),
('SHIFT004', 'EMP004', '11:00:00', '19:00:00', '2024-03-20');

INSERT INTO Shift (ShiftId, EmployeeId, ShiftTime, EndTime, ShiftDate) VALUES
('SHIFT005', 'EMP005', '12:00:00','20:00:00',  '2024-03-27'),
('SHIFT006', 'EMP006', '13:00:00','21:00:00',  '2024-03-27'),
('SHIFT007', 'EMP007', '14:00:00','22:00:00',  '2024-03-27'),
('SHIFT008', 'EMP008', '15:00:00','23:00:00',  '2024-03-27');

INSERT INTO Shift (ShiftId, EmployeeId, ShiftTime, EndTime, ShiftDate) VALUES
('SHIFT009', 'EMP009', '08:00:00', '16:00:00', '2024-03-28'),
('SHIFT010', 'EMP010', '09:00:00', '17:00:00', '2024-03-28'),
('SHIFT011', 'EMP011', '10:00:00', '18:00:00', '2024-03-28'),
('SHIFT012', 'EMP003', '11:00:00', '19:00:00', '2024-03-28');

-- 3) EmployeePhoneNumber

INSERT INTO EmployeePhoneNumber (PhoneId, EmployeeId, EmployeePhoneNumber) VALUES

('PHONE001', 'EMP001', '+941234567890'),
('PHONE002', 'EMP002', '+941987654321'),
('PHONE003', 'EMP003', '+941654321890'),
('PHONE004', 'EMP002', '+941234567892');

INSERT INTO EmployeePhoneNumber (PhoneId, EmployeeId, EmployeePhoneNumber) VALUES
('PHONE005', 'EMP005', '+941121131111'),
('PHONE006', 'EMP006', '+941122222522'),
('PHONE007', 'EMP007', '+941332334333'),
('PHONE008', 'EMP008', '+941442444644');

INSERT INTO EmployeePhoneNumber (PhoneId, EmployeeId, EmployeePhoneNumber) VALUES
('PHONE009', 'EMP009', '+941553335555'),
('PHONE010', 'EMP010', '+941664446666'),
('PHONE011', 'EMP011', '+941775557777'),
('PHONE012', 'EMP002', '+941886668888');

-- 5) ParkingLot

INSERT INTO ParkingLot (ParkingLotId, TotalSpace, AvailableSpace, Location, OccupancyRate,Name) VALUES
('LOT001', 100, 50, '123 Main Street', 50.00, 'Main Street Parking Lot'),
('LOT002', 150, 75, '456 Elm Street', 50.00,'Elm Street Parking Lot'),
('LOT003', 200, 100, '789 Oak Street', 50.00,'Oak Street Parking Lot'),
('LOT004', 120, 60, '101 Pine Street',50.00,'Pine Street Parking Lot');

INSERT INTO ParkingLot (ParkingLotId, TotalSpace, AvailableSpace, Location, OccupancyRate, Name) VALUES
('LOT005', 80, 40, '222 Maple Street', 50.00, 'Maple Street Parking Lot'),
('LOT006', 170, 85, '333 Cherry Street', 50.00, 'Cherry Street Parking Lot'),
('LOT007', 190, 95, '444 Walnut Street', 50.00, 'Walnut Street Parking Lot'),
('LOT008', 110, 55, '555 Birch Street', 50.00, 'Birch Street Parking Lot');

INSERT INTO ParkingLot (ParkingLotId, TotalSpace, AvailableSpace, Location, OccupancyRate, Name) VALUES
('LOT009', 130, 65, '666 Cedar Street', 50.00, 'Cedar Street Parking Lot'),
('LOT010', 160, 80, '777 Pineapple Street', 50.00, 'Pineapple Street Parking Lot'),
('LOT011', 180, 90, '888 Orange Street', 50.00, 'Orange Street Parking Lot'),
('LOT012', 200, 100, '999 Lemon Street', 50.00, 'Lemon Street Parking Lot');

-- 4) MaintenanceRequest

INSERT INTO MaintenanceRequest (RequestId, EmployeeId, RequestedDate, ParkingLotId, Status, CompletedDate) VALUES

('REQ001', 'EMP001', '2024-03-20', 'LOT001', 'Pending', NULL),
('REQ002', 'EMP002', '2024-03-20', 'LOT002', 'In Progress', NULL),
('REQ003', 'EMP003', '2024-03-20', 'LOT003', 'Completed', '2024-03-21'),
('REQ004', 'EMP004', '2024-03-20', 'LOT004', 'Pending', NULL),
('REQ005', 'EMP001', '2024-03-19', 'LOT004', 'Pending', NULL);

INSERT INTO MaintenanceRequest (RequestId, EmployeeId, RequestedDate, ParkingLotId, Status, CompletedDate) VALUES
('REQ006', 'EMP002', '2024-03-21', 'LOT001', 'In Progress', NULL),
('REQ007', 'EMP003', '2024-03-22', 'LOT005', 'Pending', NULL),
('REQ008', 'EMP008', '2024-03-22', 'LOT003', 'In Progress', NULL),
('REQ009', 'EMP001', '2024-03-23', 'LOT005', 'Completed', '2024-03-24');

INSERT INTO MaintenanceRequest (RequestId, EmployeeId, RequestedDate, ParkingLotId, Status, CompletedDate) VALUES
('REQ010', 'EMP009', '2024-03-25', 'LOT001', 'Pending', NULL),
('REQ011', 'EMP010', '2024-03-26', 'LOT002', 'In Progress', NULL),
('REQ012', 'EMP011', '2024-03-27', 'LOT003', 'Completed', '2024-03-28'),
('REQ013', 'EMP002', '2024-03-28', 'LOT006', 'Pending', NULL),
('REQ014', 'EMP009', '2024-03-28', 'LOT005', 'Pending', NULL);

-- 6) ParkingSpace

INSERT INTO ParkingSpace (ParkingSpaceId, ParkingLotId, SpaceNumber, Status) VALUES
('SPACE001', 'LOT001', 1, 'Available'),
('SPACE002', 'LOT001', 2, 'Occupied'),
('SPACE003', 'LOT001', 3, 'Available'),
('SPACE004', 'LOT002', 1, 'Available');

INSERT INTO ParkingSpace (ParkingSpaceId, ParkingLotId, SpaceNumber, Status) VALUES
('SPACE005', 'LOT002', 2, 'Available'),
('SPACE006', 'LOT002', 3, 'Occupied'),
('SPACE007', 'LOT003', 1, 'Available'),
('SPACE008', 'LOT003', 2, 'Available');

INSERT INTO ParkingSpace (ParkingSpaceId, ParkingLotId, SpaceNumber, Status) VALUES
('SPACE009', 'LOT003', 3, 'Occupied'),
('SPACE010', 'LOT001', 2, 'Available'),
('SPACE011', 'LOT006', 3, 'Available'),
('SPACE012', 'LOT005', 1, 'Available');

-- 7) SecurityCamera

INSERT INTO SecurityCamera (SecurityCameraId, ParkingLotId, Location, Status) VALUES
('CAM001', 'LOT001', 'Entrance', 'Active'),
('CAM002', 'LOT001', 'Exit', 'Active'),
('CAM003', 'LOT002', 'Entrance', 'Active'),
('CAM004', 'LOT002', 'Exit', 'Inactive');

INSERT INTO SecurityCamera (SecurityCameraId, ParkingLotId, Location, Status) VALUES
('CAM005', 'LOT003', 'Entrance', 'Active'),
('CAM006', 'LOT003', 'Exit', 'Active'),
('CAM007', 'LOT008', 'Entrance', 'Active'),
('CAM008', 'LOT001', 'Exit', 'Inactive');

INSERT INTO SecurityCamera (SecurityCameraId, ParkingLotId, Location, Status) VALUES
('CAM009', 'LOT005', 'Entrance', 'Active'),
('CAM010', 'LOT005', 'Exit', 'Active'),
('CAM011', 'LOT006', 'Entrance', 'Active'),
('CAM012', 'LOT006', 'Exit', 'Inactive');

-- 8) ParkingLotMaintenance

INSERT INTO ParkingLotMaintenance (ParkingLotMaintenanceId, MaintenanceId, RequestId, EmployeeId) VALUES
('PLM001', 'MNT001', 'REQ001', 'EMP001'),
('PLM002', 'MNT002', 'REQ002', 'EMP002'),
('PLM003', 'MNT003', 'REQ003', 'EMP003'),
('PLM004', 'MNT004', 'REQ002', 'EMP002');

INSERT INTO ParkingLotMaintenance (ParkingLotMaintenanceId, MaintenanceId, RequestId, EmployeeId) VALUES
('PLM005', 'MNT005', 'REQ008', 'EMP001'),
('PLM006', 'MNT006', 'REQ002', 'EMP002'),
('PLM007', 'MNT007', 'REQ006', 'EMP006'),
('PLM008', 'MNT008', 'REQ007', 'EMP007');

INSERT INTO ParkingLotMaintenance (ParkingLotMaintenanceId, MaintenanceId, RequestId, EmployeeId) VALUES
('PLM009', 'MNT009', 'REQ007', 'EMP003'),
('PLM010', 'MNT010', 'REQ003', 'EMP010'),
('PLM011', 'MNT011', 'REQ010', 'EMP011'),
('PLM012', 'MNT012', 'REQ011', 'EMP012');

-- 9) ParkingSpotHistory

INSERT INTO ParkingSpotHistory (ParkingSpotHistoryId, ParkingSpaceId, Status) VALUES
('HIST001', 'SPACE001', 'Occupied'),
('HIST002', 'SPACE002', 'Available'),
('HIST003', 'SPACE003', 'Occupied'),
('HIST004', 'SPACE001', 'Available'),
('HIST005', 'SPACE002', 'Occupied');

INSERT INTO ParkingSpotHistory (ParkingSpotHistoryId, ParkingSpaceId, Status) VALUES
('HIST006', 'SPACE003', 'Available'),
('HIST007', 'SPACE002', 'Occupied'),
('HIST008', 'SPACE005', 'Available'),
('HIST009', 'SPACE006', 'Occupied');

INSERT INTO ParkingSpotHistory (ParkingSpotHistoryId, ParkingSpaceId, Status) VALUES
('HIST010', 'SPACE007', 'Available'),
('HIST011', 'SPACE005', 'Occupied'),
('HIST012', 'SPACE009', 'Available'),
('HIST013', 'SPACE010', 'Occupied'),
('HIST014', 'SPACE002', 'Occupied');

-- 10) Vehicle

INSERT INTO Vehicle (VehicleId, LicensePlate, VehicleType) VALUES
('VEH001', 'ABC123', 'Car'),
('VEH002', 'XYZ789', 'Motorcycle'),
('VEH003', 'DEF456', 'Truck'),
('VEH004', 'GHI789', 'SUV');

INSERT INTO Vehicle (VehicleId, LicensePlate, VehicleType) VALUES
('VEH005', 'JKL012', 'SUV'),
('VEH006', 'MNO345', 'Motorcycle'),
('VEH007', 'PQR678', 'Van'),
('VEH008', 'STU901', 'Car');

INSERT INTO Vehicle (VehicleId, LicensePlate, VehicleType) VALUES
('VEH009', 'VWX234', 'Truck'),
('VEH010', 'YZA567', 'Car'),
('VEH011', 'BCD890', 'SUV'),
('VEH012', 'EFG123', 'Motorcycle');

-- 11) ParkingTicket

INSERT INTO ParkingTicket (ParkingTicketId, VehicleId, ParkingLotId, TicketStatus, Reason, IssueDate) VALUES

('TICKET001', 'VEH001', 'LOT001', 'Pending', 'Unauthorized Parking', '2024-03-20'),
('TICKET002', 'VEH002', 'LOT002', 'Paid', 'Expired Meter', '2024-03-20'),
('TICKET003', 'VEH003', 'LOT003', 'Pending', 'Parking in Fire Lane', '2024-03-20'),
('TICKET004', 'VEH004', 'LOT004', 'Unpaid', 'Blocking Emergency Exit', '2024-03-20'),
('TICKET005', 'VEH002', 'LOT002', 'Paid', NULL, '2024-03-21');

INSERT INTO ParkingTicket (ParkingTicketId, VehicleId, ParkingLotId, TicketStatus, Reason, IssueDate) VALUES
('TICKET006', 'VEH005', 'LOT005', 'Pending', 'Double Parking', '2024-03-22'),
('TICKET007', 'VEH006', 'LOT006', 'Unpaid', 'Parking in Handicap Space', '2024-03-23'),
('TICKET008', 'VEH007', 'LOT007', 'Paid', 'Expired Permit', '2024-03-24'),
('TICKET009', 'VEH003', 'LOT008', 'Pending', 'Parking Outside Designated Area', '2024-03-25');

INSERT INTO ParkingTicket (ParkingTicketId, VehicleId, ParkingLotId, TicketStatus, Reason, IssueDate) VALUES
('TICKET010', 'VEH009', 'LOT001', 'Pending', 'No Parking Permit', '2024-03-22'),
('TICKET011', 'VEH010', 'LOT006', 'Unpaid', 'Double Parking', '2024-03-23'),
('TICKET013', 'VEH003', 'LOT001', 'Pending', 'Expired Registration', '2024-03-25'),
('TICKET014', 'VEH010', 'LOT006', 'Unpaid', 'Double Parking', '2024-03-24');

-- 12) Payment

INSERT INTO Payment (PaymentId, PaymentAmount, ParkingTicketId, PaymentDate, PaymentMethod) VALUES
('PAY001', '25.00', 'TICKET001', '2024-03-20', 'Credit'),
('PAY002', '10.00', 'TICKET002', '2024-03-20', 'Cash'),
('PAY003', '35.00', 'TICKET003', '2024-03-20', 'Debit'),
('PAY004', '20.00', 'TICKET004', '2024-03-20', 'Credit'),
('PAY005', '25.00', 'TICKET003', '2024-03-20', 'Debit');

INSERT INTO Payment (PaymentId, PaymentAmount, ParkingTicketId, PaymentDate, PaymentMethod) VALUES
('PAY006', '15.00', 'TICKET009', '2024-03-21', 'Cash'),
('PAY007', '30.00', 'TICKET006', '2024-03-21', 'Credit'),
('PAY008', '40.00', 'TICKET007', '2024-03-21', 'Debit'),
('PAY009', '20.00', 'TICKET008', '2024-03-21', 'Credit');

INSERT INTO Payment (PaymentId, PaymentAmount, ParkingTicketId, PaymentDate, PaymentMethod) VALUES
('PAY010', '25.00', 'TICKET003', '2024-03-25', 'Cash'),
('PAY011', '30.00', 'TICKET007', '2024-03-26', 'Credit'),
('PAY012', '40.00', 'TICKET010', '2024-03-27', 'Debit'),
('PAY013', '15.00', 'TICKET006', '2024-03-27', 'Cash');

-- 13) User

INSERT INTO User (UserId, UserName, Email, Age, BirthDay, PassWord, FirstName, LastName) VALUES

('USR001', 'john_doe', 'john.doe@gmail.com', 30, '1994-05-15', 'password123', 'John', 'Doe'),
('USR002', 'jane_smith', 'jane.smith@gmail.com', 25, '1999-10-20', 'qwerty456', 'Jane', 'Smith'),
('USR003', 'michael_johnson', 'michael.johnson@gmail.com', 35, '1989-03-25', 'pass1234', 'Michael', 'Johnson'),
('USR004', 'emily_brown', 'emily.brown@gmail.com', 28, '1996-08-05', 'abc123', 'Emily', 'Brown');

INSERT INTO User (UserId, UserName, Email, Age, BirthDay, PassWord, FirstName, LastName) VALUES
('USR005', 'sarah_miller', 'sarah.miller@gmail.com', 32, '1992-07-12', 'sarahpass123', 'Sarah', 'Miller'),
('USR006', 'david_wilson', 'david.wilson@gmail.com', 40, '1984-12-30', 'davidpass456', 'David', 'Wilson'),
('USR007', 'olivia_taylor', 'olivia.taylor@gmail.com', 22, '2002-02-18', 'oliviapass789', 'Olivia', 'Taylor'),
('USR008', 'william_anderson', 'william.anderson@gmail.com', 27, '1997-11-08', 'williampass321', 'William', 'Anderson');

INSERT INTO User (UserId, UserName, Email, Age, BirthDay, PassWord, FirstName, LastName) VALUES
('USR009', 'hannah_thomas', 'hannah.thomas@gmail.com', 29, '1995-04-03', 'hannahpass789', 'Hannah', 'Thomas'),
('USR010', 'jacob_roberts', 'jacob.roberts@gmail.com', 33, '1989-09-22', 'jacobpass456', 'Jacob', 'Roberts'),
('USR011', 'emma_jones', 'emma.jones@gmail.com', 26, '1998-11-15', 'emmapass123', 'Emma', 'Jones'),
('USR012', 'ethan_clark', 'ethan.clark@gmail.com', 31, '1993-08-10', 'ethanpass321', 'Ethan', 'Clark');

-- 14) Reservation

INSERT INTO Reservation (ReservationId, ParkingSpaceId, UserId, StartTime, EndTime, ReservationStatus, Duration) VALUES

('RES001', 'SPACE001', 'USR001', '08:00:00', '10:00:00', 'Active', '02:00:00'),
('RES002', 'SPACE002', 'USR002', '09:00:00', '11:00:00', 'Active', '02:00:00'),
('RES003', 'SPACE003', 'USR003', '10:00:00', '12:00:00', 'Cancelled', NULL),
('RES004', 'SPACE004', 'USR004', '11:00:00', '13:00:00', 'Active', '02:00:00'),
('RES005', 'SPACE003', 'USR003', '10:30:00', '01:30:00', 'Active', '03:00:00');

INSERT INTO Reservation (ReservationId, ParkingSpaceId, UserId, StartTime, EndTime, ReservationStatus, Duration) VALUES
('RES006', 'SPACE005', 'USR005', '12:00:00', '14:00:00', 'Active', '02:00:00'),
('RES007', 'SPACE006', 'USR006', '13:00:00', '15:00:00', 'Active', '02:00:00'),
('RES008', 'SPACE007', 'USR007', '14:00:00', '16:00:00', 'Active', '02:00:00'),
('RES009', 'SPACE008', 'USR008', '15:00:00', '17:00:00', 'Active', '02:00:00');

INSERT INTO Reservation (ReservationId, ParkingSpaceId, UserId, StartTime, EndTime, ReservationStatus, Duration) VALUES
('RES010', 'SPACE009', 'USR010', '08:00:00', '10:00:00', 'Active', '02:00:00'),
('RES011', 'SPACE010', 'USR011', '09:00:00', '11:00:00', 'Active', '02:00:00'),
('RES012', 'SPACE011', 'USR012', '10:00:00', '12:00:00', 'Cancelled', NULL);

-- 15) UserPhoneNumber

INSERT INTO UserPhoneNumber (UserPhoneNumberId, UserId, UserPhoneNumber) VALUES

('PHONE001', 'USR001', '+94234567890'),
('PHONE002', 'USR002', '+94987654321'),
('PHONE003', 'USR003', '+94654321890'),
('PHONE004', 'USR004', '+94789054321'),
('PHONE005','USR001' , '+94567907849');

INSERT INTO UserPhoneNumber (UserPhoneNumberId, UserId, UserPhoneNumber) VALUES
('PHONE006', 'USR002', '+94123456789'),
('PHONE007', 'USR003', '+94876543210'),
('PHONE008', 'USR006', '+94567890123'),
('PHONE009', 'USR005', '+94432109876');

INSERT INTO UserPhoneNumber (UserPhoneNumberId, UserId, UserPhoneNumber) VALUES
('PHONE010', 'USR006', '+94789012345'),
('PHONE011', 'USR007', '+94654321098'),
('PHONE012', 'USR003', '+94123456789'),
('PHONE013', 'USR009', '+94908765432'),
('PHONE014', 'USR010', '+94567890123');

-- 16) SpotHistoryDate

INSERT INTO SpotHistoryDate (DateId, ParkingSpotHistoryId, StartTime, EndTime) VALUES

('DATE001', 'HIST001', '08:00:00', '10:00:00'),
('DATE002', 'HIST002', '09:00:00', '11:00:00'),
('DATE003', 'HIST003', '10:00:00', '12:00:00'),
('DATE004', 'HIST004', '11:00:00', '13:00:00'),
('DATE005', 'HIST005', '11:00:00', '13:00:00');

INSERT INTO SpotHistoryDate (DateId, ParkingSpotHistoryId, StartTime, EndTime) VALUES
('DATE006', 'HIST006', '12:00:00', '14:00:00'),
('DATE007', 'HIST007', '13:00:00', '15:00:00'),
('DATE008', 'HIST008', '14:00:00', '16:00:00'),
('DATE009', 'HIST009', '15:00:00', '17:00:00');

INSERT INTO SpotHistoryDate (DateId, ParkingSpotHistoryId, StartTime, EndTime) VALUES
('DATE010', 'HIST010', '16:00:00', '18:00:00'),
('DATE011', 'HIST011', '17:00:00', '19:00:00'),
('DATE012', 'HIST012', '18:00:00', '20:00:00'),
('DATE013', 'HIST013', '19:00:00', '21:00:00'),
('DATE014', 'HIST014', '20:00:00', '22:00:00');

-- 17) Supervise

INSERT INTO Supervise (SupervisorId, EmployeeId, SuperviseId) VALUES 
('SP001', 'EMP002', 'SUPER001'),
('SP002', 'EMP003', 'SUPER002'),
('SP003', 'EMP004', 'SUPER003'),
('SP004', 'EMP005', 'SUPER004');

INSERT INTO Supervise (SupervisorId, EmployeeId, SuperviseId) VALUES 
('SP005', 'EMP006', 'SUPER005'),
('SP006', 'EMP007', 'SUPER006'),
('SP007', 'EMP008', 'SUPER007'),
('SP008', 'EMP009', 'SUPER008');

INSERT INTO Supervise (SupervisorId, EmployeeId, SuperviseId) VALUES 
('SP009', 'EMP010', 'SUPER009'),
('SP010', 'EMP011', 'SUPER010'),
('SP011', 'EMP012', 'SUPER011'),
('SPOO12','EMP013','SUPER013');

-- Update and Delete Operations

-- 1) Employee

UPDATE Employee
SET Email = "alice.smith123@gmail.com"
WHERE EmployeeId = 'EMP001';

DELETE FROM Employee
WHERE EmployeeId = 'EMP004';

UPDATE Employee
SET LastName = "Kumara"
where EmployeeId = 'EMP008';

DELETE FROM Employee
WHERE EmployeeId = 'EMP008';

-- 2) Shift

UPDATE Shift
SET ShiftDate = '2024-03-21'
WHERE ShiftId = 'SHIFT001';

DELETE FROM Shift
WHERE ShiftId = 'SHIFT004';

UPDATE Shift
SET ShiftTime = '14:30:00'
WHERE ShiftId = 'SHIFT005';

DELETE FROM Shift
WHERE ShiftId = 'SHIFT008';

-- 3) EmployeePhoneNumber

UPDATE EmployeePhoneNumber
SET EmployeePhoneNumber = +941234567823
WHERE PhoneId = 'PHONE001';

DELETE FROM EmployeePhoneNumber
WHERE PhoneId = 'PHONE004';

UPDATE EmployeePhoneNumber
SET EmployeePhoneNumber = +94121234523
WHERE PhoneId = 'PHONE005';

DELETE FROM EmployeePhoneNumber
WHERE PhoneId = 'PHONE008';

-- 4) MaintenanceRequest

UPDATE MaintenanceRequest
SET RequestedDate = '2024-03-19',
    Status = 'Completed',
    CompletedDate = '2024-03-20'
WHERE RequestId = 'REQ001';

DELETE FROM MaintenanceRequest
WHERE RequestId = 'REQ005';

UPDATE MaintenanceRequest
SET RequestedDate = '2024-03-21',
    Status = 'Completed',
    CompletedDate ='2024-03-22'
WHERE RequestId = 'REQ006';

DELETE FROM MaintenanceRequest
WHERE RequestId = 'REQ009';

-- 5) ParkingLot

UPDATE ParkingLot
SET AvailableSpace = 25
WHERE ParkingLotId = 'LOT001';

DELETE FROM ParkingLot
WHERE ParkingLotId = 'LOT004';

UPDATE ParkingLot
SET TotalSpace = 200
WHERE ParkingLotId = 'LOT005';

DELETE FROM ParkingLot
WHERE ParkingLotId = 'LOT007';

-- 6) ParkingSpace

UPDATE ParkingSpace
SET Status = 'Occupied'
WHERE ParkingSpaceId = 'SPACE001';

DELETE FROM ParkingSpace
WHERE ParkingSpaceId = 'SPACE004';

UPDATE ParkingSpace
SET SpaceNumber = '1'
WHERE ParkingSpaceId = 'SPACE005';

DELETE FROM ParkingSpace
WHERE ParkingSpaceId = 'SPACE008';

-- 7)SecurityCamera

UPDATE SecurityCamera
SET Status ='Inactive'
WHERE  SecurityCameraId = 'CAM002';

DELETE FROM SecurityCamera
WHERE SecurityCameraId = 'CAM004';

UPDATE SecurityCamera
SET Status ='Inactive'
WHERE  SecurityCameraId = 'CAM005';

DELETE FROM SecurityCamera
WHERE SecurityCameraId = 'CAM008';

-- 8) ParkingLotMaintenance

UPDATE ParkingLotMaintenance
SET EmployeeId = 'EMP003'
WHERE ParkingLotMaintenanceId = 'PLM002';

DELETE FROM ParkingLotMaintenance
WHERE ParkingLotMaintenanceId = 'PLM004';

UPDATE parkinglotmaintenance
SET EmployeeId = 'EMP005'
WHERE ParkingLotMaintenanceId = 'PLM005';

DELETE FROM ParkingLotMaintenance
WHERE ParkingLotMaintenanceId = 'PLM008';

-- 9) ParkingSpotHistory

UPDATE ParkingSpotHistory
SET Status = 'Available'
WHERE ParkingSpotHistoryId = 'HIST001';

DELETE FROM ParkingSpotHistory
WHERE ParkingSpotHistoryId = 'HIST004';

UPDATE ParkingSpotHistory
SET Status = 'Occupied'
WHERE ParkingSpotHistoryId = 'HIST005';

DELETE FROM ParkingSpotHistory
WHERE ParkingSpaceId = 'HIST009';

-- 10) Vehicle

UPDATE Vehicle
SET VehicleType = 'Van'
WHERE VehicleId = 'VEH001';

DELETE FROM Vehicle
WHERE VehicleId = 'VEH004';

UPDATE Vehicle
SET VehicleType = 'Van'
WHERE VehicleId = 'VEH005';

DELETE FROM Vehicle
WHERE VehicleId = 'VEH008';

-- 11) ParkingTicket

UPDATE ParkingTicket
SET TicketStatus = 'Paid',
    Reason = NULL
 WHERE ParkingTicketId = 'TICKET001';

DELETE FROM ParkingTicket
WHERE ParkingTicketId = 'TICKET005';

UPDATE ParkingTicket
SET TicketStatus = 'Pending',
    Reason = NULL
 WHERE ParkingTicketId = 'TICKET006';

DELETE FROM ParkingTicket
WHERE ParkingTicketId = 'TICKET009';

-- 12) payment

UPDATE Payment
SET PaymentMethod ='Cash'
WHERE PaymentId = 'PAY001';

DELETE FROM Payment
WHERE PaymentId = 'PAY005';

UPDATE Payment
SET PaymentMethod ='Cash'
WHERE PaymentId = 'PAY007';

DELETE FROM Payment
WHERE PaymentId = 'PAY008';

-- 13) User

UPDATE User
SET AGE = 31,
	BirthDay = '1995-05-15'
WHERE UserId = 'USR001';

DELETE FROM User
WHERE UserId = 'USR004';

UPDATE User
SET AGE = 28,
	BirthDay = '1996-08-15'
WHERE UserId = 'USR005';

DELETE FROM User
WHERE UserId = 'USR008';

-- 14) Reservation

UPDATE Reservation
SET ReservationStatus = 'Cancelled'
WHERE ReservationId ='RES001';

DELETE FROM Reservation
WHERE ReservationId = 'RES005';

UPDATE Reservation
SET ReservationStatus = 'Cancelled'
WHERE ReservationId ='RES006';

DELETE FROM Reservation
WHERE ReservationId = 'RES008';

-- 15) UserPhoneNumber

UPDATE UserPhoneNumber
SET UserId = 'USR002'
WHERE UserPhoneNumberId = 'PHONE001';

DELETE FROM UserPhoneNumber
WHERE UserPhoneNumberId = 'PHONE005';

UPDATE UserPhoneNumber
SET UserPhoneNumber = '+9498764353'
WHERE UserPhoneNumberId = 'PHONE006';

DELETE FROM UserPhoneNumber
WHERE UserPhoneNumberId = 'PHONE009';

-- 16)SpotHistoryDate

UPDATE SpotHistoryDate
SET StartTime = '07:00:00'
WHERE DateId = 'DATE001';

DELETE FROM SpotHistoryDate
WHERE DateId = 'DATE005';

UPDATE SpotHistoryDate
SET EndTime = '16:00:00'
WHERE DateId = 'DATE006';

DELETE FROM SpotHistoryDate
WHERE DateId = 'DATE009';

-- 17 Supervise

UPDATE Supervise
SET SuperviseId = NULL
WHERE SupervisorId = 'SP001';

DELETE FROM Supervise
WHERE SupervisorId = 'SP004';

UPDATE Supervise
SET SuperviseId = 'SUPER009'
WHERE SupervisorId = 'SP005';

DELETE FROM Supervise
WHERE SupervisorId = 'SP008';

-- Fundamental Operations

-- 1) SELECT OPERATION

-- Select all columns from the Employee table
SELECT * FROM Employee;

-- Select specific columns from the Shift table
SELECT ShiftId, EmployeeId, ShiftTime FROM Shift WHERE ShiftDate = '2024-03-20';

-- 2)PROJECTION OPERATION

-- Project only FirstName and LastName from Employee table
SELECT FirstName, LastName FROM Employee;

-- Project only VehicleId and LicensePlate from Vehicle table
SELECT VehicleId, LicensePlate FROM Vehicle;

-- 3) Creating a user view 

-- Create a view to display active reservations along with user details
CREATE VIEW ActiveReservations AS
SELECT R.ReservationId, R.StartTime, R.EndTime, R.ReservationStatus, U.UserName, U.Email
FROM Reservation R
INNER JOIN User U ON R.UserId = U.UserId -- used the INNER JOIN for make more convinent
WHERE R.ReservationStatus = 'Active';

-- displaying it

SELECT * FROM ActiveReservations;

-- 4) RENAMING OPERATION

-- Rename column 'ParkingSpotHistoryId' to 'HistoryId' in ParkingSpotHistory table
ALTER TABLE ParkingSpotHistory RENAME COLUMN ParkingSpotHistoryId TO HistoryId;

-- displaying

SELECT * FROM ParkingSpotHistory;


-- 5) Cartisean Product

-- Cartesian product of Employee and Shift tables
SELECT * FROM Employee, Shift;

-- Cartesian product of Employee and User tables (Using Cross Join Keyword)
SELECT * FROM Employee CROSS JOIN User;

-- 6) Like Opeartor

-- Find employees whose first name starts with 'A'
SELECT * FROM Employee WHERE FirstName LIKE 'A%';

-- Find users whose username contains 'smith'
SELECT * FROM User WHERE UserName LIKE 'smith%';

-- 7) Aggregation

-- Calculate total number of available spaces in all parking lots (SUM Operator)
SELECT SUM(AvailableSpace) AS TotalAvailableSpaces FROM ParkingLot;




-- Complex Quearies

-- 1) UNION

-- Selecting employees' names and job titles from two different shifts
SELECT FirstName, LastName, JobTitle
FROM Employee
JOIN Shift ON Employee.EmployeeId = Shift.EmployeeId
WHERE ShiftDate = '2024-03-20'

UNION

SELECT FirstName, LastName, JobTitle
FROM Employee
JOIN Shift ON Employee.EmployeeId = Shift.EmployeeId
WHERE ShiftDate = '2024-03-27';

-- 2) INTERSECT

SELECT EmployeeId, FirstName, LastName
FROM Employee
WHERE JobTitle = 'Parking Attendant'

INTERSECT

SELECT EmployeeId, FirstName, LastName
FROM Employee
WHERE EmployeeId IN (
    SELECT EmployeeId
    FROM Shift
    WHERE ShiftDate = '2024-03-28'
);


-- 3) SET-DIFFERENCE

SELECT EmployeeId, FirstName, LastName
FROM Employee
WHERE JobTitle = 'Parking Attendant'

EXCEPT

SELECT EmployeeId, FirstName, LastName
FROM Employee
WHERE EmployeeId IN (
    SELECT EmployeeId
    FROM Shift
    WHERE ShiftDate = '2024-03-20'
);

-- 4) DIVISION

SELECT EmployeeId, FirstName, LastName
FROM Employee e
WHERE NOT EXISTS (
    SELECT *
    FROM Shift s
    WHERE e.EmployeeId = s.EmployeeId
    AND ShiftDate = '2024-03-20'
);


-- 5) INNER-JOIN

SELECT e.EmployeeId, e.FirstName, e.LastName, s.ShiftTime, s.EndTime
FROM Employee e
INNER JOIN 
Shift s ON e.EmployeeId = s.EmployeeId;

-- 6) NATURAL JOIN

SELECT e.EmployeeId, e.FirstName, e.LastName, s.ShiftTime, s.EndTime
FROM Employee e
NATURAL JOIN 
Shift s;

-- 7) LEFT OUTER JOIN

SELECT e.EmployeeId, e.FirstName, e.LastName, s.ShiftTime, s.EndTime
FROM Employee e
LEFT OUTER JOIN
Shift s ON e.EmployeeId = s.EmployeeId;


-- 8) RIGHT OUTER JOIN

SELECT e.EmployeeId, e.FirstName, e.LastName, s.ShiftTime, s.EndTime
FROM Employee e
RIGHT OUTER JOIN
Shift s ON e.EmployeeId = s.EmployeeId;

-- 9) FULL OUTER JOIN

SELECT e.EmployeeId, e.FirstName, e.LastName, s.ShiftTime, s.EndTime
FROM Employee e
LEFT JOIN 
Shift s ON e.EmployeeId = s.EmployeeId;

-- 10) OUTER JOIN

SELECT e.EmployeeId, e.FirstName, e.LastName, s.ShiftTime, s.EndTime
FROM Employee e
LEFT JOIN 
Shift s ON e.EmployeeId = s.EmployeeId;

-- 11) INDEPENDENT NESTED QUERY

SELECT EmployeeId, FirstName, LastName
FROM Employee
WHERE EmployeeId IN (
    SELECT EmployeeId
    FROM Shift
    WHERE ShiftDate = '2024-03-20'
);

-- 12) CORELATED NESTED QUERY

SELECT e.EmployeeId, e.FirstName, e.LastName
FROM Employee e
WHERE EXISTS (
    SELECT *
    FROM Shift s
    WHERE s.EmployeeId = e.EmployeeId
    AND ShiftDate = '2024-03-27'
);

-- TUNING

EXPLAIN 
SELECT e.FirstName, e.LastName, s.ShiftTime, s.EndTime, pr.Name AS ParkingLotName
FROM Employee e, Shift s, MaintenanceRequest m, ParkingLot pr
WHERE 
    e.EmployeeId = s.EmployeeId
    AND e.EmployeeId = m.EmployeeId
    AND m.ParkingLotId = pr.ParkingLotId
    AND e.JobTitle = 'Parking Attendant'

UNION

SELECT e.FirstName, e.LastName, s.ShiftTime, s.EndTime, pr.Name AS ParkingLotName
FROM Employee e, Shift s, MaintenanceRequest m, ParkingLot pr
WHERE 
    e.EmployeeId = s.EmployeeId
    AND e.EmployeeId = m.EmployeeId
    AND m.ParkingLotId = pr.ParkingLotId
    AND e.JobTitle = 'Parking Supervisor';


-- 2)INNER JOIN TUNING

SHOW INDEX FROM ParkingLot;

EXPLAIN SELECT pr.Name AS ParkingLotName, mr.RequestedDate, mr.Status
FROM ParkingLot pr
INNER JOIN MaintenanceRequest mr ON pr.ParkingLotId = mr.ParkingLotId
WHERE pr.Location = '123 Main Street' AND mr.Status = 'Pending';

-- 3)LEFT OUTER JOIN TUNING

EXPLAIN 
SELECT e.FirstName, e.LastName, s.ShiftTime, s.EndTime, s.ShiftDate
FROM Employee e
LEFT JOIN Shift s ON e.EmployeeId = s.EmployeeId;

SHOW INDEX FROM Employee;
SHOW INDEX FROM Shift;

-- 4) RIGHT OUTER JOIN TUNING

CREATE INDEX idx_employee_id ON EmployeePhoneNumber(EmployeeId);
CREATE INDEX idx_employee_id ON Employee(EmployeeId);

EXPLAIN SELECT e.FirstName, e.LastName, ep.EmployeePhoneNumber
FROM EmployeePhoneNumber ep
RIGHT JOIN Employee e ON e.EmployeeId = ep.EmployeeId;

SHOW INDEX FROM EmployeePhoneNumber;
SHOW INDEX FROM Employee;


-- 5) OUTER UNION TUNING

EXPLAIN 
SELECT ParkingLotId, Name, Location, OccupancyRate
FROM ParkingLot p1
WHERE EXISTS (
    SELECT 1
    FROM ParkingLot p2
    WHERE p2.ParkingLotId = p1.ParkingLotId
    GROUP BY p2.ParkingLotId
    HAVING MAX(p2.OccupancyRate) > 50
)
UNION ALL
SELECT ParkingLotId, Name, Location, OccupancyRate
FROM ParkingLot p3
WHERE NOT EXISTS (
    SELECT 1
    FROM ParkingLot p4
    WHERE p4.ParkingLotId = p3.ParkingLotId
    GROUP BY p4.ParkingLotId
    HAVING MAX(p4.OccupancyRate) > 50
);

-- 6) DIVISION TUNING

SHOW INDEX FROM Reservation;

EXPLAIN 
SELECT DISTINCT r.ReservationId, r.UserId
FROM Reservation r
WHERE NOT EXISTS (
    SELECT ps.ParkingSpaceId
    FROM ParkingSpace ps
    WHERE NOT EXISTS (
        SELECT pt.ParkingTicketId
        FROM ParkingTicket pt
        WHERE pt.VehicleId = 'VEH001'
        AND pt.ParkingLotId = 'LOT001'
        AND pt.ParkingLotId = ps.ParkingLotId
    )
);
-- 7) INTERSECTION TUNING

EXPLAIN 
SELECT EmployeeId, FirstName, LastName
FROM Employee
INTERSECT
SELECT EmployeeId, FirstName, LastName
FROM Employee
WHERE JobTitle = 'Parking Attendant';

SHOW INDEX FROM Employee;
SHOW INDEX FROM Shift;

-- 8) SET DIFFERENCE TUNING

EXPLAIN 
SELECT EmployeeId, FirstName, LastName
FROM Employee
EXCEPT
SELECT e.EmployeeId, e.FirstName, e.LastName
FROM Employee e
JOIN Shift s ON e.EmployeeId = s.EmployeeId;

SHOW INDEX FROM Employee;
SHOW INDEX FROM Shift;

-- 9) INDEPENDENT QUERY TUNING

EXPLAIN 
SELECT e.FirstName, e.LastName, s.ShiftTime, s.EndTime, s.ShiftDate
FROM Employee e
JOIN Shift s ON e.EmployeeId = s.EmployeeId
WHERE s.ShiftDate = '2024-03-20';

-- 10) CORRELATED NESTED QUERY TUNING

CREATE INDEX idx_user_id ON User(UserId);
CREATE INDEX idx_parking_space_id ON ParkingSpace(ParkingSpaceId);

EXPLAIN 
SELECT DISTINCT r.ReservationId, r.UserId
FROM Reservation r
WHERE NOT EXISTS (
    SELECT ps.ParkingSpaceId
    FROM ParkingSpace ps
    WHERE NOT EXISTS (
        SELECT pt.ParkingTicketId
        FROM ParkingTicket pt
        WHERE pt.VehicleId = 'VEH001'
        AND pt.ParkingLotId = 'LOT001'
        AND pt.ParkingLotId = ps.ParkingLotId
    )
);

