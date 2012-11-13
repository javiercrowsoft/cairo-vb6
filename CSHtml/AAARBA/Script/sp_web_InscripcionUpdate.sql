if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionUpdate]

/*

select insc_importe from aaarbaweb..inscripcion where insc_categoria =2
select 400 * 1.21
*/

go
create procedure sp_web_InscripcionUpdate (
	@@insc_id								int,
	@@insc_numero						int,
	@@insc_categoria        tinyint,
	@@insc_fecha						datetime,
	@@insc_socio            varchar(20),
	@@insc_socioLASFAR      varchar(20),
	@@insc_documento				varchar(30),
	@@insc_tipodocumento    tinyint,
	@@insc_descrip          varchar(1000),
	@@insc_apellido					varchar(255),
	@@insc_nombre						varchar(255),
	@@insc_importe					decimal(18,6),
	@@insc_email						varchar(255),

	@@insc_direccion				varchar(255),
	@@insc_codPostal				varchar(255),
	@@insc_localidad				varchar(255),
	@@insc_telefono					varchar(255),
	@@insc_fax							varchar(255),
	@@insc_asociacion				varchar(255),
	@@insc_cuitCuil					varchar(255),

	@@catf_id								int,

	@@pa_id									int,
	@@pro_id								int,
	@@cpg_id								int,
	@@cong_id								int,
	@@modifico							int,

	@@aabainsc_lasra        		tinyint,
  @@aabainsc_aerea        		tinyint,
  @@aabainsc_info         		tinyint,
	@@aabainsc_constanciaAfip		tinyint,
	@@aabaasoc_id               int,
	@@aabalab_id                int,
	@@aabainsc_acompannantes    smallint,
	@@insc_id_padre             int
)
as

