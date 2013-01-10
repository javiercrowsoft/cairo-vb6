/*

sp_lsdoc_Curso 

                    1,
                    '20000101',
                    '20100101',
                    '20100101',
                    '0',
                    '0',
                    '0'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Curso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Curso]

GO
create procedure sp_lsdoc_Curso (

  @@cur_id    int

)as 

set nocount on 

select 

        cur_id,              
        ''                      as [TypeTask],

        cur_nombre              as Nombre,

        cur_codigo              as Codigo,

        mat_nombre              as Materia,

        prsp.prs_apellido + ', ' + prsp.prs_nombre             
                                as Profesor,

        cur_desde               as Desde,
        cur_hasta               as Hasta,

        us_nombre                as [Modifico],
        cur.creado              as [Creado],
        cur.modificado          as [Modificado],
        cur_descrip              as [Observaciones]

from 

      Curso cur    inner join Usuario                 on cur.modifico   = Usuario.us_id
                   left  join Profesor prof            on cur.prof_id     = prof.prof_id
                   left  join Persona prsp            on prof.prs_id     = prsp.prs_id
                   left  join Materia mat             on cur.mat_id     = mat.mat_id
where 

  cur.cur_id = @@cur_id

GO