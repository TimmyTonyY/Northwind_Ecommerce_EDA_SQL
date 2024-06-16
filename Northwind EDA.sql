/*
PROBLEM OBJECTIVE
Explore and understand the Northwind e-commerce database, focusing on various aspects of customer orders, 
employee performance, product sales, and overall business insights. 
*/

use northwind;

-- 1. What is the total price of the products ordered in OrderID 10248?

select orderid, sum(unitprice * quantity) as total_price
from `order details`
where orderid = 10248
group by OrderID;

-- 2. What is the total number of orders placed by the customer with CustomerID ALFKI?

select customerid,count(orderid) as total_number
from orders
where CustomerID= 'ALFKI'
group by CustomerID;

-- 3. What is the name of the employee with EmployeeID 5?

select employeeid, firstname, lastname
from employees
where EmployeeID=5;

-- 4. What is the total number of orders in the Orders table?

select count(orderid) as number_of_order
from orders;

-- 5. What is the average quantity of each product that has been ordered?

select od.productid, p.productname ,round(avg(od.quantity)) as 'average product'
from `order details` od
join products p on p.productid = od.productid
group by productid
order by 1;

-- 6. What are the ID of all the customers who have placed orders in the year 1997?

select customerid, year(orderdate) as year_order
from orders
where year(orderdate)='1997';

-- 7. What are the IDs of the top 20 best performing employees who have sold products to customersin the year 1997?

select employeeid, count(customerid) `NO OF CUSTOMERS`, year(orderdate) as Year_order
from orders
where year(orderdate)= '1997' 
group by employeeid, year_order
order by count(customerid) desc
limit 20;

-- 8. Which top 5 customer has placed the most number of orders?

select customerid, count(orderid) as `No of order`
from orders
group by customerid
order by count(orderid) desc
limit 5;

-- 9. What is the total amount spent by each customer in the year 1997 on orders sold by employee 3?
                
select o.employeeid, o.customerid, round(sum(od.unitprice * od.quantity))as `total spent`
from orders o
join `order details` od on o.orderid = od.orderid
where year(orderdate) = '1997'
                and employeeid = 3
                group by 1, 2;

-- 10. What are the IDs of all the employees who have sold products to customers in France?

select distinct employeeid, shipcountry
from orders
where shipcountry='france';

-- 11. What is the average freight it cost to ship to each city in the Canada in the –ember months of 1997?

select round(avg(freight)), shipcountry, shipcity
from orders
where shipcountry= 'canada' and
shippeddate between '1997-09-01' and '1997-12-31'
group by 3, 2;

-- 12. What is the average revenue of each product that has been ordered less than 10 times?

select productid, count(orderid), avg(unitprice * quantity) as revenue 
from `order details`
group by productid
having count(orderid) < 10;

-- 13. What are the ID of all the customers who have placed orders in the first quarter of year 1997?

select customerid, orderdate
from orders
where orderdate between '1997-01-01' and '1997-03-31';

-- 14. What is the total freight that was paid by customers in the USA to employee 4?

select employeeid, shipcountry, round(sum(freight))
from orders
where shipcountry= 'USA' and employeeid=4;

-- 15. What are the IDs of the top 6 best performing employees who have sold products to customers in the year 1997?

select employeeid, customerid, count(orderid) as `No of orders`, year(orderdate) as year_order
from orders
where year(orderdate) = '1997'
group by 1,2,4
order by count(orderid) desc
limit 6;

-- 16. Create a report showing OrderDate, ShippedDate, CustomerID, Freight of all orders placed on 21 May 1996.

select customerid, orderdate, shippeddate, freight
from orders
where orderdate = date(1996-05-21);

-- 17. Create a report that shows the EmployeeID, OrderID, CustomerID, RequiredDate, ShippedDate from all orders shipped later than the required date.

select orderid, customerid, employeeid, requireddate, shippeddate
from orders
where shippeddate > requireddate;

-- 18. Create a report that shows the City, CompanyName, ContactName of customers from cities starting with A or B.

select companyname, contactname, city
from customers
where city like 'A%' or city like 'B%'
order by city;

/* 19. Create a report that shows the SupplierID, ProductName, CompanyName from all product Supplied by Exotic Liquids,
Specialty Biscuits, Ltd., Escargots Nouveaux sorted by the supplier ID */

select s.supplierid, s.companyname, p.productname
from suppliers s
join products p on p.supplierid = s.supplierid
where companyname in ( 'exotic liquids', 'specialty biscuits, ltd.', 'escargots nouveaux')
order by supplierid;

/* 20. Create a report that shows the ShipPostalCode, OrderID, OrderDate, RequiredDate, ShippedDate, 
ShipAddress of all orders with ShipPostalCode beginning with "98124". */

select orderid, orderdate, requireddate, shippeddate, shipaddress, shippostalcode
from orders
where shippostalcode like '98124%';

/* 21. Create a report that shows the average UnitPrice rounded to the next whole number, total price of UnitsInStock and
maximum number of orders from the products table. All saved as AveragePrice, TotalStock and MaxOrder respectively. */

