if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponGetItems]

go

/*

ResolucionCupon                   reemplazar por el nombre del documento Ej. PedidoVenta
@@rcup_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
ResolucionCupon                 reemplazar por el nombre de la tabla ej PedidoVenta
rcup_id                     reemplazar por el campo ID ej. pv_id
de la resolucion de cupones                  reemplazar por el texto de error ej. del pedido de venta

sp_DocResolucionCuponGetItems 1

*/
create procedure sp_DocResolucionCuponGetItems (
	@@rcup_id int
)
as

begin

	select 	rci.*, 
					cuepre.cue_nombre as cue_presentado,
          cuepre.cue_id     as cue_id_presentado,

          cuebco.cue_nombre,
          cuebco.cue_id,
  
          cuebcot.cue_nombre as cue_banco,
          cuebcot.cue_id     as cue_id_banco,

          cuerech.cue_nombre as cue_rechazo,
          cuerech.cue_id     as cue_id_rechazo,

          tjcc_numero,
          tjcc_numerodoc,
          tjc_nombre,
          tjc_comision,
          tjccu_comision,
          tjccu_cantidad,
          bco_nombre

	from 	ResolucionCuponItem rci
        inner join TarjetaCreditoCupon tjcc     on rci.tjcc_id         = tjcc.tjcc_id
        inner join TarjetaCreditoCuota tjccu    on tjcc.tjccu_id       = tjccu.tjccu_id
				inner join Cuenta  cuebco					      on rci.cue_id          = cuebco.cue_id
        inner join DepositoCuponItem dcupi      on tjcc.tjcc_id        = dcupi.tjcc_id
				inner join Cuenta  cuepre					      on dcupi.cue_id        = cuepre.cue_id
        inner join TarjetaCredito tjc				    on tjcc.tjc_id         = tjc.tjc_id
        inner join Cuenta cuebcot               on tjc.cue_id_banco    = cuebcot.cue_id
        inner join Cuenta cuerech               on tjc.cue_id_rechazo  = cuerech.cue_id
        left  join Banco                        on cuebco.bco_id       = Banco.bco_id
	where 
			rcup_id = @@rcup_id

	order by rcupi_orden
end
go