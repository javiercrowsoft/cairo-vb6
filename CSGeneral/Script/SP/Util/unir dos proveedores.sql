-- 
-- select * from proveedor where prov_nombre like '%PANELLA VIAJES%'
-- select * from proveedor where prov_nombre like '%PANELLA JORGE ALBERTO%'

begin tran

declare @@new_prov int
declare @@old_prov int

set @@new_prov =160

set @@old_prov =257

update StockProveedor set prov_id = @@new_prov where prov_id = @@old_prov
update Transporte set prov_id = @@new_prov where prov_id = @@old_prov
update DepositoLogico set prov_id = @@new_prov where prov_id = @@old_prov
update ProductoDepositoEntrega set prov_id = @@new_prov where prov_id = @@old_prov
update Reina set prov_id = @@new_prov where prov_id = @@old_prov
update DepartamentoProveedor set prov_id = @@new_prov where prov_id = @@old_prov
update Contacto set prov_id = @@new_prov where prov_id = @@old_prov
update FacturaCompra set prov_id = @@new_prov where prov_id = @@old_prov
update DespachoImpCalculo set prov_id = @@new_prov where prov_id = @@old_prov
update UsuarioEmpresa set prov_id = @@new_prov where prov_id = @@old_prov
update FRETSolicitudParticular set prov_id = @@new_prov where prov_id = @@old_prov
update ProductoNumeroSerie set prov_id = @@new_prov where prov_id = @@old_prov
update PresupuestoCompra set prov_id = @@new_prov where prov_id = @@old_prov
update OrdenCompra set prov_id = @@new_prov where prov_id = @@old_prov
update Persona set prov_id = @@new_prov where prov_id = @@old_prov
update Garantia set prov_id = @@new_prov where prov_id = @@old_prov
update Proyecto set prov_id = @@new_prov where prov_id = @@old_prov
update ProveedorRetencion set prov_id = @@new_prov where prov_id = @@old_prov
update EmpresaProveedor set prov_id = @@new_prov where prov_id = @@old_prov
update Cheque set prov_id = @@new_prov where prov_id = @@old_prov
update ProveedorCacheCredito set prov_id = @@new_prov where prov_id = @@old_prov
update ImportacionTemp set prov_id = @@new_prov where prov_id = @@old_prov
update ListaPrecioProveedor set prov_id = @@new_prov where prov_id = @@old_prov
update ProveedorCAI set prov_id = @@new_prov where prov_id = @@old_prov
update OrdenPago set prov_id = @@new_prov where prov_id = @@old_prov
update ListaDescuentoProveedor set prov_id = @@new_prov where prov_id = @@old_prov
update RemitoCompra set prov_id = @@new_prov where prov_id = @@old_prov
update CashFlowParam set prov_id = @@new_prov where prov_id = @@old_prov
update EmpresaProveedorDeuda set prov_id = @@new_prov where prov_id = @@old_prov
update ProductoNumeroSerieServicio set prov_id = @@new_prov where prov_id = @@old_prov
update ProveedorCuentaGrupo set prov_id = @@new_prov where prov_id = @@old_prov
update PresupuestoVenta set prov_id = @@new_prov where prov_id = @@old_prov
update ProductoProveedor set prov_id = @@new_prov where prov_id = @@old_prov
update ParteDiario set prov_id = @@new_prov where prov_id = @@old_prov
update ProductoNumeroSerieHistoria set prov_id = @@new_prov where prov_id = @@old_prov

exec sp_proveedordelete @@old_prov

update proveedor set 
                  prov_deudaorden         =0,
                  prov_deudaremito        =0,
                  prov_deudactacte        =0,
                  prov_deudadoc            =0,
                  prov_deudatotal          =0

delete empresaproveedordeuda

exec sp_docordencomprassetcredito
exec sp_docremitocomprassetcredito
exec sp_docfacturacomprassetcredito
exec sp_docordenpagossetcredito

select * from proveedor where prov_nombre like '%PANELLA VIAJES%'
select * from proveedor where prov_nombre like '%PANELLA JORGE ALBERTO%'

rollback tran