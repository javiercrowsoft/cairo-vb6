if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ClienteCreateTreeSistemas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ClienteCreateTreeSistemas]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ClienteCreateTreeSistemas.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ClienteCreateTreeSistemas (
  @@arb_id    int,
  @@raiz       int out
)
as
begin

  declare @ram_id  int

  -- Clientes de La Europea:
  --
  declare c_cli insensitive cursor for 
  select cli_id, '@@EXPO@@'
  from cliente cli
  where convert(int,cli_codigo) > 100000000 
    and not exists(select * from hoja where arb_id = @@arb_id and id = cli_id)
  
  order by cli_codigo
  
  if not exists(select ram_id from rama where ram_nombre = 'Sistemas' and ram_id_padre = @@raiz) begin
      exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
      insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@@arb_id,'Sistemas',1,@@raiz,1000)
      select @@raiz = @ram_id
  end else select @@raiz = ram_id from rama where ram_nombre = 'Sistemas' and ram_id_padre = @@raiz

end