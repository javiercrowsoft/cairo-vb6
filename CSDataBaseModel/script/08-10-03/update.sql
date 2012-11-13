      
      /*
      CHANGE REPORT for Table Arbol
          - change datatype from varchar(50) to varchar(100) of column arb_nombre
      ACTION is DROP and CREATE Table Arbol
          - Data will be copied to table ArbolNA8D2558000 ,or table will be renamed ArbolNA8D2558000..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Arbol
          - index PK_Arbol will be dropped as a side effect. 
          - foreign key FK_Arbol_Tabla of table Arbol will be dropped as a side effect. 
          - foreign key FK_Arbol_Usuario of table Arbol will be dropped as a side effect. 
          - referencing foreign key FK_Rama_Arbol of table Rama will be dropped as a side effect. 
          - referencing foreign key FK_Hoja_Arbol of table Hoja will be dropped as a side effect. 
          - view Rama will be dropped as a side effect. 
          - view Hoja will be dropped as a side effect. 
      */

ALTER TABLE Arbol DROP CONSTRAINT FK_Arbol_Tabla 
go


ALTER TABLE Arbol DROP CONSTRAINT FK_Arbol_Usuario 
go


ALTER TABLE Rama DROP CONSTRAINT FK_Rama_Arbol 
go


ALTER TABLE Hoja DROP CONSTRAINT FK_Hoja_Arbol 
go


ALTER TABLE Arbol DROP CONSTRAINT PK_Arbol 
go


execute sp_rename Arbol, ArbolNA8D2558000
go

      
      /*
      CHANGE REPORT for Table Banco
          - change datatype from varchar(50) to varchar(100) of column bco_nombre
          - change datatype from varchar(10) to varchar(15) of column bco_codigo
      ACTION is DROP and CREATE Table Banco
          - Data will be copied to table BancoNA8D2558001 ,or table will be renamed BancoNA8D2558001..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Banco
          - index IX_BancoCodigo will be dropped as a side effect. 
          - index PK__Banco__0D99FE17 will be dropped as a side effect. 
          - foreign key FK_Banco_Usuario of table Banco will be dropped as a side effect. 
      */

ALTER TABLE Banco DROP CONSTRAINT FK_Banco_Usuario 
go


DROP INDEX Banco.IX_BancoCodigo
go


ALTER TABLE Banco DROP CONSTRAINT PK__Banco__0D99FE17 
go


execute sp_rename Banco, BancoNA8D2558001
go

      
      /*
      CHANGE REPORT for Table CDRom
          - change datatype from varchar(10) to varchar(15) of column cd_codigo
          - change datatype from varchar(50) to varchar(100) of column cd_nombre
      ACTION is DROP and CREATE Table CDRom
          - Data will be copied to table CDRomNA8D2558002 ,or table will be renamed CDRomNA8D2558002..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table CDRom
          - index IX_CDRomCodigo will be dropped as a side effect. 
          - index PK__CDRom__5CF6C6BC will be dropped as a side effect. 
          - referencing foreign key FK_CDRomCarpeta_CDRom of table CDRomCarpeta will be dropped as a side effect. 
          - referencing foreign key FK_CDRomArchivo_CDRom of table CDRomArchivo will be dropped as a side effect. 
          - view CDRomCarpeta will be dropped as a side effect. 
          - view CDRomArchivo will be dropped as a side effect. 
      */

ALTER TABLE CDRomCarpeta DROP CONSTRAINT FK_CDRomCarpeta_CDRom 
go


ALTER TABLE CDRomArchivo DROP CONSTRAINT FK_CDRomArchivo_CDRom 
go


DROP INDEX CDRom.IX_CDRomCodigo
go


ALTER TABLE CDRom DROP CONSTRAINT PK__CDRom__5CF6C6BC 
go


execute sp_rename CDRom, CDRomNA8D2558002
go

      
      /*
      CHANGE REPORT for Table CDRomArchivo
          - change null constraint from NULL to NOT NULL of column cda_tipo
          WARNING : Load data or ALTER statement for table CDRomArchivo may fail (existing data may violate the new column rules: changing column cda_tipo to NOT NULL without DEFAULT).
      ACTION is DROP and CREATE Table CDRomArchivo
          - Data will be copied to table CDRomArchivoNA8D2558003 ,or table will be renamed CDRomArchivoNA8D2558003..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table CDRomArchivo
          - index PK_CDRomArchivo will be dropped as a side effect. 
          - foreign key FK_CDRomArchivo_CDRom of table CDRomArchivo will be dropped as a side effect. 
          - foreign key FK_CDRomArchivo_CDRomCarpeta of table CDRomArchivo will be dropped as a side effect. 
      */

ALTER TABLE CDRomArchivo DROP CONSTRAINT FK_CDRomArchivo_CDRomCarpeta 
go


ALTER TABLE CDRomArchivo DROP CONSTRAINT PK_CDRomArchivo 
go


execute sp_rename CDRomArchivo, CDRomArchivoNA8D2558003
go

      
      /*
      CHANGE REPORT for Table CentroCosto
          - change datatype from varchar(50) to varchar(100) of column ccos_nombre
          - change datatype from varchar(10) to varchar(15) of column ccos_codigo
      ACTION is DROP and CREATE Table CentroCosto
          - Data will be copied to table CentroCostoNA8D2558004 ,or table will be renamed CentroCostoNA8D2558004..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table CentroCosto
          - index IX_CentroCostoCodigo will be dropped as a side effect. 
          - index PK__CentroCosto__56D3D912 will be dropped as a side effect. 
      */

DROP INDEX CentroCosto.IX_CentroCostoCodigo
go


ALTER TABLE CentroCosto DROP CONSTRAINT PK__CentroCosto__56D3D912 
go


execute sp_rename CentroCosto, CentroCostoNA8D2558004
go

      
      /*
      CHANGE REPORT for Table Chequera
          - change datatype from varchar(10) to varchar(100) of column chq_codigo
          - Adding column activo
      ACTION is DROP and CREATE Table Chequera
          - Data will be copied to table ChequeraNA8D2558005 ,or table will be renamed ChequeraNA8D2558005..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Chequera
          - index IX_ChequeraCodigo will be dropped as a side effect. 
          - index PK__Chequera__6B44E613 will be dropped as a side effect. 
      */

DROP INDEX Chequera.IX_ChequeraCodigo
go


ALTER TABLE Chequera DROP CONSTRAINT PK__Chequera__6B44E613 
go


execute sp_rename Chequera, ChequeraNA8D2558005
go

      
      /*
      CHANGE REPORT for Table Ciudad
          - change datatype from varchar(50) to varchar(100) of column ciu_nombre
          - change datatype from varchar(10) to varchar(15) of column ciu_codigo
      ACTION is DROP and CREATE Table Ciudad
          - Data will be copied to table CiudadNA8D2558006 ,or table will be renamed CiudadNA8D2558006..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Ciudad
          - index IX_Ciudad_codigo will be dropped as a side effect. 
          - index PK_Ciudad will be dropped as a side effect. 
          - foreign key FK_Ciudad_Provincia1 of table Ciudad will be dropped as a side effect. 
          - foreign key FK_Ciudad_Usuario of table Ciudad will be dropped as a side effect. 
      */

ALTER TABLE Ciudad DROP CONSTRAINT FK_Ciudad_Provincia1 
go


ALTER TABLE Ciudad DROP CONSTRAINT FK_Ciudad_Usuario 
go


DROP INDEX Ciudad.IX_Ciudad_codigo
go


ALTER TABLE Ciudad DROP CONSTRAINT PK_Ciudad 
go


execute sp_rename Ciudad, CiudadNA8D2558006
go

      
      /*
      CHANGE REPORT for Table Clearing
          - change datatype from varchar(50) to varchar(100) of column cle_nombre
          - change datatype from varchar(10) to varchar(15) of column cle_codigo
      ACTION is DROP and CREATE Table Clearing
          - Data will be copied to table ClearingNA8D2558007 ,or table will be renamed ClearingNA8D2558007..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Clearing
          - index IX_ClearingCodigo will be dropped as a side effect. 
          - index PK__Clearing__70099B30 will be dropped as a side effect. 
      */

DROP INDEX Clearing.IX_ClearingCodigo
go


ALTER TABLE Clearing DROP CONSTRAINT PK__Clearing__70099B30 
go


execute sp_rename Clearing, ClearingNA8D2558007
go

      
      /*
      CHANGE REPORT for Table Cliente
          - change datatype from varchar(50) to varchar(255) of column cli_nombre
          - change datatype from varchar(20) to varchar(100) of column cli_contacto
          - change datatype from varchar(100) to varchar(255) of column cli_razonsocial
      ACTION is DROP and CREATE Table Cliente
          - Data will be copied to table ClienteNA8D2558008 ,or table will be renamed ClienteNA8D2558008..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Cliente
          - index IX_ClienteCodigo will be dropped as a side effect. 
          - index PK__Cliente__0F824689 will be dropped as a side effect. 
          - foreign key FK__Cliente__pro_id__116A8EFB of table Cliente will be dropped as a side effect. 
          - foreign key FK__Cliente__modific__125EB334 of table Cliente will be dropped as a side effect. 
          - foreign key FK__Cliente__zon_id__10766AC2 of table Cliente will be dropped as a side effect. 
          - referencing foreign key FK__Tarea__cli_id__16EE5E27 of table Tarea will be dropped as a side effect. 
          - referencing foreign key FK_Proyecto_Cliente of table Proyecto will be dropped as a side effect. 
          - referencing foreign key FK__PedidoVen__cli_i__6FD49106 of table PedidoVenta will be dropped as a side effect. 
          - referencing foreign key FK__ListaPrec__cli_i__65570293 of table ListaPrecioCliente will be dropped as a side effect. 
          - referencing foreign key FK__ListaDesc__cli_i__5EAA0504 of table ListaDescuentoCliente will be dropped as a side effect. 
          - referencing foreign key FK__Hora__cli_id__05C3D225 of table Hora will be dropped as a side effect. 
          - referencing foreign key FK__Direccion__cli_i__153B1FDF of table Direccion will be dropped as a side effect. 
          - referencing foreign key FK__CuentaUso__cli_i__7869D707 of table CuentaUso will be dropped as a side effect. 
          - referencing foreign key FK__Contacto__cli_id__17236851 of table Contacto will be dropped as a side effect. 
          - referencing foreign key FK__ClienteSu__cli_i__5AD97420 of table ClienteSucursal will be dropped as a side effect. 
          - view Tarea will be dropped as a side effect. 
          - view Proyecto will be dropped as a side effect. 
          - view PedidoVenta will be dropped as a side effect. 
          - view ListaPrecioCliente will be dropped as a side effect. 
          - view ListaDescuentoCliente will be dropped as a side effect. 
          - view Hora will be dropped as a side effect. 
          - view Direccion will be dropped as a side effect. 
          - view CuentaUso will be dropped as a side effect. 
          - view Contacto will be dropped as a side effect. 
          - view ClienteSucursal will be dropped as a side effect. 
      */

ALTER TABLE Cliente DROP CONSTRAINT FK__Cliente__pro_id__116A8EFB 
go


ALTER TABLE Cliente DROP CONSTRAINT FK__Cliente__modific__125EB334 
go


ALTER TABLE Cliente DROP CONSTRAINT FK__Cliente__zon_id__10766AC2 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__cli_id__16EE5E27 
go


ALTER TABLE Proyecto DROP CONSTRAINT FK_Proyecto_Cliente 
go


ALTER TABLE PedidoVenta DROP CONSTRAINT FK__PedidoVen__cli_i__6FD49106 
go


ALTER TABLE ListaPrecioCliente DROP CONSTRAINT FK__ListaPrec__cli_i__65570293 
go


ALTER TABLE ListaDescuentoCliente DROP CONSTRAINT 
    FK__ListaDesc__cli_i__5EAA0504 
go


ALTER TABLE Hora DROP CONSTRAINT FK__Hora__cli_id__05C3D225 
go


ALTER TABLE Direccion DROP CONSTRAINT FK__Direccion__cli_i__153B1FDF 
go


ALTER TABLE CuentaUso DROP CONSTRAINT FK__CuentaUso__cli_i__7869D707 
go


ALTER TABLE Contacto DROP CONSTRAINT FK__Contacto__cli_id__17236851 
go


ALTER TABLE ClienteSucursal DROP CONSTRAINT FK__ClienteSu__cli_i__5AD97420 
go


DROP INDEX Cliente.IX_ClienteCodigo
go


ALTER TABLE Cliente DROP CONSTRAINT PK__Cliente__0F824689 
go


execute sp_rename Cliente, ClienteNA8D2558008
go

      
      /*
      CHANGE REPORT for Table ClienteSucursal
          - change datatype from varchar(50) to varchar(100) of column clis_nombre
          - change datatype from varchar(10) to varchar(15) of column clis_codigo
      ACTION is DROP and CREATE Table ClienteSucursal
          - Data will be copied to table ClienteSucursalNA8D2558009 ,or table will be renamed ClienteSucursalNA8D2558009..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table ClienteSucursal
          - index IX_ClienteSucursalCodigo will be dropped as a side effect. 
          - index PK__ClienteSucursal__19FFD4FC will be dropped as a side effect. 
          - foreign key FK__ClienteSu__cli_i__5AD97420 of table ClienteSucursal will be dropped as a side effect. 
          - foreign key FK__ClienteSu__modif__59E54FE7 of table ClienteSucursal will be dropped as a side effect. 
      */

ALTER TABLE ClienteSucursal DROP CONSTRAINT FK__ClienteSu__modif__59E54FE7 
go


DROP INDEX ClienteSucursal.IX_ClienteSucursalCodigo
go


ALTER TABLE ClienteSucursal DROP CONSTRAINT PK__ClienteSucursal__19FFD4FC 
go


execute sp_rename ClienteSucursal, ClienteSucursalNA8D2558009
go

      
      /*
      CHANGE REPORT for Table Cobrador
          - change datatype from varchar(50) to varchar(100) of column cob_nombre
          - change datatype from varchar(10) to varchar(15) of column cob_codigo
      ACTION is DROP and CREATE Table Cobrador
          - Data will be copied to table CobradorNA8D2558010 ,or table will be renamed CobradorNA8D2558010..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Cobrador
          - index IX_CobradorCodigo will be dropped as a side effect. 
          - index PK__Cobrador__09C96D33 will be dropped as a side effect. 
          - foreign key FK__Cobrador__rel_id__19CACAD2 of table Cobrador will be dropped as a side effect. 
      */

ALTER TABLE Cobrador DROP CONSTRAINT FK__Cobrador__rel_id__19CACAD2 
go


DROP INDEX Cobrador.IX_CobradorCodigo
go


ALTER TABLE Cobrador DROP CONSTRAINT PK__Cobrador__09C96D33 
go


execute sp_rename Cobrador, CobradorNA8D2558010
go

      
      /*
      CHANGE REPORT for Table Cuenta
          - change datatype from varchar(50) to varchar(100) of column cue_nombre
          - change datatype from varchar(10) to varchar(15) of column cue_codigo
      ACTION is DROP and CREATE Table Cuenta
          - Data will be copied to table CuentaNA8D2558011 ,or table will be renamed CuentaNA8D2558011..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Cuenta
          - index IX_CuentaCodigo will be dropped as a side effect. 
          - index PK_Cuenta will be dropped as a side effect. 
          - foreign key FK__Cuenta__cuec_id__76818E95 of table Cuenta will be dropped as a side effect. 
          - foreign key FK__Cuenta__cuec_id___758D6A5C of table Cuenta will be dropped as a side effect. 
          - foreign key FK__Cuenta__modifico__74994623 of table Cuenta will be dropped as a side effect. 
          - referencing foreign key FK_Producto_Cuenta1 of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_Cuenta of table Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
      */

ALTER TABLE Cuenta DROP CONSTRAINT FK__Cuenta__cuec_id__76818E95 
go


ALTER TABLE Cuenta DROP CONSTRAINT FK__Cuenta__cuec_id___758D6A5C 
go


ALTER TABLE Cuenta DROP CONSTRAINT FK__Cuenta__modifico__74994623 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_Cuenta1 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_Cuenta 
go


DROP INDEX Cuenta.IX_CuentaCodigo
go


ALTER TABLE Cuenta DROP CONSTRAINT PK_Cuenta 
go


