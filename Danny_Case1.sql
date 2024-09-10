-- Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?



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

-- 2. How many days has each customer visited the restaurant?
-- 2. Her bir müşteri restoranı kaç gün ziyaret etti?
select * from members
select * from sales 
select * from menu

select * 
from sales s
join menu mm ON mm.product_id = s.product_id 
order by customer_id,order_date
--1.aşama cvp 
select customer_id, COUNT(order_date)--Distinct kullanmadık!
from sales
group by 1
--2.aşama cvp 
select customer_id, COUNT(distinct order_date)--Distinct KULLANDIK!
from sales
group by 1
order by 2 DESC

-- 3. What was the first item from the menu purchased by each customer?
-- 3. Her bir müşteri tarafından menüden satın alınan ilk ürün neydi?
select *
from sales s 
join menu m ON m.product_id = s.product_id
order by customer_id,order_date

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

-------- 5. Which item was the most popular for each customer?
----------5. Her bir müşteri için en popüler ürün hangisiydi?encok satın aldığı?

select	customer_id ,
		product_name,
		Count(s.product_id)

from sales s 
join menu mm ON s.product_id = mm.product_id
group by 1,2
order by 1 ,3 DESC


---2.aşama

select	customer_id ,
		product_name,
		Count(s.product_id),
		row_number() Over (PARTITION by customer_id order by Count(s.product_id) DESC ),
		rank()  Over (PARTITION by customer_id order by Count(s.product_id) DESC ),
		dense_rank()  Over (PARTITION by customer_id order by Count(s.product_id) DESC )
from sales s 
join menu mm ON s.product_id = mm.product_id
group by 1,2
order by 1 ,3 DESC

----3.aşama

select	customer_id ,
		product_name,
		Count(s.product_id),
		dense_rank()  Over (PARTITION by customer_id order by Count(s.product_id) DESC )
from sales s 
join menu mm ON s.product_id = mm.product_id
group by 1,2
order by 1 ,3 DESC

