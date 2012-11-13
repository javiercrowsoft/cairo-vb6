if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoCalcPrecioGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoCalcPrecioGetData]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoCalcPrecioGetData 2

create procedure sp_ProductoCalcPrecioGetData (
	@@pr_id	int
)
as

set nocount on

begin

	select 	pr_ventacompra,
					pr_porcinternov,
					tiiva.ti_porcentaje as iva,
					tiint.ti_porcentaje as internos

	from producto pr left join TasaImpositiva tiiva on pr.ti_id_ivariventa = tiiva.ti_id
									 left join TasaImpositiva tiint on pr.ti_id_internosv  = tiint.ti_id
	where pr_id = @@pr_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



