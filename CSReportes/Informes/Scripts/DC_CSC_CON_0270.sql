/*---------------------------------------------------------------------
Nombre: Mayor de Proveedors
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0270]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0270]


/*

 [DC_CSC_CON_0270] 1,'20070425 00:00:00','20070425 00:00:00','0','0','0','0','0','0',1,0,0

*/

go
create procedure DC_CSC_CON_0270(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id    varchar(255),
  @@cuec_id   varchar(255),
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
  @@est_id    varchar(255),
  @@emp_id    varchar(255),

  @@doc_id_mov_fondo_neg varchar(255),
  @@doc_id_mov_fondo_pos varchar(255),

  @@bSaldo      smallint,
  @@bDescrip    smallint,
  @@bDetallado   smallint
  
) 

as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  if @@doc_id_mov_fondo_pos = '0' set @@doc_id_mov_fondo_pos ='-1'
  if @@doc_id_mov_fondo_neg = '0' set @@doc_id_mov_fondo_neg ='-1'

declare @cue_id  int
declare @cuec_id int
declare @ccos_id int
declare @cico_id int
declare @est_id  int
declare @emp_id  int 

declare @doc_id_mov_fondo_pos int
declare @doc_id_mov_fondo_neg int

declare @ram_id_cuenta            int
declare @ram_id_cuentacategoria   int
declare @ram_id_centrocosto       int
declare @ram_id_circuitocontable   int
declare @ram_id_Estado             int
declare @ram_id_Empresa           int 

declare @ram_id_mov_pos       int
declare @ram_id_mov_neg       int

declare @clienteID   int
declare @clienteID2 int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,  @cue_id  out, @ram_id_cuenta out
exec sp_ArbConvertId @@cuec_id, @cuec_id out, @ram_id_cuentacategoria out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@est_id,  @est_id out,  @ram_id_Estado out
exec sp_ArbConvertId @@emp_id,   @emp_id out,   @ram_id_Empresa out 

exec sp_ArbConvertId @@doc_id_mov_fondo_pos, @doc_id_mov_fondo_pos out, @ram_id_mov_pos out
exec sp_ArbConvertId @@doc_id_mov_fondo_neg, @doc_id_mov_fondo_neg out, @ram_id_mov_neg out

exec sp_GetRptId @clienteID   out
exec sp_GetRptId @clienteID2   out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

if @ram_id_cuentacategoria <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuentacategoria, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuentacategoria, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuentacategoria, @clienteID 
  end else 
    set @ram_id_cuentacategoria = 0
end

if @ram_id_centrocosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
  end else 
    set @ram_id_centrocosto = 0
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

if @ram_id_mov_pos <> 0 begin

--  exec sp_ArbGetGroups @ram_id_mov_pos, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_mov_pos, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_mov_pos, @clienteID 
  end else 
    set @ram_id_mov_pos = 0
end

if @ram_id_mov_neg <> 0 begin

--  exec sp_ArbGetGroups @ram_id_mov_neg, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_mov_neg, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_mov_neg, @clienteID2 
  end else 
    set @ram_id_mov_neg = 0
end

if @ram_id_Estado <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
  end else 
    set @ram_id_Estado = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


create table #t_IC_NRT_CON_0270 (

  circuito_id   int not null,
  ccos_id       int null,
  emp_id        int not null,
  Neto          decimal(18,6) not null default(0),
  Iva            decimal(18,6) not null default(0),
  Total         decimal(18,6) not null default(0),
  Pagos          decimal(18,6) not null default(0),
  Cobros        decimal(18,6) not null default(0)
)


