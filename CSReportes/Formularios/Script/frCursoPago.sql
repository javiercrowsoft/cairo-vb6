/*

select max(cur_id) from curso

frCursoPago 41662

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frCursoPago]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frCursoPago]

go
create procedure frCursoPago (

	@@cur_id int

)as 

begin

	set nocount on

	create table #t_pagos(	curi_id 					int,
													producto          varchar(255) not null default(''),
													importe           decimal(18,6) not null default(0),
													efectivo					decimal(18,6) not null default(0),
													cheque            decimal(18,6) not null default(0),
													tarjeta   				decimal(18,6) not null default(0),
													otros   					decimal(18,6) not null default(0),
													cheque_descrip 	  varchar(1000) not null default(''),
													tarjeta_descrip 	varchar(1000) not null default(''),
													otros_descrip     varchar(1000) not null default('')
												)

	declare c_pagos insensitive cursor for 
		select 	curi_id, 
						cobzi_importe, 
						cobzi_tipo, 
						tjc_nombre,
						tjccu_cantidad,
						cheq_numerodoc,
						bco_nombre,
						cue_nombre,
						pr_nombreventa,
						fvi_importe

		from CursoItem curi inner join FacturaVenta fv on curi.fv_id = fv.fv_id
												left join FacturaVentaItem fvi on fv.fv_id = fvi.fv_id
												left join Producto pr on fvi.pr_id = pr.pr_id
												left join FacturaVentaDeuda fvd on fv.fv_id = fvd.fv_id
												left join FacturaVentaPago fvp on fv.fv_id = fvp.fv_id
												left join FacturaVentaCobranza fvcobz on 			fvd.fvd_id = fvcobz.fvd_id
																																	or	fvp.fvp_id = fvcobz.fvp_id

												left join Cobranza cobz on fvcobz.cobz_id = cobz.cobz_id
												left join CobranzaItem cobzi on cobz.cobz_id = cobzi.cobz_id
																												and cobzi_tipo <> 5

												left join TarjetaCreditoCupon tjcc on cobzi.tjcc_id = tjcc.tjcc_id
												left join TarjetaCreditoCuota tjccu on tjcc.tjccu_id = tjccu.tjccu_id
												left join TarjetaCredito tjc on tjcc.tjc_id = tjc.tjc_id
												left join Cheque cheq on cobzi.cheq_id = cheq.cheq_id
												left join Banco bco on cheq.bco_id = bco.bco_id
												left join Cuenta cue on cobzi.cue_id = cue.cue_id
	
		where curi.cur_id = @@cur_id
			and pr.cur_id = @@cur_id
		order by curi_id

	declare @n tinyint
	declare @curi_id int
	declare @last_curi_id int
	declare @cobzi_importe decimal(18,6)
	declare @cobzi_tipo tinyint
	declare @tjc_nombre varchar(255)
	declare @tjccu_cantidad int
	declare @bco_nombre varchar(255)
	declare @cheq_numerodoc varchar(255)
	declare @cue_nombre varchar(255)
	declare @pr_nombre varchar(255)
	declare @importe decimal(18,6)

	set @n = 1
	set @last_curi_id = 0

	open c_pagos

	fetch next from c_pagos into @curi_id, @cobzi_importe, @cobzi_tipo, @tjc_nombre, 
																@tjccu_cantidad, @bco_nombre, @cheq_numerodoc, @cue_nombre, 
																	@pr_nombre, @importe
	while @@fetch_status= 0
	begin

		if @last_curi_id <> @curi_id begin
			set @n = @n+1
			set @last_curi_id = @curi_id 
		end

		if not exists(select * from #t_pagos where curi_id = @curi_id)
		begin
			insert into #t_pagos (curi_id, producto, importe) 
										 values(@curi_id, @pr_nombre, @importe)
		end

		if @cobzi_tipo = 1 begin -- cheque
			update #t_pagos set cheque = cheque + @cobzi_importe,
													cheque_descrip = cheque_descrip + @bco_nombre + ' [cheque: ' + @cheq_numerodoc +'],'
			where curi_id = @curi_id
		end

		if @cobzi_tipo = 2 begin -- efectivo
			update #t_pagos set efectivo = efectivo + @cobzi_importe
			where curi_id = @curi_id
		end

		if @cobzi_tipo = 3 begin -- tarjeta
			update #t_pagos set tarjeta = tarjeta + @cobzi_importe,
													tarjeta_descrip = tarjeta_descrip + @tjc_nombre + ' [' + convert(varchar,@tjccu_cantidad) + case when @tjccu_cantidad = 1 then ' cuota],' else ' cuotas],' end
			where curi_id = @curi_id
		end

		if @cobzi_tipo = 4 begin -- tarjeta
			update #t_pagos set otros = otros + @cobzi_importe,
													otros_descrip = otros_descrip + @cue_nombre + ','
			where curi_id = @curi_id
		end

		fetch next from c_pagos into @curi_id, @cobzi_importe, @cobzi_tipo, @tjc_nombre, 
																	@tjccu_cantidad, @bco_nombre, @cheq_numerodoc, @cue_nombre, 
																		@pr_nombre, @importe
	end

	close c_pagos
	deallocate c_pagos

	update #t_pagos 
			set tarjeta_descrip	= case when len(tarjeta_descrip)>1 	then left(tarjeta_descrip,len(tarjeta_descrip)-1) else tarjeta_descrip 	end,
					cheque_descrip	= case when len(cheque_descrip)>1 	then left(cheque_descrip,len(cheque_descrip)-1) 	else cheque_descrip 	end,
					otros_descrip		= case when len(otros_descrip)>1 		then left(otros_descrip,len(otros_descrip)-1) 		else otros_descrip 		end

	select 	cur.*, 
					curi.*, 
					alum.*,
					alump.*,
					datediff(yy,alump.prs_fechaNac,getdate())  as Edad,
					alump.prs_apellido +', '+alump.prs_nombre as Alumno, 
					profp.prs_apellido +', '+profp.prs_nombre as Profesor,
					tutp.prs_apellido  +', '+tutp.prs_nombre  as Tutor,
					alump.prs_telCasa		as alumno_telefono,
					alump.prs_email			as alumno_email,
					alump.prs_celular		as alumno_celular,
					#t_pagos.*,
					mat_nombre

  from 	Curso cur		left join CursoItem curi 	on cur.cur_id 		= curi.cur_id	
										left join Alumno alum 		on curi.alum_id 	= alum.alum_id
										left join Profesor prof 	on cur.prof_id 	  = prof.prof_id
										left join Profesor tut 	  on curi.prof_id 	= tut.prof_id
										left join Persona alump 	on alum.prs_id 		= alump.prs_id
										left join Persona profp 	on prof.prs_id 		= profp.prs_id
										left join Persona tutp 		on tut.prs_id 		= tutp.prs_id
										left join #t_pagos 			  on curi.curi_id 	= #t_pagos.curi_id
										left join Materia mat     on cur.mat_id     = mat.mat_id


	where cur.cur_id = @@cur_id
  order by Alumno
end
go