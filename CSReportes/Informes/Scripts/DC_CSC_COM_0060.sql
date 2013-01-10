/*---------------------------------------------------------------------
Nombre: Detalle de Compra de Articulos
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_COM_0060 1, 
                '20050105',
                '20050105',
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
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0060]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0060]

go
create procedure DC_CSC_COM_0060 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pr_id           varchar(255),
  @@pro_id           varchar(255),
  @@prov_id         varchar(255),

  @@cico_id           varchar(255),
  @@ccos_id           varchar(255),
  @@suc_id           varchar(255),
  @@doct_id           int,
  @@doc_id           varchar(255),
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
declare @cico_id      int
declare @doc_id       int
declare @emp_id       int

declare @ccos_id      int
declare @suc_id        int

declare @ram_id_producto         int
declare @ram_id_provincia        int
declare @ram_id_proveedor        int
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

declare @clienteID       int
declare @clienteIDccosi  int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id,         @pr_id   out,      @ram_id_producto          out
exec sp_ArbConvertId @@pro_id,       @pro_id   out,      @ram_id_provincia         out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor         out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable   out
exec sp_ArbConvertId @@doc_id,       @doc_id   out,      @ram_id_documento         out
exec sp_ArbConvertId @@emp_id,       @emp_id   out,      @ram_id_empresa           out
exec sp_ArbConvertId @@ccos_id,      @ccos_id out,       @ram_id_centroCosto       out
exec sp_ArbConvertId @@suc_id,       @suc_id   out,       @ram_id_sucursal           out

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


/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

              1            as orden_id,  

              fc.fc_id    as comp_id,
              fc.doct_id  as doct_id,
              fc.st_id    as comp_id2,
              st.doct_id  as doct_id2,

              fc_fecha              [Fecha],
              emp_nombre            [Empresa],
              doc.doc_nombre        [Documento],
              fc.fc_nrodoc          [Comprobante],
              fc.fc_numero          [Numero],

              doc2.doc_nombre        [Transferencia],
              st.st_nrodoc          [Trans. Comprobante],
              st.st_numero          [Trans. Numero],

              prov_nombre           [Proveedor],

              fc.prov_id,

              pr_nombrecompra       [Articulo],
              pr_nombreventa        [Articulo Venta],

              sum(case fc.doct_id when 8 then -fci_cantidad else fci_cantidad end) as [Cantidad],
              sum(case fc.doct_id when 8 then -fci_neto else fci_neto end) as Neto,
              sum(case fc.doct_id when 8 then -fci_ivari+fci_ivarni else fci_ivari+fci_ivarni end) as IVA,
              sum(case fc.doct_id when 8 then -fci_importe else fci_importe end) as Importe

  
from 

  FacturaCompra  fc 

           inner join documento doc   on fc.doc_id   = doc.doc_id
           inner join empresa   emp   on doc.emp_id  = emp.emp_id

           inner join FacturaCompraItem fci    on     fc.fc_id = fci.fc_id 

           inner join producto  pr    on fci.pr_id = pr.pr_id
  
           inner join proveedor prov  on fc.prov_id = prov.prov_id 

           left join centroCosto ccos on fc.ccos_id  = ccos.ccos_id

           left join moneda    mon          on fc.mon_id   = mon.mon_id
           left join circuitocontable cico  on doc.cico_id = cico.cico_id  
            left join provincia   pro        on prov.pro_id = pro.pro_id

           left join Stock st         on fc.st_id   = st.st_id
           left join documento doc2   on st.doc_id  = doc2.doc_id
where

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin 

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where (@prov_id=0  or fc.prov_id = @prov_id) 
                                                  and us_id = @@us_id
                  ) 
            or (@us_empresaEx = 0)
          )

          
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (fci.pr_id    = @pr_id   or @pr_id=0)
and   (prov.pro_id = @pro_id  or @pro_id=0)
and   (fc.prov_id  = @prov_id or @prov_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (fc.doc_id   = @doc_id  or @doc_id=0)
and   (doc.emp_id  = @emp_id  or @emp_id=0)
and   (fc.ccos_id  = @ccos_id or @ccos_id=0)
and   (fc.suc_id   = @suc_id  or @suc_id=0)

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
                  and  fc.ccos_id   = rptarb_hojaid
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
                  and  rptarb_hojaid = fc.suc_id
                 ) 
           )
        or 
           (@ram_id_sucursal = 0)
       )

group by 

              fc.fc_id,
              fc.doct_id,
              fc.st_id,
              st.doct_id,

              fc_fecha,
              emp_nombre,
              doc.doc_nombre,
              fc.fc_nrodoc,
              fc.fc_numero,

              doc2.doc_nombre,
              st.st_nrodoc,
              st.st_numero,

              prov_nombre,

              fc.prov_id,
              pr_nombrecompra,
              pr_nombreventa

union all

select 

              1            as orden_id,  

              rc.rc_id    as comp_id,
              rc.doct_id  as doct_id,
              rc.st_id    as comp_id2,
              st.doct_id  as doct_id2,

              rc_fecha              [Fecha],
              emp_nombre            [Empresa],
              doc.doc_nombre        [Documento],
              rc.rc_nrodoc          [Comprobante],
              rc.rc_numero          [Numero],

              doc2.doc_nombre        [Transferencia],
              st.st_nrodoc          [Trans. Comprobante],
              st.st_numero          [Trans. Numero],

              prov_nombre           [Proveedor],

              rc.prov_id,

              pr_nombrecompra       [Articulo],
              pr_nombreventa        [Articulo Venta],

              sum(rci_cantidad)     [Cantidad],

              sum(rci_neto)                    as Neto,
              sum(rci_ivari+rci_ivarni)        as IVA,
              sum(rci_importe)                as Importe

  
from 

  RemitoCompra  rc 

           inner join documento doc   on rc.doc_id   = doc.doc_id
           inner join empresa   emp   on doc.emp_id  = emp.emp_id

           inner join RemitoCompraItem rci    on     rc.rc_id = rci.rc_id 

           inner join producto  pr    on rci.pr_id = pr.pr_id
  
           inner join proveedor prov  on rc.prov_id = prov.prov_id 

           left join centroCosto ccos on rc.ccos_id  = ccos.ccos_id

           left join moneda    mon          on doc.mon_id   = mon.mon_id
           left join circuitocontable cico  on doc.cico_id = cico.cico_id  
            left join provincia   pro        on prov.pro_id = pro.pro_id

           left join Stock st         on rc.st_id   = st.st_id
           left join documento doc2   on st.doc_id  = doc2.doc_id

where

          rc_fecha >= @@Fini
      and  rc_fecha <= @@Ffin 

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where (@prov_id=0  or rc.prov_id = @prov_id) 
                                                  and us_id = @@us_id
                  ) 
            or (@us_empresaEx = 0)
          )

          
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (rci.pr_id   = @pr_id    or @pr_id=0)
and   (prov.pro_id = @pro_id   or @pro_id=0)
and   (rc.prov_id  = @prov_id  or @prov_id=0)
and   (doc.cico_id = @cico_id  or @cico_id=0)
and   (rc.doc_id   = @doc_id   or @doc_id=0)
and   (doc.emp_id  = @emp_id   or @emp_id=0)
and   (rc.ccos_id  = @ccos_id  or @ccos_id=0)
and   (rc.suc_id   = @suc_id   or @suc_id=0)

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
                  and  rc.ccos_id   = rptarb_hojaid
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
                  and  rptarb_hojaid = rc.suc_id
                 ) 
           )
        or 
           (@ram_id_sucursal = 0)
       )

group by 

              rc.rc_id,
              rc.doct_id,
              rc.st_id,
              st.doct_id,

              rc_fecha,
              emp_nombre,
              doc.doc_nombre,
              rc.rc_nrodoc,
              rc.rc_numero,

              doc2.doc_nombre,
              st.st_nrodoc,
              st.st_numero,

              prov_nombre,

              rc.prov_id,
              pr_nombrecompra,
              pr_nombreventa

order by Articulo, Proveedor, Empresa

end
go

