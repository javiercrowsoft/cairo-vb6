/*---------------------------------------------------------------------
Nombre: Imputacion contable por documentos detallado
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0070]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0070]


/*

DC_CSC_CON_0070 1,
                '20050101',
                '20050110',
                '0',
                '0',
                '0',
                '0',
                1,
                '1'
        
*/

go
create procedure DC_CSC_CON_0070(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id     varchar(255),
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
  @@doc_id    varchar(255),
  @@bMonExt   smallint, 
  @@emp_id    varchar(255)
) 

as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id  int
declare @ccos_id int
declare @cico_id int
declare @doc_id  int
declare @emp_id  int 


declare @ram_id_cuenta             int
declare @ram_id_centrocosto       int
declare @ram_id_circuitocontable  int
declare @ram_id_documento         int
declare @ram_id_Empresa           int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_cuenta out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id,  @doc_id out,  @ram_id_documento out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

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


--////////////////////////////////////////////////////////////////////////
-- Entre fechas

select 
      asiento.as_id,
      id_cliente,
      doct_id_cliente,

      1                                         as Orden,
      cue_nombre                                as Cuenta,
      cue_codigo                                as [Cuenta codigo],
      as_fecha                                  as Fecha,
      IsNull(doctcl.doct_nombre,
             doct.doct_nombre)                  as [Tipo documento],
      emp_nombre                                as Empresa, 
      case
        when dfv.doc_nombre   is not null then dfv.doc_nombre
        when dfc.doc_nombre   is not null then dfc.doc_nombre
        when dcobz.doc_nombre is not null then dcobz.doc_nombre
        when dopg.doc_nombre  is not null then dopg.doc_nombre
        when dmf.doc_nombre   is not null then dmf.doc_nombre
        when ddbco.doc_nombre is not null then ddbco.doc_nombre
        when ddcup.doc_nombre is not null then ddcup.doc_nombre
        when drcup.doc_nombre is not null then drcup.doc_nombre
      end                                       as Documento,
      case doct_id_cliente
            when 1      then 'FAC'
            when 2      then 'FAC'
            when 9      then 'ND'
            when 10     then 'ND'
            when 7      then 'NC'
            when 8      then 'NC'
            when 13     then 'COB'
            when 16     then 'OP'
            when 26     then 'MF'
            when 27     then 'RN'
            when 17     then 'DBCO'
            when 32     then 'DCUP'
            when 33     then 'RCUP'
      end                                       as Tipo,

      case doct_id_cliente
            when 1      then fvcli.cli_codigo
            when 2      then fcprov.prov_codigo
            when 9      then fvcli.cli_codigo
            when 10     then fcprov.prov_codigo
            when 7      then fvcli.cli_codigo
            when 8      then fcprov.prov_codigo
            when 13     then cobzcli.cli_codigo
            when 16     then opgprov.prov_codigo
            when 17     then bco_codigo 
      end                                       as Codigo,

      case doct_id_cliente
            when 1      then fvcli.cli_nombre
            when 2      then fcprov.prov_nombre
            when 9      then fvcli.cli_nombre
            when 10     then fcprov.prov_nombre
            when 7      then fvcli.cli_nombre
            when 8      then fcprov.prov_nombre
            when 13     then cobzcli.cli_nombre
            when 16     then opgprov.prov_nombre
            when 17     then bco_nombre 
      end                                       as [Cliente/Proveedor],

      case doct_id_cliente
            when 1      then fv_nrodoc
            when 2      then fc_nrodoc
            when 9      then fv_nrodoc
            when 10     then fc_nrodoc
            when 7      then fv_nrodoc
            when 8      then fc_nrodoc
            when 13     then cobz_nrodoc
            when 16     then opg_nrodoc
            when 17     then dbco_nrodoc
      end                                       as Comprobante,
      as_nrodoc                                  as Asiento,
      as_numero                                 as Numero,
      as_descrip                                as Descripcion,
      ccos_nombre                                as [Centro Costo],
      cico_nombre                                as [Circuito contable],
      asi_debe                                  as Debe,
      asi_haber                                  as Haber,
      0                                          as Saldo,
      case 
        when asi_debe > 0 then asi_origen        
        else 0
      end                                        as [Debe mon Ext],
      case 
        when asi_haber > 0 then asi_origen        
        else 0
      end                                        as [Haber mon Ext],
      0                                          as [Saldo mon Ext],
      @@bMonExt                                 as [Ver mon Ext]

