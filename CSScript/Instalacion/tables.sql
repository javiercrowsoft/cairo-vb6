if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Hoja_Arbol]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Hoja] DROP CONSTRAINT FK_Hoja_Arbol
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Rama_Arbol]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Rama] DROP CONSTRAINT FK_Rama_Arbol
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cliente_ClienteLugar_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClienteLugar] DROP CONSTRAINT Cliente_ClienteLugar_FK1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cliente_CuentaUso_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CuentaUso] DROP CONSTRAINT Cliente_CuentaUso_FK1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cliente_Direccion_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Direccion] DROP CONSTRAINT Cliente_Direccion_FK1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cuenta_Cuenta_Banco]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cuenta] DROP CONSTRAINT FK_Cuenta_Cuenta_Banco
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CuentaCategoria_Cuenta_LibroIva]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cuenta] DROP CONSTRAINT CuentaCategoria_Cuenta_LibroIva
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cuenta_CuentaCategoria]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cuenta] DROP CONSTRAINT FK_Cuenta_CuentaCategoria
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DepositoLogico_DepositoFisico]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DepositoLogico] DROP CONSTRAINT FK_DepositoLogico_DepositoFisico
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_IngresosBrutosCategoria]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_IngresosBrutosCategoria
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Permiso_Prestacion]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Permiso] DROP CONSTRAINT FK_Permiso_Prestacion
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proveedor_CuentaUso_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CuentaUso] DROP CONSTRAINT Proveedor_CuentaUso_FK1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proveedor_Direccion_FK1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Direccion] DROP CONSTRAINT Proveedor_Direccion_FK1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cliente_Provincia]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT FK_Cliente_Provincia
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Direccion_Provincia]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Direccion] DROP CONSTRAINT FK_Direccion_Provincia
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proveedor_Provincia]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proveedor] DROP CONSTRAINT FK_Proveedor_Provincia
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Hoja_Rama]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Hoja] DROP CONSTRAINT FK_Hoja_Rama
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Rama_Rama]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Rama] DROP CONSTRAINT FK_Rama_Rama
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cobrador_ReglaLiquidacion]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cobrador] DROP CONSTRAINT FK_Cobrador_ReglaLiquidacion
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_UsuarioRol_Rol]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[UsuarioRol] DROP CONSTRAINT FK_UsuarioRol_Rol
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_Rubro]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_Rubro
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Arbol_Tabla]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Arbol] DROP CONSTRAINT FK_Arbol_Tabla
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Historia_Tabla]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Historia] DROP CONSTRAINT FK_Historia_Tabla
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_TasaImpositiva]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_TasaImpositiva
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_TasaImpositiva1]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_TasaImpositiva1
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_TasaImpositiva2]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_TasaImpositiva2
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_TasaImpositiva3]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_TasaImpositiva3
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_TIRICompra]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_TIRICompra
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_TIRNIVenta]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_TIRNIVenta
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_UnCompra]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_UnCompra
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_UnStock]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_UnStock
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_UnVenta]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_UnVenta
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Arbol_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Arbol] DROP CONSTRAINT FK_Arbol_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Banco_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Banco] DROP CONSTRAINT FK_Banco_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cliente_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT FK_Cliente_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_SucursalCliente_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ClienteLugar] DROP CONSTRAINT FK_SucursalCliente_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cuenta_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cuenta] DROP CONSTRAINT FK_Cuenta_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_CuentaCategoria_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[CuentaCategoria] DROP CONSTRAINT FK_CuentaCategoria_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DepositoFisico_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DepositoFisico] DROP CONSTRAINT FK_DepositoFisico_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_DepositoLogico_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[DepositoLogico] DROP CONSTRAINT FK_DepositoLogico_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Direccion_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Direccion] DROP CONSTRAINT FK_Direccion_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Historia_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Historia] DROP CONSTRAINT FK_Historia_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Hoja_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Hoja] DROP CONSTRAINT FK_Hoja_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_IngresosBrutosCategoria_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[IngresosBrutosCategoria] DROP CONSTRAINT FK_IngresosBrutosCategoria_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Leyenda_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Leyenda] DROP CONSTRAINT FK_Leyenda_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Moneda_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Moneda] DROP CONSTRAINT FK_Moneda_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Permiso_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Permiso] DROP CONSTRAINT FK_Permiso_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Producto_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Producto] DROP CONSTRAINT FK_Producto_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proveedor_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proveedor] DROP CONSTRAINT FK_Proveedor_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Provincia_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Provincia] DROP CONSTRAINT FK_Provincia_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Rama_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Rama] DROP CONSTRAINT FK_Rama_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Rol_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Rol] DROP CONSTRAINT FK_Rol_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Rubro_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Rubro] DROP CONSTRAINT FK_Rubro_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_TarjetaCredito_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[TarjetaCredito] DROP CONSTRAINT FK_TarjetaCredito_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_TasaImpositiva_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[TasaImpositiva] DROP CONSTRAINT FK_TasaImpositiva_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Unidad_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Unidad] DROP CONSTRAINT FK_Unidad_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Usuario_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT FK_Usuario_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_UsuarioRol_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[UsuarioRol] DROP CONSTRAINT FK_UsuarioRol_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Vendedores_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Vendedor] DROP CONSTRAINT FK_Vendedores_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Zona_Usuario]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Zona] DROP CONSTRAINT FK_Zona_Usuario
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Cliente_Zona]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Cliente] DROP CONSTRAINT FK_Cliente_Zona
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Proveedor_Zona]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Proveedor] DROP CONSTRAINT FK_Proveedor_Zona
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_permiso_update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_permiso_update]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_us_insert]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_us_insert]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_us_update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_us_update]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Arbol]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Arbol]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Banco]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Banco]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CentroCosto]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CentroCosto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Chequera]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Chequera]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Clearing]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Clearing]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cliente]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Cliente]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClienteLugar]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClienteLugar]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cobrador]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Cobrador]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Configuracion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Configuracion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Cuenta]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Cuenta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CuentaCategoria]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CuentaCategoria]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CuentaUso]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CuentaUso]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DepositoFisico]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DepositoFisico]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DepositoLogico]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DepositoLogico]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Direccion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Direccion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DocDigital]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocDigital]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Documento]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Documento]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DocumentoTipo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocumentoTipo]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Escala]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Escala]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Historia]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Historia]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Hoja]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Hoja]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Id]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Id]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IngresosBrutosCategoria]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IngresosBrutosCategoria]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Leyenda]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Leyenda]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Moneda]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Moneda]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Permiso]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Permiso]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Prestacion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Prestacion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Producto]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Producto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ProductoLugar]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ProductoLugar]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proveedor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Proveedor]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Provincia]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Provincia]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Rama]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Rama]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RamaConfig]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RamaConfig]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReglaLiquidacion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ReglaLiquidacion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Rol]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Rol]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Rubro]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Rubro]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Tabla]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Tabla]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TarjetaCredito]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TarjetaCredito]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TasaImpositiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TasaImpositiva]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TmpStringToTable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TmpStringToTable]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Unidad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Unidad]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Usuario]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Usuario]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UsuarioRol]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UsuarioRol]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Vendedor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Vendedor]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Zona]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Zona]
GO

