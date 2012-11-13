if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ProveedorEmpresa]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ProveedorEmpresa]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ProveedorEmpresa.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ProveedorEmpresa 
as
begin

  set nocount on

	declare @prov_id 			int
	declare @emp_id 			int
	declare @empprov_id   int

	set @emp_id = 1

	declare c_prov insensitive cursor for 
	select prov_id from Proveedor where not exists(select prov_id from EmpresaProveedor where prov_id = Proveedor.prov_id)
	
	open c_prov

	fetch next from c_prov into @prov_id
	while @@fetch_status = 0
	begin

    exec sp_dbgetnewid 'EmpresaProveedor','empprov_id',@empprov_id out, 0
    insert into EmpresaProveedor (empprov_id, prov_id, emp_id, modifico)
                              values(@empprov_id, @prov_id, @emp_id, 1)

		fetch next from c_prov into @prov_id
	end

	close c_prov
	deallocate c_prov

	update proveedor set prov_nombre ='vacio' where prov_nombre = ''

	exec MUR_ProveedorCreateTree

	-- Esta validacion de categorias fiscales
	-- es por que en informix no estan bien cargados
  -- los proveedores del exterior

/*
select prov_nombre,prov_catfiscal from proveedor 
where  (convert(int,prov_codigo)>609000 and convert(int,prov_codigo)< 6099999 )
		or (convert(int,prov_codigo)>659000 and convert(int,prov_codigo)< 6599999 )
and prov_catfiscal <> 6
order by 2
*/

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

