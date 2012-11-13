if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_getmarcacategoria]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_getmarcacategoria]

go
/*

	exec sp_Cfg_SetValor 'Catalogo Web','marcascategoria_3','19000101'
	exec sp_srv_catalog_getmarcacategoria 3

*/

create procedure sp_srv_catalog_getmarcacategoria (
	@@catw_id int
)
as

begin

	set nocount on

	declare @aspecto 		varchar(255)
	declare @valor   		varchar(50)
	declare @last_run		datetime

	set @aspecto = 'marcascategoria_' +  convert(varchar,@@catw_id)

	exec sp_Cfg_GetValor 'Catalogo Web',@aspecto,@valor out,0

	if @valor is null set @last_run = '19000101'
	else
		if isdate(@valor) <> 0 set @last_run = @valor
		else 							     set @last_run = '19000101'

	declare @bselect int

	if datediff(n,@last_run,getdate()) > 30 set @bselect = 1
	else																		set @bselect = 0

	set @last_run = getdate()

	if @bselect <> 0 exec sp_Cfg_SetValor 'Catalogo Web',@aspecto,@last_run

	select marc.marc_id, rubti.rubti_id, marc_nombre, rubti_nombre 
	from producto pr inner join rubrotablaitem rubti on pr.rubti_id1 = rubti.rubti_id
									 inner join marca marc on pr.marc_id = marc.marc_id
									 inner join rubro rub on pr.rub_id = rub.rub_id

	where rub_escriterio <> 0 and @bselect <> 0

	group by marc.marc_id, rubti.rubti_id, marc_nombre, rubti_nombre 

end