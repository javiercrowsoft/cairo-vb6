/*---------------------------------------------------------------------
Nombre: Detalle de percepciones y retenciones
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0086]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0086]


/*

DC_CSC_CON_0086 1,
                '20060701',
                '20061010',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '1'
        
*/

go
create procedure DC_CSC_CON_0086(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@perct_id  varchar(255),
  @@perc_id   varchar(255),
  @@rett_id   varchar(255),
  @@ret_id    varchar(255),
  @@cue_id     varchar(255),
  @@prov_id   varchar(255),
  @@cli_id    varchar(255),
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
  @@doc_id    varchar(255),
  @@emp_id    varchar(255),

  @@bcompras    smallint,
  @@bventas     smallint,
  @@bcobranzas  smallint,
  @@bpagos      smallint
) 

as 

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

declare @cue_id        int
declare @ccos_id       int
declare @cico_id       int
declare @doc_id        int
declare @perc_id       int
declare @perct_id      int
declare @ret_id        int
declare @rett_id       int
declare @prov_id       int
declare @cli_id        int
declare @emp_id        int

declare @ram_id_cuenta             int
declare @ram_id_centrocosto       int
declare @ram_id_circuitocontable  int
declare @ram_id_documento         int
declare @ram_id_percepcion        int
declare @ram_id_percepciontipo    int
declare @ram_id_retencion         int
declare @ram_id_retenciontipo     int
declare @ram_id_proveedor         int
declare @ram_id_cliente           int
declare @ram_id_empresa           int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,  @cue_id  out,  @ram_id_cuenta out
exec sp_ArbConvertId @@ccos_id, @ccos_id out,  @ram_id_centrocosto out
exec sp_ArbConvertId @@prov_id, @prov_id out,  @ram_id_proveedor out
exec sp_ArbConvertId @@cli_id,  @cli_id out,   @ram_id_cliente out
exec sp_ArbConvertId @@cico_id, @cico_id out,  @ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id,  @doc_id  out,  @ram_id_documento out

exec sp_ArbConvertId @@perc_id,   @perc_id  out,  @ram_id_percepcion out
exec sp_ArbConvertId @@perct_id,  @perct_id out,  @ram_id_percepciontipo out

exec sp_ArbConvertId @@ret_id,   @ret_id  out,  @ram_id_retencion out
exec sp_ArbConvertId @@rett_id,  @rett_id out,  @ram_id_retenciontipo out

exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
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

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
end

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_percepcion <> 0 begin

--  exec sp_ArbGetGroups @ram_id_percepcion, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_percepcion, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_percepcion, @clienteID 
  end else 
    set @ram_id_percepcion = 0
end

if @ram_id_percepciontipo <> 0 begin

--  exec sp_ArbGetGroups @ram_id_percepciontipo, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_percepciontipo, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_percepciontipo, @clienteID 
  end else 
    set @ram_id_percepciontipo = 0
end

if @ram_id_retencion <> 0 begin

--  exec sp_ArbGetGroups @ram_id_retencion, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_retencion, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_retencion, @clienteID 
  end else 
    set @ram_id_retencion = 0
end

if @ram_id_retenciontipo <> 0 begin

--  exec sp_ArbGetGroups @ram_id_retenciontipo, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_retenciontipo, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_retenciontipo, @clienteID 
  end else 
    set @ram_id_retenciontipo = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


--////////////////////////////////////////////////////////////////////////
-- Entre fechas

