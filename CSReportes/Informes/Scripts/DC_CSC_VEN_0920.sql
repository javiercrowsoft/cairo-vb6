/*---------------------------------------------------------------------
Nombre: Cuenta Corriente de Ventas
---------------------------------------------------------------------*/

/*
  Para testear:

  select * from Cliente where cli_nombre like '%argent%'

  [DC_CSC_VEN_0920] 1,'20050101 00:00:00','20051231 00:00:00','0','0','0','0','0',0

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0920]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0920]

go
create procedure [dbo].[DC_CSC_VEN_0920] (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cli_id        varchar(255),
  @@suc_id         varchar(255),
  @@cue_id         varchar(255), 
  @@cico_id        varchar(255),
  @@emp_id         varchar(255),
  @@minimo        decimal(18,6)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id   int
declare @suc_id   int
declare @cue_id   int
declare @cico_id  int
declare @emp_id   int 

declare @ram_id_Cliente   int
declare @ram_id_Sucursal   int
declare @ram_id_Cuenta     int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id,  @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_Cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

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

declare @cta_deudor     tinyint set @cta_deudor     = 1
declare @cta_deudorcobz tinyint set @cta_deudorcobz = 5

--/////////////////////////////////////////////////////////////////////////
--
--  Saldos Iniciales
--
--/////////////////////////////////////////////////////////////////////////

create table #t_DC_CSC_VEN_0920_3 ( cli_id     int not null )

create table #t_DC_CSC_VEN_0920_2 ( cli_id     int not null,
                                    debe      decimal(18,6) not null default(0),
                                    haber     decimal(18,6) not null default(0)
                                  )

create table #t_DC_CSC_VEN_0920 (

  cli_id      int not null,
  cue_id      int null,
  emp_id      int not null,
  suc_id      int not null,
  debe        decimal(18,6) not null default(0),
  haber       decimal(18,6) not null default(0)
)
--/////////////////////////////////////////////////////////////////////////

--//////////////////////////////////////////
-- Ordenes de Pago
--//////////////////////////////////////////


    insert into #t_DC_CSC_VEN_0920 (cli_id,cue_id,emp_id,suc_id,debe,haber)
    
    select 
    
            cli_id,
            (select min(cue_id) from CobranzaItem where cobz_id = cobz.cobz_id and cobzi_tipo = 5),
            doc.emp_id,
            suc_id,
            0,
            cobz_total    
    from 
    
      Cobranza cobz   inner join Documento doc                          on cobz.doc_id   = doc.doc_id
    
    where 
              cobz_fecha < @@Fini
    
          and cobz.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cobz.cli_id  = @cli_id   or @cli_id  =0)
    and   (cobz.suc_id  = @suc_id   or @suc_id  =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    
    and   (exists(
                  select * from CobranzaItem where cobz_id       = cobz.cobz_id 
                                                and cobzi_tipo   = @cta_deudorcobz
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
                      and  tbl_id = 17 
                      and  (
                            exists(
                                  select * from CobranzaItem where cobz_id       = cobz.cobz_id 
                                                                and cobzi_tipo   = @cta_deudorcobz
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

    insert into #t_DC_CSC_VEN_0920 (cli_id,cue_id,emp_id,suc_id,debe,haber)
    
    select 
            cli_id,
            cue_id,
            doc.emp_id,
            suc_id,

            case fv.doct_id 
              when 7  then     0      
              else             fv_totalcomercial
            end
                           as debe,

            case fv.doct_id 
              when 7  then      fv_totalcomercial      
              else             0
            end
                           as haber
    
    from 
    
      FacturaVenta fv inner join Documento doc                          on fv.doc_id    = doc.doc_id
                      left  join AsientoItem ai                         on fv.as_id     = ai.as_id and asi_tipo = @cta_deudor
                      
    where 
    
              fv_fecha <  @@Fini
          and fv.est_id <> 7
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (fv.cli_id     = @cli_id   or @cli_id  =0)
    and   (fv.suc_id     = @suc_id   or @suc_id  =0)
    and   (ai.cue_id     = @cue_id   or @cue_id  =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
    
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
--    
--    VentaS EN EL PERIODO
--
--
--/////////////////////////////////////////////////////////////////////////


    insert into #t_DC_CSC_VEN_0920_2(cli_id, debe, haber)


      --     --/////////////////////////////////////
      --     -- Saldos iniciales
      --     --/////////////////////////////////////
      --     select 
      -- 
      --             fv.cli_id,    
      --             sum(debe)            as [Debe],
      --             sum(haber)          as [Haber]
      -- 
      --     from 
      --     
      --       #t_DC_CSC_VEN_0920 fv 
      --                       inner join Cliente prov                         on fv.cli_id   = prov.cli_id
      --                       inner join Empresa emp                            on fv.emp_id    = emp.emp_id 
      --                       inner join Sucursal suc                           on fv.suc_id    = suc.suc_id
      --                       left  join Cuenta cue                             on fv.cue_id    = cue.cue_id
      -- 
      --     group by 
      -- 
      --             fv.cli_id
      -- 
      --     union all
    
    --/////////////////////////////////////
    --  Facturas, Notas de Credio/Debito
    --/////////////////////////////////////
    
    select 
            fv.cli_id,            
            sum(
                case fv.doct_id 
                  when 7 then    0
                  else          fv_totalcomercial
                end
              )        as [Debe],

            sum(
                case fv.doct_id 
                  when 7 then    fv_totalcomercial           
                  else          0
                end        
              )          as [Haber]    
    from 
    
      FacturaVenta fv inner join Cliente prov                         on fv.cli_id   = prov.cli_id
                       left  join FacturaVentaDeuda fvd                 on fv.fv_id      = fvd.fv_id
                       left  join FacturaVentaPago fvp                 on fv.fv_id      = fvp.fv_id
                       left  join AsientoItem ai                         on fv.as_id     = ai.as_id and asi_tipo = @cta_deudor
                       left  join Cuenta cue                            on ai.cue_id    = cue.cue_id
                       inner join Moneda mon                            on fv.mon_id    = mon.mon_id
                       inner join Estado est                            on fv.est_id    = est.est_id
                       inner join Documento doc                         on fv.doc_id    = doc.doc_id
                       inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
                       inner join Sucursal suc                          on fv.suc_id    = suc.suc_id
                       left  join Legajo lgj                            on fv.lgj_id    = lgj.lgj_id
                       inner join CondicionPago cpg                     on fv.cpg_id    = cpg.cpg_id
                       left  join CentroCosto ccos                      on fv.ccos_id   = ccos.ccos_id
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
    
    and   (fv.cli_id     = @cli_id   or @cli_id  =0)
    and   (fv.suc_id    = @suc_id    or @suc_id   =0)
    and   (ai.cue_id    = @cue_id    or @cue_id   =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id    or @emp_id   =0) 
    
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
    group by fv.cli_id
    
      --     --/////////////////////////////////////
      --     --  Ordenes de Pago
      --     --/////////////////////////////////////
      --     
      --     union all
      --     
      --     select 
      --             cobz.cli_id,
      --             0                   as [Debe]
      --             sum(cobz_total)    as [Haber],
      --     
      --     from 
      --     
      --       Cobranza cobz    inner join Cliente prov                         on cobz.cli_id   = prov.cli_id
      --                        inner join Estado est                            on cobz.est_id   = est.est_id
      --                        inner join Documento doc                         on cobz.doc_id   = doc.doc_id
      --                        inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
      --                        inner join Sucursal suc                          on cobz.suc_id   = suc.suc_id
      --                        left  join Legajo lgj                            on cobz.lgj_id   = lgj.lgj_id
      --                        left  join CentroCosto ccos                      on cobz.ccos_id  = ccos.ccos_id
      --     where 
      --     
      --               cobz_fecha >= @@Fini
      --           and  cobz_fecha <= @@Ffin     
      --     
      --           and cobz.est_id <> 7
      --     
      --           and (
      --                 exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
      --               )
      --     
      --     /* -///////////////////////////////////////////////////////////////////////
      --     
      --     INICIO SEGUNDA PARTE DE ARBOLES
      --     
      --     /////////////////////////////////////////////////////////////////////// */
      --     
      --     and   (cobz.cli_id   = @cli_id   or @cli_id  =0)
      --     and   (cobz.suc_id   = @suc_id   or @suc_id  =0)
      --     and   (exists(
      --                   select * from CobranzaItem where cobz_id       = cobz.cobz_id 
      --                                                 and cobzi_tipo   = @cta_deudorcobz
      --                                                 and cue_id      = @cue_id   
      --                   )
      --             or @cue_id  =0
      --           )
      --     and   (doc.cico_id  = @cico_id  or @cico_id =0)
      --     and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
      --     
      --     -- Arboles
      --     and   (
      --               (exists(select rptarb_hojaid 
      --                       from rptArbolRamaHoja 
      --                       where
      --                            rptarb_cliente = @clienteID
      --                       and  tbl_id = 28 
      --                       and  rptarb_hojaid = cobz.cli_id
      --                      ) 
      --                )
      --             or 
      --                (@ram_id_Cliente = 0)
      --            )
      --     
      --     and   (
      --               (exists(select rptarb_hojaid 
      --                       from rptArbolRamaHoja 
      --                       where
      --                            rptarb_cliente = @clienteID
      --                       and  tbl_id = 1007 
      --                       and  rptarb_hojaid = cobz.suc_id
      --                      ) 
      --                )
      --             or 
      --                (@ram_id_Sucursal = 0)
      --            )
      --     
      --     and   (
      --               (exists(select rptarb_hojaid 
      --                       from rptArbolRamaHoja 
      --                       where
      --                            rptarb_cliente = @clienteID
      --                       and  tbl_id = 17 
      --                       and  (
      --                             exists(
      --                                   select * from CobranzaItem where cobz_id       = cobz.cobz_id 
      --                                                                 and cobzi_tipo   = @cta_deudorcobz
      --                                                                 and cue_id      = rptarb_hojaid   
      --                                   )
      --                              ) 
      --                      ) 
      --                )
      --             or 
      --                (@ram_id_Cuenta = 0)
      --            )
      --     
      --     and   (
      --               (exists(select rptarb_hojaid 
      --                       from rptArbolRamaHoja 
      --                       where
      --                            rptarb_cliente = @clienteID
      --                       and  tbl_id = 1016 
      --                       and  rptarb_hojaid = doc.cico_id
      --                      ) 
      --                )
      --             or 
      --                (@ram_id_circuitocontable = 0)
      --            )
      -- 
      --     and   (      -- 
      --               (exists(select rptarb_hojaid 
      --                       from rptArbolRamaHoja 
      --                       where
      --                            rptarb_cliente = @clienteID
      --                       and  tbl_id = 1018 
      --                       and  rptarb_hojaid = doc.emp_id
      --                      ) 
      --                )
      --             or 
      --                (@ram_id_Empresa = 0)
      --            )
      -- 
      --     group by cobz.cli_id

  insert into #t_DC_CSC_VEN_0920_3

  select cli_id
  from #t_DC_CSC_VEN_0920_2
  group by cli_id having sum(debe-haber)> @@minimo


