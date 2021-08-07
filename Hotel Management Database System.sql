/* 
IS 620 - Team 4: Stephen Rule, Akanksha Pramod Vagal, Babajide Omobo, Geethika Sabbineni, Medha Kunnath

Note:
select * from product_component_version;

Oracle Database 11g Enterprise Edition: 11.2.0.1.0
PL/SQL: 11.2.0.1.0
*/

--Server Output ON
set serveroutput ON;

/* Drop Triggers */
drop trigger hotel_trigger;         --drop trigger for hotel
drop trigger customer_trigger;      --drop trigger for customer 
drop trigger rsv_trig;              --drop trigger for reservation
drop trigger rs_sv_trig;            --drop trigger for reserved_services
drop trigger sv_trig;               --drop trigger for services
drop trigger rp_trig;               --drop trigger for reservation_pricing

/* Drop Sequence */
drop sequence hotel_id_seq;         --drop sequence for hotel
drop sequence customer_id_seq;      --drop sequence for customer
drop sequence rsv_increment_1;      --drop sequence for reservation
drop sequence rs_sv_increment_1;    --drop sequence for reservation_services
drop sequence sv_increment_1;       --drop sequence for services
drop sequence rp_increment_1;       --drop sequence for reservation_pricing

/* Drop Tables */
drop table Reserved_Services;       --drop table for reserved_services
drop table Reservation;             --drop table for reservation
drop table Services;                --drop table for services
drop table Reservation_Pricing;     --drop table for reservation_pricing
drop table Customer;                --drop table for customer
drop table Hotel;                   --drop table for hotel

/* Drop Procedures and Functions */
drop procedure add_hotel;                  -- Member 1 Problem 1
drop procedure find_hotel;                 -- Member 1 Problem 2
drop procedure sell_hotel;                 -- Member 1 Problem 3
drop procedure hotel_state_report;         -- Member 1 Problem 4

drop procedure get_avail_rooms;            -- Member 2 Problem 5
drop procedure find_res;                   -- Member 2 Problem 6
drop procedure Cancel_reservation;         -- Member 2 Problem 7
drop procedure show_cancellations;         -- Member 2 Problem 8

drop procedure get_rooms_available;        -- Member 3 Problem 9 (Note: Updated from Jide)
drop procedure change_reservation;         -- Member 3 Problem 9 (Note: Updated from Jide)
drop procedure get_reservation;            -- Member 3 Problem 10 (Note: Updated from Stephen)
drop procedure f_guest;                    -- Member 3 Problem 11 (Note: Updated from Stephen)
drop procedure monthly_income;             -- Member 3 Problem 12 (Note: Updated from Medha)

drop procedure add_service;                -- Member 4 Problem 13
drop procedure reserved_services_report;   -- Member 4 Problem 14
drop function get_serviceID;               -- Member 4 Problem 15
drop procedure get_reservations;           -- Member 4 Problem 15
drop procedure service_report;             -- Member 4 Problem 15
drop procedure service_income;             -- Member 4 Problem 16

drop procedure add_room;                   -- Member 5 Problem 17
drop procedure rooms_available;            -- Member 5 Problem 18
drop procedure checkout_report;            -- Member 5 Problem 19
drop procedure income_report;              -- Member 5 Problem 20

/* Create Hotel Tables */
create table Hotel(hid int not null, hname varchar(128), hstreet varchar(128), hcity varchar(128), hstate varchar(128), hzip int, 
                   hphone varchar(12), hstatus varchar(4), sg_qty int, db_qty int, st_qty int, cf_qty int, primary key (hid));

/* Sequence for Hotel */
create sequence hotel_id_seq
  start with 1
  increment by 1
  cache 100;

/* Trigger for Hotel */
create trigger hotel_trigger
  before insert on Hotel
  for each row
begin
  select hotel_id_seq.nextval
  into :new.hid
  from dual;
end;
/

/* Create Customer Table */
create table Customer (cid int, cname varchar(128), cstreet varchar(128), ccity varchar(128), cstate varchar(128), czip int, cphone varchar(12), creditcard varchar(19), primary key (cid));

/* Sequence for Customer */
create sequence customer_id_seq
  start with 1
  increment by 1
  cache 100;

/* Trigger for Customer */
create trigger customer_trigger
  before insert on Customer
  for each row
begin 
  select customer_id_seq.nextval
  into :new.cid
  from dual;
end;
/

 --Creating table for Reservation_Pricing                  
create table Reservation_Pricing (rp_id int, rm_typ varchar(30), season varchar(3), price int, primary key(rp_id));

/*Creating sequence for Reservation_Pricing Table*/
CREATE SEQUENCE rp_increment_1
  START WITH 1
  INCREMENT BY 1
  CACHE 10;

/*Creating trigger for Reservation_Pricing table primary key*/
 CREATE TRIGGER rp_trig
  BEFORE INSERT ON reservation_pricing
  FOR EACH ROW
BEGIN
  SELECT rp_increment_1.nextval
    INTO :new.rp_id
    FROM dual;
END;
/

--Creating table for services
create table Services (srv_id int, srv_name varchar(30), srv_cst int, primary key(srv_id));

/*Creating sequence for Services Table*/
CREATE SEQUENCE sv_increment_1
  START WITH 1
  INCREMENT BY 1
  CACHE 10;

/*Creating trigger for Services table primary key*/
 CREATE TRIGGER sv_trig
  BEFORE INSERT ON services
  FOR EACH ROW
BEGIN
  SELECT sv_increment_1.nextval
    INTO :new.srv_id
    FROM dual;
END;
/

/*Creating Reservation table*/
create table Reservation(rsv_id int not null, cid int not null, hid int not null, gname varchar(128) not null, sg_qty int, db_qty int, st_qty int, cf_qty int, rsv_date date default sysdate, chkin date,
chkout date, season varchar(3), rsv_status varchar(16), primary key(rsv_id), foreign key (cid) references customer(cid), foreign key(hid) references hotel(hid),
constraint vd_rm check(sg_qty+db_qty+st_qty+cf_qty >= 1),
constraint vd_sg_qty check(sg_qty >= 0),
constraint vd_db_qty check(db_qty >= 0),
constraint vd_st_qty check(st_qty >= 0),
constraint vd_cf_qty check(cf_qty >= 0),
constraint vd_rsv check(rsv_status in ('Cancelled','Booked','Completed')));

/*Creating sequence for Reservation Table*/
CREATE SEQUENCE rsv_increment_1
  START WITH 1
  INCREMENT BY 1
  CACHE 10;

/*Creating trigger for Reservation table primary key*/
 CREATE TRIGGER rsv_trig
  BEFORE INSERT ON Reservation
  FOR EACH ROW
BEGIN
  SELECT rsv_increment_1.nextval
    INTO :new.rsv_id
    FROM dual;
END;
/

/*Creating Reserved Services table*/
create table Reserved_services(
rs_id int,
rsv_id int not null,
srv_id int not null,
srv_date date not null,
sv_qty int,
primary key(rs_id),
foreign key(rsv_id) references Reservation(rsv_id),
foreign key(srv_id) references Services(srv_id)
);

/*Creating sequence for Reserved_Services Table*/
CREATE SEQUENCE rs_sv_increment_1
  START WITH 1
  INCREMENT BY 1
  CACHE 10;

/*Creating trigger for Reserved_Services table primary key*/
 CREATE TRIGGER rs_sv_trig
  BEFORE INSERT ON Reserved_services
  FOR EACH ROW
BEGIN
  SELECT rs_sv_increment_1.nextval
    INTO :new.rs_id
    FROM dual;
END;
/

/* Inserting Data into Hotel*/
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Holiday Inn Express Baltimore-BWI Airport West',  '7481 Ridge Rd', 'Hanover', 'MD', '21076', '410-684-3388', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Pier 5 Hotel Baltimore, Curio Collection by Hilton', '711 Eastern Ave', 'Baltimore', 'MD', '21202', '410-539-2000', 'sold', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Ocean Enclave by Hilton Grand Vacations', '1600 N Ocean Blvd', 'Myrtle Beach', 'SC', '29577', '843-848-1600', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Bay Lake Tower at Disneys Contemporary Resort', '4600 N World Dr', 'Lake Buenva Vista', 'FL', '32830', '407-824-1000', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Country Inn and Suites by Radisson, Annapolis', '2600 Housley Rd', 'Annapolis', 'MD', '21401', '410-571-6700', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Hampton Inn Weston', '76 Hospitality Way', 'Weston', 'WV', '26452', '304-997-8750', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Hotel Hendricks', '25 W 38th St', 'New York', 'NY', '10018', '212-433-3800', 'sold', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Origin Hotel Lexington', '4174 Rowan', 'Lexington', 'KY', '40517', '859-245-0400', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Fairfield Inn and Suites by Marriott Wichita Downtown', '525 S Main St', 'Wichita', 'KS', '67202', '316-201-1400', 'open', 50, 20, 5, 2);
insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) values('Midland Railroad Hotel and Restaurant', '414 26th St', 'Wilson', 'KS', '67490', '785-658-2284', 'open', 50, 20, 5, 2);

/* Inserting Data into Customer */
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Babajide Omobo', '251 Princess Drive', 'Lewis Center', 'OH', '43035', '594-810-2076', '3578-9971-2468-8753');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Stephen Rule', '862 South Arlington St.', 'Chelmsford', 'MA', '11824', '398-909-1391', '1350-3801-7585-9160');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Medha Kunnath', '60 Chapel Lane', 'Tiffin', 'OH', 44883, '522-765-0798', '3324-4343-1032-8512');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Geethika Sabbineni', '64 Andover Ave.', 'Glen Allen', 'VA', '23059', '975-899-0937', '7180-2168-9986-3879');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Dr George Karabatis', '7 Oak Meadow Drive', 'Shelbyville', 'TN', '37160', '331-721-3731', '0695-0092-7544-0361');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Akanksha Vagal', '169 Evergreen Street', 'Sterling Heights', 'MI', '48310', '597-854-0865', '5800-8837-7421-1507');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Joe Biden', '90 Logan Road', 'Boston', 'MA', '22127', '444-816-5948', '7311-4142-4634-5959');
insert into Customer (cname, cstreet, ccity, cstate, czip, cphone, creditcard) values('Steve Rogers', '357 Buttonwood Ave.', 'Lake Mary', 'FL', '32746', '572-241-0547', '5083-2496-5078-5208');

