if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FeriadoDelete ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FeriadoDelete ]

/*

*/

go
create procedure sp_FeriadoDelete  (
  @@fe_id     int
)
as

begin

  set nocount on

  create table #t_docs (id int, fecha datetime, cle_id int, tipo tinyint)

  exec sp_FeriadoFillTableAux @@fe_id

  delete feriadoitem  where fe_id = @@fe_id
  delete feriado       where fe_id = @@fe_id

  exec sp_DocFeriadoUpdate @@fe_id

end

go