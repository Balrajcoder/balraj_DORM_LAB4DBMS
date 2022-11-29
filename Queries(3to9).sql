-- 3)	Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
SELECT COUNT(B.CUS_GENDER),B.CUS_GENDER FROM (SELECT COUNT(P.CUS_ID), P.CUS_ID ,P.CUS_NAME, P.ORD_AMOUNT,P.CUS_GENDER FROM 
(select `order`.*, customer.cus_gender, 
customer.cus_name from `order` inner join customer where 
`order`.cus_id=customer.cus_id having `order`.ord_amount>=3000) AS P GROUP BY P.CUS_ID) AS B GROUP BY B.CUS_GENDER;

-- 4)	Display all the orders along with product name ordered by a customer having Customer_Id=2

SELECT O.*, P.PRO_NAME FROM `ORDER` O ,PRODUCT P, SUPPLIER_PRICING SP 
WHERE O.CUS_ID=2 
AND O.PRICING_ID= SP.PRICING_ID
AND SP.PRO_ID= P.PRO_ID;

-- 5)	Display the Supplier details who can supply more than one product. 
SELECT S.* FROM SUPPLIER S WHERE S.SUPP_ID IN
(SELECT SP.SUPP_ID FROM SUPPLIER_PRICING AS SP GROUP BY SP.SUPP_ID HAVING COUNT(SUPP_ID)>1);

-- 6)	Find the least expensive product from each category and print the table with category id, 
	   -- name, product name and price of the product
       
 SELECT C.CAT_ID,P.PRO_NAME,P.PRO_ID,SUPP_PRICE FROM CATEGORY C
 INNER JOIN PRODUCT P 
 ON C.CAT_ID=P.CAT_ID
 INNER JOIN SUPPLIER_PRICING SP
 ON SP.PRO_ID=P.PRO_ID WHERE SUPP_PRICE IN (SELECT min(SUPP_PRICE) FROM CATEGORY AS C,PRODUCT AS P,supplier_pricing AS SP
 WHERE C.CAT_ID=P.CAT_ID
 AND SP.PRO_ID=P.PRO_ID GROUP BY C.CAT_ID);      
 
 -- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.
 SELECT PR.PRO_ID,PR.PRO_NAME, ORD.ORD_DATE FROM PRODUCT PR, `ORDER` ORD, SUPPLIER_PRICING SPR 
WHERE ORD.ORD_DATE> '2021-10-05'
AND ORD.PRICING_ID= SPR.PRICING_ID
AND SPR.PRO_ID= PR.PRO_ID;

-- 8)	Display customer name and gender whose names start or end with character 'A'. 
SELECT * FROM CUSTOMER;
SELECT CUS_NAME, CUS_GENDER FROM CUSTOMER WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

-- 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
-- For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 
-- print “Average Service” else print “Poor Service”.

SELECT SUP.SUPP_ID, SUP.SUPP_NAME, R.RAT_RATSTARS,
CASE
WHEN R.RAT_RATSTARS =5 THEN 'Excellent Service'
WHEN R.RAT_RATSTARS >=4 THEN 'Good Service'
WHEN R.RAT_RATSTARS >2 THEN 'Average service'
ELSE 'POOR SERVICE'
END AS TYPE_OF_SERVICE
FROM RATING R, SUPPLIER SUP, `ORDER` ORD,SUPPLIER_PRICING SUPP
WHERE R.ORD_ID =ORD.ORD_ID
AND ORD.PRICING_ID = SUPP.PRICING_ID
AND SUPP.SUPP_ID = SUP.SUPP_ID;

 
-- ----------------------BELOW IS THE CREATED STORE PROCEDURE USING ABOVE STATEMENTS(ATTACHED AS SEPERATE FILE)------------------------------------
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `RATING FOR TYPE OF SERVICE`()
-- BEGIN
-- SELECT SUP.SUPP_ID, SUP.SUPP_NAME, R.RAT_RATSTARS,
-- CASE
-- WHEN R.RAT_RATSTARS =5 THEN 'Excellent Service'
-- WHEN R.RAT_RATSTARS >=4 THEN 'Good Service'
-- WHEN R.RAT_RATSTARS >2 THEN 'Average service'
-- ELSE 'POOR SERVICE'
-- END AS TYPE_OF_SERVICE
-- FROM RATING R, SUPPLIER SUP, `ORDER` ORD,SUPPLIER_PRICING SUPP
-- WHERE R.ORD_ID =ORD.ORD_ID
-- AND ORD.PRICING_ID = SUPP.PRICING_ID
-- AND SUPP.SUPP_ID = SUP.SUPP_ID; 
-- END

-- CALL STATEMENT FOR CREATED STORED PROCEDURE 
CALL `RATING FOR TYPE OF SERVICE`();