CREATE TABLE [dbo].[Arbol] (
	[arb_id] [int] NOT NULL ,
	[arb_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[tbl_Id] [int] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Banco] (
	[bco_id] [int] NOT NULL ,
	[bco_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[bco_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CentroCosto] (
	[ccos_id] [int] NOT NULL ,
	[ccos_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ccos_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ccos_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ccos_compra] [smallint] NOT NULL ,
	[ccos_venta] [smallint] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Chequera] (
	[chq_id] [int] NOT NULL ,
	[cue_id] [int] NOT NULL ,
	[chq_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[chq_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[chq_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[chq_numerodesde] [int] NOT NULL ,
	[chq_numerohasta] [int] NOT NULL ,
	[chq_ultimonumero] [int] NOT NULL ,
	[chq_default] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Clearing] (
	[cle_id] [int] NOT NULL ,
	[cle_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cle_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cle_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cle_dias] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Cliente] (
	[cli_id] [int] NOT NULL ,
	[cli_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_alias] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_contacto] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_razonsocial] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_cuit] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_ingresosbrutos] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_catfiscal] [smallint] NOT NULL ,
	[cli_chequeorden] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_codpostal] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_localidad] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_calle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_callenumero] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_piso] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_depto] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_tel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_web] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pro_id] [int] NULL ,
	[zon_id] [int] NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ClienteLugar] (
	[clil_id] [int] NOT NULL ,
	[clil_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[clil_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cli_id] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Cobrador] (
	[cob_id] [int] NOT NULL ,
	[rel_id] [int] NOT NULL ,
	[cob_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cob_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cob_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cob_comision] [real] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Configuracion] (
	[cfg_grupo] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cfg_aspecto] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cfg_valor] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Cuenta] (
	[cue_id] [int] NOT NULL ,
	[cuec_id] [int] NOT NULL ,
	[cuec_id_libroiva] [int] NULL ,
	[cue_id_banco] [int] NULL ,
	[cue_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cue_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cue_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cue_identificacionexterna] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cue_llevacentrocosto] [tinyint] NOT NULL ,
	[activo] [tinyint] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CuentaCategoria] (
	[cuec_id] [int] NOT NULL ,
	[cuec_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cuec_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[cuec_tipo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CuentaUso] (
	[cueu_id] [int] NOT NULL ,
	[cue_id] [int] NOT NULL ,
	[cueu_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cueu_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[cueu_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL ,
	[prov_id] [int] NULL ,
	[cli_id] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DepositoFisico] (
	[depf_id] [int] NOT NULL ,
	[depf_nombre] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[depf_alias] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[depf_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DepositoLogico] (
	[depl_id] [int] NOT NULL ,
	[depf_id] [int] NOT NULL ,
	[depl_nombre] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[depl_alias] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[depl_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Direccion] (
	[dir_id] [int] NOT NULL ,
	[dir_calle] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[dir_numero] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[dir_cpa] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[dir_tel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[te_id] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [smallint] NOT NULL ,
	[pro_id] [int] NOT NULL ,
	[cli_id] [int] NULL ,
	[prov_id] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DocDigital] (
	[DD_Tabla] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[DD_Tabla_Id] [int] NOT NULL ,
	[DD_Id] [int] NOT NULL ,
	[DD_Nombre] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[DD_Alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[DD_Formato] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[DD_Image] [image] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Documento] (
	[doc_id] [int] NOT NULL ,
	[doc_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[doc_alias] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DocumentoTipo] (
	[doct_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[doct_alias] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[doct_id] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Escala] (
	[esc_id] [int] NOT NULL ,
	[esc_nombre] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[esc_alias] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Historia] (
	[tbl_id] [int] NOT NULL ,
	[id] [int] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[modificado] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Hoja] (
	[hoja_id] [int] NOT NULL ,
	[id] [int] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[ram_id] [int] NOT NULL ,
	[arb_id] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Id] (
	[Id_Tabla] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[Id_NextId] [int] NOT NULL ,
	[Id_CampoId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[IngresosBrutosCategoria] (
	[ibc_id] [int] NOT NULL ,
	[ibc_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ibc_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ibc_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Leyenda] (
	[ley_id] [int] NOT NULL ,
	[ley_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ley_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ley_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ley_texto] [text] COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[activo] [tinyint] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Moneda] (
	[mon_id] [int] NULL ,
	[mon_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[mon_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[mon_signo] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[activo] [tinyint] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Permiso] (
	[per_id] [int] NOT NULL ,
	[pre_id] [int] NOT NULL ,
	[us_id] [int] NULL ,
	[rol_id] [int] NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Prestacion] (
	[pre_id] [int] NOT NULL ,
	[pre_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[pre_grupo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[activo] [smallint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Producto] (
	[pr_id] [int] NOT NULL ,
	[pr_nombrecompra] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pr_nombreventa] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pr_alias] [varchar] (90) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[activo] [smallint] NOT NULL ,
	[pr_descripventa] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pr_descripcompra] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[un_id_compra] [int] NULL ,
	[un_id_venta] [int] NULL ,
	[un_id_stock] [int] NULL ,
	[pr_ventacompra] [real] NOT NULL ,
	[pr_ventastock] [real] NOT NULL ,
	[pr_stockcompra] [real] NOT NULL ,
	[pr_llevastock] [smallint] NOT NULL ,
	[pr_secompra] [smallint] NOT NULL ,
	[pr_sevende] [smallint] NOT NULL ,
	[pr_eskit] [tinyint] NOT NULL ,
	[pr_eslista] [tinyint] NOT NULL ,
	[ti_id_ivaricompra] [int] NULL ,
	[ti_id_ivarnicompra] [int] NULL ,
	[ti_id_ivariventa] [int] NULL ,
	[ti_id_ivarniventa] [int] NULL ,
	[ti_id_internosv] [int] NULL ,
	[ti_id_internosc] [int] NULL ,
	[pr_porcinternoc] [real] NOT NULL ,
	[pr_porcinternov] [real] NULL ,
	[ibc_id] [int] NULL ,
	[cue_id_compra] [int] NULL ,
	[cue_id_venta] [int] NULL ,
	[pr_x] [smallint] NOT NULL ,
	[pr_y] [smallint] NOT NULL ,
	[pr_z] [smallint] NOT NULL ,
	[pr_tienehijo] [tinyint] NOT NULL ,
	[pr_id_padre] [int] NULL ,
	[pr_editarpreciohijo] [tinyint] NOT NULL ,
	[pr_permiteedicion] [tinyint] NOT NULL ,
	[pr_borrado] [tinyint] NOT NULL ,
	[pr_stockminimo] [real] NOT NULL ,
	[pr_stockmaximo] [real] NOT NULL ,
	[pr_codigoexterno] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pr_reposicion] [real] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[rub_id] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ProductoLugar] (
	[prol_id] [int] NULL ,
	[prol_stockminio] [real] NULL ,
	[prol_stockmaximo] [real] NULL ,
	[prol_puntoreposicion] [real] NULL ,
	[prol_posicionx] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL ,
	[prol_posiciony] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL ,
	[prol_posicionz] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Proveedor] (
	[prov_id] [int] NOT NULL ,
	[prov_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_alias] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_contacto] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_razonsocial] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_cuit] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_ingresosbrutos] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_catfiscal] [smallint] NOT NULL ,
	[prov_chequeorden] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_codpostal] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_localidad] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_calle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_callenumero] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_piso] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_depto] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_tel] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[prov_web] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pro_id] [int] NULL ,
	[zon_id] [int] NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Provincia] (
	[pro_id] [int] NOT NULL ,
	[pro_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[pro_alias] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Rama] (
	[ram_id] [int] NOT NULL ,
	[ram_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[arb_id] [int] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[ram_id_padre] [int] NOT NULL ,
	[ram_orden] [smallint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[RamaConfig] (
	[ramc_aspecto] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ramc_valor] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ram_id] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ReglaLiquidacion] (
	[rel_id] [int] NOT NULL ,
	[rel_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[rel_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[rel_descripcion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Rol] (
	[rol_id] [int] NOT NULL ,
	[rol_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Rubro] (
	[rub_id] [int] NOT NULL ,
	[rub_nombre] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[rub_alias] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Tabla] (
	[tbl_id] [int] NOT NULL ,
	[tbl_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_nombrefisico] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_campoId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_campoAlias] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_sqlHelp] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_tieneArbol] [smallint] NOT NULL ,
	[tbl_campoNombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_camposInView] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tbl_where] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TarjetaCredito] (
	[tjc_id] [int] NOT NULL ,
	[tjc_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tjc_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TasaImpositiva] (
	[ti_id] [int] NOT NULL ,
	[ti_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ti_alias] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ti_porcentaje] [money] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TmpStringToTable] (
	[tmpstr2tbl_campo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[tmpstr2tbl_id] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Unidad] (
	[un_id] [int] NOT NULL ,
	[un_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[un_alias] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Usuario] (
	[us_id] [int] NOT NULL ,
	[us_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[us_clave] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[activo] [smallint] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UsuarioRol] (
	[rol_id] [int] NOT NULL ,
	[us_id] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Vendedor] (
	[ven_id] [int] NOT NULL ,
	[ven_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[ven_alias] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[activo] [tinyint] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Zona] (
	[zon_id] [int] NOT NULL ,
	[zon_nombre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[zon_alias] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [tinyint] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CentroCosto] WITH NOCHECK ADD 
	CONSTRAINT [PK_CentroCosto] PRIMARY KEY  CLUSTERED 
	(
		[ccos_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Chequera] WITH NOCHECK ADD 
	CONSTRAINT [PK_Chequera] PRIMARY KEY  CLUSTERED 
	(
		[chq_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Clearing] WITH NOCHECK ADD 
	CONSTRAINT [PK_Clearing] PRIMARY KEY  CLUSTERED 
	(
		[cle_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Cliente] WITH NOCHECK ADD 
	CONSTRAINT [PK_Cliente] PRIMARY KEY  CLUSTERED 
	(
		[cli_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Cobrador] WITH NOCHECK ADD 
	CONSTRAINT [PK_Cobrador] PRIMARY KEY  CLUSTERED 
	(
		[cob_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Cuenta] WITH NOCHECK ADD 
	CONSTRAINT [PK_Cuenta] PRIMARY KEY  CLUSTERED 
	(
		[cue_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CuentaCategoria] WITH NOCHECK ADD 
	CONSTRAINT [PK_CuentaCategoria] PRIMARY KEY  CLUSTERED 
	(
		[cuec_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Escala] WITH NOCHECK ADD 
	CONSTRAINT [PK_Escala] PRIMARY KEY  CLUSTERED 
	(
		[esc_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IngresosBrutosCategoria] WITH NOCHECK ADD 
	CONSTRAINT [PK_IngresosBrutosCategoria] PRIMARY KEY  CLUSTERED 
	(
		[ibc_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Prestacion] WITH NOCHECK ADD 
	CONSTRAINT [PK_Prestacion] PRIMARY KEY  CLUSTERED 
	(
		[pre_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proveedor] WITH NOCHECK ADD 
	CONSTRAINT [PK_Proveedor] PRIMARY KEY  CLUSTERED 
	(
		[prov_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ReglaLiquidacion] WITH NOCHECK ADD 
	CONSTRAINT [PK_ReglaLiquidacion] PRIMARY KEY  CLUSTERED 
	(
		[rel_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Rubro] WITH NOCHECK ADD 
	CONSTRAINT [PK_Rubro] PRIMARY KEY  CLUSTERED 
	(
		[rub_id]
	)  ON [PRIMARY] 
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_depf_alias] ON [dbo].[DepositoFisico]([depf_alias]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_depl_alias] ON [dbo].[DepositoLogico]([depl_alias]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_DocTAliasClus] ON [dbo].[DocumentoTipo]([doct_alias]) ON [PRIMARY]
GO

 CREATE  CLUSTERED  INDEX [IX_Usuario] ON [dbo].[Permiso]([us_id]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_PrAliasClus] ON [dbo].[Producto]([pr_alias]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_ProAliasClus] ON [dbo].[Provincia]([pro_alias]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IXU_Nombre] ON [dbo].[Rol]([rol_nombre]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_ti_alias] ON [dbo].[TasaImpositiva]([ti_alias]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_UnAliasClus] ON [dbo].[Unidad]([un_alias]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IXU_Nombre] ON [dbo].[Usuario]([us_nombre]) ON [PRIMARY]
GO

 CREATE  CLUSTERED  INDEX [IX_Usuario] ON [dbo].[UsuarioRol]([us_id]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [IX_zon_alias] ON [dbo].[Zona]([zon_alias]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Arbol] WITH NOCHECK ADD 
	CONSTRAINT [DF_Arbol_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Arbol_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [PK_Arbol] PRIMARY KEY  NONCLUSTERED 
	(
		[arb_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Banco] WITH NOCHECK ADD 
	CONSTRAINT [DF_Banco_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Banco_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Banco_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[CentroCosto] WITH NOCHECK ADD 
	CONSTRAINT [DF_CentroCosto_ccos_descripcion] DEFAULT ('') FOR [ccos_descripcion],
	CONSTRAINT [DF_CentroCosto_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_CentroCosto_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_CentroCosto_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Chequera] WITH NOCHECK ADD 
	CONSTRAINT [DF_Chequera_chq_descripcion] DEFAULT ('') FOR [chq_descripcion],
	CONSTRAINT [DF_Chequera_chq_numerodesde] DEFAULT (0) FOR [chq_numerodesde],
	CONSTRAINT [DF_Chequera_chq_numerohasta] DEFAULT (0) FOR [chq_numerohasta],
	CONSTRAINT [DF_Chequera_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Chequera_modificado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Clearing] WITH NOCHECK ADD 
	CONSTRAINT [DF_Clearing_cle_descripcion] DEFAULT ('') FOR [cle_descripcion],
	CONSTRAINT [DF_Clearing_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Clearing_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Clearing_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Cliente] WITH NOCHECK ADD 
	CONSTRAINT [DF_Cliente_prov_razonsocial] DEFAULT ('') FOR [cli_razonsocial],
	CONSTRAINT [DF_Cliente_prov_cuit] DEFAULT ('') FOR [cli_cuit],
	CONSTRAINT [DF_Cliente_prov_ingresosbrutos] DEFAULT ('') FOR [cli_ingresosbrutos],
	CONSTRAINT [DF_Cliente_prov_catfiscal] DEFAULT (1) FOR [cli_catfiscal],
	CONSTRAINT [DF_Cliente_prov_chequeorden] DEFAULT ('') FOR [cli_chequeorden],
	CONSTRAINT [DF_Cliente_prov_codpostal] DEFAULT ('') FOR [cli_codpostal],
	CONSTRAINT [DF_Cliente_prov_calle] DEFAULT ('') FOR [cli_calle],
	CONSTRAINT [DF_Cliente_prov_callenumero] DEFAULT ('s/n') FOR [cli_callenumero],
	CONSTRAINT [DF_Cliente_prov_piso] DEFAULT ('PB') FOR [cli_piso],
	CONSTRAINT [DF_Cliente_prov_depto] DEFAULT ('') FOR [cli_depto],
	CONSTRAINT [DF_Cliente_prov_tel] DEFAULT ('') FOR [cli_tel],
	CONSTRAINT [DF_Cliente_prov_fax] DEFAULT ('') FOR [cli_fax],
	CONSTRAINT [DF_Cliente_prov_email] DEFAULT ('') FOR [cli_email],
	CONSTRAINT [DF_Cliente_prov_web] DEFAULT ('') FOR [cli_web],
	CONSTRAINT [DF_Cliente_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Cliente_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Cliente_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[ClienteLugar] WITH NOCHECK ADD 
	CONSTRAINT [DF__ClienteLu__clil___38C4533E] DEFAULT ('') FOR [clil_nombre],
	CONSTRAINT [DF__ClienteLu__clil___39B87777] DEFAULT ('''') FOR [clil_alias],
	CONSTRAINT [DF__ClienteLu__activ__3AAC9BB0] DEFAULT (0) FOR [activo],
	CONSTRAINT [DF__ClienteLu__cread__3BA0BFE9] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF__ClienteLu__modif__3C94E422] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Cobrador] WITH NOCHECK ADD 
	CONSTRAINT [DF_Cobrador_cob_descripcion] DEFAULT ('') FOR [cob_descripcion],
	CONSTRAINT [DF_Cobrador_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Cobrador_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Cobrador_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Configuracion] WITH NOCHECK ADD 
	CONSTRAINT [DF_Configuracion_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Configuracion_modificado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Cuenta] WITH NOCHECK ADD 
	CONSTRAINT [DF_Cuenta_cue_identificacionexterna] DEFAULT ('') FOR [cue_identificacionexterna],
	CONSTRAINT [DF_Cuenta_cue_llevacentrocosto] DEFAULT (0) FOR [cue_llevacentrocosto],
	CONSTRAINT [DF_Cuenta_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [DF_Cuenta_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Cuenta_modificado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[CuentaCategoria] WITH NOCHECK ADD 
	CONSTRAINT [DF_CuentaCategoria2_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_CuentaCategoria2_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF__cuentacat__cuec___7C8F6DA6] DEFAULT (0) FOR [cuec_tipo]
GO

ALTER TABLE [dbo].[CuentaUso] WITH NOCHECK ADD 
	CONSTRAINT [DF_CuentaUso_cueu_descripcion] DEFAULT ('') FOR [cueu_descripcion],
	CONSTRAINT [DF_CuentaUso_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_CuentaUso_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_CuentaUso_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[DepositoFisico] WITH NOCHECK ADD 
	CONSTRAINT [DF_DepositoFisico_depf_descripcion] DEFAULT ('') FOR [depf_descripcion],
	CONSTRAINT [DF_DepositoFisico_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_DepositoFisico_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_DepositoFisico_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_DepositoFisico] PRIMARY KEY  NONCLUSTERED 
	(
		[depf_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DepositoLogico] WITH NOCHECK ADD 
	CONSTRAINT [DF_DepositoLogico_depl_descripcion] DEFAULT ('') FOR [depl_descripcion],
	CONSTRAINT [DF_DepositoLogico_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_DepositoLogico_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_DepositoLogico_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_DepositoLogico] PRIMARY KEY  NONCLUSTERED 
	(
		[depl_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Direccion] WITH NOCHECK ADD 
	CONSTRAINT [DF_Direccion_dir_cpa] DEFAULT ('') FOR [dir_cpa],
	CONSTRAINT [DF_Direccion_dir_tel] DEFAULT ('') FOR [dir_tel],
	CONSTRAINT [DF_Direccion_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Direccion_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Direccion_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_Direccion] PRIMARY KEY  NONCLUSTERED 
	(
		[dir_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DocDigital] WITH NOCHECK ADD 
	CONSTRAINT [DF_DOC DIGITAL_DD_Image] DEFAULT (0x00) FOR [DD_Image]
GO

ALTER TABLE [dbo].[DocumentoTipo] WITH NOCHECK ADD 
	CONSTRAINT [PK_DocumentoTipo] PRIMARY KEY  NONCLUSTERED 
	(
		[doct_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Escala] WITH NOCHECK ADD 
	CONSTRAINT [DF_Escala_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Escala_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Escala_modifico] DEFAULT (0) FOR [modifico],
	CONSTRAINT [DF_Escala_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Historia] WITH NOCHECK ADD 
	CONSTRAINT [DF_Historia_modificado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Hoja] WITH NOCHECK ADD 
	CONSTRAINT [DF_Hoja_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Hoja_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [PK_Hoja] PRIMARY KEY  NONCLUSTERED 
	(
		[hoja_id],
		[ram_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IngresosBrutosCategoria] WITH NOCHECK ADD 
	CONSTRAINT [DF_IngresosBrutosCategoria_ibc_descripcion] DEFAULT ('') FOR [ibc_descripcion],
	CONSTRAINT [DF_IngresosBrutosCategoria_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_IngresosBrutosCategoria_modificado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Leyenda] WITH NOCHECK ADD 
	CONSTRAINT [DF_Leyenda_ley_descripcion] DEFAULT ('') FOR [ley_descripcion],
	CONSTRAINT [DF_Leyenda_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [DF_Leyenda_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Leyenda_mofidicado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Moneda] WITH NOCHECK ADD 
	CONSTRAINT [DF_Moneda_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [DF_Moneda_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Moneda_modificado] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Permiso] WITH NOCHECK ADD 
	CONSTRAINT [DF_Permiso_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Permiso_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [PK_Permiso] PRIMARY KEY  NONCLUSTERED 
	(
		[per_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Prestacion] WITH NOCHECK ADD 
	CONSTRAINT [DF_Prestacion_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Prestacion_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Prestacion_activo] DEFAULT (1) FOR [activo]
GO

ALTER TABLE [dbo].[Producto] WITH NOCHECK ADD 
	CONSTRAINT [DF_Producto_activo] DEFAULT (1) FOR [activo],
	CONSTRAINT [DF_Producto_pro_descripventa] DEFAULT ('') FOR [pr_descripventa],
	CONSTRAINT [DF_Producto_pro_descripcompra] DEFAULT ('') FOR [pr_descripcompra],
	CONSTRAINT [DF_Producto_pr_relacioncompraventa] DEFAULT (1) FOR [pr_ventacompra],
	CONSTRAINT [DF_Producto_pr_ventastock] DEFAULT (1) FOR [pr_ventastock],
	CONSTRAINT [DF_Producto_pr_comprastock] DEFAULT (1) FOR [pr_stockcompra],
	CONSTRAINT [DF_Producto_pr_llevastock] DEFAULT (0) FOR [pr_llevastock],
	CONSTRAINT [DF_Producto_pr_secompra] DEFAULT (0) FOR [pr_secompra],
	CONSTRAINT [DF_Producto_pr_sevende] DEFAULT (0) FOR [pr_sevende],
	CONSTRAINT [DF_Producto_pr_eskit] DEFAULT (0) FOR [pr_eskit],
	CONSTRAINT [DF_Producto_pr_eslista] DEFAULT (0) FOR [pr_eslista],
	CONSTRAINT [DF_Producto_pr_porcinterno] DEFAULT (0) FOR [pr_porcinternoc],
	CONSTRAINT [DF_Producto_pr_porcinternoc1] DEFAULT (0) FOR [pr_porcinternov],
	CONSTRAINT [DF_Producto_pr_x] DEFAULT (0) FOR [pr_x],
	CONSTRAINT [DF_Producto_pr_y] DEFAULT (0) FOR [pr_y],
	CONSTRAINT [DF_Producto_pr_z] DEFAULT (0) FOR [pr_z],
	CONSTRAINT [DF_Producto_pr_tienehijo] DEFAULT (0) FOR [pr_tienehijo],
	CONSTRAINT [DF_Producto_pr_editarpreciohijo] DEFAULT (0) FOR [pr_editarpreciohijo],
	CONSTRAINT [DF_Producto_pr_permiteedicion] DEFAULT (0) FOR [pr_permiteedicion],
	CONSTRAINT [DF_Producto_pr_borrado] DEFAULT (0) FOR [pr_borrado],
	CONSTRAINT [DF_Producto_pr_stockminimo] DEFAULT (0) FOR [pr_stockminimo],
	CONSTRAINT [DF_Producto_pr_stockmaximo] DEFAULT (0) FOR [pr_stockmaximo],
	CONSTRAINT [DF_Producto_pr_codigoexterno] DEFAULT ('') FOR [pr_codigoexterno],
	CONSTRAINT [DF_Producto_pr_reposicion] DEFAULT (0) FOR [pr_reposicion],
	CONSTRAINT [DF_Producto_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Producto_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [PK_Producto] PRIMARY KEY  NONCLUSTERED 
	(
		[pr_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Proveedor] WITH NOCHECK ADD 
	CONSTRAINT [DF_Proveedor_prov_contacto] DEFAULT ('') FOR [prov_contacto],
	CONSTRAINT [DF_Proveedor_prov_razonsocial] DEFAULT ('') FOR [prov_razonsocial],
	CONSTRAINT [DF_Proveedor_prov_cuit] DEFAULT ('') FOR [prov_cuit],
	CONSTRAINT [DF_Proveedor_prov_ingresosbrutos] DEFAULT ('') FOR [prov_ingresosbrutos],
	CONSTRAINT [DF_Proveedor_prov_catfiscal] DEFAULT (1) FOR [prov_catfiscal],
	CONSTRAINT [DF_Proveedor_prov_chequeorden] DEFAULT ('') FOR [prov_chequeorden],
	CONSTRAINT [DF_Proveedor_prov_codpostal] DEFAULT ('') FOR [prov_codpostal],
	CONSTRAINT [DF_Proveedor_prov_calle] DEFAULT ('') FOR [prov_calle],
	CONSTRAINT [DF_Proveedor_prov_callenumero] DEFAULT ('s/n') FOR [prov_callenumero],
	CONSTRAINT [DF_Proveedor_prov_piso] DEFAULT ('PB') FOR [prov_piso],
	CONSTRAINT [DF_Proveedor_prov_depto] DEFAULT ('') FOR [prov_depto],
	CONSTRAINT [DF_Proveedor_prov_tel] DEFAULT ('') FOR [prov_tel],
	CONSTRAINT [DF_Proveedor_prov_fax] DEFAULT ('') FOR [prov_fax],
	CONSTRAINT [DF_Proveedor_prov_email] DEFAULT ('') FOR [prov_email],
	CONSTRAINT [DF_Proveedor_prov_web] DEFAULT ('') FOR [prov_web],
	CONSTRAINT [DF_Proveedor_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Proveedor_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Proveedor_modifico] DEFAULT (0) FOR [modifico],
	CONSTRAINT [DF_Proveedor_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Provincia] WITH NOCHECK ADD 
	CONSTRAINT [DF_Provincia_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Provincia_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Provincia_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_Provincia] PRIMARY KEY  NONCLUSTERED 
	(
		[pro_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Rama] WITH NOCHECK ADD 
	CONSTRAINT [DF_Rama_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Rama_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Rama_ram_id_Padre] DEFAULT (0) FOR [ram_id_padre],
	CONSTRAINT [DF_Rama_ram_orden] DEFAULT (0) FOR [ram_orden],
	CONSTRAINT [PK_Rama] PRIMARY KEY  NONCLUSTERED 
	(
		[ram_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RamaConfig] WITH NOCHECK ADD 
	CONSTRAINT [DF_RamaConfig_ramc_valor] DEFAULT ('') FOR [ramc_valor],
	CONSTRAINT [PK_RamaConfig] PRIMARY KEY  NONCLUSTERED 
	(
		[ramc_aspecto]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ReglaLiquidacion] WITH NOCHECK ADD 
	CONSTRAINT [DF_ReglaLiquidacion_rel_descripcion] DEFAULT ('') FOR [rel_descripcion],
	CONSTRAINT [DF_ReglaLiquidacion_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_ReglaLiquidacion_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_ReglaLiquidacion_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Rol] WITH NOCHECK ADD 
	CONSTRAINT [DF_Rol_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Rol_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Rol_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_Rol] PRIMARY KEY  NONCLUSTERED 
	(
		[rol_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Rubro] WITH NOCHECK ADD 
	CONSTRAINT [DF_Rubro_rub_nombre] DEFAULT ('') FOR [rub_nombre],
	CONSTRAINT [DF_Rubro_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Rubro_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Rubro_modifico] DEFAULT (0) FOR [modifico],
	CONSTRAINT [DF_Rubro_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[Tabla] WITH NOCHECK ADD 
	CONSTRAINT [DF_Tabla_tbl_nombre] DEFAULT ('') FOR [tbl_nombre],
	CONSTRAINT [DF_Tabla_tbl_nombrefisico] DEFAULT ('') FOR [tbl_nombrefisico],
	CONSTRAINT [DF_Tabla_tbl_campoId] DEFAULT ('') FOR [tbl_campoId],
	CONSTRAINT [DF_Tabla_tbl_campoAlias] DEFAULT ('') FOR [tbl_campoAlias],
	CONSTRAINT [DF_Tabla_tbl_sqlHelp] DEFAULT ('') FOR [tbl_sqlHelp],
	CONSTRAINT [DF_Tabla_tbl_tieneArbol] DEFAULT (0) FOR [tbl_tieneArbol],
	CONSTRAINT [DF_Tabla_tbl_campoNombre] DEFAULT ('') FOR [tbl_campoNombre],
	CONSTRAINT [DF_Tabla_tbl_camposInView] DEFAULT ('') FOR [tbl_camposInView],
	CONSTRAINT [DF_Tabla_tbl_where] DEFAULT ('') FOR [tbl_where],
	CONSTRAINT [PK_Tabla] PRIMARY KEY  NONCLUSTERED 
	(
		[tbl_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TarjetaCredito] WITH NOCHECK ADD 
	CONSTRAINT [DF_TarjetaCredito_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_TarjetaCredito_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_TarjetaCredito_activo] DEFAULT (0) FOR [activo]
GO

ALTER TABLE [dbo].[TasaImpositiva] WITH NOCHECK ADD 
	CONSTRAINT [DF_TasaImpositiva_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_TasaImpositiva_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_TasaImpositiva_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_TasaImpositiva] PRIMARY KEY  NONCLUSTERED 
	(
		[ti_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Unidad] WITH NOCHECK ADD 
	CONSTRAINT [DF_Unidad_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Unidad_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Unidad_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_Unidad] PRIMARY KEY  NONCLUSTERED 
	(
		[un_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Usuario] WITH NOCHECK ADD 
	CONSTRAINT [DF_Usuario_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Usuario_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Usuario_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [DF_Usuario_us_id_usuario] DEFAULT (1) FOR [modifico],
	CONSTRAINT [PK_Usuarios] PRIMARY KEY  NONCLUSTERED 
	(
		[us_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[UsuarioRol] WITH NOCHECK ADD 
	CONSTRAINT [DF_UsuarioRol_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_UsuarioRol_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [PK_UsuarioRol] PRIMARY KEY  NONCLUSTERED 
	(
		[rol_id],
		[us_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Vendedor] WITH NOCHECK ADD 
	CONSTRAINT [DF__Vendedor__activo__65CC03DF] DEFAULT (0) FOR [activo],
	CONSTRAINT [DF__Vendedor__creado__66C02818] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF__Vendedor__modifi__67B44C51] DEFAULT (getdate()) FOR [modificado]
GO

ALTER TABLE [dbo].[Zona] WITH NOCHECK ADD 
	CONSTRAINT [DF_Zona_creado] DEFAULT (getdate()) FOR [creado],
	CONSTRAINT [DF_Zona_modificado] DEFAULT (getdate()) FOR [modificado],
	CONSTRAINT [DF_Zona_activo] DEFAULT (0) FOR [activo],
	CONSTRAINT [PK_Zona] PRIMARY KEY  NONCLUSTERED 
	(
		[zon_id]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_Rol] ON [dbo].[Permiso]([rol_id]) ON [PRIMARY]
GO

/****** The index created by the following statement is for internal use only. ******/
/****** It is not a real index but exists as statistics only. ******/
if (@@microsoftversion > 0x07000000 )
EXEC ('CREATE STATISTICS [Statistic_ram_id] ON [dbo].[RamaConfig] ([ram_id]) ')
GO

 CREATE  INDEX [IX_Rol] ON [dbo].[UsuarioRol]([rol_id]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Arbol] ADD 
	CONSTRAINT [FK_Arbol_Tabla] FOREIGN KEY 
	(
		[tbl_Id]
	) REFERENCES [dbo].[Tabla] (
		[tbl_id]
	),
	CONSTRAINT [FK_Arbol_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Banco] ADD 
	CONSTRAINT [FK_Banco_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Cliente] ADD 
	CONSTRAINT [FK_Cliente_Provincia] FOREIGN KEY 
	(
		[pro_id]
	) REFERENCES [dbo].[Provincia] (
		[pro_id]
	),
	CONSTRAINT [FK_Cliente_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	),
	CONSTRAINT [FK_Cliente_Zona] FOREIGN KEY 
	(
		[zon_id]
	) REFERENCES [dbo].[Zona] (
		[zon_id]
	)
GO

ALTER TABLE [dbo].[ClienteLugar] ADD 
	CONSTRAINT [Cliente_ClienteLugar_FK1] FOREIGN KEY 
	(
		[cli_id]
	) REFERENCES [dbo].[Cliente] (
		[cli_id]
	),
	CONSTRAINT [FK_SucursalCliente_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Cobrador] ADD 
	CONSTRAINT [FK_Cobrador_ReglaLiquidacion] FOREIGN KEY 
	(
		[rel_id]
	) REFERENCES [dbo].[ReglaLiquidacion] (
		[rel_id]
	)
GO

ALTER TABLE [dbo].[Cuenta] ADD 
	CONSTRAINT [CuentaCategoria_Cuenta_LibroIva] FOREIGN KEY 
	(
		[cuec_id_libroiva]
	) REFERENCES [dbo].[CuentaCategoria] (
		[cuec_id]
	),
	CONSTRAINT [FK_Cuenta_Cuenta_Banco] FOREIGN KEY 
	(
		[cue_id_banco]
	) REFERENCES [dbo].[Cuenta] (
		[cue_id]
	),
	CONSTRAINT [FK_Cuenta_CuentaCategoria] FOREIGN KEY 
	(
		[cuec_id]
	) REFERENCES [dbo].[CuentaCategoria] (
		[cuec_id]
	),
	CONSTRAINT [FK_Cuenta_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[CuentaCategoria] ADD 
	CONSTRAINT [FK_CuentaCategoria_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[CuentaUso] ADD 
	CONSTRAINT [Cliente_CuentaUso_FK1] FOREIGN KEY 
	(
		[cli_id]
	) REFERENCES [dbo].[Cliente] (
		[cli_id]
	),
	CONSTRAINT [Proveedor_CuentaUso_FK1] FOREIGN KEY 
	(
		[prov_id]
	) REFERENCES [dbo].[Proveedor] (
		[prov_id]
	)
GO

ALTER TABLE [dbo].[DepositoFisico] ADD 
	CONSTRAINT [FK_DepositoFisico_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[DepositoLogico] ADD 
	CONSTRAINT [FK_DepositoLogico_DepositoFisico] FOREIGN KEY 
	(
		[depf_id]
	) REFERENCES [dbo].[DepositoFisico] (
		[depf_id]
	),
	CONSTRAINT [FK_DepositoLogico_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Direccion] ADD 
	CONSTRAINT [Cliente_Direccion_FK1] FOREIGN KEY 
	(
		[cli_id]
	) REFERENCES [dbo].[Cliente] (
		[cli_id]
	),
	CONSTRAINT [FK_Direccion_Provincia] FOREIGN KEY 
	(
		[pro_id]
	) REFERENCES [dbo].[Provincia] (
		[pro_id]
	),
	CONSTRAINT [FK_Direccion_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	),
	CONSTRAINT [Proveedor_Direccion_FK1] FOREIGN KEY 
	(
		[prov_id]
	) REFERENCES [dbo].[Proveedor] (
		[prov_id]
	)
GO

ALTER TABLE [dbo].[Historia] ADD 
	CONSTRAINT [FK_Historia_Tabla] FOREIGN KEY 
	(
		[tbl_id]
	) REFERENCES [dbo].[Tabla] (
		[tbl_id]
	),
	CONSTRAINT [FK_Historia_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Hoja] ADD 
	CONSTRAINT [FK_Hoja_Arbol] FOREIGN KEY 
	(
		[arb_id]
	) REFERENCES [dbo].[Arbol] (
		[arb_id]
	),
	CONSTRAINT [FK_Hoja_Rama] FOREIGN KEY 
	(
		[ram_id]
	) REFERENCES [dbo].[Rama] (
		[ram_id]
	),
	CONSTRAINT [FK_Hoja_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[IngresosBrutosCategoria] ADD 
	CONSTRAINT [FK_IngresosBrutosCategoria_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Leyenda] ADD 
	CONSTRAINT [FK_Leyenda_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Moneda] ADD 
	CONSTRAINT [FK_Moneda_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Permiso] ADD 
	CONSTRAINT [FK_Permiso_Prestacion] FOREIGN KEY 
	(
		[pre_id]
	) REFERENCES [dbo].[Prestacion] (
		[pre_id]
	),
	CONSTRAINT [FK_Permiso_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Producto] ADD 
	CONSTRAINT [FK_Producto_IngresosBrutosCategoria] FOREIGN KEY 
	(
		[ibc_id]
	) REFERENCES [dbo].[IngresosBrutosCategoria] (
		[ibc_id]
	),
	CONSTRAINT [FK_Producto_Rubro] FOREIGN KEY 
	(
		[rub_id]
	) REFERENCES [dbo].[Rubro] (
		[rub_id]
	),
	CONSTRAINT [FK_Producto_TasaImpositiva] FOREIGN KEY 
	(
		[ti_id_ivarnicompra]
	) REFERENCES [dbo].[TasaImpositiva] (
		[ti_id]
	),
	CONSTRAINT [FK_Producto_TasaImpositiva1] FOREIGN KEY 
	(
		[ti_id_ivariventa]
	) REFERENCES [dbo].[TasaImpositiva] (
		[ti_id]
	),
	CONSTRAINT [FK_Producto_TasaImpositiva2] FOREIGN KEY 
	(
		[ti_id_internosv]
	) REFERENCES [dbo].[TasaImpositiva] (
		[ti_id]
	),
	CONSTRAINT [FK_Producto_TasaImpositiva3] FOREIGN KEY 
	(
		[ti_id_internosc]
	) REFERENCES [dbo].[TasaImpositiva] (
		[ti_id]
	),
	CONSTRAINT [FK_Producto_TIRICompra] FOREIGN KEY 
	(
		[ti_id_ivaricompra]
	) REFERENCES [dbo].[TasaImpositiva] (
		[ti_id]
	),
	CONSTRAINT [FK_Producto_TIRNIVenta] FOREIGN KEY 
	(
		[ti_id_ivarniventa]
	) REFERENCES [dbo].[TasaImpositiva] (
		[ti_id]
	),
	CONSTRAINT [FK_Producto_UnCompra] FOREIGN KEY 
	(
		[un_id_compra]
	) REFERENCES [dbo].[Unidad] (
		[un_id]
	),
	CONSTRAINT [FK_Producto_UnStock] FOREIGN KEY 
	(
		[un_id_stock]
	) REFERENCES [dbo].[Unidad] (
		[un_id]
	),
	CONSTRAINT [FK_Producto_UnVenta] FOREIGN KEY 
	(
		[un_id_venta]
	) REFERENCES [dbo].[Unidad] (
		[un_id]
	),
	CONSTRAINT [FK_Producto_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Proveedor] ADD 
	CONSTRAINT [FK_Proveedor_Provincia] FOREIGN KEY 
	(
		[pro_id]
	) REFERENCES [dbo].[Provincia] (
		[pro_id]
	),
	CONSTRAINT [FK_Proveedor_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	),
	CONSTRAINT [FK_Proveedor_Zona] FOREIGN KEY 
	(
		[zon_id]
	) REFERENCES [dbo].[Zona] (
		[zon_id]
	)
GO

ALTER TABLE [dbo].[Provincia] ADD 
	CONSTRAINT [FK_Provincia_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Rama] ADD 
	CONSTRAINT [FK_Rama_Arbol] FOREIGN KEY 
	(
		[arb_id]
	) REFERENCES [dbo].[Arbol] (
		[arb_id]
	),
	CONSTRAINT [FK_Rama_Rama] FOREIGN KEY 
	(
		[ram_id_padre]
	) REFERENCES [dbo].[Rama] (
		[ram_id]
	),
	CONSTRAINT [FK_Rama_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Rol] ADD 
	CONSTRAINT [FK_Rol_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Rubro] ADD 
	CONSTRAINT [FK_Rubro_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[TarjetaCredito] ADD 
	CONSTRAINT [FK_TarjetaCredito_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[TasaImpositiva] ADD 
	CONSTRAINT [FK_TasaImpositiva_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Unidad] ADD 
	CONSTRAINT [FK_Unidad_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Usuario] ADD 
	CONSTRAINT [FK_Usuario_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[UsuarioRol] ADD 
	CONSTRAINT [FK_UsuarioRol_Rol] FOREIGN KEY 
	(
		[rol_id]
	) REFERENCES [dbo].[Rol] (
		[rol_id]
	),
	CONSTRAINT [FK_UsuarioRol_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Vendedor] ADD 
	CONSTRAINT [FK_Vendedores_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

ALTER TABLE [dbo].[Zona] ADD 
	CONSTRAINT [FK_Zona_Usuario] FOREIGN KEY 
	(
		[modifico]
	) REFERENCES [dbo].[Usuario] (
		[us_id]
	)
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



CREATE TRIGGER [trgg_permiso_update] ON dbo.Permiso 
FOR  UPDATE
AS

UPDATE Permiso SET modificado = GETDATE() WHERE per_id IN (SELECT per_id FROM INSERTED)
INSERT INTO Historia (tbl_id, id, modifico, modificado) SELECT 4, per_id, modifico, modificado FROM INSERTED


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_us_insert] ON dbo.Usuario 
FOR INSERT
AS
UPDATE Usuario SET creado = GETDATE() WHERE us_id IN (SELECT us_id FROM INSERTED)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_us_update] ON dbo.Usuario 
FOR UPDATE
AS
UPDATE Usuario SET modificado = GETDATE() WHERE us_id IN (SELECT us_id FROM INSERTED)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