--////////////////////////////////////////////////////////////////////////
--
-- Saldo inicial
--
--////////////////////////////////////////////////////////////////////////


  if @@bSaldo <> 0 begin

  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          0,        
          isnull(fci.ccos_id,fc.ccos_id),
          doc.emp_id,

          sum(
            case fc.doct_id when 8 
                  then -  (  fci_neto 
                          - (fci_neto * (fc_descuento1/100))
                          - (
                              (fci_neto * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          )
                  else (  fci_neto 
                          - (fci_neto * (fc_descuento1/100))
                          - (
                              (fci_neto * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          ) 
            end
            )                                        as Neto,
          sum (
            case fc.doct_id when 8 
                  then -  (  fci_ivari 
                          - (fci_ivari * (fc_descuento1/100))
                          - (
                              (fci_ivari * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          )
                  else (  fci_ivari 
                          - (fci_ivari * (fc_descuento1/100))
                          - (
                              (fci_ivari * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          ) 
            end
            )                                        as Iva,
          sum (
            case fc.doct_id when 8 
                  then -  (  fci_importe 
                          - (fci_importe * (fc_descuento1/100))
                          - (
                              (fci_importe * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          )
                  else (  fci_importe 
                          - (fci_importe * (fc_descuento1/100))
                          - (
                              (fci_importe * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          ) 
            end
            )                                        as Total

    from
    
          FacturaCompra fc        inner join FacturaCompraItem fci    on fc.fc_id     = fci.fc_id
                                  inner join Documento doc              on fc.doc_id    = doc.doc_id
    where 
    
              fc_fecha < @@Fini

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
    and   (fc.est_id     = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fc.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
      group by
          isnull(fci.ccos_id,fc.ccos_id),
          doc.emp_id
    
  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras - Otros
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          0,        
          isnull(fco.ccos_id,fc.ccos_id),
          doc.emp_id,

          sum(case fc.doct_id 
                when 8 then -(fcot_debe-fcot_haber) 
                else          (fcot_debe-fcot_haber) 
            end)  as Neto,
          0  as Iva,
          sum(case fc.doct_id 
                when 8 then -(fcot_debe-fcot_haber) 
                else          (fcot_debe-fcot_haber) 
            end)  as Total

    from
    
          FacturaCompra fc        inner join FacturaCompraOtro fco    on fc.fc_id     = fco.fc_id
                                  inner join Documento doc              on fc.doc_id    = doc.doc_id
                                  inner join Cuenta cue               on fco.cue_id   = cue.cue_id
    where 
    
              fc_fecha < @@Fini

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
    and   (fc.est_id     = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fc.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
      group by
          isnull(fco.ccos_id,fc.ccos_id),
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras - Percepciones
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          0,        
          isnull(fcp.ccos_id,fc.ccos_id),
          doc.emp_id,

          sum(case fc.doct_id 
                when 8 then -(fcperc_importe) 
                else          (fcperc_importe) 
            end)  as Neto,
          0  as Iva,
          sum(case fc.doct_id 
                when 8 then -(fcperc_importe) 
                else          (fcperc_importe) 
            end)  as Total

    from
    
          FacturaCompra fc        inner join FacturaCompraPercepcion fcp  on fc.fc_id     = fcp.fc_id
                                  inner join Documento doc                  on fc.doc_id    = doc.doc_id
    where 
    
              fc_fecha < @@Fini

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
    and   (fc.est_id     = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fc.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
      group by
          isnull(fcp.ccos_id,fc.ccos_id),
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Movimientos de Fondo (Pago de Impuestos y Salidas de Caja)
  --
  --  OJO: estos son los movimientos negativos (@doc_id_mov_fondo_neg)
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          0,
          isnull(mfi.ccos_id,mf.ccos_id),
          doc.emp_id,

          sum(mfi_importe)                          as Neto,
          0                                          as Iva,
          sum(mfi_importe)                          as Total

    from
    
          MovimientoFondo mf      inner join MovimientoFondoItem mfi  on mf.mf_id         = mfi.mf_id
                                  inner join Documento doc              on mf.doc_id        = doc.doc_id
                                  inner join Cuenta cue               on mfi.cue_id_haber  = cue.cue_id
    where 
    
              mf_fecha < @@Fini

          and mf.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(mfi.ccos_id,mf.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 

    and   (doc.doc_id   = @doc_id_mov_fondo_neg or @doc_id_mov_fondo_neg = 0)

    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(mfi.ccos_id,mf.ccos_id)
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
               (@ram_id_Empresa = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID2
                      and  tbl_id = 4001
                      and  rptarb_hojaid = doc.doc_id
                     ) 
               )
            or 
               (@ram_id_mov_neg = 0)
           )

      and exists(select 1 
                 from AsientoItem asi 
                 where mf.as_id = asi.as_id
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
      group by
          isnull(mfi.ccos_id,mf.ccos_id),
          doc.emp_id


  --////////////////////////////////////////////////////////////////////////
  --
  -- Haber del Asiento
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Total)

    select 

          0,        
          asi.ccos_id,
          doc.emp_id,
          sum(asi_haber) as Neto,
          sum(asi_haber) as Total
    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                            inner join Documento doc       on ast.doc_id = doc.doc_id
                            inner join CentroCosto ccos   on asi.ccos_id = ccos.ccos_id
                            inner join Cuenta cue         on asi.cue_id = cue.cue_id
    where     
              as_fecha < @@Fini

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el haber que lo interpreto como compras
          and (ccos_compra <> 0 or (asi.asi_haber  <> 0 and ccos_venta = 0))    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */

    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id   = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )
    
      group by
          asi.ccos_id,
          doc.emp_id


  --////////////////////////////////////////////////////////////////////////
  --
  -- Debe del Asiento
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Total)

    select 

          0,        
          asi.ccos_id,
          doc.emp_id,
          sum(asi_debe) as Neto,
          sum(asi_debe) as Total
    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                            inner join Documento doc       on ast.doc_id = doc.doc_id
                            inner join CentroCosto ccos   on asi.ccos_id = ccos.ccos_id
                            inner join Cuenta cue         on asi.cue_id = cue.cue_id
    where 
    
              as_fecha < @@Fini

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el debe de centros de costo que son de compras
          and (ccos_compra <> 0 and asi_debe <> 0)    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id   = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )
    
      group by
          asi.ccos_id,
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Ordenes de Pago
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    neto,
                                    Pagos)

    select 

          0,        
          isnull(opgi.ccos_id,opg.ccos_id),
          doc.emp_id,

          sum(case 
                  when opgi_tipo = 4 and opgi_otrotipo = 1 then   opgi_importe
                  when opgi_tipo = 4 and opgi_otrotipo = 2 then   -opgi_importe
                  else                                             opgi_importe
              end
            )            as neto,

          sum(case 
                  when opgi_tipo = 4 and opgi_otrotipo = 1 then   opgi_importe
                  when opgi_tipo = 4 and opgi_otrotipo = 2 then   -opgi_importe
                  else                                             opgi_importe
              end
            )            as Pago
    from
    
          OrdenPago opg        inner join OrdenPagoItem opgi    on opg.opg_id = opgi.opg_id
                                                              and opgi_tipo <> 5
                              inner join Documento doc          on opg.doc_id = doc.doc_id
                              inner join Cuenta cue            on opgi.cue_id = cue.cue_id
    where 
    
              opg_fecha < @@Fini

          and opg.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(opgi.ccos_id,opg.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (opg.est_id   = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(opgi.ccos_id,opg.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = opg.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    
      and exists(select 1 
                 from AsientoItem asi 
                 where opg.as_id = asi.as_id
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
      group by
          isnull(opgi.ccos_id,opg.ccos_id),
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Ventas
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          1,        
          isnull(fvi.ccos_id,fv.ccos_id),
          doc.emp_id,

          sum(
            case fv.doct_id when 7 
                  then -  (  fvi_neto 
                          - (fvi_neto * (fv_descuento1/100))
                          - (
                              (fvi_neto * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          )
                  else (  fvi_neto 
                          - (fvi_neto * (fv_descuento1/100))
                          - (
                              (fvi_neto * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          ) 
            end
            )                                        as Neto,
          sum (
            case fv.doct_id when 7 
                  then -  (  fvi_ivari 
                          - (fvi_ivari * (fv_descuento1/100))
                          - (
                              (fvi_ivari * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          )
                  else (  fvi_ivari 
                          - (fvi_ivari * (fv_descuento1/100))
                          - (
                              (fvi_ivari * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          ) 
            end
            )                                        as Iva,
          sum (
            case fv.doct_id when 7 
                  then -  (  fvi_importe 
                          - (fvi_importe * (fv_descuento1/100))
                          - (
                              (fvi_importe * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          )
                  else (  fvi_importe 
                          - (fvi_importe * (fv_descuento1/100))
                          - (
                              (fvi_importe * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          ) 
            end
            )                                        as Total

    from
    
          FacturaVenta fv        inner join FacturaVentaItem fvi   on fv.fv_id     = fvi.fv_id
                                inner join Documento doc            on fv.doc_id    = doc.doc_id
    where 
    
              fv_fecha < @@Fini

          and fv.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fvi.ccos_id,fv.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (fv.est_id     = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fvi.ccos_id,fv.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fv.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    
      and exists(select 1 
                 from AsientoItem asi 
                 where fv.as_id = asi.as_id
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
      group by
          isnull(fvi.ccos_id,fv.ccos_id),
          doc.emp_id    

  --////////////////////////////////////////////////////////////////////////
  --
  -- Ventas - Percepciones
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          1,        
          isnull(fvp.ccos_id,fv.ccos_id),
          doc.emp_id,

          sum(case fv.doct_id 
                when 7 then -(fvperc_importe) 
                else          (fvperc_importe) 
            end)  as Neto,
          0  as Iva,
          sum(case fv.doct_id 
                when 7 then -(fvperc_importe) 
                else          (fvperc_importe) 
            end)  as Total

    from
    
          FacturaVenta fv        inner join FacturaVentaPercepcion fvp  on fv.fv_id     = fvp.fv_id
                                inner join Documento doc                 on fv.doc_id   = doc.doc_id
    where 
    
              fv_fecha < @@Fini

          and fv.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fvp.ccos_id,fv.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (fv.est_id     = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fvp.ccos_id,fv.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fv.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    
      and exists(select 1 
                 from AsientoItem asi 
                 where fv.as_id = asi.as_id
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
      group by
          isnull(fvp.ccos_id,fv.ccos_id),
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Movimientos de Fondo (Pago de Impuestos y Salidas de Caja)
  --
  --  OJO: estos son los movimientos positivos (@doc_id_mov_fondo_pos)
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Iva,
                                    Total)

    select 

          1,
          isnull(mfi.ccos_id,mf.ccos_id),
          doc.emp_id,

          sum(mfi_importe)                          as Neto,
          0                                          as Iva,
          sum(mfi_importe)                          as Total

    from
    
          MovimientoFondo mf      inner join MovimientoFondoItem mfi  on mf.mf_id         = mfi.mf_id
                                  inner join Documento doc              on mf.doc_id        = doc.doc_id
                                  inner join Cuenta cue               on mfi.cue_id_debe  = cue.cue_id
    where 
    
              mf_fecha < @@Fini

          and mf.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(mfi.ccos_id,mf.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 

    and   (doc.doc_id   = @doc_id_mov_fondo_pos or @doc_id_mov_fondo_pos = 0)

    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(mfi.ccos_id,mf.ccos_id)
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
               (@ram_id_Empresa = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4001
                      and  rptarb_hojaid = doc.doc_id
                     ) 
               )
            or 
               (@ram_id_mov_pos = 0)
           )

      and exists(select 1 
                 from AsientoItem asi 
                 where mf.as_id = asi.as_id
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
      group by
          isnull(mfi.ccos_id,mf.ccos_id),
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Haber del Asiento
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Total)

    select 

          1,        
          asi.ccos_id,
          doc.emp_id,
          sum(asi_haber) as Neto,
          sum(asi_haber) as Total
    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                            inner join Documento doc       on ast.doc_id = doc.doc_id
                            inner join CentroCosto ccos   on asi.ccos_id = ccos.ccos_id
                            inner join Cuenta cue         on asi.cue_id = cue.cue_id
    where 
    
              as_fecha < @@Fini

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el haber de centros de costo que son de ventas
          and (ccos_venta <> 0 and asi.asi_haber <> 0)
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id   = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )
    
      group by
          asi.ccos_id,
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Debe del Asiento
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    Neto,
                                    Total)

    select 

          1,        
          asi.ccos_id,
          doc.emp_id,
          sum(asi_debe) as Neto,
          sum(asi_debe) as Total
    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                            inner join Documento doc       on ast.doc_id = doc.doc_id
                            inner join CentroCosto ccos   on asi.ccos_id = ccos.ccos_id
                            inner join Cuenta cue         on asi.cue_id = cue.cue_id
    where 
    
              as_fecha < @@Fini

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el debe que lo interpreto como ventas
          and (ccos_venta <> 0 or (asi.asi_debe  <> 0 and ccos_compra = 0))    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id   = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )
    
      group by
          asi.ccos_id,
          doc.emp_id

  --////////////////////////////////////////////////////////////////////////
  --
  -- Cobranzas
  --
  --////////////////////////////////////////////////////////////////////////

    insert into #t_IC_NRT_CON_0270 (circuito_id,
                                    ccos_id,
                                    emp_id,
                                    neto,
                                    Cobros)

    select 

          1,        
          isnull(cobzi.ccos_id,cobz.ccos_id),
          doc.emp_id,

          sum(case 
                  when cobzi_tipo = 4 and cobzi_otrotipo = 1 then   cobzi_importe
                  when cobzi_tipo = 4 and cobzi_otrotipo = 2 then   -cobzi_importe
                  else                                               cobzi_importe
              end
            )            as neto,

          sum(case 
                  when cobzi_tipo = 4 and cobzi_otrotipo = 1 then   cobzi_importe
                  when cobzi_tipo = 4 and cobzi_otrotipo = 2 then   -cobzi_importe
                  else                                               cobzi_importe
              end
            )            as Cobro
    from
    
          Cobranza cobz        inner join CobranzaItem cobzi    on cobz.cobz_id = cobzi.cobz_id
                                                              and cobzi_tipo <> 5
                              inner join Documento doc          on cobz.doc_id = doc.doc_id
                              inner join Cuenta cue            on cobzi.cue_id = cue.cue_id
    where 
    
              cobz_fecha < @@Fini

          and cobz.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(cobzi.ccos_id,cobz.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (cobz.est_id   = @est_id   or @est_id  =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(cobzi.ccos_id,cobz.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = cobz.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    
      and exists(select 1 
                 from AsientoItem asi 
                 where cobz.as_id = asi.as_id
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
      group by
          isnull(cobzi.ccos_id,cobz.ccos_id),
          doc.emp_id

  end

--////////////////////////////////////////////////////////////////////////
--
-- Saldos Iniciales
--
--////////////////////////////////////////////////////////////////////////

    select 

          circuito_id,
          0                                         as is_saldo_id,
          0                                         as tipo_doc_id,

          case circuito_id when 0 then 'Compras' else 'Ventas' end
                                                    as Circuito,
          '1) Saldo Incial'                         as Tipo,
          ''                                        as [Orden],

          0                                          as comp_id,
          0                                          as doct_id,
        
          isnull(substring(ccos_codigo,1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(ccos_codigo,1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(ccos_codigo,1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(ccos_nombre,'Sin Centro de Costo')
                                                    as [Centro de Costo],

          @@Fini                                    as Fecha,

          null                                      as Proveedor,

          null                                      as [Tipo documento],
          emp_nombre                                 as Empresa, 
          null                                       as Comprobante,
          null                                       as Numero,

          Sum(Neto)                                  as Neto,
          Sum(Iva)                                  as Iva,
          Sum(Total)                                as Total,
          Sum(Pagos)                                as Pagos,
          Sum(Cobros)                                as Cobros,
          null                                      as Descripcion

    from #t_IC_NRT_CON_0270 t inner join Empresa emp      on t.emp_id  = emp.emp_id
                              left  join CentroCosto ccos on t.ccos_id = ccos.ccos_id                              
    group by
          circuito_id,
          isnull(substring(ccos.ccos_codigo,1,4),'Sin Centro de Costo'),
          isnull(substring(ccos.ccos_codigo,1,6),'Sin Centro de Costo'),
          isnull(substring(ccos.ccos_codigo,1,8),'Sin Centro de Costo'),
          isnull(ccos_nombre,'Sin Centro de Costo'),
          emp_nombre

  union all
    
--////////////////////////////////////////////////////////////////////////
--
-- Entre fechas
--
--////////////////////////////////////////////////////////////////////////

  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          0                                         as circuito_id,
          1                                         as is_saldo_id,
          0                                         as tipo_doc_id,

          
          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '1) Facturas'                             as [Orden],

          fc.fc_id                                  as comp_id,
          fc.doct_id                                as doct_id,

          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          fc_fecha                                  as Fecha,

          prov_nombre                                as Proveedor,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          fc_nrodoc                                 as Comprobante,
          fc_numero                                 as Numero,
    
          sum(
            case fc.doct_id when 8 
                  then -  (  fci_neto 
                          - (fci_neto * (fc_descuento1/100))
                          - (
                              (fci_neto * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          )
                  else (  fci_neto 
                          - (fci_neto * (fc_descuento1/100))
                          - (
                              (fci_neto * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          ) 
            end
            )                                        as Neto,
          sum (
            case fc.doct_id when 8 
                  then -  (  fci_ivari 
                          - (fci_ivari * (fc_descuento1/100))
                          - (
                              (fci_ivari * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          )
                  else (  fci_ivari 
                          - (fci_ivari * (fc_descuento1/100))
                          - (
                              (fci_ivari * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          ) 
            end
            )                                        as Iva,
          sum (
            case fc.doct_id when 8 
                  then -  (  fci_importe 
                          - (fci_importe * (fc_descuento1/100))
                          - (
                              (fci_importe * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          )
                  else (  fci_importe 
                          - (fci_importe * (fc_descuento1/100))
                          - (
                              (fci_importe * (fc_descuento1/100))
                                    * (fc_descuento2/100)
                            )
                          ) 
            end
            )                                        as Total,

          0          as Pagos,
          0          as Cobros,

          fc_descrip                                as Descripcion

    from
    
          FacturaCompra fc        inner join FacturaCompraItem fci    on fc.fc_id     = fci.fc_id
                                  inner join Proveedor prov            on fc.prov_id   = prov.prov_id
                                  inner join Documento doc              on fc.doc_id    = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on fc.doct_id   = doct.doct_id
                                  left  join CentroCosto ccos           on fc.ccos_id   = ccos.ccos_id
                                  left  join CentroCosto ccosi         on fci.ccos_id  = ccosi.ccos_id    
    where 
    
              fc_fecha >= @@Fini
          and  fc_fecha <= @@Ffin    

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
    and   (fc.est_id     = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fc.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    group by

          fc.fc_id,
          fc.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          fc_fecha,
          prov_nombre,
          doct.doct_nombre,
          emp_nombre,
          fc_nrodoc,
          fc_numero,
          fc_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras - Otros
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          0                                         as circuito_id,
          1                                         as is_saldo_id,
          0                                         as tipo_doc_id,

          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '1) Facturas'                             as [Orden],

          fc.fc_id                                  as comp_id,
          fc.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          fc_fecha                                  as Fecha,

          prov_nombre                                as Proveedor,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          fc_nrodoc                                 as Comprobante,
          fc_numero                                 as Numero,
    
          sum(case fc.doct_id 
                when 8 then -(fcot_debe-fcot_haber) 
                else          (fcot_debe-fcot_haber) 
            end)  as Neto,
          0  as Iva,
          sum(case fc.doct_id 
                when 8 then -(fcot_debe-fcot_haber) 
                else          (fcot_debe-fcot_haber) 
            end)  as Total,

          0          as Pagos,
          0          as Cobros,

          fc_descrip                                as Descripcion

    from
    
          FacturaCompra fc        inner join FacturaCompraOtro fco    on fc.fc_id     = fco.fc_id
                                  inner join Proveedor prov            on fc.prov_id   = prov.prov_id
                                  inner join Documento doc              on fc.doc_id    = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on fc.doct_id   = doct.doct_id
                                  left  join CentroCosto ccos           on fc.ccos_id   = ccos.ccos_id
                                  left  join CentroCosto ccosi         on fco.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on fco.cue_id   = cue.cue_id
    where 
    
              fc_fecha >= @@Fini
          and  fc_fecha <= @@Ffin    

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
    and   (fc.est_id     = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fc.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    group by

          fc.fc_id,
          fc.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          fc_fecha,
          prov_nombre,
          doct.doct_nombre,
          emp_nombre,
          fc_nrodoc,
          fc_numero,
          fc_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Compras - Percepcion
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          0                                         as circuito_id,
          1                                         as is_saldo_id,
          0                                         as tipo_doc_id,

          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '1) Facturas'                             as [Orden],

          fc.fc_id                                  as comp_id,
          fc.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          fc_fecha                                  as Fecha,

          prov_nombre                                as Proveedor,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          fc_nrodoc                                 as Comprobante,
          fc_numero                                 as Numero,
    
          sum(case fc.doct_id 
                when 8 then -(fcperc_importe) 
                else          (fcperc_importe) 
            end)  as Neto,
          0  as Iva,
          sum(case fc.doct_id 
                when 8 then -(fcperc_importe) 
                else          (fcperc_importe) 
            end)  as Total,

          0          as Pagos,
          0          as Cobros,

          fc_descrip                                as Descripcion

    from
    
          FacturaCompra fc  inner join FacturaCompraPercepcion fcp    on fc.fc_id     = fcp.fc_id
                            inner join Proveedor prov                  on fc.prov_id   = prov.prov_id
                            inner join Documento doc                    on fc.doc_id    = doc.doc_id
                            inner join Empresa emp                     on doc.emp_id   = emp.emp_id 
                            inner join CircuitoContable  cico           on doc.cico_id  = cico.cico_id
                            inner join DocumentoTipo doct              on fc.doct_id   = doct.doct_id
                            left  join CentroCosto ccos                 on fc.ccos_id   = ccos.ccos_id
                            left  join CentroCosto ccosi               on fcp.ccos_id  = ccosi.ccos_id    
    where 
    
              fc_fecha >= @@Fini
          and  fc_fecha <= @@Ffin    

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
    and   (fc.est_id     = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fc.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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
    group by

          fc.fc_id,
          fc.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          fc_fecha,
          prov_nombre,
          doct.doct_nombre,
          emp_nombre,
          fc_nrodoc,
          fc_numero,
          fc_descrip

  union all
    
  --////////////////////////////////////////////////////////////////////////
  --
  -- Movimientos de Fondo (Pago de Impuestos y Salidas de Caja)
  --
  --////////////////////////////////////////////////////////////////////////

    select 

          0                                         as circuito_id,
          1                                         as is_saldo_id,
          1                                         as tipo_doc_id,

          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '2) Movimientos de Fondo'                 as [Orden],

          mf.mf_id                                  as comp_id,
          mf.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          mf_fecha                                   as Fecha,

          null                                      as Proveedor,

          doct_nombre                                as [Tipo documento],
          emp_nombre                                 as Empresa, 
          mf_nrodoc                                  as Comprobante,
          mf_numero                                  as Numero,

          sum(mfi_importe)                           as Neto,
          0                                          as Iva,
          sum(mfi_importe)                          as Total,
          0          as Pagos,
          0          as Cobros,

          mf_descrip                                 as Descripcion

    from
    
          MovimientoFondo mf      inner join MovimientoFondoItem mfi  on mf.mf_id     = mfi.mf_id
                                  inner join Documento doc              on mf.doc_id    = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on mf.doct_id   = doct.doct_id
                                  left  join CentroCosto ccos           on mf.ccos_id   = ccos.ccos_id
                                  left  join CentroCosto ccosi         on mfi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on mfi.cue_id_haber = cue.cue_id
    where 
    
              mf_fecha >= @@Fini
          and  mf_fecha <= @@Ffin    

          and mf.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(mfi.ccos_id,mf.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 

    and   (doc.doc_id   = @doc_id_mov_fondo_neg or @doc_id_mov_fondo_neg = 0)

    and   (cue.cuec_id  = @cuec_id  or @cuec_id  =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(mfi.ccos_id,mf.ccos_id)
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
               (@ram_id_Empresa = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID2
                      and  tbl_id = 4001
                      and  rptarb_hojaid = doc.doc_id
                     ) 
               )
            or 
               (@ram_id_mov_neg = 0)
           )

      and exists(select 1 
                 from AsientoItem asi 
                 where mf.as_id = asi.as_id
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
    group by
          mf.mf_id,
          mf.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          mf_fecha,
          doct_nombre,
          emp_nombre,
          mf_nrodoc,
          mf_numero,
          mf_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Haber de Asientos
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          0                                         as circuito_id,
          1                                         as is_saldo_id,
          3                                         as tipo_doc_id,

          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '4) Asientos'                             as [Orden],

          ast.as_id                                  as comp_id,
          ast.doct_id                                as doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo')
                                                    as [Centro de Costo],

          as_fecha                                  as Fecha,

          null                                      as Proveedor,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          as_nrodoc                                 as Comprobante,
          as_numero                                 as Numero,

          sum(asi_haber)  as Neto,
          0               as Iva,
          sum(asi_haber)  as Total,    
          0               as Pago,
          0                as Cobros,

          as_descrip                                as Descripcion

    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                                  inner join Documento doc              on ast.doc_id   = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on ast.doct_id  = doct.doct_id
                                  inner join CentroCosto ccosi         on asi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on asi.cue_id   = cue.cue_id
    where 
    
              as_fecha >= @@Fini
          and  as_fecha <= @@Ffin    

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el haber que lo interpreto como compras
          and (ccos_compra <> 0 or (asi.asi_haber  <> 0 and ccos_venta = 0))    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id  = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )

    group by

          ast.as_id,
          ast.doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo'),
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo'),

          as_fecha,
          doct.doct_nombre,
          emp_nombre,
          as_nrodoc,
          as_numero,
          as_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Debe de Asientos
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          0                                         as circuito_id,
          1                                         as is_saldo_id,
          3                                         as tipo_doc_id,

          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '4) Asientos'                             as [Orden],

          ast.as_id                                  as comp_id,
          ast.doct_id                                as doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo')
                                                    as [Centro de Costo],

          as_fecha                                  as Fecha,

          null                                      as Proveedor,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          as_nrodoc                                 as Comprobante,
          as_numero                                 as Numero,

          sum(asi_debe)    as Neto,
          0               as Iva,
          sum(asi_debe)   as Total,    
          0               as Pago,
          0                as Cobros,

          as_descrip                                as Descripcion

    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                                  inner join Documento doc              on ast.doc_id   = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on ast.doct_id  = doct.doct_id
                                  inner join CentroCosto ccosi         on asi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on asi.cue_id   = cue.cue_id
    where 
    
              as_fecha >= @@Fini
          and  as_fecha <= @@Ffin    

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el debe de centros de costo que son de compras
          and (ccos_compra <> 0 and asi_debe <> 0)    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id  = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )

    group by

          ast.as_id,
          ast.doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo'),
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo'),

          as_fecha,
          doct.doct_nombre,
          emp_nombre,
          as_nrodoc,
          as_numero,
          as_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Pagos
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          0                                         as circuito_id,
          1                                         as is_saldo_id,
          2                                         as tipo_doc_id,

          'Compras'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '3) Pagos'                                as [Orden],

          opg.opg_id                                as comp_id,
          opg.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          opg_fecha                                 as Fecha,

          prov_nombre                                as Proveedor,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          opg_nrodoc                                 as Comprobante,
          opg_numero                                 as Numero,

          0          as Neto,
          0         as Iva,
          0         as Total,    

          sum(case 
                  when opgi_tipo = 4 and opgi_otrotipo = 1 then   opgi_importe
                  when opgi_tipo = 4 and opgi_otrotipo = 2 then   -opgi_importe
                  else                                             opgi_importe
              end
            )       as Pago,

          0          as Cobros,

          opg_descrip                                as Descripcion

    from
    
          OrdenPago opg            inner join OrdenPagoItem opgi        on opg.opg_id    = opgi.opg_id
                                  inner join Proveedor prov            on opg.prov_id   = prov.prov_id
                                  inner join Documento doc              on opg.doc_id    = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id    = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id   = cico.cico_id
                                  inner join DocumentoTipo doct        on opg.doct_id   = doct.doct_id
                                  left  join CentroCosto ccos           on opg.ccos_id    = ccos.ccos_id
                                  left  join CentroCosto ccosi         on opgi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on opgi.cue_id   = cue.cue_id
    where 
    
              opg_fecha >= @@Fini
          and  opg_fecha <= @@Ffin    

          and opg.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(opgi.ccos_id,opg.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (opg.est_id   = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(opgi.ccos_id,opg.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = opg.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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

      and exists(select 1 
                 from AsientoItem asi 
                 where opg.as_id = asi.as_id
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
    group by

          opg.opg_id,
          opg.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          opg_fecha,
          prov_nombre,
          doct.doct_nombre,
          emp_nombre,
          opg_nrodoc,
          opg_numero,
          opg_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Ventas
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          1                                         as circuito_id,
          1                                         as is_saldo_id,
          0                                         as tipo_doc_id,

          'Ventas'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '1) Facturas'                             as [Orden],

          fv.fv_id                                  as comp_id,
          fv.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          fv_fecha                                  as Fecha,

          cli_nombre                                as Cliente,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          fv_nrodoc                                 as Comprobante,
          fv_numero                                 as Numero,
    
          sum(
            case fv.doct_id when 7 
                  then -  (  fvi_neto 
                          - (fvi_neto * (fv_descuento1/100))
                          - (
                              (fvi_neto * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          )
                  else (  fvi_neto 
                          - (fvi_neto * (fv_descuento1/100))
                          - (
                              (fvi_neto * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          ) 
            end
            )                                        as Neto,
          sum (
            case fv.doct_id when 7 
                  then -  (  fvi_ivari 
                          - (fvi_ivari * (fv_descuento1/100))
                          - (
                              (fvi_ivari * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          )
                  else (  fvi_ivari 
                          - (fvi_ivari * (fv_descuento1/100))
                          - (
                              (fvi_ivari * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          ) 
            end
            )                                        as Iva,
          sum (
            case fv.doct_id when 7 
                  then -  (  fvi_importe 
                          - (fvi_importe * (fv_descuento1/100))
                          - (
                              (fvi_importe * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          )
                  else (  fvi_importe 
                          - (fvi_importe * (fv_descuento1/100))
                          - (
                              (fvi_importe * (fv_descuento1/100))
                                    * (fv_descuento2/100)
                            )
                          ) 
            end
            )                                        as Total,

          0          as Pagos,
          0          as Cobros,

          fv_descrip                                as Descripcion

    from
    
          FacturaVenta fv        inner join FacturaVentaItem fvi      on fv.fv_id     = fvi.fv_id
                                inner join Cliente cli              on fv.cli_id     = cli.cli_id
                                inner join Documento doc              on fv.doc_id    = doc.doc_id
                                inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                inner join DocumentoTipo doct        on fv.doct_id   = doct.doct_id
                                left  join CentroCosto ccos           on fv.ccos_id   = ccos.ccos_id
                                left  join CentroCosto ccosi         on fvi.ccos_id  = ccosi.ccos_id    
    where 
    
              fv_fecha >= @@Fini
          and  fv_fecha <= @@Ffin    

          and fv.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fvi.ccos_id,fv.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (fv.est_id     = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fvi.ccos_id,fv.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fv.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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

      and exists(select 1 
                 from AsientoItem asi 
                 where fv.as_id = asi.as_id
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
    group by

          fv.fv_id,
          fv.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          fv_fecha,
          cli_nombre,
          doct.doct_nombre,
          emp_nombre,
          fv_nrodoc,
          fv_numero,
          fv_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Ventas - Percepcion
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          1                                         as circuito_id,
          1                                         as is_saldo_id,
          0                                         as tipo_doc_id,

          'Ventas'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '1) Facturas'                             as [Orden],

          fv.fv_id                                  as comp_id,
          fv.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          fv_fecha                                  as Fecha,

          cli_nombre                                as Cliente,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          fv_nrodoc                                 as Comprobante,
          fv_numero                                 as Numero,
    
          sum(case fv.doct_id 
                when 7 then -(fvperc_importe) 
                else          (fvperc_importe) 
            end)  as Neto,
          0  as Iva,
          sum(case fv.doct_id 
                when 7 then -(fvperc_importe) 
                else          (fvperc_importe) 
            end)  as Total,

          0          as Pagos,
          0          as Cobros,

          fv_descrip                                as Descripcion

    from
    
          FacturaVenta fv  inner join FacturaVentaPercepcion fvp    on fv.fv_id     = fvp.fv_id
                            inner join Cliente cli                  on fv.cli_id   = cli.cli_id
                            inner join Documento doc                    on fv.doc_id    = doc.doc_id
                            inner join Empresa emp                     on doc.emp_id   = emp.emp_id 
                            inner join CircuitoContable  cico           on doc.cico_id  = cico.cico_id
                            inner join DocumentoTipo doct              on fv.doct_id   = doct.doct_id
                            left  join CentroCosto ccos                 on fv.ccos_id   = ccos.ccos_id
                            left  join CentroCosto ccosi               on fvp.ccos_id  = ccosi.ccos_id    
    where 
    
              fv_fecha >= @@Fini
          and  fv_fecha <= @@Ffin    

          and fv.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(fvp.ccos_id,fv.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (fv.est_id     = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(fvp.ccos_id,fv.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = fv.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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

      and exists(select 1 
                 from AsientoItem asi 
                 where fv.as_id = asi.as_id
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
    group by

          fv.fv_id,
          fv.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          fv_fecha,
          cli_nombre,
          doct.doct_nombre,
          emp_nombre,
          fv_nrodoc,
          fv_numero,
          fv_descrip

  union all
    
  --////////////////////////////////////////////////////////////////////////
  --
  -- Movimientos de Fondo (Pago de Impuestos y Salidas de Caja)
  --
  --////////////////////////////////////////////////////////////////////////

    select 

          1                                         as circuito_id,
          1                                         as is_saldo_id,
          1                                         as tipo_doc_id,

          'Ventas'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '2) Movimientos'                          as [Orden],

          mf.mf_id                                  as comp_id,
          mf.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                    as [Centro de Costo],

          mf_fecha                                   as Fecha,

          null                                      as Cliente,

          doct_nombre                                as [Tipo documento],
          emp_nombre                                 as Empresa, 
          mf_nrodoc                                  as Comprobante,
          mf_numero                                  as Numero,

          sum(mfi_importe)                           as Neto,
          0                                          as Iva,
          sum(mfi_importe)                          as Total,
          0          as Pagos,
          0          as Cobros,

          mf_descrip                                 as Descripcion
    from
    
          MovimientoFondo mf      inner join MovimientoFondoItem mfi  on mf.mf_id     = mfi.mf_id
                                  inner join Documento doc              on mf.doc_id    = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on mf.doct_id   = doct.doct_id
                                  left  join CentroCosto ccos           on mf.ccos_id   = ccos.ccos_id
                                  left  join CentroCosto ccosi         on mfi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on mfi.cue_id_haber = cue.cue_id
    where 
    
              mf_fecha >= @@Fini
          and  mf_fecha <= @@Ffin    

          and mf.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(mfi.ccos_id,mf.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 

    and   (doc.doc_id   = @doc_id_mov_fondo_pos or @doc_id_mov_fondo_pos = 0)

    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(mfi.ccos_id,mf.ccos_id)
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
               (@ram_id_Empresa = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4001
                      and  rptarb_hojaid = doc.doc_id
                     ) 
               )
            or 
               (@ram_id_mov_pos = 0)
           )

      and exists(select 1 
                 from AsientoItem asi 
                 where mf.as_id = asi.as_id
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
    group by
          mf.mf_id,
          mf.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          mf_fecha,
          doct_nombre,
          emp_nombre,
          mf_nrodoc,
          mf_numero,
          mf_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Haber de Asientos
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          1                                         as circuito_id,
          1                                         as is_saldo_id,
          3                                         as tipo_doc_id,

          'Ventas'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '4) Asientos'                             as [Orden],

          ast.as_id                                  as comp_id,
          ast.doct_id                                as doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo')
                                                    as [Centro de Costo],

          as_fecha                                  as Fecha,

          null                                       as Cliente,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          as_nrodoc                                 as Comprobante,
          as_numero                                 as Numero,

          sum(asi_haber)  as Neto,
          0               as Iva,
          sum(asi_haber)  as Total,    
          0               as Pago,
          0                as Cobros,

          as_descrip                                as Descripcion

    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                                  inner join Documento doc              on ast.doc_id   = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on ast.doct_id  = doct.doct_id
                                  inner join CentroCosto ccosi         on asi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on asi.cue_id   = cue.cue_id
    where 
    
              as_fecha >= @@Fini
          and  as_fecha <= @@Ffin    

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el haber de centros de costo que son de ventas
          and (ccos_venta <> 0 and asi.asi_haber <> 0)
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id  = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )

    group by

          ast.as_id,
          ast.doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo'),
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo'),

          as_fecha,
          doct.doct_nombre,
          emp_nombre,
          as_nrodoc,
          as_numero,
          as_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Debe de Asientos
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          1                                         as circuito_id,
          1                                         as is_saldo_id,
          3                                         as tipo_doc_id,

          'Ventas'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '4) Asientos'                             as [Orden],

          ast.as_id                                  as comp_id,
          ast.doct_id                                as doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo')
                                                    as [Centro de Costo],

          as_fecha                                  as Fecha,

          null                                       as Cliente,

          doct.doct_nombre                          as [Tipo documento],
          emp_nombre                                as Empresa, 
          as_nrodoc                                 as Comprobante,
          as_numero                                 as Numero,

          sum(asi_debe)    as Neto,
          0               as Iva,
          sum(asi_debe)   as Total,    
          0               as Pago,
          0                as Cobros,

          as_descrip                                as Descripcion

    from
    
          (Asiento ast      inner join AsientoItem asi    on ast.as_id = asi.as_id
                                                         and ast.id_cliente = 0     -- Solo asientos
          )
                                  inner join Documento doc              on ast.doc_id   = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id   = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id  = cico.cico_id
                                  inner join DocumentoTipo doct        on ast.doct_id  = doct.doct_id
                                  inner join CentroCosto ccosi         on asi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on asi.cue_id   = cue.cue_id
    where 
    
              as_fecha >= @@Fini
          and  as_fecha <= @@Ffin    

          -- Solo asientos
          and ast.id_cliente = 0     

          -- Solo el debe que lo interpreto como ventas
          and (ccos_venta <> 0 or (asi.asi_debe  <> 0 and ccos_compra = 0))    
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (asi.cue_id   = @cue_id   or @cue_id  =0)    
    and   (asi.ccos_id  = @ccos_id  or @ccos_id  =0)
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
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
                      and  tbl_id = 21 
                      and  rptarb_hojaid = asi.ccos_id
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
               (@ram_id_Empresa = 0)
           )

    group by

          ast.as_id,
          ast.doct_id,
        
          isnull(substring(ccosi.ccos_codigo,1,4),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,6),'Sin Centro de Costo'),
          isnull(substring(ccosi.ccos_codigo,1,8),'Sin Centro de Costo'),
          isnull(ccosi.ccos_nombre,'Sin Centro de Costo'),

          as_fecha,
          doct.doct_nombre,
          emp_nombre,
          as_nrodoc,
          as_numero,
          as_descrip

  union all

  --////////////////////////////////////////////////////////////////////////
  --
  -- Cobros
  --
  --////////////////////////////////////////////////////////////////////////
    
    select 
          1                                         as circuito_id,
          1                                         as is_saldo_id,
          2                                         as tipo_doc_id,

          'Ventas'                                  as Circuito,
          '2) Periodo'                              as Tipo,
          '3) Cobros'                               as [Orden],

          cobz.cobz_id                                as comp_id,
          cobz.doct_id                                as doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo') as cuenta_1,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo') as cuenta_2,
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo') as cuenta_3,
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo')
                                                      as [Centro de Costo],

          cobz_fecha                                   as Fecha,

          cli_nombre                                  as Cliente,

          doct.doct_nombre                            as [Tipo documento],
          emp_nombre                                  as Empresa, 
          cobz_nrodoc                                 as Comprobante,
          cobz_numero                                 as Numero,

          0          as Neto,
          0         as Iva,
          0         as Total,    

          0          as Pago,
          sum(case 
                  when cobzi_tipo = 4 and cobzi_otrotipo = 1 then   cobzi_importe
                  when cobzi_tipo = 4 and cobzi_otrotipo = 2 then   -cobzi_importe
                  else                                             cobzi_importe
              end
            )       as Cobros,

          cobz_descrip                                as Descripcion

    from
    
          Cobranza cobz            inner join CobranzaItem cobzi        on cobz.cobz_id   = cobzi.cobz_id
                                  inner join Cliente cli              on cobz.cli_id     = cli.cli_id
                                  inner join Documento doc              on cobz.doc_id    = doc.doc_id
                                  inner join Empresa emp               on doc.emp_id     = emp.emp_id 
                                  inner join CircuitoContable  cico     on doc.cico_id    = cico.cico_id
                                  inner join DocumentoTipo doct        on cobz.doct_id   = doct.doct_id
                                  left  join CentroCosto ccos           on cobz.ccos_id   = ccos.ccos_id
                                  left  join CentroCosto ccosi         on cobzi.ccos_id  = ccosi.ccos_id    
                                  inner join Cuenta cue               on cobzi.cue_id   = cue.cue_id
    where 
    
              cobz_fecha >= @@Fini
          and  cobz_fecha <= @@Ffin    

          and cobz.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (IsNull(cobzi.ccos_id,cobz.ccos_id) = @ccos_id 
                                    or @ccos_id  =0
          )
    and   (doc.cico_id   = @cico_id   or @cico_id  =0)
    and   (cobz.est_id   = @est_id   or @est_id  =0)
    and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
    and   (cue.cuec_id  = @cuec_id  or @cuec_id =0)
    
    -- Arboles
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21 
                      and  rptarb_hojaid = IsNull(cobzi.ccos_id,cobz.ccos_id)
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
                      and  tbl_id = 4005
                      and  rptarb_hojaid = cobz.est_id
                     ) 
               )
            or 
               (@ram_id_Estado = 0)
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

      and exists(select 1 
                 from AsientoItem asi 
                 where cobz.as_id = asi.as_id
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
    group by

          cobz.cobz_id,
          cobz.doct_id,
        
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,4),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,6),'Sin Centro de Costo'),
          isnull(substring(isnull(ccosi.ccos_codigo,ccos.ccos_codigo),1,8),'Sin Centro de Costo'),
          isnull(isnull(ccosi.ccos_nombre,ccos.ccos_nombre),'Sin Centro de Costo'),

          cobz_fecha,
          cli_nombre,
          doct.doct_nombre,
          emp_nombre,
          cobz_nrodoc,
          cobz_numero,
          cobz_descrip

  --////////////////////////////////////////////////////////////////////////
  --
  -- SORT
  --
  --////////////////////////////////////////////////////////////////////////

    order by circuito_id desc, is_saldo_id, [Centro de Costo], Empresa, tipo_doc_id, Fecha, Proveedor, Comprobante

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

