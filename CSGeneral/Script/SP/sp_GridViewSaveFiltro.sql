if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewSaveFiltro]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewSaveFiltro]

/*

*/

go
create procedure sp_GridViewSaveFiltro (
  @@grdv_id            int,
  @@grdvfi_columna     varchar(255),
  @@grdvfi_columna2    varchar(255),
  @@grdvfi_valor       varchar(255),
  @@grdvfi_operador    tinyint
)
as

begin

  set nocount on

  begin transaction

  declare @grdvfi_id int

  exec sp_dbgetnewid 'GridViewFiltro', 'grdvfi_id', @grdvfi_id out, 0
       
  insert into GridViewFiltro (grdv_id, grdvfi_id, grdvfi_columna, grdvfi_columna2, grdvfi_valor, grdvfi_operador) 
                    values    (@@grdv_id, @grdvfi_id, @@grdvfi_columna, @@grdvfi_columna2, @@grdvfi_valor, @@grdvfi_operador)
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar el filtro. sp_GridViewSaveFiltro.', 16, 1)
  rollback transaction  

end
go