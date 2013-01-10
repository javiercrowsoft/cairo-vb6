set nocount on

update cliente set 
                  cli_deudapedido        =0,
                  cli_deudaorden        =0,
                  cli_deudaremito        =0,
                  cli_deudapackinglist  =0,
                  cli_deudamanifiesto    =0,
                  cli_deudactacte        =0,
                  cli_deudadoc          =0,
                  cli_deudatotal        =0

delete empresaclientedeuda

exec sp_docpedidoventassetcredito
exec sp_docmanifiestocargassetcredito
exec sp_docpackinglistssetcredito
exec sp_docordenserviciossetcredito
exec sp_docremitoventassetcredito
exec sp_docfacturaventassetcredito
exec sp_doccobranzassetcredito

update Cliente 
      set cli_deudatotal =   cli_deudapedido 
                          + cli_deudaorden
                          +  cli_deudaremito 
                          +  cli_deudapackinglist
                          +  cli_deudamanifiesto
                          +  cli_deudactacte
                          +  cli_deudadoc

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

update proveedor 
    set prov_deudatotal =   prov_deudaorden 
                        +  prov_deudaremito 
                        +  prov_deudactacte
                        +  prov_deudadoc

