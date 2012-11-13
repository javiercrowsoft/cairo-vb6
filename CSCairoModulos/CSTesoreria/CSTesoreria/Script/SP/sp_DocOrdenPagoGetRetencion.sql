if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetRetencion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetRetencion]
go

/*

sp_DocOrdenPagoGetRetencion 1,'20100101 00:00:00','20100131 00:00:00',48,1,1,5000.000000,'145-5000.000000', 1


*/

create procedure sp_DocOrdenPagoGetRetencion (
  @@us_id          int,
  @@fdesde         datetime,
  @@fhasta         datetime,
  @@prov_id        varchar(255),
  @@emp_id         varchar(255),
  @@ret_id         varchar(255),
  @@pago           decimal(18,6),
  @@facturas       varchar(5000),
	@@IsForOPG			 tinyint=0
)
as 
begin

  set nocount on

	-- Para obtener el monto de cada factura
	--
  create table #nuevoPago(	fc_numero 	int not null, 
														pago 				decimal(18,6) not null,
														esparcial 	tinyint not null default(0),

														pago_base   decimal(18,6) not null default(0),
														iva       	decimal(18,6) not null default(0),
														percepcion	decimal(18,6) not null default(0),
														base       	decimal(18,6) not null default(0)
													)

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	VALIDACIONES A LOS PARAMETROS
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////

		  -----------------------------------------------------------------------
		  -- Arboles: Solo me interesan id de maestros si me pasa ramas no 
		  --          devuelvo registros
		  --
		  declare @prov_id int
		  declare @emp_id int 
		  declare @ret_id int
		
		  declare @ram_id_Proveedor   int
		  declare @ram_id_Empresa   int 
		  declare @ram_id_Retencion int
		
		  -- Solo convierto los ids
		  --
		  exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
		  exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 
		  exec sp_ArbConvertId @@ret_id, @ret_id out, @ram_id_Retencion out
		  --
		  -----------------------------------------------------------------------

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	ALGUNAS VARIABLES
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////

			declare @noAplica						int
			declare @pro_id             int
			declare @tipoMinimo         tinyint
			declare @minimoImponible    decimal(18,6)
		  declare @baseNoImponible    decimal(18,6)
		  declare @minimoRet          decimal(18,6)
		  declare @tasa               decimal(18,6)
		
		  declare @ret                decimal(18,6)
		  declare @totalPago          decimal(18,6)
		  declare @opg_total          decimal(18,6)
		  declare @base               decimal(18,6)
			declare @percepcion         decimal(18,6)

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	DATOS DE LA RETENCION (periodo de acumulacion, categoria de ingresos brutos, Iva segun categoria)
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////

			declare @acumulaPor         tinyint
			declare @ibc_id             tinyint

			declare @catf_id 						int
			declare @tipoBase 					tinyint
		
			select 	@acumulaPor = ret_acumulapor ,
							@ibc_id			= ibc_id,
							@tipoMinimo = ret_tipominimo

			from Retencion where ret_id = @@ret_id

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	DEFINIMOS SI ESTA RETENCION ES APLICABLE A ESTE PROVEEDOR
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////

			-- Si la retencion indica explicitamente al menos una categoria fiscal
			-- comprobamos que la categoria del proveedor este asociada a la retencion
			--
			if exists(select * from RetencionCategoriaFiscal where ret_id = @@ret_id)
			begin

				select @catf_id = prov_catFiscal 
				from Proveedor 
				where prov_id = @@prov_id

				select @tipoBase = retcatf_base 
				from RetencionCategoriaFiscal 
				where ret_id  = @@ret_id
					and	catf_id = @catf_id

				-- Si tipoBase es null es por que esta retencion
				-- no incluye la categoria fiscal del proveedor
				--
				if @tipoBase is null set @noAplica = 1
				else                 set @noAplica = 0

			end else begin

			-- Si no hay categorias explicitas para esta retencion
			-- se calcula para todos los proveedores
			--
				set @noAplica = 0
				set @tipoBase = 1 -- Neto

			end

			-- Validamos la Provincia
			--
			if @noAplica = 0 begin

				-- Si la retencion indica explicitamente al menos una provincia
				-- comprobamos que la provincia del proveedor este asociada a la retencion
				--
				if exists(select * from RetencionProvincia where ret_id = @@ret_id)
				begin
	
					select @pro_id = pro_id
					from Proveedor 
					where prov_id = @@prov_id
	
					if not exists(select * 
												from RetencionProvincia 
												where ret_id = @@ret_id
													and	pro_id = @pro_id
												)
									set @noAplica = 1
					else    set @noAplica = 0

					-- Si la retencion tiene una provincia diferente, pero esta
					-- indicada explicitamente la traemos igual
					--
					if @noAplica <> 0 begin

						if exists(select * from ProveedorRetencion where prov_id = @@prov_id and ret_id = @@ret_id)
						set @noAplica = 0

					end
	
				end else begin
	
				-- Si no hay provincias explicitas para esta retencion
				-- se calcula para todos los proveedores
				--
					set @noAplica = 0
	
				end

			end

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	CALCULO DE LA RETENCION
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	
	if @noAplica = 0 begin
	
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--	PAGOS EN EL PERIODO (si correponde)
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
	
				if @acumulaPor = 2 -- Mensual
				begin

						-- NOTA: como la unica percepcion que incluye montos en el periodo es la de ganancias
            --       y por lo que hasta ahora sabemos, se aplica sobre el neto y para todas las
            --       categorias, no vamos a complicarnos discriminando si el producto es una cosa mueble
            --       o es un servicio, ya que no afecta a esta retencion
						--
						--       :( si cambian las reglas (y seguro lo haran) nos encargaremos
						--
			
					  -- Obtengo cuanto le pague en este periodo sin el iva
					  --
					  declare @aplicado decimal(18,6)
					
					  select @aplicado = sum(fcopg_importe 
					                          - (fc_ivari  * (fcopg_importe / fc_total)) 
					                          - (fc_ivarni * (fcopg_importe / fc_total)) 
					                        )
					  from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc on fcopg.fc_id   = fc.fc_id
					                                    inner join OrdenPago  opg   on fcopg.opg_id  = opg.opg_id
					                                    inner join Documento d      on fc.doc_id     = d.doc_id
					  where opg_fecha between @@fdesde and @@fhasta 
					    and opg.prov_id = @prov_id 
					    and d.emp_id    = @emp_id

							-- Esto no me gusta, pero no lo vamos a tocar por ahora.
							--
							-- Supuestamente es para notas de debito por cheque rechazado
							-- pero no estoy muy conforme con esta solucion,
							-- ya que si la factura contiene varios items y uno solo es
							-- exento de retenciones, no la tomo en cuenta en su totalidad
							-- y eso no esta bien.
							--
							-- Ademas, ibc es ingresos brutos categoria, y lo estamos usando
							-- para las retenciones de ganancias, asi que no esta para nada
							-- prolijo, ya veremos si lo cambiamos
							--					
							and not exists(select * 
					                   from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
														 where pr.ibc_id = 1 -- Exento
					                     and fci.fc_id = fc.fc_id
														)
					  
					  set @aplicado = IsNull(@aplicado,0)
					
						-- Obtengo cuanto hay de percepciones en estas facturas
						-- 
						select @percepcion = sum(fcperc_importe * (fcopg_importe / fc_total))
					
					  from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc 						on fcopg.fc_id   = fc.fc_id
					                                    inner join OrdenPago  opg   						on fcopg.opg_id  = opg.opg_id
					                                    inner join Documento d      						on fc.doc_id     = d.doc_id
																							inner join FacturaCompraPercepcion fcp	on fc.fc_id      = fcp.fc_id
					  where opg_fecha between @@fdesde and @@fhasta 
					    and opg.prov_id = @prov_id 
					    and d.emp_id = @emp_id

							-- Esto no me gusta, pero no lo vamos a tocar por ahora.
							--
							-- Supuestamente es para notas de debito por cheque rechazado
							-- pero no estoy muy conforme con esta solucion,
							-- ya que si la factura contiene varios items y uno solo es
							-- exento de retenciones, no la tomo en cuenta en su totalidad
							-- y eso no esta bien.
							--
							-- Ademas, ibc es ingresos brutos categoria, y lo estamos usando
							-- para las retenciones de ganancias, asi que no esta para nada
							-- prolijo, ya veremos si lo cambiamos
							--
							and not exists(select * 
					                   from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
														 where pr.ibc_id = 1 -- Exento
					                     and fci.fc_id = fc.fc_id
														)
			
			
						set @percepcion = IsNull(@percepcion,0)
					
					  -- Los anticipos no tienen iva
						--
					  declare @anticipo decimal(18,6)
					
					  select @anticipo = sum(opg_pendiente) 
					  from OrdenPago c inner join Documento d on c.doc_id = d.doc_id
					  where opg_fecha between @@fdesde and @@fhasta 
					    and prov_id  = @prov_id 
					    and d.emp_id = @emp_id
							and c.est_id <> 7
					
					  set @anticipo = IsNull(@anticipo,0)
					
					  set @opg_total = @aplicado + @anticipo - @percepcion
					  set @opg_total = IsNull(@opg_total,0)
			
				end
			
				set @percepcion = IsNull(@percepcion,0)
				set @opg_total  = IsNull(@opg_total,0)
	
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--	OBTENGO EL PAGO DE ESTA OP SIN IMPUESTOS (ni iva ni percepciones)
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
	
			  -----------------------------------------------------------------------
			  -- Ok ahora obtengo el iva de lo que estoy por pagar
			  --
			  
			  -- Paso a una temporal las facturas indicadas
			  --
			  declare @codigo 			datetime
			  declare @pagoParcial 	decimal(18,6)
			  declare @txt         	varchar(5000)
			  declare @fc_numero   	int
				declare @fc_id 				int
				declare @pago_ibc     decimal(18,6)
				declare @desc1        decimal(18,6)
				declare @desc2        decimal(18,6)
				declare @ya_pagado    decimal(18,6)

				-- Pasamos las facturas de string a temporal
				--
			  set @codigo = getdate()
			  exec sp_strStringToTable @codigo, @@facturas, '*'
			
			  declare c_nuevoPago insensitive cursor for 
			    select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @codigo
			
			  open c_nuevoPago

			  fetch next from c_nuevoPago into @txt
			  while @@fetch_status=0 begin
			
			    if isnumeric(@txt)<>0 begin
			
						select @fc_id = fc_id from facturacompra where fc_numero = convert(int,@txt)

						-- Esto no me gusta, pero no lo vamos a tocar por ahora.
						--
						-- Supuestamente es para notas de debito por cheque rechazado
						-- pero no estoy muy conforme con esta solucion,
						-- ya que si la factura contiene varios items y uno solo es
						-- exento de retenciones, no la tomo en cuenta en su totalidad
						-- y eso no esta bien.
						--
						-- Ademas, ibc es ingresos brutos categoria, y lo estamos usando
						-- para las retenciones de ganancias, asi que no esta para nada
						-- prolijo, ya veremos si lo cambiamos
						--
						if not exists(select * 
				                   from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
													 where pr.ibc_id = 1 -- Exento
				                     and fci.fc_id = @fc_id
													) begin

							-- Si la retencion no tiene definido un ibc_id aplicamos todo el pago
							if @ibc_id is null

			      		insert into #nuevoPago (fc_numero, pago) values(@txt,0)

							else begin

								-- Para descontar anticipos sobre esta factura
								--
								set @ya_pagado = 0

								-- Tenemos que obtener el monto de la suma de los productos cuyo
								-- ibc_id = al de la retencion
								--
								select @pago_ibc = sum(fci_importe) 
								from FacturaCompraItem fci inner join Producto pr on fci.pr_id = pr.pr_id
								where fc_id = @fc_id
									and pr.ibc_id = @ibc_id

								set @pago_ibc = IsNull(@pago_ibc,0)

								select 	@desc1 = fc_descuento1,
												@desc2 = fc_descuento2

								from facturacompra
								where fc_id = @fc_id

								set @pago_ibc = 	@pago_ibc 
																- (@pago_ibc*@desc1/100)
																- ((@pago_ibc*@desc1/100)*@desc2/100)

								select @ya_pagado = isnull(sum(fcopg_importe),0)
								from FacturaCompraOrdenPago where fc_id = @fc_id

								select @ya_pagado = isnull(@ya_pagado,0) + isnull(sum(fcnc_importe),0)
								from FacturaCompraNotaCredito where fc_id_factura = @fc_id

								-- Le tengo que sacar a ya_pagado el % de las retenciones ya pagadas
								--
								select @ya_pagado = @ya_pagado - @ya_pagado * (fc_totalpercepciones / fc_total)
								from FacturaCompra where fc_id = @fc_id

								set @pago_ibc = @pago_ibc - isnull(@ya_pagado,0)

								if @pago_ibc > 0 
									insert into #nuevoPago (fc_numero, pago) values(@txt,@pago_ibc)

							end

						end
			
			    end else begin

			      if charindex('-',@txt)<>0 begin

			        set @fc_numero   = convert(int,substring(@txt,1,charindex('-',@txt)-1))
			        set @pagoParcial = convert(decimal(18,6),substring(@txt,charindex('-',@txt)+1,len(@txt)))
			
							select @fc_id = fc_id from facturacompra where fc_numero = @fc_numero
			
							-- Esto no me gusta, pero no lo vamos a tocar por ahora.
							--
							-- Supuestamente es para notas de debito por cheque rechazado
							-- pero no estoy muy conforme con esta solucion,
							-- ya que si la factura contiene varios items y uno solo es
							-- exento de retenciones, no la tomo en cuenta en su totalidad
							-- y eso no esta bien.
							--
							-- Ademas, ibc es ingresos brutos categoria, y lo estamos usando
							-- para las retenciones de ganancias, asi que no esta para nada
							-- prolijo, ya veremos si lo cambiamos
							--
							if not exists(select * 
					                   from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
														 where pr.ibc_id = 1 -- Exento
					                     and fci.fc_id = @fc_id
														) begin

								-- Si ibc_id es null no hay problema
								--
								if @ibc_id is null

				        	insert into #nuevoPago (fc_numero, pago, esparcial) values(@fc_numero,@pagoParcial,1)

								else begin

									-- Si la factura tiene items con ibc_id = @ibc_id y
									-- tengo que asegurarme que no tenga otros items
									-- con ibc_id <> @ibc_id
									if exists(select * 
														from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
														where fci.fc_id = @fc_id
															and pr.ibc_id = @ibc_id
														)
									begin

										-- Como dije antes, verifico que no exista mezcla de 
										-- categorias de ingresos brutos en la factura
										--
										if exists(select * 
															from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
															where fci.fc_id = @fc_id
																and pr.ibc_id <> @ibc_id
															) 
										begin

												declare @error_msg varchar(5000)

												-- Se pudrio todo, yo no se como resolver esto asi que se lo dejo al usuario
												--
												set @error_msg =  
																		'@@ERROR_SP:Esta orden de pago esta cancelando ' 
																	 +'una factura que incluye productos con diferentes '
																	 +'categorias de ingresos brutos (Gravado Cosas Muebles, '
																	 +'Gravado Servicios, etc.), con un pago parcial, y esta '
																	 +'combinanción no esta soportada por el algoritmo de '
																	 +'cálculo de retenciones.'+char(13)+char(13)
																	 /*+'(sepa disculpar la ignorancia de nuestros programadores :)'*/
																	 +'Ud. debera realizar el calculo manualmente.'

												raiserror (@error_msg, 16, 1) -- :) sefini
												return

										end else

											-- Tomo el pago parcial ya que aqui no ha pasado nada :)
											--
											insert into #nuevoPago (fc_numero, pago, esparcial) values(@fc_numero,@pagoParcial,1)

									end
									-- Por si no lo notaron, si la factura no tiene
									-- items con ibc_id = @ibc_id, no me interesa el pago
									-- que se le halla aplicado
								end

							end
			
			      end 
			    end
			
			    fetch next from c_nuevoPago into @txt
			  end
			  close c_nuevoPago
			  deallocate c_nuevoPago

				-- Obtengo lo pagado sobre cada factura
				--
				update #nuevoPago set pago_base =  case 
								                              when pago <> 0 then
								                                    pago
								                              else
								                                    fc_pendiente
							                             end
			  from FacturaCompra fc inner join Documento d  on fc.doc_id    = d.doc_id
			  where prov_id  = @prov_id 
			    and d.emp_id = @emp_id
					and #nuevoPago.fc_numero = fc.fc_numero

				-- El pago segun la Categoria de Ingresos Brutos
				--
			  declare @nuevoPago decimal(18,6)

			  select @nuevoPago = sum( case 
			                              when pago <> 0 then
			                                    pago
			                              else
			                                    fc_pendiente
		                             end
		                            )
			  from FacturaCompra fc inner join Documento d  on fc.doc_id    = d.doc_id
			                        inner join #nuevoPago t on fc.fc_numero = t.fc_numero
			  where prov_id  = @prov_id 
			    and d.emp_id = @emp_id

				-- Obtengo el IVA de lo pagado sobre cada factura
				--
				update #nuevoPago set iva = case
  																		when esparcial <> 0 then
				                                    (fc_ivari  * (pago / fc_total))
				                                  + (fc_ivarni * (pago / fc_total)) 
				                              when pago <> 0 then
				                                    (fc_ivari  * (pago / (fc_total-fc_totalpercepciones)))
				                                  + (fc_ivarni * (pago / (fc_total-fc_totalpercepciones))) 
				                              else
				                                    (fc_ivari  * (fc_pendiente / fc_total)) 
				                                  + (fc_ivarni * (fc_pendiente / fc_total)) 
				                             end
			  from FacturaCompra fc inner join Documento d  on fc.doc_id    = d.doc_id
			  where prov_id  = @prov_id 
			    and d.emp_id = @emp_id
					and #nuevoPago.fc_numero = fc.fc_numero

				-- El iva del pago segun la Categoria de Ingresos Brutos
				--
			  declare @nuevoPagoIva decimal(18,6)

				if @tipoBase <> 3 begin -- Total begin
			
				  select @nuevoPagoIva = sum(case 
				                              when esparcial <> 0 then
				                                    (fc_ivari  * (pago / fc_total))
				                                  + (fc_ivarni * (pago / fc_total)) 
				                              when pago <> 0 then
				                                    (fc_ivari  * (pago / (fc_total-fc_totalpercepciones)))
				                                  + (fc_ivarni * (pago / (fc_total-fc_totalpercepciones))) 
				                              else
				                                    (fc_ivari  * (fc_pendiente / fc_total)) 
				                                  + (fc_ivarni * (fc_pendiente / fc_total)) 
				                             end
				                            )
				  from FacturaCompra fc inner join Documento d  on fc.doc_id    = d.doc_id
				                        inner join #nuevoPago t on fc.fc_numero = t.fc_numero
				  where prov_id  = @prov_id 
				    and d.emp_id = @emp_id

				end 

				-- Si la percepcion es sobre el total
				-- no le descuento el IVA
				--
				else set @nuevoPagoIva = 0

				-- Obtengo las percepciones de lo pagado sobre cada factura
				--
				update #nuevoPago set percepcion = case 
								                              when esparcial <> 0 then
								                                   (fcperc_importe  * (pago / fc_total)) 
								                              when pago <> 0 then
								                                   0
								                              else
								                                   (fcperc_importe  * (fc_pendiente / fc_total)) 
							                             end
			  from FacturaCompra fc inner join Documento d  on fc.doc_id    = d.doc_id
															inner join FacturaCompraPercepcion fcp	on fc.fc_id     = fcp.fc_id
			  where prov_id  = @prov_id 
			    and d.emp_id = @emp_id
					and #nuevoPago.fc_numero = fc.fc_numero

				-- Ahora la percepcion de lo que estoy pagando
				--
				set @percepcion = 0

				select @percepcion = sum(case 
			                              when esparcial <> 0 then
			                                   (fcperc_importe  * (pago / fc_total)) 
			                              when pago <> 0 then
			                                   0
			                              else
			                                   (fcperc_importe  * (fc_pendiente / fc_total)) 
			                             end
			                            )
			
			  from FacturaCompra fc inner join Documento d 									on fc.doc_id 		= d.doc_id
			                        inner join #nuevoPago t 					      on fc.fc_numero = t.fc_numero
															inner join FacturaCompraPercepcion fcp	on fc.fc_id     = fcp.fc_id
			  where prov_id  = @prov_id 
			    and d.emp_id = @emp_id
			
				set @percepcion = IsNull(@percepcion,0)

				if @tipoBase <> 3 begin

					update #nuevoPago set base = pago_base - iva - percepcion

				end else begin

					update #nuevoPago set base = pago_base - percepcion

				end

			  -----------------------------------------------------------------------
			  -- Ahora obtengo el pago sin el iva NI las percepciones 
				-- de lo que estoy por pagar
			  --
			  set @nuevoPago = IsNull(@nuevoPago,0) - IsNull(@nuevoPagoIva,0) - @percepcion
	
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--	OTROS DATOS DE LA RETENCION (base NO imponible, minimo a retener, etc.)
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
	
			  -----------------------------------------------------------------------
			  -- Vamos por la base NO imponible 
			  --
				-- Si no tiene minimos
				--

