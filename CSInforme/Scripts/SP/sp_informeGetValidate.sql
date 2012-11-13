/*---------------------------------------------------------------------
Nombre: Historia de movimientos de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_informeGetValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_informeGetValidate]

/*

 sp_informeGetValidate 

*/

go
create procedure sp_informeGetValidate 

as 
begin
set nocount on


	select inf.inf_id,
				 inf_codigo,
				 inf_nombre,
				 isnull(count(infp.inf_id),0) inf_param_count

	from informe inf left join informeparametro infp on inf.inf_id = infp.inf_id

	where inf_reporte <> ''

	group by 
		inf.inf_id, 
		inf_codigo,
		inf_nombre

	order by inf_codigo

end