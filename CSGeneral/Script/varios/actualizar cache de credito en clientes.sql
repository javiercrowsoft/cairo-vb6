delete clientecachecredito where cli_id = 256

update cliente set 
                  cli_deudapedido        =0,
                  cli_deudaremito        =0,
                  cli_deudapackinglist  =0,
                  cli_deudamanifiesto    =0,
                  cli_deudactacte        =0,
                  cli_deudadoc          =0,
                  cli_deudatotal        =0
-- Version GNGas
,
                  cli_gng_deudapedido        =0,
                  cli_gng_deudaremito        =0,
                  cli_gng_deudafactura      =0,
                  cli_gng_deudacobranza      =0

where cli_id = 256

delete empresaclientedeuda where cli_id = 256

exec sp_docpedidoventassetcredito '20060301','21000301',1,256
exec sp_docmanifiestocargassetcredito '20060301','21000301',256
exec sp_docpackinglistssetcredito '20060301','21000301',256
exec sp_docremitoventassetcredito '20060301','21000301',0,256
exec sp_docfacturaventassetcredito '20060301','21000301',0,256
exec sp_doccobranzassetcredito '20060301','21000301',0,256