-- Borrar
-- 				if not exists(select * from RetencionItem where ret_id = @ret_id and reti_importefijo <> 0) begin
-- 
-- 				  select @minimoImponible = min(reti_importedesde) from RetencionItem where ret_id = @ret_id
-- 					set @minimoImponible = IsNull(@minimoImponible,0)
-- 
-- 				end else

--					set @minimoImponible = 0
-- Borrar

				  select @minimoImponible = min(reti_importedesde) from RetencionItem where ret_id = @ret_id
					set @minimoImponible = IsNull(@minimoImponible,0)
	
			  -----------------------------------------------------------------------
			  -- Vamos por el minimo a retener
			  --
			  select @minimoRet = ret_importeminimo from Retencion where ret_id = @ret_id
	
				declare @minimoDesde decimal(18,6)
				select @minimoDesde = min(reti_importeDesde)
				from RetencionItem 
			  where ret_id = @ret_id

				set @minimoDesde = isnull(@minimoDesde,0)

			  -----------------------------------------------------------------------
			  -- Finalmente solo nos falta la tasa que esta en relacion con el monto a pagar
			  --
				declare @minimoTasa decimal(18,6)
				declare @montoFijo  decimal(18,6)

				if not exists(select * from RetencionItem where ret_id = @ret_id and reti_importefijo <> 0) begin

				  select @tasa 				= reti_porcentaje /100,
								 @minimoTasa  = reti_importeDesde,
								 @montoFijo   = reti_importefijo
	
				  from RetencionItem 
				  where ret_id = @ret_id
				    and (@opg_total + @nuevoPago) between reti_importeDesde and reti_importeHasta

				end else begin

				  select @tasa 				= reti_porcentaje /100,
								 @minimoTasa  = reti_importeDesde,
								 @montoFijo   = reti_importefijo
	
				  from RetencionItem 
				  where ret_id = @ret_id
				    and (@opg_total + @nuevoPago - @minimoDesde) between reti_importeDesde and reti_importeHasta
				end

