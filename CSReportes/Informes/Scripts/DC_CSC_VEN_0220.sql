/*---------------------------------------------------------------------
Nombre: Listado de Pedidos y remitos pendientes
---------------------------------------------------------------------*/
/*  

Para testear:

select count(*) from remitoventa where rv_pendiente >0
select count(*) from pedidoventa where pv_pendiente >0

select 890+721

DC_CSC_VEN_0220 1, '20050101','20100201','0', '0','0','0','0','0'
,'0','0','0', 5,'0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0220]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0220]

go
create procedure DC_CSC_VEN_0220 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@cli_id           varchar(255),
  @@ven_id           varchar(255),
  @@cico_id           varchar(255),
  @@ccos_id           varchar(255),
  @@cpg_id           varchar(255),
  @@lp_id             varchar(255),
  @@ld_id             varchar(255),
  @@suc_id           varchar(255),
  @@doct_id           int,
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@depl_id           varchar(255),
  @@emp_id           varchar(255),
  @@soloPendiente   tinyint =1

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

declare @ccos_id      int
declare @cpg_id        int
declare @lp_id        int
declare @ld_id        int
declare @suc_id        int
declare @depl_id      int

declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_vendedor         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_centroCosto      int
declare @ram_id_condicionPago    int
declare @ram_id_listaPrecio      int
declare @ram_id_listaDescuento   int
declare @ram_id_sucursal         int
declare @ram_id_depositoLogico   int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@ven_id,       @ven_id out,        @ram_id_vendedor out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out
exec sp_ArbConvertId @@ccos_id,      @ccos_id out,       @ram_id_centroCosto out
exec sp_ArbConvertId @@cpg_id,        @cpg_id out,       @ram_id_condicionPago out
exec sp_ArbConvertId @@lp_id,        @lp_id out,         @ram_id_listaPrecio out
exec sp_ArbConvertId @@ld_id,        @ld_id out,         @ram_id_listaDescuento out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_sucursal out
exec sp_ArbConvertId @@depl_id,      @depl_id out,       @ram_id_depositoLogico out

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

/////////////////////////////////////////////////////////////////////// */

select
  pv_id             as comp_id,
  pv.doct_id        as doct_id,
  emp_nombre        as Empresa,
  cli_nombre        as Cliente,
  pv_fecha          as Fecha,
  pv_fechaEntrega    as Entrega,
  doc_nombre        as Documento,
  pv_nrodoc          as NroPedido,
  pv_pendiente      as Pendiente,
  pv_neto            as Neto,
  pv_total          as Total,
  cpg_nombre        as [Condicion de pago],
  ven_nombre        as Vendedor
  
from
  pedidoVenta pv inner join documento         doc     on pv.doc_id   = doc.doc_id
                 inner join empresa           emp     on doc.emp_id  = emp.emp_id
                 inner join cliente           cli     on pv.cli_id   = cli.cli_id
                 inner join moneda            mon     on doc.mon_id  = mon.mon_id
                 inner join circuitocontable  cico     on doc.cico_id = cico.cico_id

                 left  join condicionPago cpg     on pv.cpg_id   = cpg.cpg_id
                 left  join vendedor      ven     on cli.ven_id  = ven.ven_id
                  left  join provincia     pro     on cli.pro_id  = pro.pro_id

where 
          pv_fecha >= @@Fini
      and  pv_fecha <= @@Ffin 

      and pv.doct_id <> 22

      and ((pv.est_id <> 7 and pv.est_id <> 5) or @@soloPendiente = 0)

