/*---------------------------------------------------------------------
Nombre: Stock por Artículo Valorizado Agrupado por Rubro
(Método de valorización última Compra  o lista de precios)
(Con valorizacion por Lote de Stock - Algoritmo Despacho de Importacion*)
(* Esto es busco un remito cuyo nrodoc = stl_codigo)
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0225]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0225]

GO

/*
DC_CSC_STK_0225 
											1,
											'20061001',
											'0',
											'0',
											'0',
											'0',
											'0',16,4,1
				
select * from rama where ram_nombre like '%dvd%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_STK_0225 (

  @@us_id    int,
	@@Ffin 		 datetime,

	@@pr_id 				varchar(255),
	@@depl_id 			varchar(255),
	@@depf_id				varchar(255),
	@@suc_id				varchar(255), 
	@@emp_id  			varchar(255),
	@@lp_id         int,
	@@metodoVal     smallint,
	@@bShowInsumo   smallint,
	@@arb_id        int = 0
)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @depl_id int
declare @depf_id int
declare @suc_id int
declare @emp_id   int 

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int
declare @ram_id_Sucursal int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

create table #dc_csc_stk_0225_producto (
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

if @@arb_id = 0	select @@arb_id = min(arb_id) from arbol where tbl_id = 30 -- producto

declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n 					int 					set @n = 2
declare @raiz 			int

while exists(select * from rama r
						 where  arb_id = @@arb_id
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_2 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_3 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_4 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_5 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_6 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_7 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_8 = r.ram_id)
								and not exists (select * from #dc_csc_stk_0225_producto where nodo_9 = r.ram_id)

								and @n <= 9
						)
begin

	if @n = 2 begin

		select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2) 
		select ram_id, ram_id from rama where ram_id_padre = @raiz

	end else begin if @n = 3 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3) 
		select ram_id, nodo_2, ram_id 
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_2

	end else begin if @n = 4 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3, nodo_4) 
		select ram_id, nodo_2, nodo_3, ram_id
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_3

	end else begin if @n = 5 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
		select ram_id, nodo_2, nodo_3, nodo_4, ram_id
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_4

	end else begin if @n = 6 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_5

	end else begin if @n = 7 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_6

	end else begin if @n = 8 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_7

	end else begin if @n = 9 begin

		insert #dc_csc_stk_0225_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
		from rama r inner join #dc_csc_stk_0225_producto n on r.ram_id_padre = n.nodo_8

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

if @ram_id_Producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
	end else 
		set @ram_id_Producto = 0
end

if @ram_id_DepositoLogico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
	end else 
		set @ram_id_DepositoLogico = 0
end

if @ram_id_DepositoFisico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_DepositoFisico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_DepositoFisico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_DepositoFisico, @clienteID 
	end else 
		set @ram_id_DepositoFisico = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end


if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

create table #t_DC_CSC_STK_0225(pr_id 		      int not null, 
                                pr_esKit        tinyint not null,
                                pr_id_insumo    int null,
                                pr_stockCompra  decimal(18,6) not null, 
																stl_id          int null,
																cantidad 	      decimal(18,6) not null, 
																costo 		      decimal(18,6) not null default(0)
																)

insert into #t_DC_CSC_STK_0225 (pr_id, stl_id, pr_esKit, pr_stockCompra, cantidad)

select 
				sti.pr_id,
				sti.stl_id,
        pr.pr_esKit,
        pr_stockCompra,
				sum(sti_ingreso)
				- sum(sti_salida)         as [Cantidad]
from

			Stock 	inner join StockItem sti							on Stock.st_id 		= sti.st_id
							inner join DepositoLogico d 					on sti.depl_id 		= d.depl_id  
              inner join Documento doc              on stock.doc_id   = doc.doc_id
              inner join Producto pr                on sti.pr_id      = pr.pr_id

where 

					st_fecha <= @@Ffin 

-- Discrimino depositos internos
			and (d.depl_id <> -2 and d.depl_id <> -3)

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (sti.pr_id = @pr_id or @pr_id=0)
and   (d.depl_id = @depl_id or @depl_id=0)
and   (d.depf_id = @depf_id or @depf_id=0)
and   (stock.suc_id = @suc_id or @suc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  rptarb_hojaid = sti.pr_id
							   ) 
           )
        or 
					 (@ram_id_Producto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = sti.depl_id
							   ) 
           )
        or 
					 (@ram_id_DepositoLogico = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10 
                  and  rptarb_hojaid = d.depf_id
							   ) 
           )
        or 
					 (@ram_id_DepositoFisico = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = Stock.suc_id
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
					 (@ram_id_Empresa = 0)
			 )
group by 		
					sti.pr_id,
					sti.stl_id,
          pr_esKit,
          pr_stockCompra

having

	abs(sum(sti_ingreso) - sum(sti_salida)) > 0.01 

----------------------------------------------------------------------------------------
--
--
--		CALCULO DE PRECIOS - VALORIZACION
--
--
----------------------------------------------------------------------------------------

	--//////////////////////////////////////////////////////////////////////////
	--
	-- Para resolver Kits
	--
  create table #t_DC_CSC_STK_0225_i (pr_id int not null, costo decimal(18,6) not null)

	create table #KitItems			(
																pr_id int not null, 
																nivel int not null
															)

	create table #KitItemsSerie(
																pr_id_kit 			int null,
																cantidad 				decimal(18,6) not null,
																pr_id 					int not null, 
                                prk_id 					int not null,
																nivel       		smallint not null default(0)
															)

set @pr_id = null

declare @pr_stockcompra   		decimal(18,6)
declare @pr_stockcompraitem   decimal(18,6)

declare @pr_esKit         tinyint
declare @pr_id_item       int
declare @costo            decimal(18,6)
declare @costo_item       decimal(18,6)
declare @cantidad         decimal(18,6)
declare @fc_id            int
declare @rc_id            int
declare @cotiz						decimal(18,6)
declare @stl_id           int
declare @stl_codigo				varchar(255)

declare c_precios insensitive cursor for select pr_id, stl_id, pr_esKit, pr_stockcompra from #t_DC_CSC_STK_0225

open c_precios

fetch next from c_precios into @pr_id, @stl_id, @pr_esKit, @pr_stockcompra
while @@fetch_status=0
begin

  set @costo = 0

  if @pr_stockcompra = 0 set @pr_stockcompra = 1 

--//////////////////////////////////////////////////////////////////////////////////////////////////////
--
--
	if @@metodoVal = 1 begin

    set @costo = 0 /*para que no chille el if hasta que terminemos el PPP*/

