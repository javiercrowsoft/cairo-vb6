/*---------------------------------------------------------------------
  Nombre: Listado de Usuarios x Departamento hasta 15 niveles
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0030]

go

/*
DC_CSC_SEG_0030 1,0,0,0
*/
create procedure DC_CSC_SEG_0030 (

  @@us_id    int,

@@dpto_id       varchar(255),
@@us_id_usuario varchar(255),
@@prs_id        varchar(255)

)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @dpto_id   int
declare @us_id     int
declare @prs_id    int

declare @ram_id_departamento  int
declare @ram_id_usuario       int
declare @ram_id_persona       int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_departamento out
exec sp_ArbConvertId @@us_id_usuario, @us_id out, @ram_id_usuario out
exec sp_ArbConvertId @@prs_id, @prs_id out, @ram_id_persona out

exec sp_GetRptId @clienteID out

if @ram_id_departamento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_departamento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_departamento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_departamento, @clienteID 
  end else 
    set @ram_id_departamento = 0
end

if @ram_id_usuario <> 0 begin

--  exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
  end else 
    set @ram_id_Usuario = 0
end

if @ram_id_persona <> 0 begin

--  exec sp_ArbGetGroups @ram_id_persona, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_persona, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_persona, @clienteID 
  end else 
    set @ram_id_persona = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
      p.prs_id,
      d03.dpto_nombre as Division,
      d02.dpto_nombre as Departamento,
      d01.dpto_nombre as Sector, 
      us_nombre       as Usuario,
      prs_apellido + ', ' 
      + prs_nombre    as Persona,
      d.dpto_nombre   as [Persona Sector],
      d2.dpto_nombre  as [Persona Departamento],
      d04.dpto_nombre as dpto4,
      d05.dpto_nombre as dpto5,
      d06.dpto_nombre as dpto6,
      d07.dpto_nombre as dpto7,
      d08.dpto_nombre as dpto8,
      d09.dpto_nombre as dpto9,
      d10.dpto_nombre as dpto10,
      d11.dpto_nombre as dpto11,
      d12.dpto_nombre as dpto12,
      d13.dpto_nombre as dpto13,
      d14.dpto_nombre as dpto14,
      d15.dpto_nombre as dpto15,
      ''              as Observaciones

 from persona p left join  Usuario u                   on p.prs_id          = u.prs_id   
                left join  usuariodepartamento dus     on u.us_id           = dus.us_id
                left join  departamento d              on dus.dpto_id       = d.dpto_id
                left join  departamento d2             on d.dpto_id_padre   = d2.dpto_id
                left join  departamento d01            on p.dpto_id         = d01.dpto_id
                left join  departamento d02            on d01.dpto_id_padre = d02.dpto_id
                left join  departamento d03            on d02.dpto_id_padre = d03.dpto_id
                left join  departamento d04            on d03.dpto_id_padre = d04.dpto_id
                left join  departamento d05            on d04.dpto_id_padre = d05.dpto_id
                left join  departamento d06            on d05.dpto_id_padre = d06.dpto_id
                left join  departamento d07            on d06.dpto_id_padre = d07.dpto_id
                left join  departamento d08            on d07.dpto_id_padre = d08.dpto_id
                left join  departamento d09            on d08.dpto_id_padre = d09.dpto_id
                left join  departamento d10            on d09.dpto_id_padre = d10.dpto_id
                left join  departamento d11            on d10.dpto_id_padre = d11.dpto_id
                left join  departamento d12            on d11.dpto_id_padre = d12.dpto_id
                left join  departamento d13            on d12.dpto_id_padre = d13.dpto_id
                left join  departamento d14            on d13.dpto_id_padre = d14.dpto_id
                left join  departamento d15            on d14.dpto_id_padre = d15.dpto_id

where                           
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (d.dpto_id = @dpto_id or @dpto_id=0)
and   (u.us_id = @us_id or @us_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1015 -- tbl_id de Proyecto
                  and  rptarb_hojaid = dus.dpto_id
                 ) 
           )
        or 
           (@ram_id_departamento = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- tbl_id de Proyecto
                  and  rptarb_hojaid = dus.us_id
                 ) 
           )
        or 
           (@ram_id_usuario = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1019 -- tbl_id de Proyecto
                  and  rptarb_hojaid = p.prs_id
                 ) 
           )
        or 
           (@ram_id_usuario = 0)
       )

order by prs_apellido, prs_nombre, us_nombre

GO