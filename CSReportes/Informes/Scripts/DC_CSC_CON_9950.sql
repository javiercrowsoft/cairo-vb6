if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9950]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9950]
GO
/*  

Para testear:

select * from centrocosto where ccos_nombre like '%perrone%'

begin tran
DC_CSC_CON_9950 1, '20110101', '20110131', '0', '0', '0', '0', '0', 0, 0, 0, 0, 0, 0, 0
rollback tran

*/

create procedure DC_CSC_CON_9950 (

	@@us_id     int,

	@@fDesde		datetime,
	@@fHasta		datetime,
  @@emp_id    varchar(255),
	@@prov_id   varchar(255),
	@@cue_id    varchar(255),
  @@cuec_id   varchar(255),
	@@ccos_id 	varchar(255),
	@@cico_id		varchar(255),

	@@update    smallint,

	@@ccos_id_old int,
	@@ccos_id_new int,

	@@factura				smallint,
	@@items					smallint,
  @@otros					smallint,
  @@percepciones  smallint

)as 

begin

	set nocount on

--////////////////////////////////////////////////////////////////////////////////////
--
-- ARBOLES
--
--////////////////////////////////////////////////////////////////////////////////////

			declare @cue_id  int
			declare @cuec_id int
			declare @ccos_id int
			declare @cico_id int
			declare @emp_id  int 
			declare @prov_id int

			declare @ram_id_cuenta            int
			declare @ram_id_cuentacategoria   int
			declare @ram_id_centrocosto 			int
			declare @ram_id_circuitocontable 	int
			declare @ram_id_empresa   				int 
			declare @ram_id_proveedor         int

			declare @clienteID 	int

			declare @IsRaiz    tinyint

			exec sp_ArbConvertId @@cue_id,  @cue_id  out, @ram_id_cuenta out
			exec sp_ArbConvertId @@cuec_id, @cuec_id out, @ram_id_cuentacategoria out
			exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
			exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
			exec sp_ArbConvertId @@emp_id, 	@emp_id  out,	@ram_id_empresa out 
			exec sp_ArbConvertId @@prov_id, @prov_id out,	@ram_id_proveedor out 

			exec sp_GetRptId @clienteID 	out

			if @ram_id_cuenta <> 0 begin

			--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

				exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
				if @IsRaiz = 0 begin
					exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
				end else 
					set @ram_id_cuenta = 0
			end

			if @ram_id_cuentacategoria <> 0 begin

			--	exec sp_ArbGetGroups @ram_id_cuentacategoria, @clienteID, @@us_id

				exec sp_ArbIsRaiz @ram_id_cuentacategoria, @IsRaiz out
				if @IsRaiz = 0 begin
					exec sp_ArbGetAllHojas @ram_id_cuentacategoria, @clienteID 
				end else 
					set @ram_id_cuentacategoria = 0
			end

			if @ram_id_centrocosto <> 0 begin

			--	exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

				exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
				if @IsRaiz = 0 begin
					exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
				end else 
					set @ram_id_centrocosto = 0
			end

			if @ram_id_circuitocontable <> 0 begin

			--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

				exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
				if @IsRaiz = 0 begin
					exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
				end else 
					set @ram_id_circuitocontable = 0
			end

			if @ram_id_empresa <> 0 begin

			--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

				exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
				if @IsRaiz = 0 begin
					exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
				end else 
					set @ram_id_empresa = 0
			end

			if @ram_id_proveedor <> 0 begin

			--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

				exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
				if @IsRaiz = 0 begin
					exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
				end else 
					set @ram_id_proveedor = 0
			end

--////////////////////////////////////////////////////////////////////////////////////
--
-- REGISTROS A MODIFICAR
--
--////////////////////////////////////////////////////////////////////////////////////

	create table #t_fc (fc_id int, ccos_id int, tipo varchar(100), importe decimal(18,6))

	exec DC_CSC_CON_9950_fc 
															@@us_id     ,

															@@fDesde		,
															@@fHasta		,
															@emp_id     ,
															@prov_id    ,
															@cue_id     ,
															@cuec_id    ,
															@ccos_id 	  ,
															@cico_id		,

															@ram_id_empresa   				,
															@ram_id_proveedor  				,
															@ram_id_cuenta            ,
															@ram_id_cuentacategoria   ,
															@ram_id_centrocosto 			,
															@ram_id_circuitocontable 	,

															@clienteID

--////////////////////////////////////////////////////////////////////////////////////
--
-- UPDATE
--
--////////////////////////////////////////////////////////////////////////////////////

	if @@update <> 0 begin

		if @@factura <> 0 begin

			update FacturaCompra set ccos_id = @@ccos_id_new 
			where fc_id in (select fc_id from #t_fc where tipo = 'factura')
				and ccos_id = @@ccos_id_old

		end

		if @@items <> 0 begin

			update FacturaCompraItem set ccos_id = @@ccos_id_new 
			where fc_id in (select fc_id from #t_fc where tipo = 'item')
				and ccos_id = @@ccos_id_old

		end

		if @@otros <> 0 begin

			update FacturaCompraOtro set ccos_id = @@ccos_id_new 
			where fc_id in (select fc_id from #t_fc where tipo = 'otro')
				and ccos_id = @@ccos_id_old

		end

		if @@percepciones <> 0 begin

			update FacturaCompraPercepcion set ccos_id = @@ccos_id_new 
			where fc_id in (select fc_id from #t_fc where tipo = 'percepcion')
				and ccos_id = @@ccos_id_old

		end

	end

--////////////////////////////////////////////////////////////////////////////////////
--
-- SELECT DE RETORNO
--
--////////////////////////////////////////////////////////////////////////////////////

	select  fc.fc_id,
					prov_codigo             as Codigo,
					prov_cuit               as CUIT,
					prov_nombre             as Proveedor,
					prov_razonsocial        as [Razon Social],
					'factura compra'				as [Tipo Doc],
					fc.fc_fecha							as Fecha,
					ccos.ccos_nombre				as [Centro Costo],
					ccosnew.ccos_nombre     as [Nuevo Centro Costo],
					tipo										as Tipo,
					importe                 as Importe
	
	from FacturaCompra fc inner join #t_fc t on fc.fc_id = t.fc_id
												inner join Proveedor prov on fc.prov_id = prov.prov_id
												inner join CentroCosto ccos on t.ccos_id = ccos.ccos_id
												left  join FacturaCompraItem fci on  fc.fc_id = fci.fc_id and t.tipo = 'item'
												left  join FacturaCompraOtro fco on fc.fc_id = fco.fc_id and t.tipo = 'otro'
												left  join FacturaCompraPercepcion fcp on fc.fc_id = fcp.fc_id and t.tipo = 'percepcion'
												left  join CentroCosto ccosnew on
                                            (fc.ccos_id = ccosnew.ccos_id and t.tipo = 'factura')
																				or  (fci.ccos_id = ccosnew.ccos_id and t.tipo = 'item')
																				or  (fco.ccos_id = ccosnew.ccos_id and t.tipo = 'otro')
																				or  (fcp.ccos_id = ccosnew.ccos_id and t.tipo = 'percepcion')

end
GO