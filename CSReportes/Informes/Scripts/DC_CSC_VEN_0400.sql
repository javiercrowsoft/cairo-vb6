/*---------------------------------------------------------------------
Nombre: Detalle de comprobantes de facturacion
---------------------------------------------------------------------*/
/*  

Para testear:
select * from documentotipo
DC_CSC_VEN_0400 1, '20050311','20050311','0', '0','0','0','0','0','0','0'
,'0','0', 1,'0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0400]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0400]

go
create procedure DC_CSC_VEN_0400 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@cli_id           varchar(255),
  @@proy_id           varchar(255),
  @@clis_id           varchar(255),
  @@cont_id           varchar(255),
  @@rub_id           varchar(255),
  @@pr_id             varchar(255),
  @@prns_id           varchar(255),
  @@suc_id           varchar(255),
  @@doc_id           varchar(255),
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

declare @cli_id       int
declare @proy_id       int
declare @clis_id      int
declare @doc_id       int
declare @mon_id       int
declare @emp_id       int
declare @cont_id      int
declare @pr_id        int
declare @prns_id      int
declare @rub_id        int
declare @ld_id        int
declare @suc_id        int
declare @trans_id     int
declare @depl_id      int

declare @ram_id_cliente          int
declare @ram_id_proyecto         int
declare @ram_id_clienteSucursal  int
declare @ram_id_documento        int

declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_contacto         int
declare @ram_id_producto         int
declare @ram_id_productonroserie int
declare @ram_id_rubro             int
declare @ram_id_sucursal         int
declare @ram_id_transporte       int
declare @ram_id_depositoLogico   int

declare @clienteID int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@proy_id,       @proy_id out,      @ram_id_proyecto out
exec sp_ArbConvertId @@clis_id,      @clis_id out,       @ram_id_clienteSucursal out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out
exec sp_ArbConvertId @@cont_id,      @cont_id out,       @ram_id_contacto out
exec sp_ArbConvertId @@pr_id,        @pr_id out,         @ram_id_producto out
exec sp_ArbConvertId @@prns_id,      @prns_id out,       @ram_id_productonroserie out
exec sp_ArbConvertId @@rub_id,       @rub_id out,       @ram_id_rubro out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_sucursal out
exec sp_ArbConvertId @@depl_id,      @depl_id out,       @ram_id_depositoLogico out

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_proyecto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proyecto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proyecto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proyecto, @clienteID 
  end else 
    set @ram_id_proyecto = 0
end

if @ram_id_clienteSucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_clienteSucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_clienteSucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_clienteSucursal, @clienteID 
  end else 
    set @ram_id_clienteSucursal = 0
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

if @ram_id_contacto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_contacto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_contacto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_contacto, @clienteID 
  end else 
    set @ram_id_contacto = 0
end

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_productonroserie <> 0 begin

--  exec sp_ArbGetGroups @ram_id_productonroserie, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_productonroserie, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_productonroserie, @clienteID 
  end else 
    set @ram_id_productonroserie = 0
end

if @ram_id_rubro <> 0 begin

--  exec sp_ArbGetGroups @ram_id_rubro, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_rubro, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_rubro, @clienteID 
  end else 
    set @ram_id_rubro = 0
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

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES
select * from producto
/////////////////////////////////////////////////////////////////////// */
select 
    os.os_id        as id,
    1               as tipo_id,
    cli_nombre      as Cliente,
    cli_codigo      as Codigo,
    doc_nombre      as Documento,
    os_nrodoc        as Comprobante,
    os_fecha        as Fecha,
    prns_nombre      as [Condicion de Pago],
    pr_nombreVenta  as Articulo,
    pr_codigo        as [Codigo Articulo],
    osi_cantidad    as Cantidad,
    depl_nombre     as Deposito,
    os_descuento1   as Descuento,
    case  
      when doct.doct_id = 7 then -osi_precio
    else osi_precio
    end             as Precio,
    case  
      when doct.doct_id = 7 then -osi_neto
    else osi_neto
    end             as Neto

from
  OrdenServicio os   inner join cliente           cli    on os.cli_id     = cli.cli_id
                    inner join OrdenServicioItem osi   on os.os_id     = osi.os_id

                    inner join producto         pr   on osi.pr_id  = pr.pr_id
                    inner join documento        doc  on os.doc_id  = doc.doc_id

                    inner join moneda          mon   on os.mon_id   = mon.mon_id
                    inner join ClienteSucursal clis  on os.clis_id  = clis.clis_id
                    inner join empresa         emp   on os.emp_id   = emp.emp_id

                     left join provincia   pro        on cli.pro_id         = pro.pro_id
                    left join stock       st         on os.st_id           = st.st_id
                    left join depositoLogico depl     on st.depl_id_destino = depl.depl_id

                    left join StockItem sti                on sti.st_id = st.st_id 
                                                         and sti.sti_grupo = osi.osi_id

                    left join ProductoNumeroSerie prns    on sti.prns_id = prns.prns_id

where 

          os_fecha >= @@Fini
      and  os_fecha <= @@Ffin 

      and os.est_id <> 7

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where cli_id = os.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.pro_id = @pro_id   or @pro_id=0)
and   (os.cli_id  = @cli_id   or @cli_id=0)
and   (os.proy_id = @proy_id   or @proy_id=0)
and   (os.clis_id = @clis_id  or @clis_id=0)
and   (os.doct_id = @doct_id  or @doct_id=0)
and   (os.doc_id  = @doc_id   or @doc_id=0)
and   (os.mon_id  = @mon_id   or @mon_id=0)
and   (os.emp_id  = @emp_id   or @emp_id=0)

and   (os.cont_id  = @cont_id  or @cont_id=0)
and   (osi.pr_id   = @pr_id    or @pr_id=0)
and   (osi.prns_id = @prns_id  or @prns_id=0)
and   (pr.rub_id   = @rub_id   or @rub_id=0)

and   (os.suc_id   = @suc_id   or @suc_id=0)
and   (os.trans_id = @trans_id or @trans_id=0)
and   (st.depl_id_destino = @depl_id or @depl_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 
                  and  rptarb_hojaid = cli.pro_id
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
                  and  rptarb_hojaid = os.cli_id
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
                  and  (    rptarb_hojaid = isnull(os.proy_id,0)
                        or  rptarb_hojaid = isnull(cli.proy_id,0)
                        )
                 ) 
           )
        or 
           (@ram_id_proyecto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = os.clis_id
                 ) 
           )
        or 
           (@ram_id_clienteSucursal = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001
                  and  rptarb_hojaid = os.doc_id
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
                  and  rptarb_hojaid = os.doct_id
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
                  and  rptarb_hojaid = os.mon_id
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
                  and  rptarb_hojaid = os.cont_id
                 ) 
           )
        or 
           (@ram_id_contacto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  rptarb_hojaid = osi.pr_id
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
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = osi.prns_id
                 ) 
           )
        or 
           (@ram_id_productonroserie = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 27 
                  and  rptarb_hojaid = os.rub_id
                 ) 
           )
        or 
           (@ram_id_rubro = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1006 
                  and  rptarb_hojaid = os.ld_id
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
                  and  rptarb_hojaid = os.suc_id
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
                  and  tbl_id = 34 
                  and  rptarb_hojaid = os.trans_id
                 ) 
           )
        or 
           (@ram_id_transporte = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_destino
                 ) 
           )
        or 
           (@ram_id_depositoLogico = 0)
       )

order by tipo_id, cliente, fecha, comprobante


end


go


