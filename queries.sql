-- Consulta para contar el numero total de clientes registrados en la tabla customers
SELECT COUNT(*) AS customers_count
FROM customers;

-- Reporte de los 10 vendedores con mayor ingreso generado por sus ventas
select 
e.first_name ||' '|| e.last_name as seller,
SUM(s.quantity) as operations,
SUM(s.quantity*p.price) as income
from sales as s 
	inner join employees as e  
		on s.sales_person_id = e.employee_id
			inner join products as p
				on s.product_id = p.product_id
group by sales_person_id , first_name,  last_name
order by income desc  
limit 10; 



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