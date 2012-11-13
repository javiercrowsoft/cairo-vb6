/*---------------------------------------------------------------------
Nombre: Cancelar cobranzas con x centavos pendientes
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_TSR_9985 1, 
								'20060501',
								'20080531', 
								'0','0','0',
								0,
								0.1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9985]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9985]

go
create procedure DC_CSC_TSR_9985 (
	@@us_id 		int,

	@@Fini        datetime,
	@@Ffin        datetime,

  @@cli_id   		varchar(255),
	@@doc_id      varchar(255),
  @@emp_id	   	varchar(255),

	@@cobz_numero   int,

	@@pendiente		decimal(18,6)

)as 

begin

  set nocount on

	create table #t_dc_csc_tsr_9985 (cobz_id int not null)

	set @@pendiente = abs(@@pendiente)

	if @@cobz_numero = 0 and @@pendiente > 0.10 begin

		select 1 as aux_id, 'Para importes mayores a 10 centavos debe indicar un número interno de la cobranza' as Info

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

	insert into #t_dc_csc_tsr_9985 (cobz_id)

	select cobz.cobz_id

	from Cobranza cobz

	where 
				cobz_fecha between @@Fini and @@Ffin
		and (cobz_pendiente <= @@pendiente and cobz_pendiente <> 0)
		and (cobz_numero = @@cobz_numero or @@cobz_numero = 0)
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
	declare @cobz_id 			int

	declare c_cobz insensitive cursor for select cobz_id from #t_dc_csc_tsr_9985

	open c_cobz

	fetch next from c_cobz into @cobz_id
	while @@fetch_status=0
	begin
		
		update Cobranza set cobz_pendiente = 0 where cobz_id = @cobz_id

		exec sp_DocCobranzaSetEstado @cobz_id, 0, 0

		fetch next from c_cobz into @cobz_id
	end

	close c_cobz
	deallocate c_cobz


--//////////////////////////////////////////////////////////////////////////////////////////////////
--
-- RESULTADO
--
--//////////////////////////////////////////////////////////////////////////////////////////////////

	  select 1 as aux_id, 'El proceso se ejecuto con éxito, las cobranzas han sido actualizadas' as Info

	union

		select cobz_id as aux_id, cobz_nrodoc + ' ' + cli_nombre + ' ' + est_nombre
		from Cobranza cobz inner join estado est 	on cobz.est_id = est.est_id
                       inner join cliente cli on cobz.cli_id = cli.cli_id
	
		where cobz_id in (select cobz_id from #t_dc_csc_tsr_9985)

	order by aux_id

end
go
