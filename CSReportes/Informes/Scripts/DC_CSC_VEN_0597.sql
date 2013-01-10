/*---------------------------------------------------------------------
Nombre: Ventas Agrupadas por Carpeta, Rubro, Articulo en Moneda Default, Costo y Origen
        Costo por ultima compra

---------------------------------------------------------------------*/
/*  

exec [DC_CSC_VEN_0597] 13,'20090301 00:00:00','20090331 00:00:00','0','0','1','0','0','0','0',2,2,4,0,218

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0597]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0597]

go
create procedure DC_CSC_VEN_0597 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@cli_id           varchar(255),
  @@pr_id           varchar(255),
  @@cico_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@suc_id          varchar(255), 
  @@emp_id           varchar(255),
  @@mon_id_informe  int,
  @@lp_id           int,
  @@bShowInsumo     smallint,
  @@arb_id          int = 0
)as 
begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id       int
declare @ven_id       int
declare @pr_id_param  int
declare @cico_id      int
declare @doc_id       int
declare @mon_id       int
declare @suc_id       int
declare @emp_id       int

declare @ram_id_cliente          int
declare @ram_id_vendedor         int
declare @ram_id_producto         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_Sucursal         int
declare @ram_id_empresa          int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@pr_id,          @pr_id_param out,   @ram_id_producto out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out

exec sp_GetRptId @clienteID out

create table #DC_CSC_VEN_0597_producto (
                                        nodo_id int,
                                        nodo_2 int,
                                        nodo_3 int,
                                        nodo_4 int,
                                        nodo_5 int,
                                        nodo_6 int,
                                        nodo_7 int,
                                        nodo_8 int,
                                        nodo_9 int
                                      )


if @@arb_id = 0  select @@arb_id = min(arb_id) from arbol where tbl_id = 30 -- producto

declare @arb_nombre varchar(255)   select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n           int           set @n = 2
declare @raiz       int

while exists(select * from rama r
             where  arb_id = @@arb_id
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_2 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_3 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_4 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_5 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_6 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_7 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_8 = r.ram_id)
                and not exists (select * from #DC_CSC_VEN_0597_producto where nodo_9 = r.ram_id)

                and @n <= 9
            )
begin

  if @n = 2 begin

    select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2) 
    select ram_id, ram_id from rama where ram_id_padre = @raiz

  end else begin if @n = 3 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3) 
    select ram_id, nodo_2, ram_id 
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_2

  end else begin if @n = 4 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3, nodo_4) 
    select ram_id, nodo_2, nodo_3, ram_id
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_3

  end else begin if @n = 5 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
    select ram_id, nodo_2, nodo_3, nodo_4, ram_id
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_4

  end else begin if @n = 6 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_5

  end else begin if @n = 7 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_6

  end else begin if @n = 8 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_7

  end else begin if @n = 9 begin

    insert #DC_CSC_VEN_0597_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
    from rama r inner join #DC_CSC_VEN_0597_producto n on r.ram_id_padre = n.nodo_8

  end
  end
  end
  end
  end
  end
  end
  end

  set @n = @n + 1

end

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_circuitoContable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
  end else 
    set @ram_id_circuitoContable = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_moneda <> 0 begin

--  exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
  end else 
    set @ram_id_moneda = 0
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

--/////////////////////////////////////////////////////////////////////////
--
-- Moneda de la lista de precios
declare @mon_id_lista int
declare @cotiz_lista  decimal(18,6)

select @mon_id_lista = mon_id from ListaPrecio where lp_id = @@lp_id

/*- ///////////////////////////////////////////////////////////////////////

TABLA TEMPORAL CON TODOS LOS MOVIMIENTOS

/////////////////////////////////////////////////////////////////////// */

------------------------------------------------------------------
-- Obtenemos de una sola vez todas las facturas del periodo
--

