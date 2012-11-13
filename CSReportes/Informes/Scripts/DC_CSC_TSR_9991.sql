/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de cobranzas
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9991]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9991]


go
create procedure DC_CSC_TSR_9991 (

  @@us_id    		int,

	@@Fini        datetime,
	@@Ffin        datetime,

  @@cli_id   				varchar(255),
	@@doc_id          varchar(255),
  @@emp_id	   			varchar(255),
	@@cue_id          varchar(255)  

)as 
begin

  set nocount on

declare @emp_id	  		int
declare @cli_id   		int
declare @doc_id   		int
declare @cue_id       int

declare @ram_id_empresa      	int
declare @ram_id_cliente       int
declare @ram_id_documento     int
declare @ram_id_cuenta        int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out, 			@ram_id_empresa 	out
exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente 	out
exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
exec sp_ArbConvertId @@cue_id,  		 @cue_id out,  			@ram_id_cuenta 		out
  
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

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

	update Cobranza set cobz_grabarAsiento = 1
	where 
				cobz_fecha between @@Fini and @@Ffin

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

			and ( 		(@cue_id = 0 or @ram_id_cuenta = 0)
						and	exists(select * from AsientoItem 
											 where as_id = Cobranza.as_id 
												and (			(cue_id = @cue_id or @cue_id = 0) 
															and (	(exists(select rptarb_hojaid 
																						from rptArbolRamaHoja 
																						where rptarb_cliente = @clienteID 
																							and tbl_id = 17
																							and rptarb_hojaid = cue_id)
																						) 
																 or (@ram_id_empresa = 0)
																	)
														)
											)
					)

	delete CobranzaAsiento

 	insert into CobranzaAsiento (cobz_id,cobz_fecha) 
	select cobz_id,'20040304' from Cobranza 
	where cobz_grabarAsiento <> 0 

  exec sp_DocCobranzaAsientosSave 

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los asientos han sido actualizados' as Info

end
go
 