if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetCueDeudor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetCueDeudor]

go

/*

Proposito: Devuelve la cuenta deudor por ventas de 
           la factura para ser utilizada en la interfaz 
					 de aplicacion de documentos de venta.

select * from facturaventa

exec sp_DocFacturaVentaGetCueDeudor 20

*/

create procedure sp_DocFacturaVentaGetCueDeudor (
	@@fv_id 		int
)
as

begin

	declare @cue_deudoresXvta int 
	set @cue_deudoresXvta = 4

	select

      c.cue_id

  from AsientoItem inner join FacturaVenta 						on AsientoItem.as_id		= FacturaVenta.as_id
									 inner join Cuenta c                on AsientoItem.cue_id 	= c.cue_id
  where 
					asi_debe 			<> 0
    and   cuec_id 			=  @cue_deudoresXvta
		and   fv_id         =  @@fv_id

  group by fv_id,c.cue_id,cue_nombre

end
go