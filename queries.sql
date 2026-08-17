-- Consulta para contar el numero total de clientes registrados en la tabla customers
SELECT COUNT(*) AS customers_count
FROM customers;

-- Reporte de los 10 vendedores con mayor ingreso generado por sus ventas
select 
e.first_name ||' '|| e.last_name as seller,
COUNT(s.sales_person_id) as operations,
FLOOR(SUM(s.quantity*p.price)) as income
from sales as s 
	inner join employees as e  
		on s.sales_person_id = e.employee_id
			inner join products as p
				on s.product_id = p.product_id
group by sales_person_id , first_name,  last_name
order by income desc  
limit 10; 


--Reporte de vendedores con un promedio de ingresos por venta inferior al promedio general
with tab1 as (
select 
AVG(s.quantity*p.price) as promgen
from sales as s 
	inner join products as p
		on s.product_id = p.product_id)
		
select 
e.first_name ||' '|| e.last_name as seller,
FLOOR(AVG(s.quantity*p.price)) as average_income
from sales as s 
	inner join products as p
		on s.product_id = p.product_id
			inner join employees as e 
				on e.employee_id=s.sales_person_id
group by sales_person_id, first_name, last_name
having FLOOR(AVG(s.quantity*p.price)) < (select promgen from tab1)
order by average_income asc;

--Reporte de ingresos por día de la semana para cada vendedor
select 
e.first_name ||' '|| e.last_name as seller,
TO_CHAR(s.sale_date, 'fmday') AS day_of_week,
FLOOR(SUM(s.quantity*p.price)) as income
from sales as s 
	inner join products as p
		on s.product_id = p.product_id
			inner join employees as e 
				on e.employee_id=s.sales_person_id
group by day_of_week, sales_person_id, seller
order by day_of_week, seller;

--Consulta para contar cuantos clientes hay cada grupo de edad 
select 
case 
	when age between 16 and 25 then '16-25'
	when age between 26 and 40 then '26-40'
	else '40+'
end as age_category,
count(*) as age_count
from customers 
group by age_category
order by age_category;

--Consulta para contar Clientes unico y sus ingresos por mes 
SELECT 
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT s.customer_id) AS total_customers,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
INNER JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
ORDER BY selling_month ASC;


--Consulta para encontrar el cliente donde su primera compra fue en promocion 
with tab1 as (
SELECT 
   s.customer_id,
   s.sale_date,
   s.sales_person_id,
   p.price,
   ROW_NUMBER() OVER (
      PARTITION BY s.customer_id 
        ORDER BY s.sale_date ASC, s.sales_id ASC
    ) AS rn
    FROM sales AS s
    INNER JOIN products AS p 
        ON s.product_id = p.product_id )

select 
c.first_name ||' '|| c.last_name as customer,
t.sale_date,
e.first_name ||' '|| e.last_name as seller
from tab1 as t
	inner join customers as c 
		on c.customer_id=t.customer_id
			inner join employees as e  
				on e.employee_id=t.sales_person_id 
where t.rn = 1 and t.price= 0
order by t.customer_id ;
			

