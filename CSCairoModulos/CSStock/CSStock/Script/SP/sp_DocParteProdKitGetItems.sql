if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitGetItems]

go

/*

sp_DocParteProdKitGetItems 7003

*/
create procedure sp_DocParteProdKitGetItems (
  @@ppk_id int
)
as

begin

  set nocount on

  declare @st_id         int
  declare @bDesarme      tinyint

  select @st_id = st_id1,

         @bDesarme = case doct_id 
                        when 34 /*Desarme*/ then 1
                        else                      0
                     end

  from ParteProdKit where ppk_id = @@ppk_id

  select   ParteProdKitItem.*, 
          pr_nombrecompra, 
          (
            select min(stik_llevanroserie) from StockItemKit where pr_id = ParteProdKitItem.pr_id and st_id = @st_id 
          ) as pr_llevanroserie,
          pr_eskit,
          un_nombre,
          depl_nombre,
          prfk_nombre,
          pr_kitResumido,
          pr_kitIdentidad,
          case when exists(select prka_id 
                           from ProductoKitItemA pka 
                                inner join ProductoKit pk on     pka.prk_id = pk.prk_id
                                                            and prfk_id = prfk.prfk_id)
               then    1
               else    0
          end  as tiene_alternativas

  from   ParteProdKitItem
        inner join Producto                 on ParteProdKitItem.pr_id     = Producto.pr_id
        inner join DepositoLogico           on ParteProdKitItem.depl_id   = DepositoLogico.depl_id
        inner join ProductoFormulaKit prfk  on ParteProdKitItem.prfk_id   = prfk.prfk_id
        inner join Unidad                   on Producto.un_id_stock       = unidad.un_id

  where 
          ppk_id     = @@ppk_id
    and    pr_eskit   <> 0

  order by ppki_orden

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  NUMEROS DE SERIE
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select 
                  prns.pr_id,
                  pr_nombrecompra,
                  prns.prns_id,
                  prns_codigo,
                  prns_descrip,
                  prns_fechavto,
                  sti.pr_id_kit,
                  ppki_id

  from (
        (ParteProdKitItem ppki inner join ParteProdKit ppk           on ppki.ppk_id   = ppk.ppk_id)

                             inner join StockItem sti               on sti.st_id     = ppk.st_id2
                                                                    
      )

                             inner join  ProductoNumeroSerie prns    on prns.prns_id  = sti.prns_id 
                             
                             inner join Producto p                   on prns.pr_id    = p.pr_id

                              -- Obtengo los datos desde el movimiento de consumo
                              --
  where ppki.ppk_id = @@ppk_id 

    and sti.prsk_id is null    -- Solo los partes que no llevan identidad

    and sti.sti_grupo  = ppki.ppki_id

  group by
          prns.prns_id,
          prns.pr_id,
          pr_nombrecompra,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          sti.pr_id_kit,
          ppki_id
  order by
          ppki_id

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

        select stik.pr_id 
        from StockItemKit stik inner join Producto pr on stik.pr_id = pr.pr_id
        where st_id = @st_id
          and pr_kitResumido <> 0 -- Solo los que no son de produccion resumida
  
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


  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  KITS CON PRODUCCION RESUMIDA
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  ------------------------------------
  -- ProductoSerieKit
  --
  select  
          case  
              when @bDesarme = 0 then  pk.ppki_id
              else                    pk.ppki_id_desarme
          end  as ppki_id,
          pk.prsk_id,
          pk.pr_id,
          pk.prns_id,
          pk.prfk_id,
          pk.stl_id,
          pr_nombrecompra,
          prns_codigo,
          stl_codigo

  from (ProductoSerieKit pk  inner join ParteProdKitItem ppki     on   
                                                                    (    pk.ppki_id  = ppki.ppki_id
                                                                      or
                                                                        pk.ppki_id_desarme = ppki.ppki_id
                                                                    )
                                                                  and ppki.ppk_id = @@ppk_id)
  
                            inner join Producto pr              on pk.pr_id   = pr.pr_id
                            inner join ProductoNumeroSerie prns on pk.prns_id = prns.prns_id
                            left  join StockLote stl            on pk.stl_id  = stl.stl_id
  order by pk.ppki_id

  if @bDesarme = 0 begin

    ------------------------------------
    -- ProductoSerieKitItem
    --
    select  pk.ppki_id,
            pki.prsk_id,
            pki.prski_id,
            pki.prski_cantidad,
            pki.prk_id,
            pki.pr_id,
            pki.prns_id,
            pki.stl_id,
            pr_nombrecompra,
            prk_variable,
            prns_codigo,
            stl_codigo
  
    from (ProductoSerieKitItem pki inner join ProductoSerieKit pk   on  pki.prsk_id = pk.prsk_id
                                   inner join ParteProdKitItem ppki on  pk.ppki_id  = ppki.ppki_id
                                                                    and ppki.ppk_id = @@ppk_id)
  
                                  inner join Producto pr              on pki.pr_id   = pr.pr_id
                                  inner join ProductoKit prk          on pki.prk_id  = prk.prk_id
                                  left  join ProductoNumeroSerie prns on pki.prns_id = prns.prns_id
                                   left  join StockLote stl            on pki.stl_id  = stl.stl_id
    order by   pk.ppki_id, 
              pki.prsk_id,
              pki.prk_id,
              pki.prski_id
            
  end else begin

    select  pk.ppki_id_desarme,
            pk.prsk_id,
            0     as prski_id,
            1     as prski_cantidad,
            -100   as prk_id, /*uso -100 como prk_id virtual para los desarmes*/
            pk.pr_id,
            pk.prns_id,
            pk.stl_id,
            pr_nombrecompra,
            0      as prk_variable,
            prns_codigo,
            ''     as stl_codigo

    from ProductoSerieKit pk      inner join ParteProdKitItem ppki on     pk.ppki_id_desarme = ppki.ppki_id
                                                                    and ppki.ppk_id        = @@ppk_id

                                 inner join Producto pr              on pk.pr_id   = pr.pr_id
                                 left  join ProductoNumeroSerie prns on pk.prns_id = prns.prns_id

  end

  ------------------------------------
  -- Alternativas
  --
  select ppkia.ppki_id,
         ppkia_id,
         ppkia_cantidad,
         ppkia.pr_id,
         ppkia.prk_id,
         pr_nombrecompra
  
  from (ParteProdKitItemA ppkia inner join ParteProdKitItem ppki on ppkia.ppki_id = ppki.ppki_id
                                                                and ppki.ppk_id   = @@ppk_id)

                               inner join Producto pr           on  ppkia.pr_id     = pr.pr_id
  order by ppkia.ppki_id

end