--select @opg_total + @nuevoPago, @opg_total,@nuevoPago
	
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--	OTROS DATOS DE LA RETENCION (base NO imponible, minimo a retener, etc.)
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
	
			  -----------------------------------------------------------------------
			  -- Ahora vemos si tiene que pagar y cuanto
			  --
				if @tipoMinimo = 1 /*NoImponible*/ set @baseNoImponible = @minimoImponible
				else							 /*Imponible  */ set @baseNoImponible = 0
			  
			  -- Si lo que se pago hasta ahora es mayor a la base (ej. > 12000)
			  --
			  if @opg_total > @baseNoImponible begin
			    
			    -- Si lo que se pago hasta ahora por la tasa no supera el minimo a retener (ej < 20)
			    --
			    if (@opg_total - @baseNoImponible) * @tasa < @minimoRet
			
			          -- La base imponible es el nuevo pago mas lo pagado anteriormente
			          -- y que no sufrio retencion
			          --
			          set @base = @opg_total + @nuevoPago - @baseNoImponible
			
			          -- La base es unicamente el nuevo pago
			          --
			    else  set @base = @nuevoPago
			  
			  end else begin
			
			    -- Si lo que pague hasta ahora es menor a la base no imponible
			    -- entonces la base imponible es lo que pague hasta ahora mas 
			    -- el nuevo pago
			    --
			    if @opg_total + @nuevoPago - @baseNoImponible > 0 
			          set @base = @opg_total + @nuevoPago - @baseNoImponible
			
			  end
			  
			  set @base = IsNull(@base,0)
			
				if @montoFijo <> 0 begin


