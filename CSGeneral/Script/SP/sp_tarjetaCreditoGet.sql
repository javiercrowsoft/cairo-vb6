if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tarjetaCreditoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tarjetaCreditoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_tarjetaCreditoGet 2

create procedure sp_tarjetaCreditoGet (
	@@tjc_id	int
)
as

set nocount on

begin

	select
					t.*,
					e.emp_nombre        as emp_nombre,

          c1.cue_id						as cue_id_encartera,
          c1.cue_nombre       as cuentaEnCartera,

          c2.cue_id						as cue_id_banco,
          c2.cue_nombre       as cuentaBanco,

          c3.cue_id						as cue_id_rechazo,
          c3.cue_nombre       as cuentaRechazo,

          c4.cue_id						as cue_id_presentado,
          c4.cue_nombre       as cuentaPresentado,

          c5.cue_id						as cue_id_comision,
          c5.cue_nombre       as cuentaComision

	from

					TarjetaCredito t  inner join Cuenta c1 on t.cue_id_encartera 	= c1.cue_id
														inner join Cuenta c2 on t.cue_id_banco      = c2.cue_id
                            inner join Cuenta c3 on t.cue_id_rechazo    = c3.cue_id
                            inner join Cuenta c4 on t.cue_id_presentado = c4.cue_id
                            inner join Cuenta c5 on t.cue_id_comision   = c5.cue_id
														inner join Empresa e on t.emp_id            = e.emp_id

	where t.tjc_id = @@tjc_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



