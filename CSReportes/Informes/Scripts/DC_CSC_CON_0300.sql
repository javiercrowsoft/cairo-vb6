/*---------------------------------------------------------------------
Nombre: Informe Economico por Centro de Costo
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0300]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0300]

go

/*  


DC_CSC_CON_0300 1,'20080101','20090101','0','0','0','0','0','0',0,1


*/

create procedure DC_CSC_CON_0300 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

	@@ccos_id 				varchar(255),
	@@cue_id          varchar(255),
  @@cico_id         varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@emp_id	 				varchar(255),
	@@arb_id          int = 0,
	@@bResumido       smallint
)as 

begin
set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id_param int
declare @mon_id   		int
declare @emp_id   		int
declare @cico_id 			int
declare @doc_id				int
declare @ccos_id 			int

declare @ram_id_cuenta           int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int
declare @ram_id_centrocosto 		 int

declare @clienteID 			int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@mon_id,  		 @mon_id  out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
exec sp_ArbConvertId @@cue_id,  		 @cue_id_param  out, 	@ram_id_cuenta out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id, 		   @doc_id  out, 				@ram_id_Documento out
exec sp_ArbConvertId @@ccos_id, 		 @ccos_id out, 				@ram_id_centrocosto out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

create table #DC_CSC_CON_0300_cuentas (
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


if @@arb_id = 0	select @@arb_id = min(arb_id) from arbol where tbl_id = 17 -- cuenta

declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n 					int 					set @n = 2
declare @raiz 			int

while exists(select * from rama r
						 where  arb_id = @@arb_id
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_2 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_3 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_4 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_5 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_6 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_7 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_8 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0300_cuentas where nodo_9 = r.ram_id)

								and @n <= 9
						)
begin

	if @n = 2 begin

		select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2) 
		select ram_id, ram_id from rama where ram_id_padre = @raiz

	end else begin if @n = 3 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3) 
		select ram_id, nodo_2, ram_id 
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_2

	end else begin if @n = 4 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3, nodo_4) 
		select ram_id, nodo_2, nodo_3, ram_id
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_3

	end else begin if @n = 5 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
		select ram_id, nodo_2, nodo_3, nodo_4, ram_id
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_4

	end else begin if @n = 6 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_5

	end else begin if @n = 7 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_6

	end else begin if @n = 8 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_7

	end else begin if @n = 9 begin

		insert #DC_CSC_CON_0300_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
		from rama r inner join #DC_CSC_CON_0300_cuentas n on r.ram_id_padre = n.nodo_8

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

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

if @ram_id_centrocosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
	end else 
		set @ram_id_centrocosto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

/*- ///////////////////////////////////////////////////////////////////////

SALDOS POR MESES

/////////////////////////////////////////////////////////////////////// */

create table #t_dc_csc_con_0300_meses (
																					row_id			int not null,
																					pr_id				int null,
																					cue_id 			int not null,
																					tipo        smallint not null,		-- Ventas / Compras
																					mes_01				decimal(18,6) not null default(0),
																					mes_02				decimal(18,6) not null default(0),
																					mes_03				decimal(18,6) not null default(0),
																					mes_04				decimal(18,6) not null default(0),
																					mes_05				decimal(18,6) not null default(0),
																					mes_06				decimal(18,6) not null default(0),
																					mes_07				decimal(18,6) not null default(0),
																					mes_08				decimal(18,6) not null default(0),
																					mes_09				decimal(18,6) not null default(0),
																					mes_10				decimal(18,6) not null default(0),
																					mes_11				decimal(18,6) not null default(0),
																					mes_12				decimal(18,6) not null default(0),
																					mes_13				decimal(18,6) not null default(0),
																					mes_14				decimal(18,6) not null default(0),
																					mes_15				decimal(18,6) not null default(0),
																					mes_16				decimal(18,6) not null default(0),
																					mes_17				decimal(18,6) not null default(0),
																					mes_18				decimal(18,6) not null default(0),
																					mes_19				decimal(18,6) not null default(0),
																					mes_20				decimal(18,6) not null default(0),
																					mes_21				decimal(18,6) not null default(0),
																					mes_22				decimal(18,6) not null default(0),
																					mes_23				decimal(18,6) not null default(0),
																					mes_24				decimal(18,6) not null default(0),
																					total				  decimal(18,6) not null default(0)
																			)