execute sp_rename Cuenta, CuentaNA8D2558011
go

      
      /*
      CHANGE REPORT for Table CuentaCategoria
          - change datatype from varchar(50) to varchar(100) of column cuec_nombre
          - change datatype from varchar(10) to varchar(15) of column cuec_codigo
      ACTION is DROP and CREATE Table CuentaCategoria
          - Data will be copied to table CuentaCategoriaNA8D2558012 ,or table will be renamed CuentaCategoriaNA8D2558012..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table CuentaCategoria
          - index IX_CuentaCategoriaCodigo will be dropped as a side effect. 
          - index PK__CuentaCategoria__3D491139 will be dropped as a side effect. 
          - foreign key FK__CuentaCat__modif__7775B2CE of table CuentaCategoria will be dropped as a side effect. 
          - referencing foreign key FK__Cuenta__cuec_id__76818E95 of table Cuenta will be dropped as a side effect. 
          - referencing foreign key FK__Cuenta__cuec_id___758D6A5C of table Cuenta will be dropped as a side effect. 
          - view Cuenta will be dropped as a side effect. 
          - view Cuenta will be dropped as a side effect. 
      */

ALTER TABLE CuentaCategoria DROP CONSTRAINT FK__CuentaCat__modif__7775B2CE 
go


DROP INDEX CuentaCategoria.IX_CuentaCategoriaCodigo
go


ALTER TABLE CuentaCategoria DROP CONSTRAINT PK__CuentaCategoria__3D491139 
go


execute sp_rename CuentaCategoria, CuentaCategoriaNA8D2558012
go

      
      /*
      CHANGE REPORT for Table CuentaUso
          - change datatype from varchar(10) to varchar(15) of column cueu_codigo
          - change datatype from varchar(50) to varchar(100) of column cueu_nombre
      ACTION is DROP and CREATE Table CuentaUso
          - Data will be copied to table CuentaUsoNA8D2558013 ,or table will be renamed CuentaUsoNA8D2558013..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table CuentaUso
          - index IX_CuentaUsoCodigo will be dropped as a side effect. 
          - index PK__CuentaUso__3F3159AB will be dropped as a side effect. 
          - foreign key FK__CuentaUso__cli_i__7869D707 of table CuentaUso will be dropped as a side effect. 
          - foreign key FK__CuentaUso__prov___795DFB40 of table CuentaUso will be dropped as a side effect. 
      */

ALTER TABLE CuentaUso DROP CONSTRAINT FK__CuentaUso__prov___795DFB40 
go


DROP INDEX CuentaUso.IX_CuentaUsoCodigo
go


ALTER TABLE CuentaUso DROP CONSTRAINT PK__CuentaUso__3F3159AB 
go


execute sp_rename CuentaUso, CuentaUsoNA8D2558013
go

      
      /*
      CHANGE REPORT for Table DepositoFisico
          - change datatype from varchar(30) to varchar(100) of column depf_nombre
      ACTION is DROP and CREATE Table DepositoFisico
          - Data will be copied to table DepositoFisicoNA8D2558014 ,or table will be renamed DepositoFisicoNA8D2558014..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table DepositoFisico
          - index IX_DepositoFisicoCodigo will be dropped as a side effect. 
          - index PK__DepositoFisico__4119A21D will be dropped as a side effect. 
          - foreign key FK__DepositoF__modif__7A521F79 of table DepositoFisico will be dropped as a side effect. 
          - referencing foreign key FK__DepositoL__depf___7B4643B2 of table DepositoLogico will be dropped as a side effect. 
          - view DepositoLogico will be dropped as a side effect. 
      */

ALTER TABLE DepositoFisico DROP CONSTRAINT FK__DepositoF__modif__7A521F79 
go


ALTER TABLE DepositoLogico DROP CONSTRAINT FK__DepositoL__depf___7B4643B2 
go


DROP INDEX DepositoFisico.IX_DepositoFisicoCodigo
go


ALTER TABLE DepositoFisico DROP CONSTRAINT PK__DepositoFisico__4119A21D 
go


execute sp_rename DepositoFisico, DepositoFisicoNA8D2558014
go

      
      /*
      CHANGE REPORT for Table DepositoLogico
          - change datatype from varchar(30) to varchar(100) of column depl_nombre
      ACTION is DROP and CREATE Table DepositoLogico
          - Data will be copied to table DepositoLogicoNA8D2558015 ,or table will be renamed DepositoLogicoNA8D2558015..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table DepositoLogico
          - index IX_DepositoLogicoCodigo will be dropped as a side effect. 
          - index PK__DepositoLogico__4301EA8F will be dropped as a side effect. 
          - foreign key FK__DepositoL__depf___7B4643B2 of table DepositoLogico will be dropped as a side effect. 
          - foreign key FK__DepositoL__modif__7C3A67EB of table DepositoLogico will be dropped as a side effect. 
      */

ALTER TABLE DepositoLogico DROP CONSTRAINT FK__DepositoL__modif__7C3A67EB 
go


DROP INDEX DepositoLogico.IX_DepositoLogicoCodigo
go


ALTER TABLE DepositoLogico DROP CONSTRAINT PK__DepositoLogico__4301EA8F 
go


execute sp_rename DepositoLogico, DepositoLogicoNA8D2558015
go

      
      /*
      CHANGE REPORT for Table Documento
          - change datatype from varchar(255) to varchar(100) of column doc_nombre
          WARNING : Load data statement for table Documento may fail or data in column doc_nombre may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
          - change datatype from varchar(50) to varchar(15) of column doc_codigo
          WARNING : Load data statement for table Documento may fail or data in column doc_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Documento
          - Data will be copied to table DocumentoNA8D2558016 ,or table will be renamed DocumentoNA8D2558016..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Documento
          - index IX_DocumentoCodigo will be dropped as a side effect. 
          - index PK__Documento__44EA3301 will be dropped as a side effect. 
          - foreign key FK__Documento__doct___7D2E8C24 of table Documento will be dropped as a side effect. 
          - foreign key FK__Documento__modif__7E22B05D of table Documento will be dropped as a side effect. 
          - referencing foreign key FK__PedidoVen__doc_i__6DEC4894 of table PedidoVenta will be dropped as a side effect. 
          - view PedidoVenta will be dropped as a side effect. 
      */

ALTER TABLE Documento DROP CONSTRAINT FK__Documento__doct___7D2E8C24 
go


ALTER TABLE Documento DROP CONSTRAINT FK__Documento__modif__7E22B05D 
go


ALTER TABLE PedidoVenta DROP CONSTRAINT FK__PedidoVen__doc_i__6DEC4894 
go


DROP INDEX Documento.IX_DocumentoCodigo
go


ALTER TABLE Documento DROP CONSTRAINT PK__Documento__44EA3301 
go


execute sp_rename Documento, DocumentoNA8D2558016
go

      
      /*
      CHANGE REPORT for Table DocumentoTipo
          - change datatype from varchar(50) to varchar(100) of column doct_nombre
          - change datatype from varchar(50) to varchar(15) of column doct_codigo
          WARNING : Load data statement for table DocumentoTipo may fail or data in column doct_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table DocumentoTipo
          - Data will be copied to table DocumentoTipoNA8D2558017 ,or table will be renamed DocumentoTipoNA8D2558017..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table DocumentoTipo
          - index IX_DocumentoTipoCodigo will be dropped as a side effect. 
          - index PK__DocumentoTipo__46D27B73 will be dropped as a side effect. 
          - foreign key FK__Documento__modif__7F16D496 of table DocumentoTipo will be dropped as a side effect. 
          - referencing foreign key FK__PedidoVen__doct___6B0FDBE9 of table PedidoVenta will be dropped as a side effect. 
          - referencing foreign key FK__Documento__doct___7D2E8C24 of table Documento will be dropped as a side effect. 
          - view PedidoVenta will be dropped as a side effect. 
          - view Documento will be dropped as a side effect. 
      */

ALTER TABLE DocumentoTipo DROP CONSTRAINT FK__Documento__modif__7F16D496 
go


ALTER TABLE PedidoVenta DROP CONSTRAINT FK__PedidoVen__doct___6B0FDBE9 
go


DROP INDEX DocumentoTipo.IX_DocumentoTipoCodigo
go


ALTER TABLE DocumentoTipo DROP CONSTRAINT PK__DocumentoTipo__46D27B73 
go


execute sp_rename DocumentoTipo, DocumentoTipoNA8D2558017
go

      
      /*
      CHANGE REPORT for Table Escala
          - change datatype from varchar(20) to varchar(15) of column esc_codigo
          WARNING : Load data statement for table Escala may fail or data in column esc_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Escala
          - Data will be copied to table EscalaNA8D2558018 ,or table will be renamed EscalaNA8D2558018..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Escala
          - index IX_EscalaCodigo will be dropped as a side effect. 
          - index PK_Escala will be dropped as a side effect. 
      */

DROP INDEX Escala.IX_EscalaCodigo
go


ALTER TABLE Escala DROP CONSTRAINT PK_Escala 
go


execute sp_rename Escala, EscalaNA8D2558018
go

      
      /*
      CHANGE REPORT for Table Estado
          - change datatype from char(50) to char(100) of column est_nombre
          - change datatype from char(10) to char(15) of column est_codigo
      ACTION is DROP and CREATE Table Estado
          - Data will be copied to table EstadoNA8D2558019 ,or table will be renamed EstadoNA8D2558019..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Estado
          - index IX_EstadoCodigo will be dropped as a side effect. 
          - index PK__Estado__1BE81D6E will be dropped as a side effect. 
      */

DROP INDEX Estado.IX_EstadoCodigo
go


ALTER TABLE Estado DROP CONSTRAINT PK__Estado__1BE81D6E 
go


execute sp_rename Estado, EstadoNA8D2558019
go

      
      /*
      CHANGE REPORT for Table FechaControlAcceso
          - change datatype from varchar(50) to varchar(100) of column fca_nombre
          - change datatype from varchar(50) to varchar(15) of column fca_codigo
          WARNING : Load data statement for table FechaControlAcceso may fail or data in column fca_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table FechaControlAcceso
          - Data will be copied to table FechaControlAccesoNA8D2558020 ,or table will be renamed FechaControlAccesoNA8D2558020..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table FechaControlAcceso
          - index IX_FechaControlAccesoCodigo will be dropped as a side effect. 
          - index PK__FechaControlAcce__1DD065E0 will be dropped as a side effect. 
      */

DROP INDEX FechaControlAcceso.IX_FechaControlAccesoCodigo
go


ALTER TABLE FechaControlAcceso DROP CONSTRAINT PK__FechaControlAcce__1DD065E0 
go


execute sp_rename FechaControlAcceso, FechaControlAccesoNA8D2558020
go

      
      /*
      CHANGE REPORT for Table FeriadoBancario
          - change datatype from varchar(50) to varchar(100) of column fb_nombre
          - change datatype from varchar(20) to varchar(15) of column fb_codigo
          WARNING : Load data statement for table FeriadoBancario may fail or data in column fb_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table FeriadoBancario
          - Data will be copied to table FeriadoBancarioNA8D2558021 ,or table will be renamed FeriadoBancarioNA8D2558021..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table FeriadoBancario
          - index IX_FeriadoBancarioCodigo will be dropped as a side effect. 
          - index PK__FeriadoBancario__1FB8AE52 will be dropped as a side effect. 
      */

DROP INDEX FeriadoBancario.IX_FeriadoBancarioCodigo
go


ALTER TABLE FeriadoBancario DROP CONSTRAINT PK__FeriadoBancario__1FB8AE52 
go


execute sp_rename FeriadoBancario, FeriadoBancarioNA8D2558021
go

      
      /*
      CHANGE REPORT for Table Hora
          - change null constraint from NULL to NOT NULL of column tar_id
          WARNING : Load data or ALTER statement for table Hora may fail (existing data may violate the new column rules: changing column tar_id to NOT NULL without DEFAULT).
      ACTION is DROP and CREATE Table Hora
          - Data will be copied to table HoraNA8D2558022 ,or table will be renamed HoraNA8D2558022..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Hora
          - index PK__Hora__4AA30C57 will be dropped as a side effect. 
          - foreign key FK__Hora__cli_id__05C3D225 of table Hora will be dropped as a side effect. 
          - foreign key FK__Hora__obje_id__03DB89B3 of table Hora will be dropped as a side effect. 
          - foreign key FK__Hora__proy_id__02E7657A of table Hora will be dropped as a side effect. 
          - foreign key FK__Hora__proyi_id__06B7F65E of table Hora will be dropped as a side effect. 
          - foreign key FK__Hora__tar_id__01F34141 of table Hora will be dropped as a side effect. 
          - foreign key FK__Hora__us_id__04CFADEC of table Hora will be dropped as a side effect. 
      */

ALTER TABLE Hora DROP CONSTRAINT FK__Hora__obje_id__03DB89B3 
go


ALTER TABLE Hora DROP CONSTRAINT FK__Hora__proy_id__02E7657A 
go


ALTER TABLE Hora DROP CONSTRAINT FK__Hora__proyi_id__06B7F65E 
go


ALTER TABLE Hora DROP CONSTRAINT FK__Hora__tar_id__01F34141 
go


ALTER TABLE Hora DROP CONSTRAINT FK__Hora__us_id__04CFADEC 
go


ALTER TABLE Hora DROP CONSTRAINT PK__Hora__4AA30C57 
go


execute sp_rename Hora, HoraNA8D2558022
go

      
      /*
      CHANGE REPORT for Table Informe
          - change datatype from varchar(50) to varchar(100) of column inf_nombre
          - change datatype from varchar(50) to varchar(15) of column inf_codigo
          WARNING : Load data statement for table Informe may fail or data in column inf_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
          - change datatype from varchar(255) to varchar(1000), change null constraint from NOT NULL to NULL of column inf_descrip
          - Adding a new relationship FK_Informe_Usuario
          WARNING : Create FK statement may fail (existing data may violate the new FK rules: adding a new FK FK_Informe_Usuario of table Informe, which references table Usuario).
      ACTION is DROP and CREATE Table Informe
          - Data will be copied to table InformeNA8D2558023 ,or table will be renamed InformeNA8D2558023..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Informe
          - index IX_informeCodigo will be dropped as a side effect. 
          - index PK__Informe__21A0F6C4 will be dropped as a side effect. 
      */

DROP INDEX Informe.IX_informeCodigo
go


ALTER TABLE Informe DROP CONSTRAINT PK__Informe__21A0F6C4 
go


execute sp_rename Informe, InformeNA8D2558023
go

      
      /*
      CHANGE REPORT for Table IngresosBrutosCategoria
          - change datatype from varchar(50) to varchar(100) of column ibc_nombre
          - change datatype from varchar(10) to varchar(15) of column ibc_codigo
      ACTION is DROP and CREATE Table IngresosBrutosCategoria
          - Data will be copied to table IngresosBrutosCategoriaNA8D2558024 ,or table will be renamed IngresosBrutosCategoriaNA8D2558024..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table IngresosBrutosCategoria
          - index IX_IngresosBrutosCategoriaCodigo will be dropped as a side effect. 
          - index PK__IngresosBrutosCa__4C8B54C9 will be dropped as a side effect. 
          - foreign key FK__IngresosB__modif__07AC1A97 of table IngresosBrutosCategoria will be dropped as a side effect. 
          - referencing foreign key FK__Producto__ibc_id__18D6A699 of table Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
      */

ALTER TABLE IngresosBrutosCategoria DROP CONSTRAINT 
    FK__IngresosB__modif__07AC1A97 
go


ALTER TABLE Producto DROP CONSTRAINT FK__Producto__ibc_id__18D6A699 
go


DROP INDEX IngresosBrutosCategoria.IX_IngresosBrutosCategoriaCodigo
go


ALTER TABLE IngresosBrutosCategoria DROP CONSTRAINT 
    PK__IngresosBrutosCa__4C8B54C9 
go


execute sp_rename IngresosBrutosCategoria, IngresosBrutosCategoriaNA8D2558024
go

      
      /*
      CHANGE REPORT for Table Leyenda
          - change datatype from varchar(50) to varchar(100) of column ley_nombre
          - change datatype from varchar(10) to varchar(15) of column ley_codigo
      ACTION is DROP and CREATE Table Leyenda
          - Data will be copied to table LeyendaNA8D2558025 ,or table will be renamed LeyendaNA8D2558025..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Leyenda
          - index IX_LeyendaCodigo will be dropped as a side effect. 
          - index PK__Leyenda__4E739D3B will be dropped as a side effect. 
          - foreign key FK__Leyenda__modific__08A03ED0 of table Leyenda will be dropped as a side effect. 
      */

ALTER TABLE Leyenda DROP CONSTRAINT FK__Leyenda__modific__08A03ED0 
go


DROP INDEX Leyenda.IX_LeyendaCodigo
go


ALTER TABLE Leyenda DROP CONSTRAINT PK__Leyenda__4E739D3B 
go


