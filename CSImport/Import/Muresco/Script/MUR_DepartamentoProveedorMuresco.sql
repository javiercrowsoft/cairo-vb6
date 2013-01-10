if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_DepartamentoProveedorMuresco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_DepartamentoProveedorMuresco]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_DepartamentoProveedorMuresco.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_DepartamentoProveedorMuresco 
as
begin

  set nocount on

  declare @dpto_id int

  declare c_dpto insensitive cursor for select dpto_id from departamento where dpto_nombre like '%compra%' or dpto_nombre like '%pago%'
  open c_dpto

  fetch next from c_dpto into @dpto_id  
  while @@fetch_status = 0
  begin

    exec MUR_DepartamentoProveedor @dpto_id, 0, 99999999

    fetch next from c_dpto into @dpto_id
  end

  close c_dpto
  deallocate c_dpto

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

