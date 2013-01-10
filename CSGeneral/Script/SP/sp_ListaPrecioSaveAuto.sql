if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioSaveAuto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioSaveAuto]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ListaPrecioSaveAuto 352,2,0,'20070131'

create procedure sp_ListaPrecioSaveAuto (
  @@doc_id    int,
  @@doct_id   int,
  @@IsNew     smallint,
  @@fecha     datetime
)
as

set nocount on

begin

  if @@doct_id in (1,2,3,4) begin

    declare @us_id int

    if @@doct_id in (1,3)  declare c_listas insensitive cursor for 
                            select lp_id from listaprecio where lp_tipo = 1 and lp_autoXcompra <> 0
  
    if @@doct_id in (2,4)  declare c_listas insensitive cursor for 
                            select lp_id from listaprecio where lp_tipo in (2,3) and lp_autoXcompra <> 0
  
    if @@IsNew <> 0 begin
  
      if @@doct_id = 1 begin
                        select @us_id = modifico from facturaventa where fv_id = @@doc_id
                        declare c_items insensitive cursor for 
                          select pr_id, fvi_precio, fv_cotizacion, mon_id, fv_fecha
                          from facturaventaitem fvi 
                                  inner join facturaventa fv 
                                      on fvi.fv_id = fv.fv_id
                          where fvi.fv_id = @@doc_id
                            and round(fvi_precio,2) <> 0
      end
  
      if @@doct_id = 2 begin
                        select @us_id = modifico from facturacompra where fc_id = @@doc_id
                        declare c_items insensitive cursor for 
                          select pr_id, fci_precio, fc_cotizacion, mon_id, fc_fecha
                          from facturacompraitem fci
                                  inner join facturacompra fc
                                      on fci.fc_id = fc.fc_id
                          where fci.fc_id = @@doc_id
                            and round(fci_precio,2) <> 0
        end

      if @@doct_id = 3 begin
                        select @us_id = modifico from remitoventa where rv_id = @@doc_id
                        declare c_items insensitive cursor for 
                          select pr_id, rvi_precio, rv_cotizacion, mon_id, rv_fecha
                          from remitoventaitem rvi
                                  inner join remitoventa rv
                                      on rvi.rv_id = rv.rv_id
                                  inner join documento doc 
                                      on rv.doc_id = doc.doc_id
                          where rvi.rv_id = @@doc_id
                            and round(rvi_precio,2) <> 0
      end
  
      if @@doct_id = 4 begin
                        select @us_id = modifico from remitocompra where rc_id = @@doc_id
                        declare c_items insensitive cursor for 
                          select pr_id, rci_precio, rc_cotizacion, mon_id, rc_fecha
                          from remitocompraitem rci
                                  inner join remitocompra rc 
                                      on rci.rc_id = rc.rc_id
                                  inner join documento doc 
                                      on rc.doc_id = doc.doc_id
                          where rci.rc_id = @@doc_id
                            and round(rci_precio,2) <> 0
      end
  
    end else begin
  
      if @@doct_id = 1  begin
                        select @us_id = modifico from facturaventa where fv_id = @@doc_id

                        declare c_items insensitive cursor for 
                          select pr_id, fvi_precio, fv_cotizacion, mon_id, fv_fecha
                          from facturaventaitem fvi2
                                  inner join facturaventa fv
                                      on fvi2.fv_id = fv.fv_id
                          where fvi2.fv_id = @@doc_id
                            and round(fvi_precio,2) <> 0
                            and not exists(select fv.fv_id from facturaventaitem fvi 
                                                          inner join facturaventa fv on fvi.fv_id = fv.fv_id
                                           where  fv.fv_id <> @@doc_id 
                                              and fv_fecha > @@fecha
                                              and pr_id = fvi2.pr_id
                                          )
      end
  
      if @@doct_id = 2  begin
                        select @us_id = modifico from facturacompra where fc_id = @@doc_id

                        declare c_items insensitive cursor for 
                          select pr_id, fci_precio, fc_cotizacion, mon_id, fc_fecha
                          from facturacompraitem fci2
                                  inner join facturacompra fc 
                                      on fci2.fc_id = fc.fc_id
                          where fci2.fc_id = @@doc_id
                            and round(fci_precio,2) <> 0
                            and not exists(select fc.fc_id from facturacompraitem fci 
                                                          inner join facturacompra fc on fci.fc_id = fc.fc_id
                                           where  fc.fc_id <> @@doc_id 
                                              and fc_fecha > @@fecha
                                              and pr_id = fci2.pr_id
                                          )
      end
  
      if @@doct_id = 3  begin
                        select @us_id = modifico from remitoventa where rv_id = @@doc_id

                        declare c_items insensitive cursor for 
                          select pr_id, rvi_precio, rv_cotizacion, mon_id, rv_fecha
                          from remitoventaitem rvi2
                                  inner join remitoventa rv 
                                      on rvi2.rv_id = rv.rv_id
                                  inner join documento doc 
                                      on rv.doc_id = doc.doc_id
                          where rvi2.rv_id = @@doc_id
                            and round(rvi_precio,2) <> 0
                            and not exists(select rv.rv_id from remitoventaitem rvi 
                                                          inner join remitoventa rv on rvi.rv_id = rv.rv_id
                                           where  rv.rv_id <> @@doc_id 
                                              and rv_fecha > @@fecha
                                              and pr_id = rvi2.pr_id
                                          )
      end
  
      if @@doct_id = 4  begin
                        select @us_id = modifico from remitocompra where rc_id = @@doc_id

                        declare c_items insensitive cursor for 
                          select pr_id, rci_precio, rc_cotizacion, mon_id, rc_fecha
                           from remitocompraitem rci2
                                  inner join remitocompra rc 
                                      on rci2.rc_id = rc.rc_id
                                  inner join documento doc 
                                      on rc.doc_id = doc.doc_id
                          where rci2.rc_id = @@doc_id
                            and round(rci_precio,2) <> 0
                            and not exists(select rc.rc_id from remitocompraitem rci 
                                                          inner join remitocompra rc on rci.rc_id = rc.rc_id
                                           where  rc.rc_id <> @@doc_id 
                                              and rc_fecha > @@fecha
                                              and pr_id = rci2.pr_id
                                          )
      end
    end
  
    open c_listas
  
    declare @lp_id    int
    declare @lpi_id   int
    declare @pr_id     int
    declare @precio   decimal(18,6)
    declare @cotiz    decimal(18,6)

    declare @doc_fecha   datetime

    declare @mon_id_precio  int
    declare @mon_id_legal    int
    declare @mon_id_lista    int

    select @mon_id_legal = mon_id from Moneda where mon_legal <> 0
  
    fetch next from c_listas into @lp_id
    while @@fetch_status = 0
    begin

      select @mon_id_lista = mon_id from ListaPrecio where lp_id = @lp_id 
  
      open c_items
  
      fetch next from c_items into @pr_id, @precio, @cotiz, @mon_id_precio, @doc_fecha
      while @@fetch_status = 0
      begin

        -- Calculo el precio segun su moneda y cotizacion
        --

        if @mon_id_precio <> @mon_id_lista begin

          if @mon_id_lista = @mon_id_legal begin

            set @precio = @precio * @cotiz

          end else begin

            if @mon_id_precio = @mon_id_legal begin

              set @cotiz = 0
              exec sp_monedaGetCotizacion @mon_id_lista, @doc_fecha, 0, @cotiz out
              if @cotiz is null set @cotiz = 0

              -- Precio en moneda extranjera
              --
              if @cotiz = 0 set @precio = 0
              else          set @precio = @precio / @cotiz

            end else begin

              -- Paso a moneda legal el precio del documento
              --
              set @cotiz = 0
              exec sp_monedaGetCotizacion @mon_id_precio, @doc_fecha, 0, @cotiz out
              if @cotiz is null set @cotiz = 0
              
              -- Precio en moneda legal
              --
              set @precio = @precio * @cotiz

              -- Paso a la moneda de la lista de precios el precio en moneda legal
              --
              set @cotiz = 0
              exec sp_monedaGetCotizacion @mon_id_lista, @doc_fecha, 0, @cotiz out
              if @cotiz is null set @cotiz = 0

              -- Precio en moneda extranjera
              --
              if @cotiz = 0 set @precio = 0
              else          set @precio = @precio / @cotiz

            end
          end
        end

        -- Actualizo el precio
        --
        set @lpi_id = null
        select @lpi_id = lpi_id from ListaPrecioItem where lp_id = @lp_id and pr_id = @pr_id

        if @lpi_id is null begin
  
          exec sp_dbgetnewid 'ListaPrecioItem', 'lpi_id', @lpi_id out, 0
  
          insert into ListaPrecioItem (lp_id, lpi_id, lpi_precio, pr_id, modifico) 
                              values  (@lp_id, @lpi_id, @precio, @pr_id, @us_id)
  
        end else begin
  
          update ListaPrecioItem set lpi_precio = @precio, modifico = @us_id where lpi_id = @lpi_id
        end
  
        fetch next from c_items into @pr_id, @precio, @cotiz, @mon_id_precio, @doc_fecha
      end
  
      close c_items
  
      fetch next from c_listas into @lp_id
    end
  
    deallocate c_items
    close c_listas
    deallocate c_listas

  end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go