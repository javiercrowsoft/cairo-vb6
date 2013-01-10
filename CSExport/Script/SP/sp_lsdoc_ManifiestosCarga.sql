/*

sp_lsdoc_ManifiestosCarga 7,'20000101','20050101','0','0','0','0','0','0','0','0','0','0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ManifiestosCarga]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ManifiestosCarga]

go
create procedure sp_lsdoc_ManifiestosCarga (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@cli_id varchar(255),
@@est_id varchar(255),
@@ccos_id  varchar(255),
@@suc_id  varchar(255),
@@barc_id  varchar(255),
@@doc_id  varchar(255),
@@trans_id  varchar(255),
@@chof_id  varchar(255),
@@pue_id_origen  varchar(255),
@@pue_id_destino varchar(255),
@@depl_id_origen varchar(255),
@@depl_id_destino varchar(255),
@@cmarc_id varchar(255),
@@emp_id  varchar(255)
)as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @est_id int
declare @ccos_id int
declare @suc_id int
declare @barc_id int
declare @doc_id int
declare @trans_id int
declare @chof_id int
declare @pue_id_origen int
declare @pue_id_destino int
declare @cmarc_id int
declare @depl_id_origen int
declare @depl_id_destino int
declare @emp_id int

declare @ram_id_Cliente int
declare @ram_id_Estado int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Barco int
declare @ram_id_Documento int
declare @ram_id_Transporte int
declare @ram_id_Chofer int
declare @ram_id_Origen int
declare @ram_id_Destino int
declare @ram_id_DepositoOrigen int
declare @ram_id_DepositoDestino int
declare @ram_id_ContraMarca int
declare @ram_id_empresa int

declare @clienteID int
declare @clienteID2 int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@barc_id, @barc_id out, @ram_id_Barco out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@trans_id, @trans_id out, @ram_id_Transporte out
exec sp_ArbConvertId @@chof_id, @chof_id out, @ram_id_Chofer out
exec sp_ArbConvertId @@pue_id_origen, @pue_id_origen out, @ram_id_Origen out
exec sp_ArbConvertId @@pue_id_destino, @pue_id_destino out, @ram_id_Destino out
exec sp_ArbConvertId @@depl_id_origen, @depl_id_origen out, @ram_id_DepositoOrigen out
exec sp_ArbConvertId @@depl_id_destino, @depl_id_destino out, @ram_id_DepositoDestino out
exec sp_ArbConvertId @@cmarc_id, @cmarc_id out, @ram_id_ContraMarca out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out 

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteID2 out

if @ram_id_Cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
  end else 
    set @ram_id_Cliente = 0
end

if @ram_id_Estado <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
  end else 
    set @ram_id_Estado = 0
end

if @ram_id_CentroCosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
  end else 
    set @ram_id_CentroCosto = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_Barco <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Barco, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Barco, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Barco, @clienteID 
  end else 
    set @ram_id_Barco = 0
end

if @ram_id_Documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
  end else 
    set @ram_id_Documento = 0
end

if @ram_id_Transporte <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Transporte, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Transporte, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Transporte, @clienteID 
  end else 
    set @ram_id_Transporte = 0
end

if @ram_id_Chofer <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Chofer, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Chofer, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Chofer, @clienteID 
  end else 
    set @ram_id_Chofer = 0
end

if @ram_id_Origen <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Origen, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Origen, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Origen, @clienteID 
  end else 
    set @ram_id_Origen = 0
end

if @ram_id_Destino <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Destino, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Destino, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Destino, @clienteID2 
  end else 
    set @ram_id_Destino = 0
end

if @ram_id_DepositoOrigen <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoOrigen, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoOrigen, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoOrigen, @clienteID 
  end else 
    set @ram_id_DepositoOrigen = 0
end

if @ram_id_DepositoDestino <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoDestino, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoDestino, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoDestino, @clienteID2 
  end else 
    set @ram_id_DepositoDestino = 0
end

if @ram_id_ContraMarca <> 0 begin

--  exec sp_ArbGetGroups @ram_id_ContraMarca, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_ContraMarca, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_ContraMarca, @clienteID 
  end else 
    set @ram_id_ContraMarca = 0
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

select 
      mfc_id,
      ''                      as [TypeTask],
      mfc_numero              as [Número],
      mfc_nrodoc              as [Comprobante],
      cli_nombre              as [Cliente],
      doc_nombre              as [Documento],
      est_nombre              as [Estado],
      mfc_fecha                as [Fecha],
      mfc_cantidad            as [Cantidad],
      mfc_pendiente            as [Pendiente],
      case mfc_firmado
        when 0 then 'No'
        else        'Si'
      end                      as [Firmado],
      
      trans_nombre         as [Transporte],
      barc_nombre          as [Barco],
      ccos_nombre           as [Centro de costo],
      suc_nombre           as [Sucursal],
      emp_nombre           as [Empresa],
      chof_nombre          as [Chofer],
      Origen.pue_nombre    as [Puerto Origen],
      Destino.pue_nombre   as [Puerto Destino],
      dOrigen.depl_nombre  as [Deposito Origen],
      dDestino.depl_nombre as [Deposito Destino],
      cmarc_nombre         as [Contra Marca],

      mfc.Creado,
      mfc.Modificado,
      us_nombre             as [Modifico],
      mfc_descrip            as [Observaciones]
from 
      ManifiestoCarga mfc inner join Documento      on mfc.doc_id         = Documento.doc_id
                          inner join empresa        on documento.emp_id   = empresa.emp_id
                          left  join Transporte     on mfc.trans_id       = Transporte.trans_id
                          inner join Estado         on mfc.est_id         = Estado.est_id
                          inner join Sucursal       on mfc.suc_id         = Sucursal.suc_id
                          inner join Cliente        on mfc.cli_id         = Cliente.cli_id
                          inner join Usuario        on mfc.modifico       = Usuario.us_id
                          left  join Barco          on mfc.barc_id        = Barco.barc_id
                          left  join Chofer         on mfc.chof_id        = Chofer.chof_id
                          left  join Puerto Origen  on mfc.pue_id_origen  = Origen.pue_id
                          left  join Puerto Destino on mfc.pue_id_destino = Destino.pue_id
                          left  join ContraMarca    on mfc.cmarc_id       = ContraMarca.cmarc_id
                          left  join Centrocosto    on mfc.ccos_id        = Centrocosto.ccos_id

                          left  join DepositoLogico dOrigen  on mfc.depl_id_origen  = dOrigen.depl_id
                          left  join DepositoLogico dDestino on mfc.depl_id_destino = dDestino.depl_id
where 

          @@Fini <= mfc_fecha
      and  @@Ffin >= mfc_fecha     


/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (mfc.cli_id = @cli_id or @cli_id=0)
and   (mfc.est_id = @est_id or @est_id=0)
and   (mfc.ccos_id = @ccos_id or @ccos_id=0)
and   (mfc.suc_id = @suc_id or @suc_id=0)
and   (mfc.barc_id = @barc_id or @barc_id=0)
and   (mfc.doc_id = @doc_id or @doc_id=0)
and   (mfc.trans_id = @trans_id or @trans_id=0)
and   (mfc.chof_id = @chof_id or @chof_id=0)
and   (mfc.pue_id_origen = @pue_id_origen or @pue_id_origen=0)
and   (mfc.pue_id_destino = @pue_id_destino or @pue_id_destino=0)
and   (mfc.depl_id_origen = @depl_id_origen or @depl_id_origen=0)
and   (mfc.depl_id_destino = @depl_id_destino or @depl_id_destino=0)
and   (mfc.cmarc_id = @cmarc_id or @cmarc_id=0)
and   (documento.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.cli_id
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
                  and  tbl_id = 4005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.est_id
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
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.ccos_id
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
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.suc_id
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
                  and  tbl_id = 12004 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.barc_id
                 ) 
           )
        or 
           (@ram_id_Barco = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.doc_id
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
                  and  tbl_id = 34 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.trans_id
                 ) 
           )
        or 
           (@ram_id_Transporte = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.chof_id
                 ) 
           )
        or 
           (@ram_id_Chofer = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.pue_id_origen
                 ) 
           )
        or 
           (@ram_id_Origen = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID2
                  and  tbl_id = 12005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.pue_id_destino
                 ) 
           )
        or 
           (@ram_id_Destino = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.depl_id_origen
                 ) 
           )
        or 
           (@ram_id_DepositoOrigen = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID2
                  and  tbl_id = 11 -- select tbl_id from tabla where tbl_nombrefisico = 'depositologico'
                  and  rptarb_hojaid = mfc.depl_id_destino
                 ) 
           )
        or 
           (@ram_id_DepositoDestino = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12006 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfc.cmarc_id
                 ) 
           )
        or 
           (@ram_id_ContraMarca = 0)
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
end

GO