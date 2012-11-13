-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraValidateDeposito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraValidateDeposito]

go

create procedure sp_DocFacturaCompraValidateDeposito (

	@@fcTMP_id    int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @bError tinyint

	set @bError     = 0
	set @@bSuccess 	= 0
	set @@bErrorMsg = '@@ERROR_SP:'

	declare @llevaStock tinyint
	select @llevaStock = doc_muevestock 
	from Documento doc inner join FacturaCompraTMP fc on doc.doc_id = fc.doc_id
	where fc.fcTMP_id = @@fcTMP_id

	if @llevaStock <> 0 begin

		if exists(select * 
							from FacturaCompraItemTMP fci 
											inner join FacturaCompraTMP fc 
															on fci.fcTMP_id = fc.fcTMP_id
											inner join Documento doc
															on fc.doc_id = doc.doc_id
							where
										fc.fcTMP_id = @@fcTMP_id
								and	not exists(select * from ProductoDepositoEntrega where pr_id = fci.pr_id and depl_id = fc.depl_id and suc_id = fc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = fc.prov_id))
								and	exists(select * from ProductoDepositoEntrega where pr_id = fci.pr_id and depl_id <> fc.depl_id and suc_id = fc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = fc.prov_id))
							) begin
	
	
				declare @depl_nombre varchar(255)
	
				select @depl_nombre = depl_nombre
				from FacturaCompraTMP fc inner join DepositoLogico depl
								on fc.depl_id = depl.depl_id
				where fc.fcTMP_id = @@fcTMP_id
	
				declare c_productos insensitive cursor for
				select pr_nombrecompra 
							from FacturaCompraItemTMP fci 
											inner join FacturaCompraTMP fc 
															on fci.fcTMP_id = fc.fcTMP_id
											inner join Producto pr
															on fci.pr_id = pr.pr_id
											inner join Documento doc
															on fc.doc_id = doc.doc_id
							where
										fc.fcTMP_id = @@fcTMP_id
								and	not exists(select * from ProductoDepositoEntrega where pr_id = fci.pr_id and depl_id = fc.depl_id and suc_id = fc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = fc.prov_id))
								and	exists(select * from ProductoDepositoEntrega where pr_id = fci.pr_id and depl_id <> fc.depl_id and suc_id = fc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = fc.prov_id))
	
				declare @pr_nombrecompra varchar(2000)
				declare @productos 			 varchar(8000)
	
				set @productos = ''
	
				open c_productos
	
				fetch next from c_productos into @pr_nombrecompra
				while @@fetch_status=0
				begin
	
					set @productos = @productos + @pr_nombrecompra + char(10)
	
					fetch next from c_productos into @pr_nombrecompra
				end
				close c_productos
				deallocate c_productos
	
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Esta factura indica articulos que no estan habilitados para ingresar en el deposito:' 
                                      + char(10)+ char(10)+ @depl_nombre + char(10)+ char(10) 
                                      + 'Los articulos son:' + char(10) + char(10) + @productos
	
		end
	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO