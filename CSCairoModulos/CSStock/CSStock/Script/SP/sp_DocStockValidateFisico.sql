if exists (select * from sysobjects where id = object_id(N'[dbo].[Sp_DocStockValidateFisico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_DocStockValidateFisico]

/*

begin transaction

	declare @msg varchar(255)
  declare @bsuccess tinyint

	exec Sp_DocStockValidateFisico @msg out,@bsuccess out,136

	select @msg
	select @bsuccess

rollback transaction

*/

go
create procedure Sp_DocStockValidateFisico (
	@@Message       varchar(5200) out,
  @@bSuccess      tinyint out,
  @@stTMP_id      int
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

	declare @TipoControl int

	-- Tengo que validar segun lo que indique la configuracion de stock
	exec sp_Cfg_GetValor  'Stock-General',
											  'Tipo Control Stock',
											  @cfg_valor out,
											  0
  set @cfg_valor = IsNull(@cfg_valor,0)

	set @TipoControl = convert(int,@cfg_valor)

	-- csEStockNegativo
	if @TipoControl = 5 begin

		-- Tengo que validar segun lo que indique la configuracion de stock
		exec sp_Cfg_GetValor  'Stock-General',
												  'SP Stock 2',
												  @cfg_valor out,
												  0
	  set @cfg_valor = IsNull(@cfg_valor,'') + ' @@Message out, @@bSuccess out, ' + convert(varchar(20),@@stTMP_id)

		exec( @cfg_valor )

	end else begin

		-- csEStockFisico 
		if @TipoControl <> 4 begin
	
			-- Si el stock no es fisico
			set @@bSuccess = 1 
		
		end else begin

--/////////////////////////
--/////////////////////////
--
--  Stock Fisico
--
--/////////////////////////
--/////////////////////////

			declare @depf_id  int
			declare @prns_id	int
			declare @stl_id   int
			declare @pr_id    int

			-- Si hay un producto en un deposito con cantidad 
			-- en negativo no se puede grabar el movimiento
			--
			if exists(select pr_id 
								from StockItemTMP 
								where stTMP_id = @@stTMP_id
								group by pr_id, depl_id 
								having sum(sti_salida) > (
																			select sum(stc_cantidad) 
																			from StockCache s 
																										inner join StockItemTMP i		  on 	s.pr_id	  = i.pr_id
																										  								and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																																			and IsNull(s.pr_id_kit,0)	= IsNull(i.pr_id_kit,0)
																																			and IsNull(s.stl_id,0)		= IsNull(i.stl_id,0)

																									 	inner join DepositoLogico df on  i.depl_id  = df.depl_id
																									 	inner join DepositoLogico d  on  df.depf_id = d.depf_id
																			where  i.stTMP_id = @@stTMP_id
																				and  i.depl_id  = StockItemTMP.depl_id 
																				and  s.pr_id    = StockItemTMP.pr_id
																				and  s.depl_id  = d.depl_id
																				and  (i.depl_id not in (-2,-3)) -- Los depositos internos no importan
										 									group by d.depf_id, i.pr_id
																		)
								)
			
				begin
			
				declare c_productos insensitive cursor 
														for 
															select pr_nombrecompra, p.pr_id, depf_nombre, f.depf_id, prns_id, stl_id 

															from StockItemTMP s inner join DepositoLogico l on s.depl_id = l.depl_id
			                                            inner join DepositoFisico f on l.depf_id = f.depf_id
																									inner join Producto p       on s.pr_id   = p.pr_id
															where stTMP_id = @@stTMP_id
															group by 
																				pr_nombrecompra,
																				p.pr_id,
																				depf_nombre,
																				f.depf_id,
																				prns_id,
                                        stl_id
																				
															having sum(sti_salida) > (
																							select sum(stc_cantidad) 
																							from StockCache s 
																											inner join StockItemTMP i		  on 	s.pr_id	  = i.pr_id
																											  								and IsNull(s.prns_id,0)	  = IsNull(i.prns_id,0)
																																				and IsNull(s.pr_id_kit,0)	= IsNull(i.pr_id_kit,0)
																																				and IsNull(s.stl_id,0)		= IsNull(i.stl_id,0)

																										 	inner join DepositoLogico df on  i.depl_id  = df.depl_id
																										 	inner join DepositoLogico d  on  df.depf_id = d.depf_id
																							where  i.stTMP_id = @@stTMP_id 
																								and  s.pr_id    = p.pr_id
																								and  i.sti_salida > 0
																								and  s.depl_id = d.depl_id
																								and  (i.depl_id not in (-2,-3)) -- Los depositos internos no importan
														 									group by d.depf_id, i.pr_id
																						)
				open c_productos
			
				set @productos = ''
			
				fetch next from c_productos into @pr_nombrecompra, @pr_id, @deposito, @depf_id, @prns_id, @stl_id
				while @@fetch_status = 0 begin
			
						select @cantidad = sum(stc_cantidad), @prns_codigo = prns_codigo, @stl_codigo = stl_codigo
						from StockCache s inner join DepositoLogico d on s.depl_id = d.depl_id
															left  join ProductoNumeroSerie prns on s.prns_id = prns.prns_id
															left  join StockLote stl            on s.stl_id  = stl.stl_id
						where depf_id 	= @depf_id 
							and s.pr_id   = @pr_id
			        and IsNull(s.prns_id,0)	= IsNull(@prns_id,0)
			        and IsNull(s.stl_id,0)	= IsNull(@stl_id,0)
						group by depf_id, prns_codigo, stl_codigo

						if @prns_codigo is null set @prns_codigo = ''
						else                    set @prns_codigo = ' ' + @prns_codigo

						if @stl_codigo is null  set @stl_codigo = ''
						else                    set @stl_codigo = ' ' + @stl_codigo

						set @productos = @productos + @pr_nombrecompra 
																				+ @prns_codigo
																				+ @stl_codigo
																				+ ' (' + @deposito + ' ' 
																				+ convert(varchar(20),convert(decimal(18,2),IsNull(@cantidad,0))) 
																				+ '),'
			
					fetch next from c_productos into @pr_nombrecompra, @pr_id, @deposito, @depf_id, @prns_id, @stl_id
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
		end
	end	
end

go