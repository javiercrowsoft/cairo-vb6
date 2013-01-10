if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_comunidadInternetTextoItemsCopy]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_comunidadInternetTextoItemsCopy]

go
/*

*/

create procedure sp_comunidadInternetTextoItemsCopy (

  @@cmit_id int
)

as

begin

  set nocount on

  declare @cmiti_id_padre int
  declare @cmiti_id_padre_new int
  declare @cmiti_codigo varchar(255)

  declare c_padre insensitive cursor for 
      select distinct cmiti_id_padre 
      from ComunidadInternetTextoItem 
      where cmit_id = @@cmit_id and cmiti_id_padre is not null

  open c_padre
  
  fetch next from c_padre into @cmiti_id_padre
  while @@fetch_status=0
  begin

    -- Obtengo el codigo
    --
    select @cmiti_codigo = cmiti_codigo 
    from ComunidadInternetTextoItem 
    where cmiti_id = @cmiti_id_padre

    -- Limpio el padre anterior
    --
    set @cmiti_id_padre_new = null

    -- Obtengo el padre para este codigo en este Texto
    --
    select @cmiti_id_padre_new = cmiti_id 
    from ComunidadInternetTextoItem 
    where cmit_id = @@cmit_id 
      and cmiti_codigo = @cmiti_codigo

    -- Actulizo el padre
    --
    update ComunidadInternetTextoItem 
            set cmiti_id_padre = @cmiti_id_padre_new 
    where cmit_id = @@cmit_id 
      and cmiti_id_padre = @cmiti_id_padre

    fetch next from c_padre into @cmiti_id_padre
  end
  
  close c_padre
  deallocate c_padre
end