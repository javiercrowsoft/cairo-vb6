if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteGetIva]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteGetIva]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_clienteGetIva 35639

*/

go
create procedure sp_clienteGetIva (
	@@cli_id 		int,
  @@bIvari		smallint = 0 out,
  @@bIvarni   smallint = 0 out,
  @@bSelect   smallint = 1 
)
as

begin

	set nocount on
  declare @tipoIva        smallint
  declare @cli_catfiscal  int

  declare @bIva           smallint  set @bIva    = -1
  declare @bIvaRni        smallint  set @bIvaRni = -2
  declare @bSinIva        smallint  set @bSinIva = -3

	select
         @tipoIva         = case cli_catfiscal
															when 1  then @bIva       --'Inscripto'
															when 2  then @bIva       -- FALTA VERIFICAR QUE SEA ASI --'Exento'
															when 3  then @bIvaRni    --'No inscripto'
															when 4  then @bIva       --'Consumidor Final'
															when 5  then @bSinIva    --'Extranjero'
															when 6  then @bIva       --'Mono Tributo'
															when 7  then @bIva       --'Extranjero Iva'
															when 8  then @bIva       --'No responsable'
															when 9  then @bIva       -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
															when 10 then @bIvaRni    --'No categorizado'
															when 11 then @bIva       --'InscriptoM'
											        else         0           --'Sin categorizar'
													 end,
        @cli_catfiscal    = cli_catfiscal

	from Cliente
  where cli_id = @@cli_id

	set @tipoIva = IsNull(@tipoIva,@bSinIva)

	if @tipoIva = @bIva begin
		set @bIva     = 1
    set @bIvaRni  = 0
  end else begin
		if @tipoIva = @bIvaRni begin
			set @bIva     = 1
	    set @bIvaRni  = 1
    end else begin
			if @tipoIva = @bSinIva begin
				set @bIva     = 0
		    set @bIvaRni  = 0
      end
    end
	end

	set @@bIvaRi  = @bIva
	set @@bIvaRni = @bIvaRni

	if @@bSelect <> 0 select @bIva as bIva, @bIvaRni as bIvaRni, @cli_catfiscal as cli_catfiscal

end

go