/* Inserting Data into Reservation_Pricing*/
insert into Reservation_Pricing(rm_typ,season,price) values ('Single','OFF','100');
insert into Reservation_Pricing(rm_typ,season,price) values ('Single','ON','300');
insert into Reservation_Pricing(rm_typ,season,price) values ('Double','OFF','200');
insert into Reservation_Pricing(rm_typ,season,price) values ('Double','ON','500');
insert into Reservation_Pricing(rm_typ,season,price) values ('Suite','OFF','500');
insert into Reservation_Pricing(rm_typ,season,price) values ('Suite','ON','900');
insert into Reservation_Pricing(rm_typ,season,price) values ('Conference','OFF','1000');
insert into Reservation_Pricing(rm_typ,season,price) values ('Conference','ON','5000');

/* Inserting Data into Services*/
insert into Services (srv_name, srv_cst) values('Restaurant services','20');
insert into Services (srv_name, srv_cst) values('Pay_per_view movies','5');
insert into Services (srv_name, srv_cst) values('Laundry services','10');

/*Inserting data into Reservation table*/
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (1,5,'Babajide Omobo',1,0,0,0, date '2020-04-01', date '2020-05-02', date '2020-05-08','ON','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (3,2,'Stephen Rule',1,0,2,0, date '2019-02-01', date '2019-03-05', date '2019-04-10','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,7,'Medha Kunnath',1,0,2,2, date '2020-12-15', date '2021-01-05', date '2021-02-12','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (6,4,'Akanksha Vagal',0,3,1,1, date '2021-02-01', date '2021-03-16', date '2021-04-22','OFF','Booked');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (4,7,'Geethika Sabbineni',1,1,0,2, date '2020-11-01', date '2021-05-05', date '2021-07-10','ON','Cancelled');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (3,3,'Joe Biden',0,0,2,1, date '2021-01-22', date '2021-03-10', date '2021-03-21','OFF','Booked');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (6,1,'Dr George Karabatis',1,1,1,0, date '2019-08-29', date '2020-01-05', date '2020-01-10','OFF','Cancelled');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,1,'Stephen Rule',2,3,1,1, date '2018-11-16', date '2019-01-01', date '2019-01-10','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,2,'Steve Rogers',1,2,0,1, date '2018-11-25', date '2019-01-03', date '2019-01-6','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,5,'Babajide Omobo',0,0,2,0, date '2018-12-04', date '2019-01-04', date '2019-01-8','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,4,'Medha Kunnath',0,0,2,0, date '2018-12-18', date '2019-01-04', date '2019-01-8','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,4,'Dr George Karabatis',1,1,2,1, date '2018-11-21', date '2019-01-04', date '2019-01-8','OFF','Completed');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,10,'Akanksha Vagal',4,2,2,1, date '2021-01-02', date '2021-03-11', date '2021-03-23','OFF','Booked');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,10,'Stephen Rule',9,3,1,1, date '2021-01-30', date '2021-03-09', date '2021-03-25','OFF','Booked');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,9,'Babajide Omobo',6,4,3,0, date '2021-02-19', date '2021-03-04', date '2021-03-26','OFF','Booked');
insert into Reservation(cid,hid,gname,sg_qty,db_qty,st_qty,cf_qty,rsv_date,chkin,chkout,season,rsv_status) values (2,9,'Steve Rogers',10,4,2,1, date '2020-12-07', date '2021-03-06', date '2021-03-28','OFF','Booked');

/*Inserting data into Reservation_Services table*/
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (1,3,date '2020-05-03',2);
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (4,1,date '2021-04-05',1);
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (3,2,date '2021-01-07',3);
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (2,1,date '2019-03-25',2);
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (3,3,date '2021-02-10',1);
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (6,2,date '2021-03-15',3);
insert into Reserved_Services(rsv_id,srv_id,srv_date,sv_qty) values (1,2,date '2020-05-08',5);

commit;



--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--############################## PL/SQL Statements ###############################
--############################# Member 1 - Problem 1 #############################
/* Create the procedure add_hotel. 
This procedure will add a new hotel to the hotel table from the inputs below. 
*/
create or replace procedure add_hotel (
                                        h_name in varchar,    -- Hotel Name
                                        h_street in varchar,  -- Hotel Street Address 
                                        h_city in varchar,    -- Hotel City 
                                        h_state in varchar,   -- Hotel State
                                        h_zip in int,         -- Hotel Zip Code
                                        h_phone in varchar,   -- Hotel Phone Number 
                                        h_status in varchar,  -- Hotel Status - open (Not Sold) or sold
                                        sgqty in int,         -- The number of Single Bedrooms at the hotel
                                        dbqty in int,         -- The number of Double Bedrooms at the hotel
                                        stqty in int,         -- The number of Suites at the hotel
                                        cfqty in int) AS      -- The number of Conference Rooms at the hotel
begin
  insert into Hotel (hname, hstreet, hcity, hstate, hzip, hphone, hstatus, sg_qty, db_qty, st_qty, cf_qty) 
             values (h_name, h_street, h_city, h_state, h_zip, h_phone, h_status, sgqty, dbqty, stqty, cfqty);  --Insert data into hotel table
  dbms_output.put_line('Inserted data into hotel table.');  --Dispaly information when procedure is ran
exception
  when others then  -- When there is an error then print out the error code and error message
    dbms_output.put_line('There was an error with the procedure add_hotel.'); 
    dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
end;
/




--############################# Member 1 - Problem 2 #############################
/* Create the procedure find_hotel 
This procedure will output the Hotel ID given the input of Hotel Street Address
*/
create or replace procedure find_hotel (h_street varchar) is  -- h_street is the Hotel Street Address
  rt hotel%rowtype;  
begin
  select * into rt from hotel where hstreet = h_street; 
  dbms_output.put_line('The Hotel ID for address: ' || rt.hstreet || ' is: ' || rt.hid);  -- Display the input (Hotel Street) and Hotel ID
exception
  when no_data_found then  -- If there is no data found from the Hotel Street Address
    dbms_output.put_line('No rows found');
  when too_many_rows then  -- If there are multiple Hotel Street Address
    dbms_output.put_line('Too many rows');
  when others then  -- If there are other errors
    dbms_output.put_line('There was an error with the procedure find_hotel.'); 
    dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
end;
/




--############################# Member 1 - Problem 3 #############################
/*Create the procedure sell_hotel
This procedure will first update the hotel status to sold if it wasnt already sold given the input of a Hotel ID 
and second display a hotel report of all sold hotels displaying basic information
*/
create or replace procedure sell_hotel(h_id int) is   -- h_id is the Hotel ID
  cursor c1 is select hid, hname, hstreet, hstate, hphone, hstatus from hotel where hstatus = 'sold';  --Cursor c1 will be used to display information on sold hotels
  hotel_status varchar(4);  -- variable for hstatus from hotel table
begin 
  select hstatus into hotel_status from hotel where hid = h_id;  -- Get hotel status where hotel id matches input h_id
  if hotel_status = 'open' then   -- If hotel status is open then go ahead and update the status to sold
    update hotel set hstatus = 'sold' where hid = h_id;
    dbms_output.put_line('Hotel ID ' || h_id || ' has been updated to sold.');
  elsif hotel_status = 'sold' then  -- If hotel status is sold then notify user that the hotel was already sold. Do not update anything
    dbms_output.put_line('Hotel ID ' || h_id || ' was already sold!'); 
  else  -- If there was anything other than 'open' or 'sold' in hotel status then there is an issue. Display what is in hotel status. Do not update anything
    dbms_output.put_line('There was an error!  Hotel Status is: ' || hotel_status);
  end if;
  
  dbms_output.new_line;  -- Give a new line to space between what was displayed above from the hotel report. 
  dbms_output.put_line('Hotel Report - Sold Hotels');  -- Display title for hotel report
  
  for item in c1  -- Loop through all sold hotels in c1 and display Hotel ID, Name, Address, State, Phone Number, and Status.  
  loop
    dbms_output.put_line('Hotel ID: ' || item.hid || 
                         ', Name: ' || item.hname || 
                         ', Address: ' || item.hstreet || 
                         ', State: ' || item.hstate || 
                         ', Phone Number: ' || item.hphone || 
                         ', Status: ' || item.hstatus);
  end loop;
exception
  when no_data_found then  -- If there is no data found
    dbms_output.put_line('No rows found');
  when too_many_rows then  -- If there are multiple values returned
    dbms_output.put_line('Too many rows');
  when others then  -- If there are other errors
    dbms_output.put_line('There was an error with the procedure sell_hotel.'); 
    dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
end;
/




--############################# Member 1 - Problem 4 #############################
/*Create the procedure hotel_state_report
This procedure will output information about hotels in a state given the input of a state (e.g. MD)
and will print the avaialble rooms for each hotel using the input date. 
Note: Sold hotels will not show up in this report. 
*/
create or replace procedure hotel_state_report(in_state varchar,  --Input State. Should be two letter designation for state. 
                                               in_date date) is   --Input date that will be used to calculate room availability from reservation table.           
    
  --Cursor for the hotel table getting the total number of rooms each hotel has
  cursor c1 is select hid, hname, hstreet, hcity, hstate, hzip, hphone, sg_qty, db_qty, st_qty, cf_qty from hotel where hstate = in_state and hstatus != 'sold'; 
  
  --Cursor joining hotel table and reservation table to get the number of rooms that are completed/booked on a certain day.  
  cursor c2 is select h.hid, h.hname, sum(r.sg_qty) as r_sg_qty, sum(r.db_qty) as r_db_qty, sum(r.st_qty) as r_st_qty, sum(r.cf_qty) as r_cf_qty
               from reservation r inner join hotel h on h.hid = r.hid 
               where h.hstate = in_state and (r.rsv_status = 'Completed' or r.rsv_status = 'Booked') and in_date between r.chkin and r.chkout
               GROUP BY h.hid, h.hname;
               
   r c1%rowtype;  -- Variable r for rowtype for cursor c1
  
  --Variables below will contain the total number of rooms available taking the total number from hotel table and subtracting that from the count of completed/booked rooms from reservation table.  
  hsr_count_single int := 0;
  hsr_count_double int := 0;
  hsr_count_suite int := 0;
  hsr_count_conference int := 0;
  
begin
  dbms_output.put_line('Hotel Report - State ' || in_state);  -- Display title for hotel report
  
  open c1;
  fetch c1 into r;
  if c1%notfound then   -- If no hotels in state (Empty Cursor/rowtype), Output no hotels in state
    dbms_output.put_line('There are no hotels in the state');
  end if;
  close c1;
  
  for item_a in c1  --Open loop for all of the hotels for state matched in c1
    loop
      hsr_count_single := item_a.sg_qty;    --Put total number of single rooms for the hotel in this loop into hsr_count_single
      hsr_count_double := item_a.db_qty;    --Put total number of double rooms for the hotel in this loop into hsr_count_double
      hsr_count_suite := item_a.st_qty;     --Put total number of suite rooms for the hotel in this loop into hsr_count_suite
      hsr_count_conference := item_a.cf_qty;  --Put total number of conference rooms for the hotel in this loop into hsr_count_conference
      
      for item_b in c2  --Open loop for all reservations matched in c2
        loop
          if item_a.hid = item_b.hid then  --If there is a reservation for matching hotel id then deduct the rooms if any were statyed in
            hsr_count_single := hsr_count_single - item_b.r_sg_qty;
            hsr_count_double := hsr_count_double - item_b.r_db_qty;
            hsr_count_suite := hsr_count_suite - item_b.r_st_qty;
            hsr_count_conference := hsr_count_conference - item_b.r_cf_qty;
          end if;
        end loop;
      
      --Output Hotel information followed by available rooms for single, double, suite, and conference. 
      dbms_output.put_line('Hotel Name: ' || item_a.hname || ', Address: ' || item_a.hstreet ||  ', ' || item_a.hcity || ', ' ||  item_a.hstate || ', ' || item_a.hzip || 
                         ', Single Rooms: ' || hsr_count_single || ', Double Rooms: ' || hsr_count_double || ', Suite Rooms: ' || hsr_count_suite || ', Conference Rooms: ' || hsr_count_conference);
    end loop;
 
exception
  when no_data_found then  -- If there is no data found
    dbms_output.put_line('No rows found');
  when too_many_rows then  -- If there are multiple values returned
    dbms_output.put_line('Too many rows');
  when others then  -- If there are other errors
    dbms_output.put_line('There was an error with the procedure hotel_state_report.'); 
    dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
end;
/




--############################# Member 2 - Problem 5 #############################
-- Make a reservation. Input Hotel ID, guest name, start date, end date, room type, and date of reservation
-- OUTPUT: Reservation ID

create or replace procedure get_avail_rooms(hotel_id int, chkin_date date, chkout_date date,sg_rooms1 int, 
    db_rooms1  int, st_rooms1 int, cf_rooms1 int, cust_id int, guest_name varchar, season_1 varchar)
    as
    cursor c1 is select * from reservation where hid = hotel_id; 
    c1_data c1%rowtype;
    
    T_sg_qty int;                                                   -- Total number of Single rooms 
    T_db_qty int;                                                   -- Total number of Double rooms 
    T_st_qty int;                                                   -- Total number of Suite rooms 
    T_cf_qty int;                                                   -- Total number of Conference rooms 
    
    d_sg_qty int;                                                   -- Total number of Single rooms currently booked
    d_db_qty int;                                                   -- Total number of Double rooms currently booked
    d_st_qty int;                                                   -- Total number of Suite rooms currently booked
    d_cf_qty int;                                                   -- Total number of Conference rooms currently booked
    
    sg_rooms int;                                                   -- Number of Single Rooms Input  
    db_rooms int;                                                   -- Number of Double Rooms Input 
    st_rooms int;                                                   -- Number of Suite Rooms Input 
    cf_rooms int;                                                   -- Number of Conference Rooms Input 
    res int;
    
   reserv_status varchar(20);

begin
    d_sg_qty := 0;
    d_db_qty := 0;
    d_st_qty := 0;
    d_cf_qty := 0;
    
    select sg_qty, db_qty, st_qty, cf_qty into T_sg_qty, T_db_qty, T_st_qty, T_cf_qty from hotel where hid = hotel_id;
    open c1;
    loop
    fetch c1 into c1_data;
    exit when c1%notfound;
    
    if chkin_date <= c1_data.chkout and chkin_date >= c1_data.chkin and c1_data.rsv_status = 'Booked' then          --Checking the number of booked rooms according to date
    d_sg_qty := d_sg_qty + c1_data.sg_qty;                                                                          --Calculating number of booked single rooms
    d_db_qty := d_db_qty + c1_data.db_qty;                                                                          --Calculating number of booked double rooms
    d_st_qty := d_st_qty + c1_data.st_qty;                                                                          --Calculating number of booked suite rooms
    d_cf_qty := d_cf_qty + c1_data.cf_qty;                                                                          --Calculating number of booked conference rooms
    end if;
    end loop;
    close c1;
    
    sg_rooms := T_sg_qty - d_sg_qty;                                                                                -- Current availability of Single rooms   
    if sg_rooms < 0 then
        sg_rooms := 0;
        dbms_output.put_line(' No Single Rooms Available!');
    end if;
    
    db_rooms := T_db_qty - d_db_qty;                                                                                -- Current availability of Double rooms                                                         
    if db_rooms < 0 then
        db_rooms := 0;
        dbms_output.put_line(' No Double Rooms Available!');

    end if;
    
    st_rooms := T_st_qty - d_st_qty;                                                                                 -- Current availability of Suite rooms   
    if st_rooms < 0 then
        st_rooms := 0;
        dbms_output.put_line('No Suite Rooms Available!');

    end if;
    
    cf_rooms := T_cf_qty - d_cf_qty;                                                                                  -- Current availability of Conference rooms  

    if cf_rooms < 0 then
        cf_rooms := 0;
        dbms_output.put_line('No Conference Rooms Available!');
    end if;

   reserv_status := 'Booked';

    
    if ((sg_rooms>=sg_rooms1) AND (db_rooms>= db_rooms1) AND (st_rooms>=st_rooms1) AND (cf_rooms >=cf_rooms1)) then
        insert into reservation(cid,hid,gname,chkin,chkout,sg_qty,db_qty,st_qty,cf_qty,season,rsv_status) 
                           values (cust_id, hotel_id,guest_name,chkin_date,chkout_date,sg_rooms1,db_rooms1,st_rooms1,cf_rooms1,season_1,reserv_status); --Making a reservation
        dbms_output.put_line ('  ');  
        dbms_output.put_line ('------------------------------------');                  
        dbms_output.put_line ('New Reservation was created !!'); 
        Select max(RSV_ID)  into res from reservation ;
        dbms_output.put_line ('------------------------------------');  
        dbms_output.put_line ('Reservation ID is  : '|| (res));                                                        --Outputting the Reservation ID
 
     Else
         dbms_output.put_line (' ');
         dbms_output.put_line ('No Reservation can be created at this time.');
    END IF;


EXCEPTION
 when no_data_found then 
 dbms_output.put_line('No rows found');                                       
 when too_many_rows then
 dbms_output.put_line('Too many rows');
 when others then
 dbms_output.put_line('There was another error');

end;
/



--############################# Member 2 - Problem 6 ############################# (NEEDS UPDATE)
--Gets reservation ID when given guest name, reservation date, and hotel ID

create or replace procedure find_res(g_name1 varchar, resv_date1 date, hotelid int) is
res Reservation%rowtype;
begin
  select * into res from Reservation
  where gname = g_name1 and rsv_date like resv_date1 and HID=hotelid; 
  dbms_output.put_line('Reserve ID is: ' || res.rsv_id);
exception
   when no_data_found then 
   dbms_output.put_line('No rows found');
   when too_many_rows then
   dbms_output.put_line('Too many rows');
   when others then
   dbms_output.put_line('There was another error');
end;
/



--############################# Member 2 - Problem 7 #############################
--Cancel a reservation given the input of reservation ID.  (DOES NOT DELETE RECORD)

create or replace procedure Cancel_reservation(rsid int) is  
  cursor cur1 is   select  rsv_id,rsv_status,chkout from reservation where RSV_status = 'Booked';  --defining the cursor cur1
  reservation_status varchar(32);  --declaring variable for rsv_status from reservation table
  check_out reservation.chkout%type;
begin 
  select rsv_status into reservation_status from reservation where rsid = rsv_id;  -- Checking reservation status of the hotel where reservation id is the same as input rsv_id
  if reservation_status = 'Booked' then   
    update reservation set rsv_status = 'Cancelled' where rsid = rsv_id; -- if rsv_status is booked then change it to cancelled 
    dbms_output.put_line('Reservation ID is ' || rsid || ' and its status has been updated to Cancelled.');
  elsif reservation_status = 'Cancelled' then  
    dbms_output.put_line('Reservation ID is ' || rsid || ' is already in Cancelled status, Please check again!'); --if rsv_status is already cancelled then don't change anything
 elsif reservation_status = 'Completed' then
    dbms_output.put_line('Reservation ID is ' || rsid || ' has been Completed on date ' || check_out || '. Please check again'); --if rsv_status is completed then don't change anything
  else  
    dbms_output.put_line('There was an error!  Reservation Status is: ' || reservation_status); -- If the status is not 'booked', 'cancelled' or 'completed'  then display what is in the reservation status without any updation
  end if;
  dbms_output.new_line;  -- A line Space
  
exception
  when no_data_found then  
    dbms_output.put_line('No rows found'); --  When no data is found
  when too_many_rows then  
    dbms_output.put_line('Too many rows'); -- When multiple values are returned
  when others then  
    dbms_output.put_line('There was an error with the procedure Cancel_reservation.'); -- When displaying other errors
    dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);

