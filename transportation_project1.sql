select
	*
from
	supply_chain_data


-- the different types of products being sold
select
	distinct [product type]
from
	supply_chain_data


-- Explore the rail mode and how costs and ship times compare
select
	[Supplier name]
	, [Shipping carriers]
	, Routes
	, [product type]
	, [Transportation modes]
	, Costs
	, [Revenue generated]
	, [Shipping times]
	, [Lead times]
from
	supply_chain_data
where
	[Transportation modes] like 'Rail'
order by 
	costs desc
	, [Revenue generated] desc

-- exploring the air transportation mode
select
	[Supplier name]
	, [Shipping carriers]
	, Routes
	, [product type]
	, [Transportation modes]
	, Costs
	, [Revenue generated]
	, [Shipping times]
from
	supply_chain_data
where
	[Transportation modes] like 'Air'
order by 
	costs desc
	, [Revenue generated] desc

--change the shipping times into int
alter table supply_chain_data
	alter column [Shipping times] int;

--change the costs column into decimal
alter table supply_chain_data
	alter column costs decimal(10,4)


--which suppliers have the highest shipping time (1 and 5)
select
	[supplier name]
	, count([Shipping times]) as time_over_8_days
from
	supply_chain_data
where
	[Shipping times] > 8
group by
	[Supplier name]
	, location
	, Routes
order by
	count([Shipping times]) desc


--routes witht the longest delivery times (partition)
select
	routes
	, count([Shipping times]) as time_over_8_days
from
	supply_chain_data
where
	[Shipping times] > 8
group by
	Routes
order by
	count([Shipping times]) desc



--Shipping carriers with the highest highest costs
select
	[Shipping carriers]
	, max([costs]) as highest_costs
from
	supply_chain_data
group by
	[Shipping carriers]
order by
	count([costs]) desc


--routes with the highest costs
select
	Routes
	, max([costs]) as highest_costs
from
	supply_chain_data
group by
	Routes
order by
	count([costs]) desc

--avg delivery times
select
	routes
	, cast(avg([Shipping times]) over(order by routes rows between 2 preceding and current row) 
		    as int) as avg_trailing_3d_ship_times
from
	supply_chain_data
order by
	cast(avg([Shipping times]) over(order by routes rows between 2 preceding and current row) 
		    as int) desc
