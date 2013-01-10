/*---------------------------------------------------------------------
Nombre: Balance por mes
---------------------------------------------------------------------*/
/*
exec DC_CSC_CON_0050 

1,
'20000101',
'20100101',
'0',
'0',
'0',
'1'

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0050]

go
create procedure DC_CSC_CON_0050 (

  @@us_id    int,
  @@FDesde      datetime,
  @@FHasta      datetime,

@@cico_id varchar(255),
@@ccos_id varchar(255),
@@cue_id  varchar(255), -- TODO:EMPRESA
@@emp_id  varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cico_id int
declare @ccos_id int
declare @cue_id int
declare @emp_id int --TODO:EMPRESA

declare @ram_id_circuito int
declare @ram_id_centrocosto int
declare @ram_id_cuenta int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuito out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out -- TODO:EMPRESA

exec sp_GetRptId @clienteID out

if @ram_id_circuito <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuito, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuito, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuito, @clienteID 
  end else 
    set @ram_id_circuito = 0
end

if @ram_id_centrocosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
  end else 
    set @ram_id_centrocosto = 0
end

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
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

create table #Anterior(
                     cue_id int not null,
                     saldoA decimal (18,6)
                     )
insert #Anterior(cue_id, saldoA)

select 
              cue_id,
                sum(asi_debe)  
              - sum(asi_haber)

from 

            asientoitem ai inner join asiento a      on ai.as_id = a.as_id  
                           inner join documento d    on a.doc_id = d.doc_id
                           inner join Empresa        on d.emp_id = Empresa.emp_id -- TODO:EMPRESA

where

            as_fecha < @@FDesde  

-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (d.cico_id = @cico_id or @cico_id=0)
and   (ai.ccos_id = @ccos_id or @ccos_id=0)
and   (ai.cue_id = @cue_id or @cue_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.cico_id
                 ) 
           )
        or 
           (@ram_id_circuito = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = ai.ccos_id
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
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = ai.cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )
-- TODO:EMPRESA
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = d.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by 
            cue_id            

-------------------------------------------------------------------------

create table #Periodo(
                     cue_id  int not null,
                     debe    decimal (18,6),
                     haber   decimal (18,6),
                     saldoP  decimal (18,6)
                     )
insert #Periodo (cue_id, debe, haber, saldoP)            

select 
              cue_id,
              sum(asi_debe),
              sum(asi_haber),

                sum(asi_debe)  
              - sum(asi_haber)

from 

            asientoitem ai inner join asiento a      on ai.as_id = a.as_id  
                           inner join documento d    on a.doc_id = d.doc_id
                           inner join Empresa        on d.emp_id = Empresa.emp_id -- TODO:EMPRESA

 where
            as_fecha >= @@FDesde  
        and as_fecha <= @@FHasta
-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (d.cico_id = @cico_id or @cico_id=0)
and   (ai.ccos_id = @ccos_id or @ccos_id=0)
and   (ai.cue_id = @cue_id or @cue_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.cico_id
                 ) 
           )
        or 
           (@ram_id_circuito = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = ai.ccos_id
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
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = ai.cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )
-- TODO:EMPRESA
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = d.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by 
            cue_id

-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
select 
              c.cue_id,
              cue_nombre                           as [Cuenta],
              IsNull(saldoA,0)                     as [Saldo anterior],
              IsNull(debe,0)                       as [Debe],
              IsNull(haber,0)                      as [Haber],
              IsNull(saldoP,0)                     as [Saldo del periodo],
              IsNull(saldoA,0) + IsNull(saldoP,0)  as [Saldo al cierre]

from 

            cuenta c left join #Periodo   p on c.cue_id = p.cue_id
                     left join #Anterior  a on c.cue_id = a.cue_id

where (saldoA is not null or saldoP is not null)

order by 1
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
end
go


