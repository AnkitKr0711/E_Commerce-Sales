USE E_COMMERCE;
	SELECT * FROM Customers;
	SELECT * FROM Orders;
	SELECT * FROM Products;
	SELECT * FROM Category;
	SELECT * FROM OrderDetails;
	SELECT * FROM Shippers;
	SELECT * FROM Payments;
---1 A
WITH CTE AS(
	SELECT CustomerID,COUNT(CustomerID) AS Ordered FROM Orders WHERE (DATEDIFF(MONTH,OrderDate,GETDATE())<=6)
	GROUP BY CustomerID HAVING COUNT(CustomerID)=1)
SELECT * FROM CTE;
---A.a
	SELECT P.Category_ID,COUNT(O.CustomerID) AS Total_purchase
				FROM Products AS P  JOIN OrderDetails AS OD ON P.ProductID = OD.ProductID
								    JOIN Orders AS O ON OD.OrderID=O.OrderID
				WHERE  EXISTS (SELECT CustomerID,COUNT(CustomerID) AS Ordered FROM Orders WHERE (DATEDIFF(MONTH,OrderDate,GETDATE())<=6)GROUP BY CustomerID HAVING COUNT(CustomerID)=1)	 
				GROUP BY P.Category_ID;	

	SELECT P.Category_ID,COUNT(O.CustomerID) AS Total_purchase
				FROM (SELECT CustomerID,COUNT(CustomerID)AS Ordered FROM Orders WHERE (DATEDIFF(MONTH,OrderDate,GETDATE())<=6)GROUP BY CustomerID HAVING COUNT(CustomerID)=1) 
				AS tempo LEFT JOIN Orders AS O ON O.CustomerID=tempo.CustomerID
						 JOIN OrderDetails AS OD ON OD.OrderID=O.OrderID
						 JOIN Products AS p ON P.ProductID=OD.ProductID
				WHERE (DATEDIFF(MONTH,O.OrderDate,GETDATE())<=6)
				GROUP BY P.Category_ID HAVING COUNT(O.CustomerID)=1;
				
---1B
	SELECT DISTINCT CustomerID,SUM(Total_order_amount) AS Amount FROM Orders WHERE (MONTH(OrderDate)=12 or MONTH(OrderDate)=11 or 
		MONTH(OrderDate)=10) AND (YEAR(OrderDate)=2021) GROUP BY CustomerID HAVING SUM(Total_order_amount) >7000;
---1C
	SELECT P.Category_ID, COUNT(O.OrderID) AS Order_placed INTO Tempo 
														  FROM Category AS C JOIN Products AS P  ON C.CategoryID=P.Category_ID
																			  JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID 
																			  JOIN Orders AS O ON OD.OrderID=O.OrderID
														  WHERE YEAR(O.OrderDate)=2021 GROUP BY  P.Category_ID ORDER BY Order_placed
	SELECT Category_ID,MAX(Order_placed),MIN(Order_placed) FROM Tempo GROUP BY Category_ID;


SELECT L.* FROM
(SELECT TOP 1 P.Category_ID, COUNT(O.OrderID) AS Order_placed
FROM Products AS P
JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID
JOIN Orders AS O ON OD.OrderID=O.OrderID
 WHERE YEAR(o.OrderDate)=2021
  GROUP BY  P.Category_ID
 ORDER BY Order_placed) AS L
UNION
SELECT T.* FROM(SELECT TOP 1 P.Category_ID, COUNT(O.OrderID) AS Order_placed FROM Products AS P
JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID
JOIN Orders AS O ON OD.OrderID=O.OrderID
 WHERE YEAR(o.OrderDate)=2021
 GROUP BY  P.Category_ID
 ORDER BY Order_placed desc) AS T

