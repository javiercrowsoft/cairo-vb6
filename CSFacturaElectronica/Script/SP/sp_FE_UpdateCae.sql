if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_UpdateCae]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_UpdateCae]

/*

 sp_FE_UpdateCae 113258, '61171391488212','25','20110505'

select * from facturaventa where fv_id = 113258

*/

go
create procedure [dbo].[sp_FE_UpdateCae] (
	@@fv_id int,
	@@fv_cae varchar(50),
	@@fv_cae_nrodoc varchar(50),
	@@fv_cae_vto varchar(50),
	@@fv_fecha datetime
)
as

begin

	set nocount on

	declare @dif_fecha int

	select @dif_fecha = datediff(d,fv_fecha,@@fv_fecha) from FacturaVenta where fv_id = @@fv_id

	update FacturaVenta 
				set fv_cae = @@fv_cae, 
						fv_cae_nrodoc = @@fv_cae_nrodoc, 
						fv_cae_vto = @@fv_cae_vto,
            fv_fecha = @@fv_fecha,
            fv_fechaiva = @@fv_fecha
	where fv_id = @@fv_id

	if @dif_fecha > 0 begin

		update FacturaVentaDeuda set fvd_fecha = dateadd(d, @dif_fecha, fvd_fecha) where fv_id = @@fv_id

	end

	declare @fv_nrodoc varchar(50)
	declare @doct_id int
	declare @emp_id int

	select @fv_nrodoc = substring(fv_nrodoc,1,2) 
											+ right('0000'+convert(varchar,dbo.FEGetPuntoVta(fv_id)),4)
											+ '-' + right('00000000'+fv_cae_nrodoc,8),
				 @doct_id = doct_id,
				 @emp_id = emp_id
	from FacturaVenta
	where fv_id = @@fv_id

	-- Compruebo que no voy a violar el indice
	--
	if not exists(select 1 from FacturaVenta 
								where fv_nrodoc = @fv_nrodoc 
									and doct_id = @doct_id 
									and emp_id = @emp_id
									and fv_id <> @@fv_id)
	begin

		update FacturaVenta set fv_nrodoc = @fv_nrodoc where fv_id = @@fv_id

	end

	delete FacturaElectronica where fv_id = @@fv_id

end

go