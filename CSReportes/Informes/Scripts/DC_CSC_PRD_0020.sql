/*---------------------------------------------------------------------
Nombre: Listar articulos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRD_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRD_0020]

/*

  [DC_CSC_PRD_0020] 1,'20071115 00:00:00','1628',0,1,184,'0','0',17,395,382,0,0,0,0,0,0,0

*/

go
create procedure DC_CSC_PRD_0020 (

  @@us_id          int,

  @@Ffin             datetime,
  @@pr_id          varchar(255),
  @@metodoVal      smallint,
  @@bShowInsumo    smallint,
  @@lp_id          int,
  @@suc_id         varchar(255), 
  @@emp_id          varchar(255),

  @@prfk_id01       int, 
  @@prfk_id02       int, 
  @@prfk_id03       int, 
  @@prfk_id04       int, 
  @@prfk_id05       int, 
  @@prfk_id06       int, 
  @@prfk_id07       int, 
  @@prfk_id08       int, 
  @@prfk_id09       int, 
  @@prfk_id10       int
)as 

begin

set nocount on

  declare @pr_id         int
  declare @suc_id       int
  declare @emp_id       int
  
  declare @ram_id_Producto          int
  declare @ram_id_Sucursal         int
  declare @ram_id_empresa          int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@pr_id,        @pr_id  out,       @ram_id_Producto out
  exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_Sucursal out
  exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_Producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
    end else 
      set @ram_id_Producto = 0
  end

  if @ram_id_Sucursal <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
    end else 
      set @ram_id_Sucursal = 0
  end
  
  if @ram_id_empresa <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
    end else 
      set @ram_id_empresa = 0
  end

