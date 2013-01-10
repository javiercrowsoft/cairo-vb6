/*---------------------------------------------------------------------
Nombre: Imputacion Contable de Comprobantes de Compra por Cuenta
---------------------------------------------------------------------*/

-- Toma todas las facturas y analiza si se envio el total de la factura a la cuenta de proveedores
-- indicada como parametro. Si el total de la factura es distinto a lo contabilizado en la cuenta
-- lista la factura. Hace lo mismo con Ordenes de Pago

/*
  Para testear:

  select * from proveedor where prov_nombre like '%argent%'

  [DC_CSC_COM_0300] 1,'20050101 00:00:00','20051231 00:00:00','0','0','0','1',-1,'2',3

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0300]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0300]

go
create procedure [dbo].[DC_CSC_COM_0300] (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@prov_id        varchar(255),
  @@suc_id         varchar(255),
  @@cue_id         varchar(255), 
  @@cico_id        varchar(255),
  @@emp_id         varchar(255),
  @@minimo        decimal(18,6)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id  int
declare @suc_id   int
declare @cue_id   int
declare @cico_id  int
declare @emp_id   int 

declare @ram_id_Proveedor int
declare @ram_id_Sucursal   int
declare @ram_id_Cuenta     int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_Cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_Cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cuenta, @clienteID 
  end else 
    set @ram_id_Cuenta = 0
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


/*- ///////////////////////////////////////////////////////////////////////

ANALISIS DE LOS COMPROBANTES

/////////////////////////////////////////////////////////////////////// */

  create table #t_facturacompra   (fc_id  int, contable decimal(18,6))
  create table #t_ordenpago       (opg_id int, contable decimal(18,6))
  
  -- Creamos un cursor sobre Facturas de Compras
  
  declare c_facturas insensitive cursor for
  
  select fc_id
  from FacturaCompra fc left join Documento doc on fc.doc_id = doc.doc_id
  where

              fc_fecha >= @@Fini
          and  fc_fecha <= @@Ffin     
    
          and fc.est_id <> 7

          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (fc.prov_id   = @prov_id   or @prov_id  =0)
    and   (fc.suc_id    = @suc_id    or @suc_id   =0)
    and   (doc.cico_id  = @cico_id  or @cico_id =0)
    and   (doc.emp_id   = @emp_id    or @emp_id   =0) 
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 29 
                      and  rptarb_hojaid = fc.prov_id
                     ) 
               )
            or 
               (@ram_id_Proveedor = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1007 
                      and  rptarb_hojaid = fc.suc_id
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
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
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

    -- Analizamos el asiento de cada factura
    open c_facturas

    declare @fc_id int

    fetch next from c_facturas into @fc_id  
    while @@fetch_status=0
    begin

      select fc_id, asi.cue_id, asi_debe, asi_haber
      from AsientoItem asi
      where as_id = @as_id

        and (asi.cue_id = @cue_id or @cue_id=0)
        and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = asi.cue_id)) or (@ram_id_Cuenta = 0))
        

      -- Si cumple la condicion lo enviamos a la tabla temporal
      fetch next from c_facturas into @fc_id  
    end
  
    close c_facturas
    deallocate c_facturas

  -- Creamos un cursor sobre Ordenes de Pago
  
    -- Analizamos el asiento de cada orden de pago
  
      -- Si cumple la condicion lo enviamos a la tabla temporal
  
  
  -- Hacemos un select de todos los movimientos en la tabla temporal