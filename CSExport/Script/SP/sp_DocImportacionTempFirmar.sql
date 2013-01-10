if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempFirmar]

go

/*

ImportacionTemp                   reemplazar por el nombre del documento Ej. PedidoVenta
@@impt_id                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
ImportacionTemp                 reemplazar por el nombre de la tabla ej PedidoVenta
impt_id                     reemplazar por el campo ID ej. pv_id
impt_firmado                reemplazar por el campo pv_firmado

sp_DocImportacionTempFirmar 17,8

*/

create procedure sp_DocImportacionTempFirmar (
  @@impt_id int,
  @@us_id int
)
as

begin

  -- Si esta firmado le quita la firma
  if exists(select impt_firmado from ImportacionTemp where impt_id = @@impt_id and impt_firmado <> 0)
    update ImportacionTemp set impt_firmado = 0 where impt_id = @@impt_id
  -- Sino lo firma
  else
    update ImportacionTemp set impt_firmado = @@us_id where impt_id = @@impt_id

  exec sp_DocImportacionTempSetEstado @@impt_id

  select ImportacionTemp.est_id,est_nombre 
  from ImportacionTemp inner join Estado on ImportacionTemp.est_id = Estado.est_id
  where impt_id = @@impt_id
end