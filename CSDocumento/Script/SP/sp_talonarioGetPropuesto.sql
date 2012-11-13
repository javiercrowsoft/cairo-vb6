if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_talonarioGetPropuesto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_talonarioGetPropuesto]

go

/*

*/

create procedure sp_talonarioGetPropuesto (
	@@doc_id 					int,
	@@ta_Mascara			varchar(100) out,
	@@ta_Propuesto		tinyint out,
  @@cli_id          int = 0,
  @@prov_id         int = 0,
	@@ta_id           int = null out,
	@@ta_tipo         smallint = 0 out
)
as

begin

	declare @ta_id int
	declare @doct_id int
  declare @cli_catfiscal int
  declare @prov_catfiscal int

	if IsNull(@@doc_id,0) = 0 begin

			set @@ta_Mascara 		= ''
      set @@ta_Propuesto 	= 0
			set @@ta_tipo				= 0
			set @@ta_id 				= null

	end	else begin

		select @ta_id = ta_id, @doct_id = doct_id from Documento where doc_id = @@doc_id

		if @doct_id in (1,--	Factura de Venta
										2,--	Factura de Compra
										7,--	Nota de Credito Venta
										8,--	Nota de Credito Compra
										9,--	Nota de Debito Venta
										10--	Nota de Debito Compra
										) begin


			if @doct_id in (1,--	Factura de Venta
											7,--	Nota de Credito Venta
											9 --	Nota de Debito Venta
											) begin

				select @cli_catfiscal = cli_catfiscal from Cliente where cli_id = @@cli_id

				select
							 @ta_id =
			         case @cli_catfiscal
									when 1  then ta_id_inscripto   --'Inscripto'
									when 2  then ta_id_final       --'Exento'
									when 3  then ta_id_inscripto   --'No inscripto'
									when 4  then ta_id_final       --'Consumidor Final'
									when 5  then ta_id_externo     --'Extranjero'
									when 6  then ta_id_final       --'Mono Tributo'
									when 7  then ta_id_externo     --'Extranjero Iva'
									when 8  then ta_id_final       --'No responsable'
									when 9  then ta_id_final       --'No Responsable exento'
									when 10 then ta_id_final       --'No categorizado'
									when 11 then ta_id_inscripto	 --'Inscripto M'
					        else         -1                --'Sin categorizar'
							 end 
				from Documento 
			  where doc_id = @@doc_id

			end else begin

				select @prov_catfiscal = prov_catfiscal from Proveedor where prov_id = @@prov_id
										--2,--	Factura de Compra
										--8,--	Nota de Credito Compra
										--10--	Nota de Debito Compra

				select
							 @ta_id =
			         case @prov_catfiscal
									when 1  then ta_id_inscripto   --'Inscripto'
									when 2  then ta_id_final       --'Exento'
									when 3  then ta_id_final       --'No inscripto'
									when 4  then ta_id_final       --'Consumidor Final'
									when 5  then ta_id_externo     --'Extranjero'
									when 6  then ta_id_final       --'Mono Tributo'
									when 7  then ta_id_externo     --'Extranjero Iva'
									when 8  then ta_id_final       --'No responsable'
									when 9  then ta_id_final       --'No Responsable exento'
									when 10 then ta_id_final       --'No categorizado'
									when 11 then ta_id_inscriptom	 --'Inscripto M'
					        else         -1                --'Sin categorizar'
							 end
				from Documento 
			  where doc_id = @@doc_id

			end
		end 

		if IsNull(@ta_id,0) = 0 begin

				set @@ta_Mascara 		= ''
	      set @@ta_Propuesto 	= 0
				set @@ta_tipo				= 0
				set @@ta_id 				= null

		end else begin

		  select 	@@ta_Mascara 		= ta_mascara, 
							@@ta_Propuesto 	= ta_tipo, 
							@@ta_tipo				= ta_tipo 
			from Talonario where ta_id = @ta_id

			if IsNull(@@ta_Propuesto,0)<> 1 set @@ta_Propuesto = 0
    	else                            set @@ta_Propuesto = 1

			set @@ta_Mascara = IsNull(@@ta_Mascara,'')
			set @@ta_id 		 = @ta_id

		end
	end
end

go