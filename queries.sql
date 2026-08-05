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