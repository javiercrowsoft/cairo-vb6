
/*---------------------------------------------------------------------
Nombre: Listado de MovimientoFondo agrupado por cliente
---------------------------------------------------------------------*/
/*
DC_CSC_TSR_0100 7, 
                '20000101', 
                '20100101', 
                '0', 
                '0', 
                '0', 
                '0', 
                '0', 
                '0'
select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0100]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0100]

go
create procedure DC_CSC_TSR_0100 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@cli_id varchar(255),
@@doc_id varchar(255),
@@lgj_id  varchar(255),
@@suc_id  varchar(255),
@@est_id  varchar(255), 
@@emp_id  varchar(255)
)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @doc_id int
declare @lgj_id int
declare @suc_id int
declare @est_id int
declare @emp_id   int 

declare @ram_id_cliente int
declare @ram_id_documento int
declare @ram_id_legajo int
declare @ram_id_sucursal int
declare @ram_id_estado int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_documento out
exec sp_ArbConvertId @@lgj_id, @lgj_id out, @ram_id_legajo out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_estado out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_legajo <> 0 begin

--  exec sp_ArbGetGroups @ram_id_legajo, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_legajo, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_legajo, @clienteID 
  end else 
    set @ram_id_legajo = 0
end

if @ram_id_sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_sucursal, @clienteID 
  end else 
    set @ram_id_sucursal = 0
end

if @ram_id_estado <> 0 begin

--  exec sp_ArbGetGroups @ram_id_estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_estado, @clienteID 
  end else 
    set @ram_id_estado = 0
end


if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

        mf_id              as comp_id,
        mf_fecha           as [Fecha],
        mf_numero          as [Numero],
        mf_nrodoc          as [Comprobante],
        cli_nombre         as [Cliente],
        mf_total           as [Total],
        mf_pendiente       as [Pendiente],
        est_nombre         as [Estado],
        doc_nombre         as [Documento],
        emp_nombre         as [Empresa], 
        suc_nombre         as [Sucursal],
        case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
        ccos_nombre        as [Centro de Costo],
        mf_descrip         as [Observaciones]

from 

  MovimientoFondo mf 
                inner join Estado est                             on mf.est_id    = est.est_id
                inner join Documento doc                          on mf.doc_id    = doc.doc_id
                inner join Empresa emp                            on doc.emp_id   = emp.emp_id
                inner join Sucursal suc                           on mf.suc_id    = suc.suc_id
                left  join Cliente cli                             on mf.cli_id     = cli.cli_id
                left  join Legajo lgj                             on mf.lgj_id    = lgj.lgj_id
                left  join CentroCosto ccos                       on mf.ccos_id   = ccos.ccos_id
where 

          @@Fini <= mf_fecha
      and  @@Ffin >= mf_fecha     


      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa 
                   where (      cli_id = cli.cli_id 
                            and  us_id = @@us_id
                          )
                      or cli.cli_id is null
                  ) or (@us_empresaEx = 0)
          )
          
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.cli_id = @cli_id or @cli_id=0)
and   (doc.doc_id = @doc_id or @doc_id=0)
and   (lgj.lgj_id = @lgj_id or @lgj_id=0)
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (est.est_id = @est_id or @est_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cli.cli_id
                 ) 
           )
        or 
           (@ram_id_cliente = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 
                  and  rptarb_hojaid = doc.doc_id
                 ) 
           )
        or 
           (@ram_id_documento = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 15001 
                  and  rptarb_hojaid = lgj.lgj_id
                 ) 
           )
        or 
           (@ram_id_legajo = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = suc.suc_id
                 ) 
           )
        or 
           (@ram_id_sucursal = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = est.est_id
                 ) 
           )
        or 
           (@ram_id_estado = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

order by Fecha

end

GO