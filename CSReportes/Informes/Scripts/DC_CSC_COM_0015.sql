/*---------------------------------------------------------------------
Nombre: Facturas a Pagar
---------------------------------------------------------------------*/

/*
Para testear:

select * from proveedor where prov_nombre like '%argent%'

[DC_CSC_COM_0015] 1,'20050101 00:00:00','20071231 00:00:00','0','0','0',1,'0',0

DC_CSC_COM_0015 
                    1,
                    @@Fini,
                    @@Fini,
                    '0',
                    '0',
                    '0',
                    1,
                    '2',
                    2


 [DC_CSC_COM_0015] 1,'20050101 00:00:00','20051231 00:00:00','0','0','0','1',-1,'2',3


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0015]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0015]

go
create procedure [dbo].[DC_CSC_COM_0015] (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@prov_id        varchar(255),
  @@suc_id         varchar(255),
  @@cue_id         varchar(255), 
  @@cico_id        varchar(255),
  @@soloDeudores  smallint,
  @@emp_id         varchar(255),
  @@nTipo         tinyint = 0  /*
                                        0 - Saldo inicial y movimientos en el periodo
                                        1 - Saldos agrupados por proveedor, empresa, cuenta y sucursal
                                        2 - Saldos por proveedor 
                                        3 - Saldos entre fechas
                                */
)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id  int
declare @suc_id   int
declare @cue_id   int
declare @cico_id  int
declare @emp_id   int 

declare @ram_id_Proveedor int
declare @ram_id_Sucursal   int
declare @ram_id_Cuenta     int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_Cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
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

if @ram_id_circuitocontable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
  end else 
    set @ram_id_circuitocontable = 0
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

declare @cta_acreedor    tinyint set @cta_acreedor    = 2
declare @cta_acreedoropg tinyint set @cta_acreedoropg = 5

--/////////////////////////////////////////////////////////////////////////
--
--  Saldos Iniciales
--
--/////////////////////////////////////////////////////////////////////////

create table #DC_CSC_COM_0015 (

  prov_id          int not null,
  cue_id          int null,
  emp_id          int not null,
  suc_id          int not null,
  neto            decimal(18,6) not null default(0),
  descuento       decimal(18,6) not null default(0),
  subtotal        decimal(18,6) not null default(0),
  iva             decimal(18,6) not null default(0),
  total           decimal(18,6) not null default(0),
  pago            decimal(18,6) not null default(0),
  pendiente       decimal(18,6) not null,
  contabilizado    decimal(18,6) not null default(0),
  as_id            int
)
--/////////////////////////////////////////////////////////////////////////

