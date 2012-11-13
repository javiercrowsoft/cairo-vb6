if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_monedaGetCotizacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_monedaGetCotizacion]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
-- select * from monedaitem
-- sp_monedaGetCotizacion 3,'20061231'

create procedure sp_monedaGetCotizacion (
	@@mon_id	int,
  @@fecha   datetime,
	@@bselect tinyint 			= 1,
	@@cotiz   decimal(18,6) = 0 out
)
as

set nocount on

begin

	set @@cotiz = 0

  if not exists(select mon_id from Moneda where mon_id = @@mon_id and mon_legal <> 0) begin

		declare @cfg_valor varchar(5000) 

		exec sp_Cfg_GetValor  'General',
												  'Decimales Cotización',
												  @cfg_valor out,
												  0

		if @cfg_valor is null 			set @cfg_valor = '3'
		if isnumeric(@cfg_valor)=0 	set @cfg_valor = '3'

    select top 1 @@cotiz =	moni_precio
		from MonedaItem  
    where mon_id = @@mon_id
    	and moni_fecha <= @@fecha
    order by moni_fecha desc

  end

	if @@bselect <> 0 select @@cotiz as moni_precio, convert(int,@cfg_valor) as DecimalesCotizacion

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



