if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetProyectoHoras]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetProyectoHoras]

go

/*

exec sp_DocFacturaVentaGetProyectoHoras '1,2,3,4,5,6'

*/

create procedure sp_DocFacturaVentaGetProyectoHoras (
	@@strIds 					  varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				hora_id,
				proy.proy_id,
				proy_nombre,

        isnull(pproyp.pr_nombreventa,pproy.pr_nombreventa) as pr_nombreventa,
        isnull(pproyp.pr_id,pproy.pr_id)									 as pr_id,

				hora_horas,
				hora_minutos,
        hora_pendiente,
        hora_titulo,

				isnull(proyp_precio,0) 
				* (1+ isnull(tiri.ti_porcentaje,0)/100)  as proyp_precioiva,

        hora_pendiente 
				* (isnull(proyp_precio,0) 
				* (1+ isnull(tiri.ti_porcentaje,0)/100)) as hora_importe,

        isnull(proyp_precio,0) 							as proyp_precio2,
        0																		as proyp_precio,
				0																		as hora_descuento,

				tiri.ti_porcentaje                       as hora_ivariporc,
				tirni.ti_porcentaje                      as hora_ivarniporc				

  from proyecto proy  inner join hora  								on hora.proy_id  = proy.proy_id
											inner join TmpStringToTable			on proy.proy_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
											inner join usuario us           on hora.us_id    = us.us_id

											left  join proyectoPrecio proyp  on 		proy.proy_id = proyp.proy_id
																													and us.us_id = proyp.us_id

                      left  join producto pproy        on proy.pr_id   = pproy.pr_id
                      left  join producto pproyp       on proyp.pr_id  = pproyp.pr_id
										  left  join tasaImpositiva tiri   on pproyp.ti_id_ivariventa  = tiri.ti_id
										  left  join tasaImpositiva tirni  on pproyp.ti_id_ivarniventa = tirni.ti_id
	where 
          hora_pendiente > 0
		and   hora_facturable <> 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				proy_nombre
end
go