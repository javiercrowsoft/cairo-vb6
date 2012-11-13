if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocVentasPorHojadeRuta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocVentasPorHojadeRuta]

go

/*

  sp_DocEsCobranzaPorCajero 34

*/

create procedure sp_DocVentasPorHojadeRuta

as

set nocount on

begin

	-- Antes que nada valido que este el centro de costo
	--
	declare @cfg_valor varchar(5000) 

	exec sp_Cfg_GetValor  'Ventas-General',
											  'Ventas por Hoja de Ruta',
											  @cfg_valor out,
											  0
  set @cfg_valor = IsNull(@cfg_valor,0)
	if convert(int,@cfg_valor) <> 0 
		select 1
	else
		select 0
end

go
