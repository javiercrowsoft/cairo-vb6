
/*---------------------------------------------------------------------
Nombre: Cheques emitidos presentados en agenda mensual
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0180 1, '2009-01-01', '2009-04-01','0','0','0','0',0

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0180]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0180]

go
create procedure DC_CSC_TSR_0180 (

  @@us_id    	int,
	@@Fini 		 	datetime,
	@@Ffin 		 	datetime,

@@cue_id  		varchar(1000),
@@bco_id  		varchar(1000),
@@prov_id			varchar(1000), 
@@emp_id  		varchar(1000),

@@bSoloPendientes smallint

)as 

begin

	set nocount on

	/*- ///////////////////////////////////////////////////////////////////////
	
	INICIO PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	declare @cue_id  int
	declare @bco_id  int
	declare @prov_id int
	declare @emp_id  int  --TODO:EMPRESA
	
	declare @ram_id_cuenta    int
	declare @ram_id_banco     int
	declare @ram_id_proveedor int
	declare @ram_id_Empresa   int 
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_cuenta out
	exec sp_ArbConvertId @@bco_id,  @bco_id out,  @ram_id_banco out
	exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
	exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 
	
	exec sp_GetRptId @clienteID out
	
	if @ram_id_cuenta <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
		end else 
			set @ram_id_cuenta = 0
	end
	
	if @ram_id_banco <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_banco, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_banco, @clienteID 
		end else 
			set @ram_id_banco = 0
	end
	
	if @ram_id_proveedor <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
		end else 
			set @ram_id_proveedor = 0
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


	--////////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- CONSTRUCCION DEL CALENDARIO
	--
	--////////////////////////////////////////////////////////////////////////////////////////////////

	-- Un mes esta formado unicamente por los dias del lunes al viernes

	-- Un mes tiene 5 semanas

	-- Un mes tiene un total al final de cada semana

	create table #t_meses(
													semana_id       int IDENTITY,
													mes							varchar(10),

													total						decimal(18,6) not null default(0),
													total_valor			varchar(1000)not null default('')

												)

	create table #t_meses1(
													semana_id       int IDENTITY,

													dia1_fecha			datetime,
													dia1_valor			varchar(1000) not null default(''),
													dia1_total      decimal(18,2) not null default(0)
												)

	create table #t_meses2(
													semana_id       int IDENTITY,

													dia2_fecha			datetime,
													dia2_valor			varchar(1000) not null default(''),
													dia2_total      decimal(18,2) not null default(0)
												)

	create table #t_meses3(
													semana_id       int IDENTITY,

													dia3_fecha			datetime,
													dia3_valor			varchar(1000) not null default(''),
													dia3_total      decimal(18,2) not null default(0)
												)

	create table #t_meses4(
													semana_id       int IDENTITY,

													dia4_fecha			datetime,
													dia4_valor			varchar(1000) not null default(''),
													dia4_total      decimal(18,2) not null default(0)
												)

	create table #t_meses5(
													semana_id       int IDENTITY,

													dia5_fecha			datetime,
													dia5_valor			varchar(1000) not null default(''),
													dia5_total      decimal(18,2) not null default(0)
												)

	-- 1) Hay que cargar la tabla #t_meses con todas las fechas entre fDesde y Fhasta

	declare @oldDateFirst int
	set @oldDateFirst = @@DATEFIRST 

	declare @fecha 					datetime
	declare @last_week_day 	datetime
	declare @dia            int

	set @fecha = @@Fini

	declare @mes varchar(1000)

	declare @lunes 			datetime
	declare @martes 		datetime
	declare @miercoles 	datetime
	declare @jueves 		datetime
	declare @viernes 		datetime

	declare @last_month 	varchar(10)
	declare @friday_month varchar(10)

	set datefirst 1 
	set @dia = datepart(dw,@fecha)
	set datefirst @oldDateFirst			  

	set @@Fini = dateadd(d,1-@dia,@fecha)

	set @last_week_day = dateadd(d,5-@dia,@fecha)
	set @friday_month = convert(varchar(7),@last_week_day,111)
	
	set @last_month = @friday_month

	set @@Ffin = dateadd(m,1,@@Ffin)
	set @@Ffin = dateadd(d,-day(@@Ffin),@@Ffin)

	while @fecha <= @@Ffin
	begin

		-- Tengo que insertar una nueva semana
		--
		if @fecha > @last_week_day begin

			set @mes = convert(varchar(7),@fecha,111)

			set datefirst 1 
			set @dia = datepart(dw,@fecha)
			set datefirst @oldDateFirst			  

			set @lunes 			= dateadd(d,1-@dia,@fecha)
			set @martes 		= dateadd(d,1,@lunes)
			set @miercoles 	= dateadd(d,2,@lunes)
			set @jueves 		= dateadd(d,3,@lunes)
			set @viernes 		= dateadd(d,4,@lunes)

			set @last_week_day = dateadd(d,6,@lunes)
			set @friday_month = convert(varchar(7),@viernes,111)

			insert into #t_meses(mes)
									 values (@mes)

			insert into #t_meses1(dia1_fecha)
									 values (@lunes)

			insert into #t_meses2(dia2_fecha)
									 values (@martes)

			insert into #t_meses3(dia3_fecha)
									 values (@miercoles)

			insert into #t_meses4(dia4_fecha)
									 values (@jueves)

			insert into #t_meses5(dia5_fecha)
									 values (@viernes)
		end

		-- Si cambio el mes inserto la semana otra vez en el nuevo mes
		--
		if @last_month <> @friday_month begin

			set @last_month = @friday_month

			insert into #t_meses(mes)
									 values (@friday_month)

			insert into #t_meses1(dia1_fecha)
									 values (@lunes)
			insert into #t_meses2(dia2_fecha)
									 values (@lunes)
			insert into #t_meses3(dia3_fecha)
									 values (@miercoles)
			insert into #t_meses4(dia4_fecha)
									 values (@jueves)
			insert into #t_meses5(dia5_fecha)
									 values (@viernes)
		end

		set @fecha = dateadd(d,1,@fecha)

	end

	declare @semana_id 	int
	declare @last_mes 	varchar(10)
	declare @last_dia  	datetime
	declare @dia1			 	datetime

	set @last_dia = '19000101'
	set @last_mes = ''

	declare c_semanas insensitive cursor for
	select t.semana_id, dia1_fecha, mes 
	from #t_meses t inner join #t_meses1 t1 on t.semana_id = t1.semana_id 
	order by t.semana_id

	open c_semanas
	fetch next from c_semanas into @semana_id, @dia1, @mes
	while @@fetch_status=0
	begin

		if @last_dia = @dia1 and @mes = @last_mes begin

			delete #t_meses  where semana_id = @semana_id
			delete #t_meses1 where semana_id = @semana_id
			delete #t_meses2 where semana_id = @semana_id
			delete #t_meses3 where semana_id = @semana_id
			delete #t_meses4 where semana_id = @semana_id
			delete #t_meses5 where semana_id = @semana_id
		end

		set @last_dia = @dia1
		set @last_mes = @mes

		fetch next from c_semanas into @semana_id, @dia1, @mes
	end

	close c_semanas
	deallocate c_semanas

	delete #t_meses1 where semana_id in (select semana_id 
																			 from #t_meses 
																			 where mes > convert(varchar(10),@@Ffin,111)
																			)
	delete #t_meses2 where semana_id in (select semana_id 
																			 from #t_meses 
																			 where mes > convert(varchar(10),@@Ffin,111)
																			)
	delete #t_meses3 where semana_id in (select semana_id 
																			 from #t_meses 
																			 where mes > convert(varchar(10),@@Ffin,111)
																			)
	delete #t_meses4 where semana_id in (select semana_id 
																			 from #t_meses 
																			 where mes > convert(varchar(10),@@Ffin,111)
																			)
	delete #t_meses5 where semana_id in (select semana_id 
																			 from #t_meses 
																			 where mes > convert(varchar(10),@@Ffin,111)
																			)

	delete #t_meses  where mes > convert(varchar(10),@@Ffin,111)

	--////////////////////////////////////////////////////////////////////////////////////////////////
	--
	--
	--	CARGO LA TABLA
	--
	--
	--////////////////////////////////////////////////////////////////////////////////////////////////

	-- Para filtrar cheques conciliados y rechazados
	--
		create table #t_cheques (cheq_id int)

		insert into #t_cheques (cheq_id)
	
			select distinct c.cheq_id
			from cheque c inner join chequera chq 	on c.chq_id = c.chq_id
										left join AsientoItem asi on 		c.cheq_id = asi.cheq_id
																								and c.cheq_fechacobro between	@@Fini and @@Ffin
			where c.cheq_fechacobro between	@@Fini and @@Ffin
			and asi_conciliado not in (0,1)
	------------------------------------------------------------------------------------------------

	declare c_cheques insensitive cursor for

	select 			cheq_fechacobro,

							--emp_codigo 				+ ': ' +
							--bco_codigo 				+ ' [' + cue_codigo + '] ' +
	            isnull(prov_nombre,'(sin proveedor)')
																+ ' [' +
							--cheq_numerodoc 		+ ': ' +		
							convert(varchar(20),convert(decimal(18,2),cheq_importe)) +']',

							cheq_importe,
							chq.cue_id
	
	from 
	
				Cheque cheq inner join Chequera chq         on cheq.chq_id    = chq.chq_id
										inner join Clearing cle         on cheq.cle_id    = cle.cle_id
										inner join Cuenta c 						on chq.cue_id 		= c.cue_id
	                  inner join Banco  b 						on c.bco_id    		= b.bco_id
	                  inner join Moneda m 						on c.mon_id 		  = m.mon_id

										left  join OrdenPago opg        	on cheq.opg_id    = opg.opg_id
										left  join MovimientoFondo mf     on cheq.mf_id     = mf.mf_id
										left  join DepositoBanco dbco     on cheq.dbco_id   = dbco.dbco_id

	                  left  join Documento d          on 		opg.doc_id     = d.doc_id
																											or 	mf.doc_id      = d.doc_id
																											or  dbco.doc_id    = d.doc_id

	                  left  join Empresa              on d.emp_id       = Empresa.emp_id 
	                  left  join Proveedor p    			on opg.prov_id    = p.prov_id
	                  left  join Legajo l             on opg.lgj_id     = l.lgj_id
	
	where cheq_fechacobro between	@@Fini and @@Ffin

				and (
							exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
						)

	and (			@@bSoloPendientes = 0 
				or 	not exists( select * from #t_cheques where cheq_id = cheq.cheq_id )
			)
	
	/* -///////////////////////////////////////////////////////////////////////
	
	INICIO SEGUNDA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	and   (c.cue_id  = @cue_id  or @cue_id=0)
	and   (b.bco_id  = @bco_id  or @bco_id=0)
	and   (p.prov_id = @prov_id or @prov_id=0)
	and   (d.emp_id  = @emp_id  or @emp_id=0) 
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 17 
	                  and  rptarb_hojaid = c.cue_id
								   ) 
	           )
	        or 
						 (@ram_id_cuenta = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 13 
	                  and  rptarb_hojaid = b.bco_id
								   ) 
	           )
	        or 
						 (@ram_id_banco = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 29 
	                  and  rptarb_hojaid = p.prov_id
								   ) 
	           )
	        or 
						 (@ram_id_proveedor = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1018
	                  and  rptarb_hojaid = d.emp_id
								   ) 
	           )
	        or 
						 (@ram_id_Empresa = 0)
				 )
	
	order by cheq_fechacobro

	---------------------------------------------------------------------------------------------------

	declare @dia1_fecha			datetime
	declare @dia1_valor			varchar(1000)
	declare @dia1_total			decimal(18,2)

	declare @dia2_fecha			datetime
	declare @dia2_valor			varchar(1000)
	declare @dia2_total			decimal(18,2)

	declare @dia3_fecha			datetime
	declare @dia3_valor			varchar(1000)
	declare @dia3_total			decimal(18,2)

	declare @dia4_fecha			datetime
	declare @dia4_valor			varchar(1000)
	declare @dia4_total			decimal(18,2)

	declare @dia5_fecha			datetime
	declare @dia5_valor			varchar(1000)
	declare @dia5_total			decimal(18,2)

	declare	@total					decimal(18,6)
	declare	@total_valor		varchar(1000)

	------------------------------------------

	declare @fecha_cheque 	datetime
	declare @valor					varchar(1000)
	declare @importe				decimal(18,6)
	declare @cue_id_cheque  int

	-- Con estos dos se en que semana estoy
	--
	declare @first_day_week 			datetime
	declare @last_first_day_week 	datetime

	set @last_first_day_week = '19000101'

	declare @last_day_week datetime

	create table #t_cuentas_semana (cue_id int, importe decimal(18,6))

	open c_cheques

	fetch next from c_cheques into @fecha_cheque, @valor, @importe, @cue_id_cheque

	while @@fetch_status = 0
	begin

		-- Obtengo el dia de la semana de debito del cheque
		--
		set datefirst 1 
		set @dia = datepart(dw,@fecha_cheque)
		set datefirst @oldDateFirst			  

		-- Obtengo el primer dia de la semana del debito del cheque
		--
		set @first_day_week = dateadd(d,1-@dia,@fecha_cheque)

		-- Obtengo el ultimo dia de la semana del debito del cheque
		--
		set @last_day_week = dateadd(d,5,@first_day_week)

		-- Si el cheque esta despues del viernes (sabado o domingo)
		--
		if @fecha_cheque > @last_day_week begin

			-- Pongo el cheque en el viernes
			--
			set @fecha_cheque = @last_day_week

		end

		-- Dias de la semana
		--
		if @dia = 1 begin

			update #t_meses1 
				set 
					dia1_total = dia1_total + @importe,
					dia1_valor = dia1_valor + @valor+char(10)+char(13)

			where dia1_fecha = @first_day_week

		end else begin

			select @semana_id = semana_id from #t_meses1 where dia1_fecha = @first_day_week

			if @dia = 2 
	
				update #t_meses2 
					set 
						dia2_total = dia2_total + @importe,
						dia2_valor = dia2_valor + @valor+char(10)+char(13)
	
				where semana_id = @semana_id

			else if @dia = 3 
	
				update #t_meses3 
					set 
						dia3_total = dia3_total + @importe,
						dia3_valor = dia3_valor + @valor+char(10)+char(13)
	
				where semana_id = @semana_id

			else if @dia = 4 
	
				update #t_meses4
					set 
						dia4_total = dia4_total + @importe,
						dia4_valor = dia4_valor + @valor+char(10)+char(13)
	
				where semana_id = @semana_id

			else if @dia = 5 
	
				update #t_meses5
					set 
						dia5_total = dia5_total + @importe,
						dia5_valor = dia5_valor + @valor+char(10)+char(13)
	
				where semana_id = @semana_id

		end

		-- Totales de la semana
		--

		-- Si cambie de semana
		--
		if @last_first_day_week <> @first_day_week begin

--			select * from #t_cuentas_semana

			-- Obtengo el total de la semana
			--

			set @total = 0
			set @total_valor = ''			

			declare c_semana insensitive cursor for

				select cue_nombre, sum(importe)
				from #t_cuentas_semana t
								inner join cuenta cue on t.cue_id = cue.cue_id
				group by cue_nombre

			open c_semana

			declare @cuenta 				varchar(1000)
			declare @total_cuenta 	decimal(18,2)

			fetch next from c_semana into @cuenta, @total_cuenta
			while @@fetch_status=0
			begin

				set @total = @total + @total_cuenta
				set @total_valor = @total_valor + @cuenta + ' ' + convert(varchar,@total_cuenta) +char(10)+char(13)

				fetch next from c_semana into @cuenta, @total_cuenta
			end

			close c_semana
			deallocate c_semana

			select @semana_id = semana_id from #t_meses1 where dia1_fecha = @last_first_day_week

			-- Actualizo el total de la semana
			--
			update #t_meses set total = @total, total_valor = @total_valor where semana_id = @semana_id

			-- Me preparo para la proxima semana
			--
			set @last_first_day_week = @first_day_week

			delete #t_cuentas_semana

		end

		if exists(select * from #t_cuentas_semana where cue_id = @cue_id_cheque)
		begin

			update #t_cuentas_semana set importe = importe + @importe where cue_id = @cue_id_cheque

		end else begin

			insert into #t_cuentas_semana (cue_id, importe) values (@cue_id_cheque, @importe)

		end

		fetch next from c_cheques into @fecha_cheque, @valor, @importe, @cue_id_cheque

	end

	close c_cheques

	deallocate c_cheques


	--/////////////////////////////////////////////////////////////////////////////////////
	--
	-- Ultima semana
	--

			set @total = 0
			set @total_valor = ''			

			declare c_semana insensitive cursor for

				select cue_nombre, sum(importe)
				from #t_cuentas_semana t
								inner join cuenta cue on t.cue_id = cue.cue_id
				group by cue_nombre

			open c_semana

			fetch next from c_semana into @cuenta, @total_cuenta
			while @@fetch_status=0
			begin

				set @total = @total + @total_cuenta
				set @total_valor = @total_valor + @cuenta + ' ' + convert(varchar,@total_cuenta) +char(10)+char(13)

				fetch next from c_semana into @cuenta, @total_cuenta
			end

			close c_semana
			deallocate c_semana

			select @semana_id = semana_id from #t_meses1 where dia1_fecha = @last_first_day_week

			-- Actualizo el total de la semana
			--
			update #t_meses set total = @total, total_valor = @total_valor where semana_id = @semana_id

			-- Me preparo para la proxima semana
			--
			set @last_first_day_week = @first_day_week

			delete #t_cuentas_semana

	--////////////////////////////////////////////////////////////////////////////////////////////

	-- Por limitaciones de CSReports tengo que devolver un mes en un solo registro

	create table #t_meses_rpt1(
													rpt_id					int IDENTITY,

													mes							varchar(10),

									------------------------------------------------------
									-- 1
													dia1_fecha			datetime,
													dia1_valor			varchar(1000),
													dia1_total			decimal(18,2),

													dia2_fecha			datetime,
													dia2_valor			varchar(1000),
													dia2_total			decimal(18,2),

													dia3_fecha			datetime,
													dia3_valor			varchar(1000),
													dia3_total			decimal(18,2),

													dia4_fecha			datetime,
													dia4_valor			varchar(1000),
													dia4_total			decimal(18,2),

													dia5_fecha			datetime,
													dia5_valor			varchar(1000),
													dia5_total			decimal(18,2),

													total1						decimal(18,6),
													total_valor1			varchar(1000)
									)

									------------------------------------------------------
									-- 2
	create table #t_meses_rpt2(

													rpt_id					int IDENTITY,

													dia6_fecha			datetime,
													dia6_valor			varchar(1000),
													dia6_total			decimal(18,2),

													dia7_fecha			datetime,
													dia7_valor			varchar(1000),
													dia7_total			decimal(18,2),

													dia8_fecha			datetime,
													dia8_valor			varchar(1000),
													dia8_total			decimal(18,2),

													dia9_fecha			datetime,
													dia9_valor			varchar(1000),
													dia9_total			decimal(18,2),

													dia10_fecha			datetime,
													dia10_valor			varchar(1000),
													dia10_total			decimal(18,2),

													total2						decimal(18,6),
													total_valor2			varchar(1000)
									)

									------------------------------------------------------
									-- 3
	create table #t_meses_rpt3(

													rpt_id					int IDENTITY,

													dia11_fecha			datetime,
													dia11_valor			varchar(1000),
													dia11_total			decimal(18,2),

													dia12_fecha			datetime,
													dia12_valor			varchar(1000),
													dia12_total			decimal(18,2),

													dia13_fecha			datetime,
													dia13_valor			varchar(1000),
													dia13_total			decimal(18,2),

													dia14_fecha			datetime,
													dia14_valor			varchar(1000),
													dia14_total			decimal(18,2),

													dia15_fecha			datetime,
													dia15_valor			varchar(1000),
													dia15_total			decimal(18,2),

													total3						decimal(18,6),
													total_valor3			varchar(1000)
									)

									------------------------------------------------------
									-- 4
	create table #t_meses_rpt4(

													rpt_id					int IDENTITY,

													dia16_fecha			datetime,
													dia16_valor			varchar(1000),
													dia16_total			decimal(18,2),

													dia17_fecha			datetime,
													dia17_valor			varchar(1000),
													dia17_total			decimal(18,2),

													dia18_fecha			datetime,
													dia18_valor			varchar(1000),
													dia18_total			decimal(18,2),

													dia19_fecha			datetime,
													dia19_valor			varchar(1000),
													dia19_total			decimal(18,2),

													dia20_fecha			datetime,
													dia20_valor			varchar(1000),
													dia20_total			decimal(18,2),

													total4						decimal(18,6),
													total_valor4			varchar(1000)
									)

									------------------------------------------------------
									-- 5
	create table #t_meses_rpt5(

													rpt_id					int IDENTITY,

													dia21_fecha			datetime,
													dia21_valor			varchar(1000),
													dia21_total			decimal(18,2),

													dia22_fecha			datetime,
													dia22_valor			varchar(1000),
													dia22_total			decimal(18,2),

													dia23_fecha			datetime,
													dia23_valor			varchar(1000),
													dia23_total			decimal(18,2),

													dia24_fecha			datetime,
													dia24_valor			varchar(1000),
													dia24_total			decimal(18,2),

													dia25_fecha			datetime,
													dia25_valor			varchar(1000),
													dia25_total			decimal(18,2),

													total5						decimal(18,6),
													total_valor5			varchar(1000)
									)
									------------------------------------------------------

	------------------------------------------
	declare @dia_rpt_1_fecha			datetime,
					@dia_rpt_1_valor			varchar(1000),
					@dia_rpt_1_total			decimal(18,2),

					@dia_rpt_2_fecha			datetime,
					@dia_rpt_2_valor			varchar(1000),
					@dia_rpt_2_total			decimal(18,2),

					@dia_rpt_3_fecha			datetime,
					@dia_rpt_3_valor			varchar(1000),
					@dia_rpt_3_total			decimal(18,2),

					@dia_rpt_4_fecha			datetime,
					@dia_rpt_4_valor			varchar(1000),
					@dia_rpt_4_total			decimal(18,2),

					@dia_rpt_5_fecha			datetime,
					@dia_rpt_5_valor			varchar(1000),
					@dia_rpt_5_total			decimal(18,2),

					@dia_rpt_6_fecha			datetime,
					@dia_rpt_6_valor			varchar(1000),
					@dia_rpt_6_total			decimal(18,2),

					@dia_rpt_7_fecha			datetime,
					@dia_rpt_7_valor			varchar(1000),
					@dia_rpt_7_total			decimal(18,2),

					@dia_rpt_8_fecha			datetime,
					@dia_rpt_8_valor			varchar(1000),
					@dia_rpt_8_total			decimal(18,2),

					@dia_rpt_9_fecha			datetime,
					@dia_rpt_9_valor			varchar(1000),
					@dia_rpt_9_total			decimal(18,2),

					@dia_rpt_10_fecha			datetime,
					@dia_rpt_10_valor			varchar(1000),
					@dia_rpt_10_total			decimal(18,2),

					@dia_rpt_11_fecha			datetime,
					@dia_rpt_11_valor			varchar(1000),
					@dia_rpt_11_total			decimal(18,2),

					@dia_rpt_12_fecha			datetime,
					@dia_rpt_12_valor			varchar(1000),
					@dia_rpt_12_total			decimal(18,2),

					@dia_rpt_13_fecha			datetime,
					@dia_rpt_13_valor			varchar(1000),
					@dia_rpt_13_total			decimal(18,2),

					@dia_rpt_14_fecha			datetime,
					@dia_rpt_14_valor			varchar(1000),
					@dia_rpt_14_total			decimal(18,2),

					@dia_rpt_15_fecha			datetime,
					@dia_rpt_15_valor			varchar(1000),
					@dia_rpt_15_total			decimal(18,2),

					@dia_rpt_16_fecha			datetime,
					@dia_rpt_16_valor			varchar(1000),
					@dia_rpt_16_total			decimal(18,2),

					@dia_rpt_17_fecha			datetime,
					@dia_rpt_17_valor			varchar(1000),
					@dia_rpt_17_total			decimal(18,2),

					@dia_rpt_18_fecha			datetime,
					@dia_rpt_18_valor			varchar(1000),
					@dia_rpt_18_total			decimal(18,2),

					@dia_rpt_19_fecha			datetime,
					@dia_rpt_19_valor			varchar(1000),
					@dia_rpt_19_total			decimal(18,2),

					@dia_rpt_20_fecha			datetime,
					@dia_rpt_20_valor			varchar(1000),
					@dia_rpt_20_total			decimal(18,2),

					@dia_rpt_21_fecha			datetime,
					@dia_rpt_21_valor			varchar(1000),
					@dia_rpt_21_total			decimal(18,2),

					@dia_rpt_22_fecha			datetime,
					@dia_rpt_22_valor			varchar(1000),
					@dia_rpt_22_total			decimal(18,2),

					@dia_rpt_23_fecha			datetime,
					@dia_rpt_23_valor			varchar(1000),
					@dia_rpt_23_total			decimal(18,2),

					@dia_rpt_24_fecha			datetime,
					@dia_rpt_24_valor			varchar(1000),
					@dia_rpt_24_total			decimal(18,2),

					@dia_rpt_25_fecha			datetime,
					@dia_rpt_25_valor			varchar(1000),
					@dia_rpt_25_total			decimal(18,2),

					@total1								decimal(18,6),
					@total_valor1					varchar(1000),
					@total2								decimal(18,6),
					@total_valor2					varchar(1000),
					@total3								decimal(18,6),
					@total_valor3					varchar(1000),
					@total4								decimal(18,6),
					@total_valor4					varchar(1000),
					@total5								decimal(18,6),
					@total_valor5					varchar(1000)

	------------------------------------------

	declare @n int

	set @last_mes = ''

	-- Inicializo la quinta semana
	-- por que puede faltar
	--
	select

			@dia_rpt_21_fecha=		'19000101',
			@dia_rpt_21_valor=		'',
			@dia_rpt_21_total=		0,

			@dia_rpt_22_fecha=		'19000101',
			@dia_rpt_22_valor=		'',
			@dia_rpt_22_total=		0,

			@dia_rpt_23_fecha=		'19000101',
			@dia_rpt_23_valor=		'',
			@dia_rpt_23_total=		0,

			@dia_rpt_24_fecha=		'19000101',
			@dia_rpt_24_valor=		'',
			@dia_rpt_24_total=		0,

			@dia_rpt_25_fecha=		'19000101',
			@dia_rpt_25_valor=		'',
			@dia_rpt_25_total=		0,

			@total5					 =		0,
			@total_valor5		 =		''

	set @n = 0

	declare c_meses insensitive cursor for 

		select 
					mes,
					dia1_fecha,
					dia1_valor,
					dia1_total,
					dia2_fecha,
					dia2_valor,
					dia2_total,
					dia3_fecha,
					dia3_valor,
					dia3_total,
					dia4_fecha,
					dia4_valor,
					dia4_total,
					dia5_fecha,
					dia5_valor,
					dia5_total,
					total,
					total_valor

		from #t_meses t inner join #t_meses1 t1 on t.semana_id = t1.semana_id
										inner join #t_meses2 t2 on t.semana_id = t2.semana_id
										inner join #t_meses3 t3 on t.semana_id = t3.semana_id
										inner join #t_meses4 t4 on t.semana_id = t4.semana_id
										inner join #t_meses5 t5 on t.semana_id = t5.semana_id

		order by t.mes, t1.dia1_fecha

	open c_meses

	fetch next from c_meses into 
																		@mes,
																		@dia1_fecha,
																		@dia1_valor,
																		@dia1_total,
																		@dia2_fecha,
																		@dia2_valor,
																		@dia2_total,
																		@dia3_fecha,
																		@dia3_valor,
																		@dia3_total,
																		@dia4_fecha,
																		@dia4_valor,
																		@dia4_total,
																		@dia5_fecha,
																		@dia5_valor,
																		@dia5_total,
																		@total,
																		@total_valor
	
	while @@fetch_status=0
	begin

			if @last_mes = '' set @last_mes = @mes

			if @last_mes <> @mes begin

				------------------------------------------------------
				-- 1

				insert into #t_meses_rpt1 (
	
														mes							,

														dia1_fecha			,
														dia1_valor			,
														dia1_total			,
	
														dia2_fecha			,
														dia2_valor			,
														dia2_total			,
	
														dia3_fecha			,
														dia3_valor			,
														dia3_total			,
	
														dia4_fecha			,
														dia4_valor			,
														dia4_total			,
	
														dia5_fecha			,
														dia5_valor			,
														dia5_total			,

														total1					,
														total_valor1				

																	)

									values (
														@last_mes							,
														@dia_rpt_1_fecha			,
														@dia_rpt_1_valor			,
														@dia_rpt_1_total			,
	
														@dia_rpt_2_fecha			,
														@dia_rpt_2_valor			,
														@dia_rpt_2_total			,
	
														@dia_rpt_3_fecha			,
														@dia_rpt_3_valor			,
														@dia_rpt_3_total			,
	
														@dia_rpt_4_fecha			,
														@dia_rpt_4_valor			,
														@dia_rpt_4_total			,
	
														@dia_rpt_5_fecha			,
														@dia_rpt_5_valor			,
														@dia_rpt_5_total			,

														@total1								,
														@total_valor1					
													)

				------------------------------------------------------
				-- 2

				insert into #t_meses_rpt2 (
	
														dia6_fecha			,
														dia6_valor			,
														dia6_total			,
	
														dia7_fecha			,
														dia7_valor			,
														dia7_total			,
	
														dia8_fecha			,
														dia8_valor			,
														dia8_total			,
	
														dia9_fecha			,
														dia9_valor			,
														dia9_total			,
	
														dia10_fecha			,
														dia10_valor			,
														dia10_total			,

														total2					,
														total_valor2				

																	)

									values (
														@dia_rpt_6_fecha			,
														@dia_rpt_6_valor			,
														@dia_rpt_6_total			,
	
														@dia_rpt_7_fecha			,
														@dia_rpt_7_valor			,
														@dia_rpt_7_total			,
	
														@dia_rpt_8_fecha			,
														@dia_rpt_8_valor			,
														@dia_rpt_8_total			,
	
														@dia_rpt_9_fecha			,
														@dia_rpt_9_valor			,
														@dia_rpt_9_total			,
	
														@dia_rpt_10_fecha			,
														@dia_rpt_10_valor			,
														@dia_rpt_10_total			,

														@total2								,
														@total_valor2					
													)

				------------------------------------------------------
				-- 3

				insert into #t_meses_rpt3 (
	
														dia11_fecha			,
														dia11_valor			,
														dia11_total			,
	
														dia12_fecha			,
														dia12_valor			,
														dia12_total			,
	
														dia13_fecha			,
														dia13_valor			,
														dia13_total			,
	
														dia14_fecha			,
														dia14_valor			,
														dia14_total			,
	
														dia15_fecha			,
														dia15_valor			,
														dia15_total			,

														total3					,
														total_valor3				

																	)

										values (
														@dia_rpt_11_fecha			,
														@dia_rpt_11_valor			,
														@dia_rpt_11_total			,
	
														@dia_rpt_12_fecha			,
														@dia_rpt_12_valor			,
														@dia_rpt_12_total			,
	
														@dia_rpt_13_fecha			,
														@dia_rpt_13_valor			,
														@dia_rpt_13_total			,
	
														@dia_rpt_14_fecha			,
														@dia_rpt_14_valor			,
														@dia_rpt_14_total			,
	
														@dia_rpt_15_fecha			,
														@dia_rpt_15_valor			,
														@dia_rpt_15_total			,

														@total3								,
														@total_valor3					
													)


				------------------------------------------------------
				-- 4

				insert into #t_meses_rpt4 (

														dia16_fecha			,
														dia16_valor			,
														dia16_total			,
	
														dia17_fecha			,
														dia17_valor			,
														dia17_total			,
	
														dia18_fecha			,
														dia18_valor			,
														dia18_total			,
	
														dia19_fecha			,
														dia19_valor			,
														dia19_total			,
	
														dia20_fecha			,
														dia20_valor			,
														dia20_total			,

														total4					,
														total_valor4				

																	)

										values (
														@dia_rpt_16_fecha			,
														@dia_rpt_16_valor			,
														@dia_rpt_16_total			,
	
														@dia_rpt_17_fecha			,
														@dia_rpt_17_valor			,
														@dia_rpt_17_total			,
	
														@dia_rpt_18_fecha			,
														@dia_rpt_18_valor			,
														@dia_rpt_18_total			,
	
														@dia_rpt_19_fecha			,
														@dia_rpt_19_valor			,
														@dia_rpt_19_total			,
	
														@dia_rpt_20_fecha			,
														@dia_rpt_20_valor			,
														@dia_rpt_20_total			,

														@total4								,
														@total_valor4					
													)

				------------------------------------------------------
				-- 5

				insert into #t_meses_rpt5 (
	
														dia21_fecha			,
														dia21_valor			,
														dia21_total			,
	
														dia22_fecha			,
														dia22_valor			,
														dia22_total			,
	
														dia23_fecha			,
														dia23_valor			,
														dia23_total			,
	
														dia24_fecha			,
														dia24_valor			,
														dia24_total			,
	
														dia25_fecha			,
														dia25_valor			,
														dia25_total			,
		
														total5					,
														total_valor5		

																	)

									values (	
														@dia_rpt_21_fecha			,
														@dia_rpt_21_valor			,
														@dia_rpt_21_total			,
	
														@dia_rpt_22_fecha			,
														@dia_rpt_22_valor			,
														@dia_rpt_22_total			,
	
														@dia_rpt_23_fecha			,
														@dia_rpt_23_valor			,
														@dia_rpt_23_total			,
	
														@dia_rpt_24_fecha			,
														@dia_rpt_24_valor			,
														@dia_rpt_24_total			,
	
														@dia_rpt_25_fecha			,
														@dia_rpt_25_valor			,
														@dia_rpt_25_total			,
	
														@total5								,
														@total_valor5		
													)

				------------------------------------------------------
				-- 

				set @last_mes = @mes

				set @n = 0

				select

						@dia_rpt_21_fecha=		'19000101',
						@dia_rpt_21_valor=		'',
						@dia_rpt_21_total=		0,

						@dia_rpt_22_fecha=		'19000101',
						@dia_rpt_22_valor=		'',
						@dia_rpt_22_total=		0,

						@dia_rpt_23_fecha=		'19000101',
						@dia_rpt_23_valor=		'',
						@dia_rpt_23_total=		0,

						@dia_rpt_24_fecha=		'19000101',
						@dia_rpt_24_valor=		'',
						@dia_rpt_24_total=		0,

						@dia_rpt_25_fecha=		'19000101',
						@dia_rpt_25_valor=		'',
						@dia_rpt_25_total=		0,

						@total5					 =		0,
						@total_valor5		 =		''

			end

			if @n = 0 begin

				select 
						@dia_rpt_1_fecha=		@dia1_fecha,
						@dia_rpt_1_valor=		@dia1_valor,
						@dia_rpt_1_total=		@dia1_total,

						@dia_rpt_2_fecha=		@dia2_fecha,
						@dia_rpt_2_valor=		@dia2_valor,
						@dia_rpt_2_total=		@dia2_total,

						@dia_rpt_3_fecha=		@dia3_fecha,
						@dia_rpt_3_valor=		@dia3_valor,
						@dia_rpt_3_total=		@dia3_total,

						@dia_rpt_4_fecha=		@dia4_fecha,
						@dia_rpt_4_valor=		@dia4_valor,
						@dia_rpt_4_total=		@dia4_total,

						@dia_rpt_5_fecha=		@dia5_fecha,
						@dia_rpt_5_valor=		@dia5_valor,
						@dia_rpt_5_total=		@dia5_total,

						@total1					=		@total,
						@total_valor1		=		@total_valor

			end 
			if @n = 1 begin

				select 
						@dia_rpt_6_fecha =		@dia1_fecha,
						@dia_rpt_6_valor =		@dia1_valor,
						@dia_rpt_6_total =		@dia1_total,

						@dia_rpt_7_fecha =		@dia2_fecha,
						@dia_rpt_7_valor =		@dia2_valor,
						@dia_rpt_7_total =		@dia2_total,

						@dia_rpt_8_fecha =		@dia3_fecha,
						@dia_rpt_8_valor =		@dia3_valor,
						@dia_rpt_8_total =		@dia3_total,

						@dia_rpt_9_fecha =		@dia4_fecha,
						@dia_rpt_9_valor =		@dia4_valor,
						@dia_rpt_9_total =		@dia4_total,

						@dia_rpt_10_fecha=		@dia5_fecha,
						@dia_rpt_10_valor=		@dia5_valor,
						@dia_rpt_10_total=		@dia5_total,

						@total2					 =		@total,
						@total_valor2		 =		@total_valor

			end 
			if @n = 2 begin

				select 
						@dia_rpt_11_fecha=		@dia1_fecha,
						@dia_rpt_11_valor=		@dia1_valor,
						@dia_rpt_11_total=		@dia1_total,

						@dia_rpt_12_fecha=		@dia2_fecha,
						@dia_rpt_12_valor=		@dia2_valor,
						@dia_rpt_12_total=		@dia2_total,

						@dia_rpt_13_fecha=		@dia3_fecha,
						@dia_rpt_13_valor=		@dia3_valor,
						@dia_rpt_13_total=		@dia3_total,

						@dia_rpt_14_fecha=		@dia4_fecha,
						@dia_rpt_14_valor=		@dia4_valor,
						@dia_rpt_14_total=		@dia4_total,

						@dia_rpt_15_fecha=		@dia5_fecha,
						@dia_rpt_15_valor=		@dia5_valor,
						@dia_rpt_15_total=		@dia5_total,

						@total3					 =		@total,
						@total_valor3		 =		@total_valor

			end 
			if @n = 3 begin

				select 
						@dia_rpt_16_fecha=		@dia1_fecha,
						@dia_rpt_16_valor=		@dia1_valor,
						@dia_rpt_16_total=		@dia1_total,

						@dia_rpt_17_fecha=		@dia2_fecha,
						@dia_rpt_17_valor=		@dia2_valor,
						@dia_rpt_17_total=		@dia2_total,

						@dia_rpt_18_fecha=		@dia3_fecha,
						@dia_rpt_18_valor=		@dia3_valor,
						@dia_rpt_18_total=		@dia3_total,

						@dia_rpt_19_fecha=		@dia4_fecha,
						@dia_rpt_19_valor=		@dia4_valor,
						@dia_rpt_19_total=		@dia4_total,

						@dia_rpt_20_fecha=		@dia5_fecha,
						@dia_rpt_20_valor=		@dia5_valor,
						@dia_rpt_20_total=		@dia5_total,

						@total4					 =		@total,
						@total_valor4		 =		@total_valor

			end 
			if @n = 4 begin

				select 
						@dia_rpt_21_fecha=		@dia1_fecha,
						@dia_rpt_21_valor=		@dia1_valor,
						@dia_rpt_21_total=		@dia1_total,

						@dia_rpt_22_fecha=		@dia2_fecha,
						@dia_rpt_22_valor=		@dia2_valor,
						@dia_rpt_22_total=		@dia2_total,

						@dia_rpt_23_fecha=		@dia3_fecha,
						@dia_rpt_23_valor=		@dia3_valor,
						@dia_rpt_23_total=		@dia3_total,

						@dia_rpt_24_fecha=		@dia4_fecha,
						@dia_rpt_24_valor=		@dia4_valor,
						@dia_rpt_24_total=		@dia4_total,

						@dia_rpt_25_fecha=		@dia5_fecha,
						@dia_rpt_25_valor=		@dia5_valor,
						@dia_rpt_25_total=		@dia5_total,

						@total5					 =		@total,
						@total_valor5		 =		@total_valor

			end

		set @n = @n+1

		fetch next from c_meses into 
																		@mes,
																		@dia1_fecha,
																		@dia1_valor,
																		@dia1_total,
																		@dia2_fecha,
																		@dia2_valor,
																		@dia2_total,
																		@dia3_fecha,
																		@dia3_valor,
																		@dia3_total,
																		@dia4_fecha,
																		@dia4_valor,
																		@dia4_total,
																		@dia5_fecha,
																		@dia5_valor,
																		@dia5_total,
																		@total,
																		@total_valor
	end

	close c_meses

	deallocate c_meses

--////////////////////////////////////////////////////////////////////////////////////////
				------------------------------------------------------
				-- 1

				insert into #t_meses_rpt1 (
	
														mes							,

														dia1_fecha			,
														dia1_valor			,
														dia1_total			,
	
														dia2_fecha			,
														dia2_valor			,
														dia2_total			,
	
														dia3_fecha			,
														dia3_valor			,
														dia3_total			,
	
														dia4_fecha			,
														dia4_valor			,
														dia4_total			,
	
														dia5_fecha			,
														dia5_valor			,
														dia5_total			,

														total1					,
														total_valor1				

																	)

									values (
														@last_mes							,
														@dia_rpt_1_fecha			,
														@dia_rpt_1_valor			,
														@dia_rpt_1_total			,
	
														@dia_rpt_2_fecha			,
														@dia_rpt_2_valor			,
														@dia_rpt_2_total			,
	
														@dia_rpt_3_fecha			,
														@dia_rpt_3_valor			,
														@dia_rpt_3_total			,
	
														@dia_rpt_4_fecha			,
														@dia_rpt_4_valor			,
														@dia_rpt_4_total			,
	
														@dia_rpt_5_fecha			,
														@dia_rpt_5_valor			,
														@dia_rpt_5_total			,

														@total1								,
														@total_valor1					
													)

				------------------------------------------------------
				-- 2

				insert into #t_meses_rpt2 (
	
														dia6_fecha			,
														dia6_valor			,
														dia6_total			,
	
														dia7_fecha			,
														dia7_valor			,
														dia7_total			,
	
														dia8_fecha			,
														dia8_valor			,
														dia8_total			,
	
														dia9_fecha			,
														dia9_valor			,
														dia9_total			,
	
														dia10_fecha			,
														dia10_valor			,
														dia10_total			,

														total2					,
														total_valor2				

																	)

									values (
														@dia_rpt_6_fecha			,
														@dia_rpt_6_valor			,
														@dia_rpt_6_total			,
	
														@dia_rpt_7_fecha			,
														@dia_rpt_7_valor			,
														@dia_rpt_7_total			,
	
														@dia_rpt_8_fecha			,
														@dia_rpt_8_valor			,
														@dia_rpt_8_total			,
	
														@dia_rpt_9_fecha			,
														@dia_rpt_9_valor			,
														@dia_rpt_9_total			,
	
														@dia_rpt_10_fecha			,
														@dia_rpt_10_valor			,
														@dia_rpt_10_total			,

														@total2								,
														@total_valor2					
													)

				------------------------------------------------------
				-- 3

				insert into #t_meses_rpt3 (
	
														dia11_fecha			,
														dia11_valor			,
														dia11_total			,
	
														dia12_fecha			,
														dia12_valor			,
														dia12_total			,
	
														dia13_fecha			,
														dia13_valor			,
														dia13_total			,
	
														dia14_fecha			,
														dia14_valor			,
														dia14_total			,
	
														dia15_fecha			,
														dia15_valor			,
														dia15_total			,

														total3					,
														total_valor3				

																	)

										values (
														@dia_rpt_11_fecha			,
														@dia_rpt_11_valor			,
														@dia_rpt_11_total			,
	
														@dia_rpt_12_fecha			,
														@dia_rpt_12_valor			,
														@dia_rpt_12_total			,
	
														@dia_rpt_13_fecha			,
														@dia_rpt_13_valor			,
														@dia_rpt_13_total			,
	
														@dia_rpt_14_fecha			,
														@dia_rpt_14_valor			,
														@dia_rpt_14_total			,
	
														@dia_rpt_15_fecha			,
														@dia_rpt_15_valor			,
														@dia_rpt_15_total			,

														@total3								,
														@total_valor3					
													)


				------------------------------------------------------
				-- 4

				insert into #t_meses_rpt4 (

														dia16_fecha			,
														dia16_valor			,
														dia16_total			,
	
														dia17_fecha			,
														dia17_valor			,
														dia17_total			,
	
														dia18_fecha			,
														dia18_valor			,
														dia18_total			,
	
														dia19_fecha			,
														dia19_valor			,
														dia19_total			,
	
														dia20_fecha			,
														dia20_valor			,
														dia20_total			,

														total4					,
														total_valor4				

																	)

										values (
														@dia_rpt_16_fecha			,
														@dia_rpt_16_valor			,
														@dia_rpt_16_total			,
	
														@dia_rpt_17_fecha			,
														@dia_rpt_17_valor			,
														@dia_rpt_17_total			,
	
														@dia_rpt_18_fecha			,
														@dia_rpt_18_valor			,
														@dia_rpt_18_total			,
	
														@dia_rpt_19_fecha			,
														@dia_rpt_19_valor			,
														@dia_rpt_19_total			,
	
														@dia_rpt_20_fecha			,
														@dia_rpt_20_valor			,
														@dia_rpt_20_total			,

														@total4								,
														@total_valor4					
													)

				------------------------------------------------------
				-- 5

				insert into #t_meses_rpt5 (
	
														dia21_fecha			,
														dia21_valor			,
														dia21_total			,
	
														dia22_fecha			,
														dia22_valor			,
														dia22_total			,
	
														dia23_fecha			,
														dia23_valor			,
														dia23_total			,
	
														dia24_fecha			,
														dia24_valor			,
														dia24_total			,
	
														dia25_fecha			,
														dia25_valor			,
														dia25_total			,
		
														total5					,
														total_valor5		

																	)

									values (	
														@dia_rpt_21_fecha			,
														@dia_rpt_21_valor			,
														@dia_rpt_21_total			,
	
														@dia_rpt_22_fecha			,
														@dia_rpt_22_valor			,
														@dia_rpt_22_total			,
	
														@dia_rpt_23_fecha			,
														@dia_rpt_23_valor			,
														@dia_rpt_23_total			,
	
														@dia_rpt_24_fecha			,
														@dia_rpt_24_valor			,
														@dia_rpt_24_total			,
	
														@dia_rpt_25_fecha			,
														@dia_rpt_25_valor			,
														@dia_rpt_25_total			,
	
														@total5								,
														@total_valor5		
													)

				------------------------------------------------------
				-- 
--////////////////////////////////////////////////////////////////////////////////////////

	select 

						mes,

		------------------------------------------------------
		-- 1
						dia1_fecha,
						dia1_valor,
						dia1_total,

						dia2_fecha,
						dia2_valor,
						dia2_total,

						dia3_fecha,
						dia3_valor,
						dia3_total,

						dia4_fecha,
						dia4_valor,
						dia4_total,

						dia5_fecha,
						dia5_valor,
						dia5_total,

						total1,
						total_valor1,

		------------------------------------------------------
		-- 2
						dia6_fecha,
						dia6_valor,
						dia6_total,

						dia7_fecha,
						dia7_valor,
						dia7_total,

						dia8_fecha,
						dia8_valor,
						dia8_total,

						dia9_fecha,
						dia9_valor,
						dia9_total,

						dia10_fecha,
						dia10_valor,
						dia10_total,

						total2,
						total_valor2,

		------------------------------------------------------
		-- 3
						dia11_fecha,
						dia11_valor,
						dia11_total,

						dia12_fecha,
						dia12_valor,
						dia12_total,

						dia13_fecha,
						dia13_valor,
						dia13_total,

						dia14_fecha,
						dia14_valor,
						dia14_total,

						dia15_fecha,
						dia15_valor,
						dia15_total,

						total3,
						total_valor3,

		------------------------------------------------------
		-- 4
						dia16_fecha,
						dia16_valor,
						dia16_total,

						dia17_fecha,
						dia17_valor,
						dia17_total,

						dia18_fecha,
						dia18_valor,
						dia18_total,

						dia19_fecha,
						dia19_valor,
						dia19_total,

						dia20_fecha,
						dia20_valor,
						dia20_total,

						total4,
						total_valor4,

		------------------------------------------------------
		-- 5
						dia21_fecha,
						dia21_valor,
						dia21_total,

						dia22_fecha,
						dia22_valor,
						dia22_total,

						dia23_fecha,
						dia23_valor,
						dia23_total,

						dia24_fecha,
						dia24_valor,
						dia24_total,

						dia25_fecha,
						dia25_valor,
						dia25_total,

						total5,
						total_valor5

	from 	#t_meses_rpt1 t1 	inner join #t_meses_rpt2 t2 on t1.rpt_id = t2.rpt_id
													inner join #t_meses_rpt3 t3 on t1.rpt_id = t3.rpt_id
													inner join #t_meses_rpt4 t4 on t1.rpt_id = t4.rpt_id
													inner join #t_meses_rpt5 t5 on t1.rpt_id = t5.rpt_id

	order by mes, dia1_fecha

end
go