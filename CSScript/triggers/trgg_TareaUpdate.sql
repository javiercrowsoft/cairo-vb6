if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_TareaUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_TareaUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_TareaUpdate] ON [dbo].[Tarea] 
FOR INSERT, UPDATE
AS

declare @tar_id int
declare @ptd_id int 

-------------------

	declare @ptd_numero int
	declare @ptd_titulo varchar (100) 
	declare @ptd_descrip varchar (5000)
	declare @ptd_fechaini datetime 
	declare @ptd_fechafin datetime 
	declare @ptd_alarma datetime 
	declare @ptd_cumplida tinyint
	declare @ptd_recurrente tinyint
	declare @ptd_listausuariosId varchar (255) 
	declare @ptd_publico tinyint 
	declare @ptd_horaini datetime
	declare @ptd_horafin datetime
	declare @ptd_vtoaviso tinyint
	declare @ptd_vtocumplido tinyint
	declare @ptdt_id int 
	declare @ptd_id_padre int
	declare @us_id_responsable int
	declare @us_id_asignador int 
	declare @cont_id int 
	declare @tarest_id int
	declare @prio_id int 
	declare @lgj_id int 
	declare @cli_id int 
	declare @prov_id int
	declare @dpto_id int
	declare @ven_id int
	declare @suc_id int
	declare @doct_id int
	declare @doc_id int 
	declare @prns_id int
	declare @modificado datetime 
	declare @creado datetime 
	declare @modifico int 

-------------------

declare c_TareaUpdate insensitive cursor for

	select 	tar_id, 
					case when isnumeric(tar_numero)<>0 then tar_numero else 0 end,--		 ptd_numero,
					tar_nombre		,--		 ptd_titulo,
					tar_descrip		,--		 ptd_descrip,
					tar_fechaini	,--		 ptd_fechaini,
					tar_fechafin	,--		 ptd_fechafin,
					tar_alarma		,--		 ptd_alarma,

					case --		 ptd_cumplida,
						when tar_finalizada <> 0 and tar_cumplida <> 0  then	3
						when tar_finalizada <> 0 and tar_rechazada <> 0 then	2
						else																									1
					end,

					10,--		 ptd_recurrente,
					'',--		 ptd_listausuariosId,
					1,--		 ptd_publico,
					tar_horaini		,--		 ptd_horaini,
					tar_horaini		,--		 ptd_horafin,
					0				,--		 ptd_vtoaviso,
					1				,--		 ptd_vtocumplido,
					5				,--		 ptdt_id,
					null		,--		 ptd_id_padre,
					us_id_responsable	,--		 us_id_responsable,
					us_id_asignador		,--		 us_id_asignador,
					cont_id		,--		 cont_id,
					tarest_id	,--		 tarest_id,
					prio_id		,--		 prio_id,
					null			,--		 lgj_id,
					cli_id		,--		 cli_id,
					null			,--		 prov_id,
					dpto_id		,--		 dpto_id,
					null			,--		 ven_id,
					null			,--		 suc_id,
					null			,--		 doct_id,
					null			,--		 doc_id,
					prns_id		,--		 prns_id,
					modificado,--		 modificado,
					creado		,--		 creado,
					modifico	--		 modifico

	from inserted

open c_TareaUpdate

fetch next from c_TareaUpdate into 
															 @tar_id,
															 @ptd_numero,
															 @ptd_titulo,
															 @ptd_descrip,
															 @ptd_fechaini,
															 @ptd_fechafin,
															 @ptd_alarma,
															 @ptd_cumplida,
															 @ptd_recurrente,
															 @ptd_listausuariosId,
															 @ptd_publico,
															 @ptd_horaini,
															 @ptd_horafin,
															 @ptd_vtoaviso,
															 @ptd_vtocumplido,
															 @ptdt_id,
															 @ptd_id_padre,
															 @us_id_responsable,
															 @us_id_asignador,
															 @cont_id,
															 @tarest_id,
															 @prio_id,
															 @lgj_id,
															 @cli_id,
															 @prov_id,
															 @dpto_id,
															 @ven_id,
															 @suc_id,
															 @doct_id,
															 @doc_id,
															 @prns_id,
															 @modificado,
															 @creado,
															 @modifico

