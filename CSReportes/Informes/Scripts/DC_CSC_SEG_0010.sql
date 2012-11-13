/*---------------------------------------------------------------------
Nombre: Permisos por usuario
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0010]
/*
	 DC_CSC_SEG_0010 1,'0'
*/
go
create procedure DC_CSC_SEG_0010 (
  @@us_id            int,
  @@us_id_usuario    varchar (255)
)
as 

begin

declare @us_id_usuario int

declare @ram_id_Usuario int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_usuario, @us_id_usuario out, @ram_id_Usuario out
exec sp_GetRptId @clienteID out

if @ram_id_Usuario <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Usuario, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Usuario, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Usuario, @clienteID 
	end else 
		set @ram_id_Usuario = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  select 
      permiso.pre_id,
      us_nombre      as Usuario,
      ''             as Rol,
      pre_nombre     as Prestacion,
      pre_grupo      as [Grupo 1],
      pre_grupo1     as [Grupo 2],
      pre_grupo2     as [Grupo 3],
      pre_grupo3     as [Grupo 4],
      pre_grupo4     as [Grupo 5],
      pre_grupo5     as [Grupo 6],
      convert(varchar(255),'') as Observaciones
      
  from
      permiso inner join prestacion  on permiso.pre_id = prestacion.pre_id
              inner join usuario      on permiso.us_id  = usuario.us_id

  where

          (usuario.us_id = @us_id_usuario or @us_id_usuario=0)
    
    and   (
    					(exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 3 -- tbl_id de Usuario
                      and  rptarb_hojaid = usuario.us_id
    							   ) 
               )
            or 
    					 (@ram_id_Usuario = 0)
    			 )

union all

  select 

      permiso.pre_id,
      us_nombre      as Usuario,
      rol_nombre     as Rol,
      pre_nombre     as Prestacion,
      pre_grupo      as [Grupo 1],
      pre_grupo1     as [Grupo 2],
      pre_grupo2     as [Grupo 3],
      pre_grupo3     as [Grupo 4],
      pre_grupo4     as [Grupo 5],
      pre_grupo5     as [Grupo 6],
      convert(varchar(255),'') as Observaciones
      
  from
      permiso inner join prestacion  on permiso.pre_id   = prestacion.pre_id
              inner join rol         on permiso.rol_id   = rol.rol_id
              inner join usuariorol  on rol.rol_id       = usuariorol.rol_id
              inner join usuario     on usuariorol.us_id = usuario.us_id

  where

          (usuario.us_id = @us_id_usuario or @us_id_usuario=0)
    
    and   (
    					(exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 3 -- tbl_id de Usuario
                      and  rptarb_hojaid = usuario.us_id
    							   ) 
               )
            or 
    					 (@ram_id_Usuario = 0)
    			 )

order by
			us_nombre,
      pre_grupo,
      pre_grupo1,
      pre_grupo2,
      pre_grupo3,
      pre_grupo4,
      pre_grupo5


end
go
