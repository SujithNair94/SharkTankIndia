-- Analysing data for Shark tank India. Please note the data is only for 30 episodes --


select * from Sharktank.dbo.data ;


-- Q> Total Number of Episodes so far--


select count(distinct epno) as Total_Episodes from Sharktank.dbo.data;


-- Q>Number of Pitches made in each sector--


select Sector , count(distinct Brand) as Pitches_made
from Sharktank.dbo.data
group by Sector; 


-- Q>Startups that have received funding ---


select sum(a.ReceivedFunding) as SuccessFunding , count(*) as TotalPitchesMade from 
(select Amountinvestedlakhs , case when AmountInvestedlakhs > 0 then '1' else 0 end as 'ReceivedFunding' 
from Sharktank.dbo.data) a ;


-- Q>Sucess Percentage so far --


select cast(sum(a.ReceivedFunding) as float)/cast(count(*) as float)*100 as SuccessPercentage from 
(select Amountinvestedlakhs , case when AmountInvestedlakhs > 0 then '1' else 0 end as 'ReceivedFunding' 
from Sharktank.dbo.data) a ;


--Q> Gender Ratio of Participants --


select sum(Female)/sum(Male)*100 as GenderRatio
from Sharktank.dbo.data ;


--Q> Average Equity taken by Sharks --

select avg(a.EquitytakenP) as Average_Equity_Taken from (
select * from Sharktank.dbo.data
where EquityTakenP>0)a ;

--Q> Highest deal taken so far--


select max(AmountInvestedLakhs) as Max_Amt_In_lakhs 
from Sharktank.dbo.data ;


-- Q>Startups that have atleast have 1 women in team or individual --


select sum(a.Female_count) as Startups_female from(
select case when female>0 then '1' else 0 end as Female_count
from Sharktank.dbo.data)a  ;


--Q> Lets analyse startups that had women in their team/individual and if they were successful in receiving funding --


select sum(b.Female_Count) as Total_Female_Startups from
(
select case when a.female>0 then 1 else 0 end as Female_Count , a.Deal from
(
select * from Sharktank.dbo.data
where Deal not in ('No Deal'))a)b; 


-- Q> Total Amount spent on all successful deals --


select sum(a.AmountInvestedlakhs) as Total_Amt_Spent_In_Lakhs from (
select * from Sharktank.dbo.data 
where Deal not in ('No Deal') )a; 


--Q>Avg Age of Participants--


select Avgage, count(Avgage) as Number_Participants from Sharktank.dbo.data 
group by Avgage
order by Number_Participants desc; 


--Q> Top Sector Startups that have appeared in the show so far --


select Sector, count(Sector) as Number_of_Pitches from Sharktank.dbo.data 
group by Sector
order by Number_of_Pitches desc; 


-- Q> Partner Deals - Deals made by Sharks individually or in partnership --


select Partners , count(Partners) as Deals_Count 
from Sharktank.dbo.data
where partners not in ('-')
group by Partners
order by Deals_Count desc; 


-- Q> Lets find the highest amount invested in brands in each sector----


select a.* from
(
select brand, Sector , AmountInvestedlakhs , rank() over (partition by Sector order by AmountInvestedLakhs desc)rnk
from Sharktank.dbo.data ) a
where a.rnk = 1;


--Q> Create a table or matrix for 4sharks that has name of Sharks as Col1 , Amt invested col2, Avg equity col3, total episodes col4 and total deals col5--


--- Lets begin with Ashneer----

select x.Shark , x.Amount_Invested , x.Avg_Equity , x.TotalEpisodes , y.Total_Deals from 
(
select m.Shark , m.Amount_Invested , m.Avg_Equity , n.TotalEpisodes from 
(
select 'Ashneer' as Shark, c.* from (
select sum(AshneerAmountInvested) as Amount_Invested , avg(AshneerEquityTaken) as Avg_Equity from Sharktank.dbo.data)c) m
inner join 
(
select 'Ashneer' as Shark, d.* from(
select sum(a.Total_Episodes) as TotalEpisodes from (
select case when AshneerAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data ) a)d)n 
on m.Shark = n.Shark) x
inner join 
(
select 'Ashneer' as Shark, e.* from 
(select sum(b.Invested) as Total_Deals from 
(select case when AshneerAmountInvested is null or AshneerAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data ) b) e )y
on x.Shark = y.Shark ;

------Namita--------

select u.Shark , u.Amount_Invested , u.Avg_Equity , v.Total_Episodes , v.Total_Deals from
(
select 'Namita' as Shark , t.* from (
select sum(NamitaAmountInvested) as Amount_Invested , avg(NamitaEquityTaken) as Avg_Equity from Sharktank.dbo.data) t ) u
 inner join
(
select r.Shark , r.Total_Episodes , s.Total_Deals from 
(
select 'Namita' as Shark ,q.* from
(
select sum(p.Total_Episodes) as Total_Episodes from (
select case when NamitaAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data)p) q ) r 
inner join 
(
select 'Namita' as Shark ,g.* from
(
select sum(f.Invested) as Total_Deals from 
(select case when NamitaAmountInvested is null or NamitaAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data )f)g )s
on r.Shark = s.Shark) v
on u.Shark = v.Shark;

---------Anupam-------------

