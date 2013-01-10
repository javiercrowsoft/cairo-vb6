
/*---------------------------------------------------------------------
Nombre: Mayor de cuentas para Bancos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0290]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0290]


/*
select * from documento where doc_nombre like '%cob%'

 [DC_CSC_CON_0290] 1,'20060901 00:00:00','20060930 00:00:00','287','0','0',0,'0','0',0

*/

go
create procedure DC_CSC_CON_0290(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@doc_id    varchar(255),
  @@cue_id     varchar(255),
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
  @@bMonExt   smallint, 
  @@emp_id    varchar(255),
  @@bSaldo    smallint
) 

as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
declare @doc_id   int
declare @cue_id   int
declare @ccos_id   int
declare @cico_id   int
declare @emp_id   int 

declare @ram_id_documento         int
declare @ram_id_cuenta             int
declare @ram_id_centrocosto       int
declare @ram_id_circuitocontable   int
declare @ram_id_Empresa           int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@doc_id,  @doc_id   out, @ram_id_documento        out
exec sp_ArbConvertId @@cue_id,   @cue_id   out, @ram_id_cuenta           out
exec sp_ArbConvertId @@ccos_id, @ccos_id   out, @ram_id_centrocosto       out
exec sp_ArbConvertId @@cico_id, @cico_id   out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,   @emp_id   out, @ram_id_Empresa           out 

exec sp_GetRptId @clienteID out

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

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
-- Saldo inicial

select 
      0                                         as [Orden],
      0                                         as as_id,
      0                                         as id_cliente,
      0                                         as doct_id_cliente,

      cue_codigo                                as [Codigo],
      cue_nombre                                as [Cuenta],
      @@Fini                                    as [Fecha],
      ''                                        as [Tipo documento],
      ''                                        as [Empresa], 

      'Saldo inicial'                           as [Comprobante],
      ''                                        as [Comp. Origen],
      ''                                        as [Asiento],

      ''                                        as Cliente,
      ''                                        as Proveedor,

      ''                                        as [Numero],
      ''                                        as [Descripcion],
      ''                                        as [Centro Costo],
      sum(asi_debe)                              as [Debe],
      sum(asi_haber)                             as [Haber],
      0                                          as [Saldo],
      sum(case 
        when asi_debe > 0 then asi_origen        
        else 0
      end)                                      as [Debe mon Ext],
      sum(case 
        when asi_haber > 0 then asi_origen        
        else 0
      end)                                      as [Haber mon Ext],
      0                                          as [Saldo mon Ext],
      @@bMonExt                                 as [Ver mon Ext]

from

      AsientoItem asi         inner join Cuenta cue             on     asi.cue_id  = cue.cue_id 
                                                                  and @@bSaldo <> 0

                              inner join Asiento ast            on asi.as_id           = ast.as_id
                              inner join Documento doc          on ast.doc_id          = doc.doc_id
                              inner join Empresa emp           on doc.emp_id          = emp.emp_id 
                              inner join CircuitoContable  cico on doc.cico_id         = cico.cico_id
                              inner join DocumentoTipo doct    on ast.doct_id         = doct.doct_id
                              left  join DocumentoTipo doctcl  on ast.doct_id_cliente = doctcl.doct_id
                              left  join Documento doccl       on ast.doc_id_cliente  = doccl.doc_id
                              left  join Cheque cheq           on asi.cheq_id         = cheq.cheq_id
where 
          (      (asi.cheq_id is null and as_fecha < @@Fini)
            or  (cheq_fecha2 < @@Fini)
          )
      and @@bSaldo <> 0

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (ast.doc_id_cliente = @doc_id or @doc_id=0)
and   (cue.cue_id = @cue_id or @cue_id=0)
and   (asi.ccos_id = @ccos_id or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001
                  and  rptarb_hojaid = ast.doc_id_cliente
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
                  and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
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
      cue_codigo,
      cue_nombre

union all

--////////////////////////////////////////////////////////////////////////
-- Entre fechas

select 
      1                                         as Orden,
      ast.as_id,
      id_cliente,
      doct_id_cliente,
      cue_codigo                                as Codigo,
      cue_nombre                                as Cuenta,
      isnull(cheq_fecha2,as_fecha)              as Fecha,
      IsNull(doctcl.doct_nombre,
             doct.doct_nombre)                  as [Tipo documento],
      emp_nombre                                as Empresa, 

      as_nrodoc + ' ' 
      + isnull(doctcli.doct_codigo,'') + ' ' 
      + as_doc_cliente                           as Comprobante,

      as_doc_cliente                            as [Comp. Origen],
      as_nrodoc                                  as [Asiento],

      cli_nombre                                as Cliente,
      prov_nombre                               as Proveedor,

      as_numero                                 as Numero,
      as_descrip                                as Descripcion,
      ccos_nombre                                as [Centro Costo],
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

      AsientoItem asi         inner join Cuenta cue             on asi.cue_id          = cue.cue_id
                              inner join Asiento ast            on asi.as_id           = ast.as_id
                              inner join Documento doc          on ast.doc_id          = doc.doc_id
                              inner join Empresa emp           on doc.emp_id          = emp.emp_id 
                              inner join CircuitoContable  cico on doc.cico_id         = cico.cico_id
                              inner join DocumentoTipo doct    on ast.doct_id         = doct.doct_id
                              left  join CentroCosto ccos       on asi.ccos_id         = ccos.ccos_id
                              left  join DocumentoTipo doctcl  on ast.doct_id_cliente = doctcl.doct_id
                              left  join Documento doccl       on ast.doc_id_cliente  = doccl.doc_id

                              left  join FacturaVenta fv       on doct_id_cliente in (1,7,9) and fv.as_id  = ast.as_id
                              left  join FacturaCompra fc      on doct_id_cliente in (2,8,10) and fc.as_id = ast.as_id
                              left  join Cobranza cobz         on doct_id_cliente = 13 and cobz.as_id = ast.as_id
                              left  join OrdenPago opg         on doct_id_cliente = 16 and opg.as_id = ast.as_id
                              left  join MovimientoFondo mf    on doct_id_cliente = 26 and mf.as_id = ast.as_id

                              left  join Cliente cli on      fv.cli_id   = cli.cli_id 
                                                          or cobz.cli_id = cli.cli_id 
                                                          or mf.cli_id   = cli.cli_id

                              left  join Proveedor prov on   fc.prov_id  = prov.prov_id 
                                                          or opg.prov_id = prov.prov_id 

                              left  join Cheque cheq on asi.cheq_id = cheq.cheq_id

                              left  join DocumentoTipo doctcli on ast.doct_id_cliente = doctcli.doct_id

where 

          (      (asi.cheq_id is null and (as_fecha >= @@Fini and  as_fecha <= @@Ffin))
            or  (cheq_fecha2 >= @@Fini and  cheq_fecha2 <= @@Ffin)
          )
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (ast.doc_id_cliente = @doc_id or @doc_id=0)
and   (cue.cue_id = @cue_id or @cue_id=0)
and   (ccos.ccos_id = @ccos_id or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001
                  and  rptarb_hojaid = ast.doc_id_cliente
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
                  and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
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

order by cue_nombre, cue_codigo, orden, Fecha, [Comp. Origen]

end
go