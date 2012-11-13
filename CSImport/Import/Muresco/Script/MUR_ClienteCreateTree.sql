if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ClienteCreateTree]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ClienteCreateTree]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ClienteCreateTree.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ClienteCreateTree 
as
begin

  set nocount on

	update cliente set cli_codigo = 100000000 + cli_id where isnumeric(cli_codigo)=0

	declare @arb_id  int
	declare @raiz    int
	declare @raiz2   int
	
	select @arb_id = min(arb_id) from arbol where tbl_id = 28
	select @raiz = ram_id from rama where arb_id = @arb_id and ram_id_padre = 0

	----------------------------------------------------------------------------------------
	-- LA EUROPEA
											set @raiz2 = @raiz
											exec MUR_ClienteCreateTreeLaEuropea @arb_id, @raiz2 out
											open c_cli
											exec MUR_ClienteCreateTreeAux @arb_id, @raiz2
											close c_cli
											deallocate c_cli
	----------------------------------------------------------------------------------------
	-- EXPO
											set @raiz2 = @raiz
											exec MUR_ClienteCreateTreeExpo @arb_id, @raiz2 out
											open c_cli
											exec MUR_ClienteCreateTreeAux @arb_id, @raiz2
											close c_cli
											deallocate c_cli
	----------------------------------------------------------------------------------------
	-- REVESTIMIENTOS
											set @raiz2 = @raiz
											exec MUR_ClienteCreateTreeRevestimientos @arb_id, @raiz2 out
											open c_cli
											exec MUR_ClienteCreateTreeAux @arb_id, @raiz2
											close c_cli
											deallocate c_cli
	----------------------------------------------------------------------------------------
	-- LIBRERIA
											set @raiz2 = @raiz
											exec MUR_ClienteCreateTreeLibreria @arb_id, @raiz2 out
											open c_cli
											exec MUR_ClienteCreateTreeAux @arb_id, @raiz2
											close c_cli
											deallocate c_cli
	----------------------------------------------------------------------------------------
	-- SISTEMAS
											set @raiz2 = @raiz
											exec MUR_ClienteCreateTreeSistemas @arb_id, @raiz2 out
											open c_cli
											exec MUR_ClienteCreateTreeAux @arb_id, @raiz2
											close c_cli
											deallocate c_cli

end