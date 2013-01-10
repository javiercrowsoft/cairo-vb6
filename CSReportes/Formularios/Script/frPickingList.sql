if exists (select * from sysobjects where id = object_id(N'[dbo].[frPickingList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frPickingList]

go

/*

exec frPickingList 12

*/

create procedure frPickingList (

  @@pkl_id   int

)
as

begin

  set nocount on

  set nocount on

  select 

          pkl_nrodoc,
          pkl_fecha,

          

          case when pr_ventastock <> 0 then convert
                                            (
                                              decimal(18,2),

                                              convert(
                                                      decimal(18,2),
                                                      convert(int,sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))*pr_ventastock+0.0001)
                                                      )
                                              +
                                                (  sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))
                                                  -    round(1.0 / pr_ventastock,2)
                                                    * convert(int,sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))*pr_ventastock+0.0001)
                                                ) / 100
                                            )

               else                         sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))

          end  as cantidad_stock,


          case when pr_ventastock <> 0 then convert(int,sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))*pr_ventastock+0.0001)
               else                         sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))

          end  as cajas,

          case when pr_ventastock <> 0 then (  sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))
                                              -    round(1.0 / pr_ventastock,2)
                                              * convert(int,sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir))*pr_ventastock+0.0001)
                                            )
               else                         0

          end  as unidades,

          sum(isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir)) as uni_total,

          pr_codigo,
          pr_nombreventa,

          rub_nombre

  from 
        PickingListPedido pklpv inner join PickingList pkl on pklpv.pkl_id = pkl.pkl_id

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

                       left  join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id

                       left  join PickingListPedidoItem pklpvi on   pklpv.pklpv_id = pklpvi.pklpv_id
                                                                and pvi.pvi_id = pklpvi.pvi_id

                       left  join Producto pr on pvi.pr_id = pr.pr_id
                       left  join CentroCosto ccos on pvi.ccos_id = ccos.ccos_id
                       left  join Rubro rub on pr.rub_id = rub.rub_id

  where 
          pklpv.pkl_id = @@pkl_id        


  group by   pkl_nrodoc,   
            pkl_fecha,        
            rub_nombre,
            pr_codigo,
            pr_nombreventa,
            pr_ventastock
  
  order by rub_nombre, pr_nombreventa

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