--////////////////////////////////////////////////////////////////////////////////////////

		declare @pr_id 		int
		declare @cue_id		int
		declare @mes			int
		declare @neto     decimal(18,6)

		declare @mes_01   int
		declare @mes_24		int

		declare @last_pr_id 		int
		declare @last_cue_id		int
		declare @bNew						tinyint
		declare @row_id         int

		set @row_id = 0

		declare @tipo_ventas					smallint
		declare @tipo_compras					smallint
		declare @tipo_total 					smallint
		declare @tipo_acumulado				smallint
		declare @tipo_total_compras 	smallint

		set @tipo_total_compras = -100 -- Para que sea el primer renglon
		set @tipo_ventas  			= 1
		set @tipo_compras 			= 2
		set @tipo_total   			= 100	 -- Este va siempre al final
		set @tipo_acumulado			= 101

		set @mes_01 = month(@@fini) + year(@@fini)*100
		set @mes_24 = month(@@ffin) + year(@@ffin)*100

		declare c_ventas insensitive cursor for
		
		select  
						pr.pr_id,
						cueg.cue_id,
						month(fv_fechaentrega) + year(fv_fechaentrega)*100,
						sum(fvi_neto)
		
		from
						 facturaventa fv inner join documento	doc 					on fv.doc_id  				= doc.doc_id
														 inner join facturaventaitem fvi		on fv.fv_id   				= fvi.fv_id
														 inner join producto pr             on fvi.pr_id  				= pr.pr_id
														 inner join cuentagrupo cueg        on pr.cueg_id_venta   = cueg.cueg_id
		
		where 		fv.est_id <> 7
					and fv_fechaentrega >= @@Fini
					and	fv_fechaentrega <= @@Ffin 
		
		-- Validar usuario - empresa
					and (
								exists(select * from EmpresaUsuario where emp_id = fv.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fv.mon_id 		= @mon_id 	or @mon_id	=0)
		and   (fv.emp_id  	= @emp_id 	or @emp_id	=0)
		and   (doc.cico_id 	= @cico_id  or @cico_id =0)
		and   (fv.doc_id 		= @doc_id 	or @doc_id	=0)
		and   (isnull(fvi.ccos_id,fv.ccos_id) = @ccos_id or @ccos_id=0)
		
		-- Arboles
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 17 
		                  and  rptarb_hojaid = cueg.cue_id
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = fv.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_empresa = 0)
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
							 (@ram_id_circuitocontable = 0)
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
		                  and  tbl_id = 21 
		                  and  rptarb_hojaid = isnull(fvi.ccos_id,fv.ccos_id)
									   ) 
		           )
		        or 
							 (@ram_id_centrocosto = 0)
					 )
		
		group by 
		
				pr.pr_id,
				cueg.cue_id,
				month(fv_fechaentrega) + year(fv_fechaentrega)*100

		order by 1, cueg.cue_id, month(fv_fechaentrega) + year(fv_fechaentrega)*100

	set @last_pr_id 	= 0
	set @last_cue_id	= 0
							
	open c_ventas 

	fetch next from c_ventas into @pr_id, @cue_id, @mes, @neto
	while @@fetch_status=0
	begin

		set @bNew = 0

		if isnull(@last_pr_id,0) <> isnull(@pr_id,0) begin

				set @bNew=1

		end else begin

			if @last_cue_id <> @cue_id begin
				set @bNew=1
			end

		end

		if @bNew <> 0 begin

			set @row_id = @row_id +1

			insert into #t_dc_csc_con_0300_meses (row_id, pr_id, cue_id, tipo)
																		values (@row_id, @pr_id, @cue_id, @tipo_ventas)

			set @last_pr_id 	= @pr_id
			set @last_cue_id  = @cue_id

		end

		update #t_dc_csc_con_0300_meses 

								set mes_01 = mes_01 + case when @mes - @mes_01 = 0  then @neto else 0 end,
								    mes_02 = mes_02 + case when @mes - @mes_01 = 1  then @neto else 0 end,
								    mes_03 = mes_03 + case when @mes - @mes_01 = 2  then @neto else 0 end,
								    mes_04 = mes_04 + case when @mes - @mes_01 = 3  then @neto else 0 end,
								    mes_05 = mes_05 + case when @mes - @mes_01 = 4  then @neto else 0 end,
								    mes_06 = mes_06 + case when @mes - @mes_01 = 5  then @neto else 0 end,
								    mes_07 = mes_07 + case when @mes - @mes_01 = 6  then @neto else 0 end,
								    mes_08 = mes_08 + case when @mes - @mes_01 = 7  then @neto else 0 end,
								    mes_09 = mes_09 + case when @mes - @mes_01 = 8  then @neto else 0 end,
								    mes_10 = mes_10 + case when @mes - @mes_01 = 9  then @neto else 0 end,
								    mes_11 = mes_11 + case when @mes - @mes_01 = 10 then @neto else 0 end,
								    mes_12 = mes_12 + case when @mes - @mes_01 = 11 then @neto else 0 end,
								    mes_13 = mes_13 + case when @mes - @mes_01 = 12 then @neto else 0 end,
								    mes_14 = mes_14 + case when @mes - @mes_01 = 13 then @neto else 0 end,
								    mes_15 = mes_15 + case when @mes - @mes_01 = 14 then @neto else 0 end,
								    mes_16 = mes_16 + case when @mes - @mes_01 = 15 then @neto else 0 end,
								    mes_17 = mes_17 + case when @mes - @mes_01 = 16 then @neto else 0 end,
								    mes_18 = mes_18 + case when @mes - @mes_01 = 17 then @neto else 0 end,
								    mes_19 = mes_19 + case when @mes - @mes_01 = 18 then @neto else 0 end,
								    mes_20 = mes_20 + case when @mes - @mes_01 = 19 then @neto else 0 end,
								    mes_21 = mes_21 + case when @mes - @mes_01 = 20 then @neto else 0 end,
								    mes_22 = mes_22 + case when @mes - @mes_01 = 21 then @neto else 0 end,
								    mes_23 = mes_23 + case when @mes - @mes_01 = 22 then @neto else 0 end,
								    mes_24 = mes_24 + case when @mes - @mes_01 = 23 then @neto else 0 end

		where row_id = @row_id

		fetch next from c_ventas into @pr_id, @cue_id, @mes, @neto
	end

	close c_ventas
	deallocate c_ventas