declare @pr_id_item         int
declare @pr_id_kit          int
declare @costo              decimal(18,6)
declare @costo_item         decimal(18,6)
declare @cantidad           decimal(18,6)
declare @fc_id              int
declare @rc_id              int
declare @pr_stockcompra     decimal(18,6)
declare @cotiz              decimal(18,6)
declare @bAddPrIdKitToTable tinyint

  create table #FormulasKit (prfk_id int)

  if @@prfk_id02 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id02)
  end
  if @@prfk_id03 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id03)
  end
  if @@prfk_id04 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id04)
  end
  if @@prfk_id05 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id05)
  end
  if @@prfk_id06 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id06)
  end
  if @@prfk_id07 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id07)
  end
  if @@prfk_id08 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id08)
  end
  if @@prfk_id09 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id09)
  end
  if @@prfk_id10 <> 0 begin
    insert into #FormulasKit(prfk_id) values(@@prfk_id10)
  end

  create table #t_dc_csc_prd_0020(pr_id           int not null, 
                                  pr_id_insumo    int null,
                                  pr_id_kit       int null,
                                  cantidad         decimal(18,6) not null default(0), 
                                  costo           decimal(18,6) not null default(0)
                                  )
  
  insert into #t_dc_csc_prd_0020 (pr_id)
      
          select pr_id
          from Producto
          where pr_esKit <> 0
            and  (pr_id = @pr_id or @pr_id  =0)
            and  (
                    (exists(select rptarb_hojaid 
                            from rptArbolRamaHoja 
                            where
                                 rptarb_cliente = @clienteID
                            and  tbl_id = 30 
                            and  rptarb_hojaid = pr_id
                           ) 
                     )
                  or 
                     (@ram_id_producto = 0)
                 )

  --//////////////////////////////////////////////////////////////////////////
  --
  -- Para resolver Kits
  --
  create table #t_dc_csc_prd_0020_i (pr_id int not null, costo decimal(18,6) not null)

  -- Horrible pero efectivo
  -- a este sp lo llama dc_csc_stk_0250 para obtener el costo
  -- de los insumos que hay que comprar.
  -- La forma que tiene el sp de indicar que no deben
  -- devolverse datos es pasar @@prfk_id10 en -9999
  --
  if IsNull(@@prfk_id10,0) <> -9999 begin

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

  end else

    set @bAddPrIdKitToTable = 1

  --
  --/////////////////////////////////////////////////////////////////////////////////////////////////////

  declare c_precios insensitive cursor for select pr_id from #t_dc_csc_prd_0020
  
  open c_precios
  
  fetch next from c_precios into @pr_id
  while @@fetch_status=0
  begin
  
    set @costo = 0

    delete #KitItems
    delete #KitItemsSerie

    exec sp_StockProductoGetKitInfo @pr_id, 0, 0, 0, 1, 1, @@prfk_id01, 0, 1, 1, 1, @bAddPrIdKitToTable

    declare c_kitItem insensitive cursor for select pr_id, cantidad, pr_id_kit from #KitItemsSerie

    open c_kitItem

    fetch next from c_kitItem into @pr_id_item, @cantidad, @pr_id_kit
    while @@fetch_status=0
    begin

    --//////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
      set @costo_item = null

      if @cantidad = 0 set @cantidad = 1 /* Para formulas con items con cantidades variables */

      select @costo_item = costo from #t_dc_csc_prd_0020_i where pr_id = @pr_id_item

      if @costo_item is null begin

        --////////////////////////////////////////////////////////////////////////////////////////////////
        --
        -- Costo por ultima compra
        --
        if @@metodoVal <> 0 begin

          select top 1 @fc_id = fc.fc_id 
          from FacturaCompra fc inner join FacturaCompraItem fci on     fc.fc_id = fci.fc_id
                                                                    and fci.pr_id = @pr_id_item
  
                                inner join Documento doc          on fc.doc_id = doc.doc_id
  
          where 
                  fc_fecha <= @@Ffin
  
            and   fc.doct_id <> 8 -- sin notas de credito
            and   fc.est_id <> 7
  
            and   (fc.suc_id  = @suc_id or @suc_id=0)
            and   (doc.emp_id = @emp_id or @emp_id=0) 
            and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1007 and  rptarb_hojaid = fc.suc_id)) or (@ram_id_Sucursal = 0))
            and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
  
          order by fc_fecha desc, fc.fc_id desc
  
          select @costo_item = fci_precio 
          from FacturaCompraItem 
          where pr_id = @pr_id_item
            and fc_id = @fc_id        

          ------------------------------------
          -- Remitos de compra
          --

          if @costo = 0 begin

            select top 1 @rc_id = rc.rc_id, @cotiz = rc_cotizacion 
            from RemitoCompra rc inner join RemitoCompraItem rci on     rc.rc_id = rci.rc_id
                                                                      and rci.pr_id = @pr_id_item
  
                                  inner join Documento doc        on rc.doc_id = doc.doc_id
  
            where
                    rc_fecha <= @@Ffin 
  
              and   rc.doct_id <> 8 -- sin notas de credito
              and   rc.est_id <> 7
  
              and   (rc.suc_id  = @suc_id or @suc_id=0)
              and   (doc.emp_id = @emp_id or @emp_id=0) 
              and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1007 and  rptarb_hojaid = rc.suc_id)) or (@ram_id_Sucursal = 0))
              and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id))or (@ram_id_Empresa = 0))
  
            order by rc_fecha desc, rc.rc_id desc

            set @cotiz = IsNull(@cotiz,1)
            if @cotiz = 0 set @cotiz = 1
  
            select @costo = rci_precio * @cotiz
            from RemitoCompraItem 
            where pr_id = @pr_id_item
              and rc_id = @rc_id        

          end  
          --
          -- Remitos de compra
          ------------------------------------

        end
        --
        -- Costo por ultima compra
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////

        if isnull(@costo_item,0) = 0 begin
          exec sp_LpGetPrecio @@lp_id, @pr_id_item, @costo_item out
        end

        select @pr_stockcompra = pr_stockcompra from Producto where pr_id = @pr_id_item
        if @pr_stockcompra = 0 set @pr_stockcompra = 1

        set @costo_item = isnull(@costo_item,0) * @pr_stockcompra

        insert into #t_dc_csc_prd_0020_i (pr_id, costo) values (@pr_id_item, @costo_item)

      end

      if @@bShowInsumo <> 0 begin
        insert into  #t_dc_csc_prd_0020 (pr_id,  pr_id_insumo, pr_id_kit, cantidad, costo)
                                 values (@pr_id, @pr_id_item, @pr_id_kit, @cantidad,  @costo_item)
      end

      set @costo = @costo + (@costo_item * @cantidad)

    --
    --
    --//////////////////////////////////////////////////////////////////////////////////////////////////////

      fetch next from c_kitItem into @pr_id_item, @cantidad, @pr_id_kit
    end

    close c_kitItem
    deallocate c_kitItem

    set @costo = IsNull(@costo,0)
  
    update #t_dc_csc_prd_0020 set costo = @costo where pr_id = @pr_id and pr_id_insumo is null
    update #t_dc_csc_prd_0020 set pr_id_kit = @pr_id where pr_id = @pr_id and pr_id_kit is null

    fetch next from c_precios into @pr_id
  end
  
  close c_precios
  deallocate c_precios

  -- Horrible pero efectivo
  -- a este sp lo llama dc_csc_stk_0250 para obtener el costo
  -- de los insumos que hay que comprar.
  -- La forma que tiene el sp de indicar que no deben
  -- devolverse datos es pasar @@prfk_id10 en -9999
  --
  if IsNull(@@prfk_id10,0) <> -9999 begin

    select 
            t.pr_id,
            p.pr_nombrecompra         as [Articulo Compra],
            u.un_nombre                as [Unidad],
  
            k.pr_nombrecompra         as Kit,
    
            i.pr_nombrecompra         as [Articulo Insumo],
            ui.un_nombre              as [Unidad Insumo],
    
            cantidad                   as [Cantidad],
            costo                      as [Costo],
            case 
              when pr_id_insumo is null then 0
              else                           1
            end                       as [Insumo],
            case 
              when pr_id_insumo is not null then costo * cantidad           
              else                           0
            end                       as [Valor]
    from
    
          #t_dc_csc_prd_0020 t
    
                  inner join Producto p                 on t.pr_id         = p.pr_id
                  inner join Unidad u                   on p.un_id_venta  = u.un_id
    
                  left  join Producto i                 on t.pr_id_insumo = i.pr_id
                  left  join Producto k                 on t.pr_id_kit    = k.pr_id
                  left  join Unidad ui                  on i.un_id_stock  = ui.un_id
    
    order by p.pr_nombrecompra, k.pr_nombrecompra, i.pr_nombrecompra              

  end else begin

    update #KitItemsSerie set costo = t.costo
    from #t_dc_csc_prd_0020 t
    where #KitItemsSerie.pr_id = t.pr_id_insumo

  end

end

GO