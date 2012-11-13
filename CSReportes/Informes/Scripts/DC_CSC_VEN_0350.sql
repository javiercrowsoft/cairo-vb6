/*---------------------------------------------------------------------
Nombre: Costo de Mercaderías Vendidas 
(Método de valorización última Compra  o lista de precios)
---------------------------------------------------------------------*/
/*  

Para testear:
select * from producto where pr_id in (107,36)
select * from producto where pr_esKit <> 0
se
exec sp_StockProductoGetKitInfo 106, 1, 0, 1, 1, 1, null, 0, 1
DC_CSC_VEN_0350 1, '20060101','20061231','0', '106','0','0','0','0','0',29,2,1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0350]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0350]

go
create procedure DC_CSC_VEN_0350 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

  @@cli_id   				varchar(255),
  @@pr_id           varchar(255),
  @@cico_id	 				varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@suc_id				  varchar(255), 
  @@emp_id	 				varchar(255),
  @@lp_id           int,
  @@metodoVal       smallint,
  @@bShowInsumo     smallint

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

declare @cli_id   		int
declare @ven_id   		int
declare @pr_id        int
declare @cico_id  		int
declare @doc_id   		int
declare @mon_id   		int
declare @suc_id       int
declare @emp_id   		int

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

exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
exec sp_ArbConvertId @@pr_id,  		 	 @pr_id out,  			@ram_id_producto out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
exec sp_ArbConvertId @@mon_id,  		 @mon_id out,  			@ram_id_moneda out
exec sp_ArbConvertId @@suc_id,       @suc_id out,       @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id,  		 @emp_id out,  			@ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

if @ram_id_circuitoContable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
	end else 
		set @ram_id_circuitoContable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

TABLA TEMPORAL CON TODOS LOS MOVIMIENTOS

/////////////////////////////////////////////////////////////////////// */

create table #t_dc_csc_ven_0350(pr_id 		      int not null, 
                                pr_esKit        tinyint not null,
                                pr_id_insumo    int null,
                                pr_ventacompra  decimal(18,6) not null, 
																cantidad 	      decimal(18,6) not null, 
																costo 		      decimal(18,6) not null default(0),
																venta           decimal(18,6) not null default(0)
																)

insert into #t_dc_csc_ven_0350 (pr_id, pr_esKit, pr_ventacompra, cantidad, venta)
		
		    select
		        pr.pr_id,
            pr.pr_esKit,
            pr_ventacompra,
		    		sum (
		    			  	case 

		    						when 		fv.doct_id = 7

													     then  -fvi_cantidad

		    						when 		fv.doct_id <> 7

													     then  	fvi_cantidad

		    						else             	0
		    					end
		    				)										as Cantidad,

						sum (
									case fv.doct_id
						        when 7  then - (fvi_neto
																				- (fvi_neto * fv_descuento1 / 100)
																				- (
																						(
																							fvi_neto - (fvi_neto * fv_descuento1 / 100)
																						) * fv_descuento2 / 100
																					)
																		)	
						        else         fvi_neto
																				- (fvi_neto * fv_descuento1 / 100)
																				- (
																						(
																							fvi_neto - (fvi_neto * fv_descuento1 / 100)
																						) * fv_descuento2 / 100
																					)
																		
									end
								)										as Venta
		    
		    from 
		    
		      facturaventa fv inner join facturaventaitem fvi  on fv.fv_id    = fvi.fv_id
													inner join cliente   cli         on fv.cli_id   = cli.cli_id 
		                      inner join documento doc         on fv.doc_id   = doc.doc_id
		                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
													inner join producto pr           on fvi.pr_id   = pr.pr_id
		    
		    where 
		    
		    				  fv_fecha >= @@Fini
		    			and	fv_fecha <= @@Ffin 
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
				and   (fvi.pr_id   = @pr_id    or @pr_id  =0)
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
		    
		    group by
		    
		        pr.pr_id,
            pr_esKit,
            pr_ventaCompra

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
  create table #t_dc_csc_ven_0350_i (pr_id int not null, costo decimal(18,6) not null)

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

declare @pr_ventacompra   decimal(18,6)
declare @pr_stockcompra   decimal(18,6)
declare @pr_esKit         tinyint
declare @pr_id_item       int
declare @costo            decimal(18,6)
declare @costo_item       decimal(18,6)
declare @cantidad         decimal(18,6)
declare @fc_id            int
declare @rc_id            int
declare @cotiz						decimal(18,6)

declare c_precios insensitive cursor for select pr_id, pr_esKit, pr_ventacompra from #t_dc_csc_ven_0350

open c_precios

fetch next from c_precios into @pr_id, @pr_esKit, @pr_ventacompra
while @@fetch_status=0
begin

  set @costo = 0

  if @pr_ventacompra = 0 set @pr_ventacompra = 1 

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

          select @costo_item = costo from #t_dc_csc_ven_0350_i where pr_id = @pr_id_item

          if @costo_item is null begin

			      exec sp_LpGetPrecio @@lp_id, @pr_id_item, @costo_item out

            select @pr_stockcompra = pr_stockcompra from Producto where pr_id = @pr_id_item
            if @pr_stockcompra = 0 set @pr_stockcompra = 1

            set @costo_item = isnull(@costo_item,0) * @pr_stockcompra

            insert into #t_dc_csc_ven_0350_i (pr_id, costo) values (@pr_id_item, @costo_item)

          end

          if @@bShowInsumo <> 0 begin
            insert into  #t_dc_csc_ven_0350 (pr_id,  pr_esKit, pr_ventacompra, pr_id_insumo , cantidad, costo)
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

            select @costo_item = costo from #t_dc_csc_ven_0350_i where pr_id = @pr_id_item

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

              select @pr_stockcompra = pr_stockcompra from Producto where pr_id = @pr_id_item
              if @pr_stockcompra = 0 set @pr_stockcompra = 1

              set @costo_item = isnull(@costo_item,0) * @pr_stockcompra

              insert into #t_dc_csc_ven_0350_i (pr_id, costo) values (@pr_id_item, @costo_item)

            end

            if @@bShowInsumo <> 0 begin
              insert into  #t_dc_csc_ven_0350 (pr_id,  pr_esKit, pr_ventacompra, pr_id_insumo , cantidad, costo)
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
			end
--
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////

		end
	end

  set @costo = IsNull(@costo,0) / @pr_ventacompra

	update #t_dc_csc_ven_0350 set costo = @costo where pr_id = @pr_id and pr_id_insumo is null

	fetch next from c_precios into @pr_id, @pr_esKit, @pr_ventacompra
end

close c_precios
deallocate c_precios

----------------------------------------------------------------------------------------

select 
				1                         as group_id,
				t.pr_id,
				p.pr_nombrecompra         as [Articulo Compra],
				u.un_nombre								as [Unidad],

				i.pr_nombrecompra         as [Articulo Insumo],
				ui.un_nombre						  as [Unidad Insumo],

				cantidad         					as [Cantidad],
				venta                     as [Ventas],
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

			#t_dc_csc_ven_0350 t

							inner join Producto p                 on t.pr_id 			  = p.pr_id
              inner join Unidad u                   on p.un_id_venta  = u.un_id

              left  join Producto i                 on t.pr_id_insumo = i.pr_id
              left  join Unidad ui                  on i.un_id_stock  = ui.un_id

order by t.pr_id, p.pr_nombrecompra, i.pr_nombrecompra              

end
go

