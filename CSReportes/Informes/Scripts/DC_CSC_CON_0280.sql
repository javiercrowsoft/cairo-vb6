/*---------------------------------------------------------------------
Nombre: Libro Diario
---------------------------------------------------------------------*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0280]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0280]
GO

/*  

Para testear:

DC_CSC_CON_0280 1, 
								'20060101',
								'20070430',
								2, 
								'0'
*/

create procedure DC_CSC_CON_0280 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,
	@@ejc_id			int,
	@@cico_id			varchar(255)

)as 

begin
set nocount on

	declare @emp_id int

	select @emp_id = emp_id
	from EjercicioContable 
	where ejc_id = @@ejc_id

	create table #t_ejasiento (ejcas_id int, cue_id int, debe decimal(18,6), haber decimal(18,6))


	--////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- Tipo de Resumen

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

	--
	--////////////////////////////////////////////////////////////////////////////////////////////////////

	if @tipo_fc <> 3 or @tipo_fv <> 3 begin

		exec sp_DocAsientoResumirAsientos @@ejc_id, @emp_id, @@cico_id, @@Fini, @@Ffin, @tipo_fc, @tipo_fv

	end

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

	declare @emp_nombre varchar(255)
	select @emp_nombre = emp_nombre from Empresa where emp_id = @emp_id

	select 
				ast.as_id             as comp_id,
				as_numero             as [Número],
				as_nrodocld					  as [Comprobante],
	      case when as_descrip = '' then doc.doc_nombre else as_descrip end	as [Documento],
				as_fecha						  as [Fecha],
	
	      (select doct_codigo from DocumentoTipo where doct_id = ast.doct_id_cliente)
	                            as [Código Doc.],
	
	      (select doct_nombre from DocumentoTipo where doct_id = ast.doct_id_cliente)
	                            as [Tipo Doc.],
	      
				as_doc_cliente        as [Documento Aux],
				emp_nombre            as [Empresa],
	
				ast.Creado,
				ast.Modificado,
				us_nombre             as [Modifico],
	
	
	      cue_nombre             as Cuenta,
	      asi_debe               as Debe,
	      asi_haber              as Haber,
	
				as_descrip						as [Observaciones]
	
	from 
	
				asiento ast
	
	              inner join documento   doc  on ast.doc_id   = doc.doc_id
	
	              left  join documento   doccl  on ast.doc_id_cliente = doccl.doc_id
	
	              inner join usuario     us   on ast.modifico = us.us_id
								inner join empresa     emp  on doc.emp_id   = emp.emp_id
	              inner join asientoItem asi  on ast.as_id    = asi.as_id
	              inner join cuenta      cue  on asi.cue_id   = cue.cue_id
	
	where 
					  as_fecha >= @@Fini
				and	as_fecha <= @@Ffin 
	
	-- Validar usuario - empresa
				and (
							exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
						)

			and doc.emp_id = @emp_id
			and (			isnull(ast.doct_id_cliente,0) not in (2,8,10)
						or 	@tipo_fc = 3
					)
			and (			isnull(ast.doct_id_cliente,0) not in (1,7,9)
						or 	@tipo_fv = 3
					)
	
			--//////////////////////////////////////////////////////////////////////////////////
			--
			-- Circuito Contable
			--
			and (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id = 0)
			and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id))) or (@ram_id_circuitocontable = 0))
			--//////////////////////////////////////////////////////////////////////////////////

	union all

	select 
				null                  as comp_id,
				0                     as [Número],
				ejcas_nrodoc				  as [Comprobante],

	      case ejcas_tipo 
						when 1 then 'Asiento Resumen Ventas'			
						else        'Asiento Resumen Compras'			
				end										as [Documento],

				ejcas_fecha						as [Fecha],
	
	      ''                    as [Código Doc.],
	      ''                    as [Tipo Doc.],
				''        						as [Documento Aux],
				@emp_nombre           as [Empresa],
	
				null									as Creado,
				null									as Modificado,
				null                  as [Modifico],
	
	
	      cue_nombre             as Cuenta,
	      debe               		 as Debe,
	      haber                  as Haber,
	
				''										 as [Observaciones]
	
	from 
	
				#t_ejasiento t 	inner join EjercicioAsientoResumen a on t.ejcas_id = a.ejcas_id
	              				inner join cuenta cue  				 			 on t.cue_id 	 = cue.cue_id

	where 
					  ejcas_fecha >= @@Fini
				and	ejcas_fecha <= @@Ffin 

	order by Fecha, Comprobante, Debe desc

	drop table #t_ejasiento 

end
GO