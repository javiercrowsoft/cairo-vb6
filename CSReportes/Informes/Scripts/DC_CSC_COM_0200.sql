/*---------------------------------------------------------------------
Nombre: Detalle de comprobantes de facuracion
---------------------------------------------------------------------*/
/*  

Para testear:
select * from documentotipo
DC_CSC_COM_0200 1, '20050311','20050311','0', '0','0','0','0','0','0','0'
,'0','0', 1,'0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0200]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0200]

go
create procedure DC_CSC_COM_0200 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@prov_id         varchar(255),
  @@cico_id           varchar(255),
  @@ccos_id           varchar(255),
  @@ccos_id_item     varchar(255),
  @@cpg_id           varchar(255),
  @@lp_id             varchar(255),
  @@ld_id             varchar(255),
  @@suc_id           varchar(255),
  @@doct_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@depl_id           varchar(255),
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
declare @doct_id       int
declare @mon_id       int
declare @emp_id       int

declare @ccos_id      int
declare @ccos_id_item  int
declare @cpg_id        int
declare @lp_id        int
declare @ld_id        int
declare @suc_id        int
declare @depl_id      int



declare @ram_id_provincia        int
declare @ram_id_proveedor          int
declare @ram_id_vendedor         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_documentoTipo    int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_centroCosto      int
declare @ram_id_centroCostoItem  int
declare @ram_id_condicionPago    int
declare @ram_id_listaPrecio      int
declare @ram_id_listaDescuento   int
declare @ram_id_sucursal         int
declare @ram_id_transporte       int
declare @ram_id_depositoLogico   int

declare @clienteID int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@doct_id,       @doct_id out,      @ram_id_documentoTipo out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out
exec sp_ArbConvertId @@ccos_id,      @ccos_id out,       @ram_id_centroCosto out
exec sp_ArbConvertId @@ccos_id_item, @ccos_id_item out, @ram_id_centroCostoItem out
exec sp_ArbConvertId @@cpg_id,        @cpg_id out,       @ram_id_condicionPago out
exec sp_ArbConvertId @@lp_id,        @lp_id out,         @ram_id_listaPrecio out
exec sp_ArbConvertId @@ld_id,        @ld_id out,         @ram_id_listaDescuento out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_sucursal out
exec sp_ArbConvertId @@depl_id,      @depl_id out,       @ram_id_depositoLogico out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

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

if @ram_id_documentoTipo <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documentoTipo, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documentoTipo, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documentoTipo, @clienteID 
  end else 
    set @ram_id_documentoTipo = 0
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

if @ram_id_centroCostoItem <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centroCostoItem, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centroCostoItem, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centroCostoItem, @clienteIDccosi 
  end else 
    set @ram_id_centroCostoItem = 0
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

if @ram_id_transporte <> 0 begin

--  exec sp_ArbGetGroups @ram_id_transporte, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_transporte, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_transporte, @clienteID 
  end else 
    set @ram_id_transporte = 0
end

if @ram_id_depositoLogico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_depositoLogico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_depositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_depositoLogico, @clienteID 
  end else 
    set @ram_id_depositoLogico = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES
select * from producto
/////////////////////////////////////////////////////////////////////// */
select 
    fc.fc_id        as id,
    fc.fc_id        as comp_id,
    fc.doct_id      as doct_id,
    1               as tipo_id,
    prov_nombre      as Proveedor,
    prov_codigo      as Codigo,
    doct_nombre      as Tipo,
    doc_nombre      as Documento,
    fc_nrodoc        as Comprobante,
    fc_fecha        as Fecha,
    cpg_nombre      as [Condicion de Pago],
    pr_nombreCompra as Articulo,
    fci_descrip     as [Item Obser.],
    pr_codigo        as [Codigo Articulo],
    ccos_nombre     as [Centro de Costo],
    fci_cantidad    as Cantidad,
    depl_nombre     as Deposito,
    fc_descuento1   as Descuento,
    case  
      when doct.doct_id = 7 then -fci_precio
    else fci_precio
    end             as Precio,
    case  
      when doct.doct_id = 7 then -fci_neto
    else fci_neto
    end             as Neto,
    case  
      when doct.doct_id = 7 then -fci_ivari
    else fci_ivari
    end             as Iva,
    case  
      when doct.doct_id = 7 then -fc_total
    else fc_total
    end             as Total


