# 8SQLChallenge_Danny
#Dannys_Dinner


-- 1. What is the total amount each customer spent at the restaurant?
-- 1. Her bir müşterinin restoranda harcadığı toplam tutar nedir?
```sql
select * from members  
select * from sales  
select * from menu

select customer_id, SUM(price)  
from sales s  
left join menu mm ON mm.product_id = s.product_id  
group by customer_id  
order by 2 DESC;  
```


<img width="357" alt="Ekran Resmi 2024-09-10 14 32 08" src="https://github.com/user-attachments/assets/864e2299-1b44-4f1c-8b5b-db2047ff813a">


-- 2. How many days has each customer visited the restaurant?
-- 2. Her bir müşteri restoranı kaç gün ziyaret etti?

select customer_id, COUNT(distinct order_date)--Distinct KULLANDIK!  
from sales  
group by 1  
order by 2 DESC  



<img width="357" alt="Ekran Resmi 2024-09-10 14 40 22" src="https://github.com/user-attachments/assets/1c436a8c-da15-4489-bf3d-c743f2e21032">


-- 3. What was the first item from the menu purchased by each customer?
-- 3. Her bir müşteri tarafından menüden satın alınan ilk ürün neydi?

select *  
from sales s   
join menu m ON m.product_id = s.product_id  
order by customer_id,order_date  

<img width="707" alt="Ekran Resmi 2024-09-10 14 44 43" src="https://github.com/user-attachments/assets/f1a1c22c-7532-4fa9-bc22-f318cd76e7e5">


--1.aşama  
select  customer_id,  
		order_date,  
		product_name,  
		Row_number() Over (PARTITION BY customer_id Order by order_date)---customer_id göre grupladık   
from sales s   
join menu m ON m.product_id = s.product_id  
order by customer_id,order_date  

---2.aşama  
select  customer_id,  
		order_date,  
		product_name,  
		Row_number() Over (PARTITION BY customer_id Order by order_date),---customer_id göre grupladık   
		Rank() Over (PARTITION BY customer_id Order by order_date),  
		Dense_Rank() Over (PARTITION BY customer_id Order by order_date)  

from sales s    
join menu m ON m.product_id = s.product_id  
order by customer_id,order_date  

----3.aşama  
select  customer_id,  
		order_date,  
		product_name,  
		Rank() Over (PARTITION BY customer_id Order by order_date)  
from sales s   
join menu m ON m.product_id = s.product_id  
order by customer_id,order_date  

---4.aşama  
with tablo as (  
select  Distinct customer_id,  
		order_date,  
		product_name,  
		Rank() Over (PARTITION BY customer_id Order by order_date) as rn  
from sales s   
join menu m ON m.product_id = s.product_id  
	)  
select customer_id,product_name  
from tablo  
where rn = 1  
order by 1   


<img width="707" alt="Ekran Resmi 2024-09-10 14 47 21" src="https://github.com/user-attachments/assets/6b2d12a0-8825-4822-a00e-26ce4d399130">


<img width="372" alt="Ekran Resmi 2024-09-10 14 48 03" src="https://github.com/user-attachments/assets/db314876-eee7-45d9-b59a-1e069b278b3e">


----- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?  
------4. Menüde en çok satın alınan ürün nedir ve tüm müşteriler tarafından kaç kez satın alınmıştır?  
select *   
from sales s   
join menu mm ON s.product_id = mm.product_id  
order by customer_id,order_date  


--2.aşama  
select product_name,  
		count(s.product_id)   
from sales s   
join menu mm ON s.product_id = mm.product_id  
group by 1  
order by 2 DESC  
--3.aşama   
select product_name,  
		count(s.product_id)   
from sales s    
join menu mm ON s.product_id = mm.product_id  
group by 1  
order by 2 DESC  
Limit 1  

<img width="326" alt="Ekran Resmi 2024-09-10 14 49 50" src="https://github.com/user-attachments/assets/78ac71a3-36b3-4426-8b0d-2ed2c34c86bc">


-------- 5. Which item was the most popular for each customer?  
----------5. Her bir müşteri için en popüler ürün hangisiydi?encok satın aldığı?  

select	customer_id ,  
		product_name,  
		Count(s.product_id)  

from sales s   
join menu mm ON s.product_id = mm.product_id  
group by 1,2  
order by 1 ,3 DESC  

<img width="461" alt="Ekran Resmi 2024-09-10 14 52 06" src="https://github.com/user-attachments/assets/7f0bf1f1-575b-45d3-8782-a6498f6d6192">

with tablo1 as(  
select	customer_id ,  
		product_name,  
		Count(s.product_id) as total,  
		dense_rank()  Over (PARTITION by customer_id order by   Count(s.product_id) DESC ) as rn  
from sales s   
join menu mm ON s.product_id = mm.product_id  
group by 1,2  
order by 1 ,3 DESC  
	)  
	
	select customer_id,  
			product_name,  
			total  
	from tablo1  
	where rn= 1   




<img width="461" alt="Ekran Resmi 2024-09-10 14 52 34" src="https://github.com/user-attachments/assets/cdd38cc7-8534-4e7c-b769-7f6e73f21633">


