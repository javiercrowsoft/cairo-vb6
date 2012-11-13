if exists (select * from sysobjects where id = object_id(N'[dbo].[Sp_DocStockValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_DocStockValidate]

/*

begin transaction

 Sp_DocStockValidate '',0,1

rollback transaction

*/

go
create procedure Sp_DocStockValidate (
	@@Message       varchar(5200) out,
  @@bSuccess      tinyint out,
  @@st_id         int
)
as

begin

	set nocount on

	declare @productos 					varchar(5000)
	declare @pr_nombrecompra		varchar(255)
	declare @cfg_valor          varchar(255)
	declare @deposito           varchar(255)
  declare @cantidad           decimal(18, 6)
	declare @prns_codigo        varchar(100)
	declare @stl_codigo         varchar(100)
	declare @vbcrlf2            varchar(20) set @vbcrlf2 = char(10)+char(13)+char(10)+char(13)
/*  Tipos de Stock
											  csENoControlaStock = 2
											  csEStockLogico = 3
											  csEStockFisico = 4
											  csEStockNegativo = 5
*/

	--//////////////////////////////////////////////////////////////////////////////////////////
	-- Agrego al Cache de Stock a todos los productos que no esten 
	-- aun cacheados para los depositos y numeros de serie mencionados por
	-- el StockItem
	if exists(
				select *
				from StockItem i
				where i.st_id = @@st_id 
					and not exists(select * from StockCache where pr_id = i.pr_id 
																										and depl_id = i.depl_id
																										and IsNull(prns_id,0) = IsNull(i.prns_id,0) 
																										and IsNull(pr_id_kit,0) = IsNull(i.pr_id_kit,0) 
																										and IsNull(stl_id,0)    = IsNull(i.stl_id,0)
																										and (depl_id not in (-2,-3)) -- Los depositos internos no importan
												)
			)
	begin

  	create table #tmpStock(pr_id int, depl_id int, prns_id int, pr_id_kit int, stl_id int)
  
  	insert into #tmpStock(
  												pr_id,
  												depl_id,
  												prns_id,
  												pr_id_kit,
                          stl_id
  												)
  			select distinct
  												i.pr_id,
  												depl_id,
  												prns_id,
  												i.pr_id_kit,
													i.stl_id

  			from StockItem i 
  			where i.st_id = @@st_id 
  				and not exists(select * from StockCache where pr_id = i.pr_id 
  																									and depl_id = i.depl_id
  																									and IsNull(prns_id,0)   = IsNull(i.prns_id,0) 
  																									and IsNull(pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																										and IsNull(stl_id,0)    = IsNull(i.stl_id,0)
  																									and (depl_id <>-2 and depl_id <> -3) -- Los depositos internos no importan
  											)
  
  	insert into StockCache (
  													stc_cantidad,
  													pr_id,
  													depl_id,
  													prns_id,
  													pr_id_kit,
														stl_id
  													)
  								select
  													sum(sti_ingreso)-sum(sti_salida),
  													i.pr_id,
  													i.depl_id,
                            i.prns_id,
                            i.pr_id_kit,
														i.stl_id
  
  								from StockItem i inner join #tmpStock t on  i.pr_id = t.pr_id
                                                          and i.depl_id = t.depl_id
                                                          and IsNull(i.prns_id,0)   = IsNull(t.prns_id,0)
  																									      and IsNull(i.pr_id_kit,0) = IsNull(t.pr_id_kit,0)
																													and IsNull(i.stl_id,0)    = IsNull(t.stl_id,0)
  								where (i.depl_id <> -2 and i.depl_id <> -3) -- Los depositos internos no importan
										and st_id = @@st_id
  								group by i.pr_id, i.depl_id, i.prns_id, i.pr_id_kit, i.stl_id
  
	end
	--//////////////////////////////////////////////////////////////////////////////////////////

	-- Tengo que validar segun lo que indique la configuracion de stock
	exec sp_Cfg_GetValor  'Stock-General',
											  'Tipo Control Stock',
											  @cfg_valor out,
											  0
  set @cfg_valor = IsNull(@cfg_valor,0)

	-- csENoControlaStock
	if convert(int,@cfg_valor) = 2 begin

		-- No se controla Stock asi que todo bien
		set @@bSuccess = 1 
	
	end else begin

		-- csEStockLogico
		if convert(int,@cfg_valor) = 3 begin

			-- Si hay un producto en un deposito con cantidad 
			-- en negativo no se puede grabar el movimiento
			--
			if exists(select * from StockCache s inner join StockItem i   on 	s.depl_id = i.depl_id 
																																		and i.st_id 	= @@st_id
																																	  and s.pr_id 	= i.pr_id
																																	  and IsNull(s.prns_id,0)		= IsNull(i.prns_id,0)
																																		and IsNull(s.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																																		and IsNull(s.stl_id,0)    = IsNull(i.stl_id,0)
									 where 		i.st_id = @@st_id
												and (i.depl_id <> -2 and i.depl_id <> -3) -- Los depositos internos no importan
												and stc_cantidad < 0) begin

				declare c_productos insensitive cursor 
														for select 
																				pr_nombrecompra, 
																				depl_nombre,
																				sum(stc_cantidad)
																				+ (	select sum(i.sti_salida) 
																						 	from StockItem i
																						 	where i.st_id = @@st_id
																								and s.pr_id = i.pr_id
																								and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																								and IsNull(s.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																								and IsNull(s.stl_id,0) 		= IsNull(i.stl_id,0)
																								and (i.depl_id <> -2 and i.depl_id <> -3)
																								and s.depl_id = i.depl_id
																						),
																				prns_codigo,
																				stl_codigo

														from (StockCache s 
																		inner join Producto p        
																			 on s.pr_id = p.pr_id
																					and exists(
																										select * 
																									 	from StockItem i 
																									 	where i.st_id = @@st_id
																											and s.pr_id = i.pr_id
																											and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																											and IsNull(s.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																											and IsNull(s.stl_id,0) 		= IsNull(i.stl_id,0)
																											and (i.depl_id <> -2 and i.depl_id <> -3)
																											and s.depl_id = i.depl_id
																										)
																	)
																						  inner join DepositoLogico  d on s.depl_id = d.depl_id

																							left join ProductoNumeroSerie prns on s.prns_id = prns.prns_id
																							left join StockLote stl 					 on s.stl_id  = stl.stl_id

													  where 	(s.depl_id <> -2 and s.depl_id <> -3) -- Los depositos internos no importan
																and stc_cantidad < 0
														group by pr_nombrecompra, s.depl_id, s.pr_id, 
                                     s.prns_id, s.pr_id_kit, s.stl_id,
																		 depl_nombre, prns_codigo, stl_codigo

				open c_productos

				set @productos = ''

				fetch next from c_productos into @pr_nombrecompra, @deposito, @cantidad, @prns_codigo, @stl_codigo
				while @@fetch_status = 0 begin
	
					if @prns_codigo is null set @prns_codigo=''
					else										set @prns_codigo=' (ns: '+@prns_codigo+')'

					if @stl_codigo is null  set @stl_codigo =''
					else										set @stl_codigo =' (lote: '+@stl_codigo+')'

					set @productos = @productos + @pr_nombrecompra +  @prns_codigo + @stl_codigo 
                                      + ' (' + @deposito + ' ' 
																						 + convert(varchar(20),convert(decimal(18,2),@cantidad)) 
																			+ '),'

					fetch next from c_productos into @pr_nombrecompra, @deposito, @cantidad, @prns_codigo, @stl_codigo
				end

				close c_productos
				deallocate c_productos

				set @productos = substring(@productos,1,len(@productos)-1)

				set @@bSuccess = 0
				set @@Message = 'No hay stock suficiente para el/los articulo(s):' + @vbcrlf2 + IsNull(@productos,'')
			end
			else begin
				set @@bSuccess = 1
			end

		end else begin

			-- csEStockFisico
			if convert(int,@cfg_valor) = 4 begin


				declare @depf_id_origen 	int
				declare @depf_id_destino	int
				

				select @depf_id_origen  = do.depf_id,
							 @depf_id_destino = dd.depf_id

				from Stock st inner join DepositoLogico do on st.depl_id_origen  = do.depl_id
											inner join DepositoLogico dd on st.depl_id_destino = dd.depl_id
				where st_id = @@st_id

				-- Si hay un producto en un deposito con cantidad 
				-- en negativo no se puede grabar el movimiento
				--
				if exists(select d.depf_id 
										from (StockCache s  
															inner join StockItem i		    
																		on 	s.pr_id	= i.pr_id
																		and i.st_id = @@st_id
																		and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																		and IsNull(s.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																		and IsNull(s.stl_id,0)    = IsNull(i.stl_id,0)
												 )
																			 inner join DepositoLogico df on  i.depl_id  = df.depl_id
																			 inner join DepositoLogico d  on  df.depf_id = d.depf_id
										 where i.st_id = @@st_id 
											and  s.depl_id = d.depl_id
											and  (i.depl_id <> -2 and i.depl_id <> -3) -- Los depositos internos no importan

										 group by d.depf_id, i.pr_id having sum(stc_cantidad) < 0) begin
	
					declare c_productos insensitive cursor 
															for select 	pr_nombrecompra, 
																					depf_nombre,
																					sum(stc_cantidad) 
								                          + (	select sum(i.sti_salida) 
																						 	from StockItem i 
																						 	where i.st_id = @@st_id
																								and s.pr_id = i.pr_id
																								and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																								and IsNull(s.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																								and IsNull(s.stl_id,0) 		= IsNull(i.stl_id,0)
																								and (i.depl_id <> -2 and i.depl_id <> -3)
																						),
																					prns_codigo,
																					stl_codigo

																	from (StockCache s 
																				inner join DepositoLogico d  on  s.depl_id = d.depl_id
																					and ( 		d.depf_id = @depf_id_origen
																								or	d.depf_id = @depf_id_destino
																							)
																					and exists(
																										select * 
																									 	from StockItem i 
																									 	where i.st_id = @@st_id
																											and s.pr_id = i.pr_id
																											and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																											and IsNull(s.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
																											and IsNull(s.stl_id,0) 		= IsNull(i.stl_id,0)
																											and (i.depl_id <> -2 and i.depl_id <> -3)
																										)
																				)
																										inner join Producto p        on  s.pr_id = p.pr_id
																								    inner join DepositoFisico f  on  d.depf_id = f.depf_id
									
																										left join ProductoNumeroSerie prns on s.prns_id = prns.prns_id
																										left join StockLote stl 					 on s.stl_id  = stl.stl_id
									
																	where  (s.depl_id <> -2 and s.depl_id <> -3) -- Los depositos internos no importan
																	group by pr_nombrecompra, depf_nombre, d.depf_id, 
																					 s.pr_id, s.prns_id, s.stl_id, s.pr_id_kit, 
                                           prns_codigo, stl_codigo 
																		having sum(stc_cantidad) < 0

					open c_productos

					set @productos = ''
	
					fetch next from c_productos into @pr_nombrecompra, @deposito, @cantidad, @prns_codigo, @stl_codigo
					while @@fetch_status = 0 begin

							if @prns_codigo is null set @prns_codigo=''
							else										set @prns_codigo=' (ns: '+@prns_codigo+')'

							if @stl_codigo is null  set @stl_codigo =''
							else										set @stl_codigo =' (lote: '+@stl_codigo+')'

							set @productos = @productos + @pr_nombrecompra + @prns_codigo + @stl_codigo
																					+ ' (' + @deposito + ' ' 
																								 + convert(varchar(20),convert(decimal(18,2),@cantidad)) 
																					+ '),'
	
						fetch next from c_productos into @pr_nombrecompra, @deposito, @cantidad, @prns_codigo, @stl_codigo
					end
	
					close c_productos
					deallocate c_productos
					
					set @productos = substring(@productos,1,len(@productos)-1)
	
					set @@bSuccess = 0
					set @@Message = 'No hay stock suficiente para el/los articulo(s):' + @vbcrlf2 + IsNull(@productos,'')
				end
				else begin
					set @@bSuccess = 1
				end

			end else begin

				-- csEStockNegativo
				if convert(int,@cfg_valor) = 5 begin

					-- Tengo que validar segun lo que indique la configuracion de stock
					exec sp_Cfg_GetValor  'Stock-General',
															  'SP Stock',
															  @cfg_valor out,
															  0
				  set @cfg_valor = IsNull(@cfg_valor,'') + ' @@Message out, @@bSuccess out, ' + convert(varchar(20),@@st_id)

					exec( @cfg_valor )
				end
			end
		end
	end
end

GO