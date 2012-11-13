/*

select max(cur_id) from curso

frCurso 5

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frCurso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frCurso]

go
create procedure frCurso (

	@@cur_id int

)as 

begin

	set nocount on

	create table #t_clases(	curi_id 	int,
													clase01		tinyint not null default(0),	
													clase02		tinyint not null default(0),	
													clase03		tinyint not null default(0),	
													clase04		tinyint not null default(0),	
													clase05		tinyint not null default(0),	
													clase06		tinyint not null default(0),	
													clase07		tinyint not null default(0),	
													clase08		tinyint not null default(0),	
													clase09		tinyint not null default(0),	
													clase10		tinyint not null default(0),	
													clase11		tinyint not null default(0),	
													clase12		tinyint not null default(0),	
													clase13		tinyint not null default(0),	
													clase14		tinyint not null default(0),	
													clase15		tinyint not null default(0),	
													clase16		tinyint not null default(0),	
													clase17		tinyint not null default(0),	
													clase18		tinyint not null default(0),	
													clase19		tinyint not null default(0),	
													clase20		tinyint not null default(0)
												)

	declare c_clase insensitive cursor for 
		select curc.curc_id, curia_id, curi_id 
		from CursoClase curc left join CursoItemAsistencia curia on curc.curc_id = curia.curc_id
		where curc.cur_id = @@cur_id
		order by curc_fecha, curc_desde

	declare @n tinyint
	declare @last_curc_id int
	declare @curc_id int
	declare @curi_id int
	declare @curia_id int

	set @n = 1
	set @last_curc_id = 0

	open c_clase

	fetch next from c_clase into @curc_id, @curia_id, @curi_id
	while @@fetch_status= 0
	begin

		if @last_curc_id <> @curc_id begin
			set @n = @n+1
			set @last_curc_id = @curc_id 
		end

		if not exists(select * from #t_clases where curi_id = @curi_id)
		begin
			insert into #t_clases (curi_id) values(@curi_id)
		end

		if @curia_id is not null begin

			if @n = 1  update #t_clases set clase01 = 1 where curi_id = @curi_id
			if @n = 2  update #t_clases set clase02 = 1 where curi_id = @curi_id
			if @n = 3  update #t_clases set clase03 = 1 where curi_id = @curi_id
			if @n = 4  update #t_clases set clase04 = 1 where curi_id = @curi_id
			if @n = 5  update #t_clases set clase05 = 1 where curi_id = @curi_id
			if @n = 6  update #t_clases set clase06 = 1 where curi_id = @curi_id
			if @n = 7  update #t_clases set clase07 = 1 where curi_id = @curi_id
			if @n = 8  update #t_clases set clase08 = 1 where curi_id = @curi_id
			if @n = 9  update #t_clases set clase09 = 1 where curi_id = @curi_id
			if @n = 10 update #t_clases set clase10 = 1 where curi_id = @curi_id
			if @n = 11 update #t_clases set clase11 = 1 where curi_id = @curi_id
			if @n = 12 update #t_clases set clase12 = 1 where curi_id = @curi_id
			if @n = 13 update #t_clases set clase13 = 1 where curi_id = @curi_id
			if @n = 14 update #t_clases set clase14 = 1 where curi_id = @curi_id
			if @n = 15 update #t_clases set clase15 = 1 where curi_id = @curi_id
			if @n = 16 update #t_clases set clase16 = 1 where curi_id = @curi_id
			if @n = 17 update #t_clases set clase17 = 1 where curi_id = @curi_id
			if @n = 18 update #t_clases set clase18 = 1 where curi_id = @curi_id
			if @n = 19 update #t_clases set clase19 = 1 where curi_id = @curi_id
			if @n = 20 update #t_clases set clase20 = 1 where curi_id = @curi_id

		end

		fetch next from c_clase into @curc_id, @curia_id, @curi_id
	end

	close c_clase
	deallocate c_clase

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
					#t_clases.*,
					mat_nombre

  from 	Curso cur		left join CursoItem curi 	on cur.cur_id 		= curi.cur_id	
										left join Alumno alum 		on curi.alum_id 	= alum.alum_id
										left join Profesor prof 	on cur.prof_id 	  = prof.prof_id
										left join Profesor tut 	  on curi.prof_id 	= tut.prof_id
										left join Persona alump 	on alum.prs_id 		= alump.prs_id
										left join Persona profp 	on prof.prs_id 		= profp.prs_id
										left join Persona tutp 		on tut.prs_id 		= tutp.prs_id
										left join #t_clases 			on curi.curi_id 	= #t_clases.curi_id
										left join Materia mat     on cur.mat_id     = mat.mat_id


	where cur.cur_id = @@cur_id
  order by Alumno
end
go