if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ClienteCreateTreeLibreria]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ClienteCreateTreeLibreria]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ClienteCreateTreeLibreria.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ClienteCreateTreeLibreria (
  @@arb_id    int,
  @@raiz       int out
)
as
begin

  declare @ram_id  int

  -- Clientes de Libreria:
  --
  declare c_cli insensitive cursor for 
  select cli_id, isnull(ven_nombre, '(sin vendedor)')
  from cliente cli left join vendedor ven on cli.ven_id = ven.ven_id
  where 
        (      convert(int,cli_codigo) >= 400000 
          and convert(int,cli_codigo) <= 499999
        )
    and not exists(select * from hoja where arb_id = @@arb_id and id = cli_id)
  
  order by ven_nombre,cli_codigo
  
  if not exists(select ram_id from rama where ram_nombre = 'Libreria' and ram_id_padre = @@raiz) begin
      exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
      insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@@arb_id,'Libreria',1,@@raiz,1000)
      select @@raiz = @ram_id
  end else select @@raiz = ram_id from rama where ram_nombre = 'Libreria' and ram_id_padre = @@raiz

end