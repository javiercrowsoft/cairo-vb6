if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaAddFvId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaAddFvId]

go

/*

begin tran
exec sp_HojaRutaAddFvId 21,456
rollback tran

*/

create procedure sp_HojaRutaAddFvId (
	@@hr_id int,
	@@fv_id int
)
as

set nocount on

begin

	declare @hri_id int
	declare @fv_total decimal(18,6)

	select @fv_total = case when doct_id = 7 then 0 
													else 									fv_total 
										 end 
	from FacturaVenta where fv_id = @@fv_id		

	exec sp_dbgetnewid 'HojaRutaItem','hri_id', @hri_id out, 0

	insert into HojaRutaItem (
														 hri_id
														,est_id
														,fv_id
														,hr_id
														,hri_acobrar
														,hri_cobrado
														,hri_descrip
														,cont_id
														,hri_importe
														,hri_orden
														,os_id
														,ptd_id
														,rv_id
														)
										values (
														 @hri_id
														,1 --est_id
														,@@fv_id
														,@@hr_id
														,@fv_total
														,0 --hri_cobrado
														,'' --hri_descrip
														,null --cont_id
														,0 --hri_importe
														,0 --hri_orden
														,null --os_id
														,null --ptd_id
														,null --rv_id
														)

	declare @hr_total decimal(18,6)

	select @hr_total = sum(hri_importe) from HojaRutaItem where hr_id = @@hr_id

	update HojaRuta set hr_total = @hr_total where hr_id = @@hr_id

	
end

go