/*---------------------------------------------------------------------
  Nombre: Clientes por Departamento
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0040]

go
create procedure DC_CSC_SEG_0040 (

  @@us_id    int,

@@dpto_id varchar(255),
@@cli_id varchar(255)

)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @dpto_id int
declare @cli_id int

declare @ram_id_departamento int
declare @ram_id_cliente int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_departamento out
exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out

exec sp_GetRptId @clienteID out

if @ram_id_departamento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_departamento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_departamento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_departamento, @clienteID 
	end else 
		set @ram_id_departamento = 0
end

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

  d.dpto_id,
  dpto_nombre as Departamento,
  cli_codigo  as Codigo,
  cli_nombre  as Cliente,
  ''          as Observaciones

from 

    DepartamentoCliente dcli inner join Departamento d on dcli.dpto_id = d.dpto_id
                             inner join Cliente      c on dcli.cli_id  = c.cli_id   

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (d.dpto_id = @dpto_id or @dpto_id=0)
and   (c.cli_id = @cli_id or @cli_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1015 -- tbl_id de Proyecto
                  and  rptarb_hojaid = dcli.dpto_id
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
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = dcli.cli_id
							   ) 
           )
        or 
					 (@ram_id_cliente = 0)
			 )

GO