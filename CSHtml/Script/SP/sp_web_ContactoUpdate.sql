if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ContactoUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactoUpdate]

/*


*/

go
create procedure sp_web_ContactoUpdate (
  @@agn_id                      int,
	@@cont_id 										int,
  @@cont_apellido               varchar(100),
	@@cont_nombre									varchar(255),
	@@cont_codigo									varchar(255),
  @@cont_tratamiento            varchar(10),
	@@cont_telefono								varchar(100),
  @@cont_fax                    varchar(100),
	@@cont_celular								varchar(100),
	@@cont_email  								varchar(255),
	@@cont_direccion							varchar(255),
	@@cont_descrip    						varchar(5000),
	@@cont_cargo  								varchar(100),
  @@cont_categoria              varchar(150),
  @@cont_cliente                varchar(255),
  @@cont_proveedor              varchar(255),
  @@cont_fechanac               datetime,
  @@cont_codpostal              varchar(255),
  @@cont_ciudad                 varchar(255),
  @@cont_provincia              varchar(255),
	@@pa_id                       int,
  @@cont_tipo                   tinyint,
	@@cli_id 											int,
	@@prov_id											int,
  @@pro_id                      int,
  @@ciu_id                      int,
	@@activo                      tinyint,
	@@us_id 											int,
	@@modifico										int,
  @@rtn                   			int out	
)
as

begin

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%contacto%'*/
  exec sp_HistoriaUpdate 2001, @@cont_id, @@us_id, 1

	set nocount on

	set @@cont_apellido 							= IsNull(@@cont_apellido,'')
	set @@cont_nombre									= IsNull(@@cont_nombre,'')
	set @@cont_codigo									= IsNull(@@cont_codigo,'')
	set @@cont_tratamiento						= IsNull(@@cont_tratamiento,'')
	set @@cont_descrip								= IsNull(@@cont_descrip,'')
	set @@cont_telefono								= IsNull(@@cont_telefono,'')
	set @@cont_fax    								= IsNull(@@cont_fax,'')
	set @@cont_celular								= IsNull(@@cont_celular,'')
	set @@cont_email									= IsNull(@@cont_email,'')
	set @@cont_cargo									= IsNull(@@cont_cargo,'')
	set @@cont_categoria  						= IsNull(@@cont_categoria,'')
	set @@cont_cliente    						= IsNull(@@cont_cliente,'')
	set @@cont_proveedor  						= IsNull(@@cont_proveedor,'')
	set @@cont_direccion							= IsNull(@@cont_direccion,'')
	set @@cont_tipo										= IsNull(@@cont_tipo,0)
	set @@cont_fechanac               = IsNull(@@cont_fechanac,'19000101')

	set @@cont_codpostal    					= IsNull(@@cont_codpostal,'')
	set @@cont_ciudad    							= IsNull(@@cont_ciudad,'')
	set @@cont_provincia    					= IsNull(@@cont_provincia,'')

	set @@activo  										= IsNull(@@activo,0)

	if @@cli_id  = 0  	set @@cli_id  = null
	if @@prov_id = 0 	  set @@prov_id = null
	if @@ciu_id  = 0  	set @@ciu_id  = null
	if @@pro_id  = 0 	  set @@pro_id  = null
	if @@us_id   = 0 		set @@us_id   = null

	if @@cont_id = 0 begin

		exec SP_DBGetNewId 'Contacto', 'cont_id', @@cont_id out, 0

		insert into Contacto (
															cont_id,
                              cont_apellido,
															cont_nombre,
															cont_codigo,
                              cont_tratamiento,
															cont_tel,
                              cont_fax,
															cont_celular,
															cont_email,
															cont_cargo,
															cont_direccion,
															cont_tipo,
															cont_descrip,
															cont_fechanac,
                              cont_categoria,
                              cont_cliente,
                              cont_proveedor,
															cont_codpostal,
															cont_ciudad,
															cont_provincia,
                              agn_id,
															cli_id,
															prov_id,
															pa_id,
                              pro_id,
                              ciu_id,
															us_id,
															activo,
															modifico
														)
										values	(
															@@cont_id,
                              @@cont_apellido,
															@@cont_nombre,
															@@cont_codigo,
                              @@cont_tratamiento,
															@@cont_telefono,
															@@cont_fax,
															@@cont_celular,
															@@cont_email,
															@@cont_cargo,
															@@cont_direccion,
															@@cont_tipo,
															@@cont_descrip,
															@@cont_fechanac,
                              @@cont_categoria,
                              @@cont_cliente,
                              @@cont_proveedor,
															@@cont_codpostal,
															@@cont_ciudad,
															@@cont_provincia,
                              @@agn_id,
															@@cli_id,
															@@prov_id,
															@@pa_id,
                              @@pro_id,
                              @@ciu_id,
															@@us_id,
															@@activo,
															@@modifico
														)
		
	end else begin

			update Contacto set
                              cont_apellido   = @@cont_apellido,
															cont_nombre			= @@cont_nombre,
															cont_codigo			= @@cont_codigo,
                              cont_tratamiento= @@cont_tratamiento,
															cont_tel				= @@cont_telefono,
                              cont_fax        = @@cont_fax,
															cont_celular		= @@cont_celular,
															cont_email			= @@cont_email,
															cont_cargo			= @@cont_cargo,
															cont_direccion	= @@cont_direccion,
															cont_tipo				= @@cont_tipo,
															cont_fechanac		= @@cont_fechanac,
															cont_descrip		= @@cont_descrip,
                              cont_categoria  = @@cont_categoria,
                              cont_cliente    = @@cont_cliente,
                              cont_proveedor  = @@cont_proveedor,
															cont_codpostal	= @@cont_codpostal,
															cont_ciudad			= @@cont_ciudad,
															cont_provincia	= @@cont_provincia,
                              agn_id          = @@agn_id,
															cli_id					= @@cli_id,
															prov_id					= @@prov_id,
															pa_id						= @@pa_id,
                              pro_id          = @@pro_id,
                              ciu_id          = @@ciu_id,
															us_id						= @@us_id,
															activo          = @@activo,
															modifico				= @@modifico

			where cont_id = @@cont_id
	end

	set @@rtn = @@cont_id

end

go
