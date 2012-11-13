if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_Cfg_SetValor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Cfg_SetValor]

go

/*

sp_Cfg_SetValor 1

*/
create procedure sp_Cfg_SetValor (
	@@cfg_grupo     varchar(60),
  @@cfg_aspecto   varchar(60),
  @@cfg_valor     varchar(5000),
	@@emp_id        int = null
)
as

begin

	set nocount on

	if exists(select * from Configuracion 
						where cfg_grupo = @@cfg_grupo 
							and cfg_aspecto = @@cfg_aspecto
							and (emp_id = @@emp_id or (emp_id is null and @@emp_id is null))
						)
	
			update Configuracion set cfg_valor = @@cfg_valor, emp_id = @@emp_id
			where cfg_grupo = @@cfg_grupo 
				and cfg_aspecto = @@cfg_aspecto
				and (emp_id = @@emp_id or (emp_id is null and @@emp_id is null))
	else
			insert into Configuracion (cfg_grupo,cfg_aspecto,cfg_valor, emp_id,modifico) 
					values(@@cfg_grupo,@@cfg_aspecto,@@cfg_valor,@@emp_id,1)

end