--select @montoFijo as montoFijo, @minimoTasa as minimoTasa
--select @base as base, @tasa as tasa, @minimoTasa as minimoTasa, @opg_total, @nuevoPago , @baseNoImponible
--select (@opg_total + @nuevoPago - @minimoTasa - @minimoDesde) as base

					set @ret = ((@opg_total + @nuevoPago - @minimoTasa - @minimoDesde) * @tasa) + @montoFijo

					declare @yaRetenido decimal(18,6)
					select @yaRetenido = sum(opgi_importe) 
					from OrdenPago opg inner join OrdenPagoItem opgi on opg.opg_id = opgi.opg_id
					where opg.prov_id = @@prov_id
						and opg_fecha between @@fdesde and @@fhasta 
						and ret_id = @@ret_id

					set @yaRetenido = isnull(@yaRetenido,0)

--select @yaRetenido as yaRetenido

					set @ret = @ret - @yaRetenido

				end else begin

				  set @ret = @base * @tasa

				end
	
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--	VALIDAMOS QUE LA RETENCION PASE EL MINIMO
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////////////////
	
			  set @ret = IsNull(@ret,0)
			  if @ret < 0 set @ret = 0
			
			  if     @ret < @minimoRet 
			    and ((@opg_total - @baseNoImponible) * @tasa < @minimoRet)
			    set @ret = 0
	
	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	FIN CALCULO
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	end

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	SELECT DE RETORNO
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////


		-- Si me llamo Cairo desde el asistente de OP para que calcule el monto
		--
		--
		if @@IsForOPG <> 0 begin
	
			set @ret = IsNull(@ret,0)

			if @ret > 0 begin

				-- //////////////////////////////////////////////////////////////////////////////////
				--
				-- Talonario
				--
							declare @ta_id        int
							declare @ta_nrodoc 		varchar(100)
		
							select @ta_id = ta_id from Retencion where ret_id = @@ret_id
		
							exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
							if @@error <> 0 goto ControlError
		
				--
				-- Fin Talonario
				--
				-- //////////////////////////////////////////////////////////////////////////////////
			end
	

			declare @descrip 		varchar(5000)
			declare @fc_base 		decimal(18,6)

			set @descrip = ''

			declare c_facturas insensitive cursor for select fc_numero, base from #nuevoPago

			open c_facturas

			fetch next from c_facturas into @fc_numero, @fc_base
			while @@fetch_status=0
			begin

				set @descrip = @descrip + 'FV:'
																+ convert(varchar,@fc_numero) + ' - ' 
																+ convert(varchar,@fc_base) + ','
				
				fetch next from c_facturas into @fc_numero, @fc_base
			end
			close c_facturas
			deallocate c_facturas

		  select @ret        as retencion, 
						 @tasa*100   as porcentaje,
						 @ta_nrodoc  as comprobante,
						 @base       as base--,
						 --@descrip		 as	base_facturas


		-- Si me llamo un reporte para imprimir el comprobante de retencion
		--	
		end else begin
	
			exec sp_DocOrdenPagoGetRetencionRpt   @@fdesde				 ,
																					  @@fhasta         ,
																					  @@prov_id        ,
																					  @@emp_id         ,
																					  @nuevoPago       ,
																						@opg_total			 ,
																						@nuevoPago			 ,
																						@base					 	 ,
																						@tasa					 	 ,
																						@ret 					 
		end	

	--/////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	SE TERMINO :)
	--
	--
	--/////////////////////////////////////////////////////////////////////////////////////////////////////

	return

ControlError:

	raiserror ('Ha ocurrido un error al calcular las retenciones', 16, 1)
end
go