end;
/




--############################# Member 2 - Problem 8 ############################# (NEEDS UPDATE)
--Show Cancelations: Print all canceled reservations (Reservation ID, hotel name, location, guest name, room type, dates) 
--Input: NO INPUTS

create or replace procedure show_cancellations is   
  cursor cur2 is   select resv.rsv_id,resv.gname,resv.sg_qty,resv.db_qty,resv.st_qty,resv.cf_qty,resv.chkin,resv.chkout,
                    h.hname,h.hstreet,h.hcity, h.hstate,h.hzip
                    from reservation resv 
                    join hotel h
                    on resv.hid = h.hid
                    where resv.rsv_status = 'Cancelled' ;  --defining Cursor cur2 

begin
  for i in cur2 loop --loop for printing cancelled reservations
   dbms_output.put_line('Reservation ID: '|| i.rsv_id|| ', Guest Name:' ||i.gname|| ', Single Room Quantity:' ||i.sg_qty|| ', Double Room Quantity: ' ||i.db_qty|| ', Suite Room Quantity: ' ||i.st_qty|| ', Conference Room Quantity: ' ||i.cf_qty|| ', CheckIn Date: ' ||i.chkin|| ', CheckOut Date ' ||i.chkout|| ', Hotel Name: ' ||
                    i.hname|| ', Street Name: ' ||i.hstreet|| ', City Name: ' ||i.hcity|| ', State Name: ' || i.hstate|| ', Zipcode: ' ||i.hzip); --output statement
   end loop;
 