select 

    fc.fc_id                as comp_id,
    fc.doct_id              as doct_id,
    perc_nombre             as Impuesto,
    fc_fecha                as Fecha,
    prov_nombre             as [Cliente/Proveedor],
    prov_codigo              as Codigo,
    prov_cuit               as CUIT,
    case fc.doct_id
      when 2  then 'FAC'
      when 8  then 'NC'
      when 10 then 'ND'
    end                     as Tipo,
    fc_nrodoc               as Comprobante,
    ''                      as [Comprobante 2],
    ''                      as [Comp. Ret.],
    case fc.doct_id
      when 2  then fcperc_importe
      when 8  then -fcperc_importe
      when 10 then fcperc_importe
    end                     as Importe,
    case fc.doct_id
      when 2  then fc_neto
      when 8  then -fcperc_importe
      when 10 then fc_neto
    end                     as Neto,
    case fc.doct_id
      when 2  then fc_ivari + fc_ivarni
      when 8  then -(fc_ivari + fc_ivarni)
      when 10 then fc_ivari + fc_ivarni
    end                     as IVA,
    case fc.doct_id
      when 2  then fc_total
      when 8  then -fc_total
      when 10 then fc_total
    end                     as Total

from facturaCompra fc  inner join facturaCompraPercepcion  fcperc on fc.fc_id       = fcperc.fc_id       
                       inner join percepcion               perc   on fcperc.perc_id = perc.perc_id
                       inner join percepcionTipo           perct  on perc.perct_id  = perct.perct_id
                       inner join documento                doc    on fc.doc_id      = doc.doc_id
                       inner join empresa                  emp    on doc.emp_id     = emp.emp_id
                       inner join circuitoContable         cico    on doc.cico_id    = cico.cico_id
                       inner join proveedor                prov   on fc.prov_id     = prov.prov_id
                       left  join centroCosto               ccos    on fc.ccos_id     = ccos.ccos_id