-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where cli_id = pv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )
          

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.pro_id = @pro_id or @pro_id=0)
and   (pv.cli_id = @cli_id or @cli_id=0)
and   (    IsNull(pv.ven_id,0)   = @ven_id
       or  IsNull(cli.ven_id,0)   = @ven_id
       or @ven_id  =0
      )
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (pv.doct_id = @@doct_id or @@doct_id=0)
and   (pv.doc_id = @doc_id or @doc_id=0)
and   (doc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (pv.ccos_id = @ccos_id or @ccos_id=0)
and   (pv.cpg_id = @cpg_id or @cpg_id=0)
and   (pv.lp_id = @lp_id or @lp_id=0)

and   (pv.ld_id = @ld_id or @ld_id=0)
and   (pv.suc_id = @suc_id or @suc_id=0)

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
                  and  rptarb_hojaid = pv.cli_id
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
                  and  (    rptarb_hojaid = isnull(pv.ven_id,0)
                        or  rptarb_hojaid = isnull(cli.ven_id,0)
                        )
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
                  and  rptarb_hojaid = pv.doc_id
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
                  and  rptarb_hojaid = pv.ccos_id
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
                  and  rptarb_hojaid = pv.cpg_id
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
                  and  rptarb_hojaid = pv.lp_id
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
                  and  rptarb_hojaid = pv.ld_id
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
                  and  rptarb_hojaid = pv.suc_id
                 ) 
           )
        or 
           (@ram_id_sucursal = 0)
       )

union all

select
  rv_id             as comp_id,
  rv.doct_id        as doct_id,
  emp_nombre        as Empresa,
  cli_nombre        as Cliente,
  rv_fecha          as Fecha,
  rv_fechaEntrega    as Entrega,
  doc_nombre        as Documento,
  rv_nrodoc          as NroRemito,
  rv_pendiente      as Pendiente,
  rv_neto            as Neto,
  rv_total          as Total,
  cpg_nombre        as [Condicion de pago],
  ven_nombre        as Vendedor
  
from
  remitoVenta rv inner join documento         doc     on rv.doc_id   = doc.doc_id
                 inner join empresa           emp     on doc.emp_id  = emp.emp_id
                 inner join cliente           cli     on rv.cli_id   = cli.cli_id
                 inner join moneda            mon     on doc.mon_id  = mon.mon_id
                 inner join circuitocontable  cico     on doc.cico_id = cico.cico_id

                 left  join condicionPago cpg     on rv.cpg_id   = cpg.cpg_id
                 left  join vendedor       ven     on rv.ven_id   = ven.ven_id
                  left  join provincia     pro     on cli.pro_id  = pro.pro_id
                 left  join stock         st      on rv.st_id    = st.st_id

where 
          rv_fecha >= @@Fini
      and  rv_fecha <= @@Ffin 

      and rv.doct_id <> 24

      and ((rv.est_id <> 7 and rv.est_id <> 5) or @@soloPendiente = 0) 
-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where cli_id = rv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )
          

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.pro_id = @pro_id or @pro_id=0)
and   (rv.cli_id = @cli_id or @cli_id=0)
and   (    IsNull(rv.ven_id,0)   = @ven_id
       or  IsNull(cli.ven_id,0)   = @ven_id
       or @ven_id  =0
      )
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (rv.doct_id = @@doct_id or @@doct_id=0)
and   (rv.doc_id = @doc_id or @doc_id=0)
and   (doc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (rv.ccos_id = @ccos_id or @ccos_id=0)
and   (rv.cpg_id = @cpg_id or @cpg_id=0)
and   (rv.lp_id = @lp_id or @lp_id=0)

and   (rv.ld_id = @ld_id or @ld_id=0)
and   (rv.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

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
                  and  rptarb_hojaid = rv.cli_id
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
                  and  (    rptarb_hojaid = isnull(rv.ven_id,0)
                        or  rptarb_hojaid = isnull(cli.ven_id,0)
                        )
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
                  and  rptarb_hojaid = rv.doc_id
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
                  and  rptarb_hojaid = rv.ccos_id
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
                  and  rptarb_hojaid = rv.cpg_id
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
                  and  rptarb_hojaid = rv.lp_id
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
                  and  rptarb_hojaid = rv.ld_id
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
                  and  rptarb_hojaid = rv.suc_id
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


order by Cliente, Fecha


end
go