/*---------------------------------------------------------------------
Nombre: Proceso para crear arboles de producto en funcion de rubros
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9988]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9988]


go
create procedure DC_CSC_VEN_9988 (

  @@us_id        int

)as 
begin

  set nocount on

  declare @arb_id int
  declare @ram_id int
  declare @arb_nombre varchar(255)

  set @arb_nombre = 'Productos x Rubro'

  exec SP_DBGetNewId 'Arbol','arb_id',@arb_id out, 0

  insert into Arbol (arb_id,arb_nombre,tbl_id,modifico)
              values(@arb_id,@arb_nombre,30,@@us_id)

  exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0

  insert into Rama (arb_id, ram_id, ram_nombre, ram_id_padre, modifico) 
            values (@arb_id, @ram_id, @arb_nombre, 0, @@us_id)


  declare @ram_nombre   varchar(500)
  declare @rub_id       int
  declare @ram_id_padre int
  declare @orden         int

  set @ram_id_padre = @ram_id
  set @orden = 1

  declare c_rama insensitive cursor for 
    select rub_nombre, rub.rub_id 
    from Producto pr inner join Rubro rub on pr.rub_id = rub.rub_id 
    group by rub.rub_id, rub_nombre
    order by rub_nombre

  open c_rama

  fetch next from c_rama into @ram_nombre, @rub_id
  while @@fetch_status = 0 begin

    set @orden = @orden + 1

    exec SP_DBGetNewId 'Rama','ram_id',@ram_id out, 0
    insert into Rama (
                        ram_id,
                        ram_nombre,
                        arb_id,
                        modificado,
                        creado,
                        modifico,
                        ram_id_padre,
                        ram_orden
                      )
              values (
                        @ram_id,
                        @ram_nombre,
                        @arb_id,
                        getdate(),
                        getdate(),
                        1,
                        @ram_id_padre,
                        @orden
                      )

    --------------------------------------------------------------------------------------------------------
    declare c_hoja insensitive cursor for 
        select pr_id from Producto
        where rub_id = @rub_id
        order by pr_nombrecompra

    open c_hoja
  
    declare @pr_id      int
    declare @hoja_id    int

    fetch next from c_hoja into @pr_id
    while @@fetch_status = 0 begin
  
      exec SP_DBGetNewId 'Hoja','hoja_id',@hoja_id out, 0
      insert into Hoja (
                          hoja_id,
                          id,
                          modificado,
                          creado,
                          modifico,
                          ram_id,
                          arb_id
                        )
                values (
                          @hoja_id,
                          @pr_id,
                          getdate(),
                          getdate(),
                          1,
                          @ram_id,
                          @arb_id
                        )      
  
      fetch next from c_hoja into @pr_id
    end
  
    close c_hoja
    deallocate c_hoja
    --------------------------------------------------------------------------------------------------------

    fetch next from c_rama into @ram_nombre, @rub_id
  end

  close c_rama
  deallocate c_rama

  select 1 as aux_id, 'El proceso se ejecuto con éxito, el árbol ha sido generado.' as Info

end
go
 