/*---------------------------------------------------------------------
Nombre: Clientes con credito mayor a X
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_VEN_9986 1, '20060501','20060531','0', '0','0','0','0','0','0',0

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9986]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9986]

go
create procedure DC_CSC_VEN_9986 (
	@@us_id 		int,
	@@credito 	decimal(18,6)
)
as
begin

	select 	cli_id, 
					cli_codigo as Codigo,
					cli_nombre as Cliente,
					cli_creditoctacte		as [Deuda en Cta. Cte.],
					cli_creditototal    as [Deuda Total]
	from Cliente 
	where cli_creditoctacte > @@credito
end
GO
