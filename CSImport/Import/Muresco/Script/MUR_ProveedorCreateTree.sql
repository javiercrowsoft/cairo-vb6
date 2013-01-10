if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ProveedorCreateTree]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ProveedorCreateTree]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ProveedorCreateTree.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ProveedorCreateTree 
as
begin

  set nocount on

  update proveedor set prov_codigo = 100000000 + prov_id where isnumeric(prov_codigo)=0

  declare @arb_id  int
  declare @raiz    int
  declare @raiz2   int
  
  select @arb_id = min(arb_id) from arbol where tbl_id = 29
  select @raiz = ram_id from rama where arb_id = @arb_id and ram_id_padre = 0

  ----------------------------------------------------------------------------------------
  -- LA EUROPEA
                      set @raiz2 = @raiz
                      exec MUR_ProveedorCreateTreeGeneral @arb_id, @raiz2 out
                      open c_prov
                      exec MUR_ProveedorCreateTreeAux @arb_id, @raiz2
                      close c_prov
                      deallocate c_prov

end