exception
  when no_data_found then  -- When no data is found
    dbms_output.put_line('No rows found');
  when too_many_rows then  -- When multiple values are returned
    dbms_output.put_line('Too many rows');
  when others then  -- When there are other errors
    dbms_output.put_line('There was an error with the procedure Cancel_reservation.'); 
    dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
 

end;
/




--############################# Member 3 - Problem 9 #############################
--Change a Reservation Date. Input (Reservation ID, Checkin Date, End Date)
--If there is availability in the same room type for the new date interval)

create or replace procedure get_rooms_available(hotel_id in int, rsvID in int, chk_date in date, sg_rooms out int, 
    db_rooms out int, st_rooms out int, cf_rooms out int)
as
    cursor c1 is select * from reservation where hid = hotel_id and rsv_id <> rsvID;
    c1_data c1%rowtype;
    
    T_sg_qty int;
    T_db_qty int;
    T_st_qty int;
    T_cf_qty int;
    
    d_sg_qty int;
    d_db_qty int;
    d_st_qty int;
    d_cf_qty int;
begin
    d_sg_qty := 0;
    d_db_qty := 0;
    d_st_qty := 0;
    d_cf_qty := 0;
    
    select sg_qty, db_qty, st_qty, cf_qty into T_sg_qty, T_db_qty, T_st_qty, T_cf_qty from hotel where hid = hotel_id;
    open c1;
    loop
    fetch c1 into c1_data;
    exit when c1%notfound;
    
    if chk_date <= c1_data.chkout and chk_date >= c1_data.chkin and c1_data.rsv_status = 'Booked' then
    d_sg_qty := d_sg_qty + c1_data.sg_qty;
    d_db_qty := d_db_qty + c1_data.db_qty;
    d_st_qty := d_st_qty + c1_data.st_qty;
    d_cf_qty := d_cf_qty + c1_data.cf_qty;
    end if;
    end loop;
    close c1;
    
    sg_rooms := T_sg_qty - d_sg_qty;
    if sg_rooms < 0 then
        sg_rooms := 0;
    end if;
    
    db_rooms := T_db_qty - d_db_qty;
    if db_rooms < 0 then
        db_rooms := 0;
    end if;
    
    st_rooms := T_st_qty - d_st_qty;
    if st_rooms < 0 then
        st_rooms := 0;
    end if;
    
    cf_rooms := T_cf_qty - d_cf_qty;
    if cf_rooms < 0 then
        cf_rooms := 0;
    end if;
    
exception
    when others then
    dbms_output.put_line('An exception was raised');

end;

/


/*This procedure changes the reservation dates given a reservation id, provided
the new dates in the specific hotel have rooms avaliable*/

create or replace procedure change_reservation(resID in int, newStartDate in date, newEndDate in date) as

    single_Q int;
    double_Q int;
    suite_Q int;
    conference_Q int;
    hotel_id int;
    
    checkSingle int;
    checkDouble int;
    checkSuite int;
    checkConference int;
begin
    if newStartDate >= sysdate and newEndDate >= sysdate and newEndDate > newStartDate then
        select hid,sg_qty, db_qty, st_qty, cf_qty into hotel_id, single_Q, double_Q, suite_Q,conference_Q from reservation where rsv_id = resID;
        get_rooms_available(hotel_id, resID, newStartDate, checkSingle,checkDouble,checkSuite,checkConference);
        
        if (checkSingle >= single_Q) and (checkDouble >= double_Q) and (checkSuite >= suite_Q) and (checkConference >= conference_Q) then
            update reservation set chkin = newStartDate, chkout = newEndDate where RSV_ID = resID;
            dbms_output.put_line('Checkin and Checkout dates for Reservation ID: '||resID||' have been updated');
            dbms_output.put_line('New Check-in date: '||newStartDate);
            dbms_output.put_line('New Check-out date: '||newEndDate);
        else
            dbms_output.put_line('The are not enough avaliable rooms for the selected dates');
            dbms_output.put_line('Avaliable single rooms: '||checkSingle);
            dbms_output.put_line('Avaliable double rooms: '||checkDouble);
            dbms_output.put_line('Avaliable suite rooms: '||checkSuite);
            dbms_output.put_line('Avaliable conference rooms: '||checkConference);
        end if;
    else 
        dbms_output.put_line('The new dates must be in the future, start date must be earlier than end date.');
    end if;
        
    exception
        when others then
        dbms_output.put_line('An exception was raised. Ensure dates and reservation ID are valid enteries');
end;
/




--############################# Member 3 - Problem 10 #############################
--Show single hotel reservation: Input (Hotel ID) Output: (All reservations for that hotel)

create or replace procedure get_reservation (h_id int ) is 
cursor c_res is select rsv_id, hid, gname, chkin, chkout, sg_qty, db_qty, st_qty, cf_qty from reservation where hid = h_id and rsv_status = 'Booked';

r c_res%rowtype;

begin
  open c_res;
  fetch c_res into r;
  if c_res%notfound then 
    dbms_output.put_line('There are currently no reservations for the hotel or the reservations have been completed.');
  end if;
  close c_res;
  
  
  for item in c_res loop
    dbms_output.put_line('Reservation ID: ' || item.rsv_id || ', Guest Name: ' || item.gname || ', Checkin Date: ' || item.chkin || ', Checkout Date: ' || item.chkout || ', Single Rooms: ' || item.sg_qty ||
                         ', Double Rooms: ' || item.db_qty || ', Suite Rooms: ' || item.st_qty || ', Conference Rooms: ' || item.cf_qty);
  end loop;
  
exception
  when no_data_found then
    dbms_output.put_line('No reservation found.');
  when others then
    dbms_output.put_line('There was another error.');
end; 
/




--############################# Member 3 - Problem 11 #############################
--Show single guest reservation.  INPUT (guest name) OUTPUT (All reservations under that name)

create or replace procedure F_Guest(g_name in Reservation.gname%type) is     --Procedure for Find reservation according to Guest Name 
  cursor fguest is select rsv_id,chkin,chkout,rsv_status from Reservation     --Cursor for checking conditions to find Reservation
                  where Reservation.gname=g_name;   
 
  rsvid Reservation.rsv_id%type;
  rchkin Reservation.chkin%type;
  rchkout Reservation.chkout%type;
  rstatus Reservation.rsv_status%type;
  r fguest%rowtype;
  
begin 

  -- If guest does not exist then display to the dba
  open fguest;
    fetch fguest into r;
    if fguest%notfound then 
      dbms_output.put_line('That guest does not exist.');
    end if;
  close fguest;
  
  -- If guest exist then display reservations
  open  fguest;
  loop 
    fetch fguest into rsvid,rchkin,rchkout,rstatus; 
    exit when fguest%notfound;   
    dbms_output.put_line('Reservation Id : '||rsvid||' , Check-In Date : '||rchkin||', Check-Out Date : '||rchkout||', Reservation Status : '||rstatus);
  end loop;
  close  fguest;

exception                                         --Exception for handling errors
  when no_data_found then
    dbms_output.put_line('No guest found');
  when others then
    dbms_output.put_line('Wrong Information');
    
end;
/




--############################# Member 3 - Problem 12 #############################
--Monthly Income Report. INPUT (No Input) Output (Total income from all sources of all
--   hotels by month.  For each month, display room type, service type.  If there is no income
--   in a month, do not display this month.  Include discounts). 


create or replace PROCEDURE Monthly_Income
IS
    -- cursor for all reservations of all hotels in given state
    CURSOR c1 IS SELECT rsv_id, hid, sg_qty, db_qty, st_qty, cf_qty, chkin, chkout, rsv_status   
    FROM reservation WHERE rsv_status != 'Cancelled' ORDER BY chkin ASC; 
    r c1%rowtype;  -- Variable r for rowtype for cursor c1

    -- cursor for all the services
    CURSOR c2 IS SELECT rs.rs_id, rs.srv_date, rs.srv_id, rs.sv_qty, s.srv_name, s.srv_cst
    FROM reserved_services rs INNER JOIN services s ON s.srv_id = rs.srv_id ORDER BY rs.srv_date;
    r2 c2%rowtype; -- Variable r2 for rowtype for cursor c2

    -- Holds dates for loop 
    Hold_dt date;
    Lst_dt date;
    curr_yr number;
    curr_mo number;

    rsv_d boolean := False; -- checks if 10% is valid
    szn reservation.season%type; -- holds season from reservation
    -- holds amout of rooms by type
    SG reservation.sg_qty%type;
    DB reservation.db_qty%type;
    ST reservation.st_qty%type;
    CF reservation.cf_qty%type;
    -- holds dates from reservation
    rdate date;
    StrtDt date;
    EndDt date;
    IDt date; --iterates through dates
    -- holds prices of rooms by type and season
    SGprice reservation_pricing.price%type;
    DBprice reservation_pricing.price%type;
    STprice reservation_pricing.price%type;
    CFprice reservation_pricing.price%type;
    -- variables used to count and iterate amounts
    sg_tot number :=0;
    sg_temp number :=0;
    db_tot number :=0;
    db_temp number :=0;
    st_tot number :=0;
    st_temp number :=0;
    cf_tot number :=0;
    cf_temp number :=0;
    r_tot number :=0;
    m_tot number :=0;
    l_tot number :=0;
    temp number :=0;
    Tot number :=0;


