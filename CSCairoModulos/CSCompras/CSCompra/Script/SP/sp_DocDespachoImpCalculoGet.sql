
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDespachoImpCalculoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDespachoImpCalculoGet]

go
create procedure sp_DocDespachoImpCalculoGet (
@@dic_id int
)as 
begin
select 
			dic.*,
			
			rc_nrodoc + ' ' + prov_nombre as comprobante,

			mon1.mon_nombre				as moneda1,
			mon2.mon_nombre				as moneda2
from 
			DespachoImpCalculo dic inner join RemitoCompra rc 	on dic.rc_id 			= rc.rc_id
														 inner join Proveedor prov 		on rc.prov_id  		= prov.prov_id
                   					 inner join Usuario us     		on dic.modifico 	= us.us_id
														 inner join Moneda mon1    		on dic.mon_id1    = mon1.mon_id
														 left  join Moneda mon2    		on dic.mon_id2    = mon2.mon_id
where 
				  
					@@dic_id = dic_id

end
