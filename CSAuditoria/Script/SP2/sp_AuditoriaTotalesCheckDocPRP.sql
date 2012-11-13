-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocPRP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocPRP]

go

create procedure sp_AuditoriaTotalesCheckDocPRP (

	@@prp_id     	int,
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

	declare @audi_id 					int
	declare @doct_id      		int
	declare @prp_nrodoc 			varchar(50) 
	declare @prp_numero 			varchar(50) 
	declare @est_id       		int
	declare @prp_total    		decimal(18,6)
	declare @prp_neto         decimal(18,6)
	declare @prp_ivari        decimal(18,6)
	declare @prp_importedesc1 decimal(18,6)
	declare @prp_importedesc2 decimal(18,6)
	declare @prp_desc1  			decimal(18,6)
	declare @prp_desc2  			decimal(18,6)
	declare @cli_catFiscal    smallint

	select 
						@doct_id 		 			= doct_id,
						@prp_nrodoc  			= prp_nrodoc,
						@prp_numero  			= convert(varchar,prp_numero),
						@est_id      			= est_id,
						@prp_total				= prp_total,
						@prp_neto					= prp_neto,
						@prp_ivari				= prp_ivari,

						@prp_desc1				= prp_descuento1,
						@prp_desc2				= prp_descuento2,

						@prp_importedesc1	= prp_importedesc1,
						@prp_importedesc2	= prp_importedesc2,
						@cli_catFiscal    = cli_catfiscal

	from ParteReparacion prp inner join Cliente cli on prp.cli_id = cli.cli_id
	where prp_id = @@prp_id

	if exists(select prp_id 
						from ParteReparacionItem
         		where abs(round(prpi_neto,2) - round(prpi_precio * prpi_cantidad,2))>=0.01
							and prp_id = @@prp_id
						) begin


			set @bError = 1
			set @@bErrorMsg =  @@bErrorMsg + 'Este parte de reparación posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

	end

	if exists(select prp_id 
						from ParteReparacionItem
         		where abs(round(prpi_neto * (prpi_ivariporc / 100),2) - round(prpi_ivari,2))>=0.01
							and prp_id = @@prp_id
							and @cli_catFiscal <> 5
						) begin

			declare @dif decimal(18,6)

			select @dif = abs(round(prpi_neto * (prpi_ivariporc / 100),2) - round(prpi_ivari,2)) 
						from ParteReparacionItem
         		where abs(round(prpi_neto * (prpi_ivariporc / 100),2) - round(prpi_ivari,2))>=0.01
							and prp_id = @@prp_id
							and @cli_catFiscal <> 5
						

			set @bError = 1
			set @@bErrorMsg =  @@bErrorMsg + 'Este parte de reparación posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)
																		 + 'Diferencia ' + convert(varchar(50),@dif)
									
	end

	declare @prpi_neto decimal(18,6)

	select @prpi_neto = sum(prpi_neto)
	from ParteReparacionItem
	where prp_id = @@prp_id
	group by prp_id

	set @prpi_neto = IsNull(@prpi_neto,0) - (@prpi_neto * @prp_desc1/100) 
	set @prpi_neto = IsNull(@prpi_neto,0) - (@prpi_neto * @prp_desc2/100)

	if  abs(round(@prpi_neto,2) - round(@prp_neto,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg =  @@bErrorMsg + 'El neto de este parte de reparación no coincide con la suma de los netos de sus items' + char(10)
																		 + 'Diferencia ' + convert(varchar(50),abs(round(@prpi_neto,2) - round(@prp_neto,2)))
	end

	declare @prp_descivari decimal(18,6)
	declare @prpi_ivari 	 decimal(18,6)
	declare @importe       decimal(18,6)

	select @prpi_ivari = sum(prpi_ivari)
						from ParteReparacionItem
						where prp_id = @@prp_id
						group by prp_id

	set @prpi_ivari 		= isnull(@prpi_ivari,0)
	set @prp_descivari  = (@prpi_ivari * @prp_desc1/100) 
	set @prp_descivari  = @prp_descivari + ((@prpi_ivari - @prp_descivari) * @prp_desc2/100)
	set @prp_total 		  = @prp_total + @prp_importedesc1 + @prp_importedesc2 + @prp_descivari

	select @importe = sum(prpi_importe)
						from ParteReparacionItem
						where prp_id = @@prp_id

	set @importe = isnull(@importe,0)

	if abs(round(@importe,2) - round(@prp_total,2))>=0.01  begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El total de este parte de reparación no coincide con la suma de los totales de sus items' + char(10)
																		+ 'Total Items: ' + convert(varchar(50),round(@importe,2)) + char(13)
																		+ 'Total parte de reparación: ' + convert(varchar(50),round(@prp_total,2)) + char(13)
									
	end

	select @prpi_ivari = sum(prpi_ivari)
						from ParteReparacionItem
						where prp_id = @@prp_id
						group by prp_id

	set @prpi_ivari = isnull(@prpi_ivari,0)
	set @prpi_ivari = @prpi_ivari - (@prpi_ivari * @prp_desc1/100) 
	set @prpi_ivari = @prpi_ivari - (@prpi_ivari * @prp_desc2/100)

	if abs(round(@prpi_ivari,2) - round(@prp_ivari,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg =  @@bErrorMsg + 'El IVA de este parte de reparación no coincide con la suma de los IVA de sus items' + char(10)
																		 + 'Diferencia ' + convert(varchar(50),abs(round(@prpi_ivari,2) - round(@prp_ivari,2)))

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO