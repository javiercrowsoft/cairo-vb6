/*---------------------------------------------------------------------
  Nombre: Proveedores por Departamento
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0050]

go
create procedure DC_CSC_SEG_0050 (

  @@us_id    int,

@@dpto_id varchar(255),
@@prov_id varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @dpto_id int
declare @prov_id int

declare @ram_id_departamento int
declare @ram_id_proveedor int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_departamento out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out

exec sp_GetRptId @clienteID out

if @ram_id_departamento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_departamento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_departamento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_departamento, @clienteID 
  end else 
    set @ram_id_departamento = 0
end

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

  d.dpto_id,
  dpto_nombre  as Departamento,
  prov_codigo  as Codigo,
  prov_nombre  as Proveedor,
  ''           as Observaciones

from 

    DepartamentoProveedor dprov inner join Departamento d on dprov.dpto_id = d.dpto_id
                                 inner join Proveedor    c on dprov.prov_id = c.prov_id   

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (d.dpto_id = @dpto_id or @dpto_id=0)
and   (c.prov_id = @prov_id or @prov_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1015 -- tbl_id de Proyecto
                  and  rptarb_hojaid = dprov.dpto_id
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
                  and  rptarb_hojaid = dprov.prov_id
                 ) 
           )
        or 
           (@ram_id_proveedor = 0)
       )

GO