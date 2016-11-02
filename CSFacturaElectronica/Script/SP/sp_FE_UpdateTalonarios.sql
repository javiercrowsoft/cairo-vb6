if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_UpdateTalonarios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_UpdateTalonarios]

/*

  sp_FE_UpdateTalonarios

*/

go
create procedure [dbo].[sp_FE_UpdateTalonarios] 

as

begin

	set nocount on

	exec sp_FE_UpdateConsultaTalonarios ''

	exec sp_cfg_setvalor 'Ventas-General', 'Update Talonarios AFIP', '1', null

	declare @cfg_valor varchar(5000) 

	declare @n int
	set @n = 1
	set @cfg_valor = ''

	-- Cada 3 segundos veo si ya procese la factura (lo hago durante 1 minuto)
	--
	while @n < 20 /* 1 minuto */ and @cfg_valor = ''
	begin

	exec sp_cfg_getvalor  'Ventas-General',
											  'Update Talonarios AFIP-Respuesta',
											  @cfg_valor out,
											  0,
												null

		exec sp_sleep '000:00:03'
		set @n = @n +1

	end

	set @cfg_valor = isnull(@cfg_valor,'')

	if @cfg_valor = '' set @cfg_valor = 'Los talonarios no pudieron ser actualizados'

  select @cfg_valor as info

end
