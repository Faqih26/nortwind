use nortwind;
create or replace view rfmanalysis as 
with frm1 as
(SELECT 
	*,
	NTILE(5) OVER (order by recency desc) rfm_recency,
	NTILE(5) OVER (order by frequency) rfm_frequency,
	NTILE(5) OVER (order by monetaryvalue) rfm_monetary
 FROM nortwind.rfm 
 )
 , rfm2 as(
 select 
	*,
    concat( cast(rfm_recency as char),'-',cast(rfm_frequency as char),'-', cast(rfm_monetary as char))rfm_cell_string,
    concat( cast(rfm_recency as char),cast(rfm_frequency as char), cast(rfm_monetary as char))rfm_cell_string1,
    rfm_recency+rfm_frequency+rfm_monetary as TotalScore_rfm,
    NTILE(5) OVER (ORDER BY (rfm_recency + rfm_frequency + rfm_monetary) DESC) AS BestCustomerCategory
from frm1
)
select 
	*,
    case 
		WHEN rfm_cell_string IN ('5-5-5', '5-5-4', '5-4-4', '5-4-5', '4-5-4', '4-5-5', '4-4-5') THEN 'Champion'
		WHEN rfm_cell_string IN ('5-4-3', '4-4-4', '4-3-5', '3-5-5', '3-5-4', '3-4-5', '3-4-4', '3-3-5') THEN 'Loyal'
		WHEN rfm_cell_string IN ('5-5-3', '5-5-1', '5-5-2', '5-4-1', '5-4-2', '5-3-3', '5-3-2', '5-3-1', 
							'4-5-2', '4-5-1', '4-4-2', '4-4-1', '4-3-1', '4-5-3', '4-3-3', '4-3-2', 
							'4-2-3', '3-5-3', '3-5-2', '3-5-1', '3-4-2', '3-4-1', '3-3-3', '3-2-3') THEN 'Potential Loyalist'
		WHEN rfm_cell_string IN ('5-1-2', '5-1-1', '4-2-2', '4-2-1', '4-1-2', '4-1-1', '3-1-1') THEN 'New Costumer'
		WHEN rfm_cell_string IN ('5-2-5', '5-2-4', '5-2-3', '5-2-2', '5-2-1', '5-1-5', '5-1-4', '5-1-3', 
							'4-2-5', '4-2-4', '4-1-3', '4-1-4', '4-1-5', '3-1-5', '3-1-4', '3-1-3') THEN 'Promising'
		WHEN rfm_cell_string IN ('5-3-5', '5-3-4', '4-4-3', '4-3-4', '3-4-3', '3-3-4', '3-2-5', '3-2-4') THEN 'Needs Attention'
		WHEN rfm_cell_string IN ('3-3-1', '3-2-1', '3-1-2', '2-2-1', '2-1-3', '2-3-1', '2-4-1', '2-5-1') THEN 'About To Sleep'
		WHEN rfm_cell_string IN ('2-5-5', '2-5-4', '2-4-5', '2-4-4', '2-5-3', '2-5-2', '2-4-3', '2-4-2', 
							'2-3-5', '2-3-4', '2-2-5', '2-2-4', '1-5-3', '1-5-2', '1-4-5', '1-4-3', 
							'1-4-2', '1-3-5', '1-3-4', '1-3-3', '1-2-5', '1-2-4') THEN 'At Risk'
		WHEN rfm_cell_string IN ('1-5-5', '1-5-4', '1-4-4', '2-1-4', '2-1-5', '1-1-5', '1-1-4', '1-1-3') THEN 'Cannot Lose Them'
		WHEN rfm_cell_string IN ('3-3-2', '3-2-2', '2-3-3', '2-3-2', '2-2-3', '2-2-2', '1-3-2', '1-2-3', 
							'1-2-2', '2-1-2', '2-1-1') THEN 'Hibernating Costumer'
		WHEN rfm_cell_string IN ('1-1-1', '1-1-2', '1-2-1', '1-3-1', '1-4-1', '1-5-1') THEN 'Lost Costumer'
	end rfm_segment
    ,
	case 
		when rfm_cell_string1 in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141,113,133, 134, 143, 244,144,243,232) then 'lost_customers'  -- lost customers
		#when rfm_cell_string1 in (133, 134, 143, 244, 334, 343, 344, 144,243,232) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
		when rfm_cell_string1 in (311, 411, 331,421, 334, 343, 344,222, 223, 233, 322,221) then 'new customers'
		#when rfm_cell_string1 in (222, 223, 233, 322,221) then 'potential churners'
		#when rfm_cell_string1 in (323, 333,321, 422, 332, 432) then 'active' -- (Customers who buy often & recently, but at low price points)
		when rfm_cell_string1 in (433, 434, 443, 444,442,423, 323, 333,321, 422, 332, 432) then 'loyal'
	end rfm_segment2
    ,
    case 
		when BestCustomerCategory = 1 then 'Platinum Customers'
        when BestCustomerCategory = 2 then 'Gold Customers'
        when BestCustomerCategory = 3 then 'Silver Customers'
        #when BestCustomerCategory = 4 then 'Bronze Customers'
        when BestCustomerCategory = 4 then ' Churned Customers'
        end as segmentcustomer
from rfm2