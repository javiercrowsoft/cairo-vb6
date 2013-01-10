/*---------------------------------------------------------------------
Nombre: sp_ArbSortRamas
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbSortRamas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbSortRamas]

GO

create procedure sp_ArbSortRamas(

  @@arb_id  int

)
as
begin

set nocount on

  declare @ram_id              int 
  declare @ram_id_padre        int
  declare @last_ram_id_padre  int
  declare @orden              int

  set @last_ram_id_padre = -1

  declare c_arbol insensitive cursor for 

    select ram_id, ram_id_padre 
    from rama 
    where arb_id = @@arb_id
    order by ram_id_padre, ram_nombre

  open c_arbol

  fetch next from c_arbol into @ram_id, @ram_id_padre
  while @@fetch_status = 0
  begin

    if @ram_id_padre <> @last_ram_id_padre begin
      set @last_ram_id_padre = @ram_id_padre
      set @orden = 0
    end

    set @orden = @orden + 1
  
    update rama set ram_orden = @orden where ram_id = @ram_id

    fetch next from c_arbol into @ram_id, @ram_id_padre
  end

  close c_arbol
  deallocate c_arbol  

end
GO