#--Haro, Vinicio 
#--SQL Winter Bridge 2018
#--Assignment 3

#--This project is where you show off your ability to (1) translate a business requirement into a database design, (2) design
#--a database using one-to-many and many-to-many relationships, and (3) know when to use LEFT and/or RIGHT JOINs to
#--build result sets for reporting.

#--Background:
#--An organization grants key-card access to rooms based on groups that key-card holders belong to. You may assume that
#--users below to only one group. Your job is to design the database that supports the key-card system.

#--Requirments 
#--There are six users, and four groups. Modesto and Ayine are in group “I.T.” Christopher and Cheong woo are in group
#--“Sales”. There are four rooms: “101”, “102”, “Auditorium A”, and “Auditorium B”. Saulat is in group
#--“Administration.” Group “Operations” currently doesn’t have any users assigned. I.T. should be able to access Rooms
#--101 and 102. Sales should be able to access Rooms 102 and Auditorium A. Administration does not have access to any
#--rooms. Heidy is a new employee, who has not yet been assigned to any group.

#--Begin Database Design 
#--Create keycard schema 
drop schema if exists keycard1; 
create schema keycard1;
use keycard1;


#--Lets define the groups in a groups table.
drop table if exists groups;
create table groups (
group_id integer primary key,
group_name varchar(150) not null);

#--populate the groups definition table 
insert into  groups (group_id, group_name)
values (1, 'I.T');

insert into groups (group_id, group_name)
values (2, 'Sales');

insert into groups (group_id, group_name)
values (3, 'Administration');

insert into groups (group_id, group_name)
values (4, 'Operations');

select * from groups;

#--create a users to groups map
drop table if exists users_groups;
create table users_groups (
user_id integer primary key,
name varchar(150) not null, 
group_id integer references groups(group_id));

#--populate the users to groups table with the required relationships 
#I.T
insert into users_groups (user_id, name, group_id)
values (1,'Modesto', 1);
#I.T
insert into users_groups (user_id, name, group_id)
values (2,'Ayine', 1);
#Sales
insert into users_groups (user_id, name, group_id)
values (3,'Christopher', 2);
#Sales
insert into users_groups (user_id, name, group_id)
values (4,'Cheong woo', 2);
#Administration 
insert into users_groups (user_id, name, group_id)
values (5,'Saulat', 3);
#Not Assigned a group
insert into users_groups (user_id, name, group_id)
values (6,'Heidy', null);

select * from users_groups;


#--define the rooms in a rooms table 
drop table if exists rooms;
create table rooms (
room_id integer primary key, 
room_name varchar(150) not null);

insert into rooms (room_id, room_name)
values (1, '101');

insert into rooms (room_id, room_name)
values (2, '102');

insert into rooms (room_id, room_name)
values (3, 'Auditorium A');

insert into rooms (room_id, room_name)
values (4, 'Auditorium B');

select * from rooms;

#--create a room to groups map
drop table if exists groups_rooms; 
create table groups_rooms (
group_id integer references groups(group_id),
room_id integer references rooms(room_id));

#--populate the room to groups map with the required conditions 
#I.T can access room 101
insert into groups_rooms (group_id, room_id)
values (1, 1);

#I.T Can access room 102 
insert into groups_rooms (group_id, room_id)
values (1, 2);

#Sales can access room 102
insert into groups_rooms (group_id, room_id)
values (2, 2);

#Sales can access Auditorium A
insert into groups_rooms (group_id, room_id)
values (2, 3);


select * from groups_rooms;


#---Proceed to writing a query for reporting 
#--Next, write SELECT statements that provide the following information:

#-- All groups, and the users in each group. A group should appear even if there are no users assigned to the group.
select 
a.group_id,
a.group_name as 'Group',  
b.name as 'Employee'
from groups a
left join users_groups b 
on a.group_id = b.group_id;


#--All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been
#--assigned to them
Select 
a.room_id,
a.room_name as 'Room', 
c.group_name as 'Group'
from rooms a
left join groups_rooms b 
on (a.room_id = b.room_id)
left join groups c 
on (b.group_id = c.group_id);



#--A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted
#--alphabetically by user, then by group, then by room.
select 
a.user_id as 'Employee ID', 
a.name as 'Employee', 
b.group_name as 'Group', 
d.room_name as 'Room'
from users_groups a
left join groups b on (a.group_id=b.group_id)
left join groups_rooms c on (b.group_id=c.group_id)
left join rooms d on (c.room_id=d.room_id)
order by a.name, b.group_name, d.room_name;


















