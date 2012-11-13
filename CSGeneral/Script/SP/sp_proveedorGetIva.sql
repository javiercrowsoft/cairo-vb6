if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorGetIva]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorGetIva]

/*

 select prov_catfiscal,prov_nombre,prov_codigo from Proveedor where prov_catfiscal <1 or prov_catfiscal >10 order by prov_catfiscal

 select * from documento

 sp_proveedorGetIva 4584,14

*/

go
create procedure sp_proveedorGetIva (
	@@prov_id 		int,
  @@bIvari		smallint = 0 out,
  @@bIvarni   smallint = 0 out,
  @@bSelect   smallint = 1 
)
as

begin

	set nocount on
  declare @tipoIva        smallint

  declare @bIva           smallint  set @bIva    = -1
  declare @bIvaRni        smallint  set @bIvaRni = -2
  declare @bSinIva        smallint  set @bSinIva = -3

	select
         @tipoIva         = case prov_catfiscal
															when 1  then @bIva       --'Inscripto'
															when 2  then @bSinIva    --'Exento'
															when 3  then @bSinIva    --'No inscripto'
															when 4  then @bIva       --'Consumidor Final'
															when 5  then @bSinIva    --'Extranjero'
															when 6  then @bSinIva    --'Mono Tributo'
															when 7  then @bIva       --'Extranjero Iva'
															when 8  then @bIva       --'No responsable'
															when 9  then @bIva       --'No Responsable exento'
															when 10 then @bIvaRni    --'No categorizado'
															when 11 then @bIva       --'Inscripto M'
											        else         0           --'Sin categorizar'
													 end
	from Proveedor
  where prov_id = @@prov_id

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

	if @@bSelect <> 0 select @bIva as bIva, @bIvaRni as bIvaRni

end

go