--//////////////////////////////////////////
-- Ordenes de Pago
--//////////////////////////////////////////


    insert into #DC_CSC_COM_0015 (as_id,prov_id,cue_id,emp_id,suc_id,pago,pendiente)
    
    select 
            opg.as_id,
            prov_id,
            (select min(cue_id) from OrdenPagoItem where opg_id = opg.opg_id and opgi_tipo = 5),
            doc.emp_id,
            suc_id,
            opg_total,
            case when @@nTipo = 0 then -opg_pendiente
                 else
                      -(opg_total - isnull((select sum(fcopg_importe) 
                                        from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc
                                                                           on fcopg.fc_id = fc.fc_id      
                                                    inner join documento doc on fc.doc_id = doc.doc_id    
              
                                        where fcopg.opg_id = opg.opg_id
              
                                          and fc.est_id <> 7
                                          and (doc.cico_id = @cico_id or @cico_id = 0)
                                          and (doc.emp_id = @emp_id or @emp_id = 0)
              
                                          and (
                                                (fc.fc_fecha <= @@Fini and @@nTipo <> 3)
                                              or
                                                (fc.fc_fecha <= @@Ffin and @@nTipo = 3)
                                              )
                                      ),0))
            end
    
    from 
    
      OrdenPago opg   inner join Documento doc                          on opg.doc_id   = doc.doc_id
    
    where 
              (      (opg_fecha < @@Fini  and @@nTipo = 0) 
                or  (opg_fecha <= @@Fini and @@nTipo in (1,2)) 
                or   (      opg_fecha >= @@Fini
                      and  opg_fecha <= @@Ffin
                      and @@nTipo = 3
                    )
              )
    
          and opg.est_id <> 7

          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (opg.prov_id  = @prov_id  or @prov_id =0)
    and   (opg.suc_id   = @suc_id   or @suc_id  =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    
    and   (exists(
                  select * from OrdenPagoItem where opg_id       = opg.opg_id 
                                                and opgi_tipo   = @cta_acreedoropg
                                                and cue_id       = @cue_id   
                  )
            or @cue_id  =0
          )
    
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 29 
                      and  rptarb_hojaid = opg.prov_id
                     ) 
               )
            or 
               (@ram_id_Proveedor = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1007 
                      and  rptarb_hojaid = opg.suc_id
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
                      and  tbl_id = 17 
                      and  (
                            exists(
                                  select * from OrdenPagoItem where opg_id       = opg.opg_id 
                                                                and opgi_tipo   = @cta_acreedoropg
                                                                and cue_id       = rptarb_hojaid   
                                  )
                             ) 
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
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitocontable = 0)
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
               (@ram_id_Empresa = 0)
           )  

