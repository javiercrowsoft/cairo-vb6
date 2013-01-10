/*---------------------------------------------------------------------
Nombre: Ventas Agrupadas por Cliente, Carpeta, Rubro, Articulo, Empresa en Moneda Default, Costo y Origen
---------------------------------------------------------------------*/
/*  

Tabla de valores para @@metodoVal
Precio Promedio Ponderado    |1|
Lista de Precios            |2|
Ultima Compra                |3|
Por Despacho de Importación  |4|

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0800_003]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0800_003]

go
create procedure DC_CSC_VEN_0800_003 (

  @clienteID int,

  @@cli_id           varchar(255),
  @@pr_id           varchar(255),
  @@cico_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@suc_id          varchar(255), 
  @@emp_id           varchar(255)

)as 

begin

  set nocount on
  
  /*- ///////////////////////////////////////////////////////////////////////
  
  INICIO PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  declare @cli_id       int
  declare @ven_id       int
  declare @pr_id_param  int
  declare @cico_id      int
  declare @doc_id       int
  declare @mon_id       int
  declare @suc_id       int
  declare @emp_id       int
  
  declare @ram_id_cliente          int
  declare @ram_id_vendedor         int
  declare @ram_id_producto         int
  declare @ram_id_circuitoContable int
  declare @ram_id_documento        int
  declare @ram_id_moneda           int
  declare @ram_id_Sucursal         int
  declare @ram_id_empresa          int
  
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
  exec sp_ArbConvertId @@pr_id,          @pr_id_param out,  @ram_id_producto out
  exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
  exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
  exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
  exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_Sucursal out
  exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out
  
  if @ram_id_cliente <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
    end else 
      set @ram_id_cliente = 0
  end
  
  if @ram_id_producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
    end else 
      set @ram_id_producto = 0
  end
  
  if @ram_id_circuitoContable <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
    end else 
      set @ram_id_circuitoContable = 0
  end
  
  if @ram_id_documento <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
    end else 
      set @ram_id_documento = 0
  end
  
  if @ram_id_moneda <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
    end else 
      set @ram_id_moneda = 0
  end
  
  if @ram_id_Sucursal <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
    end else 
      set @ram_id_Sucursal = 0
  end
  
  if @ram_id_empresa <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
    end else 
      set @ram_id_empresa = 0
  end
  
end
go

