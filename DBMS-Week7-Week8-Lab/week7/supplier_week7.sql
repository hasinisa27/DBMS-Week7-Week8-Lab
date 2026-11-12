create database supplier;

use supplier;

# week 7
# Question 1. Create tables with primary keys and foreign keys.

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(30),
    city VARCHAR(30)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(30),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10,2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

# Question 2. Insert appropriate records into each table.

INSERT INTO Supplier VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');
select * from Supplier;

INSERT INTO Parts VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');
select * from Parts;

INSERT INTO Catalog VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

# Question 3. Find the names of parts for which there is some supplier.
SELECT DISTINCT P.pname
FROM Parts P
JOIN Catalog C
ON P.pid = C.pid;

# Question 4. Find the names of suppliers who supply every part.
SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.sid = S.sid
        AND C.pid = P.pid
    )
);

 # Question 5. Find the names of suppliers who supply every red part.
SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Parts P
    WHERE P.color = 'Red'
    AND NOT EXISTS (
        SELECT *
        FROM Catalog C
        WHERE C.sid = S.sid
        AND C.pid = P.pid
    )
);

# Question 6. Find the names of parts supplied by Acme Widget Suppliers and by no one else.
SELECT P.pname
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Supplier S ON C.sid = S.sid
WHERE S.sname = 'Acme Widget'
AND NOT EXISTS (
    SELECT *
    FROM Catalog C2
    WHERE C2.pid = P.pid
    AND C2.sid <> S.sid
);

# Question 7. Find the SIDs of suppliers who charge more for some part than the average cost of that part.
SELECT DISTINCT C1.sid
FROM Catalog C1
WHERE C1.cost > (
    SELECT AVG(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C1.pid
);

# Question 8. For each part, find the supplier name who charges the most for that part.
SELECT C.pid, S.sname
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);