BEGIN
    -- Title for State Income Report--
    dbms_output.put_line('*****  Monthly Income Report  *****');
    dbms_output.new_line;

    -- if there are no reservations in the table 
    open c1;
        fetch c1 into r;
        if c1%notfound then 
            dbms_output.put_line('No Reservations recorded');
        end if;
    close c1;

    -- if there are no reserved services in the table 
    open c2;
        fetch c2 into r2;
        if c2%notfound then 
            dbms_output.put_line('No Services recorded');
        end if;
    close c2;

    -- Selects earliest date in reservation table
    SELECT MIN(chkin) into Hold_dt from reservation WHERE rsv_status != 'Cancelled';
    curr_yr := extract( year from Hold_dt);
    
    --Selects latest date in reservation table 
    SELECT MAX(chkout) into Lst_dt from reservation WHERE rsv_status != 'Cancelled';
    
    -- loops through from the year of earliest saved date to the system date
    while curr_yr <= extract( year from Lst_dt)
    loop
        dbms_output.new_line;
        -- reinitializes month to january for each year  
        curr_mo := 1;
        --loops through the 12 months
        while curr_mo <= 12
        loop
            -- reinitializes variables 
            sg_tot :=0;
            db_tot :=0;
            st_tot :=0;
            cf_tot :=0;
            r_tot :=0;
            m_tot :=0;
            l_tot :=0;
            tot:=0;

            --Calculates Room totals 
            for item in c1
            loop 
                -- if the reservation date is in the current year or month it is counted 
                if extract(year from item.chkin) = curr_yr AND (extract(month from item.chkin) = curr_mo OR extract(month from item.chkout) = curr_mo) then
                     -- Calculates totals by room
                    SELECT season, rsv_date, chkin, chkout, sg_qty, db_qty, st_qty, cf_qty 
                    INTO szn, rdate, StrtDt, EndDt, SG, DB, ST, CF 
                    FROM reservation 
                    WHERE rsv_id = item.rsv_id AND item.rsv_status != 'Cancelled';
                    rsv_d:=FALSE;
                    --checks if 10% discount is valid 
                    if(StrtDt - rdate  >= 60) then
                    	rsv_d := TRUE;
                    end if;
                    -- resets temp values for each iteration
                    sg_temp :=0;
                    db_temp :=0;
                    st_temp :=0;
                    cf_temp :=0;

                    --changes date if reservations is split into 2 months
                    if extract(month from item.chkin) != curr_mo then
                       StrtDt := TRUNC(EndDt, 'MONTH');
                    end if;

                    if extract(month from item.chkout) != curr_mo then
                        EndDt := last_day(StrtDt);
                    end if;

                    -- while loop to take in all days guest stayed at hotel per reservation
                    IDt := StrtDt;
                    While IDt < EndDt
                    loop
                        -- calculates totals by room type 
                        SELECT price INTO SGprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Single' ;
                        temp := SG*SGprice;
                        sg_temp := sg_temp + temp;

                        SELECT price INTO DBprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Double' ;
                        temp := DB*DBprice;
                        db_temp := db_temp + temp;

                        SELECT price INTO STprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Suite' ;
                        temp := ST*STprice;
                        st_temp := st_temp + temp;

                        SELECT price INTO CFprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Conference' ;
                        temp := CF*CFprice;
                        cf_temp := cf_temp + temp;

                        -- iterates to the next day
                        Idt := Idt + 1;
                    end loop;

                    -- takes in the 10% discount
                    if rsv_d = true then
                        sg_temp := sg_temp *.9;
                        db_temp := db_temp *.9;
                        st_temp := st_temp *.9;
                        cf_temp := cf_temp *.9;
                    end if;  

                    --adds the reservation totals to the overall total
                    sg_tot := sg_tot + sg_temp;
                    db_tot := db_tot + db_temp;
                    st_tot := st_tot + st_temp;
                    cf_tot := cf_tot + cf_temp;

                end if;   
            end loop;

            --Calculates Service totals 
            for item in c2
            loop
                -- if the service date is in the current year or month it is counted 
                if extract(year from item.srv_date) = curr_yr AND extract(month from item.srv_date) = curr_mo then
                   --if restaurant service was used added to to total
                    if item.srv_id = 1 then
                        r_tot := r_tot + (item.sv_qty * item.srv_cst);
                    --if movie service was used added to to total
                    elsif item.srv_id = 2 then
                        m_tot := m_tot + (item.sv_qty * item.srv_cst);
                    --if laundry services was used added to to total
                    else
                    l_tot := l_tot + (item.sv_qty * item.srv_cst);
                    end if;
                end if;  
            end loop;

            -- Calculates ant outputs the Total Sales in the state
            tot := sg_tot + db_tot + st_tot + cf_tot + r_tot + m_tot + l_tot;

            --Outputting all Values totaled
            if tot != 0 then
                dbms_output.new_line;
                dbms_output.put_line(to_char(to_date(curr_mo,'MM'),'Month')||', '||curr_yr); 
                dbms_output.new_line;
                dbms_output.put_line('Single room sales: ' || sg_tot);
                dbms_output.put_line('Double room sales: ' || db_tot);
                dbms_output.put_line('Suite room sales: ' || st_tot);
                dbms_output.put_line('Conference room sales: ' || cf_tot);
                dbms_output.put_line('Restaurant sales: ' || r_tot);
                dbms_output.put_line('Pay_Per_View Movie sales: ' || m_tot);
                dbms_output.put_line('Laundry sales: ' || l_tot);
                dbms_output.put_line('---------------------------------');
                dbms_output.put_line('Total Month Sales: ' || Tot );
                dbms_output.new_line;
                dbms_output.new_line;
            end if;

            curr_mo := curr_mo + 1;
        end loop;

        curr_yr := curr_yr + 1;
    end loop;    

EXCEPTION
    when no_data_found then  -- If there is no data found 
         dbms_output.put_line('No Rows');
    when too_many_rows then  -- If there are multiple rows found
        dbms_output.put_line('Too many rows');
    when others then  -- If there are other errors
        dbms_output.put_line('There was an error with the procedure Checkout_Report'); 
        dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
END;





--############################# Member 4 - Problem 13 #############################
--Adds a service to reservation given the reservation ID and service. 

/* MY QUESTIONS: service_id services.srv_id%type;  why not just do int or varchar(####)
1. Note: You could be doing for loops instead of the %type in most of your problem statements. 

select * from reservation;
select * from reserved_services;

*/

create or replace procedure add_service(reservation_id in int, service_name in varchar, service_date in date, service_quantity in int) as
    /*This procedure adds a service to the reserved_services table for a particular reservation id.
    Inputs include reservation id, service name, date and quantity.
    Multiple services are allowed for the same day.*/

    -- internal variable declaration
    service_id services.srv_id%type;          --service id from the inputed service name

begin
    
    -- select statement to retrieve service id given service name
    select srv_id 
    into service_id
    from services 
    where srv_name = service_name;
    
    --insert statement into reservation_services for a given reservation 
    insert into reserved_services (rsv_id, srv_id, srv_date, sv_qty)
    values (reservation_id,service_id,service_date,service_quantity);
    
    --catching exceptions
    exception
        when no_data_found then
        dbms_output.put_line('Invalid service, No service id was returned, insert aborted!');
        when too_many_rows then
        dbms_output.put_line('Many ID were returned for the specified service');
        when others then
        dbms_output.put_line('An exception was raised');
end;

/




--############################# Member 4 - Problem 14 #############################
--Input the reservation id and display all services on the reservation. Print no services for this reservation if none exists

/* MY QUESTIONS: Nice increment on the report. I like the escape approach you did here with the if null statement. 

select * from reserved_services;
*/

create or replace procedure reserved_services_report(reservation_id in int) as
    --This function takes in a reservation id as input and prints out a report with all the services booked for that reservation

    cursor c1 is select * from reserved_services where rsv_id = reservation_id;         --declaring the cursor c1
    service_name services.srv_name%type;                                                --declaring variable for implicit cursor service_name derived from service_id
    my_service c1%rowtype;                                                              --declaring variable for explicit cursor
begin

    open c1;
        --looping through each row in the cursor to print info
        loop 
            fetch c1 into my_service;
            exit when c1%notfound;
            
            --retrieving the name of the service
            select srv_name
            into service_name
            from services
            where srv_id = my_service.srv_id;
            
            --printing out data in readable format
            dbms_output.put_line('---Services for the reservation are listed below--- #' ||c1%rowcount);
            dbms_output.put_line('Reservation ID: '||my_service.rsv_id);
            dbms_output.put_line('Service ID: '||my_service.srv_id);
            dbms_output.put_line('Service name: '||service_name);
            dbms_output.put_line('Service Date: '||my_service.srv_date);
            dbms_output.put_line('Service Quantity: '||my_service.sv_qty);
            dbms_output.new_line();
        end loop;
    close c1;
    
    -- print statement when no date is returned
    if service_name is null then
        dbms_output.put_line('No services for this reservation');
    end if;

    --all other exceptions are caught
    exception
        when others then
        dbms_output.put_line('An exception was raised');
end;
/




--############################# Member 4 - Problem 15 #############################
--Input the service name and display all reservations that have this service in that hotel

/* MY QUESTIONS: on c1 what is distinct(r.rsv_id)
   -C1 why not do a join. You are taking two tables and matching on reservation ID and service ID. 
   I saw for 'Laundry service' had three entries but because 2 were to one customer the report showed two reservations. 
   Similar for rest... with 4 but only showing 3 and the last service pay... had 4 individual reservations with this service
select * from reserved_services;
select * from services;
*/

--This function does the sole job of returning the ID of a service name.
--The input is the name of a service the return value is the id of the service in the reservation table
create or replace function get_serviceID(name in varchar)
return int
as
vars int;
begin
    select srv_id into vars from services where srv_name = name;
    return vars;
    
exception
    when no_data_found then
    return -1;
    when others then
    return -1;
end;
/

