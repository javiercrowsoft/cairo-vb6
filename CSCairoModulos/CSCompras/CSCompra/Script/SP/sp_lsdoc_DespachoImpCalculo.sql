
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_DespachoImpCalculo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_DespachoImpCalculo]

go
create procedure sp_lsdoc_DespachoImpCalculo (
@@dic_id int
)as 
begin
select 
			dic_id,
			''									  as [TypeTask],
			case dic_tipo
						when 1 then 'Provisorio'
						when 2 then 'Definitivo'
			end										as Tipo,
			dic_numero            as [Número],
			prov_nombre           as [Proveedor],
			dic_titulo						as [Título],

			dic_fecha						  as [Fecha],
			dic_total							as [Total],

			dic_via								as [Vía],
			dic_viaempresa				as [Empresa],

			dic_factura						as [Factura],
			dic_cambio1						as [Cambio COMEX],
			dic_cambio2						as [Cambio Origen],
			dic_pase							as [Pase],
			dic_totalgtos					as [Total Gtos.],
			dic_porcfob						as [Porc. FOB],
			dic_var								as [Variación],
			dic_porcfobfinal			as [Porc. FOB Final],
			dic_total							as [Total],
			dic_totalorigen				as [Total Origen],
			mon1.mon_nombre				as [Moneda COMEX],
			mon2.mon_nombre				as [Moneda Origen],

			dic.Creado,
			dic.Modificado,
			us_nombre             as [Modifico],
			dic_descrip						as [Observaciones]
from 
			DespachoImpCalculo dic  inner join RemitoCompra rc  on dic.rc_id      = rc.rc_id
															inner join Proveedor prov 	on rc.prov_id  		= prov.prov_id
                   					 	inner join Usuario us     	on dic.modifico 	= us.us_id
														 	inner join Moneda mon1    	on dic.mon_id1    = mon1.mon_id
														 	left  join Moneda mon2    	on dic.mon_id2    = mon2.mon_id
where 
				  
					@@dic_id = dic_id

end