--
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////

	end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////
--
--
		if @@metodoVal = 2 begin

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

          if @cantidad = 0 set @cantidad = 1 /* Para formulas con items con cantidades variables */

          select @costo_item = costo from #t_DC_CSC_STK_0225_i where pr_id = @pr_id_item

          if @costo_item is null begin

			      exec sp_LpGetPrecio @@lp_id, @pr_id_item, @costo_item out

            select @pr_stockcompraitem = pr_stockcompra from Producto where pr_id = @pr_id_item
            if @pr_stockcompraitem = 0 set @pr_stockcompraitem = 1

            set @costo_item = isnull(@costo_item,0) * @pr_stockcompraitem

            insert into #t_DC_CSC_STK_0225_i (pr_id, costo) values (@pr_id_item, @costo_item)

          end

          if @@bShowInsumo <> 0 begin
            insert into  #t_DC_CSC_STK_0225 (pr_id,  pr_esKit, pr_stockcompra, pr_id_insumo , cantidad, costo)
                                     values (@pr_id, 0,        1,              @pr_id_item, @cantidad,  @costo_item)
          end

          set @costo = @costo + (@costo_item * @cantidad)

        --
        --
        --//////////////////////////////////////////////////////////////////////////////////////////////////////

          fetch next from c_kitItem into @pr_id_item, @cantidad
        end

        close c_kitItem
        deallocate c_kitItem

      end else begin

				exec sp_LpGetPrecio @@lp_id, @pr_id, @costo out
      end
--
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////

		end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////
--
--
			if @@metodoVal = 3 begin

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

            if @cantidad = 0 set @cantidad = 1 /* Para formulas con items con cantidades variables */

            select @costo_item = costo from #t_DC_CSC_STK_0225_i where pr_id = @pr_id_item

            if @costo_item is null begin

				      select top 1 @fc_id = fc.fc_id 
				      from FacturaCompra fc inner join FacturaCompraItem fci on 		fc.fc_id = fci.fc_id
																																	      and fci.pr_id = @pr_id_item

															      inner join Documento doc 				 on fc.doc_id = doc.doc_id

				      where 
                      fc_fecha <= @@Ffin

								and 	fc.doct_id <> 8 -- sin notas de credito
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
              end

              select @pr_stockcompraitem = pr_stockcompra from Producto where pr_id = @pr_id_item
              if @pr_stockcompraitem = 0 set @pr_stockcompraitem = 1

              set @costo_item = isnull(@costo_item,0) * @pr_stockcompraitem

              insert into #t_DC_CSC_STK_0225_i (pr_id, costo) values (@pr_id_item, @costo_item)

            end

            if @@bShowInsumo <> 0 begin
              insert into  #t_DC_CSC_STK_0225 (pr_id,  pr_esKit, pr_stockcompra, pr_id_insumo , cantidad, costo)
                                       values (@pr_id, 0,        1,              @pr_id_item, @cantidad,  @costo_item)
            end

            set @costo = @costo + (@costo_item * @cantidad)

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
				  from FacturaCompra fc inner join FacturaCompraItem fci on 		fc.fc_id = fci.fc_id
																																	  and fci.pr_id = @pr_id

															  inner join Documento doc 				 on fc.doc_id = doc.doc_id

				  where
                  fc_fecha <= @@Ffin 

						and 	fc.doct_id <> 8 -- sin notas de credito
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
					  from RemitoCompra rc inner join RemitoCompraItem rci on 		rc.rc_id = rci.rc_id
																																		  and rci.pr_id = @pr_id
	
																  inner join Documento doc 			 on rc.doc_id = doc.doc_id
	
					  where
	                  rc_fecha <= @@Ffin 
	
							and 	rc.doct_id <> 8 -- sin notas de credito
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

    --//////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
      end else begin

