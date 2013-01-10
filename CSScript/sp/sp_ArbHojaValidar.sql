if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbHojaValidar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbHojaValidar]

go
create procedure sp_ArbHojaValidar 
as

begin

set nocount on

  declare @sqlstmt varchar(5000)
  declare @tbl_id int
  declare @tbl_nombrefisico varchar(100)
  declare @tbl_campoid varchar(100)
  
  declare c_tablas insensitive cursor for select tbl_id, tbl_nombrefisico, tbl_campoid from tabla
  
  open c_tablas
  
  fetch next from c_tablas into @tbl_id, @tbl_nombrefisico, @tbl_campoid
  while @@fetch_status = 0 begin
  
    if exists (select * from sysobjects where name = @tbl_nombrefisico and xtype='u') begin
      set @sqlstmt = 'delete hoja from arbol'
    --  set @sqlstmt = 'select * from hoja, arbol'
      set @sqlstmt = @sqlstmt + ' where id not in (select ' + @tbl_campoid + ' from ' + @tbl_nombrefisico + ')'
      set @sqlstmt = @sqlstmt + ' and arbol.tbl_id = ' + convert(varchar(29),@tbl_id) + ' and hoja.arb_id = arbol.arb_id'
    
    --  print @sqlstmt
      exec (@sqlstmt)
    end
  
    fetch next from c_tablas into @tbl_id, @tbl_nombrefisico, @tbl_campoid
  end

  close c_tablas
  deallocate c_tablas

  update hoja set arb_id = rama.arb_id
  from rama where hoja.ram_id = rama.ram_id

end
go