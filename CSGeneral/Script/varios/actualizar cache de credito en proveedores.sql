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
