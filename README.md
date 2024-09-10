# 8SQLChallenge_Danny
#Dannys_Dinner


-- 1. What is the total amount each customer spent at the restaurant?
-- 1. Her bir müşterinin restoranda harcadığı toplam tutar nedir?
select * from members  
select * from sales  
select * from menu

select customer_id, SUM(price)  
from sales s  
left join menu mm ON mm.product_id = s.product_id  
group by customer_id  
order by 2 DESC;  



<img width="357" alt="Ekran Resmi 2024-09-10 14 32 08" src="https://github.com/user-attachments/assets/864e2299-1b44-4f1c-8b5b-db2047ff813a">


-- 2. How many days has each customer visited the restaurant?
-- 2. Her bir müşteri restoranı kaç gün ziyaret etti?

select customer_id, COUNT(distinct order_date)--Distinct KULLANDIK!
from sales
group by 1
order by 2 DESC


<img width="357" alt="Ekran Resmi 2024-09-10 14 40 22" src="https://github.com/user-attachments/assets/1c436a8c-da15-4489-bf3d-c743f2e21032">
