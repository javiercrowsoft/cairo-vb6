/*---------------------------------------------------------------------
Nombre: Facturas a Cobrar
---------------------------------------------------------------------*/
/*

Para testear:

DC_CSC_VEN_0015 
                    1,
                    '20050601',
                    '20051231',
                    '0',
                    '0',
                    '0',
                    '0',
                    '0',
                    '0',
                    '0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0015]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0015]

go
create procedure DC_CSC_VEN_0015 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cli_id          varchar(255),
  @@ven_id          varchar(255),
  @@suc_id          varchar(255),
  @@cico_id          varchar(255),
  @@cue_id          varchar(255), 
  @@soloDeudores     smallint,
  @@emp_id          varchar(255)

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

declare @cli_id   int
declare @ven_id   int
declare @suc_id   int
declare @cico_id  int
declare @cue_id   int
declare @emp_id   int 

declare @ram_id_Cliente           int
declare @ram_id_Vendedor           int
declare @ram_id_Sucursal           int
declare @ram_id_circuitoContable   int
declare @ram_id_Cuenta             int
declare @ram_id_Empresa           int 

declare @clienteID int
declare @IsRaiz    tinyint


exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_Vendedor out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitoContable out
exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_Cuenta out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
  end else 
    set @ram_id_Cliente = 0
end

if @ram_id_Vendedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Vendedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Vendedor, @clienteID 
  end else 
    set @ram_id_Vendedor = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_Cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cuenta, @clienteID 
  end else 
    set @ram_id_Cuenta = 0
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

declare @cta_deudor tinyint set @cta_deudor = 1

create table #tbl_DC_CSC_VEN_0015 (
        cli_nombre         varchar(255),
        mon_nombre         varchar(255),
        est_nombre         varchar(255),
        cue_nombre         varchar(255),
        doc_nombre         varchar(255),
        emp_nombre         varchar(255), 
        suc_nombre         varchar(255),
        cli_contacto       varchar(255),
        ven_nombre         varchar(255),
        cpg_nombre         varchar(255),
        ccos_nombre        varchar(255),

        fv_neto             decimal(18,6),
        fv_desc             decimal(18,6),
        fv_subtotal         decimal(18,6),
        fv_iva                decimal(18,6),
        fv_total            decimal(18,6),
        fv_pendiente        decimal(18,6)
)

insert into #tbl_DC_CSC_VEN_0015

select 
        cli_nombre         as [Cliente],
        mon_nombre         as [Moneda],
        est_nombre         as [Estado],
        cue_nombre         as [Cuenta],
        doc_nombre         as [Documento],
        emp_nombre         as [Empresa], 
        suc_nombre         as [Sucursal],
        cli_contacto       as [Contacto],
        isnull
         (ven.ven_nombre,
          ven2.ven_nombre) as [Vendedor],
        cpg_nombre         as [Cond. Pago],
        ccos_nombre        as [Centro de Costo],


        case fv.doct_id
          when 7     then -sum(fv_neto)
          else            sum(fv_neto)
        end                                         as [Neto],
        case fv.doct_id
          when 7     then -sum(  fv_importedesc1 
                              + fv_importedesc2)    
          else            sum(  fv_importedesc1 
                              + fv_importedesc2)    
        end                                        as [Descuento],
        case fv.doct_id
          when 7     then -sum(fv_subtotal)
          else            sum(fv_subtotal)
        end                                        as [Sub Total],
        case fv.doct_id
          when 7     then -sum(  fv_ivari 
                              + fv_ivarni)
          else            sum(  fv_ivari 
                              + fv_ivarni)
        end                                         as [Iva],
        case fv.doct_id
          when 7     then -sum(fv_total)
          else            sum(fv_total)
        end                                         as [Total],
        case fv.doct_id
          when 7     then -sum(fv_pendiente)
          else            sum(fv_pendiente)
        end                                         as [Pendiente]

from 

  FacturaVenta fv inner join Cliente               cli                    on fv.cli_id     = cli.cli_id
                  left  join FacturaVentaDeuda     fvd                   on fv.fv_id      = fvd.fv_id
                  left  join FacturaVentaPago     fvp                   on fv.fv_id      = fvp.fv_id
                  inner join AsientoItem           ai                    on fv.as_id     = ai.as_id and asi_tipo = @cta_deudor
                  inner join Cuenta               cue                   on ai.cue_id    = cue.cue_id
                  inner join Moneda               mon                   on fv.mon_id    = mon.mon_id
                  inner join Estado               est                   on fv.est_id    = est.est_id
                  inner join Documento             doc                   on fv.doc_id    = doc.doc_id
                  inner join Empresa              emp                   on doc.emp_id   = emp.emp_id 
                  inner join Sucursal             suc                   on fv.suc_id    = suc.suc_id
                  left  join Vendedor             ven                   on fv.ven_id    = ven.ven_id
                  left  join Vendedor              ven2                  on cli.ven_id   = ven2.ven_id
                  left  join Legajo               lgj                   on fv.lgj_id    = lgj.lgj_id
                  inner join CondicionPago         cpg                   on fv.cpg_id    = cpg.cpg_id
                  left  join CentroCosto           ccos                  on fv.ccos_id   = ccos.ccos_id
where 

          fv_fecha >= @@Fini
      and  fv_fecha <= @@Ffin

      and fv.est_id <> 7 -- Sin anuladas

      and (isnull(fvd_pendiente,0) <> 0 or @@soloDeudores = 0)

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
       and (
            exists(select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.cli_id = @cli_id or @cli_id=0)
and   (
          (      fv.ven_id = @ven_id 
            or (    cli.ven_id = @ven_id 
                and fv.ven_id is null
                )
          )
        or @ven_id=0
      )
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (cue.cue_id = @cue_id or @cue_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cli.cli_id
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
                  and  tbl_id = 15 
                  and  rptarb_hojaid = ven.ven_id
                 ) 
           )
        or 
           (@ram_id_Vendedor = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = suc.suc_id
                 ) 
           )
        or 
           (@ram_id_Sucursal = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 -- tbl_id de Proyecto
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
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cue.cue_id
                 ) 
           )
        or 
           (@ram_id_Cuenta = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by 
        cli_nombre,
        mon_nombre,
        est_nombre,
        cue_nombre,
        doc_nombre,
        emp_nombre,
        suc_nombre,
        cli_contacto,
        isnull(ven.ven_nombre,ven2.ven_nombre),
        cpg_nombre,
        ccos_nombre,
        fv.doct_id

-------------------------------------------------------------------------------------------------------------------------
-- cliente: brutas - pendientes - iva
-------------------------------------------------------------------------------------------------------------------------
select 
        1                    as grupo,
        cli_nombre          as [Item],

        sum(fv_neto)         as [Neto],
        sum(fv_desc)         as [Descuento],
        sum(fv_subtotal)     as [Sub Total],
        sum(fv_iva)          as [Iva],
        sum(fv_total)        as [Total],
        sum(fv_pendiente)    as [Pendiente]

from #tbl_DC_CSC_VEN_0015

group by 

        cli_nombre

union all

-------------------------------------------------------------------------------------------------------------------------
-- vendedores
-------------------------------------------------------------------------------------------------------------------------
select 
        2                    as grupo,
        ven_nombre          as [Item],

        sum(fv_neto)         as [Neto],
        sum(fv_desc)         as [Descuento],
        sum(fv_subtotal)     as [Sub Total],
        sum(fv_iva)          as [Iva],
        sum(fv_total)        as [Total],
        sum(fv_pendiente)    as [Pendiente]

from #tbl_DC_CSC_VEN_0015

group by 

        ven_nombre

union all

-------------------------------------------------------------------------------------------------------------------------
-- condiciones de pago
-------------------------------------------------------------------------------------------------------------------------
select 
        3                    as grupo,
        cpg_nombre           as [Item],

        sum(fv_neto)         as [Neto],
        sum(fv_desc)         as [Descuento],
        sum(fv_subtotal)     as [Sub Total],
        sum(fv_iva)          as [Iva],
        sum(fv_total)        as [Total],
        sum(fv_pendiente)    as [Pendiente]

from #tbl_DC_CSC_VEN_0015

group by 

        cpg_nombre

union all

-------------------------------------------------------------------------------------------------------------------------
-- contacto
-------------------------------------------------------------------------------------------------------------------------
select 
        4                    as grupo,
        cli_contacto         as [Item],

        sum(fv_neto)         as [Neto],
        sum(fv_desc)         as [Descuento],
        sum(fv_subtotal)     as [Sub Total],
        sum(fv_iva)          as [Iva],
        sum(fv_total)        as [Total],
        sum(fv_pendiente)    as [Pendiente]

from #tbl_DC_CSC_VEN_0015

group by 

        cli_contacto

end
go