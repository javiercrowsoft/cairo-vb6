
/*---------------------------------------------------------------------
Nombre: Mayor de cuentas por tercero
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0160]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0160]


/*

  select * from proveedor
  select * from cuenta where cue_nombre like '%acreedor%'

 [DC_CSC_CON_0160] 1,'20050223 00:00:00','20060131 00:00:00','423','0','0','4','0',0,'1',0

*/

go
create procedure DC_CSC_CON_0160(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id     varchar(255),
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
  @@prov_id   varchar(255),
  @@cli_id    varchar(255),
  @@bMonExt   smallint, 
  @@emp_id    varchar(255),
  @@bSaldo    smallint
) 

as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id int
declare @ccos_id int
declare @cico_id int
declare @emp_id int 


declare @ram_id_cuenta       int
declare @ram_id_centrocosto int
declare @cli_id   int
declare @prov_id   int
declare @ram_id_circuitocontable int
declare @ram_id_cliente   int
declare @ram_id_proveedor int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,   @cue_id out,   @ram_id_cuenta out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@cli_id,   @cli_id out,   @ram_id_cliente out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
exec sp_ArbConvertId @@emp_id,   @emp_id out,   @ram_id_Empresa out 

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

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
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
      cli_nombre                                as [Cliente],
      prov_nombre                               as [Proveedor],
      @@Fini                                    as [Fecha],
      ''                                        as [Tipo documento],
      ''                                        as [Empresa], 
      'Saldo inicial'                           as [Comprobante],
      ''                                         as [Asiento],
      ''                                        as [Numero],
      ''                                        as [Descripcion],
      ''                                        as [Centro Costo],
      sum(asi_debe)                              as [Debe],
      sum(asi_haber)                             as [Haber],
      sum(case 
        when asi_debe > 0 then asi_origen        
        else 0
      end)                                      as [Debe mon Ext],
      sum(case 
        when asi_haber > 0 then asi_origen        
        else 0
      end)                                      as [Haber mon Ext],
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

                       left join Cliente cli on     (fv.cli_id   = cli.cli_id    and doct_id_cliente in (1,7,9))
                                                or  (cobz.cli_id = cli.cli_id    and doct_id_cliente = 13)

                       left join Proveedor prov on     (fc.prov_id  = prov.prov_id    and doct_id_cliente in (2,8,10))
                                                or    (opg.prov_id = cli.cli_id      and doct_id_cliente = 16)

where 
          as_fecha < @@Fini  
      and @@bSaldo <> 0

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id   = @cue_id   or @cue_id=0)
and   (asi.ccos_id   = @ccos_id   or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id   = @emp_id   or @emp_id=0) 

and   (cli.cli_id     = @cli_id   or @cli_id=0)
and   (prov.prov_id   = @prov_id   or @prov_id=0)

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
                  and  tbl_id = 29 
                  and  rptarb_hojaid = prov.prov_id
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
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cli.cli_id
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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

  group by
      cue_codigo,
      cue_nombre,
      cli_nombre,
      prov_nombre

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
      cli_nombre                                as [Cliente],
      prov_nombre                               as [Proveedor],
      as_fecha                                  as Fecha,
      IsNull(doctcl.doct_nombre,
             doct.doct_nombre)                  as [Tipo documento],
      emp_nombre                                as Empresa, 

      case 
        when IsNull(doct_id_cliente,ast.doct_id) in (2,8,10) then fc.fc_nrodoc
        when IsNull(doct_id_cliente,ast.doct_id) in (1,7,9)  then fv.fv_nrodoc
        when IsNull(doct_id_cliente,ast.doct_id) = 26  then mf.mf_nrodoc
        when IsNull(doct_id_cliente,ast.doct_id) = 13  then cobz.cobz_nrodoc
        when IsNull(doct_id_cliente,ast.doct_id) = 16  then opg.opg_nrodoc
        else                                                as_doc_cliente
      end                                        as Comprobante,
      as_nrodoc                                  as [Asiento],
      as_numero                                 as Numero,
      as_descrip                                as Descripcion,
      ccos_nombre                                as [Centro Costo],
      asi_debe                                  as Debe,
      asi_haber                                  as Haber,
      case 
        when asi_debe > 0 then asi_origen        
        else 0
      end                                        as [Debe mon Ext],
      case 
        when asi_haber > 0 then asi_origen        
        else 0
      end                                        as [Haber mon Ext],
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

                       left join Cliente cli on     (fv.cli_id   = cli.cli_id    and doct_id_cliente in (1,7,9))
                                                or  (cobz.cli_id = cli.cli_id    and doct_id_cliente = 13)

                       left join Proveedor prov on     (fc.prov_id  = prov.prov_id    and doct_id_cliente in (2,8,10))
                                                or    (opg.prov_id = cli.cli_id      and doct_id_cliente = 16)

where 

          as_fecha >= @@Fini
      and  as_fecha <= @@Ffin

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id     = @cue_id   or @cue_id=0)
and   (ccos.ccos_id   = @ccos_id   or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id     = @emp_id   or @emp_id=0) 
and   (cli.cli_id     = @cli_id   or @cli_id=0)
and   (prov.prov_id   = @prov_id   or @prov_id=0)

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
                  and  tbl_id = 29 
                  and  rptarb_hojaid = prov.prov_id
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
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cli.cli_id
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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

order by cue_nombre, cue_codigo, orden, Fecha, Comprobante

end
go