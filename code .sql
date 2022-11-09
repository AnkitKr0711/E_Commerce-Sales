--- After Uploading the file from the drive taking a glance of table

USE E_COMMERCE;
	SELECT * FROM Customers;
	SELECT * FROM Orders;
	SELECT * FROM Products;
	SELECT * FROM Category;
	SELECT * FROM OrderDetails;
	SELECT * FROM Shippers;
	SELECT * FROM Payments;
	
--- Changing Data type to datetime format 

Alter Table Customers ALTER COLUMN DateEntered datetime

---1.A
WITH CTE AS(
	SELECT CustomerID,COUNT(CustomerID) AS Ordered FROM Orders WHERE (DATEDIFF(MONTH,OrderDate,GETDATE())<=6)
	GROUP BY CustomerID HAVING COUNT(CustomerID)=1)
SELECT * FROM CTE;				
---1B
	SELECT DISTINCT CustomerID,SUM(Total_order_amount) AS Amount FROM Orders WHERE (MONTH(OrderDate)=12 or MONTH(OrderDate)=11 or 
		MONTH(OrderDate)=10) AND (YEAR(OrderDate)=2021) GROUP BY CustomerID HAVING SUM(Total_order_amount) >7000;
---1C
	SELECT P.Category_ID, COUNT(O.OrderID) AS Order_placed INTO Tempo FROM Category AS C JOIN Products AS P  ON C.CategoryID=P.Category_ID
	JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID JOIN Orders AS O ON OD.OrderID=O.OrderIDWHERE YEAR(O.OrderDate)=2021 GROUP BY  P.Category_ID ORDER BY Order_placed
	SELECT Category_ID,MAX(Order_placed),MIN(Order_placed) FROM Tempo GROUP BY Category_ID;

---1D
	SELECT S.CompanyName,AVG(DATEDIFF(DD,O.ShipDate,O.DeliveryDate)) AS Delivery_Time FROM Orders AS O JOIN Shippers AS S 
	ON O.ShipperID=S.ShipperID GROUP BY S.CompanyName HAVING AVG(DATEDIFF(DD,O.ShipDate,O.DeliveryDate))<3 ;
	SELECT S.CompanyName,DATEDIFF(DD,O.ShipDate,O.DeliveryDate) AS Delivery_Time FROM Orders AS O JOIN Shippers AS S 
	ON O.ShipperID=S.ShipperID GROUP BY S.CompanyName ,DATEDIFF(DD,O.ShipDate,O.DeliveryDate);
---1E
	SELECT C.CategoryID,C.CategoryName,S.CompanyName,AVG(DATEDIFF(DD,O.OrderDate,O.DeliveryDate)) AS Delivery_time
	FROM Category AS C JOIN Products AS P ON C.CategoryID=P.Category_ID JOIN OrderDetails AS OD ON P.ProductID= OD.ProductID
	JOIN Orders AS O ON OD.OrderID=O.OrderID JOIN Shippers AS S ON O.ShipperID= S.ShipperID
	GROUP BY S.CompanyName,C.CategoryID,C.CategoryName ORDER BY C.CategoryID ;

---1F	
	SELECT P.PaymentType,O.PaymentID,Count(O.PaymentID) AS Total_no_Payment FROM Payments as P JOIN Orders AS O ON P.PaymentID=O.PaymentID
	GROUP BY P.PaymentType,O.PaymentID ORDER BY Total_no_Payment;
---1G
	SELECT DISTINCT MONTH(O1.OrderDate) AS MONTH_21, COUNT(O2.OrderID) AS Total_Order_Placed,COUNT(O2.CustomerID) AS Total_Customer,
	SUM(O2.Total_order_amount) AS Total_Amount FROM Orders AS O1 JOIN Orders AS O2 ON MONTH(O1.OrderDate)=MONTH(O2.OrderDate) AND MONTH(O1.OrderDate)>=MONTH(O2.OrderDate)
	WHERE YEAR(O1.OrderDate)=2021  GROUP BY MONTH(O1.OrderDate) ORDER BY MONTH(O1.OrderDate);
---1H
	SELECT s.CompanyName, S.Country, c.Country, COUNT(o.OrderID) AS no_of_orders FROM Suppliers AS s JOIN OrderDetails AS od ON od.SupplierID=s.SupplierID 
	JOIN Orders AS o ON od.OrderID = o.OrderID JOIN Customers AS c ON c.CustomerID=o.CustomerID 
	WHERE c.Country=s.Country GROUP BY s.CompanyName, S.Country, c.Country;

---1I
	SELECT O1.OrderDate,SUM(O2.Total_order_amount) AS Total_2021_Orders FROM Orders AS O1 JOIN  Orders AS O2 
	ON O1.CustomerID=O2.CustomerID AND O1.OrderDate>=O2.OrderDate
	WHERE YEAR(O1.OrderDate)=2021 GROUP BY O1.OrderDate ORDER BY O1.OrderDate;
---1J
	SELECT O1.OrderDate,COUNT(O2.OrderID) AS Orders_placed FROM Orders AS O1 JOIN  Orders AS O2 ON O1.CustomerID=O2.CustomerID AND O1.OrderDate>=O2.OrderDate
	WHERE YEAR(O1.OrderDate)=2020 GROUP BY O1.OrderDate ORDER BY O1.OrderDate;
---1K  
	SELECT MONTH(DateEntered) AS Months,YEAR(DateEntered) AS Years,CustomerID INTO #Temp_Table2  FROM Customers;
	SELECT Months,[2020],[2021] FROM #Temp_Table2
		PIVOT(
		COUNT(CustomerID) FOR Years IN ([2020],[2021])
		) AS pivotal_table;
----1L
	WITH CTE_Table AS(
	SELECT  P.Category_ID,P.Product,SUM(OD.Quantity)AS Total_sold,DENSE_RANK()OVER(PARTITION BY Category_ID ORDER BY SUM(OD.Quantity) DESC) AS Rnk
	FROM Category AS C JOIN Products AS P ON C.CategoryID=P.Category_ID JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID  
	JOIN Orders AS O ON OD.OrderID=O.OrderID WHERE C.Active='Yes' GROUP BY P.Category_ID,P.Product)
	SELECT Category_ID,Product,Total_sold, Rnk FROM CTE_Table WHERE Rnk<=3 GROUP BY Category_ID,Product,Total_sold,Rnk ORDER BY Category_ID,Rnk;
--- 1M
	SELECT * FROM Products AS P JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID JOIN Orders AS O ON OD.OrderID=O.OrderID 
	PIVOT(
	COUNT(P.Product) FOR P.Category_ID IN ([5001],[5002],[5003],[5004])
	) AS Pivotal_table1;
--- 1N
	SELECT CustomerID,OrderDate,Total_order_amount, AVG(Total_order_amount)OVER(PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING and CURRENT ROW)AS avg_purchase 
	FROM Orders GROUP BY CustomerID,Total_order_amount,OrderDate ORDER BY CustomerID;
----1O 
	SELECT MONTH(OrderDate)AS Months_2021,CustomerID,SUM(Total_order_amount), AVG(SUM(Total_order_amount))OVER(PARTITION BY MONTH(OrderDate) ORDER BY CustomerID) AS CUML_AVG
	FROM Orders WHERE YEAR(OrderDate)=2021 GROUP BY CustomerID,MONTH(OrderDate) ORDER BY MONTH(OrderDate);