create table #t_DC_CSC_VEN_0597_fv(fv_id int)

  insert into #t_DC_CSC_VEN_0597_fv

        select distinct

            fv.fv_id
        
        from 
        
          facturaventa fv inner join facturaventaitem fvi  on fv.fv_id    = fvi.fv_id
                          inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                          inner join documento doc         on fv.doc_id   = doc.doc_id
                          inner join empresa   emp         on doc.emp_id  = emp.emp_id
                          inner join producto  pr          on fvi.pr_id   = pr.pr_id        
        where 
        
                  fv_fecha >= @@Fini
              and  fv_fecha <= @@Ffin 
              and fv.est_id <> 7

              --and fv.doct_id <> 7 -- sin notas de credito
        
              and (
                    exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                  )
        
        /* -///////////////////////////////////////////////////////////////////////
        
        INICIO SEGUNDA PARTE DE ARBOLES
        
        /////////////////////////////////////////////////////////////////////// */
        
        and   (fv.cli_id   = @cli_id   or @cli_id =0)
        and   (doc.cico_id = @cico_id  or @cico_id=0)
        and   (fv.doc_id   = @doc_id   or @doc_id =0)
        and   (fvi.pr_id   = @pr_id_param    
                                       or @pr_id_param  =0)
        and   (fv.mon_id   = @mon_id   or @mon_id =0)
        and   (fv.suc_id   = @suc_id   or @suc_id =0)
        and   (doc.emp_id  = @emp_id   or @emp_id =0)
        
        -- Arboles
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 28 
                          and  rptarb_hojaid = fv.cli_id
                         ) 
                   )
                or 
                   (@ram_id_cliente = 0)
               )
        
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 30 
                          and  rptarb_hojaid = fvi.pr_id
                         ) 
                   )
                or 
                   (@ram_id_producto = 0)
               )

        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 1016 
                          and  rptarb_hojaid = doc.cico_id
                         ) 
                   )
                or 
                   (@ram_id_circuitoContable = 0)
               )
        
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 4001 
                          and  rptarb_hojaid = fv.doc_id
                         ) 
                   )
                or 
                   (@ram_id_documento = 0)
               )
        
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 12 
                          and  rptarb_hojaid = fv.mon_id
                         ) 
                   )
                or 
                   (@ram_id_moneda = 0)
               )
        
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 1007 
                          and  rptarb_hojaid = fv.suc_id
                         ) 
                   )
                or 
                   (@ram_id_Sucursal = 0)
               )
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 1018 
                          and  rptarb_hojaid = doc.emp_id
                         ) 
                   )
                or 
                   (@ram_id_empresa = 0)
               )

------------------------------------------------------------------

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Cargamos la tabla #t_DC_CSC_VEN_0597 con todas las ventas
--
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

create table #t_DC_CSC_VEN_0597(fv_id           int not null,
                                pr_id           int not null, 
                                pr_esKit        tinyint not null,
                                pr_id_insumo    int null,
                                pr_ventacompra  decimal(18,6) not null, 
                                mon_id          int not null,
                                mon_id_costo    int null,
                                cantidad         decimal(18,6) not null, 

                                costo           decimal(18,6) not null default(0),
                                venta           decimal(18,6) not null default(0),

                                costo_origen    decimal(18,6) not null default(0),
                                venta_origen    decimal(18,6) not null default(0),

                                costo_mon_informe    decimal(18,6) not null default(0),
                                venta_mon_informe    decimal(18,6) not null default(0),

                                -- Auxiliares para calcular el neto de ventas
                                --
                                fv_descuento1 decimal(18,6) not null default(0),
                                fv_descuento2 decimal(18,6) not null default(0)
                               )

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Obtenemos precios de todas las facturas
--
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          --// Comprobantes que mueven stock
          --//
              insert into #t_DC_CSC_VEN_0597 (fv_id, pr_id, mon_id, fv_descuento1, fv_descuento2, 
                                              pr_esKit, pr_ventacompra, cantidad, venta)
                  
                      select
                          fv.fv_id,
                          fvi.pr_id,
                          fv.mon_id,
              
                          fv_descuento1,
                          fv_descuento2,
              
                          pr.pr_esKit,
                          pr_ventacompra,
                          sum (
                                case 
              
                                  when     fv.doct_id = 7
              
                                             then  -fvi_cantidad
              
                                  when     fv.doct_id <> 7
              
                                             then    fvi_cantidad
              
                                  else               0
                                end
                              )                    as Cantidad,
              
                          sum (

                                case fv.doct_id 
                                    when 7 then -fvi_neto
                                    else         fvi_neto
                                end
                              )
                      
                      from 
                      
                        #t_DC_CSC_VEN_0597_fv tfv
              
                                        inner join facturaventa fv        on tfv.fv_id   = fv.fv_id
                                        inner join facturaventaitem fvi  on fv.fv_id    = fvi.fv_id
                                        inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                                        inner join documento doc         on fv.doc_id   = doc.doc_id
                                        inner join empresa   emp         on doc.emp_id  = emp.emp_id
                                        inner join producto  pr          on fvi.pr_id   = pr.pr_id  
                      
                      group by
                      
                          fv.fv_id,
                          fv.doct_id,
                          fv.mon_id,
                          fvi.pr_id,
              
                          fv_descuento1,
                          fv_descuento2,
              
                          pr_esKit,
                          pr_ventaCompra

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Calculamos las ventas por cada factura
--
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Actualizamos las ventas
  --
   
  update #t_DC_CSC_VEN_0597 set venta = (venta
                                          - (venta * fv_descuento1 / 100)
                                          - (
                                              (
                                                venta - (venta * fv_descuento1 / 100)
                                              ) * fv_descuento2 / 100
                                            )
                                          )

  --//----------------------------------------
  --// Cotizacion
  --//
      update #t_DC_CSC_VEN_0597

        set venta_origen =   case 
                              when fv_cotizacion <> 0 then venta / fv_cotizacion
                              else                         venta
                            end
      from FacturaVenta fv

      where #t_DC_CSC_VEN_0597.fv_id = fv.fv_id

----------------------------------------------------------------------------------------
--
--
--    CALCULO DE PRECIOS - VALORIZACION
--
--
----------------------------------------------------------------------------------------

  --//////////////////////////////////////////////////////////////////////////
  --
  -- Para resolver Kits
  --
  create table #t_DC_CSC_VEN_0597_i (pr_id         int not null, 
                                     mon_id       int not null,
                                     costo         decimal(18,6) not null,
                                     costo_origen decimal(18,6) not null
                                    )

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

declare @pr_id int
declare @pr_esKit tinyint
declare @pr_ventacompra decimal(18,6)
declare @cantidad decimal(18,6)



set @pr_id           = null
set @pr_esKit       = null
set @pr_ventacompra = null
set @cantidad       = null

declare @pr_stockcompra   decimal(18,6)
declare @pr_id_item       int
declare @costo            decimal(18,6)
declare @costo_item       decimal(18,6)

declare @costo_origen            decimal(18,6)
declare @costo_origen_item       decimal(18,6)

declare @fc_id            int
declare @rc_id            int
declare @cotiz            decimal(18,6)

declare @cotiz_periodo    decimal(18,6)

-----------------------------------------------
-- Obtenemos la cotizacion promedio del periodo
--

declare @mon_id_legal int
select @mon_id_legal = mon_id from Moneda where mon_legal <> 0

if @@mon_id_informe = 0 set @@mon_id_informe = @mon_id_legal
if exists(select * from MonedaItem 
          where mon_id = @@mon_id_informe 
            and moni_fecha between @@Fini and @@Ffin)
begin

  select @cotiz_periodo = sum(moni_precio)/count(*) 
  from MonedaItem 
  where mon_id = @@mon_id_informe 
    and moni_fecha between @@Fini and @@Ffin

end else begin

  select @cotiz_periodo = moni_precio
  from MonedaItem 
  where mon_id = @@mon_id_informe 
    and moni_fecha = ( select max(moni_fecha) 
                       from MonedaItem 
                       where mon_id = @@mon_id_informe 
                       and moni_fecha < @@Fini
                      )
end

if isnull(@cotiz_periodo,0) = 0 set @cotiz_periodo = 1

--
-----------------------------------------------

declare c_precios insensitive cursor for select pr_id, pr_esKit, pr_ventacompra from #t_DC_CSC_VEN_0597

open c_precios

fetch next from c_precios into @pr_id, @pr_esKit, @pr_ventacompra
while @@fetch_status=0
begin

  set @costo = 0
  set @costo_origen = 0

  if @pr_ventacompra = 0 set @pr_ventacompra = 1 

--//////////////////////////////////////////////////////////////////////////////////////////////////////
--
--

  declare @mon_id_costo int

    --//////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
        if @pr_esKit <> 0 begin

          delete #KitItems
          delete #KitItemsSerie

          exec sp_StockProductoGetKitInfo @pr_id, 0, 0, 1, 1, 1, null, 0, 1

          declare c_kitItem insensitive cursor for select pr_id, cantidad from #KitItemsSerie

          open c_kitItem

          fetch next from c_kitItem into @pr_id_item, @cantidad
          while @@fetch_status=0
          begin

          --//////////////////////////////////////////////////////////////////////////////////////////////////////
          --
          --
            set @costo_item = null
            set @costo_origen_item = null

            if @cantidad = 0 set @cantidad = 1 /* Para formulas con items con cantidades variables */

            select @costo_item = costo, @costo_origen_item = costo_origen, @mon_id_costo = mon_id
            from #t_DC_CSC_VEN_0597_i where pr_id = @pr_id_item

            if @costo_item is null begin

              select top 1 @fc_id = fc.fc_id, @mon_id_costo = doc.mon_id
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

              if isnull(@costo_item,0) = 0 begin

                exec sp_LpGetPrecio @@lp_id, @pr_id_item, @costo_item out
                set @mon_id_costo = @@mon_id_informe

              end

              set @costo_origen_item = @costo_item / @cotiz_periodo

              select @pr_stockcompra = pr_stockcompra from Producto where pr_id = @pr_id_item
              if isnull(@pr_stockcompra,0) = 0 set @pr_stockcompra = 1

              set @costo_item = isnull(@costo_item,0) * @pr_stockcompra
              set @costo_origen_item = isnull(@costo_origen_item,0) * @pr_stockcompra

              insert into #t_DC_CSC_VEN_0597_i (pr_id, mon_id, costo, costo_origen) 
                                        values (@pr_id_item, @mon_id_costo, @costo_item, @costo_origen_item)

            end

            if @@bShowInsumo <> 0 begin
              insert into  #t_DC_CSC_VEN_0597 (pr_id,  mon_id_costo, pr_esKit, pr_ventacompra, pr_id_insumo , cantidad, costo, costo_origen)
                                       values (@pr_id, @mon_id_costo, 0, 1, @pr_id_item, @cantidad,  @costo_item, @costo_origen_item)
            end

            set @costo = @costo + (@costo_item * @cantidad)
            set @costo_origen = @costo_origen + (@costo_origen_item * @cantidad)

          --
          --
          --//////////////////////////////////////////////////////////////////////////////////////////////////////

            fetch next from c_kitItem into @pr_id_item, @cantidad
          end

          close c_kitItem
          deallocate c_kitItem

    --//////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
        end else begin

          select top 1 @fc_id = fc.fc_id 
          from FacturaCompra fc inner join FacturaCompraItem fci on     fc.fc_id = fci.fc_id
                                                                    and fci.pr_id = @pr_id

                                inner join Documento doc          on fc.doc_id = doc.doc_id

          where
                  fc_fecha <= @@Ffin 

            and   fc.doct_id <> 8 -- sin notas de credito
            and   fc.est_id <> 7

            and   (fc.suc_id  = @suc_id or @suc_id=0)
            and   (doc.emp_id = @emp_id or @emp_id=0) 
            and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1007 and  rptarb_hojaid = fc.suc_id)) or (@ram_id_Sucursal = 0))
            and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id))   or (@ram_id_Empresa = 0))

          order by fc_fecha desc, fc.fc_id desc

          select @costo = fci_precio 
          from FacturaCompraItem 
          where pr_id = @pr_id
            and fc_id = @fc_id        

          if @costo = 0 begin

--------------------------------
            select top 1 @rc_id = rc.rc_id, @cotiz = rc_cotizacion
            from RemitoCompra rc inner join RemitoCompraItem rci on     rc.rc_id = rci.rc_id
                                                                      and rci.pr_id = @pr_id
  
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
            where pr_id = @pr_id
              and rc_id = @rc_id        
  
--------------------------------

            if @costo = 0 begin
              exec sp_LpGetPrecio @@lp_id, @pr_id, @costo out
            end
          end
        end

--
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////

  if @pr_ventacompra <> 0 begin 
        set @costo = IsNull(@costo,0) / abs(@pr_ventacompra) 
        set @costo_origen = IsNull(@costo_origen,0) / abs(@pr_ventacompra)
  end else begin
        set @costo = IsNull(@costo,0) 
        set @costo_origen = IsNull(@costo_origen,0) 
  end

  update #t_DC_CSC_VEN_0597 

    set costo        = @costo, 
        costo_origen = @costo_origen,
        mon_id_costo = @mon_id_costo
 
  where pr_id = @pr_id 
    and pr_id_insumo is null

  fetch next from c_precios into @pr_id, @pr_esKit, @pr_ventacompra
end

close c_precios
deallocate c_precios

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
-- Traspaso a la moneda pedida en el informe
--
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

if @@mon_id_informe <> @mon_id_legal begin

  declare @cotiz_fv       decimal(18,6)
  declare @fv_last_fecha   datetime
  declare @fv_fecha       datetime

  -- Obtenemos todas las operaciones expresadas en monedas
  -- distintas a la moneda del informe
  --
  declare c_fv_moneda insensitive cursor for 

        select distinct fv_fecha

        from #t_DC_CSC_VEN_0597 fvi inner join FacturaVenta fv on fvi.fv_id = fv.fv_id

        where fvi.mon_id        <> @@mon_id_informe 
          or  fvi.mon_id_costo <> @@mon_id_informe
        order by fv_fecha

  open c_fv_moneda

  fetch next from c_fv_moneda into @fv_fecha
  while @@fetch_status=0
  begin

    -- Buscamos la cotizacion de la moneda
    -- del informe para la fecha de este movimiento
    --
    if @fv_last_fecha <> @fv_fecha or @fv_last_fecha is null begin

      select @cotiz_fv = moni_precio
      from MonedaItem 
      where mon_id = @@mon_id_informe 
        and moni_fecha = ( select max(moni_fecha) 
                           from MonedaItem 
                           where mon_id = @@mon_id_informe 
                           and moni_fecha <= @fv_fecha
                          )
  
      if @cotiz_fv is null begin

        declare @error_msg  varchar(5000)
        declare @mon_nombre varchar(255)

        select @mon_nombre = mon_nombre from Moneda where mon_id = @@mon_id_informe

        set @mon_nombre = isnull(@mon_nombre,'Sin moneda')

        set @error_msg =   '@@ERROR_SP:No hay registrada en el sistema, una cotizacion para la fecha ' + convert(varchar,@fv_fecha,105)
                         + '.'+char(13)+char(13)
                         + 'Debe utilizar la opcion "Configuración > Tesoreria > Monedas" para registrar la cotizacion del [' + @mon_nombre + '] a esta fecha.'

        raiserror ( @error_msg, 
                    16, 
                    1)
        return

      end

      update #t_DC_CSC_VEN_0597 

        set 
            venta_mon_informe = venta / @cotiz_fv

      from FacturaVenta fv

      where #t_DC_CSC_VEN_0597.fv_id  = fv.fv_id 
        and #t_DC_CSC_VEN_0597.mon_id <> @@mon_id_informe 
        and fv.fv_fecha               = @fv_fecha

      update #t_DC_CSC_VEN_0597 

        set 
            costo_mon_informe = costo / @cotiz_fv

      from FacturaVenta fv

      where #t_DC_CSC_VEN_0597.fv_id        = fv.fv_id 
        and #t_DC_CSC_VEN_0597.mon_id_costo <> @@mon_id_informe 
        and fv.fv_fecha                     = @fv_fecha

      set @fv_last_fecha = @fv_fecha

    end

    fetch next from c_fv_moneda into @fv_fecha
  end

  close c_fv_moneda
  deallocate c_fv_moneda

  -- Ventas en la moneda del informe
  --
  update #t_DC_CSC_VEN_0597 

    set 
        venta_mon_informe = venta_origen

  where mon_id = @@mon_id_informe 

  -- Costos en la moneda del informe
  --
  update #t_DC_CSC_VEN_0597 

    set 
        costo_mon_informe = costo_origen

  where mon_id_costo = @@mon_id_informe 

end else begin

  update #t_DC_CSC_VEN_0597 

    set 
        venta_mon_informe = venta,
        costo_mon_informe = costo

end

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
-- Select de Retorno
--
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

    select
        1                       as orden_id,
        IsNull(rub_nombre,'Articulo sin rubro') 
                                as Rubro,
        pr_nombreventa          as Articulo,

        --------------------------------------------
        -- Arbol
        --
        @arb_nombre     as Nivel_1,
    
        isnull(nodo_2.ram_nombre,'Sin Clasificar')    
                            as Nivel_2,
        nodo_3.ram_nombre    as Nivel_3,
        nodo_4.ram_nombre    as Nivel_4,
        nodo_5.ram_nombre    as Nivel_5,
        nodo_6.ram_nombre    as Nivel_6,
        nodo_7.ram_nombre    as Nivel_7,
        nodo_8.ram_nombre    as Nivel_8,
        nodo_9.ram_nombre    as Nivel_9,
        --
        --------------------------------------------

        sum(cantidad)                as Cantidad,

        sum (venta)                 as Neto,

        case when sum(cantidad) <> 0 then sum(cantidad * costo)/sum(cantidad)         
             else                          0
        end                          as [Costo Unit.],
        sum(cantidad * costo)       as Costo,

        sum(venta_origen)           as [Neto Origen],

        case when sum(cantidad) <> 0 then sum(cantidad * costo_origen)/sum(cantidad)
             else                          0
        end                            as [Costo Unit. origen],
        sum(cantidad * costo_origen)  as [Costo Origen],
    
        moninf.mon_nombre                  as [Moneda Informe],

        sum(venta_mon_informe)             as [Neto Mon. Informe],

        case when sum(cantidad) <> 0 then sum(cantidad * costo_mon_informe)/sum(cantidad)
             else                          0
        end                                as [Costo Unit. Mon. Informe],
        sum(cantidad * costo_mon_informe) as [Costo Mon. Informe],


        case 

          when sum(venta_mon_informe) = 0 
          then   0

          when sum(cantidad * costo_mon_informe) = 0
          then  0

          when sum(cantidad * costo_mon_informe) > 
               sum(venta_mon_informe)
          then  0

          else
                1- (
                    sum(cantidad * costo_mon_informe) / 
                    sum(venta_mon_informe)
                    )

      end as [Utilidad]


    from 

      #t_DC_CSC_VEN_0597 fvi

                      inner join FacturaVenta fv        on fvi.fv_id         = fv.fv_id
                      inner join producto     pr        on fvi.pr_id         = pr.pr_id
                      inner join moneda        moninf    on @@mon_id_informe = moninf.mon_id
                      inner join empresa       emp       on fv.emp_id         = emp.emp_id
                      left  join rubro         rub        on pr.rub_id        = rub.rub_id

          left join hoja h    on     fvi.pr_id = h.id 
                               and h.arb_id = @@arb_id

                               -- Esto descarta la raiz
                               --
                               and not exists(select * from rama 
                                              where ram_id = ram_id_padre 
                                                and arb_id = @@arb_id 
                                                and ram_id = h.ram_id)

                               -- Esto descarta hojas secundarias
                               --
                               and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
                                              where h2.arb_id = @@arb_id
                                                and h2.ram_id < h.ram_id
                                                and h2.ram_id <> r.ram_id_padre 
                                                and h2.id = h.id)
          
          left  join #DC_CSC_VEN_0597_producto nodo on h.ram_id = nodo.nodo_id
          
          left  join rama nodo_2    on nodo.nodo_2 = nodo_2.ram_id
          left  join rama nodo_3    on nodo.nodo_3 = nodo_3.ram_id
          left  join rama nodo_4    on nodo.nodo_4 = nodo_4.ram_id
          left  join rama nodo_5    on nodo.nodo_5 = nodo_5.ram_id
          left  join rama nodo_6    on nodo.nodo_6 = nodo_6.ram_id
          left  join rama nodo_7    on nodo.nodo_7 = nodo_7.ram_id
          left  join rama nodo_8    on nodo.nodo_8 = nodo_8.ram_id
          left  join rama nodo_9    on nodo.nodo_9 = nodo_9.ram_id

    where         

        (fvi.pr_id = @pr_id_param or @pr_id_param =0)

        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 30 
                          and  rptarb_hojaid = fvi.pr_id
                         ) 
                   )
                or 
                   (@ram_id_producto = 0)
               )

    group by

        IsNull(rub_nombre,'Articulo sin rubro'),
        pr_nombreventa,

        --------------------------------------------
        -- Arbol
        --
        isnull(nodo_2.ram_nombre,'Sin Clasificar'),    
        nodo_3.ram_nombre,
        nodo_4.ram_nombre,
        nodo_5.ram_nombre,
        nodo_6.ram_nombre,
        nodo_7.ram_nombre,
        nodo_8.ram_nombre,
        nodo_9.ram_nombre,
        --
        --------------------------------------------

        moninf.mon_nombre

    order by   
              Nivel_2,
              Nivel_3,
              Nivel_4,
              Nivel_5,
              Nivel_6,
              Nivel_7,
              Nivel_8,
              Nivel_9,
              Rubro, 
              Articulo

end
go

