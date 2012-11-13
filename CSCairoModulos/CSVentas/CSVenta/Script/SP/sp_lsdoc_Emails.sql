/*


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Emails]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Emails]
go

/*

sp_lsdoc_Emails 1,'20090101','20091231','0','0','0','0','0'

*/

create procedure sp_lsdoc_Emails (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id  	varchar(255),
@@est_id		varchar(255),
@@cmi_id		varchar(255),
@@cmia_id		varchar(255),
@@cmiea_id	varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id 	int
declare @cmi_id 	int
declare @cmia_id	int
declare @est_id 	int
declare @cmiea_id int

declare @ram_id_Cliente int
declare @ram_id_ComunidadInternet int
declare @ram_id_ComunidadInternetAplicacion int
declare @ram_id_Estado int
declare @ram_id_ComunidadInternetEmailAccount int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@cmi_id, @cmi_id out, @ram_id_ComunidadInternet out
exec sp_ArbConvertId @@cmia_id, @cmia_id out, @ram_id_ComunidadInternetAplicacion out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@cmiea_id, @cmiea_id out, @ram_id_ComunidadInternetEmailAccount out

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
	end else 
		set @ram_id_Cliente = 0
end

if @ram_id_ComunidadInternet <> 0 begin

--	exec sp_ArbGetGroups @ram_id_ComunidadInternet, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_ComunidadInternet, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_ComunidadInternet, @clienteID 
	end else 
		set @ram_id_ComunidadInternet = 0
end

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
	end else 
		set @ram_id_Estado = 0
end

if @ram_id_ComunidadInternetAplicacion <> 0 begin

--	exec sp_ArbGetGroups @ram_id_ComunidadInternetAplicacion, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_ComunidadInternetAplicacion, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_ComunidadInternetAplicacion, @clienteID 
	end else 
		set @ram_id_ComunidadInternetAplicacion = 0
end

if @ram_id_ComunidadInternetEmailAccount <> 0 begin

--	exec sp_ArbGetGroups @ram_id_ComunidadInternetEmailAccount, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_ComunidadInternetEmailAccount, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_ComunidadInternetEmailAccount, @clienteID 
	end else 
		set @ram_id_ComunidadInternetEmailAccount = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns Facturaventa


select 
			cmie.cmie_id,
			''									  	as [TypeTask],
	    cli_nombre            	as [Cliente],
	    est_nombre					  	as [Estado],
			cmie_date 						  as [Fecha],
	    cmi_nombre					    as [Comunidad],
      cmia_nombre					    as [Aplicacion],
      cmiea_nombre					  as [Cuenta de Correo],

			case when cmir.cmir_id is not null then 'Si'
					 else                               'No'
      end                     as [Respondido],
			cmie.Creado,
			''											as [Observaciones]
from 
			ComunidadInternetMail cmie
 
									 left  join estado est     												on cmie.est_id 	 = est.est_id
                   left  join ComunidadInternet cmi   							on cmie.cmi_id   = cmi.cmi_id
                   left  join ComunidadInternetEmailAccount cmiea   on cmie.cmiea_id = cmiea.cmiea_id
                   left  join cliente cli      											on cmie.cli_id   = cli.cli_id
									 left  join ComunidadInternetRespuesta cmir				on cmie.cmie_id  = cmir.cmie_id
									 left  join ComunidadInternetAplicacion cmia 			on cmir.cmia_id  = cmia.cmia_id

where 

				  @@Fini <= cmie_date
			and	@@Ffin >= cmie_date 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cmie.cli_id = @cli_id or @cli_id=0)
and   (cmie.est_id = @est_id or @est_id=0)
and   (cmir.cmia_id = @cmia_id or @cmia_id=0)
and   (cmie.cmi_id = @cmi_id or @cmi_id=0)
and   (cmie.cmiea_id = @cmiea_id or @cmiea_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cmie.cli_id
							   ) 
           )
        or 
					 (@ram_id_Cliente = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 
                  and  rptarb_hojaid = cmie.cmi_id
							   ) 
           )
        or 
					 (@ram_id_ComunidadInternet = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = cmie.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = cmir.cmia_id
							   ) 
           )
        or 
					 (@ram_id_ComunidadInternetAplicacion = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 15 
                  and  rptarb_hojaid = cmie.cmiea_id
							   ) 
           )
        or 
					 (@ram_id_ComunidadInternetEmailAccount = 0)
			 )

	order by cmie_date
go