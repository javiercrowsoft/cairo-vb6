if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_getmarcas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_getmarcas]

go
/*

	sp_srv_catalog_getmarcas

*/

create procedure sp_srv_catalog_getmarcas (

	@@catw_id int = 0

)

as

begin

	set nocount on

	declare @aspecto 		varchar(255)
	declare @valor   		varchar(50)
	declare @last_run		datetime

	set @aspecto = 'marcas_' +  convert(varchar,@@catw_id)

	exec sp_Cfg_GetValor 'Catalogo Web',@aspecto,@valor out

	if @valor is null set @last_run = '19000101'
	else
		if isdate(@valor) <> 0 set @last_run = @valor
		else 							     set @last_run = '19000101'

	declare @bselect int

	if datediff(n,@last_run,getdate()) > 30 set @bselect = 1
	else																		set @bselect = 0

	set @last_run = getdate()

	if @bselect <> 0 exec sp_Cfg_SetValor 'Catalogo Web',@aspecto,@last_run

	select 	marc_id, 
					marc_nombre, 
					marc_textoweb 

	from Marca

	where @bselect <> 0

end