if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoPermisosGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoPermisosGet]

/*

          @pre_id_edit
          @pre_id_delete
          @pre_id_list
          @pre_id_anular
          @pre_id_desanular
          @pre_id_aplicar
          @pre_id_print


 sp_DocumentoPermisosGet 35,0

*/

go
create procedure sp_DocumentoPermisosGet (
  @@doc_id     int,
  @@forRol    tinyint
)
as

begin

  declare @pre_id_new              int
  declare @pre_id_edit            int
  declare @pre_id_delete          int
  declare @pre_id_list            int
  declare @pre_id_anular          int
  declare @pre_id_desanular        int
  declare @pre_id_aplicar          int
  declare @pre_id_print            int

  select

          @pre_id_new              = pre_id_new,
          @pre_id_edit            = pre_id_edit,
          @pre_id_delete          = pre_id_delete,
          @pre_id_list            = pre_id_list,
          @pre_id_anular          = pre_id_anular,
          @pre_id_desanular        = pre_id_desanular,
          @pre_id_aplicar          = pre_id_aplicar,
          @pre_id_print            = pre_id_print
  from
        Documento
  where
        doc_id = @@doc_id

  if @@forRol <> 0 begin

    select distinct
  
      p.rol_id, 
      rol_nombre,
  
      (select per_id from Permiso where pre_id = @pre_id_new         and rol_id = p.rol_id) as per_id_new,
      (select per_id from Permiso where pre_id = @pre_id_edit       and rol_id = p.rol_id) as per_id_edit,
      (select per_id from Permiso where pre_id = @pre_id_delete      and rol_id = p.rol_id) as per_id_delete,
      (select per_id from Permiso where pre_id = @pre_id_list        and rol_id = p.rol_id) as per_id_list,
      (select per_id from Permiso where pre_id = @pre_id_anular      and rol_id = p.rol_id) as per_id_anular,
      (select per_id from Permiso where pre_id = @pre_id_desanular  and rol_id = p.rol_id) as per_id_desanular,
      (select per_id from Permiso where pre_id = @pre_id_aplicar    and rol_id = p.rol_id) as per_id_aplicar,
      (select per_id from Permiso where pre_id = @pre_id_print      and rol_id = p.rol_id) as per_id_print
  
    from Permiso p inner join Rol on p.rol_id = rol.rol_id
  
    where exists (select * 
                  from Documento 
                  where 
                    ( 
                         pre_id_new       = p.pre_id
                      or pre_id_edit      = p.pre_id
                      or pre_id_delete    = p.pre_id
                      or pre_id_list      = p.pre_id
                      or pre_id_anular    = p.pre_id
                      or pre_id_desanular = p.pre_id
                      or pre_id_aplicar    = p.pre_id
                      or pre_id_print      = p.pre_id
                    )
                  and doc_id = @@doc_id
                  )

  end else begin

    select distinct
  
      p.us_id, 
      us_nombre,
  
      (select per_id from Permiso where pre_id = @pre_id_new         and us_id = p.us_id) as per_id_new,
      (select per_id from Permiso where pre_id = @pre_id_edit       and us_id = p.us_id) as per_id_edit,
      (select per_id from Permiso where pre_id = @pre_id_delete      and us_id = p.us_id) as per_id_delete,
      (select per_id from Permiso where pre_id = @pre_id_list        and us_id = p.us_id) as per_id_list,
      (select per_id from Permiso where pre_id = @pre_id_anular      and us_id = p.us_id) as per_id_anular,
      (select per_id from Permiso where pre_id = @pre_id_desanular  and us_id = p.us_id) as per_id_desanular,
      (select per_id from Permiso where pre_id = @pre_id_aplicar    and us_id = p.us_id) as per_id_aplicar,
      (select per_id from Permiso where pre_id = @pre_id_print      and us_id = p.us_id) as per_id_print
  
    from Permiso p inner join Usuario us on p.us_id = us.us_id
  
    where exists (select * 
                  from Documento 
                  where 
                    ( 
                         pre_id_new       = p.pre_id
                      or pre_id_edit      = p.pre_id
                      or pre_id_delete    = p.pre_id
                      or pre_id_list      = p.pre_id
                      or pre_id_anular    = p.pre_id
                      or pre_id_desanular = p.pre_id
                      or pre_id_aplicar    = p.pre_id
                      or pre_id_print      = p.pre_id
                    )
                  and doc_id = @@doc_id
                  )

  end

end

go