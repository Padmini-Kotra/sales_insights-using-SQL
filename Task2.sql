/* Task 2 */
/* 1. Which sales reps are handling which accounts? */

select 
s.id as sales_rep_id, 
s.name as sales_rep_name, 
s.region_id as sales_rep_region,
a.name as account_name, 
rank() over(partition by s.name order by a.id)  as acc_num
from sales_rep s left join accounts a 
on s.id=a.sales_rep_id;

/* 2. One of the aspects that the business wants to explore is what has been the share of each sales representative's s year on year sales out of the total yearly sales. */

with x as 
(select 
extract (year from o.occured_at) as year, 
s.name as sales_rep_name,
sum(o.total_amt_usd) as sum1
from orders o, accounts a,sales_rep s
where o.account_id=a.id and a.sales_rep_id=s.id
group by year,s.name
order by year),
y as 
(select 
extract(year from occured_at) as year, 
sum(total_amt_usd) as yearly_sum
from orders
group by year)
select 
x.year,x.sales_rep_name,
x.sum1/yearly_sum as perc_sales_rep,
dense_rank() over(partition by x.year order by x.sum1/yearly_sum desc)
from x,y
where x.year=y.year
order by year,perc_sales_rep desc;

/*3. Repeat the analysis given above but this time for region. 
 * Generate the percentage contribution of each region to total yearly revenue over years. */


with x as 
(select 
extract (year from o.occured_at) as year, 
r.name as region_name,
sum(o.total_amt_usd) as sum1
from orders o, accounts a,sales_rep s, region r
where o.account_id=a.id and a.sales_rep_id=s.id and s.region_id =r.id
group by year,r.name
order by year),
y as 
(select 
extract(year from occured_at) as year, 
sum(total_amt_usd) as yearly_sum
from orders
group by year)
select 
x.year,x.region_name,
x.sum1/yearly_sum as perc_region,
dense_rank() over(partition by x.year order by x.sum1/yearly_sum desc)
from x,y
where x.year=y.year
order by year,perc_region desc;