--////////////////////////////////////////////////////////////////////////////////////////

	set @last_pr_id 	= 0
	set @last_cue_id 	= 0

		declare c_compras insensitive cursor for
		
		select  
						case when @@bResumido = 0 then pr.pr_id else null end,
						cueg.cue_id,
						month(fc_fechaentrega) + year(fc_fechaentrega)*100,
						sum(fci_neto)
		
		from
						 facturacompra fc inner join documento	doc 				 on fc.doc_id  				 = doc.doc_id
														  inner join facturacompraitem fci	 on fc.fc_id   				 = fci.fc_id
														  inner join producto pr             on fci.pr_id  				 = pr.pr_id
														  inner join cuentagrupo cueg        on pr.cueg_id_compra  = cueg.cueg_id
		
		where 		fc.est_id <> 7

					and fc_fechaentrega >= @@Fini
					and	fc_fechaentrega <= @@Ffin 
		
		-- Validar usuario - empresa
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fc.mon_id 		= @mon_id 	or @mon_id	=0)
		and   (doc.emp_id  	= @emp_id 	or @emp_id	=0)
		and   (doc.cico_id 	= @cico_id  or @cico_id =0)
		and   (fc.doc_id 		= @doc_id 	or @doc_id	=0)
		and   (isnull(fci.ccos_id,fc.ccos_id) = @ccos_id or @ccos_id=0)
		
		-- Arboles
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 17 
		                  and  rptarb_hojaid = cueg.cue_id
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
		                  and  tbl_id = 12 
		                  and  rptarb_hojaid = fc.mon_id
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_empresa = 0)
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
							 (@ram_id_circuitocontable = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 4001
		                  and  rptarb_hojaid = fc.doc_id
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
		                  and  tbl_id = 21 
		                  and  rptarb_hojaid = isnull(fci.ccos_id,fc.ccos_id)
									   ) 
		           )
		        or 
							 (@ram_id_centrocosto = 0)
					 )
		
		group by 
		
				case when @@bResumido = 0 then pr.pr_id else null end,
				cueg.cue_id,
				month(fc_fechaentrega) + year(fc_fechaentrega)*100

		order by 1, cueg.cue_id, month(fc_fechaentrega) + year(fc_fechaentrega)*100

	set @last_pr_id 	= 0
	set @last_cue_id	= 0
							
	open c_compras 

	fetch next from c_compras into @pr_id, @cue_id, @mes, @neto
	while @@fetch_status=0
	begin

		set @bNew = 0

		if isnull(@last_pr_id,0) <> isnull(@pr_id,0) and @@bResumido = 0 begin

				set @bNew=1

		end else begin

			if @last_cue_id <> @cue_id begin
				set @bNew=1
			end

		end

		if @bNew <> 0 begin

			set @row_id = @row_id +1

			insert into #t_dc_csc_con_0300_meses (row_id, pr_id, cue_id, tipo)
																		values (@row_id, @pr_id, @cue_id, @tipo_compras)

			set @last_pr_id 	= @pr_id
			set @last_cue_id  = @cue_id

		end

		update #t_dc_csc_con_0300_meses 

								set mes_01 = mes_01 + case when @mes - @mes_01 = 0  then @neto else 0 end,
								    mes_02 = mes_02 + case when @mes - @mes_01 = 1  then @neto else 0 end,
								    mes_03 = mes_03 + case when @mes - @mes_01 = 2  then @neto else 0 end,
								    mes_04 = mes_04 + case when @mes - @mes_01 = 3  then @neto else 0 end,
								    mes_05 = mes_05 + case when @mes - @mes_01 = 4  then @neto else 0 end,
								    mes_06 = mes_06 + case when @mes - @mes_01 = 5  then @neto else 0 end,
								    mes_07 = mes_07 + case when @mes - @mes_01 = 6  then @neto else 0 end,
								    mes_08 = mes_08 + case when @mes - @mes_01 = 7  then @neto else 0 end,
								    mes_09 = mes_09 + case when @mes - @mes_01 = 8  then @neto else 0 end,
								    mes_10 = mes_10 + case when @mes - @mes_01 = 9  then @neto else 0 end,
								    mes_11 = mes_11 + case when @mes - @mes_01 = 10 then @neto else 0 end,
								    mes_12 = mes_12 + case when @mes - @mes_01 = 11 then @neto else 0 end,
								    mes_13 = mes_13 + case when @mes - @mes_01 = 12 then @neto else 0 end,
								    mes_14 = mes_14 + case when @mes - @mes_01 = 13 then @neto else 0 end,
								    mes_15 = mes_15 + case when @mes - @mes_01 = 14 then @neto else 0 end,
								    mes_16 = mes_16 + case when @mes - @mes_01 = 15 then @neto else 0 end,
								    mes_17 = mes_17 + case when @mes - @mes_01 = 16 then @neto else 0 end,
								    mes_18 = mes_18 + case when @mes - @mes_01 = 17 then @neto else 0 end,
								    mes_19 = mes_19 + case when @mes - @mes_01 = 18 then @neto else 0 end,
								    mes_20 = mes_20 + case when @mes - @mes_01 = 19 then @neto else 0 end,
								    mes_21 = mes_21 + case when @mes - @mes_01 = 20 then @neto else 0 end,
								    mes_22 = mes_22 + case when @mes - @mes_01 = 21 then @neto else 0 end,
								    mes_23 = mes_23 + case when @mes - @mes_01 = 22 then @neto else 0 end,
								    mes_24 = mes_24 + case when @mes - @mes_01 = 23 then @neto else 0 end

		where row_id = @row_id

		fetch next from c_compras into @pr_id, @cue_id, @mes, @neto
	end

	close c_compras
	deallocate c_compras

