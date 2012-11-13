if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PercepcionGetByPorcentaje]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PercepcionGetByPorcentaje]

/*

*/

go
create procedure sp_PercepcionGetByPorcentaje (
	@@perct_id int,
	@@porc     decimal(18,6),
	@@pro_id   int
)
as

begin

	select perc.perc_id
	from Percepcion perc inner join PercepcionItem perci on perc.perc_id = perci.perc_id
	where (perct_id = @@perct_id or perc_esiibb <> 0)
		and perci_porcentaje = @@porc
		and exists(select * from PercepcionProvincia where pro_id = @@pro_id and perc_id = perc.perc_id)

end

go