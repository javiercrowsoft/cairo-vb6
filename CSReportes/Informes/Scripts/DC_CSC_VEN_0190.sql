/*---------------------------------------------------------------------
Nombre: Listado de ventas por provincia resumido
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_VEN_0190 1, '20050101','20100201','0', '0','0','0','0','0','0'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0190]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0190]

go
create procedure DC_CSC_VEN_0190 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@cli_id           varchar(255),
  @@ven_id           varchar(255),
  @@cico_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@emp_id           varchar(255)

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

declare @pro_id       int
declare @cli_id       int
declare @ven_id       int
declare @cico_id      int
declare @doc_id       int
declare @mon_id       int
declare @emp_id       int

declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_vendedor         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@ven_id,       @ven_id out,        @ram_id_vendedor out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_provincia <> 0 begin

--  exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
  end else 
    set @ram_id_provincia = 0
end

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_vendedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_vendedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_vendedor, @clienteID 
  end else 
    set @ram_id_vendedor = 0
end

if @ram_id_circuitoContable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
  end else 
    set @ram_id_circuitoContable = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_moneda <> 0 begin

--  exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
  end else 
    set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
    IsNull(pro1.pro_id,pro2.pro_id)            as pro_id,
    1                                         as orden_id,
    IsNull(pro1.pro_codigo,pro2.pro_codigo)    as Codigo,
    IsNull(IsNull(pro1.pro_nombre,pro2.pro_nombre)
            ,'Clientes sin provincia')         as Provincia,

    sum(case doc.doct_id
          when 7  then -fv_neto
          else          fv_neto
        end
        )                   as Neto,

    sum(case doc.doct_id
          when 7  then -(fv_ivari+fv_ivarni)
          else          fv_ivari+fv_ivarni
        end
        )                   as IVA,
    0                       as [Otros Impuestos],
    sum(case doc.doct_id
          when 7  then -fv_total
          else          fv_total
        end
        )            as Total

from 

  facturaventa fv inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                  inner join documento doc         on fv.doc_id   = doc.doc_id
                  inner join moneda    mon         on fv.mon_id   = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

                   left join provincia   pro1       on cli.pro_id        = pro1.pro_id
                   left join provincia   pro2       on fv.pro_id_destino = pro2.pro_id
where 

          fv_fecha >= @@Fini
      and  fv_fecha <= @@Ffin 

      and fv.est_id <> 7 -- Anuladas

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
       and (
                exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (    fv.pro_id_destino  = @pro_id 
       or  cli.pro_id         = @pro_id   
                                or @pro_id=0)
and   (fv.cli_id     = @cli_id   or @cli_id=0)
and   (cli.ven_id   = @ven_id   or @ven_id=0)
and   (doc.cico_id   = @cico_id   or @cico_id=0)
and   (fv.doc_id     = @doc_id   or @doc_id=0)
and   (fv.mon_id     = @mon_id   or @mon_id=0)
and   (doc.emp_id   = @emp_id   or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 
                  and  (rptarb_hojaid = cli.pro_id or rptarb_hojaid = fv.pro_id_destino)
                 ) 
           )
        or 
           (@ram_id_provincia = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = fv.cli_id
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
                  and  tbl_id = 15 
                  and  rptarb_hojaid = cli.ven_id
                 ) 
           )
        or 
           (@ram_id_vendedor = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = doc.cico_id
                 ) 
           )
        or 
           (@ram_id_circuitoContable = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 
                  and  rptarb_hojaid = fv.doc_id
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
                  and  tbl_id = 12 
                  and  rptarb_hojaid = fv.mon_id
                 ) 
           )
        or 
           (@ram_id_moneda = 0)
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
           (@ram_id_empresa = 0)
       )

group by 
    IsNull(pro1.pro_id,pro2.pro_id),
    IsNull(pro1.pro_codigo,pro2.pro_codigo),
    IsNull(IsNull(pro1.pro_nombre,pro2.pro_nombre)
            ,'Clientes sin provincia')

end
go