with cte_1 as (
select round(avg(unitprice)) as averageprice
from products
),
cte_2 as (
select round(sum(unitsinstock * unitprice)) as totalstock
from products
),
cte_3 as (
select max(unitsonorder) as maxorder
from products
)
select averageprice, totalstock, maxorder
from cte_1, cte_2, cte_3;

-- 22. Create a report that shows the SupplierID, CompanyName, CategoryName, ProductName and UnitPrice from the products, suppliers and categories table.

select s.supplierid, s.companyname, c.categoryname, p.productname, p.unitprice
from suppliers s
join products p on p.productid = s.supplierid
join categories c on c.categoryid = p.categoryid;

/* 23. Create a report that shows the CustomerID, sum of Freight, from the orders table with sum of freight greater $200, grouped
by CustomerID. */

select customerid, sum(freight) as total_freight
from orders
group by customerid
having total_freight > 200 ;

/* 24. Create a report that shows the OrderID ContactName, UnitPrice, Quantity, Discount from the order details, orders and
customers table with discount given on every purchase.*/

select od.orderid, c.contactname, od.unitprice, od.quantity, od.discount
from `order details`od
join orders o on o.orderid = od.orderid
join customers c on c.customerid = o.customerid;

/* 25. Create a report that shows the EmployeeID, the LastName and FirstName as employee, and the LastName and FirstName of
who they report to as manager from the employees table sorted by Employee ID.*/

select e.employeeid, 
       concat_ws(' ',e.firstname,e.lastname) as employee, 
       concat_ws(' ', m.firstname,m.lastname) as manager
from employees e
join employees m on m.employeeid = e.reportsto
order by employeeid;

/* 26. Create a view named CustomerInfo that shows the CustomerID, CompanyName, ContactName, ContactTitle, Address, City,
Country, Phone, OrderDate, RequiredDate, ShippedDate from the customers and orders table.*/

create view customerinfo as
select c.customerid, c.companyname, c.contacttitle, c.address, c.city, c.country, c.phone,
       o.orderdate, o.requireddate, o.shippeddate
from orders o
join customers c on c.customerid = o.customerid;

/* 27. Create a view named ProductDetails that shows the ProductID, CompanyName, ProductName, CategoryName, Description,
QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued from the supplier, products and
categories tables.*/

create view productDetails as
select p.productid, s.companyname, p.productname, c.categoryname, c.description,
       p.quantityperunit, p.unitprice, p.unitsonorder, p.reorderlevel, p.discontinued
from categories c
join products p on p.categoryid = c.categoryid
join suppliers s on s.supplierid = p.supplierid;

-- 28. Create a report that shows the CompanyName and ProductName from all product in the Seafood category.

select c.companyname, p.productname, ca.categoryname
from `order details` od
join orders o on o.orderid = od.orderid
join customers c on c.customerid = o.customerid
join products p on p.productid = od.productid
join categories ca on ca.categoryid = p.categoryid
where categoryname = 'seafood';

-- 29. Create a report that shows the CategoryID, CompanyName and ProductName from all product in the categoryID 5.

select ca.categoryid, c.companyname, p.productname
from `order details` od
join orders o on o.orderid = od.orderid
join customers c on c.customerid = o.customerid
join products p on p.productid = od.productid
join categories ca on ca.categoryid = p.categoryid
where ca.categoryid ='5';

/* 30. Create a select statement that ouputs the following from the employees table.
NB: The age might differ depending on the year you are attempting this query. */

select lastname, firstname, title, concat_ws(' ',(year(now()) - year(birthdate)),'years') as age
from employees;

/* 31. Create a report that the CompanyName and total number of orders by customer renamed as number of orders since
Decemeber 31, 1994. Show number of Orders greater than 10. */

select c.companyname, count(od.orderid) as `num of orders`
from `order details` od
join orders o on o.orderid = od.orderid
join customers c on c.customerid = o.customerid
where (year(o.orderdate) = 1994) - (month(o.orderdate) = 12) - ( day(o.orderdate) = 31 )
group by c.companyname
having `num of orders` > 10;

-- 32. retutn the orders sent to US, UK, france and mexico
select orderid, freight, shipcountry
from orders
where shipcountry in ('uk','usa', 'france', 'mexico');

-- 33. Return the orders sent to canada in the second half of 1997
select orderid, shippeddate, shipcountry
from orders
where (shipcountry= 'canada') and
	  (shippeddate between '1997-07-01' and '1997-12-31');
 
 -- 34. returns the top 10 most expensive orders in terms of freight also return the countries they were sent
 
 select shipcountry, freight, orderid
 from orders 
 order by freight desc
 limit 10;
 
 -- 35. return the top 3 highest paid staff in the US or UK
 select firstname, lastname, salary, country
 from employees
 where country in ('USA', 'UK')
 order by salary desc
 limit 3;
 
 -- 36. return the productid and total revenue generated from products with atleast 50,000 total revenue generated

select productid, round(sum(unitprice* quantity)) as revenue
from `order details`
group by productid
having revenue >50000
order by revenue desc;

-- 37. write a query that returns the number of orders sold and revenue generated from all the cities in the us.
 select shipcity, count(o.orderid) as no_orders,
        round(sum(unitprice * quantity)) as revenue
