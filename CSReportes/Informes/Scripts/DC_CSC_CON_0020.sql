
/*---------------------------------------------------------------------
Nombre: Libro I.V.A. ventas
---------------------------------------------------------------------*/
/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0020]

/*


select *from empresa
select * from circuitocontable

DC_CSC_CON_0020 1,'20070301','20070331','1','1',1

update facturaventa set fv_fecha = '20070101' where fv_id = 61

*/
go
create procedure DC_CSC_CON_0020 (

  @@us_id    	int,
	@@Fini 		 	datetime,
	@@Ffin 		 	datetime,
	@@cico_id 	varchar(255), 
  @@emp_id    varchar(255),
	@@verificar smallint

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cico_id int
declare @emp_id   int 

declare @ram_id_CircuitoContable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_CircuitoContable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_CircuitoContable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CircuitoContable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CircuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CircuitoContable, @clienteID 
	end else 
		set @ram_id_CircuitoContable = 0
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



/*- ///////////////////////////////////////////////////////////////////////

VALIDACIONES DE SECUENCIA

/////////////////////////////////////////////////////////////////////// */


/*
			- Las facturas tiene una letra en el primer caracter
				y la sucursal entre el 3 y el 6 caracter

			- Dada la factura x1 no debe existir una factura xn
        con igual letra que tenga fecha > y numero menor

*/
if @@verificar <> 0 begin

			create table #t_DC_CSC_CON_0020_check ( emp_id		int, 
																							doct_id   int,
																							fv_id 		int, 
																							fv_fecha 	datetime, 
																							letra 		varchar(1), 
																							sucursal 	varchar(4), 
																							nrodoc 		varchar(255)
																						)

			insert into #t_DC_CSC_CON_0020_check (emp_id, doct_id, fv_id, fv_fecha, letra, sucursal, nrodoc)
			select 
						fv.emp_id,
						fv.doct_id,
						fv_id, 
						fv_fecha, 
						substring(fv_nrodoc,1,1),
						substring(fv_nrodoc,3,4),
						substring(fv_nrodoc,9,255)

			from FacturaVenta fv inner join Documento d on fv.doc_id = d.doc_id
			where 
							  fv_fechaiva >= @@Fini
						and	fv_fechaiva <= @@Ffin 
						and (
									exists(select * from EmpresaUsuario where emp_id = fv.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)			
			-- Arboles
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (fv.emp_id = @emp_id  or @emp_id=0) 
			and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = d.cico_id)) or (@ram_id_CircuitoContable = 0))
			and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = fv.emp_id)) or (@ram_id_Empresa = 0))			

				create table #t_DC_CSC_CON_0020_mal ( fv_id 			int not null, 
																						  fv_id_next 	int null, 
																							descrip 		varchar(255) collate SQL_Latin1_General_CP1_CI_AI null
																						)

			if exists(select * from #t_DC_CSC_CON_0020_check t1, #t_DC_CSC_CON_0020_check t2
								where t1.emp_id 	= t2.emp_id
									and t1.letra 		= t2.letra
									and t1.sucursal = t2.sucursal
									and t1.doct_id  = t2.doct_id
									and t1.fv_fecha < t2.fv_fecha
									and t1.nrodoc 	> t2.nrodoc									
								)
			begin

				declare c_mal insensitive cursor for 
								select distinct t1.emp_id, 
																t1.fv_id, 
																t1.fv_fecha, 
																t1.letra, 
																t1.sucursal, 
																t1.nrodoc,
																t1.doct_id

								from #t_DC_CSC_CON_0020_check t1, #t_DC_CSC_CON_0020_check t2
								where t1.emp_id 	= t2.emp_id
									and t1.letra 		= t2.letra
									and t1.sucursal = t2.sucursal
									and t1.doct_id  = t2.doct_id
									and t1.fv_fecha < t2.fv_fecha
									and t1.nrodoc 	> t2.nrodoc									

				open c_mal

				declare @emp_id_check		int
				declare @fv_id 					int
				declare @fv_fecha 			datetime
				declare @letra 					varchar(1)
				declare @sucursal 			varchar(4)
				declare @nrodoc   			varchar(255)
				declare @numero   			int

				declare @n int

				declare @fv_id_next     int
				declare @fv_nrodoc_next varchar(255)
				declare @nrodoc_next    varchar(255)
				declare @numero_next 		int
				declare @doct_id        int

				fetch next from c_mal into @emp_id_check, @fv_id, @fv_fecha, @letra, @sucursal, @nrodoc, @doct_id
				while @@fetch_status = 0
				begin

					if isnumeric(@nrodoc) = 0 begin

						insert into #t_DC_CSC_CON_0020_mal(fv_id) values(@fv_id)

					end else begin

						set @numero = convert(int,@nrodoc)

						set @n = 1
						while @n < 3 begin

							set @fv_nrodoc_next = null
	
							-- Proxima factura
							--		
							select @fv_nrodoc_next = min(fv_nrodoc)
							from facturaventa 
							where emp_id = @emp_id_check
								and substring(fv_nrodoc,1,1) = @letra
								and substring(fv_nrodoc,3,4) = @sucursal
								and fv_fecha > @fv_fecha
								and fv_fechaiva >= @@Fini
								and	fv_fechaiva <= @@Ffin 
								and doct_id = @doct_id

							-- Si existe una factura
							--		
							if isnull(@fv_nrodoc_next,'') <> '' begin

								select @fv_id_next = fv_id,
											 @nrodoc_next = substring(fv_nrodoc,9,255)
			
								from facturaventa
								where emp_id 		= @emp_id_check			
									and fv_nrodoc	= @fv_nrodoc_next
									and fv_fechaiva >= @@Fini
									and	fv_fechaiva <= @@Ffin 
									and doct_id = @doct_id
		
								-- Si la proxima es valida
								--		
								if isnumeric(@nrodoc_next) <> 0 begin
		
									set @numero_next = convert(int,@nrodoc_next)
		
									if @numero_next < @numero begin
	
										set @n = 3

										insert into #t_DC_CSC_CON_0020_mal (fv_id,fv_id_next) values(@fv_id,@fv_id_next)
	
									end
		
								end
							end
							set @n = @n + 1
						end
					end

					fetch next from c_mal into @emp_id_check, @fv_id, @fv_fecha, @letra, @sucursal, @nrodoc, @doct_id
				end

				close c_mal
				deallocate c_mal

				select 
							 '@@ERROR_SP_RS:Existen facturas que estan fuera de secuencia'
														as error_in_sp_id,
							 fv.fv_id 		as comp_id,
							 fv.doct_id		as doct_id,

							 fv.fv_fecha							as Fecha,
							 fv.fv_nrodoc 						as Comprobante,
							 fv.fv_numero 						as Numero,
							 'Esta en conflicto con ' as Info,
							 fv2.fv_fecha							as Fecha,
							 fv2.fv_nrodoc 						as Comprobante,
							 fv2.fv_numero 						as Numero

				from #t_DC_CSC_CON_0020_mal t inner join FacturaVenta fv 	on t.fv_id 			= fv.fv_id
																			left  join FacturaVenta fv2 on t.fv_id_next = fv2.fv_id
				order by 	
						substring(fv.fv_nrodoc,1,1),
						substring(fv.fv_nrodoc,3,4),
						fv.fv_fecha,
						substring(fv.fv_nrodoc,9,255)

				return

			end

				--// Ahora vamos a revisar que no existan huecos en los numeros de comprobante
				--

				declare @last_letra 		varchar(255) set @last_letra = ''
				declare @last_sucursal 	varchar(255) set @last_sucursal = ''
				declare @last_nrodoc 		varchar(255) set @last_nrodoc = ''
				declare @last_fv_id			int
				declare @last_doct_id		int

				declare c_facturas insensitive cursor for

					select fv_id,
								 doct_id,
								 letra,
								 sucursal,
								 nrodoc

					from #t_DC_CSC_CON_0020_check
					order by	 doct_id, 
										 letra,
										 sucursal,
										 nrodoc

				open c_facturas

				fetch next from c_facturas into @fv_id, @doct_id, @letra, @sucursal, @nrodoc
				while @@fetch_status=0
				begin

					if @last_doct_id <> @doct_id begin
						set @last_letra = ''
					end

					if @letra <> @last_letra begin
						set @last_nrodoc    = ''
						set @last_sucursal  = ''
					end

					if @sucursal <> @last_sucursal and @last_sucursal <> '' begin
						set @last_nrodoc = ''
					end

					if isnumeric(@nrodoc)=0 begin

						insert into #t_DC_CSC_CON_0020_mal (fv_id,descrip) 
							values(@fv_id,'El número de comprobante es invalido')

					end else begin

						if @last_nrodoc <> '' begin
							if isnumeric(@last_nrodoc) <> 0 begin
	
								if convert(int,@nrodoc) <> convert(int,@last_nrodoc)+1 begin
	
									insert into #t_DC_CSC_CON_0020_mal (fv_id,descrip,fv_id_next) 
										values(@fv_id
														, 'El comprobante anterior a esta factura es [&1]. Faltan números entre los comprobantes.'
													  ,@last_fv_id
													)								
	
								end
	
							end
						end
					end

					set @last_letra 		= @letra
					set @last_sucursal 	= @sucursal
					set @last_nrodoc 		= @nrodoc
					set @last_fv_id     = @fv_id

					fetch next from c_facturas into @fv_id, @doct_id, @letra, @sucursal, @nrodoc
				end

				close c_facturas
				deallocate c_facturas
				
				if exists(select * from #t_DC_CSC_CON_0020_mal)
				begin
			
					select 
								 '@@ERROR_SP_RS:Existen facturas que estan fuera de secuencia'
															as error_in_sp_id,
								 fv.fv_id 		as comp_id,
								 fv.doct_id		as doct_id,
	
								 fv.fv_fecha							as Fecha,
								 fv.fv_nrodoc 						as Comprobante,
								 fv.fv_numero 						as Numero,
								 replace(descrip,
												 '&1',
												 isnull(
																	fv2.fv_nrodoc 
																	+ ' (numero interno: '
																	+ convert(varchar,fv2.fv_numero)
																	+')'
																,'')
												)									as Info
	
					from #t_DC_CSC_CON_0020_mal t inner join FacturaVenta fv 	on t.fv_id 			= fv.fv_id
																				left  join FacturaVenta fv2 on t.fv_id_next = fv2.fv_id
					order by 	
							substring(fv.fv_nrodoc,1,1),
							substring(fv.fv_nrodoc,3,4),
							fv.fv_fecha,
							substring(fv.fv_nrodoc,9,255)

					return

				end

end

/*- ///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

			create table #t_DC_CSC_CON_0020_fv (fv_id int not null)
			insert into #t_DC_CSC_CON_0020_fv 
			select fv_id from FacturaVenta where fv_fechaiva between @@Fini and @@Ffin

			--------------------------------------------------------------------------------------------------
			-- TRATAMIENTO DE PERIODOS SIN MOVIMIENTOS
			--------------------------------------------------------------------------------------------------
	
			create table #t_DC_CSC_CON_0020 (col_dummy tinyint)
	
			if not exists(select fv.fv_id
	
										from FacturaVenta fv inner join Documento d 
														on fv.doc_id = d.doc_id
													 and fv_fechaiva >= @@Fini
													 and fv_fechaiva <= @@Ffin 
										where 											
													 	 (
																exists(select * 
																			 from EmpresaUsuario 
																			 where emp_id = d.emp_id 
																				 and us_id = @@us_id) 
																or (@@us_id = 1)
															)
										
										/* -///////////////////////////////////////////////////////////////////////
										
										INICIO SEGUNDA PARTE DE ARBOLES
										
										/////////////////////////////////////////////////////////////////////// */
										
										and   (d.cico_id = @cico_id or @cico_id=0)
										and   (d.emp_id  = @emp_id  or @emp_id=0) 
										
										-- Arboles
										and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and  rptarb_hojaid = d.cico_id)) or (@ram_id_CircuitoContable = 0))
										and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = d.emp_id))  or (@ram_id_Empresa = 0))
								)
			begin
	
				insert into #t_DC_CSC_CON_0020 (col_dummy) values(1)
	
			end
	
	
			select 
						0																	as comp_id,
						@@Fini       											as Fecha,
						''         											  as Documento,
			      ''                                as Empresa, 
						''																as Letra,
						''    											  		as Comprobante,
						'Mes sin movimientos'			  			as Cliente,
						''													  		as CUIT,
						''                                as [Tipo de Documento],
						''																as [Condicion IVA],
			
						''																as [Condicion IVA2],
			
						0			             			  							as Neto,		
						0                                       as Base,		
						0                                       as [Base Iva],		
						0			  																as [Tasa Iva],		
						0             	  											as [Importe Iva],
						0			  																as [Importe interno],
						''        															as Concepto,		
						0                          			  			as [Importe concepto],		
						0             	  											as Total,
						0                                       as Orden, 	-- Separa Comprobantes de Totales, y tipos de totales
			      1                                       as Orden2, 	-- Separa tipos de renglon
						0																				as Orden3 	-- Separa Comprobantes de totales 
																																-- (es decir todos los totales tienen el mismo valor (1))
	
			from #t_DC_CSC_CON_0020
	
			union all
	

			--------------------------------------------------------------------------------------------------
			-- FACTURAS DEL PERIODO
			--------------------------------------------------------------------------------------------------

			select 
						fv.fv_id																  as comp_id,
						fv_fecha            											as Fecha,
			      case d.doct_id
			        when 1  then 'FAC'
			        when 7  then 'NC'
			        when 9  then 'ND'
			      end               											  as Documento,
			      emp_nombre                                as Empresa, 
						substring(fv_nrodoc,1,1)                  as Letra,
						fv_nrodoc      											  		as Comprobante,
						cli_razonsocial  											  	as Cliente,
						cli_cuit													  			as CUIT,
						''                                        as [Tipo de Documento],
						case cli_catfiscal
							when 1  then 'Inscripto'
							when 2  then 'Exento'
							when 3  then 'No inscripto'
							when 4  then 'Consumidor Final'
							when 5  then 'Extranjero'
							when 6  then 'Mono Tributo'
							when 7  then 'Extranjero Iva'
							when 8  then 'No responsable'
							when 9  then 'No Responsable exento'
							when 10 then 'No categorizado'
							when 11 then 'Inscripto M'
				      else 				 'Sin categorizar'
						end																				as [Condicion IVA],
			
						case cli_catfiscal
							when 1  then 'IN'
							when 2  then 'EX'
							when 3  then 'NI'
							when 4  then 'CF'
							when 5  then 'EJ'
							when 6  then 'M'
							when 7  then 'EJI'
							when 8  then 'NR'
							when 9  then 'NRE'
							when 10 then 'NC'
							when 11 then 'IM'
				      else 				 'SC'
						end																				as [Condicion IVA2],
			
						case d.doct_id
			        when 7  then -fv_neto
			        else          fv_neto
			      end			             			  							as Neto,
			
						case fvi_ivariporc 
								when 0 then									0
								else
														case d.doct_id
											        when 7  then -sum(fvi_neto
																									- (fvi_neto * fv_descuento1 / 100)
																									- (
																											(
																												fvi_neto - (fvi_neto * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																								)
											        else         sum(fvi_neto
																									- (fvi_neto * fv_descuento1 / 100)
																									- (
																											(
																												fvi_neto - (fvi_neto * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																							)
														end
			      end                                       as Base,
			
						case fvi_ivariporc 
								when 0 then									0
								else
														case d.doct_id
											        when 7  then -sum(fvi_neto
																									- (fvi_neto * fv_descuento1 / 100)
																									- (
																											(
																												fvi_neto - (fvi_neto * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																								)
											        else         sum(fvi_neto
																									- (fvi_neto * fv_descuento1 / 100)
																									- (
																											(
																												fvi_neto - (fvi_neto * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																							)
														end
			      end                                       as [Base Iva],
			
						fvi_ivariporc			  											as [Tasa Iva],
			
						case fvi_ivariporc 
								when 0 then									0
								else
														case d.doct_id
											        when 7  then -sum(fvi_ivari
																									- (fvi_ivari * fv_descuento1 / 100)
																									- (
																											(
																												fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																								)
											        else         sum(fvi_ivari
																									- (fvi_ivari * fv_descuento1 / 100)
																									- (
																											(
																												fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																							)
														end
			      end             	  											as [Importe Iva],
						0			  																	as [Importe interno],
						''        																as Concepto,
						case fvi_ivariporc 
								when 0 then		
														case d.doct_id
											        when 7  then -sum(fvi_neto	
																									- (fvi_neto * fv_descuento1 / 100)
																									- (
																											(
																												fvi_neto - (fvi_neto * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																								)
											        else          sum(fvi_neto
																									- (fvi_neto * fv_descuento1 / 100)
																									- (
																											(
																												fvi_neto - (fvi_neto * fv_descuento1 / 100)
																											) * fv_descuento2 / 100
																										)
																								)
											      end
								else												0
						end                          			  			as [Importe concepto],
			
						case d.doct_id
			        when 7  then -fv_total
			        else          fv_total
			      end             	  											as Total,
						0                                         as Orden, 	-- Separa Comprobantes de Totales, y tipos de totales
			      1                                         as Orden2,	-- Separa tipos de renglon
						0																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  on fv.fv_id = t.fv_id)
																inner join Documento d 							on fv.doc_id  = d.doc_id
			                          inner join Empresa                  on d.emp_id   = Empresa.emp_id 
															  inner join Cliente c                on fv.cli_id  = c.cli_id
															  inner join FacturaVentaItem fvi     on fv.fv_id   = fvi.fv_id
			where 						
			      		fv.est_id <> 7 -- Anuladas			
			
						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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
			
			group by
			
						fv.fv_id,
						fv_fecha,
						doc_codigo,
						d.doct_id,
			      emp_nombre,
						fv_nrodoc,
						cli_razonsocial,
						cli_cuit,
						cli_catfiscal,
						fvi_ivariporc,
			      fv_neto,
			      fv_total
			
			union all

			--------------------------------------------------------------------------------------------------
			-- PERCEPCIONES
			--------------------------------------------------------------------------------------------------
			
			select 
						fv.fv_id																	as comp_id,
						fv_fecha            											as Fecha,
						case d.doct_id
			        when 1  then 'FAC'
			        when 7  then 'NC'
			        when 9 then 'ND'
			      end                											  as Documento,
			      emp_nombre                                as Empresa, 
						substring(fv_nrodoc,1,1)                  as Letra,
						fv_nrodoc      											  		as Comprobante,
						cli_razonsocial   											  as Cliente,
						cli_cuit													  			as CUIT,
						''                                        as [Tipo de Documento],
						case cli_catfiscal
							when 1  then 'Inscripto'
							when 2  then 'Exento'
							when 3  then 'No inscripto'
							when 4  then 'Consumidor Final'
							when 5  then 'Extranjero'
							when 6  then 'Mono Tributo'
							when 7  then 'Extranjero Iva'
							when 8  then 'No responsable'
							when 9  then 'No Responsable exento'
							when 10 then 'No categorizado'
							when 11 then 'Inscripto M'
				      else 				 'Sin categorizar'
						end																				as [Condicion IVA],
			
						case cli_catfiscal
							when 1  then 'IN'
							when 2  then 'EX'
							when 3  then 'NI'
							when 4  then 'CF'
							when 5  then 'EJ'
							when 6  then 'M'
							when 7  then 'EJI'
							when 8  then 'NR'
							when 9  then 'NRE'
							when 10 then 'NC'
							when 11 then 'IM'
				      else 				 'SC'
						end																				as [Condicion IVA2],
			
						0           			  											as Neto,
						case d.doct_id
			        when 7  then -fvperc_base
			        else          fvperc_base
			      end                                       as [Base],
			      0                                         as [Base Iva],
						fvperc_porcentaje  	  									  as [Tasa Iva],
						0				      		    										as [Importe Iva],
						case d.doct_id
			        when 7  then -fvperc_importe
			        else          fvperc_importe
			      end			  																as [Importe interno],
						perc_nombre 															as Concepto,
						0                           			  			as [Importe concepto],
						0                           			  			as Total,
						0                                         as Orden,
			      2                                         as Orden2,
						0																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  		on fv.fv_id 		 = t.fv_id) 
																inner join Documento d 							    on fv.doc_id     = d.doc_id
			                          inner join Empresa                      on d.emp_id      = empresa.emp_id 
															  inner join Cliente p                  	on fv.cli_id     = p.cli_id
			                          inner join FacturaVentaPercepcion fvp  	on fv.fv_id      = fvp.fv_id
			                          inner join Percepcion perc              on fvp.perc_id   = perc.perc_id
			
			where 
			      fv.est_id <> 7 -- Anuladas

						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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

			union all			

			--------------------------------------------------------------------------------------------------
			-- ANULADAS
			--------------------------------------------------------------------------------------------------
			
			select 
						fv.fv_id																	as comp_id,
						fv_fecha            											as Fecha,
			      case d.doct_id
			        when 1  then 'FAC'
			        when 7  then 'NC'
			        when 9  then 'ND'
			      end               											  as Documento,
			      emp_nombre                                as Empresa, 
						substring(fv_nrodoc,1,1)                  as Letra,
						fv_nrodoc      											  		as Comprobante,
						'ANULADA'       											  	as Cliente,
						''				      									  			as CUIT,
						''                                        as [Tipo de Documento],
			      ''	  																		as [Condicion IVA],
			      ''	  																		as [Condicion IVA2],
			
						0			              											as Neto,
			      0                                         as Base,
			      0                                         as [Base Iva],
						0			  					            						as [Tasa Iva],
						0		  											              as [Importe Iva],
						0			  																	as [Importe interno],
						''        																as Concepto,
						0                           			  			as [Importe concepto],
						0            			  			                as Total,
						0                                         as Orden,
						0                                         as Orden2,
						0																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  on fv.fv_id 	= t.fv_id)
																inner join Documento d 							on fv.doc_id  = d.doc_id
			                          inner join Empresa                  on d.emp_id   = Empresa.emp_id 
															  inner join Cliente c                on fv.cli_id  = c.cli_id
			where 			
			      		fv.est_id = 7 -- Anuladas			
			
						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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
			
			--------------------------------------------------------------------------------------------------
			-- TOTAL TASAS IVA
			--------------------------------------------------------------------------------------------------
			
			union all
			
			select 
						0																					as comp_id,
						'19900101'           											as Fecha,
						''                											  as Documento,
			      ''                                        as Empresa, 
						''											                  as Letra,
						''            											  		as Comprobante,
						''                											  as Cliente,
						''																  			as CUIT,
						''                                        as [Tipo de Documento],
						''																				as [Condicion IVA],
						''																				as [Condicion IVA2],
			      0                                         as Neto,
						sum(case d.doct_id
			            when 7  then - (	fvi_neto
																	- (fvi_neto * fv_descuento1 / 100)
																	- (
																			(
																				fvi_neto - (fvi_neto * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
																	)
			            else          fvi_neto
																	- (fvi_neto * fv_descuento1 / 100)
																	- (
																			(
																				fvi_neto - (fvi_neto * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
			          end			
			          )  											              as Base,
			      0                                         as [Base Iva],
						fvi_ivariporc			  											as [Tasa Iva],
						sum(case d.doct_id
			            when 7  then - (	fvi_ivari
																	- (fvi_ivari * fv_descuento1 / 100)
																	- (
																			(
																				fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
																	)
			
			            else          fvi_ivari
																	- (fvi_ivari * fv_descuento1 / 100)
																	- (
																			(
																				fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
			          end			
			          )			    		  											as [Importe Iva],
						0			  																	as [Importe interno],
						case 
								when ti_codigodgi1 <> '' then ti_codigodgi1
								else                          ti_nombre
						end			  																as Concepto,
						0                           			  			as [Importe concepto],
						0                           			  			as Total,
						1                                         as Orden,
						0                                         as Orden2,
						1																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))

			
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  on fv.fv_id 	 = t.fv_id)
																inner join Documento d 							on fv.doc_id   = d.doc_id
			                          inner join Empresa                  on d.emp_id    = Empresa.emp_id 
															  inner join FacturaVentaItem fvi     on fv.fv_id    = fvi.fv_id
			                          inner join Producto pr              on fvi.pr_id   = pr.pr_id
			                          inner join TasaImpositiva ti        on pr.ti_id_ivariventa = ti.ti_id
			where 			
			      		fv.est_id <> 7 -- Anuladas			
						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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
			group by
			
						case 
								when ti_codigodgi1 <> '' then ti_codigodgi1
								else                          ti_nombre
						end,
						fvi_ivariporc
			
			--------------------------------------------------------------------------------------------------
			-- TOTAL CATEGORIAS FISCALES
			--------------------------------------------------------------------------------------------------
			
			union all
			
			select 
						0																					as comp_id,
						'19900101'           											as Fecha,
						''                											  as Documento,
			      ''                                        as Empresa, 
						''											                  as Letra,
						''            											  		as Comprobante,
						''                											  as Cliente,
						''																  			as CUIT,
						''                                        as [Tipo de Documento],
						case cli_catfiscal
							when 1  then 'Inscripto'
							when 2  then 'Exento'
							when 3  then 'No inscripto'
							when 4  then 'Consumidor Final'
							when 5  then 'Extranjero'
							when 6  then 'Mono Tributo'
							when 7  then 'Extranjero Iva'
							when 8  then 'No responsable'
							when 9  then 'No Responsable exento'
							when 10 then 'No categorizado'
							when 11 then 'Inscripto M'
				      else 				 'Sin categorizar'
						end																				as [Condicion IVA],
			
						case cli_catfiscal
							when 1  then 'IN'
							when 2  then 'EX'
							when 3  then 'NI'
							when 4  then 'CF'
							when 5  then 'EJ'
							when 6  then 'M'
							when 7  then 'EJI'
							when 8  then 'NR'
							when 9  then 'NRE'
							when 10 then 'NC'
							when 11 then 'IM'
				      else 				 'SC'
						end																				as [Condicion IVA2],
			
			      0                                         as Neto,
						sum(case d.doct_id
			            when 7  then - (	fvi_neto
																	- (fvi_neto * fv_descuento1 / 100)
																	- (
																			(
																				fvi_neto - (fvi_neto * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
																	)
			
			            else          fvi_neto
																	- (fvi_neto * fv_descuento1 / 100)
																	- (
																			(
																				fvi_neto - (fvi_neto * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
			          end			
			          )  											              as Base,
			      0                                         as [Base Iva],
						fvi_ivariporc			  											as [Tasa Iva],
						sum(case d.doct_id
			            when 7  then - (	fvi_ivari
																	- (fvi_ivari * fv_descuento1 / 100)
																	- (
																			(
																				fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
																	)
			
			            else          fvi_ivari
																	- (fvi_ivari * fv_descuento1 / 100)
																	- (
																			(
																				fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
			          end			
			          )			    		  											as [Importe Iva],
						0			  																	as [Importe interno],
						case 
								when ti_codigodgi1 <> '' then ti_codigodgi1
								else                          ti_nombre
						end			  																as Concepto,
						0                           			  			as [Importe concepto],
						0                           			  			as Total,
						2                                         as Orden,
						0                                         as Orden2,
						1																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  on fv.fv_id 	 = t.fv_id)
																inner join Documento d 							on fv.doc_id   = d.doc_id
			                          inner join Empresa                  on d.emp_id    = Empresa.emp_id 
															  inner join FacturaVentaItem fvi     on fv.fv_id    = fvi.fv_id
			                          inner join Producto pr              on fvi.pr_id   = pr.pr_id
			                          inner join TasaImpositiva ti        on pr.ti_id_ivariventa = ti.ti_id
			                          inner join Cliente cli              on fv.cli_id   = cli.cli_id
			where 			
			      		fv.est_id <> 7 -- Anuladas			
			
						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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
			group by
			
						case cli_catfiscal
							when 1  then 'Inscripto'
							when 2  then 'Exento'
							when 3  then 'No inscripto'
							when 4  then 'Consumidor Final'
							when 5  then 'Extranjero'
							when 6  then 'Mono Tributo'
							when 7  then 'Extranjero Iva'
							when 8  then 'No responsable'
							when 9  then 'No Responsable exento'
							when 10 then 'No categorizado'
							when 11 then 'Inscripto M'
				      else 				 'Sin categorizar'
						end,
			
						case cli_catfiscal
							when 1  then 'IN'
							when 2  then 'EX'
							when 3  then 'NI'
							when 4  then 'CF'
							when 5  then 'EJ'
							when 6  then 'M'
							when 7  then 'EJI'
							when 8  then 'NR'
							when 9  then 'NRE'
							when 10 then 'NC'
							when 11 then 'IM'
				      else 				 'SC'
						end,
			
						case 
								when ti_codigodgi1 <> '' then ti_codigodgi1
								else                          ti_nombre
						end,
			      fvi_ivariporc
			
			--------------------------------------------------------------------------------------------------
			-- TOTAL TASAS PERCEPCIONES
			--------------------------------------------------------------------------------------------------
			
			union all
			
			select 
						0 																				as comp_id,
						'19900101'           											as Fecha,
						''                											  as Documento,
			      ''                                        as Empresa, 
						''																				as Letra,
						''            											  		as Comprobante,
						''                											  as Cliente,
						''																  			as CUIT,
						''                                        as [Tipo de Documento],
						''																				as [Condicion IVA],
						''																				as [Condicion IVA2],
			      0                                         as Neto,
						sum(case d.doct_id
			            when 7  then -fvperc_base
			            else          fvperc_base
			          end			
			          )			          											as Base,
			      0                                         as [Base Iva],
						fvperc_porcentaje	  											as [Tasa Iva],
						0			  																	as [Importe Iva],
						sum(case d.doct_id
			            when 7  then -fvperc_importe
			            else          fvperc_importe
			          end			
			          )			        		  									as [Importe interno],
						perc_nombre																as Concepto,
						0                           			  			as [Importe concepto],
						0                           			  			as Total,
						4                                         as Orden,
						0                                         as Orden2,
						1																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  	  on fv.fv_id 		= t.fv_id)
																inner join Documento d 							  	on fv.doc_id   	= d.doc_id
			                          inner join Empresa                      on d.emp_id    	= Empresa.emp_id 
															  inner join Cliente p                  	on fv.cli_id  	= p.cli_id
			                          inner join FacturaVentaPercepcion fvp  	on fv.fv_id     = fvp.fv_id
			                          inner join Percepcion perc              on fvp.perc_id  = perc.perc_id
			
			where 			
			      		fv.est_id <> 7 -- Anuladas			
			
						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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
			
			
			group by
			
						perc_nombre,fvperc_porcentaje

			union all
	
			--///////////////////////////////////////////////////////////////////////////////////////////
			--
			-- TOTALES POR TIPO DE DOCUMENTO AGRUPADOS POR CATGORIA FISCAL
			--
			--
			select 
						0																					as comp_id,
						'19900101'           											as Fecha,
						''                											  as Documento,
			      ''                                        as Empresa, 
						''											                  as Letra,
						''            											  		as Comprobante,
						''                											  as Cliente,
						''																  			as CUIT,
						doct_nombre                               as [Tipo de Documento],
						case cli_catfiscal
							when 1  then 'Inscripto'
							when 2  then 'Exento'
							when 3  then 'No inscripto'
							when 4  then 'Consumidor Final'
							when 5  then 'Extranjero'
							when 6  then 'Mono Tributo'
							when 7  then 'Extranjero Iva'
							when 8  then 'No responsable'
							when 9  then 'No Responsable exento'
							when 10 then 'No categorizado'
							when 11 then 'Inscripto M'
				      else 				 'Sin categorizar'
						end																				as [Condicion IVA],
			
						case cli_catfiscal
							when 1  then 'IN'
							when 2  then 'EX'
							when 3  then 'NI'
							when 4  then 'CF'
							when 5  then 'EJ'
							when 6  then 'M'
							when 7  then 'EJI'
							when 8  then 'NR'
							when 9  then 'NRE'
							when 10 then 'NC'
							when 11 then 'IM'
				      else 				 'SC'
						end																				as [Condicion IVA2],
			
			      0                                         as Neto,
						sum(case d.doct_id
			            when 7  then - (	fvi_neto
																	- (fvi_neto * fv_descuento1 / 100)
																	- (
																			(
																				fvi_neto - (fvi_neto * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
																	)
			
			            else          fvi_neto
																	- (fvi_neto * fv_descuento1 / 100)
																	- (
																			(
																				fvi_neto - (fvi_neto * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
			          end			
			          )  											              as Base,
			      0                                         as [Base Iva],
						fvi_ivariporc			  											as [Tasa Iva],
						sum(case d.doct_id
			            when 7  then - (	fvi_ivari
																	- (fvi_ivari * fv_descuento1 / 100)
																	- (
																			(
																				fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
																	)
			
			            else          fvi_ivari
																	- (fvi_ivari * fv_descuento1 / 100)
																	- (
																			(
																				fvi_ivari - (fvi_ivari * fv_descuento1 / 100)
																			) * fv_descuento2 / 100
																		)
			          end			
			          )			    		  											as [Importe Iva],
						0			  																	as [Importe interno],
						case 
								when ti_codigodgi1 <> '' then ti_codigodgi1
								else                          ti_nombre
						end			  																as Concepto,
						0                           			  			as [Importe concepto],
						0                           			  			as Total,
						3                                         as Orden,
						0                                         as Orden2,
						1																					as Orden3   -- Separa Comprobantes de totales 
																																	-- (es decir todos los totales tienen el mismo valor (1))
			
			from (FacturaVenta fv     inner join #t_DC_CSC_CON_0020_fv t  on fv.fv_id 	 = t.fv_id)
																inner join Documento d 							on fv.doc_id   = d.doc_id
			                          inner join Empresa                  on d.emp_id    = Empresa.emp_id 
															  inner join FacturaVentaItem fvi     on fv.fv_id    = fvi.fv_id
			                          inner join Producto pr              on fvi.pr_id   = pr.pr_id
			                          inner join TasaImpositiva ti        on pr.ti_id_ivariventa = ti.ti_id
			                          inner join Cliente cli              on fv.cli_id   = cli.cli_id
																inner join DocumentoTipo doct       on fv.doct_id  = doct.doct_id
			where 			 
			      		fv.est_id <> 7 -- Anuladas			
			
						and (
									exists(select * from EmpresaUsuario where emp_id = d.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (d.cico_id = @cico_id or @cico_id=0)
			and   (Empresa.emp_id = @emp_id or @emp_id=0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = d.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_CircuitoContable = 0)
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
			group by
			
						case cli_catfiscal
							when 1  then 'Inscripto'
							when 2  then 'Exento'
							when 3  then 'No inscripto'
							when 4  then 'Consumidor Final'
							when 5  then 'Extranjero'
							when 6  then 'Mono Tributo'
							when 7  then 'Extranjero Iva'
							when 8  then 'No responsable'
							when 9  then 'No Responsable exento'
							when 10 then 'No categorizado'
							when 11 then 'Inscripto M'
				      else 				 'Sin categorizar'
						end,
			
						case cli_catfiscal
							when 1  then 'IN'
							when 2  then 'EX'
							when 3  then 'NI'
							when 4  then 'CF'
							when 5  then 'EJ'
							when 6  then 'M'
							when 7  then 'EJI'
							when 8  then 'NR'
							when 9  then 'NRE'
							when 10 then 'NC'
							when 11 then 'IM'
				      else 				 'SC'
						end,
			
						doct_nombre,
						case 
								when ti_codigodgi1 <> '' then ti_codigodgi1
								else                          ti_nombre
						end,
			      fvi_ivariporc
			
			order by 
			
						orden3,							-- Separa Comprobantes de Totales
						orden,							-- Separa Comprobantes de Totales y tipos de totales entre si
						letra,
						Fecha,
						Comprobante,
						orden2,							-- Separa tipos de renglon en las facturas (total, percepcion, otras tasas de iva, anuladas)
						[Condicion IVA]

end
go
