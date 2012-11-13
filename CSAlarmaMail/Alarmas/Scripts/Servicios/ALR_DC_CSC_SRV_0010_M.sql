/*
	Facturas con mas de 30 dias de vencidas
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ALR_DC_CSC_SRV_0010_M]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ALR_DC_CSC_SRV_0010_M]
go

/*
select * from FacturaCompra

sp_docFacturaCompraget 47

ALR_DC_CSC_SRV_0010_M
  
*/

create procedure ALR_DC_CSC_SRV_0010_M 

as 
begin

	set nocount on

	declare @alm_id int
	
	set @alm_id = 2

	declare @fecha 								datetime

	declare @offset_inicio 				int set @offset_inicio      = 1000000
	declare @offset_alarma1       int set @offset_alarma1 		= 2000000
	declare @offset_alarma2       int set @offset_alarma2 		= 3000000
	declare @offset_finalizado    int set @offset_finalizado	= 4000000
	declare @offset_vencido       int set @offset_vencido			= 5000000

	set @fecha = dateadd(n,-5,getdate())

	-- //////////////////////////////////////////////////////////////////////////////////////
	--
	-- Inicio
	--
	-- //////////////////////////////////////////////////////////////////////////////////////
		select 
					 @offset_inicio + tar.tar_id 	as almr_id_mail,

					 m.mail_id,
					 null													as maili_id,
					 mail_emailTo                	as almr_emailto,
					 mail_emailCc                 as almr_emailcc,

					 'Aviso de Inicio de tarea ' 
						+ tar_nombre								as almr_subject,

					 tar_nombre	+char(13)
						+ tar_descrip								as msg
					
		from Tarea tar 	inner join AlarmaItem ali on tar.ali_id = ali.ali_id
										inner join Mail m         on ali.mail_id_inicio = m.mail_id
	
		where os_id is not null
	
			and tar_fechahoraini >= @fecha

			and	not exists (select * from AlarmaMailResult where alm_id = @alm_id and almr_id_mail = @offset_inicio + tar_id)

	-- //////////////////////////////////////////////////////////////////////////////////////
	--
	-- Alarma 1
	--
	-- //////////////////////////////////////////////////////////////////////////////////////
		union all

		select 
					 @offset_alarma1 + tar.tar_id as almr_id_mail,

					 m.mail_id,
					 null													as maili_id,
					 mail_emailTo                	as almr_emailto,
					 mail_emailCc                 as almr_emailcc,

					 'Aviso de Inicio de tarea ' 
						+ tar_nombre								as almr_subject,

					 tar_nombre	+char(13)
						+ tar_descrip								as msg
					
		from Tarea tar 	inner join AlarmaItem ali on tar.ali_id = ali.ali_id
										inner join Mail m         on ali.mail_id_alarma1 = m.mail_id
	
		where os_id is not null
	
			and tar_estado1 >= @fecha

			and	not exists (select * from AlarmaMailResult where alm_id = @alm_id and almr_id_mail = @offset_alarma1 + tar_id)

	-- //////////////////////////////////////////////////////////////////////////////////////
	--
	-- Alarma 2
	--
	-- //////////////////////////////////////////////////////////////////////////////////////
		union all

		select 
					 @offset_alarma2 + tar.tar_id 	as almr_id_mail,

					 m.mail_id,
					 null													as maili_id,
					 mail_emailTo                	as almr_emailto,
					 mail_emailCc                 as almr_emailcc,

					 'Aviso de Inicio de tarea ' 
						+ tar_nombre								as almr_subject,

					 tar_nombre	+char(13)
						+ tar_descrip								as msg
					
		from Tarea tar 	inner join AlarmaItem ali on tar.ali_id = ali.ali_id
										inner join Mail m         on ali.mail_id_alarma2 = m.mail_id
	
		where os_id is not null
	
			and tar_estado2 >= @fecha

			and	not exists (select * from AlarmaMailResult where alm_id = @alm_id and almr_id_mail = @offset_alarma2 + tar_id)

	-- //////////////////////////////////////////////////////////////////////////////////////
	--
	-- Finalizado
	--
	-- //////////////////////////////////////////////////////////////////////////////////////
		union all

		select 
					 @offset_finalizado + tar.tar_id 	as almr_id_mail,

					 m.mail_id,
					 null													as maili_id,
					 mail_emailTo                	as almr_emailto,
					 mail_emailCc                 as almr_emailcc,

					 'Aviso de Inicio de tarea ' 
						+ tar_nombre								as almr_subject,

					 tar_nombre	+char(13)
						+ tar_descrip								as msg
					
		from Tarea tar 	inner join AlarmaItem ali on tar.ali_id = ali.ali_id
										inner join Mail m         on ali.mail_id_finalizado = m.mail_id
	
		where os_id is not null
	
			and tar_fechahorafin >= @fecha

			and	not exists (select * from AlarmaMailResult where alm_id = @alm_id and almr_id_mail = @offset_finalizado + tar_id)

	-- //////////////////////////////////////////////////////////////////////////////////////
	--
	-- Vencido
	--
	-- //////////////////////////////////////////////////////////////////////////////////////
		union all

		select 
					 @offset_vencido + tar.tar_id 	as almr_id_mail,

					 m.mail_id,
					 null													as maili_id,
					 mail_emailTo                	as almr_emailto,
					 mail_emailCc                 as almr_emailcc,

					 'Aviso de Inicio de tarea ' 
						+ tar_nombre								as almr_subject,

					 tar_nombre	+char(13)
						+ tar_descrip								as msg
					
		from Tarea tar 	inner join AlarmaItem ali on tar.ali_id = ali.ali_id
										inner join Mail m         on ali.mail_id_vencido = m.mail_id
	
		where os_id is not null
	
			and tar_fechahorafin >= @fecha
			and tar_finalizada = 0

			and	not exists (select * from AlarmaMailResult where alm_id = @alm_id and almr_id_mail = @offset_vencido + tar_id)

end

go