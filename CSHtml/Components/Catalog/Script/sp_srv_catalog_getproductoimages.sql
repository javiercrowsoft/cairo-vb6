if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_cscart_getproductos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_cscart_getproductos]

go
/*

  update producto set modificado = getdate()

  sp_srv_catalog_cscart_getproductos 1


*/

create procedure sp_srv_catalog_cscart_getproductos (
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
  from Producto pr
  where CatalogoWebItem.pr_id = pr.pr_id
    and  pr_sevende <> 0 
    and pr.modificado > @desde 
    and catw_id = @@catw_id

  update CatalogoWebItem set catwi_pendiente = 1
  from Producto pr inner join ListaPrecioPrecio lpp on pr.pr_id = lpp.pr_id and lp_id = @lp_id
  where CatalogoWebItem.pr_id = pr.pr_id
    and  pr_sevende <> 0 
    and lpp.modificado > @desde 
    and catw_id = @@catw_id

  create table #t_catalog_precio (pr_id int, precio decimal(18,6) not null default(0))

  insert into #t_catalog_precio(pr_id)
  select top 100 pr_id
  from CatalogoWebItem 
  where catw_id = @@catw_id
    and catwi_pendiente <> 0

  declare @pr_id     int
  declare @precio   decimal(18,6)

  declare c_catalog_precios insensitive cursor for

    select pr_id from #t_catalog_precio

  open c_catalog_precios

  fetch next from c_catalog_precios into @pr_id
  while @@fetch_status=0
  begin

    exec sp_LpGetPrecio @lp_id, @pr_id, @precio out

    update #t_catalog_precio set precio = isnull(@precio,0) where pr_id = @pr_id

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
          pr_activoweb            as activo,
-----------------------------------------------------------------
          pr_codigo               as producto_code,
          'N'                      as product_type,
          0                        as owner_id,
          'Y'                      as avail,
          0                        as manufacturer_id,
          0                        as list_price,
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
          'EN'                    as lang_code,
          pr_nombreweb            as product,
          ''                      as shortname,
          ''                      as short_description,
          ''                      as full_description,
          ''                      as meta_keywords,
          ''                      as meta_description,
          ''                      as search_words,
          ''                      as page_title
-----------------------------------------------------------------

  from producto pr inner join #t_catalog_precio t     on pr.pr_id = t.pr_id
                   inner join CatalogoWebItem catwi   on pr.pr_id = catwi.pr_id
    
                   left join rubrotablaitem t1     on pr.rubti_id1 = t1.rubti_id
                   left join rubrotablaitem t2     on pr.rubti_id2 = t2.rubti_id
                   left join marca marc           on pr.marc_id = marc.marc_id
                   left join tasaimpositiva ti    on pr.ti_id_ivariventa = ti.ti_id
                   
  where pr_sevende <> 0
    and catwi.catw_id = @@catw_id 
    and catwi_pendiente <> 0

  update CatalogoWebItem set catwi_pendiente = 0
  where catw_id = @@catw_id
    and exists(select * from #t_catalog_precio t where t.pr_id = CatalogoWebItem.pr_id)

end