---4.aşama
with tablo1 as(
select	customer_id ,
		product_name,
		Count(s.product_id) as total,
		dense_rank()  Over (PARTITION by customer_id order by Count(s.product_id) DESC ) as rn
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


----- 6. Which item was purchased first by the customer after they became a member?
------6. Müşteri üye olduktan sonra ilk olarak hangi ürünü satın aldı?

select * 
from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id

---2.aşama
select * 
from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id
where order_date >= join_date
order by 1,2

---3.aşama
select * ,
	row_number() over (partition by s.customer_id order by order_date) as Rn
from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id
where order_date >= join_date
order by 1,2

--4.aşama
with tablo2 as (
select 		s.customer_id,
			order_date,
			product_name,
	row_number() over (partition by s.customer_id order by order_date) as Rn
from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id
where order_date >= join_date
order by 1,2
	)
	select customer_id,
			product_name

			from tablo2 
			where rn = 1 
			
-- 7. Which item was purchased just before the customer became a member?			
--- 7. Müşteri üye olmadan hemen önce hangi ürünü satın almıştır?

select * 
from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id

   --2.aşama
   
   select 	 s.customer_id,
  			order_date,
			 product_name,
			 join_date
  from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id		 
   where order_date < join_date
   
   --3.aşama
     select 	 s.customer_id,
  			order_date,
			 product_name,
			rank() Over (partition by s.customer_id order by order_date desc),
			join_date
  from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id		 
   where order_date < join_date 

	--4.aşama
	with tablo4 as(
	  select s.customer_id,
  			order_date,
			 product_name,
			rank() Over (partition by s.customer_id order by order_date desc) as rn,
			join_date
  from sales s 
left join menu mm ON s.product_id= mm.product_id
left join members mb ON mb.customer_id = s.customer_id		 
   where order_date < join_date
		)
	select customer_id,
			order_date,
			product_name
		from tablo4
		where rn = 1 
		
-- 8. What is the total items and amount spent for each member before they became a member?
-- 8. Üye olmadan önce her bir üyenin yapmış olduğu toplam harcama tutarı ve adedi nedir?

select * 
from sales s
Left join menu mm ON mm.product_id= s.product_id
left join members mb ON mb.customer_id=s.customer_id
where order_date < join_date
order by 1,2


---2.aşama
select  s.customer_id,
		count(s.product_id),
		SUM(price)
from sales s
Left join menu mm ON mm.product_id= s.product_id
left join members mb ON mb.customer_id=s.customer_id
where order_date < join_date
group by 1
order by 1,2


------ 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
------ 9. Harcanan her 1$ 10 puana eşitse ve suşi 2 kat puan çarpanına sahipse, her müşterinin kaç puanı olur?

select customer_id,
		product_name,
		price,
		CASE 
			When product_name = 'sushi' then price * 10 * 2
			ELSE price * 10 
			end points
from sales s
left join menu mm ON mm.product_id =s.product_id


---2.aşama
with tablo as (
select customer_id,
		product_name,
		price,
		CASE 
			When product_name = 'sushi' then price * 10 * 2
			ELSE price * 10 
			end points
from sales s
left join menu mm ON mm.product_id =s.product_id

)
select customer_id,
		SUM(points)
from tablo
group by 1


--- 10. In the first week after a customer joins the program (including their join date) 
---they earn 2x points on all items, not just sushi
--- how many points do customer A and B have at the end of January?

--- 10. Bir müşteri programa katıldıktan sonraki ilk hafta içinde (katılım tarihi dahil)
---sadece suşi değil, tüm yiyeceklerde 2 kat puan kazanıyorlar 
--- A ve B müşterilerinin Ocak ayı sonunda kaç puanları var?


Select  customer_id,
		join_date start_date,
		join_date + 6 End_date
from members		



---2.aşama
WITH Tablo AS (
    SELECT 
        s.customer_id,
        join_date AS start_date,
        join_date + 6 AS end_date,
        order_date,
        product_name,
        price,
        CASE
            WHEN order_date BETWEEN join_date AND join_date + 6 THEN price * 20
            WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10 
        END AS points
    FROM sales s
    LEFT JOIN menu mm ON mm.product_id = s.product_id
    LEFT JOIN members mem ON mem.customer_id = s.customer_id
    WHERE order_date <= '2021-01-31'
)
SELECT customer_id,
       SUM(points)
FROM Tablo 
GROUP BY customer_id;

--------BONUS QUESTION 1---------
---Is the customer our member or not on the date of purchase?
--Use the letter Y if he/she is a member and N if he/she is not. 

--Alışveriş yapıldığı tarihte müşteri ,bizim üyemiz mi değil mi?
--Üye ise Y,   değil ise N harfini kullan 


select 
	s.customer_id,
	order_date,
	product_name,
	price,
	join_date,
	CASE
		When join_date is null Then 'N'
		When order_date >= join_date Then 'Y' ELSE 'N'END As member
from sales s  
left join menu mm ON mm.product_id = s.product_id
left join members mb ON mb.customer_id = s.customer_id
order by 1,2


---2.aşama
select 
	s.customer_id,
	order_date,
	product_name,
	price,
	CASE
		When join_date is null Then 'N'
		When order_date >= join_date Then 'Y' ELSE 'N'END As member
from sales s  
left join menu mm ON mm.product_id = s.product_id
left join members mb ON mb.customer_id = s.customer_id
order by 1,2




------BONUS QUESTION 2 -----
--Müşteri alışverişi üye olmadan yaptıysa "null" değeri ekle . 
--her bir müşteri üye iken yaptığı alışverilere numara ata (Rank)
with tablo as (
select 
	s.customer_id,
	order_date,
	product_name,
	price,
	CASE
		When join_date is null Then 'N'
		When order_date >= join_date Then 'Y' ELSE 'N'END As member
from sales s  
left join menu mm ON mm.product_id = s.product_id
left join members mb ON mb.customer_id = s.customer_id
order by 1,2
)

select *,
		CASE
			when member = 'N' THEN null
			Else
			rank() over (PARTITION by customer_id, member order by order_date) end as ranking 
from tablo 

--NOT:
--partition by  hem customer_id,hemde member göre yaptık !! 