--This procedure returns the reservations that have a service given a service ID
--It takes in service ID as input and prints as output all the reservations that have requested that service
create or replace procedure get_reservations(service_id in int)
as
cursor c1 is select distinct(r.rsv_id), r.cid, r.hid, r.gname, r.chkin,r.chkout from reservation r, reserved_services rs where rs.rsv_id = r.rsv_id and rs.srv_id = service_id;

/*Defining the variables*/
reservation_id int;
customer_id int;
hotel_id int;
guest_name varchar(100);
check_in date;
check_out date;

begin
open c1;
loop
    fetch c1 into reservation_id, customer_id, hotel_id, guest_name, check_in, check_out;
    if c1%rowcount < 1 then       --checking for if there is no rows returned
        dbms_output.put_line('No reservation for this service');
    end if;
    exit when c1%notfound;
    dbms_output.put('Reservation id:'||reservation_id);
    dbms_output.put(', Customer id:'||customer_id);
    dbms_output.put(', Hotel id:'||hotel_id);
    dbms_output.put(', Guest name:'||guest_name);
    dbms_output.put(', Checkin date:'||check_in);
    dbms_output.put_line(', Checkout date:'||check_out);
    dbms_output.new_line();
end loop;
close c1;
exception
    when no_data_found then
    dbms_output.put_line('No reservation for this service');
    when others then
    dbms_output.put_line('Exception raised');
end;
/


/*Final procedure to call the other procedures and function and get output.
Procedure calls the "get_reservations" and "get_service" procedures
Procedure gets name of service as input and then outputs reservations that have booked the service */
create or replace procedure service_report(name in varchar)
as
val_1 int;
begin
    val_1 := get_serviceID(name);   -- calling "get_service" function and saving the output as val_1
    dbms_output.put_line('-------------Reservations requesting "'||name||'" are listed below:--------------');
    dbms_output.new_line();
    get_reservations(val_1);        -- calling the "get_reservation" procedure
exception
    when others then
    dbms_output.put_line('An exception was raised');
end;
/




--############################# Member 4 - Problem 16 #############################
--Given the hotel ID, calculate and display income from all services in all reservations in that hotel. 

/* MY QUESTIONS: three way join (2 Joins) - Available service ID, Service Qty, Service Customer (matched on rsv id | srv id and hid)
   Beacuse the last join fell on hotel_id (input) everything else falls in place because of it
   1. Need to remove output 'happy' (Why would you have a hotel name that is null?)
   2. When you input a hotel id that does not exist you raise an exception. 
select * from hotel;
select * from reservation;
select * from reserved_services;
select * from services;

join one: reserved_services (rsv_id) = reservation (rsv_id)
join two: services (srv_id) = reserved_servics (srv_id) and reservation (hid) = input hotel_id

1: 2, 2, 2 (9 does not exist)= 2,9 
2: 2 ($5), 1 ($20)   =  2(3), 1(2), 1(2)        and   2 = 2

total (15) = total (0) + sv_qty (3) * srv_cst (5)  
total (55) = total (15) + sv_qty (2) * srv_cst (20)
total (95) = total (55) + sv_qty (2) * srv_cst (20)  
*/

--This procedure shows the total income from services provided by a hotel. input is hotel ID
create or replace procedure service_income(hotel_id in int)
as
    cursor c1 is select rs.srv_id, rs.sv_qty, s.srv_cst from reserved_services rs 
    inner join reservation r on rs.rsv_id = r.rsv_id inner join services s on s.srv_id = rs.srv_id and r.hid = hotel_id;
    cursor c2 is select hname from hotel where hid = hotel_id;
    
    --variable declarations
    total int;
    vars c1%rowtype;
    hotel_name c2%rowtype;
begin
    -- getting the hotel name
    open c2;
    loop 
    fetch c2 into hotel_name;
    if hotel_name.hname is null then
        dbms_output.put_line('The given hotel ID does not exist');
    end if;
    exit when c2%notfound;
    end loop;
    close c2;
    
    total := 0;
    open c1;
    loop 
        fetch c1 into vars;
        exit when c1%notfound;
        total := total + (vars.sv_qty * vars.srv_cst);
    end loop;
    close c1;
    
    --printing output
    if hotel_name.hname is null then
        dbms_output.new_line();
    else 
        dbms_output.put_line('Hotel ID: '||hotel_id||', Hotel Name: '||hotel_name.hname||'.');
        dbms_output.put_line('The total income for all the services at this hotel is: $'||total);
    end if;
    
    exception
        when others then
        dbms_output.put_line('An exception occured');
end;
/




--############################# Member 5 - Problem 17 #############################
--Add room to hotel given (hotel ID, specific type of room, and input the number of instances)

CREATE OR REPLACE PROCEDURE Add_room(room_type IN varchar, -- room types eg: single, double etc.
                                     room_qty IN number, -- number of rooms to be added 
                                     Hotel_id IN number) -- hotel id of the hotel rooms are being added to
IS

    id_check number := 0;
   
BEGIN  
    
    
    SELECT COUNT(*) INTO id_check FROM Hotel WHERE hid = Hotel_id;
    
    if id_check = 1 then
        if room_qty >= 0 then
            -- adding rooms according to the room type inputed
            case room_type

                when 'Single' then
                    -- Updates the total number of single rooms of hotel with inputed hotel id 
                    UPDATE Hotel SET sg_qty = sg_qty + room_qty WHERE hid = Hotel_id;
                    dbms_output.put_line('Number of Single rooms updated.');

                when 'Double' then
                    -- Updates the total number of double rooms of hotel with inputed hotel id 
                    UPDATE Hotel SET db_qty = db_qty + room_qty WHERE hid = Hotel_id;
                    dbms_output.put_line('Number of Double rooms updated.');

                when 'Suite' then
                    -- Updates the total number of suite rooms of hotel with inputed hotel id 
                    UPDATE Hotel SET st_qty = st_qty + room_qty WHERE hid = Hotel_id;
                    dbms_output.put_line('Number of Suite rooms updated.');

                when 'Conference' then
                    -- Updates the total number of conference rooms of hotel with inputed hotel id 
                    UPDATE Hotel SET cf_qty = cf_qty + room_qty WHERE hid = Hotel_id;
                    dbms_output.put_line('Number of Conference rooms updated.');
    
                else
                    -- if entered varchar is not the above the following message is shown
                    dbms_output.put_line('Invalid roomtype!');

            end case;
            
        else 
            dbms_output.put_line('Cannot add a negative room quantity');
        end if;
        
    else
        dbms_output.put_line('Hotel ID doesnt exist');
    end if;
    
EXCEPTION

    when others then  -- When there is an error then print out the error code and error message
    dbms_output.put_line('There was an error with Add room Procedure'); 
END;
/



--############################# Member 5 - Problem 18 #############################
--Show available rooms by type given (hotel ID and a specific Date)

CREATE OR REPLACE PROCEDURE Rooms_Available (IN_id IN number, IN_date IN date)
IS
    -- Cursor will check for all rows in reservation with such hotel id and 'booked' reservation status
    CURSOR c1 IS SELECT hid, chkin, chkout, sg_qty, db_qty, st_qty, cf_qty 
    FROM reservation 
    WHERE hid = IN_id AND rsv_status = 'Booked' AND IN_date BETWEEN chkin AND chkout;
    -- varable will hold the row type of the cursor c1
    r c1%rowtype;
    
    -- will contain the available rooms by type
    sg_rooms_avail int := 0; 
    db_rooms_avail int := 0; 
    st_rooms_avail int := 0; 
    cf_rooms_avail int := 0; 
    
    -- will contain total rooms in the hotel by type
    sg_rooms int := 0;
    db_rooms int := 0;
    st_rooms int := 0;
    cf_rooms int := 0;
    
    
BEGIN
        if In_Date >= sysdate then
        
            for item in c1
            loop 
                -- calculates all the booked rooms by type   
                sg_rooms_avail := item.sg_qty + sg_rooms_avail; 
                db_rooms_avail := item.db_qty + db_rooms_avail; 
                st_rooms_avail := item.st_qty + st_rooms_avail; 
                cf_rooms_avail := item.cf_qty + cf_rooms_avail; 
            end loop;
        
            -- subtracts the booked rooms from the total 
            SELECT sg_qty, db_qty, st_qty, cf_qty INTO sg_rooms, db_rooms, st_rooms, cf_rooms FROM hotel WHERE hid = IN_id; 
            sg_rooms_avail := sg_rooms - sg_rooms_avail; 
            db_rooms_avail := db_rooms - db_rooms_avail; 
            st_rooms_avail := st_rooms - st_rooms_avail; 
            cf_rooms_avail := cf_rooms - cf_rooms_avail; 
	
            -- If there are no such rooms booked total # of rooms in hotel are returned
            open c1;
                if c1%notfound then  
                    SELECT sg_qty, db_qty, st_qty, cf_qty INTO sg_rooms_avail, db_rooms_avail, st_rooms_avail, cf_rooms_avail FROM hotel WHERE hid = IN_id;
                end if;
            close c1;
    
            -- Output of the final available rooms by type
            dbms_output.put_line('Total Number of Single Rooms Available: ' || sg_rooms_avail);
            dbms_output.put_line('Total Number of Double Rooms Available: ' || db_rooms_avail);
            dbms_output.put_line('Total Number of Suite Rooms Available: ' || st_rooms_avail);
            dbms_output.put_line('Total Number of Conference Rooms Available: ' || cf_rooms_avail);
            
        else 
            dbms_output.put_line(In_Date || ' is a past date.');
        
        end if;    
        
EXCEPTION  
    when no_data_found then -- When there is nothing returned 
        dbms_output.put_line('No rows found');
    when too_many_rows then -- When there are multiple things being returned
        dbms_output.put_line('Multiple rows tyring to be returned');
    when others then  -- When there is any error then print out the error code and error message
        dbms_output.put_line('There was an error with the function Rooms_Available.'); 
        dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
END;
/


--############################# Member 5 - Problem 19 #############################
--Checkout Report given (Reservation ID) output (guest name, room number, rate per day, possibly multiple rooms
--  servics rendered per date, type, and amount, discounds if any, and total amount to be paid)

