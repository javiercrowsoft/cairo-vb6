if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocEditableGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocEditableGet]

go

/*

  sp_DocEditableGet 2,61,1,17002

*/

create procedure sp_DocEditableGet (
  @@emp_id        int,
  @@doc_id         int,
  @@us_id         int,
  @@pre_id        int
)
as

set nocount on

begin

  declare @doct_id     int
  declare @emp_id      int
  declare @emp_nombre  varchar(255)
  declare @doct_nombre varchar(255)

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)


  declare @csPreVtaNew int 
  set @csPreVtaNew = @@pre_id

  select 
        @emp_id        = emp_id,
        @doct_id       = doc.doct_id,
        @doct_nombre  = doct_nombre

  from documento doc inner join documentoTipo doct on doc.doct_id = doct.doct_id
  where doc_id = @@doc_id

  set @bEditable = 1
  set @editMsg = ''

  if @@emp_id <> @emp_id begin
          select @emp_nombre = emp_nombre from empresa where emp_id = @emp_id
          set @bEditable = 0
          set @editMsg = 'El documento pertenece a la empresa ' +  @emp_nombre + ', para crear nuevos comprobantes debe ingresar al sistema indicando dicha empresa.'

  end else begin

    -- Tiene permiso para crear nuevos documentos
    --
    if not exists (select per_id from permiso 
                     where pre_id = @csPreVtaNew
                           and (
                                  (
                                  us_id = @@us_id
                                  )
                                  or
                                  exists(
                                      select us_id from usuarioRol
                                      where us_id  = @@us_id
                                        and rol_id = permiso.rol_id
                                  )
                                ) 
                   )begin
   
            set @bEditable = 0
            set @editMsg = 'Usted no tiene permiso para generar nuevos comprobantes para el tipo de documento ' + @doct_nombre

    end else begin
  

      -- Tiene permiso para crear comprobantes de este documento
      --
      declare @pre_id_new int
      declare @doc_nombre  varchar(255)
    
      select @pre_id_new = pre_id_new, @doc_nombre = doc_nombre from documento where doc_id = @@doc_id
      if not exists (select per_id from permiso 
                       where pre_id = @pre_id_new
                             and (
                                    (
                                    us_id = @@us_id
                                    )
                                    or
                                    exists(
                                        select us_id from usuarioRol
                                        where us_id  = @@us_id
                                          and rol_id = permiso.rol_id
                                    )
                                  ) 
                     )begin
     
              set @bEditable = 0
              set @editMsg = 'Usted no tiene permiso para generar nuevos comprobantes para el documento ' + @doc_nombre
      end
    end
  end

  select [Editable]=@bEditable, [EditMsg]= @editMsg

end

go
