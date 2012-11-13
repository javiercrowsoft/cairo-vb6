if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewSaveFormula]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewSaveFormula]

/*

*/

go
create procedure sp_GridViewSaveFormula (
	@@grdv_id 				 int,
	@@grdvf_columna    varchar(255),
	@@grdvf_formula    tinyint,
	@@grdvf_indice     tinyint
)
as

begin

	set nocount on

	begin transaction

	declare @grdvf_id int

	exec sp_dbgetnewid 'GridViewFormula', 'grdvf_id', @grdvf_id out, 0
			 
	insert into GridViewFormula (grdv_id, grdvf_id, grdvf_columna, grdvf_formula, grdvf_indice) 
										values    (@@grdv_id, @grdvf_id, @@grdvf_columna, @@grdvf_formula, @@grdvf_indice)
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la formula. sp_GridViewSaveFormula.', 16, 1)
	rollback transaction	

end
go