--------------------------------
--				LOTES
--------------------------------

				if @stl_id is not null begin

					select @stl_codigo = stl_codigo from StockLote where stl_id = @stl_id

				  select top 1 @rc_id = rc.rc_id, @cotiz = rc_cotizacion
				  from RemitoCompra rc inner join RemitoCompraItem rci on 		rc.rc_id = rci.rc_id
																																	  and rci.pr_id = @pr_id
																																		and rc.rc_nrodoc = @stl_codigo

															  inner join Documento doc 			 on rc.doc_id = doc.doc_id

				  where
                  rc_fecha <= @@Ffin 

						and 	rc.doct_id <> 8 -- sin notas de credito
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

				end

--------------------------------
--				FACTURAS
--------------------------------

				if @costo = 0 begin

				  select top 1 @fc_id = fc.fc_id 
				  from FacturaCompra fc inner join FacturaCompraItem fci on 		fc.fc_id = fci.fc_id
																																	  and fci.pr_id = @pr_id

															  inner join Documento doc 				 on fc.doc_id = doc.doc_id

				  where
                  fc_fecha <= @@Ffin 

						and 	fc.doct_id <> 8 -- sin notas de credito
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
--				REMITOS
--------------------------------

					  select top 1 @rc_id = rc.rc_id, @cotiz = rc_cotizacion
					  from RemitoCompra rc inner join RemitoCompraItem rci on 		rc.rc_id = rci.rc_id
																																		  and rci.pr_id = @pr_id
	
																  inner join Documento doc 			 on rc.doc_id = doc.doc_id
	
					  where
	                  rc_fecha <= @@Ffin 
	
							and 	rc.doct_id <> 8 -- sin notas de credito
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
      end
		end
--
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////

	end

  set @costo = IsNull(@costo,0) * @pr_stockcompra

	update #t_DC_CSC_STK_0225 set costo = @costo where pr_id = @pr_id and pr_id_insumo is null

	fetch next from c_precios into @pr_id, @stl_id, @pr_esKit, @pr_stockcompra
end

close c_precios
deallocate c_precios

----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------

select 
				1                         as group_id,
				t.pr_id,

				@arb_nombre     as Nivel_1,
		
				isnull(nodo_2.ram_nombre,'Sin Clasificar')		
														as Nivel_2,
				nodo_3.ram_nombre		as Nivel_3,
				nodo_4.ram_nombre		as Nivel_4,
				nodo_5.ram_nombre		as Nivel_5,
				nodo_6.ram_nombre		as Nivel_6,
				nodo_7.ram_nombre		as Nivel_7,
				nodo_8.ram_nombre		as Nivel_8,
				nodo_9.ram_nombre		as Nivel_9,
		
				p.pr_nombrecompra         as [Articulo Compra],
				u.un_nombre								as [Unidad],

				i.pr_nombrecompra         as [Articulo Insumo],
				ui.un_nombre						  as [Unidad Insumo],

				stl_codigo                as [Despacho Imp.],
				cantidad         					as [Cantidad],
				costo                    	as [Costo],
        case 
          when pr_id_insumo is null then 0
          else                           1
        end                       as [Insumo],
        case 
          when pr_id_insumo is null then costo * cantidad         	
          else                           0
        end                       as [Valor]
from

			#t_DC_CSC_STK_0225 t

							inner join Producto p                 on t.pr_id 			  = p.pr_id
              inner join Unidad u                   on p.un_id_stock  = u.un_id

              left  join Producto i                 on t.pr_id_insumo = i.pr_id
              left  join Unidad ui                  on i.un_id_stock  = ui.un_id
							left  join StockLote stl              on t.stl_id       = stl.stl_id

					left join hoja h    on     t.pr_id = h.id 
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
					
					left  join #dc_csc_stk_0225_producto nodo on h.ram_id = nodo.nodo_id
					
					left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
					left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
					left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
					left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
					left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
					left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
					left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
					left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id


order by 

				Nivel_2,
				Nivel_3,
				Nivel_4,
				Nivel_5,
				Nivel_6,
				Nivel_7,
				Nivel_8,
				Nivel_9,

				p.pr_nombrecompra, i.pr_nombrecompra, t.pr_id

GO