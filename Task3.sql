/*The business wants to understand which accounts contribute to the bulk of the revenue 
and the business also wants to see year on year trend on the revenue contribution of each account.*/

with t1 as 
(select 
extract(year from occured_at) as year,
account_id, 
sum(total_amt_usd) as total_order
from accounts a join orders o
on a.id=o.account_id
group by year, o.account_id
order by year,total_order desc)
select 
t1.year,
a.name,
t1.total_order as rev,
t1.total_order/sum(t1.total_order) over(partition by t1.year) as pct_yearly_rev,
rank() over(partition by t1.year order by t1.total_order desc)
from t1,accounts a
where t1.account_id=a.id;
