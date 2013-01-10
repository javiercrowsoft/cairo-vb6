
/*---------------------------------------------------------------------
Nombre: Libro de I.V.A. Compras
---------------------------------------------------------------------*/
/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0010]

/*

select * from circuitocontable

[DC_CSC_CON_0010] 70,'20051001 00:00:00','20051031 00:00:00','1','5'


*/
go
create procedure DC_CSC_CON_0010 (

  @@us_id      int,
  @@Fini        datetime,
  @@Ffin        datetime,
  @@cico_id   varchar(255), 
  @@emp_id    varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cico_id int
declare @emp_id   int 

declare @ram_id_CircuitoContable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_CircuitoContable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_CircuitoContable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_CircuitoContable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CircuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CircuitoContable, @clienteID 
  end else 
    set @ram_id_CircuitoContable = 0
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

/*

-- Manejo de compras sin IVA
--
-- Para que el sistema resuma las compras
-- con iva no gravado en una tasa impositiva
-- se debe crear una tasa impositiva con porcentaje 0
-- puede llamarce por ejemplo IVA Compras No Gravado
--
-- Esta tasa debe ser la primera tasa creada con porcentaje 0
-- ya que el sistema la obtiene por min(ti_id) where ti_porcentaje = 0
--
-- Si quieren separa el iva exento (el de proveedores que no cobran iva)
-- del iva no gravado deben crear otra tasa con porcentaje 0 y llamarla 
-- por ejemplo IVA Compras Exento

declare @ti_id_iva_exento int

create table #t_producto_tasa (pr_id int, ti_id int, ti_porcentaje decimal(18,6))

insert into #t_producto_tasa
select pr_id, ti_id_ivaricompra, ti_porcentaje
from Producto inner join TasaImpositiva on ti_id_ivaricompra = ti_id

select @ti_id_iva_exento = min (ti_id) from TasaImpositiva where ti_porcentaje = 0 and ti_tipo = 2 and ti_id > 0

-- Fin manejo compras sin IVA
*/
    --------------------------------------------------------------------------------------------------
    -- TRATAMIENTO DE PERIODOS SIN MOVIMIENTOS
    --------------------------------------------------------------------------------------------------

    create table #t_DC_CSC_CON_0010 (col_dummy tinyint)

    if not exists(select fc.fc_id

                  from FacturaCompra fc     inner join Documento d on fc.doc_id   = d.doc_id
                  where 
                            fc_fechaiva >= @@Fini
                        and  fc_fechaiva <= @@Ffin 
              
                        and (
                              exists(select * 
                                     from EmpresaUsuario 
                                     where emp_id = d.emp_id 
                                       and us_id = @@us_id) 
                              or (@@us_id = 1)
                            )
                  
                  /* -///////////////////////////////////////////////////////////////////////
                  
                  INICIO SEGUNDA PARTE DE ARBOLES
                  
                  /////////////////////////////////////////////////////////////////////// */
                  
                  and   (d.cico_id = @cico_id or @cico_id=0)
                  and   (d.emp_id  = @emp_id  or @emp_id=0) 
                  
                  -- Arboles
                  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and  rptarb_hojaid = d.cico_id)) or (@ram_id_CircuitoContable = 0))
                  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = d.emp_id))  or (@ram_id_Empresa = 0))
              )
    begin

      insert into #t_DC_CSC_CON_0010 (col_dummy) values(1)

    end


    select 
          0                                  as comp_id,
          @@Fini                             as Fecha,
          @@Fini                             as [Fecha IVA],
          ''                                 as Documento,
          ''                                as Empresa, 
          ''                                as Comprobante,
          'Mes sin movimientos'              as Proveedor,
          ''                                as CUIT,
          ''                                as [Condicion IVA],
    
          ''                                as [Condicion IVA2],
    
          0                                         as Neto,    
          0                                       as Base,    
          0                                       as [Base Iva],    
          0                                        as [Tasa Iva],    
          0                                       as [Importe Iva],
          0                                        as [Importe interno],
          ''                                      as Concepto,    
          0                                        as [Importe concepto],    
          0                                       as Total,
          0                                       as Orden,
          1                                       as Orden2

    from #t_DC_CSC_CON_0010

    union all

    --------------------------------------------------------------------------------------------------
    -- FACTURAS DEL PERIODO
    --------------------------------------------------------------------------------------------------

    select 
          fc.fc_id                                  as comp_id,
          fc_fecha                                  as Fecha,
          fc_fechaiva                               as [Fecha IVA],
          case d.doct_id
            when 2  then 'FAC'
            when 8  then 'NC'
            when 10 then 'ND'
          end                                        as Documento,
          emp_nombre                                as Empresa, 
          fc_nrodoc                                  as Comprobante,
          prov_razonsocial                           as Proveedor,
          prov_cuit                                  as CUIT,
          case prov_catfiscal
            when 1  then 'Inscripto'
            when 2  then 'Exento'
            when 3  then 'No inscripto'
            when 4  then 'Consumidor Final'
            when 5  then 'Extranjero'
            when 6  then 'Mono Tributo'
            when 7  then 'Extranjero Iva'
            when 8  then 'No responsable'
            when 9  then 'No Responsable exento'
            when 10 then 'No categorizado'
            when 11 then 'Inscripto M'
            else          'Sin categorizar'
          end                                        as [Condicion IVA],
    
          case prov_catfiscal
            when 1  then 'IN'
            when 2  then 'EX'
            when 3  then 'NI'
            when 4  then 'CF'
            when 5  then 'EJ'
            when 6  then 'M'
            when 7  then 'EJI'
            when 8  then 'NR'
            when 9  then 'NRE'
            when 10 then 'NC'
            when 11 then 'IM'
            else          'SC'
          end                                        as [Condicion IVA2],
    
          case d.doct_id
            when 8  then -fc_neto
            else          fc_neto
          end                                         as Neto,
    
          case sum(fci_ivari)
              when 0 then                  0
              else
                          case d.doct_id
                            when 8  then -sum(fci_neto
                                                - (fci_neto * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                              )
                            else         sum(fci_neto
                                                - (fci_neto * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                            )
                          end
          end                                       as Base,
    
          case sum(fci_ivari)
              when 0 then                  0
              else
                          case d.doct_id
                            when 8  then -sum(fci_neto
                                                - (fci_neto * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                              )
                            else         sum(fci_neto
                                                - (fci_neto * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                            )
                          end
          end                                       as [Base Iva],
    
          fci_ivariporc                              as [Tasa Iva],
    
          case sum(fci_ivari)
              when 0 then                  0
              else
                          case d.doct_id
                            when 8  then -sum(fci_ivari
                                                - (fci_ivari * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_ivari - (fci_ivari * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                              )
                            else         sum(fci_ivari
                                                - (fci_ivari * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_ivari - (fci_ivari * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                            )
                          end
          end                                       as [Importe Iva],
          0                                          as [Importe interno],
          ''                                        as Concepto,
    
          case sum(fci_ivari)
              when 0 then    
                          case d.doct_id
                            when 8  then -sum(fci_neto
                                                - (fci_neto * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                              )
                            else          sum(fci_neto
                                                - (fci_neto * fc_descuento1 / 100)
                                                - (
                                                    (
                                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                                    ) * fc_descuento2 / 100
                                                  )
                                              )
                          end
              else                        0
          end                                        as [Importe concepto],
    
          case d.doct_id
            when 8  then -fc_total
            else          fc_total
          end                                       as Total,
          0                                         as Orden,
          1                                         as Orden2
    
    from FacturaCompra fc     inner join Documento d                   on fc.doc_id   = d.doc_id
                              inner join Empresa                      on d.emp_id    = empresa.emp_id 
                              inner join Proveedor p                  on fc.prov_id  = p.prov_id
                              inner join FacturaCompraItem fci        on fc.fc_id    = fci.fc_id
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id <> 7 -- Anuladas
    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    group by
    
          fc.fc_id,
          fc_fecha,
          fc_fechaiva,
          doc_codigo,
          d.doct_id,
          emp_nombre,
          fc_nrodoc,
          prov_razonsocial,
          prov_cuit,
          prov_catfiscal,
          fci_ivariporc,
          fc_neto,
          fc_total
    
    union all
    
    --------------------------------------------------------------------------------------------------
    -- PERCEPCIONES
    --------------------------------------------------------------------------------------------------
    
    select 
          fc.fc_id                                  as comp_id,
          fc_fecha                                  as Fecha,
          fc_fechaiva                               as [Fecha IVA],
          case d.doct_id
            when 2  then 'FAC'
            when 8  then 'NC'
            when 10 then 'ND'
          end                                        as Documento,
          emp_nombre                                as Empresa, 
          fc_nrodoc                                  as Comprobante,
          prov_razonsocial                           as Proveedor,
          prov_cuit                                  as CUIT,
          case prov_catfiscal
            when 1  then 'Inscripto'
            when 2  then 'Exento'
            when 3  then 'No inscripto'
            when 4  then 'Consumidor Final'
            when 5  then 'Extranjero'
            when 6  then 'Mono Tributo'
            when 7  then 'Extranjero Iva'
            when 8  then 'No responsable'
            when 9  then 'No Responsable exento'
            when 10 then 'No categorizado'
            when 11 then 'Inscripto M'
            else          'Sin categorizar'
          end                                        as [Condicion IVA],
    
          case prov_catfiscal
            when 1  then 'IN'
            when 2  then 'EX'
            when 3  then 'NI'
            when 4  then 'CF'
            when 5  then 'EJ'
            when 6  then 'M'
            when 7  then 'EJI'
            when 8  then 'NR'
            when 9  then 'NRE'
            when 10 then 'NC'
            when 11 then 'IM'
            else          'SC'
          end                                        as [Condicion IVA2],
    
          0                                         as Neto,
          case d.doct_id
            when 8  then -fcperc_base
            else          fcperc_base
          end                                       as [Base],
          0                                         as [Base Iva],
          fcperc_porcentaje                          as [Tasa Iva],
          0                                          as [Importe Iva],
          case d.doct_id
            when 8  then -fcperc_importe
            else          fcperc_importe
          end                                        as [Importe interno],
          perc_nombre                               as Concepto,
          0                                         as [Importe concepto],
          0                                         as Total,
          0                                         as Orden,
          2                                         as Orden2
    
    from FacturaCompra fc     inner join Documento d                   on fc.doc_id     = d.doc_id
                              inner join Empresa                      on d.emp_id      = empresa.emp_id 
                              inner join Proveedor p                  on fc.prov_id    = p.prov_id
                              inner join FacturaCompraPercepcion fcp  on fc.fc_id      = fcp.fc_id
                              inner join Percepcion perc              on fcp.perc_id   = perc.perc_id
    
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id <> 7 -- Anuladas
    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    union all
    
    --------------------------------------------------------------------------------------------------
    -- OTROS
    --------------------------------------------------------------------------------------------------
    
    select 
          fc.fc_id                                  as comp_id,
          fc_fecha                                  as Fecha,
          fc_fechaiva                               as [Fecha IVA],
          case d.doct_id
            when 2  then 'FAC'
            when 8  then 'NC'
            when 10 then 'ND'
          end                                        as Documento,
          emp_nombre                                as Empresa, 
          fc_nrodoc                                  as Comprobante,
          prov_razonsocial                           as Proveedor,
          prov_cuit                                  as CUIT,
          case prov_catfiscal
            when 1  then 'Inscripto'
            when 2  then 'Exento'
            when 3  then 'No inscripto'
            when 4  then 'Consumidor Final'
            when 5  then 'Extranjero'
            when 6  then 'Mono Tributo'
            when 7  then 'Extranjero Iva'
            when 8  then 'No responsable'
            when 9  then 'No Responsable exento'
            when 10 then 'No categorizado'
            when 11 then 'Inscripto M'
            else          'Sin categorizar'
          end                                        as [Condicion IVA],
    
          case prov_catfiscal
            when 1  then 'IN'
            when 2  then 'EX'
            when 3  then 'NI'
            when 4  then 'CF'
            when 5  then 'EJ'
            when 6  then 'M'
            when 7  then 'EJI'
            when 8  then 'NR'
            when 9  then 'NRE'
            when 10 then 'NC'
            when 11 then 'IM'
            else          'SC'
          end                                        as [Condicion IVA2],
    
          0                                         as Neto,
          0                                          as [Base],
          0                                         as [Base Iva],
          0                                         as [Tasa Iva],
          0                                          as [Importe Iva],
          0                                          as [Importe interno],
          cue_nombre                                 as Concepto,
          case d.doct_id
            when 8  then -fcot_debe+fcot_haber
            else         +fcot_debe-fcot_haber
          end                                       as [Importe concepto],
          0                                         as Total,
          0                                         as Orden,
          2                                         as Orden2
    
    from FacturaCompra fc     inner join Documento d                   on fc.doc_id     = d.doc_id
                              inner join Empresa                      on d.emp_id      = empresa.emp_id 
                              inner join Proveedor p                  on fc.prov_id    = p.prov_id
                              inner join FacturaCompraOtro fcot       on fc.fc_id      = fcot.fc_id
                              inner join Cuenta cue                   on fcot.cue_id   = cue.cue_id
    
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id <> 7 -- Anuladas
    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    union all
    
    --------------------------------------------------------------------------------------------------
    -- ANULADAS
    --------------------------------------------------------------------------------------------------
    
    select 
          fc.fc_id                                  as comp_id,
          fc_fecha                                  as Fecha,
          fc_fechaiva                               as [Fecha IVA],
          case d.doct_id
            when 2  then 'FAC'
            when 8  then 'NC'
            when 10 then 'ND'
          end                                        as Documento,
          emp_nombre                                as Empresa, 
          fc_nrodoc                                  as Comprobante,
          'ANULADA'                                 as Cliente,
          ''                                        as CUIT,
          ''                                        as [Condicion IVA],
          ''                                        as [Condicion IVA2],
          0                                          as Neto,
          0                                         as Base,
          0                                         as [Base Iva],
          0                                          as [Tasa Iva],
          0                                          as [Importe Iva],
          0                                          as [Importe interno],
          ''                                        as Concepto,
          0                                         as [Importe concepto],
          0                                          as Total,
          0                                         as Orden,
          0                                         as Orden2
    
    from FacturaCompra fc      inner join Documento d               on fc.doc_id   = d.doc_id
                               inner join Empresa                   on d.emp_id    = Empresa.emp_id 
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id = 7 -- Anuladas
    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    --------------------------------------------------------------------------------------------------
    -- TOTAL TASAS IVA
    --------------------------------------------------------------------------------------------------
    
    union all
    
    select 
          0                                         as comp_id,
          '19900101'                                 as Fecha,
          '19000101'                                as [Fecha IVA],
          ''                                        as Documento,
          ''                                        as Empresa, 
          ''                                        as Comprobante,
          ''                                        as Proveedor,
          ''                                        as CUIT,
          ''                                        as [Condicion IVA],
          ''                                        as [Condicion IVA2],
          0                                         as Neto,
          sum(case d.doct_id
                when 8  then - (  fci_neto
                                - (fci_neto * fc_descuento1 / 100)
                                - (
                                    (
                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                    ) * fc_descuento2 / 100
                                  )
                                )
                else          fci_neto
                                - (fci_neto * fc_descuento1 / 100)
                                - (
                                    (
                                      fci_neto - (fci_neto * fc_descuento1 / 100)
                                    ) * fc_descuento2 / 100
                                  )
    
              end      
              )                                      as Base,
          0                                         as [Base Iva],

          case when fci_ivari <> 0 then fci_ivariporc 
               else                     0 
          end 
                                                    as [Tasa Iva],
          sum(case d.doct_id
                when 8  then - (  fci_ivari
                                - (fci_ivari * fc_descuento1 / 100)
                                - (
                                    (
                                      fci_ivari - (fci_ivari * fc_descuento1 / 100)
                                    ) * fc_descuento2 / 100
                                  )
                                )
                else          fci_ivari
                                - (fci_ivari * fc_descuento1 / 100)
                                - (
                                    (
                                      fci_ivari - (fci_ivari * fc_descuento1 / 100)
                                    ) * fc_descuento2 / 100
                                  )
              end      
              )                                      as [Importe Iva],
          0                                          as [Importe interno],
          case 
              when ti_codigodgi1 <> '' then ti_codigodgi1
              else                          ti_nombre
          end                                       as Concepto,
          0                                         as [Importe concepto],
          0                                         as Total,
          1                                         as Orden,
          0                                         as Orden2
    
    from FacturaCompra fc     inner join Documento d               on fc.doc_id   = d.doc_id
                              inner join Empresa                  on d.emp_id    = Empresa.emp_id 
                              inner join Proveedor p              on fc.prov_id  = p.prov_id
                              inner join FacturaCompraItem fci    on fc.fc_id    = fci.fc_id
                              inner join Producto pr              on fci.pr_id   = pr.pr_id
/*                            inner join #t_producto_tasa prt     on pr.pr_id    = prt.pr_id

                              inner join TasaImpositiva ti        on 
                                                                          (pr.ti_id_ivaricompra = ti.ti_id and (fci_ivari <> 0 or ti.ti_porcentaje = 0)) 
                                                                      or  (ti.ti_id = @ti_id_iva_exento and fci_ivari = 0 and prt.ti_porcentaje <> 0)
*/
                              inner join TasaImpositiva ti        on pr.ti_id_ivaricompra = ti.ti_id 
    
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id <> 7 -- Anuladas
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    
    group by
    
          case 
              when ti_codigodgi1 <> '' then ti_codigodgi1
              else                          ti_nombre
          end,
          case when fci_ivari <> 0 then fci_ivariporc 
               else                     0 
          end           
    
    --------------------------------------------------------------------------------------------------
    -- TOTAL TASAS PERCEPCIONES
    --------------------------------------------------------------------------------------------------
    
    union all
    
    select 
          0                                         as comp_id,
          '19900101'                                 as Fecha,
          '19000101'                                as [Fecha IVA],
          ''                                        as Documento,
          ''                                        as Empresa, 
          ''                                        as Comprobante,
          ''                                        as Proveedor,
          ''                                        as CUIT,
          ''                                        as [Condicion IVA],
          ''                                        as [Condicion IVA2],
          0                                         as Neto,
          sum(case d.doct_id
                when 8  then -fcperc_base
                else          fcperc_base
              end      
              )                                      as Base,
          0                                         as [Base Iva],
          fcperc_porcentaje                          as [Tasa Iva],
          0                                          as [Importe Iva],
          sum(case d.doct_id
                when 8  then -fcperc_importe
                else          fcperc_importe
              end      
              )                                      as [Importe interno],
          perc_nombre                                as Concepto,
          0                                         as [Importe concepto],
          0                                         as Total,
          1                                         as Orden,
          0                                         as Orden2
    
    from FacturaCompra fc     inner join Documento d                   on fc.doc_id   = d.doc_id
                              inner join Empresa                      on d.emp_id    = Empresa.emp_id 
                              inner join Proveedor p                  on fc.prov_id  = p.prov_id
                              inner join FacturaCompraPercepcion fcp  on fc.fc_id      = fcp.fc_id
                              inner join Percepcion perc              on fcp.perc_id   = perc.perc_id
    
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id <> 7 -- Anuladas
    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    
    group by
    
          perc_nombre,fcperc_porcentaje
    
    
    --------------------------------------------------------------------------------------------------
    -- TOTAL OTROS
    --------------------------------------------------------------------------------------------------
    
    union all
    
    select 
          0                                         as comp_id,
          '19900101'                                 as Fecha,
          '19000101'                                as [Fecha IVA],
          ''                                        as Documento,
          ''                                        as Empresa, 
          ''                                        as Comprobante,
          ''                                        as Proveedor,
          ''                                        as CUIT,
          ''                                        as [Condicion IVA],
          ''                                        as [Condicion IVA2],
          0                                         as Neto,
          0                                          as [Base],
          0                                         as [Base Iva],
          0                                         as [Tasa Iva],
          0                                          as [Importe Iva],
          sum(
                case d.doct_id
                  when 8  then -fcot_debe+fcot_haber
                  else         +fcot_debe-fcot_haber
                end  
          )                                          as [Importe interno],
          cue_nombre                                 as Concepto,
          0                                         as [Importe concepto],
          0                                         as Total,
          1                                         as Orden,
          0                                         as Orden2
    
    from FacturaCompra fc     inner join Documento d                   on fc.doc_id     = d.doc_id
                              inner join Empresa                      on d.emp_id      = empresa.emp_id 
                              inner join Proveedor p                  on fc.prov_id    = p.prov_id
                              inner join FacturaCompraOtro fcot       on fc.fc_id      = fcot.fc_id
                              inner join Cuenta cue                   on fcot.cue_id   = cue.cue_id
    
    where 
              fc_fechaiva >= @@Fini
          and  fc_fechaiva <= @@Ffin 
          and fc.est_id <> 7 -- Anuladas
    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (d.cico_id = @cico_id or @cico_id=0)
    and   (Empresa.emp_id = @emp_id or @emp_id=0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = d.cico_id
                     ) 
               )
            or 
               (@ram_id_CircuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = d.emp_id
                     ) 
               )
            or 
               (@ram_id_Empresa = 0)
           )
    
    group by
    
          fcot.cue_id,cue_nombre
    
    order by 
    
          orden,
          Fecha,
          Comprobante,
          Proveedor,
          orden2

end

go
