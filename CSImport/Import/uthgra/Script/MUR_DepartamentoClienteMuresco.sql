if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_DepartamentoClienteMuresco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_DepartamentoClienteMuresco]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_DepartamentoClienteMuresco.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*
select * from documento where doct_id = 1
select * from facturaventa where doc_id = 29
MUR_DepartamentoClienteMuresco 106,2
select * from departamento order by 2
select * from usuariodepartamento where dpto_id = 95
select * from usuario where us_id = 597
select * from cliente where cli_codigo > '300000' and cli_codigo < '300010'

select dpto_nombre from departamento where dpto_id in (
select dpto_id from departamentocliente where cli_id = 35641)

select * from departamento where dpto_nombre like '%lib.env.%'

*/
create Procedure MUR_DepartamentoClienteMuresco 
as
begin

  set nocount on

  declare @dpto_id int

  declare c_dpto insensitive cursor for select dpto_id from departamento where dpto_nombre like '%revestimientos%'
  open c_dpto

  fetch next from c_dpto into @dpto_id  
  while @@fetch_status = 0
  begin

    exec MUR_DepartamentoCliente @dpto_id, 300000, 399999

    fetch next from c_dpto into @dpto_id
  end

  close c_dpto
  deallocate c_dpto

  declare c_dpto insensitive cursor for select dpto_id from departamento where dpto_nombre like '%lib.env.%'
  open c_dpto

  fetch next from c_dpto into @dpto_id  
  while @@fetch_status = 0
  begin

    exec MUR_DepartamentoCliente @dpto_id, 400000, 499999

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

