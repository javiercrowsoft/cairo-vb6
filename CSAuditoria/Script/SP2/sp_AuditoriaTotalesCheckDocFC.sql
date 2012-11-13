-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocFC]

go

create procedure sp_AuditoriaTotalesCheckDocFC (

	@@fc_id     	int,
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

	declare @doct_id      		int
	declare @fc_nrodoc 				varchar(50) 
	declare @fc_numero 				varchar(50) 
	declare @est_id       		int
	declare @fc_pendiente			decimal(18,6)
	declare @fc_total    			decimal(18,6)
	declare @fc_otros         decimal(18,6)
	declare @fc_percepciones  decimal(18,6)
	declare @fc_neto          decimal(18,6)
	declare @fc_ivari         decimal(18,6)
	declare @fc_importedesc1  decimal(18,6)
	declare @fc_importedesc2  decimal(18,6)
	declare @fc_desc1  				decimal(18,6)
	declare @fc_desc2  				decimal(18,6)

	select 
						@doct_id 		 	= doct_id,
						@fc_nrodoc  	= fc_nrodoc,
						@fc_numero  	= convert(varchar,fc_numero),
						@est_id      	= est_id,
						@fc_pendiente	= fc_pendiente,
						@fc_total			= fc_total,
						@fc_neto			= fc_neto,
						@fc_ivari			= fc_ivari,

						@fc_otros					= fc_totalotros,
						@fc_percepciones	= fc_totalpercepciones,

						@fc_desc1					= fc_descuento1,
						@fc_desc2					= fc_descuento2,

						@fc_importedesc1	= fc_importedesc1,
						@fc_importedesc2	= fc_importedesc2

	from FacturaCompra where fc_id = @@fc_id

	if exists(select fc_id 
						from FacturaCompraItem
         		where abs(round(fci_neto,2) - round(fci_precio * fci_cantidad,2))>0.01
							and fc_id = @@fc_id
						) begin


			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta factura posee items cuyo neto no coincide con el precio por la cantidad' + char(10)
									
	end

-------------------------------------------------------------------------------
--
-- Como puede haber facturas que se cargan
-- con diferencias entre la tasa y lo impreso
-- en la factura, y hay que respetar el impreso,
-- no puedo realizar este control, al grabar,
-- aunque si lo dejamos activo en los procesos de auditoria
-- que graban en el log para que el supervisor este
-- alertado de que hay casos donde ocurre esta diferencia
--

	-- 	if exists(select fc_id 
	-- 						from FacturaCompraItem
	--          		where abs(round(fci_neto * (fci_ivariporc / 100),2) - round(fci_ivari,2))>0.01
	-- 							and fc_id = @@fc_id
	-- 						) begin
	-- 
	-- 			set @bError = 1
	-- 			set @@bErrorMsg = @@bErrorMsg + 'Esta factura posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)
	-- 
	-- 	end
-------------------------------------------------------------------------------

	declare @fci_neto decimal(18,6)

	select @fci_neto = sum(fci_neto)
	from FacturaCompraItem
	where fc_id = @@fc_id
	group by fc_id

	set @fci_neto = IsNull(@fci_neto,0) - (@fci_neto * @fc_desc1/100) 
	set @fci_neto = IsNull(@fci_neto,0) - (@fci_neto * @fc_desc2/100)

	if abs(round(@fci_neto,2) - round(@fc_neto,2))>0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El neto de esta factura no coincide con la suma de los netos de sus items' + char(10)

	end

	declare @percepciones		decimal(18,6)
	declare @fc_descivari 	decimal(18,6)
	declare @fci_ivari 			decimal(18,6)
	declare @importe 				decimal(18,6)
	declare @otros   				decimal(18,6)

	select @fci_ivari = sum(fci_ivari)
						from FacturaCompraItem
						where fc_id = @@fc_id
						group by fc_id

	set @fci_ivari 		= isnull(@fci_ivari,0)
	set @fc_descivari = (@fci_ivari * @fc_desc1/100) 
	set @fc_descivari = @fc_descivari + ((@fci_ivari - @fc_descivari) * @fc_desc2/100)
	set @fc_total 		= @fc_total + @fc_importedesc1 + @fc_importedesc2 + @fc_descivari

	select @importe 			= sum(fci_importe) from FacturaCompraItem where fc_id = @@fc_id 
	select @otros   			= sum(fcot_debe-fcot_haber) from FacturaCompraOtro where fc_id = @@fc_id 
	select @percepciones 	= sum(fcperc_importe) from FacturaCompraPercepcion where fc_id = @@fc_id 

	set @importe 			= isnull(@importe,0)
	set @otros 				= isnull(@otros,0)
	set @percepciones = isnull(@percepciones,0)

	if abs(round(@importe + @otros + @percepciones,2) - round(@fc_total,2))>0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El total de esta factura no coincide con la suma de los totales de sus items' + char(10)

	end

	select @fci_ivari = sum(fci_ivari)
						from FacturaCompraItem
						where fc_id = @@fc_id
						group by fc_id

	set @fci_ivari = isnull(@fci_ivari,0)
	set @fci_ivari = @fci_ivari - (@fci_ivari * @fc_desc1/100) 
	set @fci_ivari = @fci_ivari - (@fci_ivari * @fc_desc2/100)

	if abs(round(@fci_ivari,2) - round(@fc_ivari,2))>0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El IVA de esta factura no coincide con la suma de los IVA de sus items' + char(10)
									
	end

	if abs(round(@otros,2) - round(@fc_otros,2))>0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El total de otros de esta factura no coincide con la suma de los totales de sus items de tipo otro' + char(10)
																	  + 'Dif: ' + convert(varchar(50),round(@otros,2) - round(@fc_otros,2),1) + char(10)
																		+ 'Total: ' +  convert(varchar(50),round(@fc_otros,2),1) + char(10)
																		+ 'Deuda: ' +  convert(varchar(50),round(@otros,2),1) + char(10)


	end

	if abs(round(@percepciones,2) - round(@fc_percepciones,2))>0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El total de percepcioens de esta factura no coincide con la suma de los totales de sus items de tipo percepcion' + char(10)

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO