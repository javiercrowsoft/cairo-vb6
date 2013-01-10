if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockUpdateNumeroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockUpdateNumeroSerie]

/*

  select * from parteprodkit

  sp_DocStockUpdateNumeroSerie 64059,0

*/

go
create procedure [dbo].[sp_DocStockUpdateNumeroSerie] (
  @@st_id           int,
  @@bRestar         tinyint
)
as

begin

  set nocount on

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @prns_id          int
  declare @depl_id          int
  declare @doct_id_cliente  int
  declare @id_cliente       int

  declare @modificado datetime
  declare @creado     datetime

  select   @doct_id_cliente   = doct_id_cliente, 
          @id_cliente       = id_cliente,
          @modificado       = modificado, 
          @creado           = creado,
          @depl_id           = depl_id_destino -- Cargamos el deposito destino
                                              -- desde el movimiento de stock
                                              -- ya que el 99% de las veces
                                              -- es un Insert

  from Stock where st_id = @@st_id

/*-------------------------------------------------------------------

    NUEVO

---------------------------------------------------------------------*/

  -- Solo puedo usarlo si no estoy borrando o anulando
  --
  if @modificado = @creado and @@bRestar = 0 begin

    -- Actualizamos el deposito siempre y el cliente, el proveedor
    -- y el documento de salida y de ingreso solo si corresponde
    --
      exec sp_DocStockUpdateNumeroSerie2   @@st_id,
                                          @doct_id_cliente,
                                          @id_cliente,
                                          null,
                                          null,
                                          @depl_id
  end 

/*-------------------------------------------------------------------

    UPDATE

---------------------------------------------------------------------*/

  else begin

    -- Si estoy anulando o borrando
    --
    if @@bRestar <> 0 begin

      declare @st_id_prns              int
      declare @depl_id_prns            int
      declare @doct_id_cliente_prns    int
      declare @id_cliente_prns        int

      declare c_ns insensitive cursor for 
      select prns_id 
      from StockItem 
      where st_id = @@st_id and prns_id is not null and sti_ingreso > 0
    
      open c_ns
    
      fetch next from c_ns into @prns_id
      while @@fetch_status=0
      begin
    
        set @st_id_prns = null
        
        select @st_id_prns = st_id from ProductoNumeroSerie where prns_id = @prns_id
    
        -- Si soy el ultimo movimiento de este numero de serie
        --
        if @@st_id = @st_id_prns begin

          -- Obtengo el movimiento anterior a mi
          --
          select @st_id_prns = max(st_id) 
          from StockItem 
          where prns_id = @prns_id 
            and st_id <> @st_id_prns

          -- Obtengo el deposito del ultimo movimiento
          --
          select   @doct_id_cliente_prns = doct_id_cliente, 
                  @id_cliente_prns       = id_cliente,
                  @depl_id_prns          = depl_id_destino

          from Stock where st_id = @st_id_prns

          exec sp_DocStockUpdateNumeroSerie3   @prns_id,
                                              @st_id_prns,
                                              @doct_id_cliente_prns,
                                              @id_cliente_prns,
                                              @depl_id_prns
        end
    
        fetch next from c_ns into @prns_id
      end

      close c_ns
      deallocate c_ns

    end

    -- Sino esta borrando modificamos todos los numeros de serie
    -- cuyo st_id = @@st_id
    --
    else begin

        exec sp_DocStockUpdateNumeroSerie4  @@st_id,
                                            @doct_id_cliente,
                                            @id_cliente,
                                            @depl_id
    end
  end
end