from orders as o
join `order details` od on od.orderid=o.orderid
where shipcountry = 'USA'
group by shipcity;

-- 38. write a query that returns the top 10 most expensive orders, the customers they were sold to and the employees responsible for the sales.

select c.companyname, concat_ws(' ', e.firstname, e.lastname) as employees_name, (round(od.unitprice * od.quantity)) as  total_cost
from `order details` od
join orders o on o.orderid = od.orderid
join customers c on c.customerid = o.customerid
join employees e on e.employeeid = o.employeeid
order by total_cost desc
limit 10;

-- 39. return the total cost of the most expensive order sent to each country

select o.shipcountry, round(max(od.unitprice * od.quantity))as total_cost
from orders o
join `order details` od on od.orderid = o.orderid
group by shipcountry;

-- 40. write a query that returns the names of employees that earn above average salary

select firstname, lastname, round(salary)
from employees
where salary > (
        select avg(salary)
        from employees);
        
-- 41. return the names of all the companies that has never bought anything from us

select companyname
from customers
where not customerid in (
       select distinct customerid 
       from orders
       );
       
-- 42. return the top 10 best performing cities in terms of number of orders and the percentage contribution of that city

select shipcity, count(orderid) as no_of_orders,
      (count(orderid)/(
      select count(orderid)
      from orders)) * 100 as percentage_contrib
from orders
group by shipcity
order by no_of_orders desc
limit 10;

-- 43. write a query  that returns the details of employees that earns more than their manager and by what percentage

select e.firstname as staff, e.salary as s_salary, 
	   m.firstname as manager, m.salary as m_salary,
	   (e.salary - m.salary)/m.salary * 100 as percentage_diff
from employees e
join employees m on m.employeeid = e.reportsto 
where e.salary > m.salary;

-- 44. return the name of employees and the number of time they responsible for sending a late order .

select firstname, lastname, count(firstname) as no_of_times
from (
        select e.firstname, e.lastname,
        o.requireddate, o.shippeddate
        from orders o
        join employees e on e.employeeid = o.employeeid
		where o.shippeddate > o.requireddate) as temp_table
        group by firstname, lastname
        order by no_of_times desc; 
        
-- 45. return the number of times an employees that earns more than their manager has sent a late order also return the name of this employees

select e.firstname, e.lastname, count(firstname) as `no of times`
from orders o
join employees e on e.employeeid = o.employeeid
where (o.shippeddate > o.requireddate) and e.employeeid in (
															select  e.employeeid
															from employees e
															join employees m on m.employeeid = e.reportsto
															where e.salary > m.salary)
														  
group by firstname, lastname
order by `no of times` desc;

-- 46. return the names, birthdate,and city of employees earning above 2000usd.

select firstname ,lastname, birthdate, city, salary
from employees
where  salary > 2000;

-- 47. returns the number of customers and suppliers we have in each country

with cte_1 as (
	select country, count(customerid) as no_of_customers
	from customers
	group by country
),
cte_2 as (
	select country, count(supplierid) as no_of_suppliers
	from suppliers
    group by country
)
select case
			when a.country is null then 'unknown country'
            else a.country
		end as country, 
case
	when a.no_of_customers is null then 0
    else a.no_of_customers
end as no_of_customers, 
case 
	when b.no_of_suppliers is null then 0
    else b.no_of_suppliers
end as no_of_suppliers
from cte_1 a
left join cte_2 b on b.country = a.country
union
select 
	case
		when a.country is null then 'unknown country'
        else a.country
        end as country,
	case 
		when b.no_of_customers is null then 0
        else b.no_of_customers
	end as no_of_customers,
    case 
		when a.no_of_suppliers is null then 0
        else a.no_of_suppliers
	end as no_of_suppliers
from cte_2 a
left join cte_1 b on b.country = a.country;

-- 48. return employee name and whether or not they are due for retirement.

select firstname, lastname,
	year(now()) - year(hiredate) as service_year,
    case
		when year(now()) - year(hiredate) <= 30 then 'Not Due'
        else 'Due'
	end as retirement_status
from employees;

/* 49. we want to send all our high-value customers a special VIP gift, we are defining high-value customers as those who've made at least 1 order 
with a total value(not including the discount) equal to $10,000 or more. we only want to consider orders made in the year 1997 */

with vip as (
select c.companyname, c.contactname, sum(od.unitprice * od.quantity) as total_value, count(od.orderid) as `num of order`
from `order details` od 
join orders o on o.orderid = od.orderid
join customers c on c.customerid = o.customerid
where year(o.orderdate) = 1997
group by 1, 2

)
select companyname, contactname, total_value, `num of order`
from vip
where total_value > 10000 
;

-- 50. list all customer who have placed an order with product from the 'Beverages' Categories

select companyname, contactname
from customers
where customerid in (
			select customerid
			from orders
			where orderid in (
				     select orderid
					 from `order details`
				      where productid in (
					          select productid
							  from products
							   where categoryid in (
										select categoryid
										from categories
										where categoryname = 'beverages'
										) ) ) ) ;