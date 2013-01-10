/*---------------------------------------------------------------------
Nombre: xxxxx
---------------------------------------------------------------------*/
/*
/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
NOMBRE_SP         Reemplazar por el nombre del sp ejemplo DC_CSC_PRY_00_10
2)
TABLA_ID1         Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
TABLA_ID2
TABLA_ID3
TABLA_ID4
TABLA_ID5
TABLA_ID6
TABLA_ID7
TABLA_ID8
TABLA_ID9
TABLA_ID_10
TABLA_ID_11
TABLA_ID_12
TABLA_ID_13
TABLA_ID_14
TABLA_ID_15


3)
RAM_ID_TABLA1     Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
RAM_ID_TABLA2
RAM_ID_TABLA3
RAM_ID_TABLA4
RAM_ID_TABLA5
RAM_ID_TABLA6
RAM_ID_TABLA7
RAM_ID_TABLA8
RAM_ID_TABLA9
RAM_ID_TABLA_10
RAM_ID_TABLA_11
RAM_ID_TABLA_12
RAM_ID_TABLA_13
RAM_ID_TABLA_14

4)
TABLA_DEL_LISTADO1 Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
TABLA_DEL_LISTADO2 
TABLA_DEL_LISTADO3 
TABLA_DEL_LISTADO4 
TABLA_DEL_LISTADO5 
TABLA_DEL_LISTADO6 
TABLA_DEL_LISTADO7 
TABLA_DEL_LISTADO8 
TABLA_DEL_LISTADO9 
TABLA_DEL_LISTADO_10 
TABLA_DEL_LISTADO_11 
TABLA_DEL_LISTADO_12 
TABLA_DEL_LISTADO_13 
TABLA_DEL_LISTADO_14 
TABLA_DEL_LISTADO_15 

5)
TBL_ID_TABLA1     Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
TBL_ID_TABLA2     Para saber el id de la tabla a listar usen:
TBL_ID_TABLA3
TBL_ID_TABLA4              select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%TABLA_DEL_LISTADO%'
TBL_ID_TABLA5
TBL_ID_TABLA6
TBL_ID_TABLA7
TBL_ID_TABLA8
TBL_ID_TABLA9
TBL_ID_TABLA_10
TBL_ID_TABLA_11
TBL_ID_TABLA_12
TBL_ID_TABLA_13
TBL_ID_TABLA_14
TBL_ID_TABLA_15

5)

NOMBRE_CAMPO_FECHA              Reemplazar por el nombre del campo fecha.

6)

TABLA_PRINCIPAL

Para testear:

NOMBRE_SP 'N596'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[NOMBRE_SP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[NOMBRE_SP]

go
create procedure NOMBRE_SP (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@TABLA_ID1 varchar(255),
@@TABLA_ID2 varchar(255),
@@TABLA_ID3  varchar(255),
@@TABLA_ID4  varchar(255),
@@TABLA_ID5  varchar(255),
@@TABLA_ID6  varchar(255),
@@TABLA_ID7  varchar(255),
@@TABLA_ID8  varchar(255),
@@TABLA_ID9  varchar(255),
@@TABLA_ID_10 varchar(255),
@@TABLA_ID_11 varchar(255),
@@TABLA_ID_12 varchar(255),
@@TABLA_ID_13 varchar(255),
@@TABLA_ID_14 varchar(255),
@@TABLA_ID_15 varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @TABLA_ID1 int
declare @TABLA_ID2 int
declare @TABLA_ID3 int
declare @TABLA_ID4 int
declare @TABLA_ID5 int
declare @TABLA_ID6 int
declare @TABLA_ID7 int
declare @TABLA_ID8 int
declare @TABLA_ID9 int
declare @TABLA_ID_10 int
declare @TABLA_ID_11 int
declare @TABLA_ID_12 int
declare @TABLA_ID_13 int
declare @TABLA_ID_14 int
declare @TABLA_ID_15 int

declare @RAM_ID_TABLA1 int
declare @RAM_ID_TABLA2 int
declare @RAM_ID_TABLA3 int
declare @RAM_ID_TABLA4 int
declare @RAM_ID_TABLA5 int
declare @RAM_ID_TABLA6 int
declare @RAM_ID_TABLA7 int
declare @RAM_ID_TABLA8 int
declare @RAM_ID_TABLA9 int
declare @RAM_ID_TABLA_10 int
declare @RAM_ID_TABLA_11 int
declare @RAM_ID_TABLA_12 int
declare @RAM_ID_TABLA_13 int
declare @RAM_ID_TABLA_14 int
declare @RAM_ID_TABLA_15 int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@TABLA_ID1, @TABLA_ID1 out, @RAM_ID_TABLA1 out
exec sp_ArbConvertId @@TABLA_ID2, @TABLA_ID2 out, @RAM_ID_TABLA2 out
exec sp_ArbConvertId @@TABLA_ID3, @TABLA_ID3 out, @RAM_ID_TABLA3 out
exec sp_ArbConvertId @@TABLA_ID4, @TABLA_ID4 out, @RAM_ID_TABLA4 out
exec sp_ArbConvertId @@TABLA_ID5, @TABLA_ID5 out, @RAM_ID_TABLA5 out
exec sp_ArbConvertId @@TABLA_ID6, @TABLA_ID6 out, @RAM_ID_TABLA6 out
exec sp_ArbConvertId @@TABLA_ID7, @TABLA_ID7 out, @RAM_ID_TABLA7 out
exec sp_ArbConvertId @@TABLA_ID8, @TABLA_ID8 out, @RAM_ID_TABLA8 out
exec sp_ArbConvertId @@TABLA_ID9, @TABLA_ID9 out, @RAM_ID_TABLA9 out
exec sp_ArbConvertId @@TABLA_ID_10, @TABLA_ID_10 out, @RAM_ID_TABLA_10 out
exec sp_ArbConvertId @@TABLA_ID_11, @TABLA_ID_11 out, @RAM_ID_TABLA_11 out
exec sp_ArbConvertId @@TABLA_ID_12, @TABLA_ID_12 out, @RAM_ID_TABLA_12 out
exec sp_ArbConvertId @@TABLA_ID_13, @TABLA_ID_13 out, @RAM_ID_TABLA_13 out
exec sp_ArbConvertId @@TABLA_ID_14, @TABLA_ID_14 out, @RAM_ID_TABLA_14 out
exec sp_ArbConvertId @@TABLA_ID_15, @TABLA_ID_15 out, @RAM_ID_TABLA_15 out

exec sp_GetRptId @clienteID out

if @RAM_ID_TABLA1 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA1, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA1, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA1, @clienteID 
  end else 
    set @RAM_ID_TABLA1 = 0
end

if @RAM_ID_TABLA2 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA2, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA2, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA2, @clienteID 
  end else 
    set @RAM_ID_TABLA2 = 0
end

if @RAM_ID_TABLA3 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA3, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA3, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA3, @clienteID 
  end else 
    set @RAM_ID_TABLA3 = 0
end

if @RAM_ID_TABLA4 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA4, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA4, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA4, @clienteID 
  end else 
    set @RAM_ID_TABLA4 = 0
end

if @RAM_ID_TABLA5 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA5, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA5, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA5, @clienteID 
  end else 
    set @RAM_ID_TABLA5 = 0
end

if @RAM_ID_TABLA6 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA6, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA6, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA6, @clienteID 
  end else 
    set @RAM_ID_TABLA6 = 0
end

if @RAM_ID_TABLA7 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA7, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA7, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA7, @clienteID 
  end else 
    set @RAM_ID_TABLA7 = 0
end

if @RAM_ID_TABLA8 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA8, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA8, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA8, @clienteID 
  end else 
    set @RAM_ID_TABLA8 = 0
end

if @RAM_ID_TABLA9 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA9, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA9, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA9, @clienteID 
  end else 
    set @RAM_ID_TABLA9 = 0
end

if @RAM_ID_TABLA_10 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA_10, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA_10, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA_10, @clienteID 
  end else 
    set @RAM_ID_TABLA_10 = 0
end

if @RAM_ID_TABLA_11 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA_11, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA_11, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA_11, @clienteID 
  end else 
    set @RAM_ID_TABLA_11 = 0
end

if @RAM_ID_TABLA_12 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA_12, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA_12, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA_12, @clienteID 
  end else 
    set @RAM_ID_TABLA_12 = 0
end

if @RAM_ID_TABLA_13 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA_13, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA_13, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA_13, @clienteID 
  end else 
    set @RAM_ID_TABLA_13 = 0
end

if @RAM_ID_TABLA_14 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA_14, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA_14, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA_14, @clienteID 
  end else 
    set @RAM_ID_TABLA_14 = 0
end

if @RAM_ID_TABLA_15 <> 0 begin

  exec sp_ArbGetGroups @RAM_ID_TABLA_15, @clienteID, @@us_id

  exec sp_ArbIsRaiz @RAM_ID_TABLA_15, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @RAM_ID_TABLA_15, @clienteID 
  end else 
    set @RAM_ID_TABLA_15 = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

-- Listado de columnas que corresponda  

from 

-- Listado de tablas que corresponda  
TABLA_DEL_LISTADO

where 

          NOMBRE_CAMPO_FECHA >= @@Fini
      and  NOMBRE_CAMPO_FECHA <= @@Ffin 

-- Validar usuario - empresa
      and (
            exists(select * from EmpresaUsuario where emp_id = documento.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (TABLA_DEL_LISTADO1.TABLA_ID1 = @TABLA_ID1 or @TABLA_ID1=0)
and   (TABLA_DEL_LISTADO2.TABLA_ID2 = @TABLA_ID2 or @TABLA_ID2=0)
and   (TABLA_DEL_LISTADO3.TABLA_ID3 = @TABLA_ID3 or @TABLA_ID3=0)
and   (TABLA_DEL_LISTADO4.TABLA_ID4 = @TABLA_ID4 or @TABLA_ID4=0)
and   (TABLA_DEL_LISTADO5.TABLA_ID5 = @TABLA_ID5 or @TABLA_ID5=0)
and   (TABLA_DEL_LISTADO6.TABLA_ID6 = @TABLA_ID6 or @TABLA_ID6=0)
and   (TABLA_DEL_LISTADO7.TABLA_ID7 = @TABLA_ID7 or @TABLA_ID7=0)
and   (TABLA_DEL_LISTADO8.TABLA_ID8 = @TABLA_ID8 or @TABLA_ID8=0)
and   (TABLA_DEL_LISTADO9.TABLA_ID9 = @TABLA_ID9 or @TABLA_ID9=0)
and   (TABLA_DEL_LISTADO_10.TABLA_ID_10 = @TABLA_ID_10 or @TABLA_ID_10=0)
and   (TABLA_DEL_LISTADO_11.TABLA_ID_11 = @TABLA_ID_11 or @TABLA_ID_11=0)
and   (TABLA_DEL_LISTADO_12.TABLA_ID_12 = @TABLA_ID_12 or @TABLA_ID_12=0)
and   (TABLA_DEL_LISTADO_13.TABLA_ID_13 = @TABLA_ID_13 or @TABLA_ID_13=0)
and   (TABLA_DEL_LISTADO_14.TABLA_ID_14 = @TABLA_ID_14 or @TABLA_ID_14=0)
and   (TABLA_DEL_LISTADO_15.TABLA_ID_15 = @TABLA_ID_15 or @TABLA_ID_15=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA1 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID1
                 ) 
           )
        or 
           (@RAM_ID_TABLA1 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA2 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID2
                 ) 
           )
        or 
           (@RAM_ID_TABLA2 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA3 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID3
                 ) 
           )
        or 
           (@RAM_ID_TABLA3 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA4 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID4
                 ) 
           )
        or 
           (@RAM_ID_TABLA4 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA5 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID5
                 ) 
           )
        or 
           (@RAM_ID_TABLA5 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA6 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID6
                 ) 
           )
        or 
           (@RAM_ID_TABLA6 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA7 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID7
                 ) 
           )
        or 
           (@RAM_ID_TABLA7 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA8 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID8
                 ) 
           )
        or 
           (@RAM_ID_TABLA8 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA9 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID9
                 ) 
           )
        or 
           (@RAM_ID_TABLA9 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA_10 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID_10
                 ) 
           )
        or 
           (@RAM_ID_TABLA_10 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA_11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID_11
                 ) 
           )
        or 
           (@RAM_ID_TABLA_11 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA_12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID_12
                 ) 
           )
        or 
           (@RAM_ID_TABLA_12 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA_13 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID_13
                 ) 
           )
        or 
           (@RAM_ID_TABLA_13 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA_14 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID_14
                 ) 
           )
        or 
           (@RAM_ID_TABLA_14 = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = TBL_ID_TABLA_15 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_PRINCIPAL.TABLA_ID_15
                 ) 
           )
        or 
           (@RAM_ID_TABLA_15 = 0)
       )
end
go