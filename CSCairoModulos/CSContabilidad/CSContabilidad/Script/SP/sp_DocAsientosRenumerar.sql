if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientosRenumerar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientosRenumerar]

/*

*/

go
create procedure sp_DocAsientosRenumerar (

	@@ejc_id 		int,
	@@cico_id		varchar(255)

)
as

begin

	set nocount on

	declare @emp_id  		int
	declare @fechaIni		datetime
	declare @fechaFin   datetime

	declare @as_id_ap			int
	declare @as_id_cp			int
	declare @as_id_cr			int

	select 	@as_id_ap		= isnull(as_id_apertura,0),
					@as_id_cp		= isnull(as_id_cierrepatrimonial,0),
					@as_id_cr   = isnull(as_id_cierreresultados,0)

	from EjercicioContable

	where ejc_id = @@ejc_id

	delete EjercicioAsientoResumen where ejc_id = @@ejc_id

	select 	@emp_id 			= emp_id,
					@fechaIni			= ejc_fechaini,
					@fechaFin			= ejc_fechafin

	from EjercicioContable where ejc_id = @@ejc_id

	--/////////////////////////////////////////////////////////////////////////////////
	--
	-- Circuito Contable
	--

		declare @cico_id 		int
		declare @ram_id_circuitocontable int
	
		declare @clienteID int
		declare @IsRaiz    tinyint
	
		exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
	
		exec sp_GetRptId @clienteID out
	
		if @ram_id_circuitocontable <> 0 begin
		
		--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id
		
			exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
		  if @IsRaiz = 0 begin
				exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
			end else 
				set @ram_id_circuitocontable = 0
		end
	
	--
	-- Circuito Contable
	--
	--/////////////////////////////////////////////////////////////////////////////////

	-- Averiguo el tipo de resumen 
	-- que usa para ventas y compras
  declare @tipo_fc 		tinyint
  declare @tipo_fv 		tinyint
  declare @cfg_valor 	varchar(5000)

	exec sp_Cfg_GetValor 	'Contabilidad-General','Tipo Resumen Libro Diario Compras',  @cfg_valor out, 0
	if @cfg_valor is null 				set @tipo_fc = 3
  else begin
		if IsNumeric(@cfg_valor)=0  set @tipo_fc = 3
    else                        set @tipo_fc = convert(smallint,@cfg_valor)
  end

	exec sp_Cfg_GetValor 	'Contabilidad-General','Tipo Resumen Libro Diario Ventas',  @cfg_valor out, 0
	if @cfg_valor is null 				set @tipo_fv = 3
  else begin
		if IsNumeric(@cfg_valor)=0  set @tipo_fv = 3
    else                        set @tipo_fv = convert(smallint,@cfg_valor)
  end

	declare @as_id 			int
	declare @as_fecha		datetime
	declare @nro        int
	declare @nro_aux    int
	declare @nrodocld   varchar(50)

	declare @last_year       int
	declare @last_month      int
	declare @last_week       int

	declare @curr_year       int
	declare @curr_month      int
	declare @curr_week       int

	declare @dif 						 int
	declare @real_dif				 int
	declare @fecha           datetime
	declare @fecha_desde     datetime
	declare @fecha_hasta     datetime
	declare @weekday         int
	declare @monthday        int

	declare @ejcas_id				 int
	declare @bUpdateEjcas    tinyint

	declare @bResumLast      tinyint
	declare @last_fecha      datetime

	set @bResumLast = 0
	set @nro 			  = 0
	set @nro_aux 	  = @nro

	-------------------------------------------
	declare @oldDateFirst int
	set @oldDateFirst = @@DATEFIRST 

	set datefirst 1 

	set @last_year 	= year(@fechaIni)
	set @last_month = month(@fechaIni)
	set @last_week 	= datepart(wk,@fechaIni)

	set datefirst @oldDateFirst			  
	-------------------------------------------


	-------------------------------------------
	-- Apertura del ejercicio
	--
	if @as_id_ap <> 0 begin

		set @nro = @nro +1
		set @nro_aux = @nro

		set @nrodocld = substring('00000000',1,8-len(convert(varchar(50),@nro))) + convert(varchar(50),@nro)

		update Asiento set as_nrodocld = @nrodocld where as_id = @as_id_ap

	end
	-------------------------------------------

	declare c_asiento insensitive cursor for

		select as_id, as_fecha
		from Asiento ast inner join Documento doc 		on ast.doc_id 				= doc.doc_id
										 left  join Documento doccl 	on ast.doc_id_cliente = doccl.doc_id
		where as_fecha between @fechaIni and @fechaFin

			and doc.emp_id = @emp_id
			and (			isnull(ast.doct_id_cliente,0) not in (2,8,10)
						or 	@tipo_fc = 3
					)
			and (			isnull(ast.doct_id_cliente,0) not in (1,7,9)
						or 	@tipo_fv = 3
					)

			-- Sin asientos de apertura y cierre
			--
			and as_id not in (@as_id_ap,@as_id_cp,@as_id_cr)


			--//////////////////////////////////////////////////////////////////////////////////
			--
			-- Circuito Contable
			--
			and (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id = 0)
			and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id))) or (@ram_id_circuitocontable = 0))
			--//////////////////////////////////////////////////////////////////////////////////

		order by as_fecha, as_id asc

	open c_asiento

	fetch next from c_asiento into @as_id, @as_fecha
	while @@fetch_status = 0
	begin

		set @bResumLast = 1

		exec sp_DocAsientosResumirAux
																								-- Parametros
																								
																								@@ejc_id				 ,
																								@emp_id  				 ,
																								@cico_id 				 ,
																								@ram_id_circuitocontable ,
																								@clienteID 			 ,
																								
																								@tipo_fc 				 ,
																								@tipo_fv 				 ,
																								@oldDateFirst 	 ,
																								@as_fecha		     ,

																								0, -- Is Last
																								
																								@last_year       out,
																								@last_week       out,
																								@last_month      out,
																								
																								@curr_year       out,
																								@curr_week       out,
																								@curr_month      out,																								
																								
																								-- Parametros y retorno
																								
																								@dif 						 out,
																								@real_dif				 out,
																								@fecha           out,
																								@fecha_desde     out,
																								@fecha_hasta     out,
																								@weekday         out,
																								@monthday        out,
																								
																								@ejcas_id				 out,
																								@bUpdateEjcas    out,
																								
																								-- Retorno
																								@nro        		 out,
																								@nro_aux 				 out

		set @nro = @nro +1
		set @nro_aux = @nro

		set @nrodocld = substring('00000000',1,8-len(convert(varchar(50),@nro))) + convert(varchar(50),@nro)

		update Asiento set as_nrodocld = @nrodocld where as_id = @as_id

		set @last_fecha = @as_fecha

		fetch next from c_asiento into @as_id, @as_fecha
	end

	close c_asiento
	deallocate c_asiento

	if @bResumLast <> 0 begin

		set @as_fecha = dateadd(m,1,@last_fecha)

		exec sp_DocAsientosResumirAux
																								-- Parametros
																								
																								@@ejc_id				 ,
																								@emp_id  				 ,
																								@cico_id 				 ,
																								@ram_id_circuitocontable ,
																								@clienteID 			 ,
																								
																								@tipo_fc 				 ,
																								@tipo_fv 				 ,
																								@oldDateFirst 	 ,
																								@as_fecha		     ,

																								1, -- IsLast
																								
																								@last_year       ,
																								@last_week       ,
																								@last_month      ,
																								
																								@curr_year       ,
																								@curr_week       ,
																								@curr_month      ,																								
																								
																								-- Parametros y retorno
																								
																								@dif 						 out,
																								@real_dif				 out,
																								@fecha           out,
																								@fecha_desde     out,
																								@fecha_hasta     out,
																								@weekday         out,
																								@monthday        out,
																								
																								@ejcas_id				 out,
																								@bUpdateEjcas    out,
																								
																								-- Retorno
																								@nro        		 out,
																								@nro_aux 				 out
	end

	-------------------------------------------
	-- Cierre del ejercicio
	--
	if @as_id_cr <> 0 begin

		set @nro = @nro +1
		set @nro_aux = @nro

		set @nrodocld = substring('00000000',1,8-len(convert(varchar(50),@nro))) + convert(varchar(50),@nro)

		update Asiento set as_nrodocld = @nrodocld where as_id = @as_id_cr

	end

	if @as_id_cp <> 0 begin

		set @nro = @nro +1
		set @nro_aux = @nro

		set @nrodocld = substring('00000000',1,8-len(convert(varchar(50),@nro))) + convert(varchar(50),@nro)

		update Asiento set as_nrodocld = @nrodocld where as_id = @as_id_cp

	end
	-------------------------------------------

end

GO