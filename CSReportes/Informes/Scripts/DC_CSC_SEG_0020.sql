/*---------------------------------------------------------------------
Nombre: Permisos por rol
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0020]
/* 
 DC_CSC_SEG_0020 1,'0'
*/
go
create procedure DC_CSC_SEG_0020 (
  @@us_id            int,
  @@rol_id           varchar (255)
)
as 

begin

declare @rol_id int

declare @ram_id_Rol int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@rol_id, @rol_id out, @ram_id_Rol out
exec sp_GetRptId @clienteID out

if @ram_id_Rol <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Rol, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Rol, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Rol, @clienteID 
  end else 
    set @ram_id_Rol = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  select 
      1                as grupo,
      'Permisos'       as Tipo,
      rol_nombre       as Rol,
      ''               as Usuario,
      pre_nombre       as Prestacion,
      pre_grupo        as [Grupo 1],
      pre_grupo1       as [Grupo 2],
      pre_grupo2       as [Grupo 3],
      pre_grupo3       as [Grupo 4],
      pre_grupo4       as [Grupo 5],
      pre_grupo5       as [Grupo 6],
      convert(varchar(255),'') as Observaciones
      
  from
      permiso inner join prestacion  on permiso.pre_id   = prestacion.pre_id
              inner join rol         on permiso.rol_id   = rol.rol_id

  where

          (rol.rol_id = @rol_id or @rol_id=0)
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 2 
                      and  rptarb_hojaid = rol.rol_id
                     ) 
               )
            or 
               (@ram_id_Rol = 0)
           )

union all

  select 
      2 as grupo,
      'Usuarios'       as Tipo,
      rol_nombre       as Rol,
      us_nombre        as Usuario,
      ''               as Prestacion,
      ''               as [Grupo 1],
      ''               as [Grupo 2],
      ''               as [Grupo 3],
      ''               as [Grupo 4],
      ''               as [Grupo 5],
      ''               as [Grupo 6],
      convert(varchar(255),'') as Observaciones
      
  from rol r inner join usuariorol ur on r.rol_id   = ur.rol_id
             inner join usuario u on ur.us_id = u.us_id

  where

          (r.rol_id = @rol_id or @rol_id=0)
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 2 
                      and  rptarb_hojaid = r.rol_id
                     ) 
               )
            or 
               (@ram_id_Rol = 0)
           )

order by
      grupo,
      rol_nombre,
      pre_grupo,
      pre_grupo1,
      pre_grupo2,
      pre_grupo3,
      pre_grupo4,
      pre_grupo5


end
go