from
  facturaCompra fc inner join proveedor        prov on fc.prov_id = prov.prov_id
                   inner join condicionPago    cpg  on fc.cpg_id  = cpg.cpg_id
                   inner join facturaCompraItem fci on fc.fc_id   = fci.fc_id
                   inner join producto         pr   on fci.pr_id  = pr.pr_id
                   inner join documentoTipo    doct on fc.doct_id = doct.doct_id
                   inner join documento        doc  on fc.doc_id  = doc.doc_id

                  inner join moneda    mon         on fc.mon_id   = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

                  left join centroCosto ccos       on fci.ccos_id = ccos.ccos_id
                   left join provincia   pro        on prov.pro_id = pro.pro_id
                  left join stock       st         on fc.st_id    = st.st_id
                  left join depositoLogico depl     on st.depl_id_origen = depl.depl_id
where 

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin 

      and fc.est_id <> 7

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where prov_id = fc.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.pro_id = @pro_id or @pro_id=0)
and   (fc.prov_id = @prov_id or @prov_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (fc.doct_id = @doct_id or @doct_id=0)
and   (fc.doc_id = @doc_id or @doc_id=0)
and   (fc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (fc.ccos_id = @ccos_id or @ccos_id=0)
and   (fci.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (fc.cpg_id = @cpg_id or @cpg_id=0)
and   (fc.lp_id = @lp_id or @lp_id=0)

and   (fc.ld_id = @ld_id or @ld_id=0)
and   (fc.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = fc.doct_id
                 ) 
           )
        or 
           (@ram_id_documentoTipo = 0)
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
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fci.ccos_id
                 ) 
           )
        or 
           (@ram_id_centroCostoItem = 0)
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

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
                 ) 
           )
        or 
           (@ram_id_depositoLogico = 0)
       )
------------------------------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------------------------------

-- Otros

select 
    fc.fc_id        as id,
    fc.fc_id        as comp_id,
    fc.doct_id      as doct_id,
    1               as tipo_id,
    prov_nombre      as Proveedor,
    prov_codigo      as Codigo,
    doct_nombre      as Tipo,
    doc_nombre      as Documento,
    fc_nrodoc        as Comprobante,
    fc_fecha        as Fecha,
    cpg_nombre      as [Condicion de Pago],
    cue_nombre      as Articulo,
    fcot_descrip    as [Item Obser.],
    cue_codigo      as [Codigo Articulo],
    ccos_nombre     as [Centro de Costo],
    1                as Cantidad,
    depl_nombre     as Deposito,
    fc_descuento1   as Descuento,
    case  
      when doct.doct_id = 7 then -(fcot_debe-fcot_haber)
    else (fcot_debe-fcot_haber)
    end             as Precio,
    case  
      when doct.doct_id = 7 then -(fcot_debe-fcot_haber)
    else (fcot_debe-fcot_haber)
    end             as Neto,
    0               as Iva,
    case  
      when doct.doct_id = 7 then -fc_total
    else fc_total
    end             as Total

from
  facturaCompra fc inner join proveedor        prov on fc.prov_id = prov.prov_id
                   inner join condicionPago    cpg  on fc.cpg_id  = cpg.cpg_id
                   inner join facturaCompraOtro fco on fc.fc_id   = fco.fc_id
                   inner join cuenta           cue  on fco.cue_id = cue.cue_id
                   inner join documentoTipo    doct on fc.doct_id = doct.doct_id
                   inner join documento        doc  on fc.doc_id  = doc.doc_id

                  inner join moneda    mon         on fc.mon_id   = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

                  left join centroCosto ccos       on fco.ccos_id = ccos.ccos_id
                   left join provincia   pro        on prov.pro_id = pro.pro_id
                  left join stock       st         on fc.st_id    = st.st_id
                  left join depositoLogico depl     on st.depl_id_origen = depl.depl_id
