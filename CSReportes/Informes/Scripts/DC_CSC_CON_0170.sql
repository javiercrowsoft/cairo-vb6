/*---------------------------------------------------------------------
Nombre: Mayor de cuentas con detalle de cheques y cuentas relacionadas
        si existe el cheque toma la fecha del campo cheq_fechacobro
        sino usa as_fecha
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0170]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0170]


/*

 [DC_CSC_CON_0170] 1,'20060120 00:00:00','20060131 00:00:00','0','0','0',0,'0',0

 [DC_CSC_CON_0170] 1,'20060120 00:00:00','20060129 00:00:00','0','0','0',0,'0',0

*/

go
create procedure DC_CSC_CON_0170(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id     varchar(255),
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
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


declare @ram_id_cuenta int
declare @ram_id_centrocosto int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

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


if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end


create table #t_dc_csc_con_0170 (
        [Orden]                  int,
        as_id                    int,
        id_cliente              int,
        doct_id_cliente          int,
        cue_id                  int,
        asi_id                  int,
        cheq_id                 int,
        [Cuenta]                varchar(255),
        [Fecha]                  datetime,
        [Tipo documento]        varchar(255),
        [Empresa]                varchar(255), 
        [Comprobante]            varchar(500),
        [Asiento]                varchar(50),
        [Numero]                varchar(50),
        [Descripcion]            varchar(5000),
        [Centro Costo]          varchar(255),
        [Debe]                  decimal(18,6),
        [Haber]                  decimal(18,6),
        [Saldo]                  decimal(18,6),
        [Debe mon Ext]          decimal(18,6),
        [Haber mon Ext]          decimal(18,6),
        [Saldo mon Ext]          decimal(18,6)
)

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

--////////////////////////////////////////////////////////////////////////
-- Saldo inicial
insert into #t_dc_csc_con_0170

select 
      0                                         as [Orden],
      0                                         as as_id,
      0                                         as id_cliente,
      0                                         as doct_id_cliente,
      asi.cue_id,
      0                                          as asi_id,
      0                                          as cheq_id,

      cue_nombre                                as [Cuenta],
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
      0                                          as [Saldo],
      sum(case 
        when asi_debe > 0 then asi_origen        
        else 0
      end)                                      as [Debe mon Ext],
      sum(case 
        when asi_haber > 0 then asi_origen        
        else 0
      end)                                      as [Haber mon Ext],
      0                                          as [Saldo mon Ext]

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
          --as_fecha < @@Fini  
          (      (as_fecha < @@Fini and asi.cheq_id is null) 
            or  (cheq_fechacobro < @@Fini and cheq_fechacobro >= as_fecha)
            or  (as_fecha < @@Fini and cheq_fechacobro < as_fecha)
          )
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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

  group by
            asi.cue_id, cue_nombre

union all

--////////////////////////////////////////////////////////////////////////
-- Entre fechas

select 
      1                                         as Orden,
      ast.as_id,
      id_cliente,
      doct_id_cliente,
      asi.cue_id,
      asi.asi_id,
      asi.cheq_id,

      cue_nombre                                as Cuenta,
      as_fecha                                  as Fecha,
      IsNull(doctcl.doct_nombre,
             doct.doct_nombre)                  as [Tipo documento],
      emp_nombre                                as Empresa, 
      as_doc_cliente                             as Comprobante,
      as_nrodoc                                  as [Asiento],
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
      0                                          as [Saldo mon Ext]

from

      AsientoItem asi         inner join Cuenta cue             on asi.cue_id          = cue.cue_id
                              left  join CentroCosto ccos       on asi.ccos_id         = ccos.ccos_id
                              inner join Asiento ast            on asi.as_id           = ast.as_id
                              inner join Documento doc          on ast.doc_id          = doc.doc_id
                              inner join Empresa emp           on doc.emp_id          = emp.emp_id 
                              inner join CircuitoContable  cico on doc.cico_id         = cico.cico_id
                              inner join DocumentoTipo doct    on ast.doct_id         = doct.doct_id
                              left  join DocumentoTipo doctcl  on ast.doct_id_cliente = doctcl.doct_id
                              left  join Documento doccl       on ast.doc_id_cliente  = doccl.doc_id
                              left  join Cheque cheq           on asi.cheq_id         = cheq.cheq_id

where 

--           as_fecha >= @@Fini
--       and  as_fecha <= @@Ffin

          (
              (      as_fecha between @@Fini and @@Ffin
                and asi.cheq_id is null
              )
            or (cheq_fechacobro between @@Fini and @@Ffin and cheq_fechacobro >= as_fecha)
            or (as_fecha between @@Fini and @@Ffin and as_fecha > cheq_fechacobro)
          )

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id   = @cue_id   or @cue_id=0)
and   (ccos.ccos_id = @ccos_id   or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id   = @emp_id   or @emp_id=0) 

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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )


select 

      asi.[Orden]                  ,
      asi.as_id                    ,
      asi.id_cliente              ,
      asi.doct_id_cliente          ,
      asi.cue_id                  ,
      asi.asi_id                  ,
      asi.cheq_id                 ,
      asi.[Cuenta]                ,
      asi.[Fecha]                  ,
      asi.[Tipo documento]        ,
      asi.[Empresa]                , 
      asi.[Comprobante]            ,
      asi.[Asiento]                ,
      asi.[Numero]                ,
      asi.[Descripcion]            ,
      asi.[Centro Costo]          ,
      asi.[Debe]                  ,
      asi.[Haber]                  ,
      asi.[Saldo]                  ,
      asi.[Debe mon Ext]          ,
      asi.[Haber mon Ext]          ,
      asi.[Saldo mon Ext]          ,

      1                     as orden_id,                                    
      @@bMonExt             as [Ver mon Ext],

      null                   as [Cheque],
      null                  as [Nro. Cheque],
      null                   as Importe,      
      null                   as [Importe Origen],
      null                  as Tipo,
      null                  as Cobro,
      null                  as Vencimiento,
      null                  as Observaciones,
      null                  as Clearing,

      null            as [Cuenta Rel.],
      null            as [Importe Rel.]

from #t_dc_csc_con_0170  asi  

union

select 
      asi.[Orden]                  ,
      asi.as_id                    ,
      asi.id_cliente              ,
      asi.doct_id_cliente          ,
      asi.cue_id                  ,
      asi.asi_id                  ,
      asi.cheq_id                 ,
      asi.[Cuenta]                ,
      asi.[Fecha]                  ,
      asi.[Tipo documento]        ,
      asi.[Empresa]                , 
      asi.[Comprobante]            ,
      asi.[Asiento]                ,
      asi.[Numero]                ,
      asi.[Descripcion]            ,
      asi.[Centro Costo]          ,
      0 as [Debe]                  ,
      0 as [Haber]                ,
      asi.[Saldo]                  ,
      asi.[Debe mon Ext]          ,
      asi.[Haber mon Ext]          ,
      asi.[Saldo mon Ext]          ,

      2                     as orden_id,                                    
      @@bMonExt             as [Ver mon Ext],
/*
      null                   as [Cheque],
      null                  as [Nro. Cheque],
      null                   as Importe,      
      null                   as [Importe Origen],
      null                  as Tipo,
      null                  as Cobro,
      null                  as Vencimiento,
      null                  as Observaciones,
      null                  as Clearing
*/
      cheq_numero                                as [Cheque],
      cheq_numerodoc                            as [Nro. Cheque],
      cheq_importe                              as Importe,
      cheq_importeOrigen                        as [Importe Origen],
      case
          when cheq_tipo = 1 then 'Propio'
          else                    'De tercero'
      end                                        as Tipo,
      cheq_fechacobro                           as Cobro,
      cheq_fechaVto                              as Vencimiento,
      cheq_descrip                              as Observaciones,
      cle_nombre                                as Clearing,

      null            as [Cuenta Rel.],
      null            as [Importe Rel.]



from #t_dc_csc_con_0170 asi    inner join Cheque cheq          on asi.cheq_id  = cheq.cheq_id
                              inner join Clearing cle         on cheq.cle_id  = cle.cle_id

union

select 
        asi.[Orden]                  ,
        asi.as_id                    ,
        asi.id_cliente              ,
        asi.doct_id_cliente          ,
        asi.cue_id                  ,
        asi.asi_id                  ,
        asi.cheq_id                 ,
        asi.[Cuenta]                ,
        asi.[Fecha]                  ,
        asi.[Tipo documento]        ,
        asi.[Empresa]                , 
        asi.[Comprobante]            ,
        asi.[Asiento]                ,
        asi.[Numero]                ,
        asi.[Descripcion]            ,
        asi.[Centro Costo]          ,
        0 as [Debe]                  ,
        0 as [Haber]                ,
        asi.[Saldo]                  ,
        asi.[Debe mon Ext]          ,
        asi.[Haber mon Ext]          ,
        asi.[Saldo mon Ext]          ,

      3                     as orden_id,                                    
      @@bMonExt             as [Ver mon Ext],

      null                   as [Cheque],
      null                  as [Nro. Cheque],
      null                   as Importe,      
      null                   as [Importe Origen],
      null                  as Tipo,
      null                  as Cobro,
      null                  as Vencimiento,
      null                  as Observaciones,
      null                  as Clearing,

      cue_nombre            as [Cuenta Rel.],
      asi_debe + asi_haber  as [Importe Rel.]



from #t_dc_csc_con_0170 asi    inner join AsientoItem asi2     on     asi.as_id  =  asi2.as_id
                                                                and asi.asi_id <> asi2.asi_id
                                                                and asi.debe   = asi2.asi_haber
                                                                and asi.haber  = asi2.asi_debe
                              inner join Cuenta cue           on asi2.cue_id = cue.cue_id


order by Cuenta, Orden, Fecha, Comprobante, asi_id, orden_id, Cobro

end
go

