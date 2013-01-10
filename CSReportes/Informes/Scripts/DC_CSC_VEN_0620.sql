/*---------------------------------------------------------------------
Nombre: Tabla de Productos para BuscaPe
---------------------------------------------------------------------*/
/*  

 [DC_CSC_VEN_0620] 79,'1','N82617','102','Todo en Cartuchos','http://www.todoencartuchos.com/catalog/lib/index.php?pr_id=','http://www.todoencartuchos.com/catalog/lib/images/','Contado','Cartuchos para Impresoras','Segun stock del dia de la compra',-1

*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0620]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0620]
GO


create procedure DC_CSC_VEN_0620 (

  @@us_id            int,
  @@emp_id          varchar(255),
  @@pr_id           varchar(255),
  @@catw_id         varchar(255),
  @@lp_id           varchar(255),
  @@emp_nombre      varchar(255),
  @@link            varchar(5000),
  @@link_img        varchar(5000),
  @@financiacion    varchar(255),
  @@categoria       varchar(255),
  @@disponibilidad  varchar(255),
  @@conIva          smallint
) 

as 

begin

  set nocount on
  
  /*- ///////////////////////////////////////////////////////////////////////
  
  INICIO PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  declare @pr_id     int
  declare @catw_id  int
  declare @lp_id     int

  declare @ram_id_Producto int
  declare @ram_id_Listaprecio int
  declare @ram_id_Catalogoweb int
  
  declare @clienteID int
  declare @IsRaiz    tinyint

  exec sp_ArbConvertId @@pr_id,   @pr_id out,   @ram_id_Producto out
  exec sp_ArbConvertId @@lp_id,   @lp_id out,   @ram_id_Listaprecio out
  exec sp_ArbConvertId @@catw_id, @catw_id out, @ram_id_Catalogoweb out
  
  if @lp_id = 0 begin

    select 1, 'Debe seleccionar una sola lista de precios' as Info, '' as dummy
    return  
  end
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_Producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
    end else 
      set @ram_id_Producto = 0
  end

  if @ram_id_Catalogoweb <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Catalogoweb, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Catalogoweb, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Catalogoweb, @clienteID 
    end else 
      set @ram_id_Catalogoweb = 0
  end
  
  /*- ///////////////////////////////////////////////////////////////////////
  
  FIN PRIMERA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  create table #t_producto (pr_id int not null)

  insert into #t_producto  (pr_id)
  select c.pr_id 
  from CatalogoWebItem c inner join Producto pr on c.pr_id = pr.pr_id
  where (catw_id = @catw_id or @catw_id = 0)
    and (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1035
                  and  rptarb_hojaid = catw_id
                 ) 
           )
        or 
           (@ram_id_Catalogoweb = 0)
       )
    and pr.pr_activoweb <> 0

  --/////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --

    create table #t_catalog_precio (
                                    pr_id       int, 
                                    precio       decimal(18,6) not null default(0), 
                                    descripiva   varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AI not null default('')
                                   )
  
    insert into #t_catalog_precio(pr_id)
    select pr_id
    from Producto
    where   (pr_id = @pr_id or @pr_id=0)
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30 
                        and  rptarb_hojaid = pr_id
                       ) 
                 )
              or 
                 (@ram_id_Producto = 0)
             )
      and   exists(select * from #t_producto where pr_id = Producto.pr_id)
  
    declare @precio       decimal(18,6)
    declare @precioiva    decimal(18,2)
    declare @ivaporc      decimal(18,2)
    declare @leyenda_iva  varchar(255)

    declare c_catalog_precios insensitive cursor for
  
      select pr_id from #t_catalog_precio
  
    open c_catalog_precios
  
    fetch next from c_catalog_precios into @pr_id
    while @@fetch_status=0
    begin
  
      exec sp_LpGetPrecio @lp_id, @pr_id, @precio out

      set @precio = isnull(@precio,0)
      set @leyenda_iva = ''
  
      if @@conIva <> 0 begin

        select @ivaporc = ti_porcentaje 
        from TasaImpositiva ti inner join Producto pr on ti.ti_id = pr.ti_id_ivariventa
        where pr_id = @pr_id

        set @ivaporc     = isnull(@ivaporc,0)
        set @precioiva   = @precio + (@precio * @ivaporc/100)

        set @leyenda_iva = ' - los precios no incluyen IVA. (IVA incluido ' 
                            + convert(varchar(50),@ivaporc) + '% '
                            + convert(varchar(50),@precioiva) +')'
      end

      update #t_catalog_precio

            set precio      = @precio, 
                descripiva = @leyenda_iva

      where pr_id = @pr_id
  
      fetch next from c_catalog_precios into @pr_id
    end
    close c_catalog_precios
    deallocate c_catalog_precios  

  --
  --
  --/////////////////////////////////////////////////////////////////////////////////////////////////////////
  set @@link=replace(@@link, '&','&amp;')
  set @@link_img=replace(@@link_img, '&','&amp;')
  set @@categoria=replace(@@categoria, '&','&amp;')
  set @@disponibilidad=replace(@@disponibilidad, '&','&amp;')

  select c.pr_id,
         replace(
         case when pr_nombreweb <> '' then pr_nombreweb + descripiva
              else                          pr_nombreventa + descripiva
         end, '&','&amp;')
                          as Descripcion,
         pr_codigo         as Codigo,
         @@link + convert(varchar,c.pr_id)
                          as Link,
         c.precio         as Precio,
         @@financiacion    as Financiacion,
         @@link_img + pr_codigo + '.jpg'
                          as Imagen,
         @@categoria      as Categoria,
         @@disponibilidad as Disponibilidad,
         0.9               as priority

  from #t_catalog_precio c inner join Producto pr on c.pr_id   = pr.pr_id
                           left  join Rubro rub   on pr.rub_id = rub.rub_id

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