select ca.Shark , ca.Amount_Invested , ca.Avg_equity , ca.Total_Episodes , cb.Total_deals from
(
select ad.Shark , ad.Amount_Invested , ad.Avg_equity , ag.Total_Episodes from 
(
select 'Anupam' as Shark , ac.* from (
select sum(AnupamAmountInvested) as Amount_Invested , avg(AnupamEquityTaken) as Avg_Equity from Sharktank.dbo.data)ac) ad
inner join 
(
select 'Anupam' as Shark ,be.* from
(
select sum(bd.Total_Episodes) as Total_Episodes from (
select case when AnupamAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data) bd) be) ag
on ad.Shark = ag.Shark
)ca
inner join 
(
select 'Anupam' as Shark, cc.* from 
(
select sum(bb.Invested) as Total_Deals from 
(
select case when AnupamAmountInvested is null or AnupamAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data) bb) cc ) cb
on ca.Shark = cb.Shark ;

--------Vineeta----------

select vj.Shark , vj.Amount_invested ,vj.Avg_Equity , vj.Total_Episodes , vo.Total_deals from
(
select vk.Shark , vk.Amount_invested ,vk.Avg_Equity , vq.Total_Episodes from 
(
select 'Vineeta' as Shark , ne.* from
(
select sum(VineetaAmountInvested) as Amount_Invested , avg(VineetaEquityTaken) as Avg_Equity from Sharktank.dbo.data) ne) vk
inner join 
(
select 'Vineeta' as Shark , vi.* from 
(
select sum(vv.Total_Episodes) as Total_episodes from
(
select case when VineetaAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data)vv) vi )vq
on vk.Shark = vq.Shark)vj

inner join
(
select 'Vineeta' as Shark , gg.* from 
(
select sum(ag.Invested) as Total_deals from (
select case when VineetaAmountInvested is null or VineetaAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data ) ag) gg) vo
on vj.Shark = vo.Shark ;



---- Now combining all the queries again using a union to create a table/matrix----


select aa.* from 

(
select x.Shark , x.Amount_Invested , x.Avg_Equity , x.TotalEpisodes , y.Total_Deals from 
(
select m.Shark , m.Amount_Invested , m.Avg_Equity , n.TotalEpisodes from 
(
select 'Ashneer' as Shark, c.* from (
select sum(AshneerAmountInvested) as Amount_Invested , avg(AshneerEquityTaken) as Avg_Equity from Sharktank.dbo.data)c) m
inner join 
(
select 'Ashneer' as Shark, d.* from(
select sum(a.Total_Episodes) as TotalEpisodes from (
select case when AshneerAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data ) a)d)n 
on m.Shark = n.Shark) x
inner join 
(
select 'Ashneer' as Shark, e.* from 
(select sum(b.Invested) as Total_Deals from 
(select case when AshneerAmountInvested is null or AshneerAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data ) b) e )y
on x.Shark = y.Shark 
) aa


union


select ab.* from 

(
select u.Shark , u.Amount_Invested , u.Avg_Equity , v.Total_Episodes , v.Total_Deals from
(
select 'Namita' as Shark , t.* from (
select sum(NamitaAmountInvested) as Amount_Invested , avg(NamitaEquityTaken) as Avg_Equity from Sharktank.dbo.data) t ) u
 inner join
(
select r.Shark , r.Total_Episodes , s.Total_Deals from 
(
select 'Namita' as Shark ,q.* from
(
select sum(p.Total_Episodes) as Total_Episodes from (
select case when NamitaAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data)p) q ) r 
inner join 
(
select 'Namita' as Shark ,g.* from
(
select sum(f.Invested) as Total_Deals from 
(select case when NamitaAmountInvested is null or NamitaAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data )f)g )s
on r.Shark = s.Shark) v
on u.Shark = v.Shark) ab


union


select ac.* from

(select ca.Shark , ca.Amount_Invested , ca.Avg_equity , ca.Total_Episodes , cb.Total_deals from
(
select ad.Shark , ad.Amount_Invested , ad.Avg_equity , ag.Total_Episodes from 
(
select 'Anupam' as Shark , ac.* from (
select sum(AnupamAmountInvested) as Amount_Invested , avg(AnupamEquityTaken) as Avg_Equity from Sharktank.dbo.data)ac) ad
inner join 
(
select 'Anupam' as Shark ,be.* from
(
select sum(bd.Total_Episodes) as Total_Episodes from (
select case when AnupamAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data) bd) be) ag
on ad.Shark = ag.Shark
)ca
inner join 
(
select 'Anupam' as Shark, cc.* from 
(
select sum(bb.Invested) as Total_Deals from 
(
select case when AnupamAmountInvested is null or AnupamAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data) bb) cc ) cb
on ca.Shark = cb.Shark )ac


union

select ad.* from

(
select vj.Shark , vj.Amount_invested ,vj.Avg_Equity , vj.Total_Episodes , vo.Total_deals from
(
select vk.Shark , vk.Amount_invested ,vk.Avg_Equity , vq.Total_Episodes from 
(
select 'Vineeta' as Shark , ne.* from
(
select sum(VineetaAmountInvested) as Amount_Invested , avg(VineetaEquityTaken) as Avg_Equity from Sharktank.dbo.data) ne) vk
inner join 
(
select 'Vineeta' as Shark , vi.* from 
(
select sum(vv.Total_Episodes) as Total_episodes from
(
select case when VineetaAmountInvested is null then 0 else 1 end as Total_Episodes
from Sharktank.dbo.data)vv) vi )vq
on vk.Shark = vq.Shark)vj

inner join
(
select 'Vineeta' as Shark , gg.* from 
(
select sum(ag.Invested) as Total_deals from (
select case when VineetaAmountInvested is null or VineetaAmountInvested = 0 then 0 else 1 end as Invested 
from Sharktank.dbo.data ) ag) gg) vo
on vj.Shark = vo.Shark) ad ;


