if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentoUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentoUpdate]

/*


 select * from departamento

 sp_DepartamentoUpdate 47,1

*/

go
create procedure sp_DepartamentoUpdate (
	@@dpto_id		 int,
  @@bheredar   tinyint
)
as

begin

  set nocount on

  exec sp_DepartamentoUpdateAux @@dpto_id, @@bheredar

  select @@dpto_id = dpto_id_padre from Departamento where dpto_id = @@dpto_id
  if @@dpto_id is not null begin
    exec sp_DepartamentoUpdateAux @@dpto_id, @@bheredar
  end
end
GO