execute sp_rename Leyenda, LeyendaNA8D2558025
go

      
      /*
      CHANGE REPORT for Table ListaDescuento
          - change datatype from varchar(50) to varchar(100) of column ld_nombre
      ACTION is DROP and CREATE Table ListaDescuento
          - Data will be copied to table ListaDescuentoNA8D2558026 ,or table will be renamed ListaDescuentoNA8D2558026..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table ListaDescuento
          - index IX_ListaDescuentoCodigo will be dropped as a side effect. 
          - index PK__ListaDescuento__23893F36 will be dropped as a side effect. 
          - foreign key FK__ListaDesc__ld_id__5BCD9859 of table ListaDescuento will be dropped as a side effect. 
          - foreign key FK__ListaDesc__modif__5CC1BC92 of table ListaDescuento will be dropped as a side effect. 
          - referencing foreign key FK__PedidoVen__ld_id__6C040022 of table PedidoVenta will be dropped as a side effect. 
          - referencing foreign key FK__ListaDesc__ld_id__5F9E293D of table ListaDescuentoItem will be dropped as a side effect. 
          - referencing foreign key FK__ListaDesc__ld_id__5DB5E0CB of table ListaDescuentoCliente will be dropped as a side effect. 
          - referencing foreign key FK__ListaDesc__ld_id__5BCD9859 of table ListaDescuento will be dropped as a side effect. 
          - view PedidoVenta will be dropped as a side effect. 
          - view ListaDescuentoItem will be dropped as a side effect. 
          - view ListaDescuentoCliente will be dropped as a side effect. 
          - view ListaDescuento will be dropped as a side effect. 
      */

ALTER TABLE ListaDescuento DROP CONSTRAINT FK__ListaDesc__ld_id__5BCD9859 
go


ALTER TABLE ListaDescuento DROP CONSTRAINT FK__ListaDesc__modif__5CC1BC92 
go


ALTER TABLE PedidoVenta DROP CONSTRAINT FK__PedidoVen__ld_id__6C040022 
go


ALTER TABLE ListaDescuentoItem DROP CONSTRAINT FK__ListaDesc__ld_id__5F9E293D 
go


ALTER TABLE ListaDescuentoCliente DROP CONSTRAINT 
    FK__ListaDesc__ld_id__5DB5E0CB 
go


DROP INDEX ListaDescuento.IX_ListaDescuentoCodigo
go


ALTER TABLE ListaDescuento DROP CONSTRAINT PK__ListaDescuento__23893F36 
go


execute sp_rename ListaDescuento, ListaDescuentoNA8D2558026
go

      
      /*
      CHANGE REPORT for Table ListaPrecio
          - change datatype from varchar(50) to varchar(100) of column lp_nombre
          - change datatype from varchar(20) to varchar(15) of column lp_codigo
          WARNING : Load data statement for table ListaPrecio may fail or data in column lp_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table ListaPrecio
          - Data will be copied to table ListaPrecioNA8D2558027 ,or table will be renamed ListaPrecioNA8D2558027..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table ListaPrecio
          - index IX_ListaPrecioCodigo will be dropped as a side effect. 
          - index PK__ListaPrecio__2942188C will be dropped as a side effect. 
          - foreign key FK__ListaPrec__lp_id__636EBA21 of table ListaPrecio will be dropped as a side effect. 
          - foreign key FK__ListaPrec__modif__627A95E8 of table ListaPrecio will be dropped as a side effect. 
          - referencing foreign key FK__PedidoVen__lp_id__6EE06CCD of table PedidoVenta will be dropped as a side effect. 
          - referencing foreign key FK__ListaPrec__lp_id__673F4B05 of table ListaPrecioItem will be dropped as a side effect. 
          - referencing foreign key FK__ListaPrec__lp_id__6462DE5A of table ListaPrecioCliente will be dropped as a side effect. 
          - referencing foreign key FK__ListaPrec__lp_id__636EBA21 of table ListaPrecio will be dropped as a side effect. 
          - view PedidoVenta will be dropped as a side effect. 
          - view ListaPrecioItem will be dropped as a side effect. 
          - view ListaPrecioCliente will be dropped as a side effect. 
          - view ListaPrecio will be dropped as a side effect. 
      */

ALTER TABLE ListaPrecio DROP CONSTRAINT FK__ListaPrec__lp_id__636EBA21 
go


ALTER TABLE ListaPrecio DROP CONSTRAINT FK__ListaPrec__modif__627A95E8 
go


ALTER TABLE PedidoVenta DROP CONSTRAINT FK__PedidoVen__lp_id__6EE06CCD 
go


ALTER TABLE ListaPrecioItem DROP CONSTRAINT FK__ListaPrec__lp_id__673F4B05 
go


ALTER TABLE ListaPrecioCliente DROP CONSTRAINT FK__ListaPrec__lp_id__6462DE5A 
go


DROP INDEX ListaPrecio.IX_ListaPrecioCodigo
go


ALTER TABLE ListaPrecio DROP CONSTRAINT PK__ListaPrecio__2942188C 
go


execute sp_rename ListaPrecio, ListaPrecioNA8D2558027
go

      
      /*
      CHANGE REPORT for Table Marca
          - change datatype from varchar(50) to varchar(100) of column marc_nombre
          - change datatype from varchar(10) to varchar(15) of column marc_codigo
      ACTION is DROP and CREATE Table Marca
          - Data will be copied to table MarcaNA8D2558028 ,or table will be renamed MarcaNA8D2558028..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Marca
          - index IX_MarcaCodigo will be dropped as a side effect. 
          - index PK__Marca__2EFAF1E2 will be dropped as a side effect. 
          - foreign key FK__Marca__modifico__69279377 of table Marca will be dropped as a side effect. 
      */

ALTER TABLE Marca DROP CONSTRAINT FK__Marca__modifico__69279377 
go


DROP INDEX Marca.IX_MarcaCodigo
go


ALTER TABLE Marca DROP CONSTRAINT PK__Marca__2EFAF1E2 
go


execute sp_rename Marca, MarcaNA8D2558028
go

      
      /*
      CHANGE REPORT for Table Moneda
          - change datatype from varchar(50) to varchar(100) of column mon_nombre
          - change datatype from varchar(10) to varchar(15) of column mon_codigo
          - Adding column mon_codigodgi1
          - Adding column mon_codigodgi2
      ACTION is DROP and CREATE Table Moneda
          - Data will be copied to table MonedaNA8D2558029 ,or table will be renamed MonedaNA8D2558029..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Moneda
          - index IX_MonedaCodigo will be dropped as a side effect. 
          - index PK__Moneda__515009E6 will be dropped as a side effect. 
          - foreign key FK__Moneda__modifico__09946309 of table Moneda will be dropped as a side effect. 
      */

ALTER TABLE Moneda DROP CONSTRAINT FK__Moneda__modifico__09946309 
go


DROP INDEX Moneda.IX_MonedaCodigo
go


ALTER TABLE Moneda DROP CONSTRAINT PK__Moneda__515009E6 
go


execute sp_rename Moneda, MonedaNA8D2558029
go

      
      /*
      CHANGE REPORT for Table Objetivo
          - change datatype from varchar(50) to varchar(100) of column obje_nombre
          - change datatype from varchar(10) to varchar(15) of column obje_codigo
      ACTION is DROP and CREATE Table Objetivo
          - Data will be copied to table ObjetivoNA8D2558030 ,or table will be renamed ObjetivoNA8D2558030..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Objetivo
          - index IX_ObjetivoCodigo will be dropped as a side effect. 
          - index PK_Objetivo will be dropped as a side effect. 
          - foreign key FK_Objetivo_Proyecto of table Objetivo will be dropped as a side effect. 
          - foreign key FK_Objetivo_Usuario of table Objetivo will be dropped as a side effect. 
          - referencing foreign key FK__Tarea__obje_id__131DCD43 of table Tarea will be dropped as a side effect. 
          - referencing foreign key FK__Hora__obje_id__03DB89B3 of table Hora will be dropped as a side effect. 
          - view Tarea will be dropped as a side effect. 
          - view Hora will be dropped as a side effect. 
      */

ALTER TABLE Objetivo DROP CONSTRAINT FK_Objetivo_Proyecto 
go


ALTER TABLE Objetivo DROP CONSTRAINT FK_Objetivo_Usuario 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__obje_id__131DCD43 
go


DROP INDEX Objetivo.IX_ObjetivoCodigo
go


ALTER TABLE Objetivo DROP CONSTRAINT PK_Objetivo 
go


execute sp_rename Objetivo, ObjetivoNA8D2558030
go

      
      /*
      CHANGE REPORT for Table Pais
          - change datatype from varchar(50) to varchar(100) of column pa_nombre
          - change datatype from varchar(10) to varchar(15) of column pa_codigo
          WARNING : Recreating Table Pais based on the ERwin source model. Any differences marked 'Ignore' in the compare list will be recreated based on the ERwin source model.
      ACTION is DROP and CREATE Table Pais
          - Data will be copied to table PaisNA8D2558031 ,or table will be renamed PaisNA8D2558031..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Pais
          - index IX_PaisCodigo will be dropped as a side effect. 
          - index PK_Pais will be dropped as a side effect. 
          - foreign key FK__Pais__modifico__6A1BB7B0 of table Pais will be dropped as a side effect. 
          - referencing foreign key FK_Provincia_Pais of table Provincia will be dropped as a side effect. 
          - view Provincia will be dropped as a side effect. 
      */

ALTER TABLE Pais DROP CONSTRAINT FK__Pais__modifico__6A1BB7B0 
go


ALTER TABLE Provincia DROP CONSTRAINT FK_Provincia_Pais 
go


DROP INDEX Pais.IX_PaisCodigo
go


ALTER TABLE Pais DROP CONSTRAINT PK_Pais 
go


execute sp_rename Pais, PaisNA8D2558031
go

      
      /*
      CHANGE REPORT for Table Percepciones
          - change datatype from varchar(50) to varchar(100) of column perc_nombre
          - change datatype from varchar(50) to varchar(15) of column perc_codigo
          WARNING : Load data statement for table Percepciones may fail or data in column perc_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Percepciones
          - Data will be copied to table PercepcionesNA8D2558032 ,or table will be renamed PercepcionesNA8D2558032..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Percepciones
          - index IX_PercepcionesCodigo will be dropped as a side effect. 
          - index PK__Percepciones__35A7EF71 will be dropped as a side effect. 
      */

DROP INDEX Percepciones.IX_PercepcionesCodigo
go


ALTER TABLE Percepciones DROP CONSTRAINT PK__Percepciones__35A7EF71 
go


execute sp_rename Percepciones, PercepcionesNA8D2558032
go

      
      /*
      CHANGE REPORT for Table Prestacion
          - change datatype from varchar(50) to varchar(100) of column pre_nombre
      ACTION is DROP and CREATE Table Prestacion
          - Data will be copied to table PrestacionNA8D2558033 ,or table will be renamed PrestacionNA8D2558033..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Prestacion
          - index PK_Prestacion will be dropped as a side effect. 
          - referencing foreign key FK_Permiso_Prestacion of table Permiso will be dropped as a side effect. 
          - view Permiso will be dropped as a side effect. 
      */

ALTER TABLE Permiso DROP CONSTRAINT FK_Permiso_Prestacion 
go


ALTER TABLE Prestacion DROP CONSTRAINT PK_Prestacion 
go


execute sp_rename Prestacion, PrestacionNA8D2558033
go

      
      /*
      CHANGE REPORT for Table Prioridad
          - change datatype from varchar(50) to varchar(100) of column prio_nombre
      ACTION is DROP and CREATE Table Prioridad
          - Data will be copied to table PrioridadNA8D2558034 ,or table will be renamed PrioridadNA8D2558034..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Prioridad
          - index PK_Prioridad will be dropped as a side effect. 
          - foreign key FK_Prioridad_Usuario of table Prioridad will be dropped as a side effect. 
          - referencing foreign key FK__Tarea__prio_id__113584D1 of table Tarea will be dropped as a side effect. 
          - view Tarea will be dropped as a side effect. 
      */

ALTER TABLE Prioridad DROP CONSTRAINT FK_Prioridad_Usuario 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__prio_id__113584D1 
go


ALTER TABLE Prioridad DROP CONSTRAINT PK_Prioridad 
go


execute sp_rename Prioridad, PrioridadNA8D2558034
go

      
      /*
      CHANGE REPORT for Table Proveedor
          - change datatype from varchar(50) to varchar(255) of column prov_nombre
          - change datatype from varchar(100) to varchar(255) of column prov_razonsocial
          - change datatype from varchar(13) to varchar(20) of column prov_cuit
      ACTION is DROP and CREATE Table Proveedor
          - Data will be copied to table ProveedorNA8D2558035 ,or table will be renamed ProveedorNA8D2558035..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Proveedor
          - index IX_ProveedorCodigo will be dropped as a side effect. 
          - index PK_Proveedor will be dropped as a side effect. 
          - foreign key FK_Proveedor_Provincia of table Proveedor will be dropped as a side effect. 
          - foreign key FK_Proveedor_Usuario of table Proveedor will be dropped as a side effect. 
          - foreign key FK_Proveedor_Zona of table Proveedor will be dropped as a side effect. 
          - referencing foreign key FK_Proyecto_Proveedor of table Proyecto will be dropped as a side effect. 
          - referencing foreign key Proveedor_Direccion_FK1 of table Direccion will be dropped as a side effect. 
          - referencing foreign key FK__CuentaUso__prov___795DFB40 of table CuentaUso will be dropped as a side effect. 
          - referencing foreign key FK_Contacto_Proveedor of table Contacto will be dropped as a side effect. 
          - view Proyecto will be dropped as a side effect. 
          - view Direccion will be dropped as a side effect. 
          - view CuentaUso will be dropped as a side effect. 
          - view Contacto will be dropped as a side effect. 
      */

ALTER TABLE Proveedor DROP CONSTRAINT FK_Proveedor_Provincia 
go


ALTER TABLE Proveedor DROP CONSTRAINT FK_Proveedor_Usuario 
go


ALTER TABLE Proveedor DROP CONSTRAINT FK_Proveedor_Zona 
go


ALTER TABLE Proyecto DROP CONSTRAINT FK_Proyecto_Proveedor 
go


ALTER TABLE Direccion DROP CONSTRAINT Proveedor_Direccion_FK1 
go


ALTER TABLE Contacto DROP CONSTRAINT FK_Contacto_Proveedor 
go


DROP INDEX Proveedor.IX_ProveedorCodigo
go


ALTER TABLE Proveedor DROP CONSTRAINT PK_Proveedor 
go


execute sp_rename Proveedor, ProveedorNA8D2558035
go

      
      /*
      CHANGE REPORT for Table Provincia
          - change datatype from varchar(50) to varchar(100) of column pro_nombre
      ACTION is DROP and CREATE Table Provincia
          - Data will be copied to table ProvinciaNA8D2558036 ,or table will be renamed ProvinciaNA8D2558036..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Provincia
          - index IX_ProvinciaCodigo will be dropped as a side effect. 
          - index PK_Provincia will be dropped as a side effect. 
          - foreign key FK_Provincia_Pais of table Provincia will be dropped as a side effect. 
          - foreign key FK_Provincia_Usuario of table Provincia will be dropped as a side effect. 
          - referencing foreign key FK_Proveedor_Provincia of table Proveedor will be dropped as a side effect. 
          - referencing foreign key FK_Direccion_Provincia of table Direccion will be dropped as a side effect. 
          - referencing foreign key FK__Cliente__pro_id__116A8EFB of table Cliente will be dropped as a side effect. 
          - referencing foreign key FK_Ciudad_Provincia1 of table Ciudad will be dropped as a side effect. 
          - view Proveedor will be dropped as a side effect. 
          - view Direccion will be dropped as a side effect. 
          - view Cliente will be dropped as a side effect. 
          - view Ciudad will be dropped as a side effect. 
      */

ALTER TABLE Provincia DROP CONSTRAINT FK_Provincia_Usuario 
go


ALTER TABLE Direccion DROP CONSTRAINT FK_Direccion_Provincia 
go


DROP INDEX Provincia.IX_ProvinciaCodigo
go


ALTER TABLE Provincia DROP CONSTRAINT PK_Provincia 
go


