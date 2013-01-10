if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_catalog_getproductotags]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_catalog_getproductotags]

go
/*

 sp_srv_catalog_getproductotags 3 --select * from catalogoweb

*/

create procedure sp_srv_catalog_getproductotags (
  @@catw_id int
)

as

begin

  set nocount on

  create table #t_catalog_producto (pr_id int not null)
  create table #t_catalog_tag(prt_id int not null)

  declare @desde datetime

  set @desde = '19000101'

  declare @cfg_clave varchar(255)
  declare @cfg_valor varchar(5000) 

  set @cfg_clave = 'Ultima Ejecucion - Productos - Tag_'+ convert(varchar,@@catw_id)

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

  insert into CatalogoWebProductoTag (catw_id, prt_id)
          select @@catw_id, prt_id
          from Producto pr inner join CatalogoWebItem catwi on     pr.pr_id = catwi.pr_id
                                                              and catwi.catw_id = @@catw_id

                           inner join ProductoTag prt       on pr.pr_id = prt.pr_id

                           left  join Rubro rub             on pr.rub_id = rub.rub_id

          where pr.modificado > @desde
            and (pr_sevende <> 0 or isnull(rub_escriterio,0) <> 0)
            and not exists(select * from CatalogoWebProductoTag where catw_id = @@catw_id and prt_id = prt.prt_id)


  insert into #t_catalog_producto
  select   top 30 
          prt.pr_id

  from ProductoTag prt inner join CatalogoWebProductoTag t 
           on prt.prt_id = t.prt_id 
          and t.catw_id = @@catw_id
  group by prt.pr_id

  insert into #t_catalog_tag
  select 
          prt.prt_id

  from ProductoTag prt inner join CatalogoWebProductoTag t 
           on prt.prt_id = t.prt_id 
          and t.catw_id = @@catw_id
  where exists(select * from #t_catalog_producto where pr_id = prt.pr_id)

  select   prt.prt_id, 
          prt.pr_id,
          prt_texto,
          prt_expoweb      as exposicion_web,
          prt.pr_id_tag    as pr_id_tag

  from ProductoTag prt inner join #t_catalog_tag t on prt.prt_id = t.prt_id
  order by prt.pr_id

  delete CatalogoWebProductoTag 
  where exists( select * from #t_catalog_tag t 
                where t.prt_id = CatalogoWebProductoTag.prt_id 
              )
    and catw_id = @@catw_id
end