where 

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin 

      and fc.est_id <> 7

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where prov_id = fc.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.pro_id = @pro_id or @pro_id=0)
and   (fc.prov_id = @prov_id or @prov_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (fc.doct_id = @doct_id or @doct_id=0)
and   (fc.doc_id = @doc_id or @doc_id=0)
and   (fc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (fc.ccos_id = @ccos_id or @ccos_id=0)
and   (fco.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (fc.cpg_id = @cpg_id or @cpg_id=0)
and   (fc.lp_id = @lp_id or @lp_id=0)

and   (fc.ld_id = @ld_id or @ld_id=0)
and   (fc.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = fc.doct_id
                 ) 
           )
        or 
           (@ram_id_documentoTipo = 0)
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
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fco.ccos_id
                 ) 
           )
        or 
           (@ram_id_centroCostoItem = 0)
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

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
                 ) 
           )
        or 
           (@ram_id_depositoLogico = 0)
       )
------------------------------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------------------------------

-- Percepciones

select 
    fc.fc_id        as id,
    fc.fc_id        as comp_id,
    fc.doct_id      as doct_id,
    1               as tipo_id,
    prov_nombre      as Proveedor,
    prov_codigo      as Codigo,
    doct_nombre      as Tipo,
    doc_nombre      as Documento,
    fc_nrodoc        as Comprobante,
    fc_fecha        as Fecha,
    cpg_nombre      as [Condicion de Pago],
    perc_nombre     as Articulo,
    fcperc_descrip  as [Item Obser.],
    perc_codigo      as [Codigo Articulo],
    ccos_nombre     as [Centro de Costo],
    1                as Cantidad,
    depl_nombre     as Deposito,
    fc_descuento1   as Descuento,
    case  
      when doct.doct_id = 7 then -fcperc_importe
    else fcperc_importe
    end             as Precio,
    case  
      when doct.doct_id = 7 then -fcperc_importe
    else fcperc_importe
    end             as Neto,
    0               as Iva,
    case  
      when doct.doct_id = 7 then -fc_total
    else fc_total
    end             as Total

from
  facturaCompra fc inner join proveedor        prov on fc.prov_id = prov.prov_id
                   inner join condicionPago    cpg  on fc.cpg_id  = cpg.cpg_id
                   inner join facturaCompraPercepcion fcp on fc.fc_id = fcp.fc_id
                   inner join Percepcion        perc on fcp.perc_id = perc.perc_id
                   inner join documentoTipo    doct on fc.doct_id = doct.doct_id
                   inner join documento        doc  on fc.doc_id  = doc.doc_id

                  inner join moneda    mon         on fc.mon_id   = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

                  left join centroCosto ccos       on fcp.ccos_id = ccos.ccos_id
                   left join provincia   pro        on prov.pro_id = pro.pro_id
                  left join stock       st         on fc.st_id    = st.st_id
                  left join depositoLogico depl     on st.depl_id_origen = depl.depl_id
where 

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin 

      and fc.est_id <> 7

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where prov_id = fc.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.pro_id = @pro_id or @pro_id=0)
and   (fc.prov_id = @prov_id or @prov_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (fc.doct_id = @doct_id or @doct_id=0)
and   (fc.doc_id = @doc_id or @doc_id=0)
and   (fc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (fc.ccos_id = @ccos_id or @ccos_id=0)
and   (fcp.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (fc.cpg_id = @cpg_id or @cpg_id=0)
and   (fc.lp_id = @lp_id or @lp_id=0)

and   (fc.ld_id = @ld_id or @ld_id=0)
and   (fc.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = fc.doct_id
                 ) 
           )
        or 
           (@ram_id_documentoTipo = 0)
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
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fcp.ccos_id
                 ) 
           )
        or 
           (@ram_id_centroCostoItem = 0)
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

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
                 ) 
           )
        or 
           (@ram_id_depositoLogico = 0)
       )
