if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioGetEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioGetEx]

/*

sp_web_ParteDiarioGetEx 
	5,
	0,
	0,
	0,
	0,
	0,
	0,
  0,
  0,
  0,
	'20041026',
	'20081026',
  '1',
  0
	
select * from departamento where dpto_nombre = 'ventas'

*/

go
create procedure sp_web_ParteDiarioGetEx (
	@@ptdt_id									int,
	@@ptd_cumplida            int,
	@@dpto_id									int,
	@@cont_id									int,
	@@tarest_id								int,
	@@prio_id									int,
	@@lgj_id									int,
	@@cli_id									int,
  @@us_id_responsable       int,
  @@us_id_asignador         int,
	@@fechaDesde							datetime,
	@@fechaHasta							datetime,
	@@us_id										int,
	@@ptd_id                  int = 0
)
as

begin

	set nocount on

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 15002, @@ptd_id, @@us_id, 3

--/////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////
--
--  Un lista de partes diarios
--
--/////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////

	if @@ptd_id = 0 begin

--/////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////

    if @@ptdt_id = -1001 begin

      exec sp_web_ParteDiarioGetAviso 
                                      @@ptdt_id,
                                      @@ptd_cumplida,
                                      @@dpto_id,
                                      @@cont_id,
                                      @@tarest_id,
                                      @@prio_id,
                                      @@lgj_id,
                                      @@cli_id,
                                      @@us_id_responsable,
                                      @@us_id_asignador,
                                      @@fechaDesde,
                                      @@fechaHasta,
                                      @@us_id

		end else begin 
			if @@ptdt_id = -6 begin

	      exec sp_web_ParteDiarioGetAlarmas 
	                                      @@ptdt_id,
	                                      @@ptd_cumplida,
	                                      @@dpto_id,
	                                      @@cont_id,
	                                      @@tarest_id,
	                                      @@prio_id,
	                                      @@lgj_id,
	                                      @@cli_id,
	                                      @@us_id_responsable,
	                                      @@us_id_asignador,
	                                      @@fechaDesde,
	                                      @@fechaHasta,
	                                      @@us_id

	    end else begin
	
	      exec sp_web_ParteDiarioGetPartes 
	                                      @@ptdt_id,
	                                      @@ptd_cumplida,
	                                      @@dpto_id,
	                                      @@cont_id,
	                                      @@tarest_id,
	                                      @@prio_id,
	                                      @@lgj_id,
	                                      @@cli_id,
	                                      @@us_id_responsable,
	                                      @@us_id_asignador,
	                                      @@fechaDesde,
	                                      @@fechaHasta,
	                                      @@us_id
	    end 
		end
	end
end
go