--////////////////////////////////////////////////////////////////////////////////////////

	set @last_cue_id 	= 0

		declare c_asientos insensitive cursor for
		
		select  
						asi.cue_id,
						month(as_fecha) + year(as_fecha)*100,
						sum(asi_debe-asi_haber)
		
		from
						 asiento ast 			inner join documento	doc 				 on ast.doc_id  			 = doc.doc_id
														  inner join asientoitem asi	 			 on ast.as_id   			 = asi.as_id
		
		where 
						  as_fecha >= @@Fini
					and	as_fecha <= @@Ffin 

					and ast.id_cliente = 0
		
		-- Validar usuario - empresa
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (doc.emp_id  	= @emp_id 	or @emp_id	=0)
		and   (doc.cico_id 	= @cico_id  or @cico_id =0)
		and   (ast.doc_id 	= @doc_id 	or @doc_id	=0)
		and   (asi.ccos_id  = @ccos_id  or @ccos_id =0)
		
		-- Arboles
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 17 
		                  and  rptarb_hojaid = asi.cue_id
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_empresa = 0)
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
							 (@ram_id_circuitocontable = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 4001
		                  and  rptarb_hojaid = ast.doc_id
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
		                  and  tbl_id = 21 
		                  and  rptarb_hojaid = asi.ccos_id
									   ) 
		           )
		        or 
							 (@ram_id_centrocosto = 0)
					 )

		group by 
		
				asi.cue_id,
				month(as_fecha) + year(as_fecha)*100

		order by asi.cue_id, month(as_fecha) + year(as_fecha)*100

	set @last_cue_id	= 0
							
	open c_asientos 

	fetch next from c_asientos into @cue_id, @mes, @neto
	while @@fetch_status=0
	begin

		set @bNew = 0

		if @last_cue_id <> @cue_id begin
			set @bNew=1
		end

		if @bNew <> 0 begin

			set @row_id = @row_id +1

			insert into #t_dc_csc_con_0300_meses (row_id, pr_id, cue_id, tipo)
																		values (@row_id, null, @cue_id, @tipo_compras)

			set @last_cue_id  = @cue_id

		end

		update #t_dc_csc_con_0300_meses 

								set mes_01 = mes_01 + case when @mes - @mes_01 = 0  then @neto else 0 end,
								    mes_02 = mes_02 + case when @mes - @mes_01 = 1  then @neto else 0 end,
								    mes_03 = mes_03 + case when @mes - @mes_01 = 2  then @neto else 0 end,
								    mes_04 = mes_04 + case when @mes - @mes_01 = 3  then @neto else 0 end,
								    mes_05 = mes_05 + case when @mes - @mes_01 = 4  then @neto else 0 end,
								    mes_06 = mes_06 + case when @mes - @mes_01 = 5  then @neto else 0 end,
								    mes_07 = mes_07 + case when @mes - @mes_01 = 6  then @neto else 0 end,
								    mes_08 = mes_08 + case when @mes - @mes_01 = 7  then @neto else 0 end,
								    mes_09 = mes_09 + case when @mes - @mes_01 = 8  then @neto else 0 end,
								    mes_10 = mes_10 + case when @mes - @mes_01 = 9  then @neto else 0 end,
								    mes_11 = mes_11 + case when @mes - @mes_01 = 10 then @neto else 0 end,
								    mes_12 = mes_12 + case when @mes - @mes_01 = 11 then @neto else 0 end,
								    mes_13 = mes_13 + case when @mes - @mes_01 = 12 then @neto else 0 end,
								    mes_14 = mes_14 + case when @mes - @mes_01 = 13 then @neto else 0 end,
								    mes_15 = mes_15 + case when @mes - @mes_01 = 14 then @neto else 0 end,
								    mes_16 = mes_16 + case when @mes - @mes_01 = 15 then @neto else 0 end,
								    mes_17 = mes_17 + case when @mes - @mes_01 = 16 then @neto else 0 end,
								    mes_18 = mes_18 + case when @mes - @mes_01 = 17 then @neto else 0 end,
								    mes_19 = mes_19 + case when @mes - @mes_01 = 18 then @neto else 0 end,
								    mes_20 = mes_20 + case when @mes - @mes_01 = 19 then @neto else 0 end,
								    mes_21 = mes_21 + case when @mes - @mes_01 = 20 then @neto else 0 end,
								    mes_22 = mes_22 + case when @mes - @mes_01 = 21 then @neto else 0 end,
								    mes_23 = mes_23 + case when @mes - @mes_01 = 22 then @neto else 0 end,
								    mes_24 = mes_24 + case when @mes - @mes_01 = 23 then @neto else 0 end

		where row_id = @row_id

		fetch next from c_asientos into @cue_id, @mes, @neto
	end

	close c_asientos
	deallocate c_asientos

	update #t_dc_csc_con_0300_meses set

			total = mes_01+
							mes_02+
							mes_03+
							mes_04+
							mes_05+
							mes_06+
							mes_07+
							mes_08+
							mes_09+
							mes_10+
							mes_11+
							mes_12+
							mes_13+
							mes_14+
							mes_15+
							mes_16+
							mes_17+
							mes_18+
							mes_19+
							mes_20+
							mes_21+
							mes_22+
							mes_23+
							mes_24

		-----------------------------------------------------------------------

	declare @mes_total_compras 	decimal(18,6)
	declare @mes_total_ventas  	decimal(18,6)
	declare @mes_total  				decimal(18,6)
	declare @mes_acumulado      decimal(18,6)

	set @row_id = @row_id +1

	declare @row_id_total 					int	
	declare @row_id_total_compras		int
	declare @row_id_acumulado       int

	set @row_id_total 				= @row_id
	set @row_id_total_compras = @row_id +1
	set @row_id_acumulado 		= @row_id +2

	insert into #t_dc_csc_con_0300_meses (row_id, pr_id, cue_id, tipo)
																values (@row_id_total, null, 0, @tipo_total)

	insert into #t_dc_csc_con_0300_meses (row_id, pr_id, cue_id, tipo)
																values (@row_id_total_compras, null, 0, @tipo_total_compras)

	insert into #t_dc_csc_con_0300_meses (row_id, pr_id, cue_id, tipo)
																values (@row_id_acumulado, null, 0, @tipo_acumulado)

	set @n             = 1
	set @mes_acumulado = 0

	while @n < 24
	begin

		set @mes_total_compras = 0
		set @mes_total_ventas = 0

		select @mes_total_compras =  case when @n = 1  then 	sum(mes_01)
																			when @n = 2  then 	sum(mes_02)
																			when @n = 3  then 	sum(mes_03)
																			when @n = 4  then 	sum(mes_04)
																			when @n = 5  then 	sum(mes_05)
																			when @n = 6  then 	sum(mes_06)
																			when @n = 7  then 	sum(mes_07)
																			when @n = 8  then 	sum(mes_08)
																			when @n = 9  then 	sum(mes_09)
																			when @n = 10 then 	sum(mes_10)
																			when @n = 11 then 	sum(mes_11)
																			when @n = 12 then 	sum(mes_12)
																			when @n = 13 then 	sum(mes_13)
																			when @n = 14 then 	sum(mes_14)
																			when @n = 15 then 	sum(mes_15)
																			when @n = 16 then 	sum(mes_16)
																			when @n = 17 then 	sum(mes_17)
																			when @n = 18 then 	sum(mes_18)
																			when @n = 19 then 	sum(mes_19)
																			when @n = 20 then 	sum(mes_20)
																			when @n = 21 then 	sum(mes_21)
																			when @n = 22 then 	sum(mes_22)
																			when @n = 23 then 	sum(mes_23)
																			when @n = 24 then 	sum(mes_24)
																 end
		from #t_dc_csc_con_0300_meses
		where tipo = 2

		select @mes_total_ventas =  case  when @n = 1  then 	sum(mes_01)
																			when @n = 2  then 	sum(mes_02)
																			when @n = 3  then 	sum(mes_03)
																			when @n = 4  then 	sum(mes_04)
																			when @n = 5  then 	sum(mes_05)
																			when @n = 6  then 	sum(mes_06)
																			when @n = 7  then 	sum(mes_07)
																			when @n = 8  then 	sum(mes_08)
																			when @n = 9  then 	sum(mes_09)
																			when @n = 10 then 	sum(mes_10)
																			when @n = 11 then 	sum(mes_11)
																			when @n = 12 then 	sum(mes_12)
																			when @n = 13 then 	sum(mes_13)
																			when @n = 14 then 	sum(mes_14)
																			when @n = 15 then 	sum(mes_15)
																			when @n = 16 then 	sum(mes_16)
																			when @n = 17 then 	sum(mes_17)
																			when @n = 18 then 	sum(mes_18)
																			when @n = 19 then 	sum(mes_19)
																			when @n = 20 then 	sum(mes_20)
																			when @n = 21 then 	sum(mes_21)
																			when @n = 22 then 	sum(mes_22)
																			when @n = 23 then 	sum(mes_23)
																			when @n = 24 then 	sum(mes_24)
												 				end
		from #t_dc_csc_con_0300_meses
		where tipo = 1

		set @mes_total_compras = isnull(@mes_total_compras,0)
		set @mes_total_ventas  = isnull(@mes_total_ventas,0)

		set @mes_total 			= @mes_total_ventas - @mes_total_compras
		set @mes_acumulado 	= @mes_acumulado + @mes_total

		-- Total (ventas - compras)
		--
		update #t_dc_csc_con_0300_meses

								set mes_01 = mes_01 + case when @n = 1  then @mes_total else 0 end,
								    mes_02 = mes_02 + case when @n = 2  then @mes_total else 0 end,
								    mes_03 = mes_03 + case when @n = 3  then @mes_total else 0 end,
								    mes_04 = mes_04 + case when @n = 4  then @mes_total else 0 end,
								    mes_05 = mes_05 + case when @n = 5  then @mes_total else 0 end,
								    mes_06 = mes_06 + case when @n = 6  then @mes_total else 0 end,
								    mes_07 = mes_07 + case when @n = 7  then @mes_total else 0 end,
								    mes_08 = mes_08 + case when @n = 8  then @mes_total else 0 end,
								    mes_09 = mes_09 + case when @n = 9  then @mes_total else 0 end,
								    mes_10 = mes_10 + case when @n = 10 then @mes_total else 0 end,
								    mes_11 = mes_11 + case when @n = 11 then @mes_total else 0 end,
								    mes_12 = mes_12 + case when @n = 12 then @mes_total else 0 end,
								    mes_13 = mes_13 + case when @n = 13 then @mes_total else 0 end,
								    mes_14 = mes_14 + case when @n = 14 then @mes_total else 0 end,
								    mes_15 = mes_15 + case when @n = 15 then @mes_total else 0 end,
								    mes_16 = mes_16 + case when @n = 16 then @mes_total else 0 end,
								    mes_17 = mes_17 + case when @n = 17 then @mes_total else 0 end,
								    mes_18 = mes_18 + case when @n = 18 then @mes_total else 0 end,
								    mes_19 = mes_19 + case when @n = 19 then @mes_total else 0 end,
								    mes_20 = mes_20 + case when @n = 20 then @mes_total else 0 end,
								    mes_21 = mes_21 + case when @n = 21 then @mes_total else 0 end,
								    mes_22 = mes_22 + case when @n = 22 then @mes_total else 0 end,
								    mes_23 = mes_23 + case when @n = 23 then @mes_total else 0 end,
								    mes_24 = mes_24 + case when @n = 24 then @mes_total else 0 end

		where row_id = @row_id_total

		-- Total compras
		--
		update #t_dc_csc_con_0300_meses

								set mes_01 = mes_01 + case when @n = 1  then @mes_total_compras else 0 end,
								    mes_02 = mes_02 + case when @n = 2  then @mes_total_compras else 0 end,
								    mes_03 = mes_03 + case when @n = 3  then @mes_total_compras else 0 end,
								    mes_04 = mes_04 + case when @n = 4  then @mes_total_compras else 0 end,
								    mes_05 = mes_05 + case when @n = 5  then @mes_total_compras else 0 end,
								    mes_06 = mes_06 + case when @n = 6  then @mes_total_compras else 0 end,
								    mes_07 = mes_07 + case when @n = 7  then @mes_total_compras else 0 end,
								    mes_08 = mes_08 + case when @n = 8  then @mes_total_compras else 0 end,
								    mes_09 = mes_09 + case when @n = 9  then @mes_total_compras else 0 end,
								    mes_10 = mes_10 + case when @n = 10 then @mes_total_compras else 0 end,
								    mes_11 = mes_11 + case when @n = 11 then @mes_total_compras else 0 end,
								    mes_12 = mes_12 + case when @n = 12 then @mes_total_compras else 0 end,
								    mes_13 = mes_13 + case when @n = 13 then @mes_total_compras else 0 end,
								    mes_14 = mes_14 + case when @n = 14 then @mes_total_compras else 0 end,
								    mes_15 = mes_15 + case when @n = 15 then @mes_total_compras else 0 end,
								    mes_16 = mes_16 + case when @n = 16 then @mes_total_compras else 0 end,
								    mes_17 = mes_17 + case when @n = 17 then @mes_total_compras else 0 end,
								    mes_18 = mes_18 + case when @n = 18 then @mes_total_compras else 0 end,
								    mes_19 = mes_19 + case when @n = 19 then @mes_total_compras else 0 end,
								    mes_20 = mes_20 + case when @n = 20 then @mes_total_compras else 0 end,
								    mes_21 = mes_21 + case when @n = 21 then @mes_total_compras else 0 end,
								    mes_22 = mes_22 + case when @n = 22 then @mes_total_compras else 0 end,
								    mes_23 = mes_23 + case when @n = 23 then @mes_total_compras else 0 end,
								    mes_24 = mes_24 + case when @n = 24 then @mes_total_compras else 0 end

		where row_id = @row_id_total_compras

		-- Acumulado
		--
		update #t_dc_csc_con_0300_meses

								set mes_01 = mes_01 + case when @n = 1  then @mes_acumulado else 0 end,
								    mes_02 = mes_02 + case when @n = 2  then @mes_acumulado else 0 end,
								    mes_03 = mes_03 + case when @n = 3  then @mes_acumulado else 0 end,
								    mes_04 = mes_04 + case when @n = 4  then @mes_acumulado else 0 end,
								    mes_05 = mes_05 + case when @n = 5  then @mes_acumulado else 0 end,
								    mes_06 = mes_06 + case when @n = 6  then @mes_acumulado else 0 end,
								    mes_07 = mes_07 + case when @n = 7  then @mes_acumulado else 0 end,
								    mes_08 = mes_08 + case when @n = 8  then @mes_acumulado else 0 end,
								    mes_09 = mes_09 + case when @n = 9  then @mes_acumulado else 0 end,
								    mes_10 = mes_10 + case when @n = 10 then @mes_acumulado else 0 end,
								    mes_11 = mes_11 + case when @n = 11 then @mes_acumulado else 0 end,
								    mes_12 = mes_12 + case when @n = 12 then @mes_acumulado else 0 end,
								    mes_13 = mes_13 + case when @n = 13 then @mes_acumulado else 0 end,
								    mes_14 = mes_14 + case when @n = 14 then @mes_acumulado else 0 end,
								    mes_15 = mes_15 + case when @n = 15 then @mes_acumulado else 0 end,
								    mes_16 = mes_16 + case when @n = 16 then @mes_acumulado else 0 end,
								    mes_17 = mes_17 + case when @n = 17 then @mes_acumulado else 0 end,
								    mes_18 = mes_18 + case when @n = 18 then @mes_acumulado else 0 end,
								    mes_19 = mes_19 + case when @n = 19 then @mes_acumulado else 0 end,
								    mes_20 = mes_20 + case when @n = 20 then @mes_acumulado else 0 end,
								    mes_21 = mes_21 + case when @n = 21 then @mes_acumulado else 0 end,
								    mes_22 = mes_22 + case when @n = 22 then @mes_acumulado else 0 end,
								    mes_23 = mes_23 + case when @n = 23 then @mes_acumulado else 0 end,
								    mes_24 = mes_24 + case when @n = 24 then @mes_acumulado else 0 end

		where row_id = @row_id_acumulado

		set @n = @n +1
	end

	update #t_dc_csc_con_0300_meses set

			total = mes_01+
							mes_02+
							mes_03+
							mes_04+
							mes_05+
							mes_06+
							mes_07+
							mes_08+
							mes_09+
							mes_10+
							mes_11+
							mes_12+
							mes_13+
							mes_14+
							mes_15+
							mes_16+
							mes_17+
							mes_18+
							mes_19+
							mes_20+
							mes_21+
							mes_22+
							mes_23+
							mes_24
	where row_id in(@row_id_total, @row_id_total_compras)

	update #t_dc_csc_con_0300_meses

		set total = (select total from #t_dc_csc_con_0300_meses where row_id = @row_id_total)

	where row_id = @row_id_acumulado

/*- ///////////////////////////////////////////////////////////////////////

FIN SALDOS POR MESES

/////////////////////////////////////////////////////////////////////// */


/*- ///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */


	if @@bResumido = 0 begin

			select 
		
						@arb_nombre     as Nivel_1,
		
						lower(nodo_2.ram_nombre)		as Nivel_2,
						lower(nodo_3.ram_nombre)		as Nivel_3,
						lower(nodo_4.ram_nombre)		as Nivel_4,
						lower(nodo_5.ram_nombre)		as Nivel_5,
						lower(nodo_6.ram_nombre)		as Nivel_6,
						lower(nodo_7.ram_nombre)		as Nivel_7,
						lower(nodo_8.ram_nombre)		as Nivel_8,
						lower(nodo_9.ram_nombre)		as Nivel_9,
		
						convert(varchar,nodo_2.ram_orden)+'@'+ nodo_2.ram_nombre		as Nivelg_2,
						convert(varchar,nodo_3.ram_orden)+'@'+ nodo_3.ram_nombre		as Nivelg_3,
						convert(varchar,nodo_4.ram_orden)+'@'+ nodo_4.ram_nombre		as Nivelg_4,
						convert(varchar,nodo_5.ram_orden)+'@'+ nodo_5.ram_nombre		as Nivelg_5,
						convert(varchar,nodo_6.ram_orden)+'@'+ nodo_6.ram_nombre		as Nivelg_6,
						convert(varchar,nodo_7.ram_orden)+'@'+ nodo_7.ram_nombre		as Nivelg_7,
						convert(varchar,nodo_8.ram_orden)+'@'+ nodo_8.ram_nombre		as Nivelg_8,
						convert(varchar,nodo_9.ram_orden)+'@'+ nodo_9.ram_nombre		as Nivelg_9,
		
						lower(cue_nombre) 		as cue_nombre,
		
		
						lower(pr_nombreventa) as pr_nombreventa,
		
						case when @@bResumido = 0 then lower(isnull(pr_nombrecompra,cue_nombre)) 
								 else                      lower(cue_nombre)
						end 									as pr_nombrecompra,
						
						t.*				
		
			from #t_dc_csc_con_0300_meses t
		
														left  join cuenta cue 	on t.cue_id = cue.cue_id
														left  join producto pr 	on t.pr_id  = pr.pr_id
		
														 left  join hoja h    on     cue.cue_id = h.id 
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
		
														 left  join #DC_CSC_CON_0300_cuentas nodo on h.ram_id = nodo.nodo_id
		
		                         left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
		                         left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
		                         left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
		                         left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
		                         left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
		                         left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
		                         left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
		                         left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id
		
			where total <> 0 or t.tipo in (@tipo_total,@tipo_total_compras,@tipo_acumulado)
		
			order by 
								t.tipo,
								Nivel_1, 
								Nivelg_2, 
								Nivelg_3, 
								Nivelg_4, 
								Nivelg_5, 
								Nivelg_6, 
								Nivelg_7, 
								Nivelg_8, 
								Nivelg_9, 
								cue_nombre, 
								pr_nombreventa

	end else begin

			select 
		
						case when tipo = 1 then 'facturación y varios'
								 else                lower(nodo.ram_nombre)
						end 				as Nivel_1,
		
						''		as Nivel_2,
						''		as Nivel_3,
						''		as Nivel_4,
						''		as Nivel_5,
						''		as Nivel_6,
						''		as Nivel_7,
						''		as Nivel_8,
						''		as Nivel_9,
		
						100		as Nivelg_2,
						100   as Nivelg_3,
						100   as Nivelg_4,
						100   as Nivelg_5,
						100   as Nivelg_6,
						100   as Nivelg_7,
						100   as Nivelg_8,
						100   as Nivelg_9,
		
						lower(cue_nombre) 		as cue_nombre,
		
		
						lower(pr_nombreventa) as pr_nombreventa,
		
						case when @@bResumido = 0 then lower(isnull(pr_nombrecompra,cue_nombre)) 
								 else                      lower(cue_nombre)
						end 									as pr_nombrecompra,
						
						t.*				
		
			from #t_dc_csc_con_0300_meses t
		
														left  join cuenta cue 	on t.cue_id = cue.cue_id
														left  join producto pr 	on t.pr_id  = pr.pr_id
		
														 left  join hoja h    on     cue.cue_id = h.id 
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
		
														 left  join rama nodo on h.ram_id = nodo.ram_id
		
		
			where total <> 0 or t.tipo in (@tipo_total,@tipo_total_compras,@tipo_acumulado)
		
			order by 
								t.tipo,
								Nivel_1, 
								cue_nombre, 
								pr_nombreventa

	end

--	select * from #t_dc_csc_con_0300_meses

end

go

