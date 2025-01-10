-------------- What to choose for Performance- Subqueries or Joins? -----------

select count(*) from tblProducts
select count(*) from tblProductSales

/*

According to MSDN, in most cases, there is usually no performance difference
between queries that uses subqueries and equivalent queries using joins.

According to MSDN, in some cases where existence must be checked, a join
produces better performance. Otherwise, the nested query must be processed
for each result of the outer query. In such cases, a join approach would
yield better results.

In general, joins work faster than subqueries, but in reality it all depends
on the execution plan that is generated by SQL Server. It does not matter
how we have written the query, SQL Server will always transform it on an
execution plan. if it is "smart" enought o generate the same plan from 
both queries, you will get the same result.

I would say, rather than going by theory, turn on client statistics and 
execution plan to see the performance of each option, and then make a
decision. 

*/

checkpoint;
GO
DBCC DROPCLEANBUFFERS; ---- Clears Query Cache
GO
DBCC FREEPROCCACHE;   ----- Clears execution plan cache
GO


---- 1 seconds 99,749 rows ---
select id,name,description
from tblProducts 
where id in
(
  select productid from tblProductSales

)

----- 1 seconds 99,749 rows -----
select distinct tblProducts.id,name,description
from tblProducts inner join tblProductSales
on tblProducts.id=tblProductSales.ProductId

---- 4 second 800,251 rows ----
select id,name,description 
from tblProducts 
where not exists(select * from tblProductSales where productid=tblProducts.id)

---- 4 second 800,251 rows ----
select tblproducts.id,name,description
from tblProducts 
left join tblProductSales
on tblProducts.id=tblProductSales.ProductId
where tblProductSales.ProductId is null



/* In our case we got same execution time in all cases,
that means the sql server query engine is smart enough
to produce the same execution plan for subqueries and joins
but we can try with client stats and query execution plan
to actually understand which approach is better
*/