--//////////////////////////////////////////
-- Facturas y Notas de Credito
--//////////////////////////////////////////

    insert into #DC_CSC_COM_0015 (as_id,prov_id,cue_id,emp_id,suc_id,neto,descuento,subtotal,iva,total,pago,pendiente)
    
    select 
            fc.as_id,
            prov_id,
            cue_id,
            doc.emp_id,
            suc_id,
            
            case fc.doct_id 
              when 8 then   - fc_neto
              else              fc_neto
            end
                          as [Neto],
        
            case fc.doct_id 
              when 8 then      - (isnull(fc_importedesc1,0) 
                               + isnull(fc_importedesc2,0)
                              )
              else             isnull(fc_importedesc1,0) 
                               + isnull(fc_importedesc2,0)
            end                
                           as [Descuento],
        
            case fc.doct_id 
              when 8  then   - fc_subtotal   
              else             fc_subtotal
            end
                            as [Sub Total],
        
            case fc.doct_id 
              when 8  then   - (isnull(fc_ivari,0)
                              + isnull(fc_ivarni,0) 
                              )
              else              isnull(fc_ivari,0)
                              + isnull(fc_ivarni,0) 
            end
                           as [Iva],
        
            case fc.doct_id 
              when 8  then   - fc_total      
              else             fc_total
            end
                           as [Total],    
    
            case
      
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      
               and fc.doct_id = 8            then   -fc_total
        
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      
               and fc.doct_id <> 8          then   fc_total

              else                                 0
            end              as [Pagos],

            case 

              when @@nTipo = 0 and fc.doct_id = 8 then -fc_pendiente
              when @@nTipo = 0                     then  fc_pendiente
      
              when fc.doct_id = 8 then   
                            - (fc_total - IsNull((select sum(fcnc_importe) 
                                                   from FacturaCompraNotaCredito fcnc inner join FacturaCompra fc2
                                                                                     on fcnc.fc_id_factura = fc2.fc_id  
                                                      inner join documento doc on fc2.doc_id = doc.doc_id    
    
                                                   where fcnc.fc_id_notacredito = fc.fc_id
    
                                                    and fc2.est_id <> 7
                                                    and (doc.cico_id = @cico_id or @cico_id = 0)
                                                    and (doc.emp_id = @emp_id or @emp_id = 0)
    
                                                    and (
                                                            (fc2.fc_fecha <= @@Fini and @@nTipo <> 3)
                                                          or
                                                            (fc2.fc_fecha <= @@Ffin and @@nTipo = 3)
                                                        )
                                                  ),0)
                                )      
              else             (fc_total - IsNull((select sum(fcnc_importe) 
                                                   from FacturaCompraNotaCredito fcnc inner join FacturaCompra nc
                                                                                     on fcnc.fc_id_notacredito = nc.fc_id      
                                                      inner join documento doc on nc.doc_id = doc.doc_id    
    
                                                   where fcnc.fc_id_factura = fc.fc_id
    
                                                  and nc.est_id <> 7
                                                  and (doc.cico_id = @cico_id or @cico_id = 0)
                                                  and (doc.emp_id = @emp_id or @emp_id = 0)
    
                                                    and (
                                                            (nc.fc_fecha <= @@Fini and @@nTipo <> 3)
                                                          or
                                                            (nc.fc_fecha <= @@Ffin and @@nTipo = 3)
                                                        )
    
                                                   ),0)
                                         - IsNull((select sum(fcopg_importe) 
                                                   from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
                                                                                       on fcopg.opg_id = opg.opg_id      
                                                      inner join documento doc on opg.doc_id = doc.doc_id    
    
                                                   where fcopg.fc_id = fc.fc_id
    
                                                    and opg.est_id <> 7
                                                    and (doc.cico_id = @cico_id or @cico_id = 0)
                                                    and (opg.emp_id = @emp_id or @emp_id = 0)
    
                                                    and (
                                                            (opg.opg_fecha <= @@Fini and @@nTipo <> 3)
                                                          or
                                                            (opg.opg_fecha <= @@Ffin and @@nTipo = 3)
                                                        )
    
                                                   ),0)
                                )
            end
                             as [Pendiente]
    
    
    from 
    
      FacturaCompra fc inner join Documento doc                          on fc.doc_id    = doc.doc_id
                       left  join AsientoItem ai                         on fc.as_id     = ai.as_id and asi_tipo = @cta_acreedor
                      
    where 
    
              (      (fc_fecha <  @@Fini and @@nTipo = 0) 
                or  (fc_fecha <= @@Fini and @@nTipo in (1,2)) 
                or   (      fc_fecha >= @@Fini
                      and  fc_fecha <= @@Ffin
                      and @@nTipo = 3
                    )
              )
    
          and fc.est_id <> 7
          and fc_totalcomercial <> 0 

          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (fc.prov_id   = @prov_id   or @prov_id  =0)
    and   (fc.suc_id     = @suc_id   or @suc_id  =0)
    and   (ai.cue_id     = @cue_id   or @cue_id  =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
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
               (@ram_id_Proveedor = 0)
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
               (@ram_id_Sucursal = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 17 
                      and  rptarb_hojaid = ai.cue_id
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
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitocontable = 0)
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
               (@ram_id_Empresa = 0)
           )

    insert into #DC_CSC_COM_0015 (as_id,prov_id,cue_id,emp_id,suc_id,neto,descuento,subtotal,iva,total,pago,pendiente)
    
    select 
    
            fc.as_id,
            prov_id,
            cue_id,
            doc.emp_id,
            suc_id,
            
            case fc.doct_id 
              when 8 then   - fc_neto
              else              fc_neto
            end
                          as [Neto],
        
            case fc.doct_id 
              when 8 then      - (isnull(fc_importedesc1,0) 
                               + isnull(fc_importedesc2,0)
                              )
              else             isnull(fc_importedesc1,0) 
                               + isnull(fc_importedesc2,0)
            end                
                           as [Descuento],
        
            case fc.doct_id 
              when 8  then   - fc_subtotal   
              else             fc_subtotal
            end
                            as [Sub Total],
        
            case fc.doct_id 
              when 8  then   - (isnull(fc_ivari,0)
                              + isnull(fc_ivarni,0) 
                              )
              else              isnull(fc_ivari,0)
                              + isnull(fc_ivarni,0) 
            end
                           as [Iva],
        
            case fc.doct_id 
              when 8  then   - fc_total      
              else             fc_total
            end
                           as [Total],    
    
            case
      
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      
               and fc.doct_id = 8            then   -fc_total
        
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      
               and fc.doct_id <> 8          then   fc_total

              else                                 0
            end              as [Pagos],

            case
      
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      then   0
        
              when fc_totalcomercial = 0 
               and (    fc_fechavto >= getdate()  
                     or fc_fechavto >= @@Ffin
                    )
                and fc.doct_id = 8          then   -fc_total
    
              when fc_totalcomercial = 0 
               and (    fc_fechavto >= getdate()  
                     or fc_fechavto >= @@Ffin
                    )
                and fc.doct_id <> 8          then   fc_total
        
            end
                             as [Pendiente]
    
    
    from 
    
      FacturaCompra fc inner join Documento doc                          on fc.doc_id    = doc.doc_id
                       left  join AsientoItem ai                         on fc.as_id     = ai.as_id and asi_tipo = @cta_acreedor
                      
    where 
    
              (      (fc_fecha <  @@Fini and @@nTipo = 0) 
                or  (fc_fecha <= @@Fini and @@nTipo in (1,2)) 
                or   (      fc_fecha >= @@Fini
                      and  fc_fecha <= @@Ffin
                      and @@nTipo = 3
                    )
              )
    
          and fc.est_id <> 7

          and fc_totalcomercial = 0 

          and (case 
    
                when fc_totalcomercial = 0 
                 and fc_fechavto < getdate()
                 and fc_fechavto < @@Ffin      then   0
          
                /* aca no importa si es fc o nc, sino que sea <> 0 */
                when fc_totalcomercial = 0 
                 and (    fc_fechavto >= getdate()  
                       or fc_fechavto >= @@Ffin
                      )                        then   -fc_total
    
              end)<> 0
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (fc.prov_id   = @prov_id   or @prov_id  =0)
    and   (fc.suc_id     = @suc_id   or @suc_id  =0)
    and   (ai.cue_id     = @cue_id   or @cue_id  =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
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
               (@ram_id_Proveedor = 0)
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
               (@ram_id_Sucursal = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 17 
                      and  rptarb_hojaid = ai.cue_id
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
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitocontable = 0)
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
               (@ram_id_Empresa = 0)
           )

