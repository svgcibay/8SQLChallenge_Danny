--PART2 
----B. Runner and Customer Experience-------
----B. Kurye  ve Müşteri Deneyimi-------



---How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
---Her 1 haftalık dönem için kaç kurye kaydoldu? (yani hafta 2021-01-01'de başlıyor)
select * from runners  
select * from runner_orders


SELECT 
    TO_CHAR(registration_date, 'IYYY-IW') AS week,
    COUNT(runner_id) AS runners_signed_up
FROM runners
GROUP BY week 
ORDER BY week


SELECT 
		COUNT(RUNNER_ID),	
		TO_CHAR(REGISTRATION_DATE, 'DAY')
FROM RUNNERS
GROUP BY 2
/*2.What was the average time in minutes it took for
each runner to arrive at the Pizza Runner HQ to pickup the order?*/

/* 2.Her bir kurye siparişi almak için Pizza Runner Genel Merkezi'ne 
varması dakika cinsinden ortalama ne kadar sürdü?*/

select  runner_id,
		AVG(AGE(pickup_time, order_time)) Time 
		
from runner_orders ro 
left join customer_orders co ON co.order_id = ro.order_id
where pickup_time is not null
group by 1
order by 1 ASC
--- diğer yol 
select runner_id,
		avg(pickup_time - order_time)
from customer_orders co
JOIN runner_orders ro on ro.order_id = co.order_id
where cancellation is null
group by 1  


/* 3.Is there any relationship between the number of pizzas and how long
the order takes to prepare? */
/* 3.Pizza sayısı ile ne kadar süreceği arasında herhangi bir ilişki var mı?
siparişin hazırlanması ne kadar sürer? */

select  pizza_id,
	AVG(AGE(pickup_time, order_time)) Time 		
from runner_orders ro 
left join customer_orders co ON co.order_id = ro.order_id
where pickup_time is not null
group by 1
order by 1 ASC

---Hocanın çözümü 
SELECT co.order_id,
		count(pizza_id),
		avg(pickup_time - order_time)
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
group by 1
order by 1;







/*4.What was the average distance travelled for each customer?*/
/*4.Her bir müşteri için kat edilen ortalama mesafe neydi?*/
select * from customer_orders
select * from runner_orders

select customer_id,
		AVG(distance) as Avgdistance
from runner_orders ro 
left join customer_orders co ON co.order_id = ro.order_id	
where distance is not null
group by 1	
order by 1 

--diğer yol 
select customer_id,
		round(avg(distance)::numeric,2)
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
group by 1
order by 1;

/*5.What was the difference between the longest and shortest delivery times for all orders?*/
/*5.Tüm siparişler için en uzun ve en kısa teslimat süreleri arasındaki fark neydi?*/

select * from customer_orders
select * from runner_orders


select order_id,
		MIN(duration),
		MAX(duration)
from runner_orders
where duration is not null
group by 1

select max(duration) longest,
		min(duration) shortest,
		max(duration) - min(duration) difference
from runner_orders


/*6.What was the average speed for each runner for each delivery and do you notice any trend
for these values?*/
/*6.Her bir teslimat için her bir kurye ortalama hızı neydi ve herhangi bir eğilim fark ettiniz mi?
bu değerler için? */

select runner_id,
		order_id,
		60 * distance / duration as avg_speed
from runner_orders
where cancellation is null
order by 1

----





/*7.What is the successful delivery percentage for each runner?*/
/*7.Her bir Kurye için başarılı teslimat yüzdesi nedir?*/

select runner_id,
		count(runner_id),
		count(pickup_time),
		round(1.0 * count(pickup_time) / count(runner_id) * 100,0)
from runner_orders
group by 1
order by 1

----başka bir cevap 
SELECT runner_id,
       100.0 * SUM(CASE WHEN pickup_time IS NULL THEN 0 ELSE 1 END) / COUNT(order_id) AS pickup_percentage
FROM runner_orders
GROUP BY runner_id
ORDER BY runner_id ASC;



SELECT runner_id,
       1.0 * SUM(CASE WHEN pickup_time IS NULL THEN 0 ELSE 1 END) / COUNT(order_id) AS pickup_percentage
FROM runner_orders
GROUP BY runner_id
ORDER BY runner_id ASC;