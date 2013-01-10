if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PrestacionClean]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PrestacionClean]

go

create Procedure sp_PrestacionClean

as

begin

  set nocount on

    delete permiso where pre_id in (
    
    select pre_id from prestacion 
    where 
        pre_id not in (select pre_id_agregar from Agenda where pre_id_agregar is not null)
    and pre_id not in (select pre_id_borrar from Agenda where pre_id_borrar is not null)
    and pre_id not in (select pre_id_editar from Agenda where pre_id_editar is not null)
    and pre_id not in (select pre_id_listar from Agenda where pre_id_listar is not null)
    and pre_id not in (select pre_id_propietario from Agenda where pre_id_propietario is not null)
    and pre_id not in (select pre_id_agregardocumentos from Departamento where pre_id_agregardocumentos is not null)
    and pre_id not in (select pre_id_asignartareas from Departamento where pre_id_asignartareas is not null)
    and pre_id not in (select pre_id_borrardocumentos from Departamento where pre_id_borrardocumentos is not null)
    and pre_id not in (select pre_id_editardocumentos from Departamento where pre_id_editardocumentos is not null)
    and pre_id not in (select pre_id_editarnoticias from Departamento where pre_id_editarnoticias is not null)
    and pre_id not in (select pre_id_verdocumentos from Departamento where pre_id_verdocumentos is not null)
    and pre_id not in (select pre_id_vernoticias from Departamento where pre_id_vernoticias is not null)
    and pre_id not in (select pre_id_vertareas from Departamento where pre_id_vertareas is not null)
    and pre_id not in (select pre_id_anular from Documento where pre_id_anular is not null)
    and pre_id not in (select pre_id_aplicar from Documento where pre_id_aplicar is not null)
    and pre_id not in (select pre_id_delete from Documento where pre_id_delete is not null)
    and pre_id not in (select pre_id_desanular from Documento where pre_id_desanular is not null)  
    and pre_id not in (select pre_id_edit from Documento where pre_id_edit is not null)
    and pre_id not in (select pre_id_list from Documento where pre_id_list is not null)
    and pre_id not in (select pre_id_new from Documento where pre_id_new is not null)
    and pre_id not in (select pre_id_print from Documento where pre_id_print is not null)  
    and pre_id not in (select pre_id from Informe where pre_id is not null)
    and pre_id not in (select pre_id_addHora from Proyecto where pre_id_addHora is not null)
    and pre_id not in (select pre_id_addTarea from Proyecto where pre_id_addTarea is not null)
    and pre_id not in (select pre_id_aprobarTarea from Proyecto where pre_id_aprobarTarea is not null)
    and pre_id not in (select pre_id_asignarTarea from Proyecto where pre_id_asignarTarea is not null)
    and pre_id not in (select pre_id_delHora from Proyecto where pre_id_delHora is not null)
    and pre_id not in (select pre_id_delHoraP from Proyecto where pre_id_delHoraP is not null)
    and pre_id not in (select pre_id_delTarea from Proyecto where pre_id_delTarea is not null)
    and pre_id not in (select pre_id_delTareaD from Proyecto where pre_id_delTareaD is not null)
    and pre_id not in (select pre_id_delTareaP from Proyecto where pre_id_delTareaP is not null)
    and pre_id not in (select pre_id_editHora from Proyecto where pre_id_editHora is not null)
    and pre_id not in (select pre_id_editHoraP from Proyecto where pre_id_editHoraP is not null)
    and pre_id not in (select pre_id_editTarea from Proyecto where pre_id_editTarea is not null)
    and pre_id not in (select pre_id_editTareaD from Proyecto where pre_id_editTareaD is not null)
    and pre_id not in (select pre_id_editTareaP from Proyecto where pre_id_editTareaP is not null)
    and pre_id not in (select pre_id_listHora from Proyecto where pre_id_listHora is not null)
    and pre_id not in (select pre_id_listHoraD from Proyecto where pre_id_listHoraD is not null)
    and pre_id not in (select pre_id_listTarea from Proyecto where pre_id_listTarea is not null)
    and pre_id not in (select pre_id_listTareaD from Proyecto where pre_id_listTareaD is not null)
    and pre_id not in (select pre_id_tomarTarea from Proyecto where pre_id_tomarTarea is not null)
    and pre_id > 99999)
    
    delete prestacion where pre_id in (
    
    select pre_id from prestacion 
    where
        pre_id not in (select pre_id_agregar from Agenda where pre_id_agregar is not null)
    and pre_id not in (select pre_id_borrar from Agenda where pre_id_borrar is not null)
    and pre_id not in (select pre_id_editar from Agenda where pre_id_editar is not null)
    and pre_id not in (select pre_id_listar from Agenda where pre_id_listar is not null)
    and pre_id not in (select pre_id_propietario from Agenda where pre_id_propietario is not null)
    and pre_id not in (select pre_id_agregardocumentos from Departamento where pre_id_agregardocumentos is not null)
    and pre_id not in (select pre_id_asignartareas from Departamento where pre_id_asignartareas is not null)
    and pre_id not in (select pre_id_borrardocumentos from Departamento where pre_id_borrardocumentos is not null)
    and pre_id not in (select pre_id_editardocumentos from Departamento where pre_id_editardocumentos is not null)
    and pre_id not in (select pre_id_editarnoticias from Departamento where pre_id_editarnoticias is not null)
    and pre_id not in (select pre_id_verdocumentos from Departamento where pre_id_verdocumentos is not null)
    and pre_id not in (select pre_id_vernoticias from Departamento where pre_id_vernoticias is not null)
    and pre_id not in (select pre_id_vertareas from Departamento where pre_id_vertareas is not null)
    and pre_id not in (select pre_id_anular from Documento where pre_id_anular is not null)
    and pre_id not in (select pre_id_aplicar from Documento where pre_id_aplicar is not null)
    and pre_id not in (select pre_id_delete from Documento where pre_id_delete is not null)
    and pre_id not in (select pre_id_desanular from Documento where pre_id_desanular is not null)  
    and pre_id not in (select pre_id_edit from Documento where pre_id_edit is not null)
    and pre_id not in (select pre_id_list from Documento where pre_id_list is not null)
    and pre_id not in (select pre_id_new from Documento where pre_id_new is not null)
    and pre_id not in (select pre_id_print from Documento where pre_id_print is not null)  
    and pre_id not in (select pre_id from Informe where pre_id is not null)
    and pre_id not in (select pre_id_addHora from Proyecto where pre_id_addHora is not null)
    and pre_id not in (select pre_id_addTarea from Proyecto where pre_id_addTarea is not null)
    and pre_id not in (select pre_id_aprobarTarea from Proyecto where pre_id_aprobarTarea is not null)
    and pre_id not in (select pre_id_asignarTarea from Proyecto where pre_id_asignarTarea is not null)
    and pre_id not in (select pre_id_delHora from Proyecto where pre_id_delHora is not null)
    and pre_id not in (select pre_id_delHoraP from Proyecto where pre_id_delHoraP is not null)
    and pre_id not in (select pre_id_delTarea from Proyecto where pre_id_delTarea is not null)
    and pre_id not in (select pre_id_delTareaD from Proyecto where pre_id_delTareaD is not null)
    and pre_id not in (select pre_id_delTareaP from Proyecto where pre_id_delTareaP is not null)
    and pre_id not in (select pre_id_editHora from Proyecto where pre_id_editHora is not null)
    and pre_id not in (select pre_id_editHoraP from Proyecto where pre_id_editHoraP is not null)
    and pre_id not in (select pre_id_editTarea from Proyecto where pre_id_editTarea is not null)
    and pre_id not in (select pre_id_editTareaD from Proyecto where pre_id_editTareaD is not null)
    and pre_id not in (select pre_id_editTareaP from Proyecto where pre_id_editTareaP is not null)
    and pre_id not in (select pre_id_listHora from Proyecto where pre_id_listHora is not null)
    and pre_id not in (select pre_id_listHoraD from Proyecto where pre_id_listHoraD is not null)
    and pre_id not in (select pre_id_listTarea from Proyecto where pre_id_listTarea is not null)
    and pre_id not in (select pre_id_listTareaD from Proyecto where pre_id_listTareaD is not null)
    and pre_id not in (select pre_id_tomarTarea from Proyecto where pre_id_tomarTarea is not null)
    and pre_id > 99999)
    
end

go