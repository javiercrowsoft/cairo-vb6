if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponGetItems]

go

/*

DepositoCupon                   reemplazar por el nombre del documento Ej. PedidoVenta
@@dcup_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
DepositoCupon                 reemplazar por el nombre de la tabla ej PedidoVenta
dcup_id                     reemplazar por el campo ID ej. pv_id
de la presentacion de cupones                  reemplazar por el texto de error ej. del pedido de venta

sp_DocDepositoCuponGetItems 1

*/
create procedure sp_DocDepositoCuponGetItems (
  @@dcup_id int
)
as

begin

  select   dci.*, 
          cuecar.cue_nombre as cue_encartera,
          cuecar.cue_id     as cue_id_encartera,
          cuepre.cue_nombre as cue_presentado,
          cuepre.cue_id     as cue_id_presentado,
          tjcc_numero,
          tjcc_numerodoc,
          tjc_nombre,
          bco_nombre

  from   DepositoCuponItem dci
        inner join TarjetaCreditoCupon tjcc     on dci.tjcc_id   = tjcc.tjcc_id
        inner join Cuenta  cuepre                on dci.cue_id    = cuepre.cue_id
        inner join CobranzaItem cbi             on tjcc.tjcc_id  = cbi.tjcc_id
        inner join Cuenta  cuecar                on cbi.cue_id   = cuecar.cue_id
        inner join TarjetaCredito tjc            on tjcc.tjc_id   = tjc.tjc_id
        inner join Banco                        on cuepre.bco_id = Banco.bco_id
  where 
      dcup_id = @@dcup_id

  order by dcupi_orden
end
go