where 

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin

      and fc.est_id <> 7 

      and @@bcompras <> 0

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
       and (
            exists(select * from UsuarioEmpresa where prov_id = fc.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
and   (perct.cue_id    = @cue_id      or @cue_id = 0)
and   (fc.ccos_id      = @ccos_id     or @ccos_id=0)
and   (doc.cico_id      = @cico_id     or @cico_id=0)
and   (fc.prov_id      = @prov_id     or @prov_id=0)
and   (fc.doc_id        = @doc_id      or @doc_id=0)
and   (fcperc.perc_id  = @perc_id     or @perc_id=0)
and   (perc.perct_id    = @perct_id    or @perct_id=0)
and   (emp.emp_id      = @emp_id      or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = perct.cue_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fc.ccos_id
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
           (@ram_id_circuitocontable = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001
                  and  rptarb_hojaid  = fc.doc_id
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
                  and  tbl_id = 1012
                  and  rptarb_hojaid  = fcperc.perc_id
                 )
           )
        or 
           (@ram_id_percepcion = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1011
                  and  rptarb_hojaid  = perc.perct_id
                 )
           )
        or 
           (@ram_id_percepciontipo = 0)
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

----------------------------------------------------------------------------------------------------------------------
union all
----------------------------------------------------------------------------------------------------------------------

select 

    opg.opg_id              as comp_id,
    opg.doct_id             as doct_id,
    ret_nombre              as Impuesto,
    opg_fecha               as Fecha,
    prov_nombre             as [Cliente/Proveedor],
    prov_codigo              as Codigo,
    prov_cuit               as CUIT,
    'OP'                    as Tipo,
    opg_nrodoc              as Comprobante,
    (select max(fc_nrodoc) 
     from FacturaCompra fc 
          inner join FacturaCompraOrdenPago fcp 
          on fc.fc_id = fcp.fc_id 
     where fcp.opg_id = opg.opg_id)
                            as [Comprobante 2],
    opgi_nroRetencion        as [Comp. Ret.],
    opgi_importe            as Importe,
    opg_neto                as Neto,
    0                       as IVA,
    opg_total               as Total

from ordenPago opg     inner join OrdenPagoItem            opgi   on     opg.opg_id     = opgi.opg_id
                                                                    and  opgi_tipo      = 4 --Otros     
                       inner join retencion                ret    on opgi.ret_id    = ret.ret_id
                       inner join retencionTipo            rett   on ret.rett_id    = rett.rett_id
                       inner join documento                doc    on opg.doc_id     = doc.doc_id
                       inner join empresa                  emp    on doc.emp_id     = emp.emp_id
                       inner join circuitoContable         cico    on doc.cico_id    = cico.cico_id
                       inner join proveedor                prov   on opg.prov_id    = prov.prov_id
                       left  join centroCosto               ccos    on opg.ccos_id    = ccos.ccos_id

where 

          opg_fecha >= @@Fini
      and  opg_fecha <= @@Ffin

      and opg.est_id <> 7 

      and @@bpagos <> 0

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
       and (
            exists(select * from UsuarioEmpresa where prov_id = opg.prov_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )


/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
and   (rett.cue_id     = @cue_id      or @cue_id = 0)
and   (opg.ccos_id     = @ccos_id     or @ccos_id=0)
and   (doc.cico_id      = @cico_id     or @cico_id=0)
and   (opg.prov_id     = @prov_id     or @prov_id=0)
and   (opg.doc_id      = @doc_id      or @doc_id=0)
and   (opgi.ret_id     = @ret_id      or @ret_id=0)
and   (ret.rett_id      = @rett_id     or @rett_id=0)
and   (emp.emp_id      = @emp_id      or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = rett.cue_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = opg.ccos_id
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
                  and  tbl_id = 29
                  and  rptarb_hojaid = opg.prov_id
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
           (@ram_id_circuitocontable = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001
                  and  rptarb_hojaid  = opg.doc_id
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
                  and  tbl_id = 1014
                  and  rptarb_hojaid  = opgi.ret_id
                 )
           )
        or 
           (@ram_id_retencion = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1013
                  and  rptarb_hojaid  = ret.rett_id
                 )
           )
        or 
           (@ram_id_retenciontipo = 0)
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

----------------------------------------------------------------------------------------------------------------------
union all
----------------------------------------------------------------------------------------------------------------------

select 

    fv.fv_id                as comp_id,
    fv.doct_id              as doct_id,
    perc_nombre             as Impuesto,
    fv_fecha                as Fecha,
    cli_nombre              as [Cliente/Cliente],
    cli_codigo              as Codigo,
    cli_cuit                as CUIT,
    case fv.doct_id
      when 1  then 'FAC'
      when 7  then 'NC'
      when 9  then 'ND'
    end                     as Tipo,
    fv_nrodoc               as Comprobante,
    ''                      as [Comprobante 2],
    ''                      as [Comp. Ret.],
    case fv.doct_id
      when 1  then fvperc_importe
      when 7  then -fvperc_importe
      when 9  then fvperc_importe
    end                     as Importe,
    case fv.doct_id
      when 1  then fv_neto
      when 7  then -fvperc_importe
      when 9  then fv_neto
    end                     as Neto,
    case fv.doct_id
      when 1  then fv_ivari + fv_ivarni
      when 7  then -(fv_ivari + fv_ivarni)
      when 9  then fv_ivari + fv_ivarni
    end                     as IVA,
    case fv.doct_id
      when 1  then fv_total
      when 7  then -fv_total
      when 9  then fv_total
    end                     as Total

from FacturaVenta fv   inner join FacturaVentaPercepcion   fvperc on fv.fv_id       = fvperc.fv_id       
                       inner join percepcion               perc   on fvperc.perc_id = perc.perc_id
                       inner join percepcionTipo           perct  on perc.perct_id  = perct.perct_id
                       inner join documento                doc    on fv.doc_id      = doc.doc_id
                       inner join empresa                  emp    on doc.emp_id     = emp.emp_id
                       inner join circuitoContable         cico    on doc.cico_id    = cico.cico_id
                       inner join Cliente                  cli    on fv.cli_id      = cli.cli_id
                       left  join centroCosto               ccos    on fv.ccos_id     = ccos.ccos_id

where 

          fv_fecha >= @@Fini
      and  fv_fecha <= @@Ffin

      and fv.est_id <> 7 

      and @@bventas <> 0

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
       and (
            exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
and   (perct.cue_id    = @cue_id      or @cue_id = 0)
and   (fv.ccos_id      = @ccos_id     or @ccos_id=0)
and   (doc.cico_id      = @cico_id     or @cico_id=0)
and   (fv.cli_id       = @cli_id      or @cli_id=0)
and   (fv.doc_id        = @doc_id      or @doc_id=0)
and   (fvperc.perc_id  = @perc_id     or @perc_id=0)
and   (perc.perct_id    = @perct_id    or @perct_id=0)
and   (emp.emp_id      = @emp_id      or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = perct.cue_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fv.ccos_id
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
                  and  tbl_id = 4001
                  and  rptarb_hojaid  = fv.doc_id
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
                  and  tbl_id = 1012
                  and  rptarb_hojaid  = fvperc.perc_id
                 )
           )
        or 
           (@ram_id_percepcion = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1011
                  and  rptarb_hojaid  = perc.perct_id
                 )
           )
        or 
           (@ram_id_percepciontipo = 0)
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