while @@fetch_status = 0
begin

	set @ptd_id = null

	select @ptd_id = ptd_id from ParteDiario where tar_id = @tar_id

	if @ptd_id is null begin

		exec sp_dbgetnewid 'ParteDiario','ptd_id',@ptd_id out, 0

		insert into ParteDiario (
														 ptd_id,
														 tar_id,
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
														 ptd_vtoaviso,
														 ptd_vtocumplido,
														 ptdt_id,
														 ptd_id_padre,
														 us_id_responsable,
														 us_id_asignador,
														 cont_id,
														 tarest_id,
														 prio_id,
														 lgj_id,
														 cli_id,
														 prov_id,
														 dpto_id,
														 ven_id,
														 suc_id,
														 doct_id,
														 doc_id,
														 prns_id,
														 modificado,
														 creado,
														 modifico
														)

										values	(
															 @ptd_id,
															 @tar_id,
															 @ptd_numero,
															 @ptd_titulo,
															 @ptd_descrip,
															 @ptd_fechaini,
															 @ptd_fechafin,
															 @ptd_alarma,
															 @ptd_cumplida,
															 @ptd_recurrente,
															 @ptd_listausuariosId,
															 @ptd_publico,
															 @ptd_horaini,
															 @ptd_horafin,
															 @ptd_vtoaviso,
															 @ptd_vtocumplido,
															 @ptdt_id,
															 @ptd_id_padre,
															 @us_id_responsable,
															 @us_id_asignador,
															 @cont_id,
															 @tarest_id,
															 @prio_id,
															 @lgj_id,
															 @cli_id,
															 @prov_id,
															 @dpto_id,
															 @ven_id,
															 @suc_id,
															 @doct_id,
															 @doc_id,
															 @prns_id,
															 @modificado,
															 @creado,
															 @modifico
														)

	end else begin

			update ParteDiario set

														 ptd_numero				=		 @ptd_numero,
														 ptd_titulo				=		 @ptd_titulo,
														 ptd_descrip			=		 @ptd_descrip,
														 ptd_fechaini			=		 @ptd_fechaini,
														 ptd_fechafin			=		 @ptd_fechafin,
														 ptd_alarma				=		 @ptd_alarma,
														 ptd_cumplida			=		 @ptd_cumplida,
														 ptd_recurrente		=		 @ptd_recurrente,
														 ptd_listausuariosId=		 @ptd_listausuariosId,
														 ptd_publico			=		 @ptd_publico,
														 ptd_horaini			=		 @ptd_horaini,
														 ptd_horafin			=		 @ptd_horafin,
														 ptd_vtoaviso			=		 @ptd_vtoaviso,
														 ptd_vtocumplido	=		 @ptd_vtocumplido,
														 ptdt_id					=		 @ptdt_id,
														 ptd_id_padre			=		 @ptd_id_padre,
														 us_id_responsable=		 @us_id_responsable,
														 us_id_asignador	=		 @us_id_asignador,
														 cont_id					=		 @cont_id,
														 tarest_id				=		 @tarest_id,
														 prio_id					=		 @prio_id,
														 lgj_id						=		 @lgj_id,
														 cli_id						=		 @cli_id,
														 prov_id					=		 @prov_id,
														 dpto_id					=		 @dpto_id,
														 ven_id						=		 @ven_id,
														 suc_id						=		 @suc_id,
														 doct_id					=		 @doct_id,
														 doc_id						=		 @doc_id,
														 prns_id					=		 @prns_id,
														 modificado				=		 @modificado,
														 creado						=		 @creado,
														 modifico					=		 @modifico

			where ptd_id = @ptd_id

	end

	fetch next from c_TareaUpdate into 
															 @tar_id,
															 @ptd_numero,
															 @ptd_titulo,
															 @ptd_descrip,
															 @ptd_fechaini,
															 @ptd_fechafin,
															 @ptd_alarma,
															 @ptd_cumplida,
															 @ptd_recurrente,
															 @ptd_listausuariosId,
															 @ptd_publico,
															 @ptd_horaini,
															 @ptd_horafin,
															 @ptd_vtoaviso,
															 @ptd_vtocumplido,
															 @ptdt_id,
															 @ptd_id_padre,
															 @us_id_responsable,
															 @us_id_asignador,
															 @cont_id,
															 @tarest_id,
															 @prio_id,
															 @lgj_id,
															 @cli_id,
															 @prov_id,
															 @dpto_id,
															 @ven_id,
															 @suc_id,
															 @doct_id,
															 @doc_id,
															 @prns_id,
															 @modificado,
															 @creado,
															 @modifico

end

close c_TareaUpdate
deallocate c_TareaUpdate


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