execute sp_rename Provincia, ProvinciaNA8D2558036
go

      
      /*
      CHANGE REPORT for Table Proyecto
          - change datatype from varchar(50) to varchar(100) of column proy_nombre
          - change datatype from varchar(20) to varchar(15) of column proy_codigo
          WARNING : Load data statement for table Proyecto may fail or data in column proy_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Proyecto
          - Data will be copied to table ProyectoNA8D2558037 ,or table will be renamed ProyectoNA8D2558037..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Proyecto
          - index IX_Alias will be dropped as a side effect. 
          - index PK_Proyecto will be dropped as a side effect. 
          - foreign key FK_Proyecto_Cliente of table Proyecto will be dropped as a side effect. 
          - foreign key FK_Proyecto_Proveedor of table Proyecto will be dropped as a side effect. 
          - foreign key FK__Proyecto__modifi__0D64F3ED of table Proyecto will be dropped as a side effect. 
          - referencing foreign key FK__Tarea__proy_id__10416098 of table Tarea will be dropped as a side effect. 
          - referencing foreign key FK_ProyectoItem_Proyecto of table ProyectoItem will be dropped as a side effect. 
          - referencing foreign key FK_Objetivo_Proyecto of table Objetivo will be dropped as a side effect. 
          - referencing foreign key FK__Hora__proy_id__02E7657A of table Hora will be dropped as a side effect. 
          - view Tarea will be dropped as a side effect. 
          - view ProyectoItem will be dropped as a side effect. 
          - view Objetivo will be dropped as a side effect. 
          - view Hora will be dropped as a side effect. 
      */

ALTER TABLE Proyecto DROP CONSTRAINT FK__Proyecto__modifi__0D64F3ED 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__proy_id__10416098 
go


ALTER TABLE ProyectoItem DROP CONSTRAINT FK_ProyectoItem_Proyecto 
go


DROP INDEX Proyecto.IX_Alias
go


ALTER TABLE Proyecto DROP CONSTRAINT PK_Proyecto 
go


execute sp_rename Proyecto, ProyectoNA8D2558037
go

      
      /*
      CHANGE REPORT for Table ProyectoItem
          - change datatype from varchar(50) to varchar(100) of column proyi_nombre
          - change datatype from varchar(10) to varchar(15) of column proyi_codigo
      ACTION is DROP and CREATE Table ProyectoItem
          - Data will be copied to table ProyectoItemNA8D2558038 ,or table will be renamed ProyectoItemNA8D2558038..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table ProyectoItem
          - index IX_ProyectoItemCodigo will be dropped as a side effect. 
          - index PK_ProyectoItem will be dropped as a side effect. 
          - foreign key FK_ProyectoItem_Proyecto of table ProyectoItem will be dropped as a side effect. 
          - foreign key FK__ProyectoI__modif__0E591826 of table ProyectoItem will be dropped as a side effect. 
          - referencing foreign key FK__Tarea__proyi_id__17E28260 of table Tarea will be dropped as a side effect. 
          - referencing foreign key FK__Hora__proyi_id__06B7F65E of table Hora will be dropped as a side effect. 
          - view Tarea will be dropped as a side effect. 
          - view Hora will be dropped as a side effect. 
      */

ALTER TABLE ProyectoItem DROP CONSTRAINT FK__ProyectoI__modif__0E591826 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__proyi_id__17E28260 
go


DROP INDEX ProyectoItem.IX_ProyectoItemCodigo
go


ALTER TABLE ProyectoItem DROP CONSTRAINT PK_ProyectoItem 
go


execute sp_rename ProyectoItem, ProyectoItemNA8D2558038
go

      
      /*
      CHANGE REPORT for Table Rama
          - change datatype from varchar(50) to varchar(100) of column ram_nombre
      ACTION is DROP and CREATE Table Rama
          - Data will be copied to table RamaNA8D2558039 ,or table will be renamed RamaNA8D2558039..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Rama
          - index PK_Rama will be dropped as a side effect. 
          - foreign key FK_Rama_Arbol of table Rama will be dropped as a side effect. 
          - foreign key FK_Rama_Rama of table Rama will be dropped as a side effect. 
          - foreign key FK_Rama_Usuario of table Rama will be dropped as a side effect. 
          - referencing foreign key FK_Rama_Rama of table Rama will be dropped as a side effect. 
          - referencing foreign key FK_Hoja_Rama of table Hoja will be dropped as a side effect. 
          - view Rama will be dropped as a side effect. 
          - view Hoja will be dropped as a side effect. 
      */

ALTER TABLE Rama DROP CONSTRAINT FK_Rama_Rama 
go


ALTER TABLE Rama DROP CONSTRAINT FK_Rama_Usuario 
go


ALTER TABLE Hoja DROP CONSTRAINT FK_Hoja_Rama 
go


ALTER TABLE Rama DROP CONSTRAINT PK_Rama 
go


execute sp_rename Rama, RamaNA8D2558039
go

      
      /*
      CHANGE REPORT for Table ReglaLiquidacion
          - change datatype from varchar(50) to varchar(100) of column rel_nombre
          - change datatype from varchar(10) to varchar(15) of column rel_codigo
      ACTION is DROP and CREATE Table ReglaLiquidacion
          - Data will be copied to table ReglaLiquidacionNA8D2558040 ,or table will be renamed ReglaLiquidacionNA8D2558040..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table ReglaLiquidacion
          - index IX_ReglaLiquidacionCodigo will be dropped as a side effect. 
          - index PK__ReglaLiquidacion__53385258 will be dropped as a side effect. 
          - referencing foreign key FK__Cobrador__rel_id__19CACAD2 of table Cobrador will be dropped as a side effect. 
          - view Cobrador will be dropped as a side effect. 
      */

DROP INDEX ReglaLiquidacion.IX_ReglaLiquidacionCodigo
go


ALTER TABLE ReglaLiquidacion DROP CONSTRAINT PK__ReglaLiquidacion__53385258 
go


execute sp_rename ReglaLiquidacion, ReglaLiquidacionNA8D2558040
go

      
      /*
      CHANGE REPORT for Table Rol
          - change datatype from varchar(50) to varchar(100) of column rol_nombre
      ACTION is DROP and CREATE Table Rol
          - Data will be copied to table RolNA8D2558041 ,or table will be renamed RolNA8D2558041..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Rol
          - index IX_RolNombre will be dropped as a side effect. 
          - index PK_Rol will be dropped as a side effect. 
          - foreign key FK_Rol_Usuario of table Rol will be dropped as a side effect. 
          - referencing foreign key FK_UsuarioRol_Rol of table UsuarioRol will be dropped as a side effect. 
          - view UsuarioRol will be dropped as a side effect. 
      */

ALTER TABLE Rol DROP CONSTRAINT FK_Rol_Usuario 
go


ALTER TABLE UsuarioRol DROP CONSTRAINT FK_UsuarioRol_Rol 
go


DROP INDEX Rol.IX_RolNombre
go


ALTER TABLE Rol DROP CONSTRAINT PK_Rol 
go


execute sp_rename Rol, RolNA8D2558041
go

      
      /*
      CHANGE REPORT for Table Rubro
          - change datatype from varchar(20) to varchar(15) of column rub_codigo
          WARNING : Load data statement for table Rubro may fail or data in column rub_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Rubro
          - Data will be copied to table RubroNA8D2558042 ,or table will be renamed RubroNA8D2558042..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Rubro
          - index IX_RubroCodigo will be dropped as a side effect. 
          - index PK_Rubro will be dropped as a side effect. 
          - foreign key FK_Rubro_Usuario of table Rubro will be dropped as a side effect. 
          - referencing foreign key FK_Producto_Rubro of table Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
      */

ALTER TABLE Rubro DROP CONSTRAINT FK_Rubro_Usuario 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_Rubro 
go


DROP INDEX Rubro.IX_RubroCodigo
go


ALTER TABLE Rubro DROP CONSTRAINT PK_Rubro 
go


execute sp_rename Rubro, RubroNA8D2558042
go

      
      /*
      CHANGE REPORT for Table Tabla
          - change datatype from varchar(50) to varchar(100) of column tbl_nombre
          - Changing definition of index PK_Tabla
      ACTION is DROP and CREATE Table Tabla
          - Data will be copied to table TablaNA8D2558043 ,or table will be renamed TablaNA8D2558043..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Tabla
          - index PK_Tabla will be dropped as a side effect. 
          - referencing foreign key FK__Historia__tbl_id__000AF8CF of table Historia will be dropped as a side effect. 
          - referencing foreign key FK_Arbol_Tabla of table Arbol will be dropped as a side effect. 
          - view Historia will be dropped as a side effect. 
          - view Arbol will be dropped as a side effect. 
      */

ALTER TABLE Historia DROP CONSTRAINT FK__Historia__tbl_id__000AF8CF 
go


ALTER TABLE Tabla DROP CONSTRAINT PK_Tabla 
go


execute sp_rename Tabla, TablaNA8D2558043
go

      
      /*
      CHANGE REPORT for Table Tarea
          - change datatype from varchar(50) to varchar(100) of column tar_nombre
      ACTION is DROP and CREATE Table Tarea
          - Data will be copied to table TareaNA8D2558044 ,or table will be renamed TareaNA8D2558044..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Tarea
          - index PK__Tarea__5708E33C will be dropped as a side effect. 
          - foreign key FK__Tarea__cli_id__16EE5E27 of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__cont_id__1229A90A of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__obje_id__131DCD43 of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__prio_id__113584D1 of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__proy_id__10416098 of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__proyi_id__17E28260 of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__tarest_id__0F4D3C5F of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__us_id_asi__1411F17C of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__us_id_res__150615B5 of table Tarea will be dropped as a side effect. 
          - foreign key FK__Tarea__modifico__15FA39EE of table Tarea will be dropped as a side effect. 
          - referencing foreign key FK__Hora__tar_id__01F34141 of table Hora will be dropped as a side effect. 
          - view Hora will be dropped as a side effect. 
      */

ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__cont_id__1229A90A 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__tarest_id__0F4D3C5F 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__us_id_asi__1411F17C 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__us_id_res__150615B5 
go


ALTER TABLE Tarea DROP CONSTRAINT FK__Tarea__modifico__15FA39EE 
go


ALTER TABLE Tarea DROP CONSTRAINT PK__Tarea__5708E33C 
go


execute sp_rename Tarea, TareaNA8D2558044
go

      
      /*
      CHANGE REPORT for Table TareaEstado
          - change datatype from varchar(50) to varchar(100) of column tarest_nombre
      ACTION is DROP and CREATE Table TareaEstado
          - Data will be copied to table TareaEstadoNA8D2558045 ,or table will be renamed TareaEstadoNA8D2558045..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table TareaEstado
          - index PK_TareaEstado will be dropped as a side effect. 
          - foreign key FK_TareaEstado_Usuario of table TareaEstado will be dropped as a side effect. 
          - referencing foreign key FK__Tarea__tarest_id__0F4D3C5F of table Tarea will be dropped as a side effect. 
          - view Tarea will be dropped as a side effect. 
      */

ALTER TABLE TareaEstado DROP CONSTRAINT FK_TareaEstado_Usuario 
go


ALTER TABLE TareaEstado DROP CONSTRAINT PK_TareaEstado 
go


execute sp_rename TareaEstado, TareaEstadoNA8D2558045
go

      
      /*
      CHANGE REPORT for Table TarjetaCredito
          - change datatype from varchar(50) to varchar(100) of column tjc_nombre
          - change datatype from varchar(10) to varchar(15) of column tjc_codigo
      ACTION is DROP and CREATE Table TarjetaCredito
          - Data will be copied to table TarjetaCreditoNA8D2558046 ,or table will be renamed TarjetaCreditoNA8D2558046..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table TarjetaCredito
          - index IX_TarjetaCreditoCodigo will be dropped as a side effect. 
          - index PK__TarjetaCredito__57FD0775 will be dropped as a side effect. 
          - foreign key FK_TarjetaCredito_Usuario of table TarjetaCredito will be dropped as a side effect. 
      */

ALTER TABLE TarjetaCredito DROP CONSTRAINT FK_TarjetaCredito_Usuario 
go


DROP INDEX TarjetaCredito.IX_TarjetaCreditoCodigo
go


ALTER TABLE TarjetaCredito DROP CONSTRAINT PK__TarjetaCredito__57FD0775 
go


execute sp_rename TarjetaCredito, TarjetaCreditoNA8D2558046
go

      
      /*
      CHANGE REPORT for Table TasaImpositiva
          - change datatype from varchar(50) to varchar(100) of column ti_nombre
          - Adding column ti_codigodgi1
          - Adding column ti_codigodgi2
      ACTION is DROP and CREATE Table TasaImpositiva
          - Data will be copied to table TasaImpositivaNA8D2558047 ,or table will be renamed TasaImpositivaNA8D2558047..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table TasaImpositiva
          - index IX_TasaImpositivaCodigo will be dropped as a side effect. 
          - index PK_TasaImpositiva will be dropped as a side effect. 
          - foreign key FK_TasaImpositiva_Usuario of table TasaImpositiva will be dropped as a side effect. 
          - referencing foreign key FK_Producto_TIRICompra of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_TIRNIVenta of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_TasaImpositiva of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_TasaImpositiva2 of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_TasaImpositiva1 of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_TasaImpositiva3 of table Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
      */

ALTER TABLE TasaImpositiva DROP CONSTRAINT FK_TasaImpositiva_Usuario 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_TIRICompra 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_TIRNIVenta 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_TasaImpositiva 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_TasaImpositiva2 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_TasaImpositiva1 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_TasaImpositiva3 
go


DROP INDEX TasaImpositiva.IX_TasaImpositivaCodigo
go


ALTER TABLE TasaImpositiva DROP CONSTRAINT PK_TasaImpositiva 
go


execute sp_rename TasaImpositiva, TasaImpositivaNA8D2558047
go

      
      /*
      CHANGE REPORT for Table Transporte
          - change datatype from varchar(50) to varchar(100) of column trans_nombre
          - change datatype from varchar(50) to varchar(15) of column trans_codigo
          WARNING : Load data statement for table Transporte may fail or data in column trans_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
          - change datatype from varchar(50) to varchar(100) of column trans_chofer
      ACTION is DROP and CREATE Table Transporte
          - Data will be copied to table TransporteNA8D2558048 ,or table will be renamed TransporteNA8D2558048..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Transporte
          - index IX_TransporteCodigo will be dropped as a side effect. 
          - index PK__Transporte__379037E3 will be dropped as a side effect. 
      */

DROP INDEX Transporte.IX_TransporteCodigo
go


ALTER TABLE Transporte DROP CONSTRAINT PK__Transporte__379037E3 
go


execute sp_rename Transporte, TransporteNA8D2558048
go

      
      /*
      CHANGE REPORT for Table Unidad
          - change datatype from varchar(50) to varchar(100) of column un_nombre
          - change datatype from varchar(20) to varchar(15) of column un_codigo
          WARNING : Load data statement for table Unidad may fail or data in column un_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Unidad
          - Data will be copied to table UnidadNA8D2558049 ,or table will be renamed UnidadNA8D2558049..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Unidad
          - index IX_UnidadCodigo will be dropped as a side effect. 
          - index PK_Unidad will be dropped as a side effect. 
          - foreign key FK_Unidad_Usuario of table Unidad will be dropped as a side effect. 
          - referencing foreign key FK_Producto_UnStock of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_UnVenta of table Producto will be dropped as a side effect. 
          - referencing foreign key FK_Producto_UnCompra of table Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
          - view Producto will be dropped as a side effect. 
      */

ALTER TABLE Unidad DROP CONSTRAINT FK_Unidad_Usuario 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_UnStock 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_UnVenta 
go


ALTER TABLE Producto DROP CONSTRAINT FK_Producto_UnCompra 
go


DROP INDEX Unidad.IX_UnidadCodigo
go


ALTER TABLE Unidad DROP CONSTRAINT PK_Unidad 
go


execute sp_rename Unidad, UnidadNA8D2558049
go

      
      /*
      CHANGE REPORT for Table Vendedor
          - change datatype from varchar(50) to varchar(100) of column ven_nombre
          - change datatype from varchar(10) to varchar(15) of column ven_codigo
      ACTION is DROP and CREATE Table Vendedor
          - Data will be copied to table VendedorNA8D2558050 ,or table will be renamed VendedorNA8D2558050..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Vendedor
          - index IX_VendedorCodigo will be dropped as a side effect. 
          - index PK__Vendedor__58F12BAE will be dropped as a side effect. 
          - foreign key FK_Vendedores_Usuario of table Vendedor will be dropped as a side effect. 
      */

ALTER TABLE Vendedor DROP CONSTRAINT FK_Vendedores_Usuario 
go


DROP INDEX Vendedor.IX_VendedorCodigo
go


ALTER TABLE Vendedor DROP CONSTRAINT PK__Vendedor__58F12BAE 
go