begin

	set nocount on

	declare @bSuccess tinyint
	declare @msg      varchar(255)

	-- Categorias
	--
	declare @c_categoriaInvitadoCESC	int set @c_categoriaInvitadoCESC 	=5
	declare @c_categoriaOrador				int set @c_categoriaOrador 				=7
	declare @c_categoriaResidente     int set @c_categoriaResidente     =8

	declare @est_id int

	exec sp_web_InscripcionCheck @@insc_id, @bSuccess out, @msg out
	if @bSuccess = 0 begin
		raiserror (@msg, 16, 1)
		return
	end

	if @@insc_categoria = 1 begin

		set @@aabaasoc_id = 5

	end else begin

		if @@insc_categoria in (2,4,6) set @@insc_importe = @@insc_importe * 1.21

	end

	if @@insc_socio <> '' set @@insc_socioLASFAR = @@insc_socio
	if @@insc_socioLASFAR <> '' set @@insc_socio = @@insc_socioLASFAR

	begin transaction

	if @@insc_id = 0 begin

		exec SP_DBGetNewId 'aaarbaweb..Inscripcion', 'insc_id', @@insc_id out, 0
		exec SP_DBGetNewId2 'aaarbaweb..Inscripcion', 'insc_numero',0,10000, @@insc_numero out, 0

		insert into aaarbaweb..Inscripcion (
															insc_id,
                              insc_apellido,
															insc_nombre,
															insc_numero,
															insc_categoria,
															insc_socio,
															insc_socioLASFAR,
                              insc_documento,
															insc_tipodocumento,
                              insc_fecha,
															insc_email,
															insc_importe,
                              insc_descrip,
															insc_direccion,
															insc_codPostal,
															insc_localidad,
															insc_telefono,
															insc_fax,
															insc_asociacion,
															insc_cuitCuil,
															catf_id,
															pa_id,
															pro_id,
															cpg_id,
															est_id,
															cong_id,
															modifico,
															aabainsc_lasra,
														  aabainsc_aerea,
														  aabainsc_info,
															aabainsc_acompannantes,
															aabainsc_constanciaAfip,
															aabaasoc_id,
															aabalab_id,
															insc_id_padre
														)
										values	(
															@@insc_id,
                              @@insc_apellido,
															@@insc_nombre,
															@@insc_numero,
															@@insc_categoria,
															@@insc_socio,
															@@insc_socioLASFAR,
                              @@insc_documento,
															@@insc_tipodocumento,
															@@insc_fecha,
															@@insc_email,
															@@insc_importe,
                              @@insc_descrip,
															@@insc_direccion,
															@@insc_codPostal,
															@@insc_localidad,
															@@insc_telefono,
															@@insc_fax,
															@@insc_asociacion,
															@@insc_cuitCuil,
															@@catf_id,
															@@pa_id,
															@@pro_id,
															@@cpg_id,
															1,
															@@cong_id,
															@@modifico,
															@@aabainsc_lasra,
														  @@aabainsc_aerea,
														  @@aabainsc_info,
															@@aabainsc_acompannantes,
															@@aabainsc_constanciaAfip,
															@@aabaasoc_id,
															@@aabalab_id,
															@@insc_id_padre
														)
		
	end else begin

			update aaarbaweb..Inscripcion set
															insc_numero					= @@insc_numero,
                              insc_apellido   		= @@insc_apellido,
															insc_nombre					= @@insc_nombre,
															insc_categoria			= @@insc_categoria,
															insc_socio					= @@insc_socio,
															insc_socioLASFAR		= @@insc_socioLASFAR,
                              insc_documento			= @@insc_documento,
															insc_tipodocumento	= @@insc_tipodocumento,
                              insc_fecha        	= @@insc_fecha,
															insc_email					= @@insc_email,
															insc_importe				= @@insc_importe,
															insc_descrip        = @@insc_descrip,
															insc_direccion			= @@insc_direccion,
															insc_codPostal			= @@insc_codPostal,
															insc_localidad			= @@insc_localidad,
															insc_telefono				= @@insc_telefono,
															insc_fax						= @@insc_fax,
															insc_asociacion			= @@insc_asociacion,
															insc_cuitCuil				= @@insc_cuitCuil,
															catf_id							= @@catf_id,
															cong_id							= @@cong_id,
                              pa_id          			= @@pa_id,
															pro_id							= @@pro_id,
															cpg_id							= @@cpg_id,
															modifico						= @@modifico,

															insc_id_padre       = @@insc_id_padre,

															aabainsc_lasra						= @@aabainsc_lasra,
														  aabainsc_aerea						= @@aabainsc_aerea,
														  aabainsc_info							= @@aabainsc_info,
															aabainsc_acompannantes		= @@aabainsc_acompannantes,
															aabainsc_constanciaAfip		= @@aabainsc_constanciaAfip,
															aabalab_id								= @@aabalab_id,
															aabaasoc_id								= @@aabaasoc_id,

                              modificado          = getdate()

			where insc_id = @@insc_id
	end

	/* Estado 

	*/

	select @est_id = est_id from aaarbaweb..Inscripcion where insc_id = @@insc_id

	if @@insc_categoria = @c_categoriaInvitadoCESC begin

		if @est_id = 1 update aaarbaweb..Inscripcion set est_id = 1008	--Pendiente de envió constancia de inscripción
									 where insc_id = @@insc_id
	end else begin

		if    @@insc_categoria = @c_categoriaOrador 
       or @@insc_categoria = @c_categoriaResidente begin
	
			if @est_id = 1 update aaarbaweb..Inscripcion set est_id = 5	--Finalizado
										 where insc_id = @@insc_id
		end else begin

			exec sp_web_InscripcionUpdateEstado @@insc_id

		end
	end

	commit transaction

	select insc_id, insc_numero from aaarbaweb..Inscripcion where insc_id = @@insc_id

	return
ControlError:

	if @@trancount > 0 begin
		rollback transaction	
  end

	raiserror ('Error al grabar la inscripción', 16, 1)

end

go
