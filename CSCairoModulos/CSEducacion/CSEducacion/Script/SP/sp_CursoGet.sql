SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_CursoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CursoGet]
GO

/*

sp_CursoGet 1

*/

create procedure sp_CursoGet
(
  @@cur_id   int
)
as
begin

  select   cur.*,
          pprof.prs_apellido + ', ' + pprof.prs_nombre   as prof_nombre,

          pprof1.prs_apellido + ', ' + pprof1.prs_nombre   as prof_nombre1,
          pprof2.prs_apellido + ', ' + pprof2.prs_nombre   as prof_nombre2,
          pprof3.prs_apellido + ', ' + pprof3.prs_nombre   as prof_nombre3,
          pprof4.prs_apellido + ', ' + pprof4.prs_nombre   as prof_nombre4,
          pprof5.prs_apellido + ', ' + pprof5.prs_nombre   as prof_nombre5,

          mat_nombre

  from  Curso cur    inner join Materia mat           on cur.mat_id        = mat.mat_id
                     left  join Profesor prof         on cur.prof_id   = prof.prof_id
                     left  join Persona pprof         on prof.prs_id  = pprof.prs_id

                     left  join Profesor prof1         on cur.prof_id_ayudante1   = prof1.prof_id
                     left  join Persona pprof1         on prof1.prs_id            = pprof1.prs_id
                     left  join Profesor prof2         on cur.prof_id_ayudante2   = prof2.prof_id
                     left  join Persona pprof2         on prof2.prs_id            = pprof2.prs_id
                     left  join Profesor prof3         on cur.prof_id_ayudante3   = prof3.prof_id
                     left  join Persona pprof3         on prof3.prs_id            = pprof3.prs_id
                     left  join Profesor prof4         on cur.prof_id_ayudante4   = prof4.prof_id
                     left  join Persona pprof4         on prof4.prs_id            = pprof4.prs_id
                     left  join Profesor prof5         on cur.prof_id_ayudante5   = prof5.prof_id
                     left  join Persona pprof5         on prof5.prs_id            = pprof5.prs_id

  where cur.cur_id = @@cur_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go