--/////////////////////////////////////////////////////////////////////////
--    
--    SELECT DE RETORNO
--
--
--/////////////////////////////////////////////////////////////////////////

    --/////////////////////////////////////
    -- Saldos iniciales
    --/////////////////////////////////////
    select 
    
            0                   as doct_id,
            0                  as comp_id,
            0                  as nOrden_id,
            'Saldo Inicial'     as Documento,
            @@Fini             as [Fecha],
            ''                 as [Numero],
            'Saldo inicial'    as [Comprobante],

            cli_nombre + ' -RZ: ' + cli_razonsocial + ' -CUIT: ' + cli_cuit + ' -TE: ' + cli_tel
                               as [Cliente],

            cli_calle + ' ' + 
            cli_callenumero + ' ' + 
            cli_piso + ' ' + 
            cli_codpostal + ' ' + 
            cli_localidad      as cli_direccion,

            'Tel: ' + 
            cli_tel  + ' | Fax:' + 
            cli_fax  + ' | Email: ' + 
            cli_email  + ' | Web:' + 
            cli_web             as cli_telefono,
    
            sum(debe)            as [Debe],
            sum(haber)          as [Haber],
    
            ''                 as [Moneda],
            ''                 as [Estado],
            cue_nombre         as [Cuenta],
            ''                 as [Documento],
            emp_nombre         as [Empresa], 
            suc_nombre         as [Sucursal],
            ''                 as [Cond. Pago],
            ''                 as [Legajo],
            ''                 as [Centro de Costo],
            ''                 as [Observaciones]
    
    from 
    
      #t_DC_CSC_VEN_0920 fv 
                      inner join Cliente prov                         on fv.cli_id   = prov.cli_id
                      inner join Empresa emp                            on fv.emp_id    = emp.emp_id 
                      inner join Sucursal suc                           on fv.suc_id    = suc.suc_id
                      left  join Cuenta cue                             on fv.cue_id    = cue.cue_id

    where exists(select * from #t_DC_CSC_VEN_0920_3 where cli_id = fv.cli_id)

    group by 

            fv.cli_id,    

            cli_nombre + ' -RZ: ' + cli_razonsocial + ' -CUIT: ' + cli_cuit + ' -TE: ' + cli_tel,

            cli_calle + ' ' + 
            cli_callenumero + ' ' + 
            cli_piso + ' ' + 
            cli_codpostal + ' ' + 
            cli_localidad,

            'Tel: ' + 
            cli_tel  + ' | Fax:' + 
            cli_fax  + ' | Email: ' + 
            cli_email  + ' | Web:' + 
            cli_web,

            cue_nombre,
            suc_nombre,
            emp_nombre

    union all
    
    --/////////////////////////////////////
    --  Facturas, Notas de Credio/Debito
    --/////////////////////////////////////
    
    select 
            fv.doct_id         as doct_id,
            fv.fv_id           as comp_id,
            1                  as nOrden_id,
            doc_nombre         as Documento,
            fv_fecha           as [Fecha],
            fv_numero          as [Numero],
            fv_nrodoc          as [Comprobante],

            cli_nombre + ' -RZ: ' + cli_razonsocial + ' -CUIT: ' + cli_cuit + ' -TE: ' + cli_tel
                               as [Cliente],

            cli_calle + ' ' + 
            cli_callenumero + ' ' + 
            cli_piso + ' ' + 
            cli_codpostal + ' ' + 
            cli_localidad      as cli_direccion,

            'Tel: ' + 
            cli_tel  + ' | Fax:' + 
            cli_fax  + ' | Email: ' + 
            cli_email  + ' | Web:' + 
            cli_web             as cli_telefono,
            
            case fv.doct_id 
              when 7 then    0
              else          fv_totalcomercial
            end        as [Debe],

            case fv.doct_id 
              when 7 then    fv_totalcomercial           
              else          0
            end        as [Haber],

            mon_nombre         as [Moneda],
            est_nombre         as [Estado],
            cue_nombre         as [Cuenta],
            doc_nombre         as [Documento],
            emp_nombre         as Empresa, 
            suc_nombre         as [Sucursal],
            cpg_nombre         as [Cond. Pago],

            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],

            ccos_nombre        as [Centro de Costo],                
            fv_descrip         as [Observaciones]
    
    from 
    
      FacturaVenta fv inner join Cliente prov                         on fv.cli_id   = prov.cli_id
                       left  join FacturaVentaDeuda fvd                 on fv.fv_id      = fvd.fv_id
                       left  join FacturaVentaPago fvp                 on fv.fv_id      = fvp.fv_id
                       left  join AsientoItem ai                         on fv.as_id     = ai.as_id and asi_tipo = @cta_deudor
                       left  join Cuenta cue                            on ai.cue_id    = cue.cue_id
                       inner join Moneda mon                            on fv.mon_id    = mon.mon_id
                       inner join Estado est                            on fv.est_id    = est.est_id
                       inner join Documento doc                         on fv.doc_id    = doc.doc_id
                       inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
                       inner join Sucursal suc                          on fv.suc_id    = suc.suc_id
                       left  join Legajo lgj                            on fv.lgj_id    = lgj.lgj_id
                       inner join CondicionPago cpg                     on fv.cpg_id    = cpg.cpg_id
                       left  join CentroCosto ccos                      on fv.ccos_id   = ccos.ccos_id
    where 
    
              fv_fecha >= @@Fini
          and  fv_fecha <= @@Ffin     
    
          and fv.est_id <> 7

          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )

          and exists(select * from #t_DC_CSC_VEN_0920_3 where cli_id = fv.cli_id)
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (fv.cli_id     = @cli_id   or @cli_id  =0)
    and   (fv.suc_id    = @suc_id    or @suc_id   =0)
    and   (ai.cue_id    = @cue_id    or @cue_id   =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id    or @emp_id   =0) 
    
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
            cobz.doct_id        as doct_id,
            cobz.cobz_id         as comp_id,
            1                  as nOrden_id,
            doc_nombre         as Documento,
            cobz_fecha          as [Fecha],
            cobz_numero         as [Numero],
            cobz_nrodoc         as [Comprobante],

            cli_nombre + ' -RZ: ' + cli_razonsocial + ' -CUIT: ' + cli_cuit + ' -TE: ' + cli_tel
                               as [Cliente],

            cli_calle + ' ' + 
            cli_callenumero + ' ' + 
            cli_piso + ' ' + 
            cli_codpostal + ' ' + 
            cli_localidad      as cli_direccion,

            'Tel: ' + 
            cli_tel  + ' | Fax:' + 
            cli_fax  + ' | Email: ' + 
            cli_email  + ' | Web:' + 
            cli_web             as cli_telefono,

            0                    as [Debe],
            cobz_total         as [Haber],
    
            ''                 as [Moneda],
            est_nombre         as [Estado],
            (select min(cue_nombre) 
             from CobranzaItem cobzi inner join cuenta cue on cobzi.cue_id = cue.cue_id
             where cobz_id = cobz.cobz_id and cobzi_tipo = 5)
                               as [Cuenta],
            doc_nombre         as [Documento],
            emp_nombre         as Empresa, 
            suc_nombre         as [Sucursal],
            ''                 as [Cond. Pago],
            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
            ccos_nombre        as [Centro de Costo],                
            cobz_descrip       as [Observaciones]
    
    from 
    
      Cobranza cobz    inner join Cliente prov                         on cobz.cli_id   = prov.cli_id
                       inner join Estado est                            on cobz.est_id   = est.est_id
                       inner join Documento doc                         on cobz.doc_id   = doc.doc_id
                       inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
                       inner join Sucursal suc                          on cobz.suc_id   = suc.suc_id
                       left  join Legajo lgj                            on cobz.lgj_id   = lgj.lgj_id
                       left  join CentroCosto ccos                      on cobz.ccos_id  = ccos.ccos_id
    where 
    
              cobz_fecha >= @@Fini
          and  cobz_fecha <= @@Ffin     
    
          and cobz.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )

          and exists(select * from #t_DC_CSC_VEN_0920_3 where cli_id = cobz.cli_id)
    
    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cobz.cli_id   = @cli_id   or @cli_id  =0)
    and   (cobz.suc_id   = @suc_id   or @suc_id  =0)
    and   (exists(
                  select * from CobranzaItem where cobz_id       = cobz.cobz_id 
                                                and cobzi_tipo   = @cta_deudorcobz
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
                      and  tbl_id = 17 
                      and  (
                            exists(
                                  select * from CobranzaItem where cobz_id       = cobz.cobz_id 
                                                                and cobzi_tipo   = @cta_deudorcobz
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
    
      order by Cliente, Cuenta, Fecha, nOrden_id
  
end

GO