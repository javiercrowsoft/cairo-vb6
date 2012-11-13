if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_cuponGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cuponGetData]

go

/*
select * from cuenta where cue_id = 155
update cuenta set bco_id=1 where cue_id = 155
select * from banco
select * from tarjetacreditocupon
select * from cheque where cheq_numerodoc='9999'

sp_cuponGetData 3

*/
create procedure sp_cuponGetData (
	@@tjcc_id int
)
as

begin

	select 
						bco_nombre, 
						tcuepre.cue_nombre         as cue_presentado, 
						tcuepre.cue_id             as cue_id_presentado, 
            tcuecartera.cue_nombre     as cue_encartera,
            tcuecartera.cue_id         as cue_id_encartera,

            tcuecomi.cue_nombre     as cue_comision,
            tcuecomi.cue_id         as cue_id_comision,
            tcuerech.cue_nombre     as cue_rechazo,
            tcuerech.cue_id         as cue_id_rechazo,

            tcuebco.cue_id          as cue_id_banco,
            tcuebco.cue_nombre      as cue_banco,

						cli_nombre,
						banco.bco_id, 
            tjcc_numerodoc,
						tjcc_importe, 
						tjcc_importeorigen,
            tjcc_fechavto,
            tjccu_cantidad,
            tjccu_comision,
            tjc_comision
	from 
				TarjetaCreditoCupon tc  inner join TarjetaCredito t           on tc.tjc_id             = t.tjc_id
                                inner join TarjetaCreditoCuota tcc    on tc.tjccu_id           = tcc.tjccu_id
                                inner join Cuenta tcuepre             on t.cue_id_presentado   = tcuepre.cue_id
                                inner join Cuenta tcuecartera         on t.cue_id_encartera    = tcuecartera.cue_id
                                inner join Cuenta tcuerech            on t.cue_id_rechazo      = tcuerech.cue_id
                                inner join Cuenta tcuecomi            on t.cue_id_comision     = tcuecomi.cue_id
                                inner join Cuenta tcuebco             on t.cue_id_banco        = tcuebco.cue_id
                                inner join banco                      on tcuepre.bco_id        = banco.bco_id
							              		left  join cliente                    on tc.cli_id             = cliente.cli_id

	where tjcc_id = @@tjcc_id

end