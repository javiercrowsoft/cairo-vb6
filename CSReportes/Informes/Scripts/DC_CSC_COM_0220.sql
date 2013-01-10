/*---------------------------------------------------------------------
Nombre: Cuenta Corriente de Compras
---------------------------------------------------------------------*/
/*  

[DC_CSC_COM_0220] 1,'20060401 00:00:00','20060430 00:00:00','0','','0','0','0','0','0','0',0,'0','0','0'

*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0220]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0220]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure DC_CSC_COM_0220 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@prov_id         varchar(255),
  @@cico_id           varchar(255),
  @@ccos_id           varchar(255),
  @@cpg_id           varchar(255),
  @@lp_id             varchar(255),
  @@ld_id             varchar(255),
  @@suc_id           varchar(255),
  @@doct_id           int,
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
declare @prov_id       int
declare @cico_id      int
declare @doc_id       int
declare @mon_id       int
declare @emp_id       int

declare @ccos_id      int
declare @cpg_id        int
declare @lp_id        int
declare @ld_id        int
declare @suc_id        int

declare @ram_id_provincia        int
declare @ram_id_proveedor        int
declare @ram_id_vendedor         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_centroCosto      int
declare @ram_id_centroCostoItem  int
declare @ram_id_condicionPago    int
declare @ram_id_listaPrecio      int
declare @ram_id_listaDescuento   int
declare @ram_id_sucursal         int
declare @mon_default             int

select @mon_default = mon_id from moneda where mon_legal <> 0

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out
exec sp_ArbConvertId @@ccos_id,      @ccos_id out,       @ram_id_centroCosto out
exec sp_ArbConvertId @@cpg_id,        @cpg_id out,       @ram_id_condicionPago out
exec sp_ArbConvertId @@lp_id,        @lp_id out,         @ram_id_listaPrecio out
exec sp_ArbConvertId @@ld_id,        @ld_id out,         @ram_id_listaDescuento out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_sucursal out

exec sp_GetRptId @clienteID out

if @ram_id_provincia <> 0 begin

--  exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
  end else 
    set @ram_id_provincia = 0
end

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
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

if @ram_id_centroCosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centroCosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centroCosto, @clienteID 
  end else 
    set @ram_id_centroCosto = 0
end

if @ram_id_condicionPago <> 0 begin

--  exec sp_ArbGetGroups @ram_id_condicionPago, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_condicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_condicionPago, @clienteID 
  end else 
    set @ram_id_condicionPago = 0
end

if @ram_id_listaPrecio <> 0 begin

--  exec sp_ArbGetGroups @ram_id_listaPrecio, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_listaPrecio, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_listaPrecio, @clienteID 
  end else 
    set @ram_id_listaPrecio = 0
end

if @ram_id_listaDescuento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_listaDescuento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_listaPrecio, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_listaDescuento, @clienteID 
  end else 
    set @ram_id_listaDescuento = 0
end

if @ram_id_sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_sucursal, @clienteID 
  end else 
    set @ram_id_sucursal = 0
end


/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
--
-- IMPORTE ORIGEN DE OrdenPagoS
--
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

    create table #t_DC_CSC_COM_0220 (opg_id int, origen decimal(18,6))

    insert into #t_DC_CSC_COM_0220(opg_id, origen)

    select 
            opg.opg_id, 
            sum(opgi_importeorigen * (opg_pendiente / opg_total))

    from
      OrdenPago opg inner join OrdenPagoItem opgi  on opg.opg_id    = opgi.opg_id
                    inner join Proveedor prov      on prov.prov_id = opg.prov_id
                    inner join documento doc       on doc.doc_id    = opg.doc_id
    
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
                      left join centroCosto ccos       on opg.ccos_id = ccos.ccos_id
                       left join provincia   pro        on prov.pro_id = pro.pro_id    
    where 
    
              opg_fecha >= @@Fini
          and  opg_fecha <= @@Ffin 

          and round(opg.opg_pendiente,2) > 0
    
          and opgi_tipo <> 5

          and opg.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where prov_id = opg.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )
              
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (prov.pro_id   = @pro_id   or @pro_id  =0)
    and   (opg.prov_id   = @prov_id   or @prov_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (opg.doc_id   = @doc_id   or @doc_id  =0)
    and   (opg.emp_id   = @emp_id   or @emp_id  =0)
    and   (opg.ccos_id  = @ccos_id   or @ccos_id  =0)
    and   (opg.suc_id   = @suc_id   or @suc_id  =0)
    
    -- Arboles
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 6    and rptarb_hojaid = prov.pro_id))  or (@ram_id_provincia = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 29   and rptarb_hojaid = opg.prov_id))  or (@ram_id_proveedor = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = doc.cico_id))  or (@ram_id_circuitoContable = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 4001 and rptarb_hojaid = opg.doc_id))   or (@ram_id_documento = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = opg.emp_id))   or (@ram_id_empresa = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 21   and rptarb_hojaid = opg.ccos_id))  or (@ram_id_centroCosto = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1007 and rptarb_hojaid = opg.suc_id))   or (@ram_id_sucursal = 0))

    group by opg.opg_id

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------
--
-- FACTURAS DE COMPRAS DEL INFORME
--
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

create table #t_fc_DC_CSC_COM_0220 (fc_id int not null)

    insert into #t_fc_DC_CSC_COM_0220 (fc_id)

    select distinct
      fc.fc_id

    from 

      FacturaCompra fc inner join documento doc  on fc.doc_id  = doc.doc_id
                       inner join Proveedor prov on fc.prov_id = prov.prov_id

                       inner join FacturaCompraDeuda fcd on fc.fc_id = fcd.fc_id

    where 
    
              fcd_fecha >= @@Fini
          and  fcd_fecha <= @@Ffin 
    
          and fc.est_id <> 7

          and round(fc.fc_pendiente,2) > 0
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (prov.pro_id = @pro_id  or @pro_id =0)
    and   (fc.prov_id  = @prov_id or @prov_id=0)
    and   (doc.cico_id = @cico_id or @cico_id=0)
    and   (fc.doc_id   = @doc_id  or @doc_id =0)
    and   (fc.mon_id   = @mon_id  or @mon_id =0)
    and   (doc.emp_id  = @emp_id  or @emp_id =0)
    
    and   (fc.ccos_id = @ccos_id or @ccos_id=0)
    and   (fc.cpg_id  = @cpg_id  or @cpg_id=0)
    and   (fc.lp_id   = @lp_id   or @lp_id=0)
    
    and   (fc.ld_id  = @ld_id  or @ld_id=0)
    and   (fc.suc_id = @suc_id or @suc_id=0)
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 6 
                      and  rptarb_hojaid = prov.pro_id
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
                      and  tbl_id = 29 
                      and  rptarb_hojaid = fc.prov_id
                     ) 
               )
            or 
               (@ram_id_proveedor = 0)
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
                      and  rptarb_hojaid = fc.doc_id
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
                      and  rptarb_hojaid = fc.mon_id
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
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = fc.ccos_id
                     ) 
               )
            or 
               (@ram_id_centroCosto = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1005 
                      and  rptarb_hojaid = fc.cpg_id
                     ) 
               )
            or 
               (@ram_id_condicionPago = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 27 
                      and  rptarb_hojaid = fc.lp_id
                     ) 
               )
            or 
               (@ram_id_listaPrecio = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1006 
                      and  rptarb_hojaid = fc.ld_id
                     ) 
               )
            or 
               (@ram_id_listaDescuento = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1007 
                      and  rptarb_hojaid = fc.suc_id
                     ) 
               )
            or 
               (@ram_id_sucursal = 0)
           )

/*- ///////////////////////////////////////////////////////////////////////

FACTURAS, NC Y ND DE CONTADO

/////////////////////////////////////////////////////////////////////// */

    select 
      fc_id        as comp_id,
      fc.doct_id   as doct_id,
      1            as orden_id,  
      emp_nombre   as Empresa,
      prov_nombre   as Proveedor,

      prov_tel              as Telefono,
      prov_fax            as Fax,
      prov_email          as Email,
      prov_calle          as Calle,
      prov_callenumero    as Calle_nro,
      prov_piso           as Piso,
      prov_depto          as Dpto,
      pro_nombre          as Provincia,

                          'te.: ' +
      prov_tel           + ' - email: ' +
      prov_email         + ' - dir.: ' +
      prov_calle         + ' ' +
      prov_callenumero  + ' - piso: ' +
      prov_piso          + ' ' +
      prov_depto       as Direccion,

      fc_fecha     as Fecha,
      fc_fecha     as [Vto.],
      convert(datetime,
              convert(varchar,year(fc_fecha))
                 + '-' + 
              convert(varchar,month(fc_fecha))
                 + '-01'
              )     as Mes,

      doc_nombre   as Documento,
      fc_nrodoc    as NroDoc,
      cpg_nombre   as [Cond. Pago],

      fc_totalcomercial as Total,

      case 
        when fc.mon_id <> @mon_default and fc.doct_id = 8  then  -fc_pendiente / fc_cotizacion
        when fc.mon_id <> @mon_default and fc.doct_id <> 8 then   fc_pendiente / fc_cotizacion
        else                                  0
      end           as Origen,

      case 
        when fc.doct_id = 8  then    0
        else                          fc_pendiente
      end          as Debe,
      case 
        when fc.doct_id = 8  then    fc_pendiente
        else                          0
      end          as Haber,
      case 
        when fc.doct_id = 8  then    -fc_pendiente
        else                          +fc_pendiente
      end          as Saldo,
      fc_descrip   as Observaciones
    
    from 
      FacturaCompra fc inner join condicionPago    cpg  on fc.cpg_id   = cpg.cpg_id 
                                                        and cpg_escontado <> 0
    
                      inner join proveedor         prov on fc.prov_id  = prov.prov_id
                      inner join documento         doc  on fc.doc_id   = doc.doc_id
                      inner join moneda            mon  on fc.mon_id   = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa           emp  on doc.emp_id  = emp.emp_id
    
                      left join centroCosto       ccos on fc.ccos_id = ccos.ccos_id
                       left join provincia         pro  on prov.pro_id  = pro.pro_id
    where 
    
      exists (select fc_id from #t_fc_DC_CSC_COM_0220 where fc_id = fc.fc_id)
    
    ------------------------------------------------------------------
    union all
    ------------------------------------------------------------------

/*- ///////////////////////////////////////////////////////////////////////

DEUDA (VENCIMIENTOS SIN PAGAR) DE FACTURAS, NC Y ND

/////////////////////////////////////////////////////////////////////// */
    
    select 
      fc.fc_id     as comp_id,
      fc.doct_id   as doct_id,
      1            as orden_id,  
      emp_nombre   as Empresa,
      prov_nombre   as Proveedor,

      prov_tel              as Telefono,
      prov_fax            as Fax,
      prov_email          as Email,
      prov_calle          as Calle,
      prov_callenumero    as Calle_nro,
      prov_piso          as Piso,
      prov_depto          as Dpto,
      pro_nombre        as Provincia,

                        'te.: ' +
      prov_tel         + ' - email: ' +
      prov_email       + ' - dir.: ' +
      prov_calle       + ' ' +
      prov_callenumero  + ' - piso: ' +
      prov_piso        + ' ' +
      prov_depto       as Direccion,

      fc_fecha     as Fecha,
      fcd_fecha     as [Vto.],
      convert(datetime,
              convert(varchar,year(fcd_fecha))
                 + '-' +
              convert(varchar,month(fcd_fecha))
                 + '-01'
              )     as Mes,
      doc_nombre   as Documento,
      fc_nrodoc    as NroDoc,
      cpg_nombre   as [Cond. Pago],

      fc_totalcomercial as Total,

      case 
        when fc.mon_id <> @mon_default and fc.doct_id = 8  then  -fcd_pendiente / fc_cotizacion
        when fc.mon_id <> @mon_default and fc.doct_id <> 8 then   fcd_pendiente / fc_cotizacion
        else                                  0
      end           as Origen,

      case 
        when fc.doct_id = 8  then    0
        else                          fcd_pendiente
      end          as Debe,
      case 
        when fc.doct_id = 8  then    fcd_pendiente
        else                          0
      end          as Haber,
      case 
        when fc.doct_id = 8  then    -fc_pendiente
        else                          +fc_pendiente
      end          as Saldo,
      fc_descrip   as Observaciones
    
    from 
      FacturaCompra fc inner join condicionPago    cpg  on fc.cpg_id    = cpg.cpg_id 
                                                      and cpg_escontado = 0
    
                      inner join proveedor         prov on fc.prov_id  = prov.prov_id
                      inner join documento         doc  on fc.doc_id   = doc.doc_id
                      inner join moneda            mon  on fc.mon_id   = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa           emp  on doc.emp_id  = emp.emp_id
    
                      inner join FacturaCompraDeuda fcd on fc.fc_id    = fcd.fc_id
                                                        and fcd_fecha <= @@Ffin
    
                      left join centroCosto        ccos on fc.ccos_id  = ccos.ccos_id
                       left join provincia          pro  on prov.pro_id = pro.pro_id
    where 
    
      exists (select fc_id from #t_fc_DC_CSC_COM_0220 where fc_id = fc.fc_id)
    
    ------------------------------------------------------------------
    union all
    ------------------------------------------------------------------
    
    
/*- ///////////////////////////////////////////////////////////////////////

Ordenes de Pago

/////////////////////////////////////////////////////////////////////// */

    select 
      opg.opg_id         as comp_id,
      opg.doct_id       as doct_id,
      1                   as orden_id,  
      emp_nombre          as Empresa,
      prov.prov_nombre   as Proveedor,

      prov_tel              as Telefono,
      prov_fax            as Fax,
      prov_email          as Email,
      prov_calle          as Calle,
      prov_callenumero    as Calle_nro,
      prov_piso           as Piso,
      prov_depto          as Dpto,
      pro_nombre          as Provincia,

                          'te.: ' +
      prov_tel           + ' - email: ' +
      prov_email         + ' - dir.: ' +
      prov_calle         + ' ' +
      prov_callenumero  + ' - piso: ' +
      prov_piso          + ' ' +
      prov_depto         as Direccion,

      opg_fecha     as Fecha,
      opg_fecha     as [Vto.],
      convert(datetime,
              convert(varchar,year(opg_fecha))
                 + '-' +
              convert(varchar,month(opg_fecha))
                 + '-01'
              )     as Mes,

      doc_nombre       as Documento,
      opg_nrodoc      as NroDoc,
      null             as [Cond. Pago],
      opg_total       as Total,


      -t.origen          as Origen,
      0                   as Debe,
      opg_pendiente     as Haber,
      -opg_pendiente    as Saldo,
      opg_descrip       as Observaciones
    
    from
      OrdenPago opg inner join proveedor prov        on prov.prov_id  = opg.prov_id
                    inner join documento doc         on doc.doc_id    = opg.doc_id
                    left  join #t_DC_CSC_COM_0220 t  on opg.opg_id    = t.opg_id
    
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
                      left join centroCosto ccos       on opg.ccos_id = ccos.ccos_id
                       left join provincia   pro        on prov.pro_id = pro.pro_id    
    where 
    
              opg_fecha >= @@Fini
          and  opg_fecha <= @@Ffin 

          and round(opg.opg_pendiente,2) > 0
    
          and opg.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where prov_id = opg.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )
              
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (prov.pro_id   = @pro_id   or @pro_id  =0)
    and   (opg.prov_id   = @prov_id   or @prov_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (opg.doc_id   = @doc_id   or @doc_id  =0)
    and   (opg.emp_id   = @emp_id   or @emp_id  =0)
    and   (opg.ccos_id  = @ccos_id   or @ccos_id  =0)
    and   (opg.suc_id   = @suc_id   or @suc_id  =0)
    
    -- Arboles
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 6    and rptarb_hojaid = prov.pro_id))  or (@ram_id_provincia = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 29   and rptarb_hojaid = opg.prov_id))  or (@ram_id_proveedor = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = doc.cico_id))  or (@ram_id_circuitoContable = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 4001 and rptarb_hojaid = opg.doc_id))   or (@ram_id_documento = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = opg.emp_id))   or (@ram_id_empresa = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 21   and rptarb_hojaid = opg.ccos_id))  or (@ram_id_centroCosto = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1007 and rptarb_hojaid = opg.suc_id))   or (@ram_id_sucursal = 0))
    
    order by prov_nombre, emp_nombre, Fecha, doct_id, NroDoc

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

