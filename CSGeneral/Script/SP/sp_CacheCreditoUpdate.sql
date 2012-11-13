if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CacheCreditoUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CacheCreditoUpdate]

/*

 sp_CacheCreditoUpdate

*/

go
create procedure sp_CacheCreditoUpdate 

as

begin

	set nocount on
	
	update cliente set 
										cli_deudapedido				=0,
										cli_deudaorden				=0,
										cli_deudaremito				=0,
										cli_deudapackinglist	=0,
										cli_deudamanifiesto		=0,
										cli_deudactacte				=0,
										cli_deudadoc					=0,
										cli_deudatotal				=0
	
	delete empresaclientedeuda
	
	exec sp_docpedidoventassetcredito '19900101','21000101',0,0
	exec sp_docmanifiestocargassetcredito '19900101','21000101',0
	exec sp_docpackinglistssetcredito '19900101','21000101',0
	exec sp_docordenserviciossetcredito '19900101','21000101'
	exec sp_docremitoventassetcredito '19900101','21000101',0,0
	exec sp_docfacturaventassetcredito '19900101','21000101',0,0
	exec sp_doccobranzassetcredito '19900101','21000101',0,0
	
	update Cliente 
				set cli_deudatotal = 	cli_deudapedido 
														+ cli_deudaorden
														+	cli_deudaremito 
														+	cli_deudapackinglist
														+	cli_deudamanifiesto
														+	cli_deudactacte
														+	cli_deudadoc
	
	update proveedor set 
										prov_deudaorden 				=0,
										prov_deudaremito				=0,
										prov_deudactacte				=0,
										prov_deudadoc						=0,
										prov_deudatotal					=0
	
	delete empresaproveedordeuda
	
	exec sp_docordencomprassetcredito
	exec sp_docremitocomprassetcredito
	exec sp_docfacturacomprassetcredito
	exec sp_docordenpagossetcredito
	
	update proveedor 
			set prov_deudatotal = 	prov_deudaorden 
													+	prov_deudaremito 
													+	prov_deudactacte
													+	prov_deudadoc
	

end
go