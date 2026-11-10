-- q1
create database StudentNumber_DATA6222_ExamQ1;
use StudentNumber_DATA6222_ExamQ1;

create table Client (
  ClientID int primary key,
  ClientFullName varchar(150) not null,
  ClientContact varchar(13) not null unique
);

create table Venue (
  VenueID varchar(5) primary key,
  VenueName varchar(150) not null,
  VenueAddress varchar(150) unique not null
);

create table Booking (
  BookingID varchar(6) primary key,
  ClientID int not null,
  VenueID varchar(5) not null,
  foreign key (ClientID) references Client (ClientID),
  foreign key (VenueID) references Venue (VenueID),
  EventStartDate date,
  EventEndDate date,
  NumberOfAttendees int
);

insert into CLIENT
values ("111222", "Lindiwe Mokoena", "072 4567 891"), 
       ("222333", "Mark Peterson", "083 9123 456"), 
       ("333444", "Ayanda Dlamini", "074 6789 321"), 
       ("444555", "Sipho Khumalo", "071 3456 789"), 
       ("555666", "Rachel Adams", "082 9876 543");

insert into VENUE
values ("V0001", "Grand Hall", "45 Summit Road, Johannesburg"), 
	   ("V0002", "City Convention Centre", "10 Market Street, Durban"), 
       ("V0003", "Riverside Pavilion", "88 River Road, Pretoria"), 
       ("V0004", "Coastal Conference Hall", "12 Beach Avenue, Gqeberha"), 
       ("V0005", "Mountain View Centre", "5 Peak Drive, Cape Town");
       
insert into BOOKING (BookingID, ClientID, VenueID, EventStartDate, EventEndDate, NumberOfAttendees)
values ("B00007", 111222, "V0001", "2026-09-30", "2026-10-01", 120), 
       ("B00005", 222333, "V0005", "2026-09-29", "2026-10-02", 40), 
       ("B00006", 222333, "V0004", "2026-10-01", "2026-10-07", 200), 
       ("B00002", 444555, "V0002", "2026-09-28", "2026-10-01", 150), 
       ("B00003", 555666, "V0001", "2026-09-29", "2026-10-02", 300), 
       ("B00001", 111222, "V0002", "2026-09-20", "2026-09-30", 80), 
       ("B00004", 222333, "V0004", "2026-09-29", "2026-10-01", 60);

-- q1.1
create view LargeBOOKINGs as select Client.ClientID, Venue.VenueID, BOOKING.EventStartDate, BOOKING.EventEndDate, BOOKING.NumberOfAttendees from Client 
join BOOKING on Client.ClientID = BOOKING.ClientID join Venue on BOOKING.VenueID = Venue.VenueID where BOOKING.EventStartDate like "2026%" 
and BOOKING.NumberOfAttendees >= 100;
select * from LargeBOOKINGs;

-- q1.2
delimiter $$
create procedure FindBOOKINGs (id varchar(5))
begin
select Client.ClientFullName, Client.ClientContact, BOOKING.EventStartDate, BOOKING.EventEndDate, BOOKING.NumberOfAttendees from Client
join BOOKING on Client.ClientID = BOOKING.ClientID join Venue on BOOKING.VenueID = Venue.VenueID where Venue.VenueID = id 
order by Client.ClientFullName asc;
end $$
delimiter ;
call FindBOOKINGs("V0002");

-- q1.3
alter table Venue add column BOOKING_STATUS varchar(50);
update Venue set BOOKING_STATUS = "Bookings exist" where Venue.VenueID = "V0001" and Venue.VenueName = "Grand Hall";
update Venue set BOOKING_STATUS = "Bookings exist" where Venue.VenueID = "V0002" and Venue.VenueName = "City Convention Centre";
update Venue set BOOKING_STATUS = "Bookings exist" where Venue.VenueID = "V0004" and Venue.VenueName = "Coastal Conference Hall";
update Venue set BOOKING_STATUS = "Bookings exist" where Venue.VenueID = "V0005" and Venue.VenueName = "Mountain View Centre";
update Venue set BOOKING_STATUS = "No bookings exist" where Venue.VenueID = "V0003";
select * from Venue;

-- q1.4
select Venue.VenueName, sum(NumberOfAttendees) as "TOTAL ATTENDEES" from Venue left join BOOKING on Venue.VenueID = BOOKING.VenueID
group by Venue.VenueName order by sum(NumberOfAttendees) desc;

-- q1.5
select Venue.VenueName from Venue left join BOOKING on Venue.VenueID = BOOKING.VenueID where BOOKING.VenueID is null group by Venue.VenueName ;

-- q2.1
create table equipment (
  equipment_id varchar(5) not null primary key,
  equipment_name varchar(40) not null
);

create table warehouse (
  warehouse_id varchar(5) not null primary key,
  warehouse_name varchar(20) not null,
  address varchar(40) not null
);

create table availability (
  primary key (equipment_id, warehouse_id),
  equipment_id varchar(5) not null,
  warehouse_id varchar(5) not null,
  foreign key (equipment_id) references equipment(equipment_id),
  foreign key (warehouse_id) references warehouse(warehouse_id),
  quantity smallint not null
);

-- q2.2
insert into equipment 
values ("E001", "Football Nets"), 
       ("E002", "Training Cones"), 
       ("E003", "Cricket Bats"), 
       ("E004", "Tennis Rackets"), 
       ("E005", "Gym Mats");

insert into warehouse
values ("W001", "Central Sports Depot", "15 Loop Street, Cape Town"), 
       ("W002", "Northern Supplies", "88 Church Street, Polokwane"), 
       ("W003", "Coastal Storage", "44 Marine Road, Durban"), 
       ("W004", "Inland Hub", "9 Park Avenue, Bloemfontein"), 
       ("W005", "Eastern Depot", "61 Oxford Street, East London");
       
insert into availability
values ("E002", "W001", 20), 
       ("E002", "W004", 12), 
       ("E003", "W005", 7), 
       ("E004", "W003", 9), 
       ("E004", "W001", 14);
       
-- q2.3
alter table availability add column stock_ordered smallint;

-- q2.4
update availability set stock_ordered = 3 where equipment_id = "E004" and warehouse_id = "W003";

-- q2.5
select equipment.equipment_name from equipment left join availability on equipment.equipment_id = availability.equipment_id where availability.equipment_id is null 
group by equipment.equipment_name order by equipment.equipment_name asc;

-- q2.6
select equipment.equipment_name, sum(availability.quantity) as TOTAL_AVAILABLE from equipment left join availability on equipment.equipment_id = availability.equipment_id 
group by equipment.equipment_name order by equipment.equipment_name asc;

-- q2.7
select warehouse.warehouse_name, warehouse.address, equipment.equipment_name, availability.quantity from warehouse
join availability on warehouse.warehouse_id = availability.warehouse_id join equipment on availability.equipment_id = equipment.equipment_id
where equipment.equipment_id = "E002" order by equipment.equipment_name limit 1;