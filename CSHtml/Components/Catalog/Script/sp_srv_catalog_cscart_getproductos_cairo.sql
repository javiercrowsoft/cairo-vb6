if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_cscart_getproductos_cairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_cscart_getproductos_cairo]

go
/*

  update producto set modificado = getdate() where exists (select * from CatalogoWebItem where pr_id = producto.pr_id and catw_id = 3)

  update producto set modificado = getdate() where pr_codigo = 'q2612a'

  select pr_activoweb from producto where pr_codigo = '08668'

  exec sp_srv_catalog_cscart_getproductos_cairo 3

sp_srv_catalog_cscart_getproductos_cairo 3

*/

create procedure sp_srv_catalog_cscart_getproductos_cairo (
  @@catw_id int
)

as

begin

  set nocount on

  declare @desde     datetime
  declare @lp_id     int

  set @desde = '19000101'

  declare @cfg_clave varchar(255)
  declare @cfg_valor varchar(5000) 

  set @cfg_clave = 'Ultima Ejecucion - Productos_'+ convert(varchar,@@catw_id)

  exec sp_Cfg_GetValor  'Catalogo Web',
                        @cfg_clave,
                        @cfg_valor out,
                        0

  if isdate(@cfg_valor)<>0 begin

    set @desde = @cfg_valor
  end

  set @cfg_valor = convert(varchar,getdate(),121)
  exec sp_Cfg_SetValor 'Catalogo Web',
                       @cfg_clave, 
                       @cfg_valor

  exec sp_Cfg_GetValor  'Catalogo Web',
                        'Lista de Precios',
                        @cfg_valor out,
                        0

  if isnumeric(@cfg_valor)<>0 begin

    set @lp_id = convert(int,@cfg_valor)
  end

  update CatalogoWebItem set catwi_pendiente = 1
  from Producto pr left join Rubro rub on pr.rub_id = rub.rub_id
  where CatalogoWebItem.pr_id = pr.pr_id
    and  (pr_sevende <> 0 or isnull(rub_escriterio,0) <> 0)
    and pr.modificado > @desde 
    and catw_id = @@catw_id

  update CatalogoWebItem set catwi_pendiente = 1
  from Producto pr inner join ListaPrecioPrecio lpp on pr.pr_id = lpp.pr_id and lp_id = @lp_id
  where CatalogoWebItem.pr_id = pr.pr_id
    and  pr_sevende <> 0 
    and lpp.modificado > @desde 
    and catw_id = @@catw_id

  create table #t_catalog_data (  pr_id int, 
                                  precio decimal(18,6) not null default(0), 
                                  referidos varchar(5000) COLLATE SQL_Latin1_General_CP1_CI_AI not null default('')
                                )

  insert into #t_catalog_data(pr_id)
  select top 100 pr_id
  from CatalogoWebItem 
  where catw_id = @@catw_id
    and catwi_pendiente <> 0

  declare @pr_id     int
  declare @precio   decimal(18,6)

  declare @referidos       varchar(5000)
  declare @referido       varchar(5000)
  declare @prefijo        varchar(255)
  declare @last_prefijo    varchar(255)

  declare c_catalog_precios insensitive cursor for

    select pr_id from #t_catalog_data

  open c_catalog_precios

  fetch next from c_catalog_precios into @pr_id
  while @@fetch_status=0
  begin

    exec sp_LpGetPrecio @lp_id, @pr_id, @precio out

    update #t_catalog_data set precio = isnull(@precio,0) where pr_id = @pr_id

    set @referidos = ''
    set @last_prefijo = ''

    declare c_referidos insensitive cursor for 

-- Por nombre web

--       select 
--         case 
--           when pr_nombreweb <> '' then pr_nombreweb 
--           when pr_nombreventa <> '' then pr_nombreventa 
--           else pr_nombrecompra
--         end  as pr_nombre,
--         rubti_nombre
-- 
--       from Producto pr left join RubroTablaItem rubti on pr.rubti_id6 = rubti.rubti_id
--       where exists(  select pr_id from ProductoTag 
--                     where pr_id = pr.pr_id 
--                       and pr_id_tag = @pr_id
--                   )
--       order by rubti_nombre

