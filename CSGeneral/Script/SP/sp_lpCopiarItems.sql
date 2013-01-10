if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lpCopiarItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lpCopiarItems]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 select * from Chequera
 exec sp_lpCopiarItems 2,'x-0001-0002405'
*/
create procedure sp_lpCopiarItems (
  @@idSource    int,
  @@idTarget    int,
  @@modifico    int
)
as

set nocount on

begin

  declare @lpi_id            int
  declare @lpi_precio        decimal(18,6)
  declare @lpi_porcentaje    decimal(18,6)
  declare @pr_id             int
  declare @activo            tinyint

  declare c_items insensitive cursor for select lpi_precio,lpi_porcentaje,pr_id,activo from ListaPrecioItem where lp_id = @@idSource

  open c_items
  fetch next from c_items into @lpi_precio, @lpi_porcentaje, @pr_id, @activo
  while @@fetch_status=0
  begin
      
      exec sp_dbgetnewid 'ListaPrecioItem','lpi_id', @lpi_id out, 0

      insert into ListaPrecioItem(lp_id,lpi_id,lpi_precio,lpi_porcentaje,pr_id,activo,modificado,modifico)
                          values (@@idTarget,@lpi_id,@lpi_precio,@lpi_porcentaje,@pr_id,@activo,getdate(),@@modifico)

      fetch next from c_items into @lpi_precio, @lpi_porcentaje, @pr_id, @activo    
  end
  close c_items
  deallocate c_items

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



