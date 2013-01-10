/*---------------------------------------------------------------------
Nombre: Saldos a Fecha de Clientes
---------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*

exec [DC_CSC_VEN_0026] 1,'20100228 00:00:00','0','0','0'

*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0026]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0026]
GO

create procedure DC_CSC_VEN_0026 (

  @@us_id    int,
  @@Fecha     datetime,

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

SALDOS

/////////////////////////////////////////////////////////////////////// */

  create table #t_DC_CSC_VEN_0026 (
  
    cli_id            int,
    emp_id           int,
    cobznc_pendiente decimal(18,6),
    fv_pendiente     decimal(18,6)
  )

    --/////////////////////////////////////
    --
    -- ORDENES DE PAGO
    --
    
    insert into #t_DC_CSC_VEN_0026
    
    select 
    
      cli_id,
      emp_id,
      cobz_total - isnull((select sum(fvcobz_importe) 
                           from FacturaVentaCobranza fvcobz inner join FacturaVenta fv
                                                              on fvcobz.fv_id = fv.fv_id      
                           where fvcobz.cobz_id = cobz.cobz_id
                             and fv.fv_fecha <= @@Fecha
                          ),0),
      0  
    
    from
    
      Cobranza cobz
    
    where 
    
              cobz.cobz_fecha < @@Fecha
          and  cobz.est_id <> 7

    ---------------------------------------------------------------------------
          and (
                exists(select * from EmpresaUsuario where emp_id = cobz.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where cli_id = cobz.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )
  
  ---------------------------------------------------------------------------
    
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
               (@ram_id_cliente = 0)
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

    -- Esto va al final por que el SQL
    -- FALLA al crear el query plan si
    -- se selecciona una rama o multiple
    -- seleccion de clientes. Al poner
    -- esto al final primero evalua el arbol
    -- y de esta forma evitamos que realize el
    -- subquery para todas las facturas
    --
    and (cobz_total - isnull((select sum(fvcobz_importe) 
                          from FacturaVentaCobranza fvcobz inner join FacturaVenta fv
                                                             on fvcobz.fv_id = fv.fv_id      
                          where fvcobz.cobz_id = cobz.cobz_id
                            and fv.fv_fecha <= @@Fecha
                        ),0)<> 0)

    --/////////////////////////////////////
    --
    -- NOTAS DE CREDITO
    --

    union all
    
    select 
    
      cli_id,
      nc.emp_id,
      fv_totalcomercial - IsNull((select sum(fvnc_importe) 
                         from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv
                                                           on fvnc.fv_id_factura = fv.fv_id      
                         where fvnc.fv_id_notacredito = nc.fv_id
                           and fv.fv_fecha <= @@Fecha
                        ),0),
      0
    
    from
    
      FacturaVenta nc inner join Documento docnc on nc.doc_id = docnc.doc_id
                          
    where 
    
              nc.fv_fecha < @@Fecha
          and docnc.doct_id = 7 /* 7  Nota de Credito Venta */
          and nc.est_id <> 7
    
    ---------------------------------------------------------------------------
          and (
                exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where cli_id = nc.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )

    ---------------------------------------------------------------------------
    
    and   (nc.cli_id   = @cli_id or @cli_id =0)
    and   (nc.suc_id    = @suc_id  or @suc_id  =0)
    and   (docnc.emp_id = @emp_id  or @emp_id  =0) 
    
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
               (@ram_id_cliente = 0)
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
                      and  rptarb_hojaid = docnc.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    -- Esto va al final por que el SQL
    -- FALLA al crear el query plan si
    -- se selecciona una rama o multiple
    -- seleccion de clientes. Al poner
    -- esto al final primero evalua el arbol
    -- y de esta forma evitamos que realize el
    -- subquery para todas las facturas
    --
    and (fv_totalcomercial - IsNull((select sum(fvnc_importe) 
                   from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv
                                                     on fvnc.fv_id_factura = fv.fv_id      
                   where fvnc.fv_id_notacredito = nc.fv_id
                     and fv.fv_fecha <= @@Fecha
                  ),0)<>0)

    --/////////////////////////////////////
    --
    -- FACTURAS
    --

    union all

    select 
    
          cli_id,
          fv.emp_id,
          0,
          fv_totalcomercial - IsNull((select sum(fvnc_importe) 
                                     from FacturaVentaNotaCredito fvnc inner join FacturaVenta nc
                                                                       on fvnc.fv_id_notacredito = nc.fv_id      
                                     where fvnc.fv_id_factura = fv.fv_id
                                       and nc.fv_fecha <= @@Fecha
                                     ),0)
                           - IsNull((select sum(fvcobz_importe) 
                                     from FacturaVentaCobranza fvcobz inner join Cobranza cobz
                                                                         on fvcobz.cobz_id = cobz.cobz_id      
                                     where fvcobz.fv_id = fv.fv_id
                                       and cobz.cobz_fecha <= @@Fecha
                                     ),0)
    
    from
    
      FacturaVenta fv inner join Documento docfv on fv.doc_id = docfv.doc_id
    
    where 
    
              fv_fecha < @@Fecha
          and docfv.doct_id <> 7 /* 7  Nota de Credito Venta */
          and fv.est_id <> 7
    
    ---------------------------------------------------------------------------
          and (
                exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )

    ---------------------------------------------------------------------------
    
    and   (fv.cli_id    = @cli_id  or @cli_id = 0)
    and   (fv.suc_id    = @suc_id  or @suc_id  = 0)
    and   (docfv.emp_id = @emp_id  or @emp_id  = 0) 
    
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
               (@ram_id_cliente = 0)
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
                      and  rptarb_hojaid = docfv.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )

    -- Esto va al final por que el SQL
    -- FALLA al crear el query plan si
    -- se selecciona una rama o multiple
    -- seleccion de clientes. Al poner
    -- esto al final primero evalua el arbol
    -- y de esta forma evitamos que realize el
    -- subquery para todas las facturas
    --
    and (fv_totalcomercial - IsNull((select sum(fvnc_importe) 
                            from FacturaVentaNotaCredito fvnc inner join FacturaVenta nc
                                                             on fvnc.fv_id_notacredito = nc.fv_id      
                            where fvnc.fv_id_factura = fv.fv_id
                              and nc.fv_fecha <= @@Fecha
                            ),0)
                  - IsNull((select sum(fvcobz_importe) 
                            from FacturaVentaCobranza fvcobz inner join Cobranza cobz
                                                               on fvcobz.cobz_id = cobz.cobz_id      
                            where fvcobz.fv_id = fv.fv_id
                              and cobz.cobz_fecha <= @@Fecha
                            ),0)<>0)

/*- //////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

  --/////////////////////////////////////
  --  
  -- SALDOS
  --

  declare @SaldoAl varchar(255)
  set @SaldoAl = 'Saldo al ' + convert(varchar(10),dateadd(d,-1,@@Fecha),110)

  select 
    1                         as orden_id,
    cli.cli_id,  
    cli_nombre                as Cliente,
    emp_nombre                as Empresa, 
    @SaldoAl                  as [Saldo al],
    sum(fv_pendiente)         as [Debe],
    sum(cobznc_pendiente)      as [Haber],
    sum(fv_pendiente)
    - sum(cobznc_pendiente)    as [Saldo]    
  
  from #t_DC_CSC_VEN_0026 t inner join Cliente cli on t.cli_id = cli.cli_id
                            inner join Empresa emp    on t.emp_id  = emp.emp_id

    group by cli.cli_id, cli_nombre, emp_nombre
  
  --///////////////////////////////////////////////////////////////
  
  order by
  
    Cliente


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