-- Por prefijo y modelo

      select 
        t8.rubti_nombre,
        t6.rubti_nombre

      from Producto pr left join RubroTablaItem t6 on pr.rubti_id6 = t6.rubti_id
                       left join RubroTablaItem t8 on pr.rubti_id8 = t8.rubti_id
      where exists(  select pr_id from ProductoTag 
                    where pr_id = pr.pr_id 
                      and pr_id_tag = @pr_id
                  )
      order by t6.rubti_nombre, t8.rubti_nombre


    open c_referidos
    fetch next from c_referidos into @referido, @prefijo
    while @@fetch_status=0
    begin

      if @last_prefijo <> @prefijo begin

        set @last_prefijo = @prefijo 

        -- Por prefijo y modelo
        --
        set @referido = @prefijo + ' ' + @referido

      end

      -- Por nombre web
      --
      -- else begin

        -- set @referido = replace (@referido, @last_prefijo, '')

      -- end

      set @referidos = @referidos + @referido + ', '
      fetch next from c_referidos into @referido, @prefijo

    end
    close c_referidos
    deallocate c_referidos

    if len(@referidos)>0 begin

      set @referidos = left(@referidos,len(@referidos)-1)

      update #t_catalog_data set referidos = @referidos where pr_id = @pr_id

    end

    fetch next from c_catalog_precios into @pr_id
  end
  close c_catalog_precios
  deallocate c_catalog_precios  

  select   
          pr.pr_id, 
          pr_nombreventa          as pr_nombre, 
          pr_codigo                as pr_codigo, 
          pr_descripcompra        as pr_descrip, 
          t1.rubti_nombre         as pr_codigopadre,
          t2.rubti_nombre         as pr_orden,  
          pr_codigohtml           as pr_codigohtml,
          pr_codigohtmldetalle    as pr_codigohtmldetalle,
          marc_nombre             as pr_marca,
          ti_porcentaje           as pr_iva,
          pr_aliasweb             as pr_aliasweb,
          pr_nombreweb            as pr_nombreweb,
          t.precio                as precio,

          case 
            when isnull(rub_escriterio,0) <> 0 then 0
            else                                     pr_activoweb
          end                     as activo,

          pr_expoweb              as exposicion_web,
          rub_nombre              as rubro,
          pr_ventaWebMaxima        as venta_maxima,

          rubti1.rubti_nombre      as atributo01,
          rubti2.rubti_nombre      as atributo02,
          rubti3.rubti_nombre      as atributo03,
          rubti4.rubti_nombre      as atributo04,
          rubti5.rubti_nombre      as atributo05,
          rubti6.rubti_nombre      as atributo06,
          rubti7.rubti_nombre      as atributo07,
          rubti8.rubti_nombre      as atributo08,
          rubti9.rubti_nombre      as atributo09,

          rubti10.rubti_nombre    as atributo10,

          t.referidos              as referidos,

-----------------------------------------------------------------
          pr_codigo               as product_code,
          'N'                      as product_type,
          0                        as owner_id,
          'Y'                      as avail,
          0                        as manufacturer_id,
          t.precio                as list_price,
          0                        as amount,
          0                        as min_amount,
          0                        as weight,
          0                        as length,
          0                        as width,
          0                        as height,
          0                        as shipping_freight,
          0                        as low_avail_limit,
          0                        as [timestamp],
          'N'                     as is_edp,
          'N'                     as edp_shipping,
          'B'                     as tracking,
          'N'                     as free_shipping,
          'N'                     as feature_comparison,
          'R'                     as zero_price_action,
          'N'                     as is_pbp,
          'N'                     as is_op,
          'N'                     as is_oper,
          0                        as supplier_id,
          'Y'                     as is_returnable,
          10                      as return_period,
-----------------------------------------------------------------
          'ES'                    as lang_code,
          pr_nombreweb            as product,
          ''                      as shortname,
          --pr_codigohtml           as short_description,
          ''                       as short_description,
          ''                      as full_description,
          ''                      as meta_keywords,
          ''                      as meta_description,
          ''                      as search_words,
          ''                      as page_title,
-----------------------------------------------------------------
          t.precio                as price,
          1                        as lower_limit
-----------------------------------------------------------------

  from producto pr inner join #t_catalog_data t     on pr.pr_id = t.pr_id
                   inner join CatalogoWebItem catwi   on pr.pr_id = catwi.pr_id
    
                   left join rubrotablaitem t1     on pr.rubti_id1 = t1.rubti_id
                   left join rubrotablaitem t2     on pr.rubti_id2 = t2.rubti_id
                   left join marca marc           on pr.marc_id = marc.marc_id
                   left join tasaimpositiva ti    on pr.ti_id_ivariventa = ti.ti_id


                    left join rubro rub on pr.rub_id = rub.rub_id

                    left join rubrotablaitem rubti1  on pr.rubti_id1  = rubti1.rubti_id
                    left join rubrotablaitem rubti2  on pr.rubti_id2  = rubti2.rubti_id
                    left join rubrotablaitem rubti3  on pr.rubti_id3  = rubti3.rubti_id
                    left join rubrotablaitem rubti4  on pr.rubti_id4  = rubti4.rubti_id
                    left join rubrotablaitem rubti5  on pr.rubti_id5  = rubti5.rubti_id
                    left join rubrotablaitem rubti6  on pr.rubti_id6  = rubti6.rubti_id
                    left join rubrotablaitem rubti7  on pr.rubti_id7  = rubti7.rubti_id
                    left join rubrotablaitem rubti8  on pr.rubti_id8  = rubti8.rubti_id
                    left join rubrotablaitem rubti9  on pr.rubti_id9  = rubti9.rubti_id
                    left join rubrotablaitem rubti10 on pr.rubti_id10 = rubti10.rubti_id
                   
  where (pr_sevende <> 0 or isnull(rub_escriterio,0) <> 0)
    and catwi.catw_id = @@catw_id 
    and catwi_pendiente <> 0

  update CatalogoWebItem set catwi_pendiente = 0
  where catw_id = @@catw_id
    and exists(select * from #t_catalog_data t where t.pr_id = CatalogoWebItem.pr_id)

end