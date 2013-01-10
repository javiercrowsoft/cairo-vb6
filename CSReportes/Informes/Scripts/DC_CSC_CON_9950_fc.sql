if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9950_fc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9950_fc]
GO
/*  

*/

create procedure DC_CSC_CON_9950_fc (

  @@us_id     int,

  @@fDesde    datetime,
  @@fHasta    datetime,
  @emp_id     int,
  @prov_id    int,
  @cue_id     int,
  @cuec_id    int,
  @ccos_id     int,
  @cico_id    int,

  @ram_id_empresa           int,
  @ram_id_proveedor         int,
  @ram_id_cuenta            int,
  @ram_id_cuentacategoria   int,
  @ram_id_centrocosto       int,
  @ram_id_circuitocontable   int,

  @clienteID   int

)as 

begin

  set nocount on

    insert into #t_fc (fc_id, ccos_id, tipo, importe)

    select distinct

          fc.fc_id,        
          isnull(fci.ccos_id,fc.ccos_id),
          case when fc.ccos_id is not null then 'factura' else 'item' end,
          case fc.doct_id 
                when 8 then -(fci_importe) 
                else          (fci_importe) 
          end

    from
    
          FacturaCompra fc        inner join FacturaCompraItem fci    on fc.fc_id     = fci.fc_id
                                  inner join Documento doc              on fc.doc_id    = doc.doc_id
    where 
    
              fc_fecha between @@fDesde and @@fHasta

          and fc.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fci.ccos_id,fc.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (fc.prov_id   = @prov_id   or @prov_id  =0) 
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fci.ccos_id,fc.ccos_id)
                     ) 
               )
            or 
               (@ram_id_centrocosto = 0)
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
               (@ram_id_empresa = 0)
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

      and exists(select 1 
                 from AsientoItem asi 
                 where fc.as_id = asi.as_id
                  and  (asi.cue_id = @cue_id or @cue_id  =0)    
                  and  (
                            (exists(select rptarb_hojaid 
                                    from rptArbolRamaHoja 
                                    where
                                         rptarb_cliente = @clienteID
                                    and  tbl_id = 17 
                                    and  rptarb_hojaid = asi.cue_id
                                   ) 
                             )
                          or 
                             (@ram_id_cuenta = 0)
                        )
                  )
    
  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras - Otros
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_fc (fc_id, ccos_id, tipo, importe)

    select distinct

          fc.fc_id,        
          isnull(fco.ccos_id,fc.ccos_id),
          'otros',
          case fc.doct_id 
                when 8 then -(fcot_debe-fcot_haber) 
                else          (fcot_debe-fcot_haber) 
          end
    from
    
          FacturaCompra fc        inner join FacturaCompraOtro fco    on fc.fc_id     = fco.fc_id
                                  inner join Documento doc              on fc.doc_id    = doc.doc_id
                                  inner join Cuenta cue               on fco.cue_id   = cue.cue_id
    where 
    
              fc_fecha between @@fDesde and @@fHasta

          and fc.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fco.ccos_id,fc.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (fc.prov_id   = @prov_id   or @prov_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fco.ccos_id,fc.ccos_id)
                     ) 
               )
            or 
               (@ram_id_centrocosto = 0)
           )

    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 19 
                      and  rptarb_hojaid = cue.cuec_id
                     ) 
               )
            or 
               (@ram_id_cuentacategoria = 0)
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
               (@ram_id_empresa = 0)
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
    
      and exists(select 1 
                 from AsientoItem asi 
                 where fc.as_id = asi.as_id
                  and  (asi.cue_id = @cue_id or @cue_id  =0)    
                  and  (
                            (exists(select rptarb_hojaid 
                                    from rptArbolRamaHoja 
                                    where
                                         rptarb_cliente = @clienteID
                                    and  tbl_id = 17 
                                    and  rptarb_hojaid = asi.cue_id
                                   ) 
                             )
                          or 
                             (@ram_id_cuenta = 0)
                        )
                  )

  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras - Percepciones
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_fc (fc_id, ccos_id, tipo, importe)

    select distinct

          fc.fc_id,        
          isnull(fcp.ccos_id,fc.ccos_id),
          'percepcion',
          case fc.doct_id 
                when 8 then -(fcperc_importe) 
                else          (fcperc_importe) 
          end

    from
    
          FacturaCompra fc        inner join FacturaCompraPercepcion fcp  on fc.fc_id     = fcp.fc_id
                                  inner join Documento doc                  on fc.doc_id    = doc.doc_id
    where 
    
              fc_fecha between @@fDesde and @@fHasta

          and fc.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fcp.ccos_id,fc.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (fc.prov_id   = @prov_id   or @prov_id  =0) 
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fcp.ccos_id,fc.ccos_id)
                     ) 
               )
            or 
               (@ram_id_centrocosto = 0)
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
               (@ram_id_empresa = 0)
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
    
      and exists(select 1 
                 from AsientoItem asi 
                 where fc.as_id = asi.as_id
                  and  (asi.cue_id = @cue_id or @cue_id  =0)    
                  and  (
                            (exists(select rptarb_hojaid 
                                    from rptArbolRamaHoja 
                                    where
                                         rptarb_cliente = @clienteID
                                    and  tbl_id = 17 
                                    and  rptarb_hojaid = asi.cue_id
                                   ) 
                             )
                          or 
                             (@ram_id_cuenta = 0)
                        )
                  )

end
GO