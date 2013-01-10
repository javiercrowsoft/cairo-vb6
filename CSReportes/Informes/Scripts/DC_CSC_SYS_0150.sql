/*---------------------------------------------------------------------
Nombre: Copia documentos a una empresa
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0150]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0150]

GO

/*

  DC_CSC_SYS_0150 1, 0
  DC_CSC_SYS_0150 1, 1
  DC_CSC_SYS_0150 1, 2
  DC_CSC_SYS_0150 1, 3
  DC_CSC_SYS_0150 1, 4
  DC_CSC_SYS_0150 1, 5



ver todos los trabajos|0|ver trabajos pendientes|1|ver trabajos terminados|2|ver trabajos con errores|3|ver trabajos cancelados|4|cancelar trabajos pendientes|5

*/

create procedure DC_CSC_SYS_0150 (

  @@us_id    int,

  @@action_id           int        /*  0 - view all jobs
                                    1 - view pending jobs
                                    2 - view finished jobs
                                    3 - view jobs with errors 
                                    4 - view cancel jobs 
                                    5 - cancel pending jobs
                                */

)as 

begin

  set nocount on

  create table #t_ti (timp_id int)

  if @@action_id = 5 begin

    insert into #t_ti (timp_id) select timp_id from TrabajoImpresion where timp_estado = 2
    update TrabajoImpresion set timp_estado = 5 where timp_estado = 2

  end

    select   timp_id,
            timp_creado as Creado,
            timp_pc      as PC,
            case timp_estado 
                when 1 then 'Preparando trabajo'
                when 2 then 'Pendiente' 
                when 3 then 'Finalizado' 
                when 4 then 'Error' 
                when 5 then 'Cancelado' 
            end
                        as Estado,
            tbl_nombre  as Tabla,
            doc_nombre  as Documento,
            id          as [Id documento],
            us_nombre    as Usuario,
            emp_nombre  as Empresa,
            t.creado    as [Creado en server]

    from TrabajoImpresion t left join Tabla tbl on t.tbl_id = tbl.tbl_id
                            left join Documento doc on t.doc_id = doc.doc_id
                            left join Usuario us on t.us_id = us.us_id
                            left join Empresa emp on t.emp_id = emp.emp_id
    where   @@action_id = 0
        or  (timp_estado = 2 and @@action_id = 1)
        or  (timp_estado = 3 and @@action_id = 2)
        or  (timp_estado = 4 and @@action_id = 3)
        or  (timp_estado = 5 and @@action_id = 4)
        or  (@@action_id = 5 and timp_id in (select timp_id from #t_ti))

end
go

