if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentoUpdateAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentoUpdateAux]

/*


 select * from departamento

 sp_DepartamentoUpdateAux 59

*/

go
create procedure sp_DepartamentoUpdateAux (
  @@dpto_id     int,
  @@bheredar   tinyint
)
as

begin

  set nocount on

  declare @pre_id_vernoticias           int
  declare @pre_id_editarnoticias        int
  declare @pre_id_vertareas             int
  declare @pre_id_asignartareas         int
  declare @pre_id_verdocumentos         int
  declare @pre_id_agregardocumentos     int
  declare @pre_id_borrardocumentos      int
  declare @pre_id_editardocumentos      int

  declare @modifico     int

  select 
          @pre_id_vernoticias       = pre_id_vernoticias,
          @pre_id_editarnoticias    = pre_id_editarnoticias,
          @pre_id_vertareas         = pre_id_vertareas,
          @pre_id_asignartareas     = pre_id_asignartareas,
          @pre_id_verdocumentos     = pre_id_verdocumentos,
          @pre_id_agregardocumentos = pre_id_agregardocumentos,
          @pre_id_borrardocumentos  = pre_id_borrardocumentos,
          @pre_id_editardocumentos  = pre_id_editardocumentos,
          @modifico                 = modifico

  from Departamento where dpto_id = @@dpto_id

  exec sp_DepartamentoUpdateAux2 @pre_id_vernoticias, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_editarnoticias, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_vertareas, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_asignartareas, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_verdocumentos, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_agregardocumentos, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_borrardocumentos, @@bHeredar, @modifico
  exec sp_DepartamentoUpdateAux2 @pre_id_editardocumentos, @@bHeredar, @modifico

end
GO