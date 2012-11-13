/*---------------------------------------------------------------------
Nombre: Numeros de serie huerfanos (que no estan asociados a ningun comprobante)
---------------------------------------------------------------------*/

/*
Para testear:


DC_CSC_SYS_0070 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0070]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0070]

go
create procedure DC_CSC_SYS_0070 (

  @@us_id    int
)
as

set nocount on

begin

	select prns_id,
				 pr_nombrecompra  as Articulo,
				 prns_codigo 			as [Numero de Serie],
				 p.creado      		as Fecha 

	from productonumeroserie p inner join producto pr on p.pr_id = pr.pr_id
	
	where not exists(select * 
									 from facturacompra f 
										inner join stockitem s on f.st_id = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	
	and not exists(select * 
									 from remitocompra r 
										inner join stockitem s on r.st_id = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	and not exists(select * 
									 from remitoventa r 
										inner join stockitem s on r.st_id = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	
	and not exists(select * 
									 from facturaventa f 
										inner join stockitem s on f.st_id = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	and not exists(select * 
									 from parteprodkit pk 
										inner join stockitem s on pk.st_id1 = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	
	and not exists(select * 
									 from parteprodkit pk 
										inner join stockitem s on pk.st_id2 = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	
	and not exists(select * 
									 from recuentostock r 
										inner join stockitem s on r.st_id1 = s.st_id
	 								 where s.prns_id = p.prns_id
									)
	
	and not exists(select * 
									 from recuentostock r 
										inner join stockitem s on r.st_id2 = s.st_id
	 								 where s.prns_id = p.prns_id
									)

end
GO