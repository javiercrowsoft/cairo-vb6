if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_GetTributosForFactura]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_GetTributosForFactura]

/*
 select * from percepciontipo
 select * from facturaventapercepcion where fv_id = 84
 select * from percepcion where perc_id in (2,1)
 [sp_FE_GetTributosForFactura] 84

*/

go
create procedure [dbo].[sp_FE_GetTributosForFactura] (
	@@fv_id int
)

as

begin

	select 	convert(decimal(18,2),round(fvperc_porcentaje,2)) as alic,
					perct_codigosicore as tribId,
					convert(decimal(18,2),round(sum(fvperc_base),2)) as baseImp,
					convert(decimal(18,2),round(sum(fvperc_importe),2)) as importe
	from FacturaVentaPercepcion fvperc 
  inner join Percepcion perc on fvperc.perc_id = perc.perc_id 
  inner join PercepcionTipo perct on perc.perct_id = perct.perct_id
	where fv_id = @@fv_id
  group by perct_codigosicore, fvperc_porcentaje

end