select categoryname, count(b.productid) orders_category, sum(quantity) as total_product_qty
from orders as A 
inner join orderdetails as b on a.orderid = b.orderid
inner join products as c on b.productid = c.productid
inner join category as d on c.category_id = d.categoryid
group by categoryname
order by total_product_qty desc;
---1D
	SELECT S.CompanyName,AVG(DATEDIFF(DD,O.ShipDate,O.DeliveryDate)) AS Delivery_Time FROM Orders AS O JOIN Shippers AS S 
	ON O.ShipperID=S.ShipperID GROUP BY S.CompanyName HAVING AVG(DATEDIFF(DD,O.ShipDate,O.DeliveryDate))<3 ;
	SELECT S.CompanyName,DATEDIFF(DD,O.ShipDate,O.DeliveryDate) AS Delivery_Time FROM Orders AS O JOIN Shippers AS S 
	ON O.ShipperID=S.ShipperID GROUP BY S.CompanyName ,DATEDIFF(DD,O.ShipDate,O.DeliveryDate);
---1E
	SELECT C.CategoryID,C.CategoryName,S.CompanyName,AVG(DATEDIFF(DD,O.OrderDate,O.DeliveryDate)) AS Delivery_time
										FROM Category AS C JOIN Products AS P ON C.CategoryID=P.Category_ID
														   JOIN OrderDetails AS OD ON P.ProductID= OD.ProductID
														   JOIN Orders AS O ON OD.OrderID=O.OrderID
														   JOIN Shippers AS S ON O.ShipperID= S.ShipperID
										GROUP BY S.CompanyName,C.CategoryID,C.CategoryName ORDER BY C.CategoryID ;

---1F	
	SELECT P.PaymentType,O.PaymentID,Count(O.PaymentID) AS Total_no_Payment FROM Payments as P JOIN Orders AS O ON P.PaymentID=O.PaymentID
													    GROUP BY P.PaymentType,O.PaymentID ORDER BY Total_no_Payment;
---1G
	SELECT DISTINCT MONTH(O1.OrderDate) AS MONTH_21, COUNT(O2.OrderID) AS Total_Order_Placed,COUNT(O2.CustomerID) AS Total_Customer,
	SUM(O2.Total_order_amount) AS Total_Amount FROM Orders AS O1 JOIN Orders AS O2 ON MONTH(O1.OrderDate)=MONTH(O2.OrderDate) AND MONTH(O1.OrderDate)>=MONTH(O2.OrderDate)
	WHERE YEAR(O1.OrderDate)=2021  GROUP BY MONTH(O1.OrderDate) ORDER BY MONTH(O1.OrderDate);
---1H
	SELECT s.CompanyName, S.Country, c.Country, COUNT(o.OrderID) AS no_of_orders 
												FROM Suppliers AS s JOIN OrderDetails AS od ON od.SupplierID=s.SupplierID 
																	JOIN Orders AS o ON od.OrderID = o.OrderID 
																	JOIN Customers AS c ON c.CustomerID=o.CustomerID 
												WHERE c.Country=s.Country GROUP BY s.CompanyName, S.Country, c.Country;

---1I
	SELECT O1.OrderDate,SUM(O2.Total_order_amount) AS Total_2021_Orders FROM Orders AS O1 JOIN  Orders AS O2 
										ON O1.CustomerID=O2.CustomerID AND O1.OrderDate>=O2.OrderDate
										WHERE YEAR(O1.OrderDate)=2021 GROUP BY O1.OrderDate ORDER BY O1.OrderDate;
---1J
		SELECT O1.OrderDate,COUNT(O2.OrderID) AS Orders_placed FROM Orders AS O1 JOIN  Orders AS O2 
										ON O1.CustomerID=O2.CustomerID AND O1.OrderDate>=O2.OrderDate
										WHERE YEAR(O1.OrderDate)=2020 GROUP BY O1.OrderDate ORDER BY O1.OrderDate;
USE DPP8
		CREATE TABLE Table_1 (
		A TINYINT NULL,
		B NVARCHAR(2) NOT NULL
		);
		CREATE TABLE Table_2 (
		A TINYINT NULL,
		C NVARCHAR(2) NOT NULL
		);
		INSERT INTO Table_1 (A,B) VALUES (1,'B1'),(1,'B2'),(1,'B3'),(3,'B4'),(3,'B5'),(5,'B6'),(5,'B7'),(5,'B8'),(Null,'B9');
		INSERT INTO Table_2 (A,C) VALUES (1,'C1'),(1,'C2'),(3,'C3'),(3,'C4'),(3,'C5'),(NULL,'C6'),(4,'C7'),(5,'C8'),(NULL,'C9');

		SELECT * FROM Table_1 CROSS JOIN Table_2 ;