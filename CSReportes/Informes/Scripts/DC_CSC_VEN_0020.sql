/*---------------------------------------------------------------------
Nombre: Aplicacion de Documentos de Venta
---------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

--[DC_CSC_VEN_0020] 73,'20070601 00:00:00','0','0','0'

/*
select * from cliente where cli_nombre like '%car on%'
DC_CSC_VEN_0020 1,
                '20050701',
                '20050930',
                '2249',
                '0',
                '2'
*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0020]
GO

create procedure DC_CSC_VEN_0020 (

  @@us_id    int,
  @@Fini      datetime,

@@cli_id  varchar(255),
@@suc_id  varchar(255), 
@@emp_id  varchar(255)

)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @Ffin datetime set @Ffin = getdate()

declare @cli_id int
declare @suc_id int
declare @emp_id int 

declare @ram_id_Cliente  int
declare @ram_id_Sucursal int
declare @ram_id_Empresa  int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
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

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
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


/*- ///////////////////////////////////////////////////////////////////////

SALDO INICIAL

/////////////////////////////////////////////////////////////////////// */


      select 
      
        0                         as doct_id_cobz,
        0                         as doct_id,
        0                          as cobz_id,
        0                          as comp_id,
      
        cli_nombre                as Cliente,
        convert(datetime,'19000101')
                                  as [Cobranza/NC Fecha],
        ''                         as [Cobranza/NC],
        ''                        as [Empresa], 
        '(Saldo Inicial COBZ)'    as [Cobranza/NC Comprobante],
        -9999                     as [Cobranza/NC Numero],
        0                         as [Cobranza/NC Total],
        sum(cobz_pendiente)       as [Cobranza/NC Pendiente],
        ''                         as [Cobranza/NC Legajo],
        null                       as [Factura Fecha],
        ''                        as [Documento de Venta],
        ''                         as [Factura Comprobante],
        0                          as [Factura Numero],
        ''                        as [Moneda],
        0                          as [Aplicacion],
        0                          as [Factura Total],
        0                         as [Factura Pendiente],
        ''                        as [Factura Legajo],
        0                         as Orden
        
      
      from
      
        Cobranza cobz        inner join Cliente cli   on cobz.cli_id   = cli.cli_id

      where 
      
                cobz_fecha < @@Fini
      
            and cobz.est_id <> 7
      
            and (
                  exists(select * from EmpresaUsuario where emp_id = cobz.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
             and (
                  exists(select * from UsuarioEmpresa where cli_id = cobz.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (cobz.cli_id = @cli_id or @cli_id=0)
      and   (cobz.suc_id = @suc_id or @suc_id=0)
      and   (cobz.emp_id = @emp_id or @emp_id=0) 
      
      -- Arboles
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 28 
                        and  rptarb_hojaid = cobz.cli_id
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
                        and  tbl_id = 1007 
                        and  rptarb_hojaid = cobz.suc_id
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
                        and  tbl_id = 1018 
                        and  rptarb_hojaid = cobz.emp_id
                       ) 
                 )
              or 
                 (@ram_id_Empresa = 0)
             )

      group by cli_nombre
      
      union all
      
      --////////////////////////////////////////////////////////////////////////////////////////////////////////
      
      select 

        0                         as doct_id_cobz,      
        0                         as doct_id,
        0                         as cobz_id,
        0                          as comp_id,
      
        cli_nombre                as Cliente,
        convert(datetime,'19000101')                    
                                  as [Cobranza/NC Fecha],
        ''                        as [Cobranza/NC],
        ''                        as [Empresa], 
        '(Saldo Inicial NC)'      as [Cobranza/NC Comprobante],
        -9999                     as [Cobranza/NC Numero],
        0                         as [Cobranza/NC Total],
        sum(nc.fv_pendiente)      as [Cobranza/NC Pendiente],
        ''                        as [Cobranza/NC Legajo],
        null                      as [Factura Fecha],
        ''                        as [Documento de Venta],
        ''                        as [Factura Comprobante],
        0                          as [Factura Numero],
        ''                        as [Moneda],
        0                          as [Aplicacion],
        0                         as [Factura Total],
        0                         as [Factura Pendiente],
        ''                        as [Factura Legajo],
        0                         as Orden
        
      
      from
      
        FacturaVenta nc     inner join Cliente cli                     on nc.cli_id             = cli.cli_id

      where 
      
                nc.fv_fecha < @@Fini
      
            and nc.est_id <> 7
            and nc.doct_id = 7 /* 7  Nota de Credito Venta */
      
            and (
                  exists(select * from EmpresaUsuario where emp_id = nc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
             and (
                  exists(select * from UsuarioEmpresa where cli_id = nc.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (nc.cli_id = @cli_id or @cli_id=0)
      and   (nc.suc_id = @suc_id or @suc_id=0)
      and   (nc.emp_id = @emp_id or @emp_id=0) 
      
      -- Arboles
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 28 
                        and  rptarb_hojaid = nc.cli_id
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
                        and  tbl_id = 1007 
                        and  rptarb_hojaid = nc.suc_id
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
                        and  tbl_id = 1018 
                        and  rptarb_hojaid = nc.emp_id
                       ) 
                 )
              or 
                 (@ram_id_Empresa = 0)
             )

      group by cli_nombre
      
      --////////////////////////////////////////////////////////////////////////////////////////////////////////
      union all
      
      select 

        0                         as doct_id_cobz,
        0                         as doct_id,      
        0                          as cobz_id,
        0                          as comp_id,
      
        cli_nombre                as Cliente,
        convert(datetime,'19000101')
                                  as [Cobranza/NC Fecha],
        ''                        as [Cobranza/NC],
        ''                        as [Empresa], 
        ''                         as [Cobranza/NC Comprobante],
        null                       as [Cobranza/NC Numero],
        0                          as [Cobranza/NC Total],
        0                          as [Cobranza/NC Pendiente],
        ''                        as [Cobranza/NC Legajo],
        null                       as [Factura Fecha],
        ''                        as [Documento de Venta],
        '(Saldo Inicial FV/ND)'   as [Factura Comprobante],
        -9999                     as [Factura Numero],
        ''                        as [Moneda],
        0                          as [Aplicacion],
        0                          as [Factura Total],
        sum(fv_pendiente)         as [Factura Pendiente],
        ''                        as [Factura Legajo],
        1                         as Orden
      
      from
      
        FacturaVenta fv         inner join Cliente cli                     on fv.cli_id       = cli.cli_id

      where 
      
                fv_fecha < @@Fini
      
            and round(fv_pendiente,2) > 0
            and fv.doct_id <> 7 /* 7  Nota de Credito Venta */
            and fv.est_id <> 7
      
            and (
                  exists(select * from EmpresaUsuario where emp_id = fv.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
             and (
                  exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (fv.cli_id = @cli_id or @cli_id=0)
      and   (fv.suc_id = @suc_id or @suc_id=0)
      and   (fv.emp_id = @emp_id or @emp_id=0) 
      
      -- Arboles
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
                 (@ram_id_Cliente = 0)
             )
      
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 1007 
                        and  rptarb_hojaid = fv.suc_id
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
                        and  tbl_id = 1018 
                        and  rptarb_hojaid = fv.emp_id
                       ) 
                 )
              or 
                 (@ram_id_Empresa = 0)
             )

      group by cli_nombre

      --///////////////////////////////////////////////////////////////

union all

/*- ///////////////////////////////////////////////////////////////////////

PERIODO

/////////////////////////////////////////////////////////////////////// */
      select 
      
        cobz.doct_id              as doct_id_cobz,
        fv.doct_id                as doct_id,
        cobz.cobz_id              as cobz_id,
        fv.fv_id                  as comp_id,
      
        cli_nombre                as Cliente,
        cobz_fecha                as [Cobranza/NC Fecha],
        doccob.doc_nombre         as [Cobranza/NC],
        emp_nombre                as [Empresa], 
        cobz_nrodoc               as [Cobranza/NC Comprobante],
        cobz_numero               as [Cobranza/NC Numero],
        cobz_total                as [Cobranza/NC Total],
        cobz_pendiente            as [Cobranza/NC Pendiente],
        lgjcob.lgj_codigo         as [Cobranza/NC Legajo],
        fv_fecha                  as [Factura Fecha],
        docfv.doc_nombre          as [Documento de Venta],
        fv_nrodoc                 as [Factura Comprobante],
        fv_numero                 as [Factura Numero],
        mon_nombre                as [Moneda],
        fvcobz_importe            as [Aplicacion],
        fv_total                  as [Factura Total],
        0                         as [Factura Pendiente],
        lgjfv.lgj_codigo          as [Factura Legajo],
        0                         as Orden
        
      
      from
      
        Cobranza cobz        inner join Cliente cli                     on cobz.cli_id       = cli.cli_id
                            inner join Sucursal                       on cobz.suc_id      = Sucursal.suc_id
                            inner join Documento doccob               on cobz.doc_id      = doccob.doc_id
                            inner join Empresa                        on cobz.emp_id      = Empresa.emp_id 
                            left  join Legajo lgjcob                  on cobz.lgj_id      = lgjcob.lgj_id
                            left  join FacturaVentaCobranza fvcob     on cobz.cobz_id     = fvcob.cobz_id
                            left  join FacturaVenta fv                on fvcob.fv_id      = fv.fv_id
                            left  join Documento docfv                on fv.doc_id        = docfv.doc_id
                            left  join Moneda m                       on fv.mon_id        = m.mon_id
                            left  join Legajo lgjfv                   on fv.lgj_id        = lgjfv.lgj_id
      where 
      
                cobz_fecha >= @@Fini
            and  cobz_fecha <= @Ffin 
      
            and cobz.est_id <> 7
      
            and (
                  exists(select * from EmpresaUsuario where emp_id = cobz.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
             and (
                  exists(select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (cli.cli_id = @cli_id or @cli_id=0)
      and   (Sucursal.suc_id = @suc_id or @suc_id=0)
      and   (Empresa.emp_id = @emp_id or @emp_id=0) 
      
      -- Arboles
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 28 
                        and  rptarb_hojaid = cobz.cli_id
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
                        and  tbl_id = 1007 
                        and  rptarb_hojaid = cobz.suc_id
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
                        and  tbl_id = 1018 
                        and  rptarb_hojaid = cobz.emp_id
                       ) 
                 )
              or 
                 (@ram_id_Empresa = 0)
             )
      
      union all
      
      --////////////////////////////////////////////////////////////////////////////////////////////////////////
      
      select 
      
        nc.doct_id                as doct_id_cobz,
        fv.doct_id                as doct_id,
        nc.fv_id                   as cobz_id,
        fv.fv_id                  as comp_id,
      
        cli_nombre                as Cliente,
        nc.fv_fecha                as [Cobranza/NC Fecha],
        docnc.doc_nombre          as [Cobranza/NC],
        emp_nombre                as [Empresa], 
        nc.fv_nrodoc              as [Cobranza/NC Comprobante],
        nc.fv_numero              as [Cobranza/NC Numero],
        nc.fv_total               as [Cobranza/NC Total],
        nc.fv_pendiente           as [Cobranza/NC Pendiente],
        lgjnc.lgj_codigo          as [Cobranza/NC Legajo],
        fv.fv_fecha               as [Factura Fecha],
        docfv.doc_nombre          as [Documento de Venta],
        fv.fv_nrodoc              as [Factura Comprobante],
        fv.fv_numero              as [Factura Numero],
        mon_nombre                as [Moneda],
        fvnc_importe              as [Aplicacion],
        fv.fv_total               as [Factura Total],
        0                         as [Factura Pendiente],
        lgjfv.lgj_codigo          as [Factura Legajo],
        0                         as Orden
        
      
      from
      
        FacturaVenta nc     inner join Cliente cli                     on nc.cli_id             = cli.cli_id
                            inner join Sucursal                       on nc.suc_id            = Sucursal.suc_id
                            inner join Documento docnc                on nc.doc_id            = docnc.doc_id
                            inner join Empresa                        on docnc.emp_id         = Empresa.emp_id 
                            left  join Legajo lgjnc                   on nc.lgj_id            = lgjnc.lgj_id
                            left  join FacturaVentaNotaCredito fvnc   on nc.fv_id             = fvnc.fv_id_notacredito
                            left  join FacturaVenta fv                on fvnc.fv_id_factura   = fv.fv_id
                            left  join Documento docfv                on fv.doc_id            = docfv.doc_id
                            left  join Moneda m                       on fv.mon_id            = m.mon_id
                            left  join Legajo lgjfv                   on fv.lgj_id            = lgjfv.lgj_id
      where 
      
                nc.fv_fecha >= @@Fini
            and  nc.fv_fecha <= @Ffin 
      
            and nc.est_id <> 7
            and docnc.doct_id = 7 /* 7  Nota de Credito Venta */
      
            and (
                  exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
             and (
                  exists(select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (cli.cli_id = @cli_id or @cli_id=0)
      and   (nc.suc_id = @suc_id or @suc_id=0)
      and   (nc.emp_id = @emp_id or @emp_id=0) 
      
      -- Arboles
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 28 
                        and  rptarb_hojaid = nc.cli_id
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
                        and  tbl_id = 1007 
                        and  rptarb_hojaid = nc.suc_id
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
                        and  tbl_id = 1018 
                        and  rptarb_hojaid = nc.emp_id
                       ) 
                 )
              or 
                 (@ram_id_Empresa = 0)
             )
      
      --////////////////////////////////////////////////////////////////////////////////////////////////////////
      union all
      
      select 
      
        0                          as doct_id_cobz,
        fv.doct_id                as doct_id,
        0                          as cobz_id,
        fv.fv_id                  as comp_id,
      
        cli_nombre                as Cliente,
        convert(datetime,'19000101')
                                  as [Cobranza/NC Fecha],
        ''                        as [Cobranza/NC],
        emp_nombre                as [Empresa], 
        ''                        as [Cobranza/NC Comprobante],
        null                       as [Cobranza/NC Numero],
        0                          as [Cobranza/NC Total],
        0                          as [Cobranza/NC Pendiente],
        ''                        as [Cobranza/NC Legajo],
        fv_fecha                  as [Factura Fecha],
        docfv.doc_nombre          as [Documento de Venta],
        fv_nrodoc                 as [Factura Comprobante],
        fv_numero                 as [Factura Numero],
        mon_nombre                as [Moneda],
        fv_total - fv_pendiente    as [Aplicacion],
        fv_total                  as [Factura Total],
        fv_pendiente              as [Factura Pendiente],
        lgjfv.lgj_codigo          as [Factura Legajo],
        1                         as Orden
      
      from
      
        FacturaVenta fv         inner join Cliente cli                     on fv.cli_id       = cli.cli_id
                                inner join Sucursal                       on fv.suc_id      = Sucursal.suc_id
                                inner join Documento docfv                on fv.doc_id      = docfv.doc_id
                                inner join Empresa                        on docfv.emp_id   = Empresa.emp_id 
                                inner join Moneda m                       on fv.mon_id      = m.mon_id
                                left  join Legajo lgjfv                   on fv.lgj_id      = lgjfv.lgj_id
      where 
      
                fv_fecha >= @@Fini
            and  fv_fecha <= @Ffin 
      
            and round(fv_pendiente,2) > 0
            and docfv.doct_id <> 7 /* 7  Nota de Credito Venta */
            and fv.est_id <> 7
      
            and (
                  exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
             and (
                  exists(select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (cli.cli_id = @cli_id or @cli_id=0)
      and   (fv.suc_id = @suc_id or @suc_id=0)
      and   (fv.emp_id = @emp_id or @emp_id=0) 
      
      -- Arboles
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
                 (@ram_id_Cliente = 0)
             )
      
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 1007 
                        and  rptarb_hojaid = fv.suc_id
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
                        and  tbl_id = 1018 
                        and  rptarb_hojaid = fv.emp_id
                       ) 
                 )
              or 
                 (@ram_id_Empresa = 0)
             )

--///////////////////////////////////////////////////////////////

order by

  Cliente, Orden, [Cobranza/NC Fecha], [Factura Fecha], [Cobranza/NC Comprobante]


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
