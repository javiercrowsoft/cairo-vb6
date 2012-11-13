if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioUpdate]

/*


 sp_web_ParteDiarioUpdate 
																1
																,'Demo Intranet Muresco'
																,'El miercoles 14/05/2004 se presentara una demo de las nuevas utilidades de la Intranet: - Llamadas pendientes. - Notas por cliente, departamento, contacto. - Vencimientos.'
																,'20040514'
																,'20040614'
																,'20040614'
																
																,1
																,1
																,''
																,1
																
																,7
																,7
																,2
																,1
																,1
																,1
																,16
																,9
																,7

*/

go
create procedure sp_web_ParteDiarioUpdate (
	@@ptd_id 											int,
	@@ptd_titulo									varchar(100),
	@@ptd_descrip									varchar(5000),
	@@ptd_fechaini								datetime,
	@@ptd_fechafin								datetime,
	@@ptd_alarma									datetime,

	@@ptd_cumplida								tinyint,
	@@ptd_recurrente							tinyint,
	@@ptd_listausuariosId					varchar(255),
	@@ptd_publico                 tinyint,

	@@ptd_horaini                 datetime,
  @@ptd_horafin                 datetime,
	@@ptd_id_padre                int,

	@@ptdt_id 										int,

	@@us_id_responsable						int,
	@@us_id_asignador 						int,
	@@cont_id 										int,

	@@tarest_id										int,
	@@prio_id											int,
	@@lgj_id 											int,

	@@cli_id 											int,
	@@prov_id                     int,
	@@dpto_id 										int,
	@@modifico										int,

  @@rtn                   			int out	
)
as