CREATE OR REPLACE PROCEDURE Checkout_Report (r_id number) 
IS
    
    --Cursor for services 
    CURSOR s1 IS SELECT srv_id, srv_date, sv_qty FROM reserved_services WHERE rsv_id = r_id; 
    s s1%rowtype;  -- Variable s for rowtype for cursor s1
  
    
    rsv_d boolean := False;  -- checks if 10% discount is valid
    G_name reservation.gname%type;  -- holds guest name
    szn reservation.season%type; -- holds season
    -- holds room quantity by type from reservation
    SG reservation.sg_qty%type;
    DB reservation.db_qty%type;
    ST reservation.st_qty%type;
    CF reservation.cf_qty%type;
    status reservation.rsv_status%type;
    -- Holds dates from reservation 
    rdate date;
    StrtDt date;
    EndDt date;
    IDt date; -- used to iterate through the dates in a loop
    --holds price based on room type and season
    SGprice reservation_pricing.price%type;
    DBprice reservation_pricing.price%type;
    STprice reservation_pricing.price%type;
    CFprice reservation_pricing.price%type;
    s_cost services.srv_cst%type; -- holds services' costs
    s_name services.srv_name%type; -- holds services' names
    -- following variables are used to count and add amounts
    s_tot number :=0;
    r_tot number:=0;
    sg_tot number:=0;
    db_tot number:=0;
    st_tot number:=0;
    cf_tot number:=0;
    temp number:=0;
    tot number:=0;
  
BEGIN

    -- Title for Checkout states reservation id --
    dbms_output.put_line('*****  Checkout Report for Reservation: ' || r_id ||'  *****'); 
    -- outputs the guest name in reservation
    SELECT gname INTO G_name FROM reservation WHERE rsv_id = r_id;
    dbms_output.put_line('Name of Guest: ' || G_name);
  
  
  
    -- output discounts
    SELECT season, rsv_date, chkin, chkout, sg_qty, db_qty, st_qty, cf_qty, rsv_status 
    INTO szn, rdate, StrtDt, EndDt, SG, DB, ST, CF, status
    FROM reservation WHERE rsv_id = r_id;
    
    if (status = 'Cancelled') then
        dbms_output.put_line(' ');
        dbms_output.put_line( 'Reservation was Cancelled');
    else    
        dbms_output.put_line(' ');
        dbms_output.put_line('**Discounts Included**');
        --outputs if off season prices were used 
        if (szn = 'OFF') then
            dbms_output.put_line('- Off Season Discounted Price');
        end if; 
     
        --outputs if reservation date was more than two months before checkin
        if(StrtDt - rdate >= 60) then
            rsv_d := TRUE;
            dbms_output.put_line('- 10% Advanced Booking ');
        end if;
  
  
  
        -- ouput room (loop it)
        dbms_output.put_line(' ');
        dbms_output.put_line('**Rooms Booked** ');
        -- loops through all days the guest stayed as per reservation
        IDt := StrtDt;    
        while IDt < EndDt
        loop
            -- Calculates prices by room type
            SELECT price INTO SGprice FROM reservation_pricing rp WHERE rp.season = szn AND rp.rm_typ = 'Single' ;
            temp := SG*SGprice;
            sg_tot := sg_tot + temp;
        
            SELECT price into DBprice FROM reservation_pricing rp WHERE rp.season = szn AND rp.rm_typ = 'Double' ;
            temp := DB*DBprice;
            db_tot := db_tot + temp;
        
            SELECT price into STprice FROM reservation_pricing rp WHERE rp.season = szn AND rp.rm_typ = 'Suite' ;
            temp := ST*STprice;
            st_tot := st_tot + temp;
        
            SELECT price into CFprice FROM reservation_pricing rp WHERE rp.season = szn AND rp.rm_typ = 'Conference' ;
            temp := CF*CFprice;
            cf_tot := cf_tot + temp;
        
            -- iterates to the next day
            Idt := Idt + 1;
        end Loop;
    
        -- Outputs total cost by room 
        dbms_output.put_line('Single rooms: ' || sg_tot);
        dbms_output.put_line('Double rooms: ' || db_tot);
        dbms_output.put_line('Suite rooms: ' || st_tot);
        dbms_output.put_line('Conference rooms: ' || cf_tot);
    
        -- calculates total cost for all rooms on all days
        r_tot := sg_tot + db_tot + st_tot + cf_tot;
    
        -- if 10 percent discount is valid dicount is given here
        if rsv_d = true then
        r_tot := r_tot * .9;
        end if;    
        dbms_output.put_line('----------------------------');
        dbms_output.put_line('Room total: ' || r_tot);
    
    

        --output services
        dbms_output.put_line(' ');
        dbms_output.put_line('**Services** ');
    
        -- outputs if no services were booked 
        open s1;
            fetch s1 into s;
            if s1%notfound then 
                dbms_output.put_line('No services were booked for this reservation');
            end if;
        close s1;
 
        -- loops through services used and calculates total for reservation
        for item_s in s1
            loop
                SELECT srv_cst, srv_name INTO s_cost, s_name FROM services WHERE srv_id = item_s.srv_id;
                temp := s_cost*item_s.sv_qty;
                dbms_output.put_line('Service: ' || s_name );
                s_tot := s_tot + temp;
            end loop;   
        dbms_output.put_line('----------------------------');
        dbms_output.put_line('Service total: ' || s_tot);
     
     
     
        -- total amount to be paid calculated and output here
        dbms_output.put_line(' ');
        dbms_output.put_line ('--------------------------------- ');
        tot := s_tot + r_tot; 
        dbms_output.put_line ('Total Amount Due : ' || tot);
    end if;
  
EXCEPTION
    when no_data_found then  -- If there is no data found 
         dbms_output.put_line('No Such Reservation');
    when too_many_rows then  -- If there are multiple rows found
        dbms_output.put_line('Too many rows');
    when others then  -- If there are other errors
        dbms_output.put_line('There was an error with the procedure Checkout_Report'); 
        dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
END;
/



--############################# Member 5 - Problem 20 #############################
--Income by state report: Input is state (MD), Output: total income from all sources of all hotels by room type and service type in 
--   the given state. Includes all discounts

CREATE OR REPLACE PROCEDURE Income_Report (INState varchar) 
IS
    
    -- cursor for all reservations of all hotels in given state
    CURSOR c1 IS SELECT r.rsv_id, r.sg_qty, r.db_qty, r.st_qty, r.cf_qty, r.rsv_status   
    FROM Hotel h INNER JOIN reservation r ON h.hid = r.hid AND h.HState = INState AND r.rsv_status != 'Cancelled'; 
    r c1%rowtype;  -- Variable r for rowtype for cursor c1
    
    -- cursor for all the services
    CURSOR c2 IS SELECT rs.sv_qty, rs.srv_id, s.srv_name, s.srv_cst
    FROM reserved_services rs INNER JOIN services s ON s.srv_id = rs.srv_id
    INNER JOIN reservation r ON rs.rsv_id = r.rsv_id
    INNER JOIN hotel h ON h.hid = r.hid AND h.HState = INState AND r.rsv_status != 'Cancelled';
    r2 c2%rowtype; -- Variable r2 for rowtype for cursor c2

    rsv_d boolean := False; -- checks if 10% is valid
    szn reservation.season%type; -- holds season from reservation
    -- holds amout of rooms by type
    SG reservation.sg_qty%type;
    DB reservation.db_qty%type;
    ST reservation.st_qty%type;
    CF reservation.cf_qty%type;
    -- holds dates from reservation
    rdate date;
    StrtDt date;
    EndDt date;
    IDt date; --iterates through dates
    -- holds prices of rooms by type and season
    SGprice reservation_pricing.price%type;
    DBprice reservation_pricing.price%type;
    STprice reservation_pricing.price%type;
    CFprice reservation_pricing.price%type;
    -- variables used to count and iterate amounts
    sg_tot number :=0;
    sg_temp number :=0;
    db_tot number :=0;
    db_temp number :=0;
    st_tot number :=0;
    st_temp number :=0;
    cf_tot number :=0;
    cf_temp number :=0;
    r_tot number :=0;
    m_tot number :=0;
    l_tot number :=0;
    temp number :=0;
    Tot number :=0;
    -- checks if hotels or services exists 
    no_hotel boolean := false;
    no_service boolean := false;
  
