/*---------------------------------------------------------------------
  Nombre: Usuarios por Departamento
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0030]

go

/*
DC_CSC_SEG_0030 1,1,1,1
*/
create procedure DC_CSC_SEG_0030 (

  @@us_id    int,

@@dpto_id 			varchar(255),
@@us_id_usuario varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @dpto_id int
declare @us_id int

declare @ram_id_departamento int
declare @ram_id_usuario int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_departamento out
exec sp_ArbConvertId @@us_id_usuario, @us_id out, @ram_id_usuario out

exec sp_GetRptId @clienteID out

if @ram_id_departamento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_departamento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_departamento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_departamento, @clienteID 
	end else 
		set @ram_id_departamento = 0
end

if @ram_id_usuario <> 0 begin

--	exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
	end else 
		set @ram_id_Usuario = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

  d.dpto_id,
  dpto_nombre  as Departamento,
  us_nombre    as Usuario,
  ''           as Observaciones

from 

    UsuarioDepartamento dus inner join Departamento d on dus.dpto_id = d.dpto_id
                            inner join Usuario      c on dus.us_id  = c.us_id   

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (d.dpto_id = @dpto_id or @dpto_id=0)
and   (c.us_id = @us_id or @us_id=0)

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
                  and  tbl_id = 1019 -- tbl_id de Proyecto
                  and  rptarb_hojaid = dus.us_id
							   ) 
           )
        or 
					 (@ram_id_usuario = 0)
			 )

GO