/*

select * from materia order by mat_nombre

sp_lsdoc_Alumnos 

                    1,
                    '20000101',
                    '20100101',
                    '20100101',
                    '0',
                    '22',
                    '0',
                    '',
                    ''
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Alumnos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Alumnos]

GO
create procedure sp_lsdoc_Alumnos (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,
  @@Fvto      datetime,

@@prof_id       varchar(255),
@@mat_id_si      varchar(255),
@@mat_id_no      varchar(255),
@@codigo        varchar(255),
@@apellido      varchar(255)

)as 

set nocount on 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

set @@codigo   = replace(@@codigo,'*','%')
set @@apellido = replace(@@apellido,'*','%')

declare @prof_id int
declare @mat_id_si int
declare @mat_id_no int

declare @ram_id_profesor int
declare @ram_id_materia_si int
declare @ram_id_materia_no int

declare @clienteID     int
declare @clienteID2   int
declare @IsRaiz        tinyint

exec sp_ArbConvertId @@prof_id, @prof_id out, @ram_id_profesor out
exec sp_ArbConvertId @@mat_id_si, @mat_id_si out, @ram_id_materia_si out
exec sp_ArbConvertId @@mat_id_no, @mat_id_no out, @ram_id_materia_no out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteID2 out

if @ram_id_profesor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_profesor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_profesor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_profesor, @clienteID 
  end else 
    set @ram_id_profesor = 0
end

if @ram_id_materia_si <> 0 begin

--  exec sp_ArbGetGroups @ram_id_materia_si, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_materia_si, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_materia_si, @clienteID 
  end else 
    set @ram_id_materia_si = 0
end

if @ram_id_materia_no <> 0 begin

--  exec sp_ArbGetGroups @ram_id_materia_no, @clienteID2, @@us_id

  exec sp_ArbIsRaiz @ram_id_materia_no, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_materia_no, @clienteID2 
  end else 
    set @ram_id_materia_no = 0
end


create table #t_curso_item_si (alum_id int)
create table #t_curso_item_no (alum_id int)

if (@mat_id_si<>0 or @ram_id_materia_si<>0) begin

  insert into #t_curso_item_si(alum_id)

                  select distinct alum_id 
                  from CursoItem curi inner join Curso cur on curi.cur_id = cur.cur_id
                  where (cur.mat_id = @mat_id_si or @mat_id_si=0)
                    and   (
                              (exists(select rptarb_hojaid 
                                      from rptArbolRamaHoja 
                                      where
                                           rptarb_cliente = @clienteID
                                      and  tbl_id = 37001
                                      and  rptarb_hojaid = cur.mat_id
                                     ) 
                               )
                            or 
                               (@ram_id_materia_si= 0)
                           )
end

if (@mat_id_no<>0 or @ram_id_materia_no<>0) begin

  insert into #t_curso_item_no(alum_id)

                  select distinct alum_id 
                  from CursoItem curi inner join Curso cur on curi.cur_id = cur.cur_id
                  where (cur.mat_id = @mat_id_no or @mat_id_no=0)
                    and   (
                              (exists(select rptarb_hojaid 
                                      from rptArbolRamaHoja 
                                      where
                                           rptarb_cliente = @clienteID2
                                      and  tbl_id = 37001
                                      and  rptarb_hojaid = cur.mat_id
                                     ) 
                               )
                            or 
                               (@ram_id_materia_no= 0)
                           )
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @bShowDuplicados tinyint

if @@apellido = 'duplicados' set @bShowDuplicados = 1
else                         set @bShowDuplicados = 0

if @bShowDuplicados <> 0 begin

  select 
  
          alum_id,              
          ''                      as [TypeTask],
  
          prs.prs_apellido         as Apellido,
          prs.prs_nombre          as Nombre,
  
          alum_codigo              as Codigo,
          alum_legajo             as Legajo,
          alum_fechaingreso        as [Fecha Ingreso],
          prsp.prs_apellido + ', ' + prsp.prs_nombre             
                                  as Profesor,
  
          prs.prs_telCasa         as [Tel Casa],
          prs.prs_telTrab          as [Tel Trabajo],
          prs.prs_celular         as Celular,
          prs.prs_email           as Email,
  
          prs.prs_calle + ' ' + prs.prs_callenumero + ' ' + case when prs.prs_codpostal <> '' then '('+prs.prs_codpostal+')' else '' end +  ' ' + prs.prs_localidad
                                  as Direccion,
          pro_nombre              as Provincia,
          pa_nombre               as Pais,
  
          us_nombre                as [Modifico],
          alum.creado              as [Creado],
          alum.modificado          as [Modificado],
          alum_descrip            as [Observaciones]
  
  from 
  
        Alumno alum  inner join Persona prs              on alum.prs_id     = prs.prs_id
                     inner join Usuario                 on alum.modifico   = Usuario.us_id
                     left  join Profesor prof            on alum.prof_id   = prof.prof_id
                     left  join Persona prsp            on prof.prs_id     = prsp.prs_id
  
                     left  join Provincia pro           on prs.pro_id     = pro.pro_id
                     left  join Pais pa                 on prs.pa_id      = pa.pa_id

  where prs.prs_apellido+prs.prs_nombre in
  
                                (select prs_apellido + prs_nombre
                                  from alumno alum inner join persona prs on alum.prs_id = prs.prs_id 
                                  group by prs_apellido, prs_nombre 
                                  having count(*)>1
                                 )

  order by prs.prs_apellido, prs.prs_nombre

end else begin

  select 
  
          alum_id,              
          ''                      as [TypeTask],
  
          prs.prs_apellido         as Apellido,
          prs.prs_nombre          as Nombre,
  
          alum_codigo              as Codigo,
          alum_legajo             as Legajo,
          alum_fechaingreso        as [Fecha Ingreso],
          prsp.prs_apellido + ', ' + prsp.prs_nombre             
                                  as Profesor,
  
          prs.prs_telCasa         as [Tel Casa],
          prs.prs_telTrab          as [Tel Trabajo],
          prs.prs_celular         as Celular,
          prs.prs_email           as Email,
  
          prs.prs_calle + ' ' + prs.prs_callenumero + ' ' + case when prs.prs_codpostal <> '' then '('+prs.prs_codpostal+')' else '' end +  ' ' + prs.prs_localidad
                                  as Direccion,
          pro_nombre              as Provincia,
          pa_nombre               as Pais,
  
          us_nombre                as [Modifico],
          alum.creado              as [Creado],
          alum.modificado          as [Modificado],
          alum_descrip            as [Observaciones]
  
  from 
  
        Alumno alum  inner join Persona prs              on alum.prs_id     = prs.prs_id
                     inner join Usuario                 on alum.modifico   = Usuario.us_id
                     left  join Profesor prof            on alum.prof_id   = prof.prof_id
                     left  join Persona prsp            on prof.prs_id     = prsp.prs_id
  
                     left  join Provincia pro           on prs.pro_id     = pro.pro_id
                     left  join Pais pa                 on prs.pa_id      = pa.pa_id
  
  where 
  
            alum_fechaingreso >= @@Fini
        and  alum_fechaingreso <= @@Ffin 
  
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (alum.prof_id = @prof_id or @prof_id=0)
  and   (alum_codigo         like @@codigo or @@codigo = '')
  and   (prs.prs_apellido   like @@apellido or @@apellido = '')
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 37003
                    and  rptarb_hojaid = alum.prof_id
                   ) 
             )
          or 
             (@ram_id_profesor = 0)
         )
  
  and (     not (@mat_id_si<>0 or @ram_id_materia_si<>0)
        or exists(select * from #t_curso_item_si where alum_id = alum.alum_id)
      )
  and (     not (@mat_id_no<>0 or @ram_id_materia_no<>0)
        or not exists(select * from #t_curso_item_no where alum_id = alum.alum_id)
      )
  
  order by prs.prs_apellido, prs.prs_nombre

end

GO