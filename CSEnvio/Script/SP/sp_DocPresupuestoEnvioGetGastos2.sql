if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioGetGastos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioGetGastos2]

go

/*

select * from tarifagasto

sp_DocPresupuestoEnvioGetGastos2 1

*/
create procedure sp_DocPresupuestoEnvioGetGastos2 (
	@@trfi_id int
)
as

begin

	declare @valor 			varchar(255)
  declare @pr_id 			int
  declare @pr_nombre 	varchar(255)
	
	exec sp_Cfg_GetValor 'Envio','Producto Gasto',@valor out

	if isnumeric(@valor) <> 0 	begin
															select @pr_id = convert(int,@valor)		
															select @pr_nombre = pr_nombreventa from producto where pr_id = @pr_id
	end
	else												select @pr_id = 0

	select 	TarifaGasto.*, 
					@pr_id 					as pr_id,
					@pr_nombre 			as pr_nombreventa,
          trans_id,
          gto_nombre

	from 	TarifaGasto inner join Tarifa 			on TarifaGasto.trf_id = Tarifa.trf_id
                    inner join TarifaItem 	on Tarifa.trf_id      = TarifaItem.trf_id
										inner join Gasto        on TarifaGasto.gto_id = Gasto.gto_id
	where 
			trfi_id = @@trfi_id

end