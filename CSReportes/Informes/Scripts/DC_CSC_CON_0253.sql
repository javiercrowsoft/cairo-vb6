
/*---------------------------------------------------------------------
Nombre: Movimientos de compras que impactaron en cuentas de acreedores
        en el debe siendo facturas o notas de debito o en el haber
        siendo notas de credito, lo que genera que la factura sume en
        la cuenta corriente, pero la cuenta acreedora no suma en la contabilidad
        ya que el debe y el haber se netean.
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0253]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0253]


/*
select * from documento where doc_nombre like '%cob%'

 [DC_CSC_CON_0253] 1,'20080101 00:00:00','20080930 00:00:00','567','0','0'

*/

go
create procedure DC_CSC_CON_0253(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id     varchar(255),
  @@cico_id    varchar(255),
  @@emp_id    varchar(255)

) 

as 

begin


/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
declare @cue_id   int
declare @cico_id   int
declare @emp_id   int 

declare @ram_id_cuenta             int
declare @ram_id_circuitocontable   int
declare @ram_id_Empresa           int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,   @cue_id   out, @ram_id_cuenta           out
exec sp_ArbConvertId @@cico_id, @cico_id   out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,   @emp_id   out, @ram_id_Empresa           out 

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
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

--
--

-- Facturas: Cuentas del Debe

select 
        ast.doct_id,
        asi.as_id           as comp_id,

        as_fecha            as Fecha, 
        as_nrodoc            as Asiento, 
        as_doc_cliente      as Comprobante, 
        cue_nombre          as Cuenta, 
        sum(asi_debe)       as Importe

from asientoitem asi   inner join cuenta cue     on asi.cue_id = cue.cue_id 
                      inner join asiento ast     on asi.as_id   = ast.as_id
                      inner join documento doc   on ast.doc_id = doc.doc_id
where
          as_fecha >= @@Fini
      and  as_fecha <= @@Ffin

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

and asi_debe <> 0

and asi.as_id in (

  select as_id 
  from facturacompra 
  where doct_id <> 8 
    and doc_id in (  select doc_id 
                    from documento 
                    where (cico_id = @cico_id or @cico_id=0)

                      and   (
                                (exists(select rptarb_hojaid 
                                        from rptArbolRamaHoja 
                                        where
                                             rptarb_cliente = @clienteID
                                        and  tbl_id = 1016 
                                        and  rptarb_hojaid = cico_id
                                       ) 
                                 )
                              or 
                                 (@ram_id_circuitocontable = 0)
                             )
                    )
)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (asi.cue_id = @cue_id or @cue_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0) 

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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by as_fecha, as_nrodoc, as_doc_cliente, cue_nombre, ast.doct_id, asi.as_id 

--/////////////////////////////////////////////////////////////////////////////////////////////////////////

union all

-- Notas de credito: Cuentas del haber

select 
        ast.doct_id,
        asi.as_id           as comp_id,

        as_fecha            as Fecha, 
        as_nrodoc            as Asiento, 
        as_doc_cliente      as Comprobante, 
        cue_nombre          as Cuenta, 
        sum(asi_haber)       as Importe

from asientoitem asi   inner join cuenta cue     on asi.cue_id = cue.cue_id 
                      inner join asiento ast     on asi.as_id   = ast.as_id
                      inner join documento doc   on ast.doc_id = doc.doc_id
where
          as_fecha >= @@Fini
      and  as_fecha <= @@Ffin

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

and asi_haber <> 0
and asi.as_id in (

  select as_id 
  from facturacompra 
  where doct_id = 8 
    and doc_id in (  select doc_id 
                    from documento 
                    where (cico_id = @cico_id or @cico_id=0)

                      and   (
                                (exists(select rptarb_hojaid 
                                        from rptArbolRamaHoja 
                                        where
                                             rptarb_cliente = @clienteID
                                        and  tbl_id = 1016 
                                        and  rptarb_hojaid = cico_id
                                       ) 
                                 )
                              or 
                                 (@ram_id_circuitocontable = 0)
                             )
                    )
)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (asi.cue_id = @cue_id or @cue_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0) 

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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )


group by as_fecha, as_nrodoc, as_doc_cliente, cue_nombre, ast.doct_id, asi.as_id 


order by as_fecha, as_nrodoc, as_doc_cliente, cue_nombre

end
go