from

  AsientoItem       inner join Cuenta                on AsientoItem.cue_id      = Cuenta.cue_id
                    left  join CentroCosto           on AsientoItem.ccos_id     = CentroCosto.ccos_id
                    inner join Asiento               on AsientoItem.as_id       = Asiento.as_id
                    inner join Documento             on Asiento.doc_id          = Documento.doc_id
                    inner join Empresa               on Documento.emp_id        = Empresa.emp_id 
                    inner join CircuitoContable       on Documento.cico_id       = CircuitoContable.cico_id
                    inner join DocumentoTipo doct    on Asiento.doct_id         = doct.doct_id
                    left  join DocumentoTipo doctcl  on Asiento.doct_id_cliente = doctcl.doct_id
  
  
                   left join facturaVenta        fv    on id_cliente = fv.fv_id      and doct_id_cliente in (1,7,9)
                   left join facturaCompra       fc    on id_cliente = fc.fc_id      and doct_id_cliente in (2,8,10)
                   left join cobranza            cobz on id_cliente = cobz.cobz_id  and doct_id_cliente = 13
                   left join ordenPago           opg  on id_cliente = opg.opg_id    and doct_id_cliente = 16
                   left join movimientoFondo    mf   on id_cliente = mf.mf_id      and doct_id_cliente = 26
                   left join depositoBanco      dbco on id_cliente = dbco.dbco_id  and doct_id_cliente = 17
                   left join depositoCupon      dcup on id_cliente = dcup.dcup_id  and doct_id_cliente = 32
                   left join resolucionCupon    rcup on id_cliente = rcup.rcup_id  and doct_id_cliente = 33
      
                   left join documento        dfv    on fv.doc_id   = dfv.doc_id
                   left join documento        dfc    on fc.doc_id   = dfc.doc_id
                   left join documento        dcobz  on cobz.doc_id = dcobz.doc_id
                   left join documento        dopg   on opg.doc_id  = dopg.doc_id
                   left join documento        dmf    on mf.doc_id   = dmf.doc_id
                   left join documento        ddbco  on dbco.doc_id = ddbco.doc_id
                   left join documento        ddcup  on dcup.doc_id = ddcup.doc_id
                   left join documento        drcup  on rcup.doc_id = drcup.doc_id


                   left join cliente            fvcli    on fv.cli_id    = fvcli.cli_id
                   left join proveedor           fcprov    on fc.prov_id   = fcprov.prov_id
                   left join cliente            cobzcli  on cobz.cli_id  = cobzcli.cli_id
                   left join proveedor           opgprov  on opg.prov_id  = opgprov.prov_id
                   left join banco              bco      on dbco.bco_id  = bco.bco_id

where 

          as_fecha >= @@Fini
      and  as_fecha <= @@Ffin

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = documento.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (AsientoItem.cue_id   = @cue_id  or @cue_id=0)
and   (AsientoItem.ccos_id  = @ccos_id or @ccos_id=0)
and   (Documento.cico_id     = @cico_id or @cico_id=0)

and   (
            ((dfv.doc_id    = @doc_id  or @doc_id=0) and dfv.doc_id is not null)
        or
            ((dfc.doc_id    = @doc_id  or @doc_id=0) and dfc.doc_id is not null)
        or
            ((dcobz.doc_id  = @doc_id  or @doc_id=0) and dcobz.doc_id is not null)
        or
            ((dopg.doc_id   = @doc_id  or @doc_id=0) and dopg.doc_id is not null)
        or
            ((dmf.doc_id    = @doc_id  or @doc_id=0) and dmf.doc_id is not null)
        or
            ((ddbco.doc_id  = @doc_id  or @doc_id=0) and ddbco.doc_id is not null)
        or
            ((ddcup.doc_id  = @doc_id  or @doc_id=0) and ddcup.doc_id is not null)
        or
            ((drcup.doc_id  = @doc_id  or @doc_id=0) and drcup.doc_id is not null)
      )
and   (Empresa.emp_id       = @emp_id  or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = AsientoItem.cue_id
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
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = AsientoItem.ccos_id
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
                  and  tbl_id = 1016 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Documento.cico_id
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
                  and  tbl_id = 4001 -- select * from tabla where tbl_nombre like '%documento%'
                  and   (
                              (rptarb_hojaid = dfv.doc_id and dfv.doc_id is not null)
                          or
                              (rptarb_hojaid = dfc.doc_id and dfc.doc_id is not null)
                          or
                              (rptarb_hojaid = dcobz.doc_id and dcobz.doc_id is not null)
                          or
                              (rptarb_hojaid = dopg.doc_id and dopg.doc_id is not null)
                          or
                              (rptarb_hojaid = dmf.doc_id and dmf.doc_id is not null)
                          or
                              (rptarb_hojaid = ddbco.doc_id  and ddbco.doc_id is not null)
                          or
                              (rptarb_hojaid = ddcup.doc_id  and ddcup.doc_id is not null)
                          or
                              (rptarb_hojaid = drcup.doc_id  and drcup.doc_id is not null)
                        )
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
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = Documento.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

order by cue_nombre,cue_codigo, orden, Fecha

end
go