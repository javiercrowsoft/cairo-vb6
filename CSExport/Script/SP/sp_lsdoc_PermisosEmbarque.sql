/*

sp_lsdoc_PermisosEmbarque 7,'20030101 00:00:00','20050101 00:00:00','0','2','0','0','0','0','0'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PermisosEmbarque]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PermisosEmbarque]
go

/*
select * from PermisoEmbarque

sp_docPermisoEmbarqueget 47

sp_lsdoc_PermisosEmbarque

  7,
  '20030101',
  '20050101',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'

*/

create procedure sp_lsdoc_PermisosEmbarque (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@emb_id  varchar(255),
@@est_id  varchar(255),
@@ccos_id  varchar(255),
@@suc_id  varchar(255),
@@bco_id  varchar(255),
@@doc_id  varchar(255),
@@adu_id  varchar(255),
@@emp_id  varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @emb_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @bco_id int
declare @doc_id int
declare @adu_id int
declare @emp_id int

declare @ram_id_Embarque int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Banco int
declare @ram_id_Documento int
declare @ram_id_Aduana int  
declare @ram_id_empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@emb_id, @emb_id out, @ram_id_Embarque out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@bco_id, @bco_id out, @ram_id_Banco out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@adu_id, @adu_id out, @ram_id_Aduana out 
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Embarque <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Embarque, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Embarque, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Embarque, @clienteID 
  end else 
    set @ram_id_Embarque = 0
end

if @ram_id_CentroCosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
  end else 
    set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
  end else 
    set @ram_id_Estado = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_Banco <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Banco, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Banco, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Banco, @clienteID 
  end else 
    set @ram_id_Banco = 0
end

if @ram_id_Documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
  end else 
    set @ram_id_Documento = 0
end

if @ram_id_Aduana <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Aduana, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Aduana, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Aduana, @clienteID 
  end else 
    set @ram_id_Aduana = 0
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
-- sp_columns PermisoEmbarque


select 
      pemb_id,
      ''                      as [TypeTask],
      pemb_numero             as [Número],
      pemb_nrodoc              as [Comprobante],
      emb_nombre              as [Embarque],
      doc_nombre              as [Documento],
      est_nombre              as [Estado],
      pemb_fecha              as [Fecha],
      pemb_Total              as [Total],
      pemb_TotalOrigen        as [Total Origen],
      pemb_pendiente          as [Pendiente],
      case pemb_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      lp_nombre            as [Lista de Precios],
      adu_nombre          as [Aduana],
      bco_nombre          as [Banco],
      ccos_nombre          as [Centro de costo],
      suc_nombre          as [Sucursal],
      emp_nombre          as [Empresa],

      PermisoEmbarque.Creado,
      PermisoEmbarque.Modificado,
      us_nombre               as [Modifico],
      pemb_descrip            as [Observaciones]
from 
      PermisoEmbarque inner join Documento     on PermisoEmbarque.doc_id   = Documento.doc_id
                      inner join empresa       on documento.emp_id         = empresa.emp_id
                      inner join Aduana        on PermisoEmbarque.adu_id   = Aduana.adu_id
                      inner join Estado        on PermisoEmbarque.est_id   = Estado.est_id
                      inner join Sucursal      on PermisoEmbarque.suc_id   = Sucursal.suc_id
                      inner join Embarque      on PermisoEmbarque.emb_id   = Embarque.emb_id
                      inner join Usuario       on PermisoEmbarque.modifico = Usuario.us_id
                      inner join Banco         on PermisoEmbarque.bco_id   = Banco.bco_id
                      left join Centrocosto    on PermisoEmbarque.ccos_id  = Centrocosto.ccos_id
                      left join Listaprecio    on PermisoEmbarque.lp_id    = Listaprecio.lp_id

where 

          @@Fini <= pemb_fecha
      and  @@Ffin >= pemb_fecha     

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Embarque.emb_id = @emb_id or @emb_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (Aduana.adu_id = @adu_id or @adu_id=0) 
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (Banco.bco_id = @bco_id or @bco_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 22002 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Embarque.emb_id
                 ) 
           )
        or 
           (@ram_id_Embarque = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = CentroCosto.ccos_id
                 ) 
           )
        or 
           (@ram_id_CentroCosto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Estado.est_id
                 ) 
           )
        or 
           (@ram_id_Estado = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Sucursal.suc_id
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
                  and  tbl_id = 13 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Banco.bco_id
                 ) 
           )
        or 
           (@ram_id_Banco = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Documento.doc_id
                 ) 
           )
        or 
           (@ram_id_Documento = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 22001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Aduana.adu_id
                 ) 
           )
        or 
           (@ram_id_Aduana = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Empresa.emp_id
                 ) 
           )
        or 
           (@ram_id_empresa = 0)
       )

  order by pemb_fecha
go