use nortwind;
create or replace view rfm as 
SELECT 
	customerID,
	sum(discountprice) as monetaryvalue,
    count(distinct orderID) as frequency,
    max(orderDate) as last_order,
    (select max(orderDate) FROM nortwind.analysis) as max_date,
    abs(datediff(max(orderDate) ,(select max(orderDate) FROM nortwind.analysis))) as recency
 FROM nortwind.analysis
 group by customerID
 