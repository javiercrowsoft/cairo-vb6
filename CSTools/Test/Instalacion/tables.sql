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


