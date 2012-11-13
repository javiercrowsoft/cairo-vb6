-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocOC]

go

create procedure sp_AuditoriaTotalesCheckDocOC (

	@@oc_id     	int,
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
	declare @oc_nrodoc 				varchar(50) 
	declare @oc_numero 				varchar(50) 
	declare @est_id       		int
	declare @oc_pendiente			decimal(18,6)
	declare @oc_total    			decimal(18,6)
	declare @oc_neto          decimal(18,6)
	declare @oc_ivari         decimal(18,6)
	declare @oc_importedesc1  decimal(18,6)
	declare @oc_importedesc2  decimal(18,6)
	declare @oc_desc1  				decimal(18,6)
	declare @oc_desc2  				decimal(18,6)
	declare @prov_catFiscal   smallint

	select 
						@doct_id 		 	= doct_id,
						@oc_nrodoc  	= oc_nrodoc,
						@oc_numero  	= convert(varchar,oc_numero),
						@est_id      	= est_id,
						@oc_pendiente	= oc_pendiente,
						@oc_total			= oc_total,
						@oc_neto			= oc_neto,
						@oc_ivari			= oc_ivari,

						@oc_desc1					= oc_descuento1,
						@oc_desc2					= oc_descuento2,

						@oc_importedesc1	= oc_importedesc1,
						@oc_importedesc2	= oc_importedesc2,
						@prov_catFiscal   = prov_catfiscal

	from OrdenCompra oc inner join Proveedor prov on oc.prov_id = prov.prov_id
	where oc_id = @@oc_id

	if exists(select oc_id 
						from OrdenCompraItem
         		where abs(round(oci_neto,2) - round(oci_precio * oci_cantidad,2))>=0.01
							and oc_id = @@oc_id
						) begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta orden posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

	end

	if exists(select oc_id 
						from OrdenCompraItem
         		where abs(round(oci_neto * (oci_ivariporc / 100),2) - round(oci_ivari,2))>=0.01
							and oc_id = @@oc_id
							and @prov_catFiscal <> 5
						) begin


			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta orden posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)

	end

	declare @oci_neto decimal(18,6)

	select @oci_neto = sum(oci_neto)
	from OrdenCompraItem
	where oc_id = @@oc_id
	group by oc_id

	set @oci_neto = IsNull(@oci_neto,0) - (@oci_neto * @oc_desc1/100) 
	set @oci_neto = IsNull(@oci_neto,0) - (@oci_neto * @oc_desc2/100)

	if abs(round(@oci_neto,2) - round(@oc_neto,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El neto de esta orden no coincide con la suma de los netos de sus items' + char(10)

	end

	declare @importe 				decimal(18,6)

	select @importe = sum(oci_importe) from OrdenCompraItem where oc_id = @@oc_id group by oc_id

	set @importe = isnull(@importe,0)

	declare @oc_descivari decimal(18,6)
	declare @oci_ivari 		decimal(18,6)

	select @oci_ivari = sum(oci_ivari)
						from OrdenCompraItem
						where oc_id = @@oc_id
						group by oc_id

	set @oci_ivari 		= isnull(@oci_ivari,0)
	set @oc_descivari = (@oci_ivari * @oc_desc1/100) 
	set @oc_descivari = @oc_descivari + ((@oci_ivari - @oc_descivari) * @oc_desc2/100)
	set @oc_total 		= @oc_total + @oc_importedesc1 + @oc_importedesc2 + @oc_descivari

	if abs(round(@importe,2) - round(@oc_total,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El total de esta orden no coincide con la suma de los totales de sus items' + char(10)

	end

	select @oci_ivari = sum(oci_ivari)
						from OrdenCompraItem
						where oc_id = @@oc_id
						group by oc_id

	set @oci_ivari = isnull(@oci_ivari,0)
	set @oci_ivari = @oci_ivari - (@oci_ivari * @oc_desc1/100) 
	set @oci_ivari = @oci_ivari - (@oci_ivari * @oc_desc2/100)

	if abs(round(@oci_ivari,2) - round(@oc_ivari,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El IVA de esta orden no coincide con la suma de los IVA de sus items' + char(10)

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO