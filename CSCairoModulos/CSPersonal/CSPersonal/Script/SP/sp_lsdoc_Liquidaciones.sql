/*


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Liquidaciones]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Liquidaciones]
go

/*

sp_lsdoc_Liquidaciones 1,'20060101','20101231','0','0','0','0','0','0'

*/

create procedure sp_lsdoc_Liquidaciones (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@ccos_id  varchar(255),
  @@em_id   varchar(255),
  @@est_id  varchar(255),
  @@suc_id  varchar(255),
  @@doc_id  varchar(255),
  @@emp_id  varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @ccos_id   int
declare @em_id     int
declare @suc_id   int
declare @est_id   int
declare @doc_id   int
declare @emp_id   int

declare @ram_id_CentroCosto int
declare @ram_id_Empleado int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Documento int
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@ccos_id,     @ccos_id out,     @ram_id_CentroCosto out
exec sp_ArbConvertId @@em_id,       @em_id out,       @ram_id_Empleado out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id,       @est_id out,       @ram_id_Estado out
exec sp_ArbConvertId @@doc_id,       @doc_id out,       @ram_id_Documento out
exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_CentroCosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
  end else 
    set @ram_id_CentroCosto = 0
end

if @ram_id_Empleado <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Empleado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empleado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empleado, @clienteID 
  end else 
    set @ram_id_Empleado = 0
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

if @ram_id_Documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
  end else 
    set @ram_id_Documento = 0
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

create table #t_empleado_liquidacion (liq_id int)

  if not (@em_id = 0 and @ram_id_Empleado = 0) begin

    insert into #t_empleado_periodo
  
    select liq_id 
    from LiquidacionItem liqi
    where (liqi.em_id = @em_id or @em_id = 0)
      and (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 35005
                      and  rptarb_hojaid = liqi.em_id
                     ) 
               )
            or 
               (@ram_id_Empleado = 0)
           )
  end
----------------------------------------------------------------------------


select 
      liq_id,
      ''                    as [TypeTask],
      liq_numero            as [Número],
      liq_nrodoc            as [Comprobante],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      liq_fecha              as [Fecha],
      liq_neto              as [Neto],
      liq_total              as [Total],
      case liq_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      case impreso
        when 0 then 'No'
        else        'Si'
      end                    as [Impreso],
      
      ccos_nombre          as [Centro de costo],
      suc_nombre          as [Sucursal],
      emp_nombre          as [Empresa],

      Liquidacion.Creado,
      Liquidacion.Modificado,
      us_nombre             as [Modifico],
      liq_descrip            as [Observaciones]

from 
      Liquidacion inner join documento      on Liquidacion.doc_id   = documento.doc_id
                  inner join empresa        on documento.emp_id     = empresa.emp_id     
                  inner join estado         on Liquidacion.est_id   = estado.est_id
                  inner join sucursal       on Liquidacion.suc_id   = sucursal.suc_id
                  inner join usuario        on Liquidacion.modifico = usuario.us_id
                  left  join centrocosto    on Liquidacion.ccos_id  = centrocosto.ccos_id
where 

          @@Fini <= liq_fecha
      and  @@Ffin >= liq_fecha     

      and (           (@em_id = 0 and @ram_id_Empleado = 0) 
            or exists(select * from #t_empleado_liquidacion where liq_id = Liquidacion.liq_id)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 
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
                  and  tbl_id = 4005 
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
                  and  tbl_id = 1007 
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
                  and  tbl_id = 4001 
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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = Empresa.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

  order by liq_fecha, Comprobante
go