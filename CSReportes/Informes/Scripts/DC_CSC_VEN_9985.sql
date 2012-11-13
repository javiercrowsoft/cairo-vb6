/*---------------------------------------------------------------------
Nombre: Cancelar facturas con x centavos pendientes
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_VEN_9985 1, 
								'20060501',
								'20080531', 
								'0','0','0',
								0,
								0.1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9985]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9985]

go
create procedure DC_CSC_VEN_9985 (
	@@us_id 		int,

	@@Fini        datetime,
	@@Ffin        datetime,

  @@cli_id   		varchar(255),
	@@doc_id      varchar(255),
  @@emp_id	   	varchar(255),

	@@fv_numero   int,

	@@pendiente		decimal(18,6)

)as 

begin

  set nocount on

	create table #t_dc_csc_ven_9985 (fv_id int not null)

	set @@pendiente = abs(@@pendiente)

	if @@fv_numero = 0 and @@pendiente > 0.10 begin

		select 1 as aux_id, 'Para importes mayores a 10 centavos debe indicar un número interno de la factura' as Info

		return
	end
	
	declare @emp_id	  		int
	declare @cli_id   		int
	declare @doc_id   		int
	
	declare @ram_id_empresa      	int
	declare @ram_id_cliente       int
	declare @ram_id_documento     int
	
	declare @IsRaiz    tinyint
	declare @clienteID int
	
	exec sp_ArbConvertId @@emp_id,       @emp_id out, 			@ram_id_empresa out
	exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
	exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
	  
	exec sp_GetRptId @clienteID out
	
	if @ram_id_cliente <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
		end else 
			set @ram_id_cliente = 0
	end
	
	if @ram_id_documento <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
		end else 
			set @ram_id_documento = 0
	end
	
	if @ram_id_empresa <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
		end else 
			set @ram_id_empresa = 0
	end

--//////////////////////////////////////////////////////////////////////////////////////////////////
--
-- PROCESO
--
--//////////////////////////////////////////////////////////////////////////////////////////////////

	insert into #t_dc_csc_ven_9985 (fv_id)

	select fv.fv_id

	from FacturaVenta fv

	where 
				fv_fecha between @@Fini and @@Ffin
		and (fv_pendiente <= @@pendiente and fv_pendiente <> 0)
		and (fv_numero = @@fv_numero or @@fv_numero = 0)
		and est_id <> 7


	  and   (cli_id = @cli_id or @cli_id = 0)
	  and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 28 
	                  and  rptarb_hojaid = cli_id
								   ) 
	           )
	        or 
						 (@ram_id_cliente = 0)
				 )									

			and	(doc_id = @doc_id or @doc_id = 0)
	    and (
	  					(exists(select rptarb_hojaid 
	                    from rptArbolRamaHoja 
	                    where
	                         rptarb_cliente = @clienteID
	                    and  tbl_id = 4001 
	                    and  rptarb_hojaid = doc_id
	  							   ) 
	             )
	          or 
	  					 (@ram_id_documento = 0)
	  			 )

		 and (emp_id = @emp_id or @emp_id = 0)
     and (
  					(exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1018 
                    and  rptarb_hojaid = emp_id
  							   ) 
             )
          or 
  					 (@ram_id_empresa = 0)
  			 )


	--//////////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- CURSORSILLO
	--
	--//////////////////////////////////////////////////////////////////////////////////////////////////
	declare @fv_id 				int
	declare @doct_id      int
	declare @fvp_id       int
	declare @fvd_id       int
	declare @fvd_fecha 		datetime
	declare @fvd_importe	decimal(18,6)

	declare c_fv insensitive cursor for select fv_id from #t_dc_csc_ven_9985

	open c_fv

	fetch next from c_fv into @fv_id
	while @@fetch_status=0
	begin

		select @doct_id = doct_id from FacturaVenta where fv_id = @fv_id

		-- Pasamos todas las deudas a pagos
		-- y redirijimos la aplicacion
		--
		declare c_deuda insensitive cursor for 
				select fvd_id, fvd_importe, fvd_fecha from FacturaVentaDeuda where fv_id = @fv_id

		open c_deuda
		fetch next from c_deuda into @fvd_id, @fvd_importe, @fvd_fecha
		while @@fetch_status=0
		begin

			exec sp_dbgetnewid 'FacturaVentaPago','fvp_id', @fvp_id out, 0

			insert into FacturaVentaPago (
																			fvp_id,
																			fvp_fecha,
																			fvp_importe,
																			fv_id
																		)
												values		 (
																			@fvp_id,
																			@fvd_fecha,
																			@fvd_importe,
																			@fv_id
																		)
			if @doct_id <> 7 begin

				update FacturaVentaCobranza set fvp_id = @fvp_id, fvd_id = null where fvd_id = @fvd_id
	
				update FacturaVentaNotaCredito set fvp_id_factura = @fvp_id, fvd_id_factura = null 
				where fvd_id_factura = @fvd_id

			end else begin

				update FacturaVentaNotaCredito set fvp_id_notacredito = @fvp_id, fvd_id_notacredito = null 
				where fvd_id_notacredito = @fvd_id

			end
			
			delete FacturaVentaDeuda where fvd_id = @fvd_id

			exec sp_DocFacturaVentaSetPendiente @fv_id, 0

			exec sp_DocFacturaVentaSetEstado @fv_id, 0, 0

			fetch next from c_deuda into @fvd_id, @fvd_importe, @fvd_fecha

		end

		close c_deuda
		deallocate c_deuda

		fetch next from c_fv into @fv_id
	end

	close c_fv
	deallocate c_fv


--//////////////////////////////////////////////////////////////////////////////////////////////////
--
-- RESULTADO
--
--//////////////////////////////////////////////////////////////////////////////////////////////////

	  select 1 as aux_id, 'El proceso se ejecuto con éxito, las facturas han sido actualizadas' as Info

	union

		select fv_id as aux_id, fv_nrodoc + ' ' + cli_nombre + ' ' + est_nombre
		from facturaventa fv inner join estado est on fv.est_id = est.est_id
	                       inner join cliente cli on fv.cli_id = cli.cli_id
	
		where fv_id in (select fv_id from #t_dc_csc_ven_9985)

	order by aux_id

end
go
