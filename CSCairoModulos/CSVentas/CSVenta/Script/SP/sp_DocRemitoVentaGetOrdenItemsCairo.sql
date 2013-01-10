if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetOrdenItemsCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetOrdenItemsCairo]

go

/*

sp_DocRemitoVentaGetOrdenItemsCairo '11'

*/

create procedure sp_DocRemitoVentaGetOrdenItemsCairo (
  @@strIds varchar(5000)
)
as

begin

  set nocount on

  declare @timeCode datetime
  set @timeCode = getdate()
  exec sp_strStringToTable @timeCode, @@strIds, ','

    select 
          osi_id,
          os.os_id,
          os_fecha,
          os_numero,
          os_nrodoc,
          pr_nombreventa,
          pr_llevanroserie,
          pr_llevanrolote,
          pr_lotefifo,
          pr_eskit,
          osi.pr_id,
  
          case 
            when cli_catfiscal = 1  or
                 cli_catfiscal = 2  or
                 cli_catfiscal = 3  or
                 cli_catfiscal = 4  or
                 cli_catfiscal = 6  or
                 cli_catfiscal = 7  or
                 cli_catfiscal = 8  or
                 cli_catfiscal = 9  or
                 cli_catfiscal = 10 or
                 cli_catfiscal = 11 then 
                        ((osi_neto / osi_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'
  
            -- No inscripto
            --
            when cli_catfiscal = 3 
              or cli_catfiscal = 10 then 
                        ((osi_neto / osi_cantidad) * (1+tiri.ti_porcentaje/100)) + 
                        ((osi_neto / osi_cantidad) * (1+tirni.ti_porcentaje/100))
  
            -- Exentos
            else        (osi_neto / osi_cantidad)
  
          end osi_precio,
  
          osi_cantidadaremitir,
          osi_pendiente,
  
          case 
            when cli_catfiscal = 1  or
                 cli_catfiscal = 2  or
                 cli_catfiscal = 3  or
                 cli_catfiscal = 4  or
                 cli_catfiscal = 6  or
                 cli_catfiscal = 7  or
                 cli_catfiscal = 8  or
                 cli_catfiscal = 9  or
                 cli_catfiscal = 10 or
                 cli_catfiscal = 11 then 
                        osi_pendiente * ((osi_neto / osi_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'
  
            -- No inscripto
            --
            when cli_catfiscal = 3 
              or cli_catfiscal = 10 then 
                        osi_pendiente * ((osi_neto / osi_cantidad) * (1+tiri.ti_porcentaje/100)) + 
                        osi_pendiente * ((osi_neto / osi_cantidad) * (1+tirni.ti_porcentaje/100))
  
            -- Exentos
            else        osi_pendiente * (osi_neto / osi_cantidad)
  
          end osi_importe,
  
          osi_descrip,
          osi_precio2 = osi_precio,
          osi_precioLista,
          osi_precioUsr,
          osi_descuento,
          osi.ccos_id,
  
          case cli_catfiscal
            when 1  then tiri.ti_porcentaje    --'Inscripto'
            when 2  then tiri.ti_porcentaje    -- FALTA VERIFICAR QUE SEA ASI --'Exento'
            when 3  then tiri.ti_porcentaje    --'No inscripto'
            when 4  then tiri.ti_porcentaje    --'Consumidor Final'
            when 6  then tiri.ti_porcentaje    --'Mono Tributo'
            when 7  then tiri.ti_porcentaje    --'Extranjero Iva'
            when 8  then tiri.ti_porcentaje    --'No responsable'
            when 9  then tiri.ti_porcentaje    -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
            when 10 then tiri.ti_porcentaje    --'No categorizado'
            when 11 then tiri.ti_porcentaje    --'InscriptoM'
            else         0           
          end osi_ivariporc,
  
          case cli_catfiscal
            when 3  then tirni.ti_porcentaje     --'No inscripto'
            when 10 then tirni.ti_porcentaje     --'No categorizado'
            else         0                        
          end osi_ivarniporc,

          osi_id as prns_group_id
  
    from OrdenServicio os inner join OrdenServicioItem osi   on osi.os_id = os.os_id
                          inner join TmpStringToTable        on os.os_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                          inner join Producto p             on osi.pr_id = p.pr_id
                          inner join Cliente cli            on os.cli_id = cli.cli_id
                          inner join TasaImpositiva tiri    on p.ti_id_ivariventa  = tiri.ti_id
                          left  join TasaImpositiva tirni   on p.ti_id_ivarniventa = tirni.ti_id
    where 
            osi_pendiente > 0
      and   tmpstr2tbl_id =  @timeCode
  
  union  

    select 
          -prpi_id as osi_id,
          os.os_id,
          os_fecha,
          os_numero,
          os_nrodoc + ' ' + prp_nrodoc as os_nrodoc,
          case pr_sevende
            when 0 then pr_nombrecompra
            else        pr_nombreventa
          end      as pr_nombreventa,
          0       as pr_llevanroserie,
          0       as pr_llevanrolote,
          0       as pr_lotefifo,
          0       as pr_eskit,
          prpi.pr_id,
  
          case 
            when cli_catfiscal = 1  or
                 cli_catfiscal = 2  or
                 cli_catfiscal = 3  or
                 cli_catfiscal = 4  or
                 cli_catfiscal = 6  or
                 cli_catfiscal = 7  or
                 cli_catfiscal = 8  or
                 cli_catfiscal = 9  or
                 cli_catfiscal = 10 or
                 cli_catfiscal = 11 then 
                        ((prpi_neto / prpi_cantidad) * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100))    --'Inscripto'
  
            -- No inscripto
            --
            when cli_catfiscal = 3 
              or cli_catfiscal = 10 then 
                        ((prpi_neto / prpi_cantidad) * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)) + 
                        ((prpi_neto / prpi_cantidad) * (1+isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)/100))
  
            -- Exentos
            else        (prpi_neto / prpi_cantidad)
  
          end prpi_precio,
  
          prpi_cantidad,
          prpi_cantidad as prpi_pendiente,
  
          case 
            when cli_catfiscal = 1  or
                 cli_catfiscal = 2  or
                 cli_catfiscal = 3  or
                 cli_catfiscal = 4  or
                 cli_catfiscal = 6  or
                 cli_catfiscal = 7  or
                 cli_catfiscal = 8  or
                 cli_catfiscal = 9  or
                 cli_catfiscal = 10 or
                 cli_catfiscal = 11 then 
                        prpi_neto * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)    --'Inscripto'
  
            -- No inscripto
            --
            when cli_catfiscal = 3 
              or cli_catfiscal = 10 then 
                        (prpi_neto * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)) + 
                        (prpi_neto * (1+isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)/100))
  
            -- Exentos
            else        prpi_neto
  
          end prpi_importe,
  
          prpi_descrip,
          prpi_precio2 = prpi_precio,
          prpi_precioLista,
          prpi_precioUsr,
          prpi_descuento,
          prpi.ccos_id,
  
          case cli_catfiscal
            when 1  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Inscripto'
            when 2  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    -- FALTA VERIFICAR QUE SEA ASI --'Exento'
            when 3  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'No inscripto'
            when 4  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Consumidor Final'
            when 6  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Mono Tributo'
            when 7  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Extranjero Iva'
            when 8  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'No responsable'
            when 9  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
            when 10 then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'No categorizado'
            when 11 then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'InscriptoM'
            else         0           
          end prpi_ivariporc,
  
          case cli_catfiscal
            when 3  then isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)     --'No inscripto'
            when 10 then isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)     --'No categorizado'
            else         0                        
          end prpi_ivarniporc,

          0  as prns_group_id
  
    from (OrdenServicio os     
                          inner join stock st on os.st_id = st.st_id
                          inner join stockitem sti on st.st_id = sti.st_id and sti_ingreso > 0
                          inner join partereparacion prp on sti.prns_id = prp.prns_id
                                                          and prp.os_id = os.os_id
         )
    
                          inner join ParteReparacionItem prpi   on prp.prp_id = prpi.prp_id
  
                          inner join TmpStringToTable        on os.os_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                          inner join Producto p             on prpi.pr_id = p.pr_id
                          inner join Cliente cli            on os.cli_id = cli.cli_id

                          left  join TasaImpositiva tiri    on p.ti_id_ivariventa  = tiri.ti_id
                          left  join TasaImpositiva tirni   on p.ti_id_ivarniventa = tirni.ti_id
                          left  join TasaImpositiva tiri2    on p.ti_id_ivaricompra  = tiri2.ti_id
                          left  join TasaImpositiva tirni2   on p.ti_id_ivarnicompra = tirni2.ti_id
    where 
            prp_tipo = 2 -- Reparacion
      and   tmpstr2tbl_id =  @timeCode
  

  order by 

        os_nrodoc,
        os_fecha,
        osi_id desc


  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  NUMEROS DE SERIE
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select 
                  prns.prns_id,
                  prns.stl_id,

                  case when prns_codigo2<>'' then prns_codigo + ' | ' + prns_codigo2
                       else                        prns_codigo
                  end  as prns_codigo,

                  prns_descrip,
                  prns_fechavto,
                  osi_id,
                  stl_codigo,
                  osi_id as prns_group_id

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join OrdenServicioItem osi     on sti.sti_grupo  = osi.osi_id
                                inner join OrdenServicio os         on osi.os_id      = os.os_id
                                inner join TmpStringToTable          on os.os_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                                left  join StockLote stl            on prns.stl_id    = stl.stl_id

  where osi_pendiente > 0
    and sti.st_id = os.st_id
    and tmpstr2tbl_id =  @timeCode

  group by
          prns.prns_id,
          prns.stl_id,
          prns_codigo,
          prns_codigo2,
          prns_descrip,
          prns_fechavto,
          osi_id,
          stl_codigo

  order by
          osi_id

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  Info Kit
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////
  declare @pr_id int

  create table #KitItems      (
                                pr_id int not null, 
                                nivel int not null
                              )

  create table #KitItemsSerie(
                                pr_id_kit       int null,
                                cantidad         decimal(18,6) not null,
                                pr_id           int not null, 
                                prk_id           int not null,
                                nivel           smallint not null default(0)
                              )

  declare c_KitItem insensitive cursor for 
                                              select 
                                                    osi.pr_id
                                            
                                              from OrdenServicio os inner join OrdenServicioItem osi   on osi.os_id = os.os_id
                                                                    inner join TmpStringToTable        on os.os_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                                                                    inner join Producto p             on osi.pr_id = p.pr_id
                                              where 
                                                      osi_pendiente > 0
                                                and   tmpstr2tbl_id =  @timeCode
                                                and   p.pr_eskit <> 0
                                            
                                              group by osi.pr_id
  
  open c_KitItem

  fetch next from c_KitItem into @pr_id
  while @@fetch_status = 0 begin

    exec sp_StockProductoGetKitInfo @pr_id, 0

    update #KitItemsSerie set pr_id_kit = @pr_id where pr_id_kit is null

    fetch next from c_KitItem into @pr_id
  end

  close c_KitItem
  deallocate c_KitItem

  select 
          k.pr_id_kit     as pr_id,
          k.pr_id         as pr_id_item, 
          pr_nombrecompra,
          pr_llevanroserie,
          cantidad 
  from 
          #KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id
end
go