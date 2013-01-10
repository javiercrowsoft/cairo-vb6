if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetCueDeudor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetCueDeudor]

go

/*

Proposito: Devuelve la cuenta deudor por Compras de 
           la factura para ser utilizada en la interfaz 
           de aplicacion de documentos de Compra.

select * from facturaCompra

exec sp_DocFacturaCompraGetCueDeudor 1

*/

create procedure sp_DocFacturaCompraGetCueDeudor (
  @@fc_id     int
)
as

begin

  declare @cue_deudoresXcpra int 
  set @cue_deudoresXcpra = 8

  select

      c.cue_id

  from AsientoItem inner join FacturaCompra             on AsientoItem.as_id    = FacturaCompra.as_id
                   inner join Cuenta c                  on AsientoItem.cue_id   = c.cue_id
  where 
          asi_haber       <> 0
    and   cuec_id       =  @cue_deudoresXcpra
    and   fc_id         =  @@fc_id

  group by fc_id,c.cue_id,cue_nombre

end
go


