--Author: Jingwen Xia
--Assignment# 3 / Part 1 
--Date due: 03/16/2025
--I pledge that I have completed this assignment without collaborating
--with anyone else, in conformance with the NYU School of Engineering
--Policies and Procedures on Academic Misconduct.

CREATE TABLE hotel(
    hotelno CHAR(4),
    hotename VARCHAR(50),
    hotelcity VARCHAR(50),
    PRIMARY KEY(hotelno)
);

CREATE TABLE room (
	roomno INT,
    hotelno CHAR(4),
	roomtype CHAR(1),
	roomprice DECIMAL(8,2),
	FOREIGN KEY (hotelno) REFERENCES hotel(hotelno),
	PRIMARY KEY(roomno,hotelno)
);
CREATE TABLE guest(
    guestno CHAR(4),
    guestname VARCHAR(50),
    guestcity VARCHAR(50),
    PRIMARY KEY(guestno)
);

CREATE TABLE booking(
    hotelno CHAR(4),
    roomno INT,
    guestno CHAR(4),
    datefrom DATE,
    dateto DATE,
    FOREIGN KEY(hotelno, roomno)REFERENCES room(hotelno,roomno),
    FOREIGN KEY (guestno) REFERENCES guest(guestno),
    PRIMARY KEY(hotelno, guestno, roomno, datefrom)
    
);