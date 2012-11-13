/*---------------------------------------------------------------------
Nombre: Ventas Agrupadas por Cliente, Carpeta, Rubro, Articulo, Empresa en Moneda Default, Costo y Origen
---------------------------------------------------------------------*/
/*  

Tabla de valores para @@metodoVal
Precio Promedio Ponderado		|1|
Lista de Precios						|2|
Ultima Compra								|3|
Por Despacho de Importación	|4|

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0800]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0800]

go
create procedure DC_CSC_VEN_0800 (

  @@us_id    		int,
	@@Ffin 		 		datetime,

	@@periodo1    smallint,
	@@periodo2    smallint,
	@@periodo3    smallint,

  @@cli_id   				varchar(255),
  @@pr_id           varchar(255),
  @@cico_id	 				varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@suc_id				  varchar(255), 
  @@emp_id	 				varchar(255),
  @@mon_id_informe	int,
  @@lp_id           int,
  @@metodoVal       smallint,
  @@bShowInsumo     smallint,
	@@arb_id          int = 0,
	@@showpromedios   smallint
)as 
begin

set nocount on	

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
-- Obtenemos toda la jerarquia del arbol de producto seleccionado
--
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

	if @@arb_id = 0	select @@arb_id = min(arb_id) from arbol where tbl_id = 30 -- producto

	declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id

	create table #DC_CSC_VEN_0800_producto (
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
	exec DC_CSC_VEN_0800_002 @@arb_id

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
-- Arboles
--
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

	declare @clienteID int

	exec sp_GetRptId @clienteID out	

	exec DC_CSC_VEN_0800_003
						
							@clienteID,
						
						  @@cli_id   				,
						  @@pr_id           ,
						  @@cico_id	 				,
						  @@doc_id	 				,
						  @@mon_id	 				,
						  @@suc_id				  , 
						  @@emp_id	 				


	declare @pr_id_param  		int
	declare @ram_id_producto  int

	exec sp_ArbConvertId @@pr_id, @pr_id_param out,	@ram_id_producto out
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
-- Datos de cada periodo
--
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

	create table #t_DC_CSC_VEN_0800 (

																		cli_id 				int not null,
																		pr_id  				int not null,
																		
																		promedio01		decimal(18,6) not null default(0),
																		promedio02		decimal(18,6) not null default(0),
																		promedio03		decimal(18,6) not null default(0),

																		prom_orig01		decimal(18,6) not null default(0),
																		prom_orig02		decimal(18,6) not null default(0),
																		prom_orig03		decimal(18,6) not null default(0),
																		
																		costo01				decimal(18,6) not null default(0),
																		costo02				decimal(18,6) not null default(0),
																		costo03				decimal(18,6) not null default(0),
																		
																		costo_orig01	decimal(18,6) not null default(0),
																		costo_orig02	decimal(18,6) not null default(0),
																		costo_orig03	decimal(18,6) not null default(0),

																		costo_inf01		decimal(18,6) not null default(0),
																		costo_inf02		decimal(18,6) not null default(0),
																		costo_inf03		decimal(18,6) not null default(0),

																		prom_cant01		decimal(18,6) not null default(0),
																		prom_cant02		decimal(18,6) not null default(0),
																		prom_cant03		decimal(18,6) not null default(0),

																		mon_id          int not null,
																		mon_id_costo    int null,

																		mes1 smallint not null default(0),
																		mes2 smallint not null default(0),
																		mes3 smallint not null default(0)
																		)

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--
-- Obtengo los periodos
--
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

	declare @Fini datetime
	declare @Ffin datetime

	set @Fini = dateadd(m, -@@periodo1, @@Ffin)

	-- 1
	--
	exec DC_CSC_VEN_0800_001 

														@clienteID,
														1, --@@periodo
													
													  @@us_id,
														@Fini,
														@@Ffin,
													
													  @@cli_id,
													  @@pr_id,
													  @@cico_id,
													  @@doc_id,
													  @@mon_id,
													  @@suc_id,
													  @@emp_id,
													  @@mon_id_informe,
													  @@lp_id,
													  @@metodoVal,
													  @@bShowInsumo
					
	set @Ffin = dateadd(d,-1,@Fini)
	set @Fini = dateadd(m, -@@periodo2, @@Ffin)

	-- 2
	--
	exec DC_CSC_VEN_0800_001 

														@clienteID,
														2, --@@periodo
													
													  @@us_id,
														@Fini,
														@Ffin,
													
													  @@cli_id,
													  @@pr_id,
													  @@cico_id,
													  @@doc_id,
													  @@mon_id,
													  @@suc_id,
													  @@emp_id,
													  @@mon_id_informe,
													  @@lp_id,
													  @@metodoVal,
													  @@bShowInsumo

	set @Ffin = dateadd(d,-1,@Fini)
	set @Fini = dateadd(m, -@@periodo3, @@Ffin)

	-- 3
	--
	exec DC_CSC_VEN_0800_001 

														@clienteID,
														3, --@@periodo
													
													  @@us_id,
														@Fini,
														@Ffin,
													
													  @@cli_id,
													  @@pr_id,
													  @@cico_id,
													  @@doc_id,
													  @@mon_id,
													  @@suc_id,
													  @@emp_id,
													  @@mon_id_informe,
													  @@lp_id,
													  @@metodoVal,
													  @@bShowInsumo


	declare @mes1 	smallint
	declare @mes2 	smallint
	declare @mes3 	smallint
	declare @fecha 	datetime
	declare @fecha2 datetime
	declare @cli_id int
		
	declare c_clientes insensitive cursor for select distinct cli_id from #t_DC_CSC_VEN_0800

	open c_clientes
	
	fetch next from c_clientes into @cli_id
	while @@fetch_status = 0
	begin

		set @mes1 = 1
		set @mes2 = 1
		set @mes3 = 1

		select @fecha = min (fv_fecha) from FacturaVenta where cli_id = @cli_id

		if @fecha <= @Fini begin

			set @mes1 = @@periodo1
			set @mes2 = @@periodo2
			set @mes3 = @@periodo3

		end else begin

			set @fecha2 = dateadd(m, -@@periodo1, @@Ffin)
			if @fecha >= @fecha2
				set @mes1 = datediff(m,@@Ffin, @fecha)
			else
				set @mes1 = @@periodo1

			set @fecha2 = dateadd(m, -@@periodo2, @@Ffin)
			if @fecha >= @fecha2
				set @mes2 = datediff(m,@@Ffin, @fecha)-@mes1
			else
				set @mes2 = @@periodo2

			set @fecha2 = dateadd(m, -@@periodo3, @@Ffin)
			if @fecha >= @fecha2
				set @mes3 = datediff(m,@@Ffin, @fecha)-@mes1-@mes2
			else
				set @mes3 = @@periodo3

		end

		if @mes1<=0 set @mes1=1
		if @mes2<=0 set @mes2=1
		if @mes3<=0 set @mes3=1

		update #t_DC_CSC_VEN_0800 set mes1=@mes1, mes2=@mes2, mes3=@mes3 where cli_id = @cli_id

		fetch next from c_clientes into @cli_id
	end
	close c_clientes
	deallocate c_clientes
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

    select
    		1 											as orden_id,
    		cli_nombre							as Cliente,
      	IsNull(rub_nombre,'(Articulo sin rubro)') 
																as Rubro,
				pr_nombreventa					as Articulo,
      	IsNull(ven_nombre,'(Cliente sin vendedor)') 
																as Vendedor,

				--------------------------------------------
				-- Arbol
				--
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
				--
				--------------------------------------------

-- 				mon.mon_nombre		    			as Moneda,
-- 				monc.mon_nombre             as [Moneda Costo],
-- 				moninf.mon_nombre						as [Moneda Informe],

				case when @@showpromedios <> 0 then  sum(promedio01/mes1) else	sum(promedio01)		end as [Promedio 01],
				case when @@showpromedios <> 0 then  sum(promedio02/mes2)	else	sum(promedio02)		end as [Promedio 02],
				case when @@showpromedios <> 0 then  sum(promedio03/mes3)	else	sum(promedio03)		end as [Promedio 03],

-- 				case when @@showpromedios <> 0 then  sum(prom_orig01/mes1)	else	sum(promedio01)	end as [Prom. Origen 01],
-- 				case when @@showpromedios <> 0 then  sum(prom_orig02/mes2)	else	sum(promedio02)	end as [Prom. Origen 02],
-- 				case when @@showpromedios <> 0 then  sum(prom_orig03/mes3)	else	sum(promedio03)	end as [Prom. Origen 03],
				
				case when @@showpromedios <> 0 then  sum(costo01/mes1)	else	sum(promedio01)			end as [Costo 01],
				case when @@showpromedios <> 0 then  sum(costo02/mes2)	else	sum(promedio02)			end as [Costo 02],
				case when @@showpromedios <> 0 then  sum(costo03/mes3)	else	sum(promedio03)			end as [Costo 03],
				
-- 				case when @@showpromedios <> 0 then  sum(costo_orig01/mes1)	else	sum(promedio01) end as [Costo Origen 01],
-- 				case when @@showpromedios <> 0 then  sum(costo_orig02/mes2)	else	sum(promedio02) end as [Costo Origen 02],
-- 				case when @@showpromedios <> 0 then  sum(costo_orig03/mes3)	else	sum(promedio03) end as [Costo Origen 03],

-- 				case when @@showpromedios <> 0 then  sum(costo_inf01/mes1)	else	sum(promedio01) end as [Costo Inf 01],
-- 				case when @@showpromedios <> 0 then  sum(costo_inf02/mes2)	else	sum(promedio02) end as [Costo Inf 02],
-- 				case when @@showpromedios <> 0 then  sum(costo_inf03/mes3)	else	sum(promedio03) end as [Costo Inf 03],

				case when @@showpromedios <> 0 then  sum(prom_cant01/mes1)	else	sum(promedio01) end as [Cantidad 01],
				case when @@showpromedios <> 0 then  sum(prom_cant02/mes2)	else	sum(promedio02) end as [Cantidad 02],
				case when @@showpromedios <> 0 then  sum(prom_cant03/mes3)	else	sum(promedio03) end as [Cantidad 03]

    from 

			#t_DC_CSC_VEN_0800 fvi

											inner join producto 		pr				on fvi.pr_id   			= pr.pr_id
											inner join cliente   		cli       on fvi.cli_id   		= cli.cli_id 
--                      inner join moneda    		mon       on fvi.mon_id   		= mon.mon_id
-- 											inner join moneda    		moninf    on @@mon_id_informe = moninf.mon_id
-- 											left  join moneda    		monc      on fvi.mon_id_costo = monc.mon_id
											left  join rubro 				rub				on pr.rub_id				= rub.rub_id
											left  join vendedor     ven       on cli.ven_id       = ven.ven_id

--////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Arbol de producto
--
--////////////////////////////////////////////////////////////////////////////////////////////////////

					left join hoja h    on   fvi.pr_id = h.id 
					                     and h.arb_id  = @@arb_id

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
					
					left  join #DC_CSC_VEN_0800_producto nodo on h.ram_id = nodo.nodo_id
					
					left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
					left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
					left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
					left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
					left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
					left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
					left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
					left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id

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

    		cli_nombre,
      	IsNull(rub_nombre,'(Articulo sin rubro)'),
				pr_nombreventa,
      	IsNull(ven_nombre,'(Cliente sin vendedor)'),

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
				nodo_9.ram_nombre
				--
				--------------------------------------------

-- 				,mon.mon_nombre
-- 				,monc.mon_nombre
-- 				,moninf.mon_nombre

		order by 	
							Vendedor,
							Cliente, 
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

