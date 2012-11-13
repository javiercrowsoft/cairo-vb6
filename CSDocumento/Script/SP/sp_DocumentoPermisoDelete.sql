if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoPermisoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoPermisoDelete]

/*

					@pre_id_edit
					@pre_id_delete
					@pre_id_list
					@pre_id_anular
					@pre_id_desanular
					@pre_id_aplicar
					@pre_id_print


 sp_DocumentoPermisoDelete 35,1

*/

go
create procedure sp_DocumentoPermisoDelete (
	@@doc_id 		int,
	@@strIds    varchar(5000),
	@@forRol    tinyint
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	if @@forRol <> 0 begin
	
		delete Permiso
	
		where exists (select * 
									from Documento 
									where 
										( 
												 pre_id_new 			= Permiso.pre_id
											or pre_id_edit			= Permiso.pre_id
											or pre_id_delete		= Permiso.pre_id
											or pre_id_list			= Permiso.pre_id
											or pre_id_anular		= Permiso.pre_id
											or pre_id_desanular = Permiso.pre_id
											or pre_id_aplicar		= Permiso.pre_id
											or pre_id_print			= Permiso.pre_id
										)
									and doc_id = @@doc_id
									)
	
		and exists (select * from TmpStringToTable					
								where Permiso.rol_id = convert(int,TmpStringToTable.tmpstr2tbl_campo)
									and tmpstr2tbl_id = @timeCode
								)

	end else begin

		delete Permiso
	
		where exists (select * 
									from Documento 
									where 
										( 
												 pre_id_new 			= Permiso.pre_id
											or pre_id_edit			= Permiso.pre_id
											or pre_id_delete		= Permiso.pre_id
											or pre_id_list			= Permiso.pre_id
											or pre_id_anular		= Permiso.pre_id
											or pre_id_desanular = Permiso.pre_id
											or pre_id_aplicar		= Permiso.pre_id
											or pre_id_print			= Permiso.pre_id
										)
									and doc_id = @@doc_id
									)
	
		and exists (select * from TmpStringToTable					
								where Permiso.us_id = convert(int,TmpStringToTable.tmpstr2tbl_campo)
									and tmpstr2tbl_id = @timeCode
								)

	end
end

go