----------------------------------------------------------------------------------------------------------------------
union all
----------------------------------------------------------------------------------------------------------------------

select 

    cobz.cobz_id              as comp_id,
    cobz.doct_id              as doct_id,
    ret_nombre                as Impuesto,
    cobz_fecha                as Fecha,
    cli_nombre                as [Cliente/Proveedor],
    cli_codigo                as Codigo,
    cli_cuit                  as CUIT,
    'COB'                     as Tipo,
    cobz_nrodoc               as Comprobante,
    (select max(fv_nrodoc) 
     from FacturaVenta fv 
          inner join FacturaVentaCobranza fvp 
          on fv.fv_id = fvp.fv_id 
     where cobz_id = cobz.cobz_id)
                              as [Comprobante 2],
    cobzi_nroRetencion        as [Comp. Ret.],
    -cobzi_importe            as Importe,
    -cobz_neto                as Neto,
    0                         as IVA,
    -cobz_total               as Total

from Cobranza cobz     inner join CobranzaItem            cobzi   on     cobz.cobz_id  = cobzi.cobz_id
                                                                    and  cobzi_tipo    = 4 --Otros    

                       inner join retencion                ret    on cobzi.ret_id    = ret.ret_id
                       inner join retencionTipo            rett   on ret.rett_id     = rett.rett_id
                       inner join documento                doc    on cobz.doc_id     = doc.doc_id
                       inner join empresa                  emp    on doc.emp_id      = emp.emp_id
                       inner join circuitoContable         cico    on doc.cico_id     = cico.cico_id
                       inner join Cliente                  cli    on cobz.cli_id     = cli.cli_id
                       left  join centroCosto               ccos    on cobz.ccos_id    = ccos.ccos_id

where 

          cobz_fecha >= @@Fini
      and  cobz_fecha <= @@Ffin

      and  cobz.est_id <> 7 

      and @@bcobranzas <> 0

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
       and (
            exists(select * from UsuarioEmpresa where cli_id = cobz.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )


/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
and   (rett.cue_id     = @cue_id      or @cue_id = 0)
and   (cobz.ccos_id    = @ccos_id     or @ccos_id=0)
and   (doc.cico_id      = @cico_id     or @cico_id=0)
and   (cobz.cli_id     = @cli_id      or @cli_id=0)
and   (cobz.doc_id      = @doc_id      or @doc_id=0)
and   (cobzi.ret_id    = @ret_id      or @ret_id=0)
and   (ret.rett_id      = @rett_id     or @rett_id=0)
and   (emp.emp_id      = @emp_id      or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = rett.cue_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = cobz.ccos_id
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
                  and  tbl_id = 4001
                  and  rptarb_hojaid  = cobz.doc_id
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
                  and  tbl_id = 1014
                  and  rptarb_hojaid  = cobzi.ret_id
                 )
           )
        or 
           (@ram_id_retencion = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1013
                  and  rptarb_hojaid  = ret.rett_id
                 )
           )
        or 
           (@ram_id_retenciontipo = 0)
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

order by Impuesto, Fecha

end
go