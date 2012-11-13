if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_help_TarifaItemEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_help_TarifaItemEx]

go

/*

sp_help_TarifaItemEx 6,500,5

*/
create procedure sp_help_TarifaItemEx (
	@@trfi_id					int,
  @@kilos  	        decimal(18,6),
  @@volumen         decimal(18,6)
)
as
begin
	set nocount on

	set @@volumen = @@volumen * 166.67 
	if @@volumen > @@kilos   set @@kilos = @@volumen

	select 
			@@kilos       				as Kilos,
			Transporte.trans_id,
      trans_nombre,
			trfi_minimo,
			case 
				when    @@kilos <= 45   then trfi_menos45
				when    @@kilos > 45 
            and @@kilos <= 100  then trfi_mas45
				when		@@kilos >  100  
						and	@@kilos <= 300  then trfi_mas100
				when		@@kilos >  300  
						and	@@kilos <= 500  then trfi_mas300
				when		@@kilos >  500  
						and	@@kilos <= 1000 then trfi_mas500
				when		@@kilos >  1000 then trfi_mas1000
				end as tarifa

	from TarifaItem inner join Tarifa     on TarifaItem.trf_id   = Tarifa.trf_id
									inner join Transporte on Tarifa.trans_id     = Transporte.trans_id

    and trfi_id = @@trfi_id

end

go