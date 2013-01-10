if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GridViewSaveFormato]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GridViewSaveFormato]

/*

*/

go
create procedure sp_GridViewSaveFormato (
  @@grdv_id            int,
  @@grdvfc_columna     varchar(255),
  @@grdvfc_columna2    varchar(255),
  @@grdvfc_valor       varchar(255),
  @@grdvfc_operador    tinyint,
  @@grdvfc_fontName     varchar(255),
  @@grdvfc_fontSize     varchar(255),
  @@grdvfc_fontStyle   tinyint,
  @@grdvfc_fColor      int,
  @@grdvfc_bgColor     int
)
as

begin

  set nocount on

  begin transaction

  declare @grdvfc_id int

  exec sp_dbgetnewid 'GridViewFormato', 'grdvfc_id', @grdvfc_id out, 0
       
  insert into GridViewFormato (grdv_id, grdvfc_id, grdvfc_columna, grdvfc_columna2, grdvfc_valor, grdvfc_operador, 
                              grdvfc_fontname, grdvfc_fontsize, grdvfc_fontstyle, grdvfc_fcolor, grdvfc_bgcolor)
                    values    (@@grdv_id, @grdvfc_id, @@grdvfc_columna, @@grdvfc_columna2, @@grdvfc_valor, @@grdvfc_operador,
                              @@grdvfc_fontname, @@grdvfc_fontsize, @@grdvfc_fontstyle, @@grdvfc_fcolor, @@grdvfc_bgcolor)
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar el formato. sp_GridViewSaveFormato.', 16, 1)
  rollback transaction  

end
go