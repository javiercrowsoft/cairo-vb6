if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetPercepciones]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetPercepciones]

go

/*

sp_DocFacturaCompraGetPercepciones 1

*/
create procedure sp_DocFacturaCompraGetPercepciones (
	@@fc_id int
)
as

begin

	select 	FacturaCompraPercepcion.*, 
					perc_nombre, 
          ccos_nombre

	from 	FacturaCompraPercepcion
				inner join Percepcion 						on FacturaCompraPercepcion.perc_id = Percepcion.perc_id
        left join centrocosto as ccos 		on FacturaCompraPercepcion.ccos_id = ccos.ccos_id
	where 
			fc_id = @@fc_id

	order by fcperc_orden
end