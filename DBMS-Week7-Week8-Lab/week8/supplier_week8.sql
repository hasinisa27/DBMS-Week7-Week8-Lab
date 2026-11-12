# week 8
# Question 1. Find the most expensive part overall and the supplier who supplies it.
SELECT P.pname, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(cost)
    FROM Catalog
);

# Question 2. Find suppliers who DO NOT supply any red parts.
SELECT S.sname
FROM Supplier S
WHERE NOT EXISTS (
    SELECT *
    FROM Catalog C
    JOIN Parts P ON C.pid = P.pid
    WHERE C.sid = S.sid
    AND P.color = 'Red'
);

# Question 3. Show each supplier and the total value of all parts they supply.
SELECT S.sname, SUM(C.cost) AS total_value
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;

# Question 4. Find suppliers who supply at least 2 parts cheaper than $20.
SELECT S.sname
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
WHERE C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT C.pid) >= 2;

# Question 5. List suppliers who offer the cheapest cost for each part.
SELECT P.pname, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MIN(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = P.pid
);

# Question 6. Create a view of the most expensive supplier for each part.
CREATE VIEW Expensive_Supplier AS
SELECT C.pid, P.pname, S.sname, C.cost
FROM Catalog C
JOIN Parts P ON C.pid = P.pid
JOIN Supplier S ON C.sid = S.sid
WHERE C.cost = (
    SELECT MAX(C2.cost)
    FROM Catalog C2
    WHERE C2.pid = C.pid
);
SELECT * FROM Expensive_Supplier;

# Question 7. Create a trigger to prevent inserting a Catalog cost below 1.
DELIMITER //

CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NOT NULL AND NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost cannot be below 1';
    END IF;
END //

DELIMITER ;

# Question 8. Create a trigger to set a default cost if it is not provided.
DELIMITER //

CREATE TRIGGER set_default_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
FOLLOWS prevent_low_cost
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10;
    END IF;
END //

DELIMITER ;

INSERT INTO Catalog (sid, pid, cost)
VALUES (10002, 20004, NULL);

SELECT * FROM Catalog
WHERE sid = 10002 AND pid = 20004;