------------------------------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------------------------------
select 
    rc.rc_id        as id,
    rc.rc_id        as comp_id,
    rc.doct_id      as doct_id,
    1               as tipo_id,
    prov_nombre      as Proveedor,
    prov_codigo      as Codigo,
    doct_nombre      as Tipo,
    doc_nombre      as Documento,
    rc_nrodoc        as Comprobante,
    rc_fecha        as Fecha,
    cpg_nombre      as [Condicion de Pago],
    pr_nombreCompra as Articulo,
    rci_descrip     as [Item Obser.],
    pr_codigo        as [Codigo Articulo],
    ccos_nombre     as [Centro de Costo],
    rci_cantidad    as Cantidad,
    depl_nombre     as Deposito,
    rc_descuento1    as Descuento,
    case  
      when doct.doct_id = 24 then -rci_precio 
    else rci_precio
    end             as Precio,
    case  
      when doct.doct_id = 24 then -rci_neto 
    else rci_neto
    end             as Neto,
    case  
      when doct.doct_id = 24 then -rci_ivari 
    else rci_ivari
    end             as Iva,
    case  
      when doct.doct_id = 24 then -rc_total
    else rc_total
    end             as Total

from
  remitoCompra rc inner join proveedor        prov on rc.prov_id = prov.prov_id
                  inner join condicionPago    cpg  on rc.cpg_id  = cpg.cpg_id
                  inner join remitoCompraItem rci  on rc.rc_id   = rci.rc_id
                  inner join producto         pr   on rci.pr_id  = pr.pr_id
                  inner join documentoTipo    doct on rc.doct_id = doct.doct_id
                  inner join documento        doc  on rc.doc_id  = doc.doc_id


                  inner join moneda    mon         on doc.mon_id  = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

                  left join centroCosto ccos       on rci.ccos_id = ccos.ccos_id
                   left join provincia   pro        on prov.pro_id = pro.pro_id
                  left join stock       st         on rc.st_id    = st.st_id
                  left join depositoLogico depl     on st.depl_id_origen = depl.depl_id
where 

          rc_fecha >= @@Fini
      and  rc_fecha <= @@Ffin 

      and rc.est_id <> 7

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where prov_id = rc.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )
          

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.pro_id = @pro_id or @pro_id=0)
and   (rc.prov_id = @prov_id or @prov_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (rc.doct_id = @doct_id or @doct_id=0)
and   (rc.doc_id = @doc_id or @doc_id=0)
and   (doc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (rc.ccos_id = @ccos_id or @ccos_id=0)
and   (rci.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (rc.cpg_id = @cpg_id or @cpg_id=0)
and   (rc.lp_id = @lp_id or @lp_id=0)

and   (rc.ld_id = @ld_id or @ld_id=0)
and   (rc.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

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
                  and  rptarb_hojaid = rc.prov_id
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
                  and  rptarb_hojaid = rc.doc_id
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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = rc.doct_id
                 ) 
           )
        or 
           (@ram_id_documentoTipo = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12 
                  and  rptarb_hojaid = doc.mon_id
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
                  and  rptarb_hojaid = rc.ccos_id
                 ) 
           )
        or 
           (@ram_id_centroCosto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = rci.ccos_id
                 ) 
           )
        or 
           (@ram_id_centroCostoItem = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = rc.cpg_id
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
                  and  rptarb_hojaid = rc.lp_id
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
                  and  rptarb_hojaid = rc.ld_id
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
                  and  rptarb_hojaid = rc.suc_id
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
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
                 ) 
           )
        or 
           (@ram_id_depositoLogico = 0)
       )

order by tipo_id, proveedor, fecha, comprobante


end


go


