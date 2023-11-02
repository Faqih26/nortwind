create or replace view nortwindjoin as 
SELECT 	
	o.orderID
		,o.customerID
		,o.employeeID
		,o.orderDate
		,o.requiredDate
		,cast(o.shippedDate as date) as shippedDate
		,o.shipperID
		,o.freight
		,od.productID
		,od.unitPrice
		,od.quantity
		,od.discount
		,c.companyName
		,c.contactName
		,c.contactTitle
		,c.city as citycustomer
		,c.country as countrycustomer
		,p.productName
		,p.quantityPerUnit
		,p.unitPrice as priceproduct
		,p.discontinued
		,ca.categoryID
		,ca.categoryName
		,ca.description
		,e.employeeName
		,e.title
		,e.city as cityemployee
		,e.country as countryemployee
		,e.reportsTo
		,s.companyName as shippingcompany
FROM nortwind.orders as o
inner join order_details as od
	on o.orderID = od.orderID
inner join customers as c 
	on c.customerID = o.customerID
inner join products as p
	on p.productID = od.productID
inner join categories as ca
	on ca.categoryID = p.categoryID
inner join shippers as s
	on s.shipperID = o.shipperID
inner join employees as e
	on e.employeeID = o.employeeID
;