--/////////////////////////////////////////////////////////////////////////

  --/////////////////////////////////////////////////////////////////////////
  -- Solo Saldos
  --/////////////////////////////////////////////////////////////////////////
  if @@nTipo <> 0 begin

    if @@nTipo = 1 begin

      --/////////////////////////////////////
      -- Saldos iniciales
      --/////////////////////////////////////
      select     
              1                  as grp_total,
              @@Fini             as [Fecha],
              emp_nombre         as [Empresa], 
              prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
                                 as [Proveedor],
              cue_nombre         as [Cuenta],
              suc_nombre         as [Sucursal],
              sum(neto)           as [Neto],
              sum(descuento)     as [Descuento],
              sum(subtotal)       as [Sub Total],
              sum(iva)           as [Iva],
              sum(total)         as [Total],
              sum(pago)           as [Pagos],
              sum(pendiente)     as [Pendiente],
              sum(pendiente)     as [Vto. Pendiente]
      
      from 
      
        #DC_CSC_COM_0015 fc 
                        inner join Proveedor prov                         on fc.prov_id   = prov.prov_id
                        inner join Empresa emp                            on fc.emp_id    = emp.emp_id 
                        inner join Sucursal suc                           on fc.suc_id    = suc.suc_id
                        left  join Cuenta cue                             on fc.cue_id    = cue.cue_id
      group by 
      
              fc.prov_id,
              prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel,
              emp_nombre,
              cue_nombre,
              suc_nombre

      having (abs(sum(pendiente))>0.01 or @@soloDeudores = 0)
  
      order by
              Proveedor,
              emp_nombre,
              cue_nombre,
              suc_nombre

    end else begin

      update #DC_CSC_COM_0015 
        set contabilizado = isnull(
                             (select sum(asi_debe-asi_haber) 
                             from AsientoItem asi inner join Asiento ast on asi.as_id = ast.as_id
                             where asi.as_id = #DC_CSC_COM_0015.as_id 
                               and cue_id = #DC_CSC_COM_0015.cue_id
                               and as_fecha between @@Fini and @@Ffin
                                ),0)

      --/////////////////////////////////////
      -- Saldos iniciales
      --/////////////////////////////////////
      select     
              1                  as grp_total,
              @@Fini             as [Fecha],
              prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
                                 as [Proveedor],
              cue_nombre         as [Cuenta],
              
              sum(neto)           as [Neto],
              sum(descuento)     as [Descuento],
              sum(subtotal)       as [Sub Total],
              sum(iva)           as [Iva],
              sum(total)         as [Total],
              sum(pago)           as [Pagos],
              sum(pendiente)     as [Pendiente],
              sum(pendiente)     as [Vto. Pendiente],
              sum(contabilizado) as Contabilizado
      
      from 
      
        #DC_CSC_COM_0015 fc 
                        inner join Proveedor prov     on fc.prov_id = prov.prov_id
                        left  join Cuenta cue         on fc.cue_id   = cue.cue_id
      group by 
      
              fc.prov_id,
              prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel,
              cue_nombre

      having (abs(sum(pendiente))>0.01 or @@soloDeudores = 0)


      order by
              Proveedor
    end

  --/////////////////////////////////////////////////////////////////////////
  -- Saldo y Periodo
  --/////////////////////////////////////////////////////////////////////////
  end else begin

    --/////////////////////////////////////////////////////////////////////////
    --
    --  Facturas, Notas de Credio/Debito y Ordenes de Pago en el Periodo
    --
    --/////////////////////////////////////////////////////////////////////////

    
    --/////////////////////////////////////
    -- Saldos iniciales
    --/////////////////////////////////////
    select 
    
            1                  as grp_total,
            0                   as doct_id,
            0                  as comp_id,
            0                  as nOrden_id,
            'Saldo Inicial'     as Documento,
            @@Fini             as [Fecha],
            ''                 as [Numero],
            'Saldo inicial'    as [Comprobante],
            prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
                               as [Proveedor],
    
            sum(neto)           as [Neto],
            sum(descuento)     as [Descuento],
            sum(subtotal)       as [Sub Total],
            sum(iva)           as [Iva],
            sum(total)         as [Total],
            sum(pago)           as [Pagos],
            sum(pendiente)     as [Pendiente],
    
            ''                 as [Moneda],
            ''                 as [Estado],
            cue_nombre         as [Cuenta],
            ''                 as [Documento],
            emp_nombre         as [Empresa], 
            suc_nombre         as [Sucursal],
            ''                 as [Cond. Pago],
            ''                 as [Legajo],
            ''                 as [Centro de Costo],
            ''                 as [Vto.],
            0                  as [Vto. Importe],
            sum(pendiente)     as [Vto. Pendiente],
            ''                 as [Observaciones]
    
    from 
    
      #DC_CSC_COM_0015 fc 
                      inner join Proveedor prov                         on fc.prov_id   = prov.prov_id
                      inner join Empresa emp                            on fc.emp_id    = emp.emp_id 
                      inner join Sucursal suc                           on fc.suc_id    = suc.suc_id
                      left  join Cuenta cue                             on fc.cue_id     = cue.cue_id

    group by 

            fc.prov_id,    
            prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel,
            cue_nombre,
            suc_nombre,
            emp_nombre

    having (abs(sum(pendiente))>0.01 or @@soloDeudores = 0)

    union all
    
    --/////////////////////////////////////
    --  Facturas, Notas de Credio/Debito
    --/////////////////////////////////////
    
    select 
            1                  as grp_total,
            fc.doct_id         as doct_id,
            fc.fc_id           as comp_id,
            1                  as nOrden_id,
            doc_nombre         as Documento,
            fc_fecha           as [Fecha],
            fc_numero          as [Numero],
            fc_nrodoc          as [Comprobante],
            prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
                               as [Proveedor],
    
            case fc.doct_id 
              when 8 then -fc_neto            
              else         fc_neto
            end                as [Neto],
    
            case fc.doct_id 
              when 8 then -(  fc_importedesc1 
                            + fc_importedesc2  
                            )
              else            fc_importedesc1 
                            + fc_importedesc2
            end         as [Descuento],
    
            case fc.doct_id 
              when 8 then    -fc_subtotal        
              else           fc_subtotal
            end        as [Sub Total],
    
            case fc.doct_id 
              when 8 then  - (fc_ivari + fc_ivarni)
              else           fc_ivari + fc_ivarni 
            end        as [Iva],
    
            case fc.doct_id 
              when 8 then  -  fc_total           
              else          fc_total
            end        as [Total],

            case
      
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      
               and fc.doct_id = 8            then   -fc_total
        
              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      
               and fc.doct_id <> 8          then   fc_total

              else                                 0
            end              as [Pagos],
    
            case fc.doct_id 
              when 8 then - fc_pendiente       
              else          fc_pendiente
            end        as [Pendiente],
    
            mon_nombre         as [Moneda],
            est_nombre         as [Estado],
            cue_nombre         as [Cuenta],
            doc_nombre         as [Documento],
            emp_nombre         as Empresa, 
            suc_nombre         as [Sucursal],
            cpg_nombre         as [Cond. Pago],
            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
            ccos_nombre        as [Centro de Costo],
            case 
                when fcd_fecha is not null then fcd_fecha
                else                            fcp_fecha
            end                as [Vto.],
    
            case fc.doct_id 
              when 8 then  - (IsNull(fcd_importe,fcp_importe))
              else           IsNull(fcd_importe,fcp_importe)
            end                 as [Vto. Importe],

            case 

              when fc_totalcomercial = 0 
               and fc_fechavto < getdate()
               and fc_fechavto < @@Ffin      then   0
        
              when fc_totalcomercial = 0 
               and (    fc_fechavto >= getdate()  
                     or fc_fechavto >= @@Ffin
                    )
                and fc.doct_id = 8          then   -fc_total
    
              when fc_totalcomercial = 0 
               and (    fc_fechavto >= getdate()  
                     or fc_fechavto >= @@Ffin
                    )
                and fc.doct_id <> 8          then   fc_total
        
              when fc.doct_id= 8             then  - (IsNull(fcd_pendiente,0))
              else                                    IsNull(fcd_pendiente,0)
            end                as [Vto. Pendiente],
                
            fc_descrip         as [Observaciones]
    
    from 
    
      FacturaCompra fc inner join Proveedor prov                         on fc.prov_id   = prov.prov_id
                       left  join FacturaCompraDeuda fcd                 on fc.fc_id      = fcd.fc_id
                       left  join FacturaCompraPago fcp                 on fc.fc_id      = fcp.fc_id
                       left  join AsientoItem ai                         on fc.as_id     = ai.as_id and asi_tipo = @cta_acreedor
                       left  join Cuenta cue                            on ai.cue_id    = cue.cue_id
                       inner join Moneda mon                            on fc.mon_id    = mon.mon_id
                       inner join Estado est                            on fc.est_id    = est.est_id
                       inner join Documento doc                         on fc.doc_id    = doc.doc_id
                       inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
                       inner join Sucursal suc                          on fc.suc_id    = suc.suc_id
                       left  join Legajo lgj                            on fc.lgj_id    = lgj.lgj_id
                       inner join CondicionPago cpg                     on fc.cpg_id    = cpg.cpg_id
                       left  join CentroCosto ccos                      on fc.ccos_id   = ccos.ccos_id
    where 
    
              fc_fecha >= @@Fini
          and  fc_fecha <= @@Ffin     
    
          and fc.est_id <> 7

          and (abs(fc_pendiente)>0.01 or @@soloDeudores = 0)
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (fc.prov_id   = @prov_id   or @prov_id  =0)
    and   (fc.suc_id    = @suc_id    or @suc_id   =0)
    and   (ai.cue_id    = @cue_id    or @cue_id   =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id    or @emp_id   =0) 
    
    -- Arboles
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
               (@ram_id_Proveedor = 0)
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
               (@ram_id_Sucursal = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 17 
                      and  rptarb_hojaid = ai.cue_id
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
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitocontable = 0)
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
               (@ram_id_Empresa = 0)
           )
    
    --/////////////////////////////////////
    --  Ordenes de Pago
    --/////////////////////////////////////
    
    union all
    
    select 
            1                  as grp_total,
            opg.doct_id        as doct_id,
            opg.opg_id         as comp_id,
            1                  as nOrden_id,
            doc_nombre         as Documento,
            opg_fecha          as [Fecha],
            opg_numero         as [Numero],
            opg_nrodoc         as [Comprobante],
            prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel        
                               as [Proveedor],
            0                  as [Neto],
            0                  as [Descuento],
            0                   as [Sub Total],
             0                  as [Iva],
            0                   as [Total],
            opg_total           as [Pagos],
            -opg_pendiente     as [Pendiente],
    
            ''                 as [Moneda],
            est_nombre         as [Estado],
            (select min(cue_nombre) 
             from OrdenPagoItem opgi inner join cuenta cue on opgi.cue_id = cue.cue_id
             where opg_id = opg.opg_id and opgi_tipo = 5)
                               as [Cuenta],
            doc_nombre         as [Documento],
            emp_nombre         as Empresa, 
            suc_nombre         as [Sucursal],
            ''                 as [Cond. Pago],
            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
            ccos_nombre        as [Centro de Costo],
            opg_fecha          as [Vto.],
            0                   as [Vto.],
            -opg_pendiente     as [Vto. Pendiente],
                
            opg_descrip        as [Observaciones]
    
    from 
    
      OrdenPago opg    inner join Proveedor prov                         on opg.prov_id   = prov.prov_id
                       inner join Estado est                            on opg.est_id   = est.est_id
                       inner join Documento doc                         on opg.doc_id   = doc.doc_id
                       inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
                       inner join Sucursal suc                          on opg.suc_id   = suc.suc_id
                       left  join Legajo lgj                            on opg.lgj_id   = lgj.lgj_id
                       left  join CentroCosto ccos                      on opg.ccos_id  = ccos.ccos_id
    where 
    
              opg_fecha >= @@Fini
          and  opg_fecha <= @@Ffin     
    
          and opg.est_id <> 7

          and (abs(opg_pendiente)>0.01 or @@soloDeudores = 0)
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (opg.prov_id   = @prov_id   or @prov_id  =0)
    and   (opg.suc_id   = @suc_id   or @suc_id  =0)
    and   (exists(
                  select * from OrdenPagoItem where opg_id       = opg.opg_id 
                                                and opgi_tipo   = @cta_acreedoropg
                                                and cue_id      = @cue_id   
                  )
            or @cue_id  =0
          )
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 29 
                      and  rptarb_hojaid = opg.prov_id
                     ) 
               )
            or 
               (@ram_id_Proveedor = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1007 
                      and  rptarb_hojaid = opg.suc_id
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
                      and  tbl_id = 17 
                      and  (
                            exists(
                                  select * from OrdenPagoItem where opg_id       = opg.opg_id 
                                                                and opgi_tipo   = @cta_acreedoropg
                                                                and cue_id      = rptarb_hojaid   
                                  )
                             ) 
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
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitocontable = 0)
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
               (@ram_id_Empresa = 0)
           )
    
      order by Proveedor, Cuenta, Fecha, nOrden_id
  
  end

end

GO