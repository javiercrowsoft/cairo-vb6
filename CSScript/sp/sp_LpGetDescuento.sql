if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ldGetDescuentoStr]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ldGetDescuentoStr]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ram_convertid.sql
' Objetivo: Convierte un seudo id en un id real ya sea de rama o de una tabla cliente
'-----------------------------------------------------------------------------------------
*/

/*

select * from listadescuento
select * from listadescuentoitem

sp_ldGetDescuentoStr 2,9,'',1

*/
create Procedure sp_ldGetDescuentoStr(
  @@ld_id       int,
	@@pr_id 			int,
	@@descuento   varchar(255)='' out,
	@@select      tinyint = 0
)
as
begin

	declare @ldi_id 				int
  declare @ld_porcentaje  decimal(18,6)
  declare @ld_porcGlobal  decimal(18,6)
  declare @importe        decimal(18,6)
	declare @ld_id   				int
  declare @descuento      varchar(255)

	set @descuento = @@descuento

	-- Valido si me pasaron una lista de descuento
	if @@ld_id is null goto Fin

	if not exists (select ld_id from listadescuento where ld_id = @@ld_id) goto Fin
	
	set @ld_id = @@ld_id

	set @ld_porcGlobal = 0

	-- Busco un descuento
	select 
					@ldi_id 				= ldi_id, 
					@importe  			= ldi_importe,
					@ld_porcentaje 	= ldi_porcentaje
	from 
					listadescuentoitem 
	where 
					ld_id 	= @ld_id
		and		pr_id 	= @@pr_id

	select @ld_porcGlobal = ld_porcentaje from listadescuento where ld_id = @ld_id

	set @ld_porcGlobal = isnull(@ld_porcGlobal,0)
	set @ld_porcentaje = isnull(@ld_porcentaje,0)
  set @importe       = isnull(@importe,0)

	if @ld_porcGlobal > 0 
		set @descuento = @descuento + ' +' + convert(varchar(10),convert(money,@ld_porcGlobal),1) +'%'

	if @importe > 0
		set @descuento = @descuento + ' + $' + convert(varchar(10),convert(money,@importe),1)

	if @ld_porcentaje > 0
		set @descuento = @descuento + ' +' + convert(varchar(10),convert(money,@ld_porcentaje),1)+'%'


	if @ld_porcGlobal < 0 
		set @descuento = @descuento + ' - ' + convert(varchar(10),convert(money,@ld_porcGlobal),1) +'%'

	if @importe < 0
		set @descuento = @descuento + ' -' + convert(varchar(10),convert(money,@importe),1)

	if @ld_porcentaje < 0
		set @descuento = @descuento + ' -' + convert(varchar(10),convert(money,@ld_porcentaje),1)+'%'

	select @ld_id = ld_id_padre from listadescuento where ld_id = @ld_id

	if @ld_id is null goto Fin

	exec sp_ldGetDescuentoStr @ld_id, @@pr_id, @descuento out

Fin:

	select @@descuento = @descuento

	if @@select <> 0 select @descuento

end