begin

	set nocount on

	declare @bUpdateRecurrente tinyint

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 15002, @@ptd_id, @@modifico, 2

	set @@ptd_titulo									= IsNull(@@ptd_titulo,'')
	set @@ptd_descrip									= IsNull(@@ptd_descrip,'')
	set @@ptd_fechaini								= IsNull(@@ptd_fechaini,'19000101')
	set @@ptd_fechafin								= IsNull(@@ptd_fechafin,'19000101')
	set @@ptd_alarma									= IsNull(@@ptd_alarma,'19000101')
	set @@ptd_cumplida								= IsNull(@@ptd_cumplida,3)
	set @@ptd_recurrente							= IsNull(@@ptd_recurrente,10)
	set @@ptd_listausuariosId					= IsNull(@@ptd_listausuariosId,'')
	set @@ptd_publico                 = IsNull(@@ptd_publico,0)

	set @@ptd_horaini                 = IsNull(@@ptd_horaini,'19000101')
	set @@ptd_horafin                 = IsNull(@@ptd_horafin,'19000101')

	if @@ptd_alarma <> '19000101' begin
  	set @@ptd_alarma = DateAdd(hh,DatePart(hh,@@ptd_horaini),@@ptd_alarma)
	  set @@ptd_alarma = DateAdd(n,DatePart(n,@@ptd_horaini),@@ptd_alarma)
	end

	set @@ptdt_id 										= IsNull(@@ptdt_id,1)

	if @@cont_id = 0 set @@cont_id = null

	if @@ptd_id_padre = 0      set @@ptd_id_padre      = null
	if @@us_id_responsable = 0 set @@us_id_responsable = null
	if @@us_id_asignador = 0	 set @@us_id_asignador   = null

	if @@tarest_id = 0	set @@tarest_id = null
	if @@prio_id = 0		set @@prio_id   = null
	if @@lgj_id = 0			set @@lgj_id 		= null

	if @@prov_id = 0  set @@prov_id = null
	if @@cli_id  = 0	set @@cli_id 	= null
	if @@dpto_id = 0	set @@dpto_id = null

  if @@dpto_id is null begin
    select @@dpto_id = dpto_id 
    from usuario inner join persona on usuario.prs_id = persona.prs_id 
    where us_id = @@us_id_responsable

    if @@dpto_id is null begin
      select @@dpto_id = dpto_id 
      from usuario inner join persona on usuario.prs_id = persona.prs_id 
      where us_id = @@us_id_asignador
    end
  end

	if @@ptd_id = 0 begin

		exec SP_DBGetNewId 'ParteDiario', 'ptd_id', @@ptd_id out, 0

		declare @ptd_numero int
    declare @ta_id      varchar(255)
		
		exec sp_Cfg_GetValor 'Envio','Talonario Parte Diario', @ta_id out
		select @ptd_numero = ta_ultimonro from talonario where ta_id = convert(int,@ta_id)

		select @ptd_numero = @ptd_numero +1

		insert into ParteDiario (
															ptd_id,
															ptd_numero,
															ptd_titulo,
															ptd_descrip,
															ptd_fechaini,
															ptd_fechafin,
															ptd_alarma,
															ptd_cumplida,
															ptd_recurrente,
															ptd_listausuariosId,
															ptd_publico,
															ptd_horaini,
                              ptd_horafin,
															ptd_id_padre,
															ptdt_id,
															us_id_responsable,
															us_id_asignador,
															cont_id,
															tarest_id,
															prio_id,
															lgj_id,
															cli_id,
															prov_id,
															dpto_id,
															modifico
														)
										values	(
															@@ptd_id,
															@ptd_numero,
															@@ptd_titulo,
															@@ptd_descrip,
															@@ptd_fechaini,
															@@ptd_fechafin,
															@@ptd_alarma,
															@@ptd_cumplida,
															@@ptd_recurrente,
															@@ptd_listausuariosId,
															@@ptd_publico,
															@@ptd_horaini,
                              @@ptd_horafin,
															@@ptd_id_padre,
															@@ptdt_id,
															@@us_id_responsable,
															@@us_id_asignador,
															@@cont_id,
															@@tarest_id,
															@@prio_id,
															@@lgj_id,
															@@cli_id,
															@@prov_id,
															@@dpto_id,
															@@modifico
														)

		exec sp_talonarioSet @ta_id, @ptd_numero

		exec sp_web_ParteDiarioSaveRecurrente @@ptd_id, 0
		
	end else begin

			set @bUpdateRecurrente = 0

			if exists(select * from ParteDiario ptd
								where ptd_id = @@ptd_id 
									and (
														ptd_id_padre is null
												or	exists(select * from ParteDiario 
																	 where ptd_id = ptd.ptd_id_padre
																		 and (	 ptd_recurrente = 0 
																					or ptd_recurrente = 10
																				 )
																	)
											)
									and (
														ptd_recurrente <> @@ptd_recurrente
												or	ptd_fechaini   <> @@ptd_fechaini
												or  ptd_fechafin   <> @@ptd_fechafin
											)
								) begin

				set @bUpdateRecurrente = 1
				
			end									

			update ParteDiario set
															ptd_titulo							= @@ptd_titulo,
															ptd_descrip							= @@ptd_descrip,
															ptd_fechaini						= @@ptd_fechaini,
															ptd_fechafin						= @@ptd_fechafin,
															ptd_alarma							= @@ptd_alarma,
															ptd_cumplida						= @@ptd_cumplida,
															ptd_recurrente					= @@ptd_recurrente,
															ptd_publico             = @@ptd_publico,
															ptd_listausuariosId			= @@ptd_listausuariosId,
															ptd_horaini             = @@ptd_horaini,
                              ptd_horafin             = @@ptd_horafin,
															ptd_id_padre						= @@ptd_id_padre,
															ptdt_id									= @@ptdt_id,
															us_id_responsable				= @@us_id_responsable,
															us_id_asignador					= @@us_id_asignador,
															cont_id									= @@cont_id,
															tarest_id								= @@tarest_id,
															prio_id									= @@prio_id,
															lgj_id									= @@lgj_id,
															cli_id									= @@cli_id,
															prov_id									= @@prov_id,
															dpto_id									= @@dpto_id,
															modifico								= @@modifico

			where ptd_id = @@ptd_id

			if @bUpdateRecurrente <> 0 exec sp_web_ParteDiarioSaveRecurrente @@ptd_id, 1

	end

  exec sp_web_ParteDiarioUpdateAviso @@ptd_id

	set @@rtn = @@ptd_id

end

go