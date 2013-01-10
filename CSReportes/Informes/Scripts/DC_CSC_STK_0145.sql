/*---------------------------------------------------------------------
Nombre: Ingresos y egresos de Stock
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_STK_0145 1, 
                '20060101',
                '99991231',
                '1854',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0145]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0145]

go
create procedure DC_CSC_STK_0145 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pr_id           varchar(255),
  @@pro_id           varchar(255),
  @@prov_id         varchar(255),
  @@cli_id           varchar(255),
  @@cico_id           varchar(255),
  @@ccos_id           varchar(255),
  @@suc_id           varchar(255),
  @@doct_id           int,
  @@doc_id           varchar(255),
  @@depl_id           varchar(255),
  @@depf_id         varchar(255),
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

declare @pr_id        int
declare @pro_id       int
declare @prov_id       int
declare @cli_id       int
declare @cico_id      int
declare @doc_id       int
declare @emp_id       int

declare @ccos_id      int
declare @suc_id        int
declare @depl_id      int
declare @depf_id      int

declare @ram_id_producto         int
declare @ram_id_provincia        int
declare @ram_id_proveedor        int
declare @ram_id_cliente          int
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
declare @ram_id_transporte       int
declare @ram_id_depositoLogico   int
declare @ram_id_depositoFisico   int

declare @clienteID       int
declare @clienteIDccosi  int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id,         @pr_id   out,      @ram_id_producto          out
exec sp_ArbConvertId @@pro_id,       @pro_id   out,      @ram_id_provincia         out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor         out
exec sp_ArbConvertId @@cli_id,       @cli_id   out,      @ram_id_cliente           out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable   out
exec sp_ArbConvertId @@doc_id,       @doc_id   out,      @ram_id_documento         out
exec sp_ArbConvertId @@emp_id,       @emp_id   out,      @ram_id_empresa           out
exec sp_ArbConvertId @@ccos_id,      @ccos_id out,       @ram_id_centroCosto       out
exec sp_ArbConvertId @@suc_id,       @suc_id   out,       @ram_id_sucursal           out
exec sp_ArbConvertId @@depl_id,      @depl_id out,       @ram_id_depositoLogico     out
exec sp_ArbConvertId @@depf_id,      @depf_id out,       @ram_id_depositoFisico     out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

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

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
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

if @ram_id_depositoLogico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_depositoLogico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_depositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_depositoLogico, @clienteID 
  end else 
    set @ram_id_depositoLogico = 0
end

if @ram_id_depositoFisico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_depositoFisico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_depositoFisico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_depositoFisico, @clienteID 
  end else 
    set @ram_id_depositoFisico = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

              st.id_cliente        as comp_id,
              st.doct_id_cliente  as doct_id,

              st.st_id     as comp_id2,
              st.doct_id   as doct_id2,

              1            as orden_id,  

              st_fecha              [Fecha],
              emp_nombre            [Empresa],
              doc.doc_nombre        [Transferencia],
              st.st_nrodoc          [Trans. Comprobante],
              st.st_numero          [Trans. Numero],

              doc2.doc_nombre       [Documento],
              case       
                when fc_nrodoc   is not null then fc_nrodoc
                when fv_nrodoc   is not null then fv_nrodoc
                when rc_nrodoc   is not null then rc_nrodoc
                when rv_nrodoc   is not null then rv_nrodoc
                when rs_nrodoc   is not null then rs_nrodoc
                when ppk_nrodoc is not null then ppk_nrodoc
                else ''
              end                    [Comprobante],

              case       
                when fc_numero   is not null then fc_numero
                when fv_numero   is not null then fv_numero
                when rc_numero   is not null then rc_numero
                when rv_numero   is not null then rv_numero
                when rs_numero   is not null then rs_numero
                when ppk_numero is not null then ppk_numero
              end                    [Numero],

              prov_nombre           [Proveedor],
              cli_nombre            [Cliente],

              isnull(fc.prov_id,rc.prov_id)  as prov_id,
              isnull(fv.cli_id,rv.cli_id)    as cli_id,

              deplo.depl_nombre      [Origen],
              depld.depl_nombre      [Destino],

              pr_nombrecompra       [Articulo],
              pr_nombreventa        [Articulo Venta],

              case 
                    when depl_id_destino in (-2,-3) then  -sum (sti_ingreso)     
                    else                                    sum (sti_ingreso)     
              end                    [Cantidad]
  
from 

  stock  st inner join documento doc   on st.doc_id   = doc.doc_id
           inner join empresa   emp   on doc.emp_id  = emp.emp_id

           inner join depositoLogico deplo on st.depl_id_origen  = deplo.depl_id
           inner join depositoLogico depld on st.depl_id_destino = depld.depl_id

           inner join stockitem sti    on     st.st_id    = sti.st_id 
--                                        and sti_ingreso <> 0

           inner join producto  pr    on sti.pr_id = pr.pr_id
  
           left join facturaCompra fc on    st.st_id    = fc.st_id 
                                        and st.doct_id_cliente in (2, 8, 10) -- Factura de compra, nota debito venta

           left join facturaVenta fv  on   st.st_id    = fv.st_id 
                                        and st.doct_id_cliente in (1, 7, 9)  -- Factura venta, nota credito venta, nota debito venta

           left join remitoCompra rc  on    st.st_id    = rc.st_id 
                                        and st.doct_id_cliente in (4, 25)    -- Remito compra, devolucion remito compra

           left join remitoVenta rv   on    st.st_id    = rv.st_id 
                                        and st.doct_id_cliente in (3, 24)     -- Remito venta, devolucion remito venta

           left join recuentoStock rs on     (st.st_id = rs.st_id1 or st.st_id = rs.st_id2)
                                        and st.doct_id_cliente = 28          -- Recuento de stock

           left join parteProdKit ppk on     (st.st_id = ppk.st_id1 or st.st_id = ppk.st_id2)
                                        and st.doct_id_cliente = 30          -- Parte produccion kit
  

           left join proveedor prov         on      fc.prov_id = prov.prov_id 
                                                or rc.prov_id = prov.prov_id

           left join cliente cli            on      fv.cli_id  = cli.cli_id 
                                                or rv.cli_id  = cli.cli_id

           left join centroCosto ccos       on      fc.ccos_id  = ccos.ccos_id
                                                or fv.ccos_id  = ccos.ccos_id
                                                or rc.ccos_id  = ccos.ccos_id
                                                or rv.ccos_id  = ccos.ccos_id

           left join moneda    mon          on fc.mon_id   = mon.mon_id
           left join circuitocontable cico  on doc.cico_id = cico.cico_id  
            left join provincia   pro        on prov.pro_id = pro.pro_id

           left join documento doc2 on (fc.doc_id = doc2.doc_id
                                        and st.doct_id_cliente in (2, 8, 10) -- Factura de compra, nota debito venta
                                        ) or
                                        (fv.doc_id = doc2.doc_id
                                        and st.doct_id_cliente in (1, 7, 9)  -- Factura venta, nota credito venta, nota debito venta
                                        ) or
                                        (rc.doc_id = doc2.doc_id
                                        and st.doct_id_cliente in (4, 25)    -- Remito compra, devolucion remito compra
                                        ) or
                                        (rv.doc_id = doc2.doc_id
                                        and st.doct_id_cliente in (3, 24)     -- Remito venta, devolucion remito venta
                                        ) or
                                        (rs.doc_id = doc2.doc_id
                                        and st.doct_id_cliente = 28          -- Recuento de stock
                                        ) or
                                        (ppk.doc_id = doc2.doc_id
                                        and st.doct_id_cliente = 30          -- Parte produccion kit
                                        )
where

          st_fecha >= @@Fini
      and  st_fecha <= @@Ffin 

      and (depl_id_destino = -3 or depl_id_origen = -3)

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where       (@cli_id=0  or fv.cli_id = @cli_id 
                                                                        or rv.cli_id = @cli_id
                                                            ) 
                                                      and us_id = @@us_id
                  ) 
            or (@us_empresaEx = 0)
          )
      and (
            exists(select * from UsuarioEmpresa where       (@prov_id=0  or fc.prov_id = @prov_id 
                                                                         or rc.prov_id = @prov_id
                                                            ) 
                                                      and us_id = @@us_id
                  ) 
            or (@us_empresaEx = 0)
          )

          
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (sti.pr_id = @pr_id or @pr_id=0)

and   (@pro_id=0 or prov.pro_id = @pro_id
                 or cli.pro_id  = @pro_id
      )

and   (@prov_id=0 or fc.prov_id = @prov_id 
                  or rc.prov_id = @prov_id
      )

and   (@cli_id=0  or fv.cli_id = @cli_id 
                  or rv.cli_id = @cli_id
      )

and   (doc.cico_id = @cico_id or @cico_id=0)
and   (st.doc_id = @doc_id or @doc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (@ccos_id=0 or fc.ccos_id   = @ccos_id
                  or fv.ccos_id   = @ccos_id
                  or rc.ccos_id   = @ccos_id
                  or rv.ccos_id   = @ccos_id
      )
and   (st.suc_id           = @suc_id    or @suc_id=0)
and   (st.depl_id_destino = @depl_id   or
       st.depl_id_origen  = @depl_id   or
                                         @depl_id=0
      )
and   (depld.depf_id       = @depf_id   or
       deplo.depf_id      = @depf_id  or
                                         @depf_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30
                  and  rptarb_hojaid = pr.pr_id 
                 ) 
           )
        or 
           (@ram_id_producto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 
                  and  (    rptarb_hojaid = prov.pro_id 
                         or rptarb_hojaid = cli.pro_id
                        )
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
                  and  (    rptarb_hojaid = fc.prov_id 
                         or rptarb_hojaid = rc.prov_id
                        )
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
                  and  tbl_id = 28 
                  and  (    rptarb_hojaid = fv.cli_id 
                         or rptarb_hojaid = rv.cli_id
                        )
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
                  and  tbl_id = 1016 
                  and  (    rptarb_hojaid = doc.cico_id
                         or rptarb_hojaid = doc2.cico_id
                        )
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
                  and  (    rptarb_hojaid = st.doc_id
                         or rptarb_hojaid = doc2.doc_id
                        )
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
                  and  (     fc.ccos_id   = rptarb_hojaid
                          or fv.ccos_id   = rptarb_hojaid
                          or rc.ccos_id   = rptarb_hojaid
                          or rv.ccos_id   = rptarb_hojaid
                        )
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
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = st.suc_id
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
                  and  (    rptarb_hojaid = st.depl_id_origen
                         or rptarb_hojaid = st.depl_id_destino
                        )
                 ) 
           )
        or 
           (@ram_id_depositoLogico = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10
                  and  (    rptarb_hojaid = depld.depf_id
                         or rptarb_hojaid = deplo.depf_id
                        )
                 ) 
           )
        or 
           (@ram_id_depositoFisico = 0)
       )

group by 

              st.st_id,
              st.doct_id,

              st.id_cliente,
              st.doct_id_cliente,

              st_fecha,
              emp_nombre,
              doc.doc_nombre,
              st.st_nrodoc,
              st.st_numero,

              doc2.doc_nombre,
              case       
                when fc_nrodoc   is not null then fc_nrodoc
                when fv_nrodoc   is not null then fv_nrodoc
                when rc_nrodoc   is not null then rc_nrodoc
                when rv_nrodoc   is not null then rv_nrodoc
                when rs_nrodoc   is not null then rs_nrodoc
                when ppk_nrodoc is not null then ppk_nrodoc
                else ''
              end,

              case       
                when fc_numero   is not null then fc_numero
                when fv_numero   is not null then fv_numero
                when rc_numero   is not null then rc_numero
                when rv_numero   is not null then rv_numero
                when rs_numero   is not null then rs_numero
                when ppk_numero is not null then ppk_numero
              end,

              prov_nombre,
              cli_nombre,

              isnull(fc.prov_id,rc.prov_id),
              isnull(fv.cli_id,rv.cli_id),

              depl_id_destino,
              deplo.depl_nombre,
              depld.depl_nombre,

              pr_nombrecompra,
              pr_nombreventa

order by Fecha, Documento, Proveedor, Cliente

end
go

