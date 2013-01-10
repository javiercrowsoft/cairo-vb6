-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*
DC_CSC_CON_0060 7,
                '20010101',
                '20100101',
                '0',
                '0',
                '0',
                1
*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0060]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0060]

go
create procedure DC_CSC_CON_0060(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id     varchar(255),
  @@cico_id    varchar(255), -- TODO:EMPRESA
  @@emp_id    varchar(255)

) 

as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id int
declare @cico_id int
declare @emp_id   int -- TODO:EMPRESA

declare @ram_id_cuenta int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out -- TODO:EMPRESA

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

-- TODO:EMPRESA
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
      1                                         as Orden,
      cue_nombre                                as Cuenta,
      sum(asi_debe)                             as Debe,
      sum(asi_haber)                             as Haber,
      sum(asi_debe)-sum(asi_haber)              as Saldo
from

      AsientoItem             inner join Cuenta                on AsientoItem.cue_id      = Cuenta.cue_id
                              inner join Asiento               on AsientoItem.as_id       = Asiento.as_id
                              inner join Documento             on Asiento.doc_id          = Documento.doc_id
                              inner join Empresa               on documento.emp_id        = Empresa.emp_id -- TODO:EMPRESA
                              inner join CircuitoContable       on Documento.cico_id       = CircuitoContable.cico_id
where 

          as_fecha >= @@Fini
      and  as_fecha <= @@Ffin
-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = documento.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Cuenta.cue_id = @cue_id or @cue_id=0)
and   (CircuitoContable.cico_id = @cico_id or @cico_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

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
                  and  tbl_id = 1016 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Documento.cico_id
                 ) 
           )
        or 
           (@ram_id_circuitocontable = 0)
       )
-- TODO:EMPRESA
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = documento.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )
group by cue_nombre
order by cue_nombre

end
go