if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListGetItemsPedidos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListGetItemsPedidos]

go

/*

exec sp_PickingListGetItemsPedidos 1

*/

create procedure sp_PickingListGetItemsPedidos (

  @@pkl_id   int

)
as

begin

  set nocount on

  select 
          pklpv.pklpv_id,
          pklpv.pv_id,
          pklpv_descrip,
          pv_fecha,
          pv_nrodoc,
          pv_total,
          pv_pendiente,
          pv.cli_id,
          pv.est_id   as est_id_pedido,

          '*) ' +
          cli.cli_nombre + ' - ' +

          case
               when clispv.clis_calle <> '' then

                    clispv.clis_calle + ' ' +
                    clispv.clis_callenumero + ' ' +
                    clispv.clis_piso + ' ' +
                    clispv.clis_depto + ' (' +
                    clispv.clis_codpostal + ') ' +
                    clispv.clis_localidad + ' - ' +
                    clispv.clis_tel + ' - ' +
                    clispv.clis_contacto

               when clis.clis_calle <> '' then

                    clis.clis_calle + ' ' +
                    clis.clis_callenumero + ' ' +
                    clis.clis_piso + ' ' +
                    clis.clis_depto + ' (' +
                    clis.clis_codpostal + ') ' +
                    clis.clis_localidad + ' - ' +
                    clis.clis_tel + ' - ' +
                    clis.clis_contacto

               else

                    cli_calle + ' ' +
                    cli_callenumero + ' ' +
                    cli_piso + ' ' +
                    cli_depto + ' (' +
                    cli_codpostal + ') ' +
                    cli_localidad + ' - ' +
                    cli_tel + ' - ' +
                    cli_contacto

          end as cli_nombre,

          pklpv_orden

  from 
        PickingListPedido pklpv 

                         inner join PedidoVenta pv on pklpv.pv_id = pv.pv_id
                         inner join Cliente cli on pv.cli_id = cli.cli_id

                         -- Sucursal de entrega del cliente
                         --
                         left  join ClienteSucursal clis on   pv.cli_id = clis.cli_id 
                            -- El codigo debe ser "e" para que el sistema la tome 
                            -- como sucursal de entrega 
                                                          and clis_codigo = 'e' 
                            -- El documento no debe indicar una sucursal
                                                          and pv.clis_id is null 

                         -- Sucursal explicitamente indicada en la orden de servicio
                         --
                       left  join ClienteSucursal clispv on pv.clis_id = clispv.clis_id

  where 
          pklpv.pkl_id = @@pkl_id        

  order by cli_nombre+cli_codigo, pklpv_orden, pv_fecha, pv.pv_id

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