execute sp_rename Vendedor, VendedorNA8D2558050
go

      
      /*
      CHANGE REPORT for Table Zona
          - change datatype from varchar(50) to varchar(100) of column zon_nombre
          - Adding column zon_descrip
          - change datatype from varchar(30) to varchar(15) of column zon_codigo
          WARNING : Load data statement for table Zona may fail or data in column zon_codigo may be lost (existing data may violate the new datatype rules: converting to a shorter or incompatible datatype).
      ACTION is DROP and CREATE Table Zona
          - Data will be copied to table ZonaNA8D2558051 ,or table will be renamed ZonaNA8D2558051..
          - Temp table will be dropped if load data statement is successful.
      IMPACT ANALYSIS REPORT for DROP and CREATE Table Zona
          - index IX_ZonaCodigo will be dropped as a side effect. 
          - index PK_Zona will be dropped as a side effect. 
          - foreign key FK_Zona_Usuario of table Zona will be dropped as a side effect. 
          - referencing foreign key FK_Proveedor_Zona of table Proveedor will be dropped as a side effect. 
          - referencing foreign key FK__Cliente__zon_id__10766AC2 of table Cliente will be dropped as a side effect. 
          - view Proveedor will be dropped as a side effect. 
          - view Cliente will be dropped as a side effect. 
      */

ALTER TABLE Zona DROP CONSTRAINT FK_Zona_Usuario 
go


DROP INDEX Zona.IX_ZonaCodigo
go


ALTER TABLE Zona DROP CONSTRAINT PK_Zona 
go


execute sp_rename Zona, ZonaNA8D2558051
go

      
      /*
      ACTION is CREATE Table AFIPEsquema
      */

