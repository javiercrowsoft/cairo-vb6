if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioUpdateHistorial]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioUpdateHistorial]

/*

*/

go
create procedure sp_ListaPrecioUpdateHistorial (
  @@lpi_id     int
)
as

begin

  set nocount on

  declare @lpi_preciolista    decimal(18,6)
  declare @lpi_fechalista    datetime
  declare @lpi_precio         decimal(18,6)
  declare @lpi_fecha         datetime

  declare @lpi_fechah1       datetime
  declare @lpi_precioh1      decimal(18,6)
  declare @lpi_fechah2       datetime
  declare @lpi_precioh2      decimal(18,6)
  declare @lpi_fechah3       datetime
  declare @lpi_precioh3      decimal(18,6)
  declare @lpi_fechah4       datetime
  declare @lpi_precioh4      decimal(18,6)
  declare @lpi_fechah5       datetime
  declare @lpi_precioh5      decimal(18,6)

  select 
          @lpi_preciolista    = lpi_preciolista,
          @lpi_fechalista     = lpi_fechalista,
          @lpi_precio         = lpi_precio,
          @lpi_fecha         = lpi_fecha,
          @lpi_fechah1       = lpi_fechah1,
          @lpi_precioh1      = lpi_precioh1,
          @lpi_fechah2       = lpi_fechah2,
          @lpi_precioh2      = lpi_precioh2,
          @lpi_fechah3       = lpi_fechah3,
          @lpi_precioh3      = lpi_precioh3,
          @lpi_fechah4       = lpi_fechah4,
          @lpi_precioh4      = lpi_precioh4,
          @lpi_fechah5       = lpi_fechah5,
          @lpi_precioh5      = lpi_precioh5

  from ListaPrecioItem 
  where lpi_id = @@lpi_id

  if @lpi_preciolista <> @lpi_precio begin

    if @lpi_preciolista <> 0 begin

      if @lpi_precioh4 <> 0  begin
  
        update ListaPrecioItem 
  
          set lpi_precioh5 = @lpi_precioh4, 
              lpi_fechah5 = @lpi_fechah4 
  
        where lpi_id = @@lpi_id
  
      end
  
      -----------------------------------------
  
      if @lpi_precioh3 <> 0  begin
  
        update ListaPrecioItem 
  
          set lpi_precioh4 = @lpi_precioh3, 
              lpi_fechah4 = @lpi_fechah3 
  
        where lpi_id = @@lpi_id
  
      end
  
      -----------------------------------------
  
      if @lpi_precioh2 <> 0  begin
  
        update ListaPrecioItem 
  
          set lpi_precioh3 = @lpi_precioh2, 
              lpi_fechah3 = @lpi_fechah2 
  
        where lpi_id = @@lpi_id
  
      end
  
      -----------------------------------------
  
      if @lpi_precioh1 <> 0  begin
  
        update ListaPrecioItem 
  
          set lpi_precioh2 = @lpi_precioh1, 
              lpi_fechah2 = @lpi_fechah1 
  
        where lpi_id = @@lpi_id
  
      end

      update ListaPrecioItem 
  
        set lpi_precioh1 = @lpi_preciolista, 
            lpi_fechah1 = @lpi_fechalista 
  
      where lpi_id = @@lpi_id

    end

    -----------------------------------------

  end

  update ListaPrecioItem 

    set lpi_preciolista = @lpi_precio,
        lpi_fechalista  = @lpi_fecha

  where lpi_id = @@lpi_id

end
go