BEGIN
    -- Title for State Income Report--
    dbms_output.put_line('*****  State Income Report for ' || INState ||'  *****');
    dbms_output.put_line(' ');
    
    -- outputs if there are no hotels in the IN state
    open c1;
        fetch c1 into r;
        if c1%notfound then 
            dbms_output.put_line(' ');
            dbms_output.put_line('No Hotels in ' || INState);
            no_hotel := true;
        end if;
    close c1;
    
    if (no_hotel = false) then
        --calculates total per room type
        for item in c1
            loop
                -- resets boolean for the loop
                rsv_d := False;
                -- Calculates totals by room
                SELECT season, rsv_date, chkin, chkout, sg_qty, db_qty, st_qty, cf_qty 
                INTO szn, rdate, StrtDt, EndDt, SG, DB, ST, CF 
                FROM reservation WHERE rsv_id = item.rsv_id AND item.rsv_status != 'Cancelled';
                --checks if 10% discount is valid 
                if(StrtDt - rdate  >= 60) then
                    rsv_d := TRUE;
                    dbms_output.put_line('rsv_d');
                end if;
                -- resets temp values for each iteration
                sg_temp :=0;
                db_temp :=0;
                st_temp :=0;
                cf_temp :=0;
                
                -- while loop to take in all days guest stayed at hotel per reservation
                IDt := StrtDt;
                While IDt < EndDt
                loop
                    -- calculates totals by room type 
                    SELECT price INTO SGprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Single' ;
                    temp := SG*SGprice;
                    sg_temp := sg_temp + temp;
                
                    SELECT price INTO DBprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Double' ;
                    temp := DB*DBprice;
                    db_temp := db_temp + temp;
                
                    SELECT price INTO STprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Suite' ;
                    temp := ST*STprice;
                    st_temp := st_temp + temp;
                
                    SELECT price INTO CFprice FROM reservation_pricing WHERE season = szn AND rm_typ = 'Conference' ;
                    temp := CF*CFprice;
                    cf_temp := cf_temp + temp;

                    -- iterates to the next day
                    Idt := Idt + 1;
                end loop;
            
                -- takes in the 10% discount
                if rsv_d = true then
                    sg_temp := sg_temp *.9;
                    db_temp := db_temp *.9;
                    st_temp := st_temp *.9;
                    cf_temp := cf_temp *.9;
                end if;  
            
                --adds the reservation totals to the overall total
                sg_tot := sg_tot + sg_temp;
                db_tot := db_tot + db_temp;
                st_tot := st_tot + st_temp;
                cf_tot := cf_tot + cf_temp;
            
            end loop;
            
            -- Outputting Room Sales totaled
            dbms_output.put_line('Single room sales: ' || sg_tot);
            dbms_output.put_line('Double room sales: ' || db_tot);
            dbms_output.put_line('Suite room sales: ' || st_tot);
            dbms_output.put_line('Conference room sales: ' || cf_tot);    
        end if;                
                        
        -- outputs if there are no services used in the IN state
        open c2;
            fetch c2 into r2;
            if c2%notfound then 
                dbms_output.put_line(' ');
                dbms_output.put_line('No Services applied in  ' || INState);
                no_service := true;
            end if;
        close c2;
    
        if(no_service = false) then
            --calculates totals per services
            for item_s in c2
            loop
                --if restaurant service was used added to to total
                if item_s.srv_id = 1 then
                    r_tot := r_tot + (item_s.sv_qty * item_s.srv_cst);
                --if movie service was used added to to total
                elsif item_s.srv_id = 2 then
                    m_tot := m_tot + (item_s.sv_qty * item_s.srv_cst);
                --if laundry services was used added to to total
                else
                    l_tot := l_tot + (item_s.sv_qty * item_s.srv_cst);
                end if;
            end loop;
        
            --Outputting Serivces totaled 
            dbms_output.put_line('Restaurant sales: ' || r_tot);
            dbms_output.put_line('Pay_Per_View Movie sales: ' || m_tot);
            dbms_output.put_line('Laundry sales: ' || l_tot);
            
            end if;
        
        
        -- Calculates ant outputs the Total Sales in the state
        Tot := sg_tot + db_tot + st_tot + cf_tot + r_tot + m_tot + l_tot;
        dbms_output.put_line('---------------------------------');
        dbms_output.put_line('Total Sales in ' || InState ||': ' || Tot );
    
EXCEPTION
    when no_data_found then  -- If there is no data found 
         dbms_output.put_line('No Rows');
    when too_many_rows then  -- If there are multiple rows found
        dbms_output.put_line('Too many rows');
    when others then  -- If there are other errors
        dbms_output.put_line('There was an error with the procedure Checkout_Report'); 
        dbms_output.put_line('Error Code ' || SQLCODE || ': ' || SQLERRM);
END;
/



--############################# COMMIT #############################
commit;




--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--################################################################################
--########################### PL/SQL - EXEC Statments ############################
--############################# Member 1 - Problem 1 #############################
/*  Adds a new hotel to the hotel table
    run before and after to see results: select * from hotel;
*/  

--Call the procedure add_hotel and insert data (New Hotel)
exec add_hotel('Warwick New York', '65 W 64th St', 'New York', 'NY', '10019', '212-247-2700', 'open', 55, 25, 10, 4);


--Call the procedure add_hotel and insert data (New Hotel)
exec add_hotel('Sheraton Inner Harbor Hotel', '300 S Charles St', 'Baltimore', 'MD', '21201', '410-962-8300', 'open', 100, 60, 40, 10);





--############################# Member 1 - Problem 2 #############################
--You can run select * from hotel; to see what is in the table to compare

--Call the procedure find_hotel, find Hotel ID from Street and display the ID
exec find_hotel('2600 Housley Rd');


--Call the procedure find_hotel, find Hotel ID from Street and display the ID
exec find_hotel('4174 Rowan');





--############################# Member 1 - Problem 3 #############################
--You can run select * from hotel; before and after to see the hstatus change. If already sold the procedure will tell you

--Call the procedure sell_hotel, update hotel status to sold from input hotel id and display all sold hotels
exec sell_hotel(1);


--Call the procedure sell_hotel, update hotel status to sold from input hotel id and display all sold hotels
exec sell_hotel(2);





--############################# Member 1 - Problem 4 #############################
/* Run select * from reservation; to see all the reservations.  You can calculate the number of rooms by 
   1. Taking the input of state and find all hotels in the hotel table that match the state: select * from hotel; to get the 
   hotel id (hid).  
   2. Go back to reservation table and filter for records with the matching hid.  Take the input date and find all reservations
   between the chkin and chkout date. Remove any that were cancelled (Will count on Booked and Completed)
   3. Group those reservations by hid and calculate the total number or rooms reserved.
   4. Go back to hotel table and get the total number of rooms for each hotel (hid) and subtract the reserved rooms. 
*/

--Call the procedure hotel_state_report and display all hotels in the state for the given date (Muliple hotels)
exec hotel_state_report('MD', TO_DATE('05-01-19','DD-MM-YY'));   


--Call the procedure hotel_state_report and display all hotels in the state for the given date (Multiple hotels with multiple dates to calculate)
exec hotel_state_report('KS', TO_DATE('22-03-21','DD-MM-YY'));  


--Call the procedure hotel_state_report and display all hotels in the state for the given date. DW does not exist and will inform user. (No Entries)
exec hotel_state_report('DW', TO_DATE('05-01-19','DD-MM-YY')); 





--############################# Member 2 - Problem 5 #############################
-- Make a reservation. Input Hotel ID, guest name, start date, end date, room type, and date of reservation
-- OUTPUT: Reservation ID

--Hotel ID, Check IN Date, Check OUT Date, Single Room #, double room #, Suite room #, Conference room #, customer ID, Guest Name, Season
exec get_avail_rooms(6,to_date('03-30-21','MM-DD-YY'), to_date('04-25-21','MM-DD-YY'),1,5,2,2,1,'Medha Kunnath', 'OFF'); 




--############################# Member 2 - Problem 6 #############################
--Guest name, Reservation Date (Checkin Date), Hotel ID
--Outputs Reservation ID

--Guest Name, Checkin Date, Hotel ID
exec find_res('Joe Biden', TO_DATE('10-03-21', 'DD-MM-YY'),3);




--############################# Member 2 - Problem 7 #############################
--Input: Reservation ID

--Does not change table(status = completed) - States that ID 9 was completed on date and gives date
 exec cancel_reservation(9); 
 
 --13 is Booked: Updated to cancelled
 --Ran again and stated that 13 was already cancelled. 
 exec cancel_reservation(13); 
 
 --25 does not exist. States no row found.
 exec cancel_reservation(25);
 




--############################# Member 2 - Problem 8 #############################
--Will print all cancelled reservations. 

exec show_cancellations;




--############################# Member 3 - Problem 9 #############################
--Change a Reservation Date. Input (Reservation ID, Checkin Date, End Date)
--If there is availability in the same room type for the new date interval)

exec change_reservation(8, date '2021-12-15', date '2021-05-10');


--############################# Member 3 - Problem 10 #############################
--Show single hotel reservation: Input (Hotel ID) Output: (All reservations for that hotel)

--Input Hotel ID
--Works (2 Reservations)
exec get_reservation(10);

--Completed/Cancelled
exec get_reservation(1);

--2 Completed
exec get_reservation(2);

--1 Booked
exec get_reservation(3);

--No Records
exec get_reservation(50);



--############################# Member 3 - Problem 11 #############################
--Show single guest reservation.  INPUT (guest name) OUTPUT (All reservations under that name)

-- Guest in DB
exec F_Guest('Geethika Sabbineni');
exec F_Guest('Stephen Rule');

-- Guest not in DB
exec F_Guest('Johnathan Kain');




--############################# Member 3 - Problem 12 #############################
--Monthly Income Report. INPUT (No Input) Output (Total income from all sources of all
--   hotels by month.  For each month, display room type, service type.  If there is no income
--   in a month, do not display this month.  Include discounts). 

exec monthly_income;


--############################# Member 4 - Problem 13 #############################
exec add_service(2, 'Pay_per_view movies', date '2019-03-05', 3);
exec add_service(2, 'Restaurant services', date '2019-03-05', 2);
exec add_service(3, 'Laundry services', date '2021-01-10', 5);
exec add_service(6, 'Restaurant services', date '2021-03-07', 7);




--############################# Member 4 - Problem 14 #############################
exec reserved_services_report(1);
exec reserved_services_report(2);
exec reserved_services_report(3);
exec reserved_services_report(6);
exec reserved_services_report(22);




--############################# Member 4 - Problem 15 #############################
/* Testing the "service_report procedure*/
exec service_report('Laundry services');
exec service_report('Restaurant services');
exec service_report('Pay_per_view movies');




--############################# Member 4 - Problem 16 #############################
/*Testing the "service_income_report" procedure*/
exec service_income(2);
exec service_income(1);
exec service_income(5);
exec service_income(15);



--############################# Member 5 - Problem 17 #############################
--Add room to hotel: Input (hotel ID, room type, # of rooms to add); 
--To see results: select * from hotel;
--Note: Will not allow negative numbers

-- Room Type, room QTY, Hotel ID
exec Add_room('Single',8,2); 
exec Add_room('Double', 5,1);
exec Add_room('Suite', 5,1);
exec Add_room('Conference', 5,1);




--############################# Member 5 - Problem 18 #############################
--Show available rooms by type given (INPUT: hotel ID and a specific Date)

-- Hotel ID and Date (To check against)
exec rooms_available(9,to_date('03-10-21','MM-DD-YY'));
exec rooms_available(3,to_date('03-12-21','MM-DD-YY'));
exec rooms_available(7,to_date('04-19-21','MM-DD-YY'));




--############################# Member 5 - Problem 19 #############################
--Checkout Report given (Reservation ID) output (guest name, room number, rate per day, possibly multiple rooms
--  servics rendered per date, type, and amount, discounds if any, and total amount to be paid)

-- Reservation ID
exec checkout_report(1);
exec checkout_report(2);
exec checkout_report(3);




--############################# Member 5 - Problem 20 #############################
--Income by state report: Input is state (MD), Output: total income from all sources of all hotels by room type and service type in 
--   the given state. Includes all discounts

-- State (SC, MD, KS, etc...)
exec income_report ('SC');
exec income_report ('KS');
exec income_report ('MD');