CREATE TABLE AFIPEsquema (
       afesq_id             int NOT NULL,
       afesq_nombre         varchar(100) NOT NULL,
       afesq_codigo         varchar(15) NOT NULL,
       afesq_descrip        varchar(255) NOT NULL,
       afesq_objetodll      varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_AFIPEsquemaCodigo ON AFIPEsquema
(
       afesq_codigo
)
go


ALTER TABLE AFIPEsquema
       ADD PRIMARY KEY (afesq_id)
go

      
      /*
      ACTION is CREATE Table AFIPArchivo
      */

CREATE TABLE AFIPArchivo (
       afarch_id            int NOT NULL,
       afarch_nombre        varchar(100) NOT NULL,
       afarch_descrip       varchar(255) NOT NULL,
       afarch_separadorRegistro varchar(5) NOT NULL,
       afarch_objetoentrada varchar(255) NOT NULL,
       afesq_id             int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE AFIPArchivo
       ADD PRIMARY KEY (afarch_id)
go

      
      /*
      ACTION is CREATE Table AFIPRegistro
      */

CREATE TABLE AFIPRegistro (
       afreg_id             int NOT NULL,
       afreg_nombre         varchar(100) NOT NULL,
       afreg_descrip        varchar(255) NOT NULL,
       afreg_objetoproceso  varchar(255) NOT NULL,
       afarch_id            int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE AFIPRegistro
       ADD PRIMARY KEY (afreg_id)
go

      
      /*
      ACTION is CREATE Table AFIPCampo
      */

CREATE TABLE AFIPCampo (
       afcampo_id           int NOT NULL,
       afcampo_nombre       varchar(255) NOT NULL,
       afcampo_descrip      varchar(255) NOT NULL,
       afcampo_formatoFecha varchar(50) NOT NULL,
       afcampo_tipo         tinyint NOT NULL,
       afcampo_posicion     smallint NOT NULL,
       afcampo_relleno      varchar(1) NOT NULL,
       afcampo_separadorDecimal varchar(1) NOT NULL,
       afcampo_cantDigitosEnteros tinyint NOT NULL,
       afcampo_cantDigitosDecimales tinyint NOT NULL,
       afcampo_largo        smallint NOT NULL,
       afcampo_alineacion   tinyint NOT NULL,
       afcampo_columna      varchar(100) NOT NULL,
       afreg_id             int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE AFIPCampo
       ADD PRIMARY KEY (afcampo_id)
go

      
      /*
      ACTION is CREATE Table AFIPParametro
      */

CREATE TABLE AFIPParametro (
       afparam_id           int NOT NULL,
       afparam_nombre       varchar(100) NOT NULL,
       afparam_descrip      varchar(255) NOT NULL,
       afparam_tipo         tinyint NOT NULL,
       afparam_subTipo      tinyint NOT NULL,
       afparam_tablaHelp    int NOT NULL,
       afparam_valor        varchar(5000) NOT NULL,
       afparam_avanzado     tinyint NOT NULL,
       afesq_id             int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE AFIPParametro
       ADD PRIMARY KEY (afparam_id)
go

      
      /*
      ACTION is CREATE Table Calidad
      */

CREATE TABLE Calidad (
       calid_id             int NOT NULL,
       calid_nombre         varchar(100) NOT NULL,
       calid_codigo         varchar(15) NOT NULL,
       calid_descrip        varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_CalidadCodigo ON Calidad
(
       calid_codigo
)
go


ALTER TABLE Calidad
       ADD PRIMARY KEY (calid_id)
go

      
      /*
      ACTION is CREATE Table Camion
      */

CREATE TABLE Camion (
       cam_id               int NOT NULL,
       cam_nombre           varchar(100) NOT NULL,
       cam_codigo           varchar(15) NOT NULL,
       cam_descrip          varchar(255) NOT NULL,
       cam_patente          varchar(20) NOT NULL,
       cam_patentesemi      varchar(20) NOT NULL,
       cam_tara             int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_Camion ON Camion
(
       cam_codigo
)
go


ALTER TABLE Camion
       ADD PRIMARY KEY (cam_id)
go

      
      /*
      ACTION is CREATE Table Chofer
      */

CREATE TABLE Chofer (
       chof_id              int NOT NULL,
       chof_nombre          varchar(100) NOT NULL,
       chof_codigo          varchar(15) NOT NULL,
       chof_descrip         varchar(255) NOT NULL,
       chof_tipodni         varchar(10) NOT NULL,
       chof_dni             int NOT NULL,
       chof_fechadenacimiento datetime NOT NULL,
       chof_direccion       varchar(255) NOT NULL,
       chof_telefono        varchar(50) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ChoferCodigo ON Chofer
(
       chof_codigo
)
go


ALTER TABLE Chofer
       ADD PRIMARY KEY (chof_id)
go

      
      /*
      ACTION is CREATE Table InformeParametro
      */

CREATE TABLE InformeParametro (
       infp_id              int NOT NULL,
       infp_nombre          varchar(255) NOT NULL,
       infp_orden           tinyint NOT NULL,
       infp_tipo            tinyint NOT NULL,
       infp_default         varchar(500) NOT NULL,
       infp_visible         tinyint NOT NULL,
       infp_sqlstmt         varchar(2000) NOT NULL,
       inf_id               int NOT NULL,
       tbl_id               int NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_InformeParametroNombre ON InformeParametro
(
       inf_id,
       infp_nombre
)
go


ALTER TABLE InformeParametro
       ADD PRIMARY KEY (infp_id)
go

      
      /*
      ACTION is CREATE Table InformePermiso
      */

CREATE TABLE InformePermiso (
       infper_id            int NOT NULL,
       us_id                int NULL,
       rol_id               int NULL,
       inf_id               int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go


ALTER TABLE InformePermiso
       ADD PRIMARY KEY (infper_id)
go

      
      /*
      ACTION is CREATE Table Reporte
      */

CREATE TABLE Reporte (
       rpt_id               int NOT NULL,
       rpt_nombre           varchar(100) NOT NULL,
       rpt_descrip          varchar(1000) NOT NULL,
       inf_id               int NOT NULL,
       us_id                int NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE Reporte
       ADD PRIMARY KEY (rpt_id)
go

      
      /*
      ACTION is CREATE Table ReporteParametro
      */

CREATE TABLE ReporteParametro (
       rptp_id              int NOT NULL,
       rptp_valor           varchar(255) NOT NULL,
       rptp_visible         tinyint NOT NULL,
       rpt_id               int NOT NULL,
       infp_id              int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go


ALTER TABLE ReporteParametro
       ADD PRIMARY KEY (rptp_id)
go


CREATE TABLE Arbol (
       arb_id               int NOT NULL,
       arb_nombre           varchar(100) NOT NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       tbl_Id               int NOT NULL,
       modifico             int NOT NULL
)
go


ALTER TABLE Arbol
       ADD PRIMARY KEY NONCLUSTERED (arb_id)
go


CREATE TABLE Banco (
       bco_id               int NOT NULL,
       bco_nombre           varchar(100) NOT NULL,
       bco_codigo           varchar(15) NOT NULL,
       bco_contacto         varchar(500) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       bco_telefono         varchar(255) NOT NULL,
       bco_direccion        varchar(255) NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL,
       bco_web              varchar(255) NOT NULL,
       bco_mail             varchar(255) NOT NULL
)
go

CREATE UNIQUE INDEX IX_BancoCodigo ON Banco
(
       bco_codigo
)
go


ALTER TABLE Banco
       ADD PRIMARY KEY (bco_id)
go


CREATE TABLE CDRom (
       cd_id                int NOT NULL,
       cd_codigo            varchar(15) NOT NULL,
       cd_nombre            varchar(100) NOT NULL,
       cd_descrip           varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_CDRomCodigo ON CDRom
(
       cd_codigo
)
go


ALTER TABLE CDRom
       ADD PRIMARY KEY (cd_id)
go


CREATE TABLE CDRomArchivo (
       cda_id               int NOT NULL,
       cda_nombre           varchar(255) NOT NULL,
       cda_tipo             varchar(50) NOT NULL,
       cda_path             varchar(500) NOT NULL,
       cd_id                int NOT NULL,
       cdc_id               int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE CDRomArchivo
       ADD PRIMARY KEY (cda_id)
go


CREATE TABLE CentroCosto (
       ccos_id              int NOT NULL,
       ccos_nombre          varchar(100) NOT NULL,
       ccos_codigo          varchar(15) NOT NULL,
       ccos_descrip         varchar(255) NOT NULL,
       ccos_compra          smallint NOT NULL,
       ccos_venta           smallint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_CentroCostoCodigo ON CentroCosto
(
       ccos_codigo
)
go


ALTER TABLE CentroCosto
       ADD PRIMARY KEY (ccos_id)
go


CREATE TABLE Chequera (
       chq_id               int NOT NULL,
       cue_id               int NOT NULL,
       chq_nombre           varchar(50) NOT NULL,
       chq_codigo           varchar(100) NOT NULL,
       chq_descrip          varchar(255) NOT NULL,
       chq_numerodesde      int NOT NULL,
       chq_numerohasta      int NOT NULL,
       chq_ultimonumero     int NOT NULL,
       chq_default          int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ChequeraCodigo ON Chequera
(
       chq_codigo
)
go


ALTER TABLE Chequera
       ADD PRIMARY KEY (chq_id)
go


CREATE TABLE Ciudad (
       ciu_id               int NOT NULL,
       ciu_nombre           varchar(100) NOT NULL,
       ciu_codigo           varchar(15) NOT NULL,
       ciu_descrip          varchar(255) NOT NULL,
       pro_id               int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_Ciudad_codigo ON Ciudad
(
       ciu_codigo
)
go


ALTER TABLE Ciudad
       ADD PRIMARY KEY (ciu_id)
go


CREATE TABLE Clearing (
       cle_id               int NOT NULL,
       cle_nombre           varchar(100) NOT NULL,
       cle_codigo           varchar(15) NOT NULL,
       cle_descrip          varchar(255) NOT NULL,
       cle_dias             int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ClearingCodigo ON Clearing
(
       cle_codigo
)
go


ALTER TABLE Clearing
       ADD PRIMARY KEY (cle_id)
go


CREATE TABLE Cliente (
       cli_id               int NOT NULL,
       cli_nombre           varchar(255) NOT NULL,
       cli_codigo           varchar(15) NOT NULL,
       cli_contacto         varchar(100) NOT NULL,
       cli_descrip          varchar(255) NOT NULL,
       cli_razonsocial      varchar(255) NOT NULL,
       cli_cuit             varchar(13) NOT NULL,
       cli_ingresosbrutos   varchar(20) NOT NULL,
       cli_catfiscal        smallint NOT NULL,
       cli_chequeorden      varchar(100) NOT NULL,
       cli_codpostal        varchar(50) NOT NULL,
       cli_localidad        varchar(100) NOT NULL,
       cli_calle            varchar(100) NOT NULL,
       cli_callenumero      varchar(10) NOT NULL,
       cli_piso             varchar(4) NOT NULL,
       cli_depto            varchar(4) NOT NULL,
       cli_tel              varchar(100) NOT NULL,
       cli_fax              varchar(50) NOT NULL,
       cli_email            varchar(100) NOT NULL,
       cli_web              varchar(100) NOT NULL,
       pro_id               int NULL,
       zon_id               int NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ClienteCodigo ON Cliente
(
       cli_codigo
)
go


ALTER TABLE Cliente
       ADD PRIMARY KEY (cli_id)
go


CREATE TABLE ClienteSucursal (
       clis_id              int NOT NULL,
       clis_nombre          varchar(100) NOT NULL,
       clis_codigo          varchar(15) NOT NULL,
       cli_id               int NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_ClienteSucursalCodigo ON ClienteSucursal
(
       clis_codigo
)
go


ALTER TABLE ClienteSucursal
       ADD PRIMARY KEY (clis_id)
go


CREATE TABLE Cobrador (
       cob_id               int NOT NULL,
       rel_id               int NOT NULL,
       cob_nombre           varchar(100) NOT NULL,
       cob_codigo           varchar(15) NOT NULL,
       cob_descrip          varchar(255) NOT NULL,
       cob_comision         real NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_CobradorCodigo ON Cobrador
(
       cob_codigo
)
go


ALTER TABLE Cobrador
       ADD PRIMARY KEY (cob_id)
go


CREATE TABLE Cuenta (
       cue_id               int NOT NULL,
       cuec_id              int NOT NULL,
       cuec_id_libroiva     int NULL,
       cue_descrip          varchar(255) NOT NULL,
       cue_nombre           varchar(100) NOT NULL,
       cue_codigo           varchar(15) NOT NULL,
       cue_identificacionexterna varchar(50) NOT NULL,
       cue_llevacentrocosto tinyint NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_CuentaCodigo ON Cuenta
(
       cue_codigo
)
go


ALTER TABLE Cuenta
       ADD PRIMARY KEY (cue_id)
go


CREATE TABLE CuentaCategoria (
       cuec_id              int NOT NULL,
       cuec_nombre          varchar(100) NOT NULL,
       cuec_codigo          varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       cuec_tipo            tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_CuentaCategoriaCodigo ON CuentaCategoria
(
       cuec_codigo
)
go


ALTER TABLE CuentaCategoria
       ADD PRIMARY KEY (cuec_id)
go


CREATE TABLE CuentaUso (
       cueu_id              int NOT NULL,
       cue_id               int NOT NULL,
       cueu_codigo          varchar(15) NOT NULL,
       cueu_nombre          varchar(100) NOT NULL,
       cueu_descrip         varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL,
       prov_id              int NULL,
       cli_id               int NULL
)
go

CREATE UNIQUE INDEX IX_CuentaUsoCodigo ON CuentaUso
(
       cueu_codigo
)
go


ALTER TABLE CuentaUso
       ADD PRIMARY KEY (cueu_id)
go


CREATE TABLE DepositoFisico (
       depf_id              int NOT NULL,
       depf_nombre          varchar(100) NOT NULL,
       depf_codigo          varchar(30) NOT NULL,
       depf_descrip         varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_DepositoFisicoCodigo ON DepositoFisico
(
       depf_codigo
)
go


ALTER TABLE DepositoFisico
       ADD PRIMARY KEY NONCLUSTERED (depf_id)
go


CREATE TABLE DepositoLogico (
       depl_id              int NOT NULL,
       depf_id              int NOT NULL,
       depl_nombre          varchar(100) NOT NULL,
       depl_codigo          varchar(30) NOT NULL,
       depl_descrip         varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_DepositoLogicoCodigo ON DepositoLogico
(
       depl_codigo
)
go


ALTER TABLE DepositoLogico
       ADD PRIMARY KEY NONCLUSTERED (depl_id)
go


CREATE TABLE Documento (
       doc_id               int NOT NULL,
       doc_nombre           varchar(100) NOT NULL,
       doc_codigo           varchar(15) NOT NULL,
       doc_descrip          varchar(5000) NOT NULL,
       doct_id              int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_DocumentoCodigo ON Documento
(
       doc_codigo
)
go


ALTER TABLE Documento
       ADD PRIMARY KEY (doc_id)
go


CREATE TABLE DocumentoTipo (
       doct_id              int NOT NULL,
       doct_nombre          varchar(100) NOT NULL,
       doct_codigo          varchar(15) NOT NULL,
       doct_grupo           varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_DocumentoTipoCodigo ON DocumentoTipo
(
       doct_codigo
)
go


ALTER TABLE DocumentoTipo
       ADD PRIMARY KEY (doct_id)
go


CREATE TABLE Escala (
       esc_id               int NOT NULL,
       esc_nombre           varchar(100) NOT NULL,
       esc_codigo           varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_EscalaCodigo ON Escala
(
       esc_codigo
)
go


ALTER TABLE Escala
       ADD PRIMARY KEY (esc_id)
go


CREATE TABLE Estado (
       est_id               int NOT NULL,
       est_nombre           char(100) NOT NULL,
       est_codigo           char(15) NOT NULL,
       est_descrip          char(100) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_EstadoCodigo ON Estado
(
       est_codigo
)
go


ALTER TABLE Estado
       ADD PRIMARY KEY (est_id)
go


CREATE TABLE FechaControlAcceso (
       fca_id               int NOT NULL,
       fca_nombre           varchar(100) NOT NULL,
       fca_codigo           varchar(15) NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       fca_fecha            datetime NOT NULL
)
go

CREATE UNIQUE INDEX IX_FechaControlAccesoCodigo ON FechaControlAcceso
(
       fca_codigo
)
go


ALTER TABLE FechaControlAcceso
       ADD PRIMARY KEY (fca_id)
go


CREATE TABLE FeriadoBancario (
       fb_id                int NOT NULL,
       fb_nombre            varchar(100) NOT NULL,
       fb_codigo            varchar(15) NOT NULL,
       fb_descrip           varchar(100) NOT NULL,
       fb_fecha             datetime NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_FeriadoBancarioCodigo ON FeriadoBancario
(
       fb_codigo
)
go


ALTER TABLE FeriadoBancario
       ADD PRIMARY KEY (fb_id)
go

      
      /*
      ACTION is NO action to Table Hoja
      */

CREATE TABLE Hora (
       hora_id              int NOT NULL,
       hora_titulo          varchar(255) NOT NULL,
       hora_descrip         varchar(1000) NOT NULL,
       hora_fecha           datetime NOT NULL,
       hora_desde           datetime NOT NULL,
       hora_hasta           datetime NOT NULL,
       hora_horas           smallint NOT NULL,
       hora_minutos         smallint NOT NULL,
       hora_facturable      smallint NOT NULL,
       cli_id               int NOT NULL,
       proy_id              int NOT NULL,
       proyi_id             int NOT NULL,
       obje_id              int NOT NULL,
       us_id                int NOT NULL,
       tar_id               int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go


ALTER TABLE Hora
       ADD PRIMARY KEY (hora_id)
go


CREATE TABLE Informe (
       inf_id               int NOT NULL,
       inf_nombre           varchar(100) NOT NULL,
       inf_codigo           varchar(15) NOT NULL,
       inf_descrip          varchar(1000) NULL,
       inf_storedprocedure  varchar(50) NOT NULL,
       inf_reporte          varchar(255) NOT NULL,
       inf_presentaciondefault tinyint NOT NULL,
       inf_modulo           varchar(255) NOT NULL,
       inf_tipo             tinyint NOT NULL,
       inf_propietario      tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_informeCodigo ON Informe
(
       inf_codigo
)
go


ALTER TABLE Informe
       ADD PRIMARY KEY (inf_id)
go


CREATE TABLE IngresosBrutosCategoria (
       ibc_id               int NOT NULL,
       ibc_nombre           varchar(100) NOT NULL,
       ibc_codigo           varchar(15) NOT NULL,
       ibc_descrip          varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_IngresosBrutosCategoriaCodigo ON IngresosBrutosCategoria
(
       ibc_codigo
)
go


ALTER TABLE IngresosBrutosCategoria
       ADD PRIMARY KEY (ibc_id)
go


CREATE TABLE Leyenda (
       ley_id               int NOT NULL,
       ley_nombre           varchar(100) NOT NULL,
       ley_codigo           varchar(15) NOT NULL,
       ley_descrip          varchar(255) NOT NULL,
       ley_texto            text NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_LeyendaCodigo ON Leyenda
(
       ley_codigo
)
go


ALTER TABLE Leyenda
       ADD PRIMARY KEY (ley_id)
go


CREATE TABLE ListaDescuento (
       ld_id                int NOT NULL,
       ld_nombre            varchar(100) NOT NULL,
       ld_codigo            varchar(50) NOT NULL,
       ld_descrip           varchar(5000) NOT NULL,
       ld_id_padre          int NULL,
       ld_fechadesde        datetime NOT NULL,
       ld_fechahasta        datetime NOT NULL,
       ld_porcentaje        decimal(18,6) NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_ListaDescuentoCodigo ON ListaDescuento
(
       ld_codigo
)
go


ALTER TABLE ListaDescuento
       ADD PRIMARY KEY (ld_id)
go

      
      /*
      ACTION is NO action to Table ListaDescuentoItem
      */
      
      /*
      ACTION is NO action to Table ListaDocumentoParametro
      */

CREATE TABLE ListaPrecio (
       lp_id                int NOT NULL,
       lp_nombre            varchar(100) NOT NULL,
       lp_codigo            varchar(15) NOT NULL,
       lp_descrip           varchar(5000) NOT NULL,
       lp_fechadesde        datetime NOT NULL,
       lp_fechahasta        datetime NOT NULL,
       lp_default           smallint NOT NULL,
       lp_id_padre          int NULL,
       lp_porcentaje        decimal(18,6) NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_ListaPrecioCodigo ON ListaPrecio
(
       lp_codigo
)
go


ALTER TABLE ListaPrecio
       ADD PRIMARY KEY (lp_id)
go

      
      /*
      ACTION is NO action to Table ListaPrecioItem
      */

CREATE TABLE Marca (
       marc_id              int NOT NULL,
       marc_nombre          varchar(100) NOT NULL,
       marc_codigo          varchar(15) NOT NULL,
       marc_descrip         varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_MarcaCodigo ON Marca
(
       marc_codigo
)
go


ALTER TABLE Marca
       ADD PRIMARY KEY (marc_id)
go


CREATE TABLE Moneda (
       mon_id               int NOT NULL,
       mon_nombre           varchar(100) NOT NULL,
       mon_codigo           varchar(15) NOT NULL,
       mon_signo            varchar(5) NOT NULL,
       mon_codigodgi1       varchar(10) NOT NULL,
       activo               tinyint NOT NULL,
       modifico             int NOT NULL,
       mon_codigodgi2       varchar(10) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL
)
go

CREATE UNIQUE INDEX IX_MonedaCodigo ON Moneda
(
       mon_codigo
)
go


ALTER TABLE Moneda
       ADD PRIMARY KEY (mon_id)
go


CREATE TABLE Objetivo (
       obje_id              int NOT NULL,
       obje_nombre          varchar(100) NOT NULL,
       obje_codigo          varchar(15) NOT NULL,
       obje_descrip         varchar(255) NOT NULL,
       proy_id              int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ObjetivoCodigo ON Objetivo
(
       obje_codigo,
       proy_id
)
go


ALTER TABLE Objetivo
       ADD PRIMARY KEY (obje_id)
go


CREATE TABLE Pais (
       pa_id                int NOT NULL,
       pa_nombre            varchar(100) NOT NULL,
       pa_codigo            varchar(15) NOT NULL,
       pa_descrip           varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_PaisCodigo ON Pais
(
       pa_codigo
)
go

      
      /*
      ACTION is NO action to Table PedidoVentaItem
      */

CREATE TABLE Percepciones (
       perc_id              int NOT NULL,
       perc_nombre          varchar(100) NOT NULL,
       perc_codigo          varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_PercepcionesCodigo ON Percepciones
(
       perc_codigo
)
go


ALTER TABLE Percepciones
       ADD PRIMARY KEY (perc_id)
go


CREATE TABLE Prestacion (
       pre_id               int NOT NULL,
       pre_nombre           varchar(100) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       pre_grupo            varchar(50) NOT NULL,
       activo               smallint NOT NULL
)
go


ALTER TABLE Prestacion
       ADD PRIMARY KEY (pre_id)
go


CREATE TABLE Prioridad (
       prio_id              int NOT NULL,
       prio_nombre          varchar(100) NOT NULL,
       prio_codigo          varchar(15) NOT NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE Prioridad
       ADD PRIMARY KEY (prio_id)
go


CREATE TABLE Proveedor (
       prov_id              int NOT NULL,
       prov_nombre          varchar(255) NOT NULL,
       prov_codigo          varchar(20) NOT NULL,
       prov_contacto        varchar(30) NOT NULL,
       prov_razonsocial     varchar(255) NOT NULL,
       prov_cuit            varchar(20) NOT NULL,
       prov_ingresosbrutos  varchar(20) NOT NULL,
       prov_catfiscal       smallint NOT NULL,
       prov_chequeorden     varchar(100) NOT NULL,
       prov_codpostal       varchar(50) NOT NULL,
       prov_localidad       varchar(100) NOT NULL,
       prov_calle           varchar(100) NOT NULL,
       prov_callenumero     varchar(10) NOT NULL,
       prov_piso            varchar(4) NOT NULL,
       prov_depto           varchar(4) NOT NULL,
       prov_tel             varchar(100) NOT NULL,
       prov_fax             varchar(50) NOT NULL,
       prov_email           varchar(100) NOT NULL,
       prov_web             varchar(100) NOT NULL,
       pro_id               int NULL,
       zon_id               int NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ProveedorCodigo ON Proveedor
(
       prov_codigo
)
go


ALTER TABLE Proveedor
       ADD PRIMARY KEY (prov_id)
go


CREATE TABLE Provincia (
       pro_id               int NOT NULL,
       pro_nombre           varchar(100) NOT NULL,
       pro_codigo           varchar(15) NOT NULL,
       modificado           datetime NOT NULL,
       pro_descrip          varchar(255) NOT NULL,
       modifico             int NOT NULL,
       pa_id                int NOT NULL,
       creado               datetime NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ProvinciaCodigo ON Provincia
(
       pro_codigo
)
go


ALTER TABLE Provincia
       ADD PRIMARY KEY NONCLUSTERED (pro_id)
go


CREATE TABLE Proyecto (
       proy_id              int NOT NULL,
       proy_nombre          varchar(100) NOT NULL,
       proy_codigo          varchar(15) NOT NULL,
       proy_descrip         varchar(255) NOT NULL,
       proy_desde           datetime NOT NULL,
       proy_hasta           datetime NOT NULL,
       prov_id              int NULL,
       cli_id               int NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       activo               smallint NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_Alias ON Proyecto
(
       proy_codigo
)
go


ALTER TABLE Proyecto
       ADD PRIMARY KEY (proy_id)
go


CREATE TABLE ProyectoItem (
       proyi_id             int NOT NULL,
       proyi_nombre         varchar(100) NOT NULL,
       proyi_codigo         varchar(15) NOT NULL,
       proyi_descrip        varchar(255) NOT NULL,
       proy_id              int NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ProyectoItemCodigo ON ProyectoItem
(
       proyi_codigo,
       proy_id
)
go


ALTER TABLE ProyectoItem
       ADD PRIMARY KEY (proyi_id)
go


CREATE TABLE Rama (
       ram_id               int NOT NULL,
       ram_nombre           varchar(100) NOT NULL,
       arb_id               int NOT NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       modifico             int NOT NULL,
       ram_id_padre         int NOT NULL,
       ram_orden            smallint NOT NULL
)
go


ALTER TABLE Rama
       ADD PRIMARY KEY NONCLUSTERED (ram_id)
go


CREATE TABLE ReglaLiquidacion (
       rel_id               int NOT NULL,
       rel_nombre           varchar(100) NOT NULL,
       rel_codigo           varchar(15) NOT NULL,
       rel_descrip          varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ReglaLiquidacionCodigo ON ReglaLiquidacion
(
       rel_codigo
)
go


ALTER TABLE ReglaLiquidacion
       ADD PRIMARY KEY (rel_id)
go


CREATE TABLE Rol (
       rol_id               int NOT NULL,
       rol_nombre           varchar(100) NOT NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_RolNombre ON Rol
(
       rol_nombre
)
go


ALTER TABLE Rol
       ADD PRIMARY KEY NONCLUSTERED (rol_id)
go


CREATE TABLE Rubro (
       rub_id               int NOT NULL,
       rub_nombre           varchar(100) NOT NULL,
       rub_codigo           varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_RubroCodigo ON Rubro
(
       rub_codigo
)
go


ALTER TABLE Rubro
       ADD PRIMARY KEY (rub_id)
go

      
      /*
      ACTION is NO action to Table sysModulo
      */

CREATE TABLE Tabla (
       tbl_id               int NOT NULL,
       tbl_nombre           varchar(100) NOT NULL,
       tbl_nombrefisico     varchar(50) NOT NULL,
       tbl_campoId          varchar(50) NOT NULL,
       tbl_campocodigo      varchar(50) NOT NULL,
       tbl_sqlHelp          varchar(255) NOT NULL,
       tbl_tieneArbol       smallint NOT NULL,
       tbl_campoNombre      varchar(50) NOT NULL,
       tbl_camposInView     varchar(255) NOT NULL,
       tbl_where            varchar(255) NOT NULL,
       tbl_objectEdit       varchar(255) NOT NULL,
       tbl_objectAbm        varchar(255) NOT NULL
)
go


ALTER TABLE Tabla
       ADD PRIMARY KEY (tbl_id)
go


CREATE TABLE Tarea (
       tar_id               int NOT NULL,
       tar_nombre           varchar(100) NOT NULL,
       tar_descrip          varchar(1000) NOT NULL,
       tar_fechaini         datetime NOT NULL,
       tar_fechafin         datetime NOT NULL,
       tar_alarma           datetime NOT NULL,
       tar_finalizada       tinyint NOT NULL,
       tar_cumplida         tinyint NOT NULL,
       tar_rechazada        tinyint NOT NULL,
       us_id_responsable    int NULL,
       us_id_asignador      int NULL,
       cont_id              int NULL,
       tarest_id            int NULL,
       prio_id              int NULL,
       proy_id              int NOT NULL,
       proyi_id             int NULL,
       obje_id              int NULL,
       cli_id               int NULL,
       modificado           datetime NOT NULL,
       creado               datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE Tarea
       ADD PRIMARY KEY (tar_id)
go


CREATE TABLE TareaEstado (
       tarest_id            int NOT NULL,
       tarest_nombre        varchar(100) NOT NULL,
       tarest_codigo        varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go


ALTER TABLE TareaEstado
       ADD PRIMARY KEY (tarest_id)
go


CREATE TABLE TarjetaCredito (
       tjc_id               int NOT NULL,
       tjc_nombre           varchar(100) NOT NULL,
       tjc_codigo           varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_TarjetaCreditoCodigo ON TarjetaCredito
(
       tjc_codigo
)
go


ALTER TABLE TarjetaCredito
       ADD PRIMARY KEY (tjc_id)
go


CREATE TABLE TasaImpositiva (
       ti_id                int NOT NULL,
       ti_nombre            varchar(100) NOT NULL,
       ti_codigo            varchar(15) NOT NULL,
       ti_porcentaje        money NOT NULL,
       ti_codigodgi1        varchar(10) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       ti_codigodgi2        varchar(10) NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_TasaImpositivaCodigo ON TasaImpositiva
(
       ti_codigo
)
go


ALTER TABLE TasaImpositiva
       ADD PRIMARY KEY NONCLUSTERED (ti_id)
go


CREATE TABLE Transporte (
       trans_id             int NOT NULL,
       trans_nombre         varchar(100) NOT NULL,
       trans_codigo         varchar(15) NOT NULL,
       trans_chofer         varchar(100) NOT NULL,
       trans_telefono       varchar(50) NOT NULL,
       trans_direccion      varchar(50) NOT NULL,
       trans_patente        varchar(20) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_TransporteCodigo ON Transporte
(
       trans_codigo
)
go


ALTER TABLE Transporte
       ADD PRIMARY KEY (trans_id)
go


CREATE TABLE Unidad (
       un_id                int NOT NULL,
       un_nombre            varchar(100) NOT NULL,
       un_codigo            varchar(15) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_UnidadCodigo ON Unidad
(
       un_codigo
)
go


ALTER TABLE Unidad
       ADD PRIMARY KEY NONCLUSTERED (un_id)
go


CREATE TABLE Vendedor (
       ven_id               int NOT NULL,
       ven_nombre           varchar(100) NOT NULL,
       ven_codigo           varchar(15) NOT NULL,
       activo               tinyint NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL
)
go

CREATE UNIQUE INDEX IX_VendedorCodigo ON Vendedor
(
       ven_codigo
)
go


ALTER TABLE Vendedor
       ADD PRIMARY KEY (ven_id)
go


CREATE TABLE Zona (
       zon_id               int NOT NULL,
       zon_nombre           varchar(100) NOT NULL,
       zon_codigo           varchar(15) NOT NULL,
       zon_descrip          varchar(255) NOT NULL,
       creado               datetime NOT NULL,
       modificado           datetime NOT NULL,
       modifico             int NOT NULL,
       activo               tinyint NOT NULL
)
go

CREATE UNIQUE INDEX IX_ZonaCodigo ON Zona
(
       zon_codigo
)
go


ALTER TABLE Zona
       ADD PRIMARY KEY NONCLUSTERED (zon_id)
go


INSERT INTO Arbol (arb_id, arb_nombre, modificado, creado, tbl_Id, modifico) 
    SELECT arb_id, arb_nombre, modificado, creado, tbl_Id, modifico FROM 
    ArbolNA8D2558000 

go


DROP TABLE ArbolNA8D2558000
go


INSERT INTO Banco (bco_id, bco_nombre, bco_codigo, creado, bco_contacto, 
    modificado, bco_telefono, modifico, bco_direccion, bco_web, activo, 
    bco_mail) SELECT bco_id, bco_nombre, bco_codigo, creado, bco_contacto, 
    modificado, bco_telefono, modifico, bco_direccion, bco_web, activo, 
    bco_mail FROM BancoNA8D2558001 

go


DROP TABLE BancoNA8D2558001
go


INSERT INTO CDRom (cd_id, cd_codigo, cd_nombre, cd_descrip, creado, modificado, 
    modifico, activo) SELECT cd_id, cd_codigo, cd_nombre, cd_descrip, creado, 
    modificado, modifico, activo FROM CDRomNA8D2558002 

go


DROP TABLE CDRomNA8D2558002
go


INSERT INTO CDRomArchivo (cda_id, cda_nombre, cda_tipo, cda_path, cd_id, cdc_id,
     creado, modificado, modifico, activo) SELECT cda_id, cda_nombre, cda_tipo, 
    cda_path, cd_id, cdc_id, creado, modificado, modifico, activo FROM 
    CDRomArchivoNA8D2558003 

go


DROP TABLE CDRomArchivoNA8D2558003
go


INSERT INTO CentroCosto (ccos_id, ccos_nombre, ccos_codigo, ccos_descrip, 
    ccos_compra, ccos_venta, creado, modificado, modifico, activo) SELECT 
    ccos_id, ccos_nombre, ccos_codigo, ccos_descrip, ccos_compra, ccos_venta, 
    creado, modificado, modifico, activo FROM CentroCostoNA8D2558004 

go


DROP TABLE CentroCostoNA8D2558004
go


INSERT INTO Chequera (chq_id, cue_id, chq_nombre, chq_codigo, chq_descrip, 
    chq_numerodesde, chq_numerohasta, chq_ultimonumero, chq_default, creado, 
    modificado, modifico) SELECT chq_id, cue_id, chq_nombre, chq_codigo, 
    chq_descrip, chq_numerodesde, chq_numerohasta, chq_ultimonumero, 
    chq_default, creado, modificado, modifico FROM ChequeraNA8D2558005 

go


DROP TABLE ChequeraNA8D2558005
go


INSERT INTO Ciudad (ciu_id, ciu_nombre, ciu_codigo, ciu_descrip, pro_id, creado,
     modificado, modifico, activo) SELECT ciu_id, ciu_nombre, ciu_codigo, 
    ciu_descrip, pro_id, creado, modificado, modifico, activo FROM 
    CiudadNA8D2558006 

go


DROP TABLE CiudadNA8D2558006
go


INSERT INTO Clearing (cle_id, cle_nombre, cle_codigo, cle_descrip, cle_dias, 
    creado, modificado, modifico, activo) SELECT cle_id, cle_nombre, cle_codigo,
     cle_descrip, cle_dias, creado, modificado, modifico, activo FROM 
    ClearingNA8D2558007 

go


DROP TABLE ClearingNA8D2558007
go


INSERT INTO Cliente (cli_id, cli_nombre, cli_codigo, cli_contacto, cli_descrip, 
    cli_razonsocial, cli_cuit, cli_ingresosbrutos, cli_catfiscal, 
    cli_chequeorden, cli_codpostal, cli_localidad, cli_calle, cli_callenumero, 
    cli_piso, cli_depto, cli_tel, cli_fax, cli_email, cli_web, pro_id, zon_id, 
    creado, modificado, modifico, activo) SELECT cli_id, cli_nombre, cli_codigo,
     cli_contacto, cli_descrip, cli_razonsocial, cli_cuit, cli_ingresosbrutos, 
    cli_catfiscal, cli_chequeorden, cli_codpostal, cli_localidad, cli_calle, 
    cli_callenumero, cli_piso, cli_depto, cli_tel, cli_fax, cli_email, cli_web, 
    pro_id, zon_id, creado, modificado, modifico, activo FROM 
    ClienteNA8D2558008 

go


DROP TABLE ClienteNA8D2558008
go


INSERT INTO ClienteSucursal (clis_id, clis_nombre, clis_codigo, cli_id, activo, 
    creado, modificado, modifico) SELECT clis_id, clis_nombre, clis_codigo, 
    cli_id, activo, creado, modificado, modifico FROM 
    ClienteSucursalNA8D2558009 

go


DROP TABLE ClienteSucursalNA8D2558009
go


INSERT INTO Cobrador (cob_id, rel_id, cob_nombre, cob_codigo, cob_descrip, 
    cob_comision, creado, modificado, modifico, activo) SELECT cob_id, rel_id, 
    cob_nombre, cob_codigo, cob_descrip, cob_comision, creado, modificado, 
    modifico, activo FROM CobradorNA8D2558010 

go


DROP TABLE CobradorNA8D2558010
go


INSERT INTO Cuenta (cue_id, cuec_id, cuec_id_libroiva, cue_descrip, cue_nombre, 
    cue_codigo, cue_identificacionexterna, cue_llevacentrocosto, activo, creado,
     modificado, modifico) SELECT cue_id, cuec_id, cuec_id_libroiva, 
    cue_descrip, cue_nombre, cue_codigo, cue_identificacionexterna, 
    cue_llevacentrocosto, activo, creado, modificado, modifico FROM 
    CuentaNA8D2558011 

go


DROP TABLE CuentaNA8D2558011
go


INSERT INTO CuentaCategoria (cuec_id, cuec_nombre, cuec_codigo, creado, 
    modificado, modifico, cuec_tipo) SELECT cuec_id, cuec_nombre, cuec_codigo, 
    creado, modificado, modifico, cuec_tipo FROM CuentaCategoriaNA8D2558012 

go


DROP TABLE CuentaCategoriaNA8D2558012
go


INSERT INTO CuentaUso (cueu_id, cue_id, cueu_codigo, cueu_nombre, cueu_descrip, 
    creado, modificado, modifico, activo, prov_id, cli_id) SELECT cueu_id, 
    cue_id, cueu_codigo, cueu_nombre, cueu_descrip, creado, modificado, 
    modifico, activo, prov_id, cli_id FROM CuentaUsoNA8D2558013 

go


DROP TABLE CuentaUsoNA8D2558013
go


INSERT INTO DepositoFisico (depf_id, depf_nombre, depf_codigo, depf_descrip, 
    creado, modificado, modifico, activo) SELECT depf_id, depf_nombre, 
    depf_codigo, depf_descrip, creado, modificado, modifico, activo FROM 
    DepositoFisicoNA8D2558014 

go


DROP TABLE DepositoFisicoNA8D2558014
go


INSERT INTO DepositoLogico (depl_id, depf_id, depl_nombre, depl_codigo, 
    depl_descrip, creado, modificado, modifico, activo) SELECT depl_id, depf_id,
     depl_nombre, depl_codigo, depl_descrip, creado, modificado, modifico, 
    activo FROM DepositoLogicoNA8D2558015 

go


DROP TABLE DepositoLogicoNA8D2558015
go


INSERT INTO Documento (doc_id, doc_nombre, doc_codigo, doc_descrip, doct_id, 
    creado, modificado, modifico, activo) SELECT doc_id, doc_nombre, doc_codigo,
     doc_descrip, doct_id, creado, modificado, modifico, activo FROM 
    DocumentoNA8D2558016 

go


DROP TABLE DocumentoNA8D2558016
go


INSERT INTO DocumentoTipo (doct_id, doct_nombre, doct_codigo, doct_grupo, 
    creado, modificado, modifico, activo) SELECT doct_id, doct_nombre, 
    doct_codigo, doct_grupo, creado, modificado, modifico, activo FROM 
    DocumentoTipoNA8D2558017 

go


DROP TABLE DocumentoTipoNA8D2558017
go


INSERT INTO Escala (esc_id, esc_nombre, esc_codigo, creado, modificado, 
    modifico, activo) SELECT esc_id, esc_nombre, esc_codigo, creado, modificado,
     modifico, activo FROM EscalaNA8D2558018 

go


DROP TABLE EscalaNA8D2558018
go


INSERT INTO Estado (est_id, est_nombre, est_codigo, est_descrip, creado, 
    modificado, modifico, activo) SELECT est_id, est_nombre, est_codigo, 
    est_descrip, creado, modificado, modifico, activo FROM EstadoNA8D2558019 

go


DROP TABLE EstadoNA8D2558019
go


INSERT INTO FechaControlAcceso (fca_id, fca_nombre, fca_codigo, activo, creado, 
    modificado, modifico, fca_fecha) SELECT fca_id, fca_nombre, fca_codigo, 
    activo, creado, modificado, modifico, fca_fecha FROM 
    FechaControlAccesoNA8D2558020 

go


DROP TABLE FechaControlAccesoNA8D2558020
go


INSERT INTO FeriadoBancario (fb_id, fb_nombre, fb_codigo, fb_descrip, fb_fecha, 
    creado, modificado, modifico) SELECT fb_id, fb_nombre, fb_codigo, 
    fb_descrip, fb_fecha, creado, modificado, modifico FROM 
    FeriadoBancarioNA8D2558021 

go


DROP TABLE FeriadoBancarioNA8D2558021
go


INSERT INTO Hora (hora_id, hora_titulo, hora_descrip, hora_fecha, hora_desde, 
    hora_hasta, hora_horas, hora_minutos, hora_facturable, cli_id, proy_id, 
    proyi_id, obje_id, us_id, tar_id, creado, modificado, modifico) SELECT 
    hora_id, hora_titulo, hora_descrip, hora_fecha, hora_desde, hora_hasta, 
    hora_horas, hora_minutos, hora_facturable, cli_id, proy_id, proyi_id, 
    obje_id, us_id, tar_id, creado, modificado, modifico FROM HoraNA8D2558022 

go


DROP TABLE HoraNA8D2558022
go


INSERT INTO Informe (inf_id, inf_nombre, inf_codigo, inf_descrip, 
    inf_storedprocedure, inf_reporte, inf_presentaciondefault, inf_modulo, 
    inf_tipo, inf_propietario, creado, modificado, modifico, activo) SELECT 
    inf_id, inf_nombre, inf_codigo, inf_descrip, inf_storedprocedure, 
    inf_reporte, inf_presentaciondefault, inf_modulo, inf_tipo, inf_propietario,
     creado, modificado, modifico, activo FROM InformeNA8D2558023 

go


DROP TABLE InformeNA8D2558023
go


INSERT INTO IngresosBrutosCategoria (ibc_id, ibc_nombre, ibc_codigo, 
    ibc_descrip, creado, modificado, modifico) SELECT ibc_id, ibc_nombre, 
    ibc_codigo, ibc_descrip, creado, modificado, modifico FROM 
    IngresosBrutosCategoriaNA8D2558024 

go


DROP TABLE IngresosBrutosCategoriaNA8D2558024
go


INSERT INTO Leyenda (ley_id, ley_nombre, ley_codigo, ley_descrip, ley_texto, 
    activo, creado, modificado, modifico) SELECT ley_id, ley_nombre, ley_codigo,
     ley_descrip, ley_texto, activo, creado, modificado, modifico FROM 
    LeyendaNA8D2558025 

go


DROP TABLE LeyendaNA8D2558025
go


INSERT INTO ListaDescuento (ld_id, ld_nombre, ld_codigo, ld_descrip, 
    ld_id_padre, ld_fechadesde, ld_fechahasta, ld_porcentaje, activo, creado, 
    modificado, modifico) SELECT ld_id, ld_nombre, ld_codigo, ld_descrip, 
    ld_id_padre, ld_fechadesde, ld_fechahasta, ld_porcentaje, activo, creado, 
    modificado, modifico FROM ListaDescuentoNA8D2558026 

go


DROP TABLE ListaDescuentoNA8D2558026
go


INSERT INTO ListaPrecio (lp_id, lp_nombre, lp_codigo, lp_descrip, lp_fechadesde,
     lp_fechahasta, lp_default, lp_id_padre, lp_porcentaje, activo, creado, 
    modificado, modifico) SELECT lp_id, lp_nombre, lp_codigo, lp_descrip, 
    lp_fechadesde, lp_fechahasta, lp_default, lp_id_padre, lp_porcentaje, 
    activo, creado, modificado, modifico FROM ListaPrecioNA8D2558027 

go


DROP TABLE ListaPrecioNA8D2558027
go


INSERT INTO Marca (marc_id, marc_nombre, marc_codigo, marc_descrip, creado, 
    modificado, modifico, activo) SELECT marc_id, marc_nombre, marc_codigo, 
    marc_descrip, creado, modificado, modifico, activo FROM MarcaNA8D2558028 

go


DROP TABLE MarcaNA8D2558028
go


INSERT INTO Moneda (mon_id, mon_nombre, mon_codigo, mon_signo, activo, modifico,
     creado, modificado) SELECT mon_id, mon_nombre, mon_codigo, mon_signo, 
    activo, modifico, creado, modificado FROM MonedaNA8D2558029 

go


DROP TABLE MonedaNA8D2558029
go


INSERT INTO Objetivo (obje_id, obje_nombre, obje_codigo, obje_descrip, proy_id, 
    creado, modificado, modifico, activo) SELECT obje_id, obje_nombre, 
    obje_codigo, obje_descrip, proy_id, creado, modificado, modifico, activo 
    FROM ObjetivoNA8D2558030 

go


DROP TABLE ObjetivoNA8D2558030
go


INSERT INTO Pais (pa_id, pa_nombre, pa_codigo, pa_descrip, creado, modificado, 
    modifico, activo) SELECT pa_id, pa_nombre, pa_codigo, pa_descrip, creado, 
    modificado, modifico, activo FROM PaisNA8D2558031 

go


DROP TABLE PaisNA8D2558031
go


INSERT INTO Percepciones (perc_id, perc_nombre, perc_codigo, creado, modificado,
     modifico, activo) SELECT perc_id, perc_nombre, perc_codigo, creado, 
    modificado, modifico, activo FROM PercepcionesNA8D2558032 

go


DROP TABLE PercepcionesNA8D2558032
go


INSERT INTO Prestacion (pre_id, pre_nombre, creado, modificado, pre_grupo, 
    activo) SELECT pre_id, pre_nombre, creado, modificado, pre_grupo, activo 
    FROM PrestacionNA8D2558033 

go


DROP TABLE PrestacionNA8D2558033
go


INSERT INTO Prioridad (prio_id, prio_nombre, prio_codigo, modificado, creado, 
    modifico, activo) SELECT prio_id, prio_nombre, prio_codigo, modificado, 
    creado, modifico, activo FROM PrioridadNA8D2558034 

go


DROP TABLE PrioridadNA8D2558034
go


INSERT INTO Proveedor (prov_id, prov_nombre, prov_codigo, prov_contacto, 
    prov_razonsocial, prov_cuit, prov_ingresosbrutos, prov_catfiscal, 
    prov_chequeorden, prov_codpostal, prov_localidad, prov_calle, 
    prov_callenumero, prov_piso, prov_depto, prov_tel, prov_fax, prov_email, 
    prov_web, pro_id, zon_id, creado, modificado, modifico, activo) SELECT 
    prov_id, prov_nombre, prov_codigo, prov_contacto, prov_razonsocial, 
    prov_cuit, prov_ingresosbrutos, prov_catfiscal, prov_chequeorden, 
    prov_codpostal, prov_localidad, prov_calle, prov_callenumero, prov_piso, 
    prov_depto, prov_tel, prov_fax, prov_email, prov_web, pro_id, zon_id, 
    creado, modificado, modifico, activo FROM ProveedorNA8D2558035 

go


DROP TABLE ProveedorNA8D2558035
go


INSERT INTO Provincia (pro_id, pro_nombre, pro_codigo, modificado, pro_descrip, 
    pa_id, modifico, creado, activo) SELECT pro_id, pro_nombre, pro_codigo, 
    modificado, pro_descrip, pa_id, modifico, creado, activo FROM 
    ProvinciaNA8D2558036 

go


DROP TABLE ProvinciaNA8D2558036
go


INSERT INTO Proyecto (proy_id, proy_nombre, proy_codigo, proy_descrip, 
    proy_desde, proy_hasta, prov_id, cli_id, modificado, creado, activo, 
    modifico) SELECT proy_id, proy_nombre, proy_codigo, proy_descrip, 
    proy_desde, proy_hasta, prov_id, cli_id, modificado, creado, activo, 
    modifico FROM ProyectoNA8D2558037 

go


DROP TABLE ProyectoNA8D2558037
go


INSERT INTO ProyectoItem (proyi_id, proyi_nombre, proyi_codigo, proyi_descrip, 
    proy_id, creado, modificado, modifico, activo) SELECT proyi_id, 
    proyi_nombre, proyi_codigo, proyi_descrip, proy_id, creado, modificado, 
    modifico, activo FROM ProyectoItemNA8D2558038 

go


DROP TABLE ProyectoItemNA8D2558038
go


INSERT INTO Rama (ram_id, ram_nombre, arb_id, modificado, creado, modifico, 
    ram_id_padre, ram_orden) SELECT ram_id, ram_nombre, arb_id, modificado, 
    creado, modifico, ram_id_padre, ram_orden FROM RamaNA8D2558039 

go


DROP TABLE RamaNA8D2558039
go


INSERT INTO ReglaLiquidacion (rel_id, rel_nombre, rel_codigo, rel_descrip, 
    creado, modificado, modifico, activo) SELECT rel_id, rel_nombre, rel_codigo,
     rel_descrip, creado, modificado, modifico, activo FROM 
    ReglaLiquidacionNA8D2558040 

go


DROP TABLE ReglaLiquidacionNA8D2558040
go


INSERT INTO Rol (rol_id, rol_nombre, modificado, creado, modifico, activo) 
    SELECT rol_id, rol_nombre, modificado, creado, modifico, activo FROM 
    RolNA8D2558041 

go


DROP TABLE RolNA8D2558041
go


INSERT INTO Rubro (rub_id, rub_nombre, rub_codigo, creado, modificado, modifico,
     activo) SELECT rub_id, rub_nombre, rub_codigo, creado, modificado, 
    modifico, activo FROM RubroNA8D2558042 

go


DROP TABLE RubroNA8D2558042
go


INSERT INTO Tabla (tbl_id, tbl_nombre, tbl_nombrefisico, tbl_campoId, 
    tbl_campocodigo, tbl_sqlHelp, tbl_tieneArbol, tbl_campoNombre, 
    tbl_camposInView, tbl_where, tbl_objectEdit, tbl_objectAbm) SELECT tbl_id, 
    tbl_nombre, tbl_nombrefisico, tbl_campoId, tbl_campocodigo, tbl_sqlHelp, 
    tbl_tieneArbol, tbl_campoNombre, tbl_camposInView, tbl_where, 
    tbl_objectEdit, tbl_objectAbm FROM TablaNA8D2558043 

go


DROP TABLE TablaNA8D2558043
go


INSERT INTO Tarea (tar_id, tar_nombre, tar_descrip, tar_fechaini, tar_fechafin, 
    tar_alarma, tar_finalizada, tar_cumplida, tar_rechazada, us_id_responsable, 
    us_id_asignador, cont_id, tarest_id, prio_id, proy_id, proyi_id, obje_id, 
    cli_id, modificado, creado, modifico, activo) SELECT tar_id, tar_nombre, 
    tar_descrip, tar_fechaini, tar_fechafin, tar_alarma, tar_finalizada, 
    tar_cumplida, tar_rechazada, us_id_responsable, us_id_asignador, cont_id, 
    tarest_id, prio_id, proy_id, proyi_id, obje_id, cli_id, modificado, creado, 
    modifico, activo FROM TareaNA8D2558044 

go


DROP TABLE TareaNA8D2558044
go


INSERT INTO TareaEstado (tarest_id, tarest_nombre, tarest_codigo, creado, 
    modificado, modifico, activo) SELECT tarest_id, tarest_nombre, 
    tarest_codigo, creado, modificado, modifico, activo FROM 
    TareaEstadoNA8D2558045 

go


DROP TABLE TareaEstadoNA8D2558045
go


INSERT INTO TarjetaCredito (tjc_id, tjc_nombre, tjc_codigo, creado, modificado, 
    modifico, activo) SELECT tjc_id, tjc_nombre, tjc_codigo, creado, modificado,
     modifico, activo FROM TarjetaCreditoNA8D2558046 

go


DROP TABLE TarjetaCreditoNA8D2558046
go


INSERT INTO TasaImpositiva (ti_id, ti_nombre, ti_codigo, ti_porcentaje, creado, 
    modificado, modifico, activo) SELECT ti_id, ti_nombre, ti_codigo, 
    ti_porcentaje, creado, modificado, modifico, activo FROM 
    TasaImpositivaNA8D2558047 

go


DROP TABLE TasaImpositivaNA8D2558047
go


INSERT INTO Transporte (trans_id, trans_nombre, trans_codigo, trans_chofer, 
    trans_telefono, trans_direccion, trans_patente, creado, modificado, 
    modifico, activo) SELECT trans_id, trans_nombre, trans_codigo, trans_chofer,
     trans_telefono, trans_direccion, trans_patente, creado, modificado, 
    modifico, activo FROM TransporteNA8D2558048 

go


DROP TABLE TransporteNA8D2558048
go


INSERT INTO Unidad (un_id, un_nombre, un_codigo, creado, modificado, modifico, 
    activo) SELECT un_id, un_nombre, un_codigo, creado, modificado, modifico, 
    activo FROM UnidadNA8D2558049 

go


DROP TABLE UnidadNA8D2558049
go


INSERT INTO Vendedor (ven_id, ven_nombre, ven_codigo, activo, creado, 
    modificado, modifico) SELECT ven_id, ven_nombre, ven_codigo, activo, creado,
     modificado, modifico FROM VendedorNA8D2558050 

go


DROP TABLE VendedorNA8D2558050
go


INSERT INTO Zona (zon_id, zon_nombre, zon_codigo, creado, modificado, modifico, 
    activo) SELECT zon_id, zon_nombre, zon_codigo, creado, modificado, modifico,
     activo FROM ZonaNA8D2558051 

go


DROP TABLE ZonaNA8D2558051
go


ALTER TABLE AFIPEsquema
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE AFIPArchivo
       ADD FOREIGN KEY (afesq_id)
                             REFERENCES AFIPEsquema
go


ALTER TABLE AFIPArchivo
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE AFIPRegistro
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE AFIPRegistro
       ADD FOREIGN KEY (afarch_id)
                             REFERENCES AFIPArchivo
go


ALTER TABLE AFIPCampo
       ADD FOREIGN KEY (afreg_id)
                             REFERENCES AFIPRegistro
go


ALTER TABLE AFIPCampo
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE AFIPParametro
       ADD FOREIGN KEY (afesq_id)
                             REFERENCES AFIPEsquema
go


ALTER TABLE AFIPParametro
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Calidad
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Camion
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Chofer
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE InformeParametro
       ADD FOREIGN KEY (inf_id)
                             REFERENCES Informe
go


ALTER TABLE InformeParametro
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE InformePermiso
       ADD FOREIGN KEY (inf_id)
                             REFERENCES Informe
go


ALTER TABLE InformePermiso
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE InformePermiso
       ADD FOREIGN KEY (us_id)
                             REFERENCES Usuario
go


ALTER TABLE InformePermiso
       ADD FOREIGN KEY (rol_id)
                             REFERENCES Rol
go


ALTER TABLE Reporte
       ADD FOREIGN KEY (inf_id)
                             REFERENCES Informe
go


ALTER TABLE Reporte
       ADD FOREIGN KEY (us_id)
                             REFERENCES Usuario
go


ALTER TABLE Reporte
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE ReporteParametro
       ADD FOREIGN KEY (infp_id)
                             REFERENCES InformeParametro
go


ALTER TABLE ReporteParametro
       ADD FOREIGN KEY (rpt_id)
                             REFERENCES Reporte
go


ALTER TABLE Arbol
       ADD FOREIGN KEY (tbl_Id)
                             REFERENCES Tabla
go


ALTER TABLE Arbol
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Banco
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE CDRomArchivo
       ADD FOREIGN KEY (cdc_id)
                             REFERENCES CDRomCarpeta
go


ALTER TABLE CDRomArchivo
       ADD FOREIGN KEY (cd_id)
                             REFERENCES CDRom
go


ALTER TABLE Ciudad
       ADD FOREIGN KEY (pro_id)
                             REFERENCES Provincia
go


ALTER TABLE Ciudad
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Cliente
       ADD FOREIGN KEY (zon_id)
                             REFERENCES Zona
go


ALTER TABLE Cliente
       ADD FOREIGN KEY (pro_id)
                             REFERENCES Provincia
go


ALTER TABLE Cliente
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE ClienteSucursal
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE ClienteSucursal
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Cobrador
       ADD FOREIGN KEY (rel_id)
                             REFERENCES ReglaLiquidacion
go


ALTER TABLE Cuenta
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Cuenta
       ADD FOREIGN KEY (cuec_id_libroiva)
                             REFERENCES CuentaCategoria
go


ALTER TABLE Cuenta
       ADD FOREIGN KEY (cuec_id)
                             REFERENCES CuentaCategoria
go


ALTER TABLE CuentaCategoria
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE CuentaUso
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE CuentaUso
       ADD FOREIGN KEY (prov_id)
                             REFERENCES Proveedor
go


ALTER TABLE DepositoFisico
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE DepositoLogico
       ADD FOREIGN KEY (depf_id)
                             REFERENCES DepositoFisico
go


ALTER TABLE DepositoLogico
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Documento
       ADD FOREIGN KEY (doct_id)
                             REFERENCES DocumentoTipo
go


ALTER TABLE Documento
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE DocumentoTipo
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Hora
       ADD FOREIGN KEY (tar_id)
                             REFERENCES Tarea
go


ALTER TABLE Hora
       ADD FOREIGN KEY (proy_id)
                             REFERENCES Proyecto
go


ALTER TABLE Hora
       ADD FOREIGN KEY (obje_id)
                             REFERENCES Objetivo
go


ALTER TABLE Hora
       ADD FOREIGN KEY (us_id)
                             REFERENCES Usuario
go


ALTER TABLE Hora
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Hora
       ADD FOREIGN KEY (proyi_id)
                             REFERENCES ProyectoItem
go


ALTER TABLE IngresosBrutosCategoria
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Leyenda
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE ListaDescuento
       ADD FOREIGN KEY (ld_id_padre)
                             REFERENCES ListaDescuento
go


ALTER TABLE ListaDescuento
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE ListaPrecio
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE ListaPrecio
       ADD FOREIGN KEY (lp_id_padre)
                             REFERENCES ListaPrecio
go


ALTER TABLE Marca
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Moneda
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Objetivo
       ADD FOREIGN KEY (proy_id)
                             REFERENCES Proyecto
go


ALTER TABLE Objetivo
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Pais
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Prioridad
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Proveedor
       ADD FOREIGN KEY (zon_id)
                             REFERENCES Zona
go


ALTER TABLE Proveedor
       ADD FOREIGN KEY (pro_id)
                             REFERENCES Provincia
go


ALTER TABLE Proveedor
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Provincia
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Proyecto
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Proyecto
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Proyecto
       ADD FOREIGN KEY (prov_id)
                             REFERENCES Proveedor
go


ALTER TABLE ProyectoItem
       ADD FOREIGN KEY (proy_id)
                             REFERENCES Proyecto
go


ALTER TABLE ProyectoItem
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Rama
       ADD FOREIGN KEY (arb_id)
                             REFERENCES Arbol
go


ALTER TABLE Rama
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Rama
       ADD FOREIGN KEY (ram_id_padre)
                             REFERENCES Rama
go


ALTER TABLE Rol
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Rubro
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (tarest_id)
                             REFERENCES TareaEstado
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (proy_id)
                             REFERENCES Proyecto
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (prio_id)
                             REFERENCES Prioridad
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (cont_id)
                             REFERENCES Contacto
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (obje_id)
                             REFERENCES Objetivo
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (us_id_asignador)
                             REFERENCES Usuario
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (us_id_responsable)
                             REFERENCES Usuario
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Tarea
       ADD FOREIGN KEY (proyi_id)
                             REFERENCES ProyectoItem
go


ALTER TABLE TareaEstado
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE TarjetaCredito
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE TasaImpositiva
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Unidad
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Vendedor
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go


ALTER TABLE Zona
       ADD FOREIGN KEY (modifico)
                             REFERENCES Usuario
go

CREATE VIEW Rama (ram_id, ram_nombre, arb_id, modificado, creado, modifico, ram_orden, ram_id_padre)  AS
       SELECT FK_Rama_Arbol.arb_id, FK_Rama_Usuario.us_id, FK_Rama_Rama.ram_id
       FROM Rama FK_Rama_Rama, Usuario FK_Rama_Usuario, Arbol FK_Rama_Arbol
go



ALTER TABLE Hoja
       ADD FOREIGN KEY (arb_id)
                             REFERENCES Arbol
go


ALTER TABLE CDRomCarpeta
       ADD FOREIGN KEY (cd_id)
                             REFERENCES CDRom
go


ALTER TABLE PedidoVenta
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE ListaPrecioCliente
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE ListaDescuentoCliente
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Direccion
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Contacto
       ADD FOREIGN KEY (cli_id)
                             REFERENCES Cliente
go


ALTER TABLE Producto
       ADD FOREIGN KEY (cue_id_venta)
                             REFERENCES Cuenta
go


ALTER TABLE Producto
       ADD FOREIGN KEY (cue_id_compra)
                             REFERENCES Cuenta
go


ALTER TABLE PedidoVenta
       ADD FOREIGN KEY (doc_id)
                             REFERENCES Documento
go


ALTER TABLE PedidoVenta
       ADD FOREIGN KEY (doct_id)
                             REFERENCES DocumentoTipo
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ibc_id)
                             REFERENCES IngresosBrutosCategoria
go


ALTER TABLE PedidoVenta
       ADD FOREIGN KEY (ld_id)
                             REFERENCES ListaDescuento
go


ALTER TABLE ListaDescuentoItem
       ADD FOREIGN KEY (ld_id)
                             REFERENCES ListaDescuento
go


ALTER TABLE ListaDescuentoCliente
       ADD FOREIGN KEY (ld_id)
                             REFERENCES ListaDescuento
go


ALTER TABLE PedidoVenta
       ADD FOREIGN KEY (lp_id)
                             REFERENCES ListaPrecio
go


ALTER TABLE ListaPrecioItem
       ADD FOREIGN KEY (lp_id)
                             REFERENCES ListaPrecio
go


ALTER TABLE ListaPrecioCliente
       ADD FOREIGN KEY (lp_id)
                             REFERENCES ListaPrecio
go


ALTER TABLE Permiso
       ADD FOREIGN KEY (pre_id)
                             REFERENCES Prestacion
go


ALTER TABLE Direccion
       ADD FOREIGN KEY (prov_id)
                             REFERENCES Proveedor
go


ALTER TABLE Contacto
       ADD FOREIGN KEY (prov_id)
                             REFERENCES Proveedor
go


ALTER TABLE Direccion
       ADD FOREIGN KEY (pro_id)
                             REFERENCES Provincia
go


ALTER TABLE Hoja
       ADD FOREIGN KEY (ram_id)
                             REFERENCES Rama
go


ALTER TABLE UsuarioRol
       ADD FOREIGN KEY (rol_id)
                             REFERENCES Rol
go


ALTER TABLE Producto
       ADD FOREIGN KEY (rub_id)
                             REFERENCES Rubro
go


ALTER TABLE Historia
       ADD FOREIGN KEY (tbl_id)
                             REFERENCES Tabla
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ti_id_ivaricompra)
                             REFERENCES TasaImpositiva
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ti_id_ivarniventa)
                             REFERENCES TasaImpositiva
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ti_id_ivarnicompra)
                             REFERENCES TasaImpositiva
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ti_id_internosv)
                             REFERENCES TasaImpositiva
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ti_id_ivariventa)
                             REFERENCES TasaImpositiva
go


ALTER TABLE Producto
       ADD FOREIGN KEY (ti_id_internosc)
                             REFERENCES TasaImpositiva
go


ALTER TABLE Producto
       ADD FOREIGN KEY (un_id_stock)
                             REFERENCES Unidad
go


ALTER TABLE Producto
       ADD FOREIGN KEY (un_id_venta)
                             REFERENCES Unidad
go


ALTER TABLE Producto
       ADD FOREIGN KEY (un_id_compra)
                             REFERENCES Unidad
go

































































































































