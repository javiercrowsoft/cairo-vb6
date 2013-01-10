if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioValidate]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ram_convertid.sql
' Objetivo: Convierte un seudo id en un id real ya sea de rama o de una tabla cliente
'-----------------------------------------------------------------------------------------
*/

/*
select * from listaprecio where lp_id = 3
sp_ListaPrecioValidate 2

*/
create Procedure sp_ListaPrecioValidate(
  @@lp_id         int,
  @@bCreateTable  tinyint = 1,
  @@n             tinyint = 0,
  @@bBusacarHijos tinyint = 0
)
as
begin

  set nocount on

  declare @lp_id int

  set @@n = @@n + 1

  if @@bCreateTable <> 0 begin
    create table #ListasPadres(lp_id int not null, n tinyint, pendiente tinyint)
    create table #ListasHijas(lp_id int not null, n tinyint, pendiente tinyint)
  end

  if @@n = 1 begin

    exec sp_ListaPrecioValidate @@lp_id, 0, @@n, 1
    exec sp_ListaPrecioValidate @@lp_id, 0, @@n, 0

  end else begin

    if @@bBusacarHijos <> 0 begin
  
      -- Busco los hijos
      --
      insert into #ListasHijas(lp_id, n, pendiente) select lp_id, @@n,1 from ListaPrecio where lp_id_padre = @@lp_id and not lp_id in (select lp_id from #ListasHijas)
      insert into #ListasHijas(lp_id, n, pendiente) select lp_id, @@n,1 from ListaPrecioLista where lp_id_padre = @@lp_id and not lp_id in (select lp_id from #ListasHijas)
    
      while exists(select lp_id from #ListasHijas where n = @@n and pendiente = 1) begin
    
        select @lp_id = min(lp_id) from #ListasHijas where n = @@n and pendiente = 1
        update #ListasHijas set pendiente = 0 where lp_id = @lp_id
    
        exec sp_ListaPrecioValidate @lp_id, 0, @@n, 1
    
      end
  
    end else begin
  
      -- Busco los padres
      --
      insert into #ListasPadres(lp_id, n, pendiente) select lp_id_padre, @@n,1 from ListaPrecio where lp_id = @@lp_id and lp_id_padre is not null and not lp_id_padre in (select lp_id from #ListasPadres)
      insert into #ListasPadres(lp_id, n, pendiente) select lp_id_padre, @@n,1 from ListaPrecioLista where lp_id = @@lp_id and not lp_id_padre in (select lp_id from #ListasPadres)
    
      while exists(select lp_id from #ListasPadres where n = @@n and pendiente = 1) begin
    
        select @lp_id = min(lp_id) from #ListasPadres where n = @@n and pendiente = 1
        update #ListasPadres set pendiente = 0 where lp_id = @lp_id
    
        exec sp_ListaPrecioValidate @lp_id, 0, @@n, 0
    
      end
    end
  end

  if @@n = 1 begin

    if exists (select lp_id from #ListasHijas where lp_id in (select lp_id from #ListasPadres)) begin
  
      select 0
      select lp_nombre from ListaPrecio where lp_id in (select lp_id from #ListasHijas where lp_id in (select lp_id from #ListasPadres))
  
    end else begin

      -- Ahora verfificamos que no exista mas de una lista por defecto por moneda y tipo
      --
      if exists(select lp_id from ListaPrecio where lp_id = @@lp_id and lp_default <> 0) begin
        
        declare @mon_id     int
        declare @lp_tipo    tinyint

        select @mon_id = mon_id, @lp_tipo = lp_tipo from ListaPrecio where lp_id = @@lp_id

        update ListaPrecio set lp_default = 0 where lp_id <> @@lp_id and mon_id = @mon_id and lp_tipo = @lp_tipo

      end 

  
      select 1    
    end
  end


end
