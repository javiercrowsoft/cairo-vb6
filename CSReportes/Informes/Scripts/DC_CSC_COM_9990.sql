/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de compra
---------------------------------------------------------------------*/

/*


[DC_CSC_COM_9990] 1,'20060101 00:00:00','20070301 00:00:00','539','0','0'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9990]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9990]


go
create procedure DC_CSC_COM_9990 (

  @@us_id    		int,

	@@Fini        datetime,
	@@Ffin        datetime,

  @@prov_id   			varchar(255),
	@@doc_id          varchar(255),
  @@emp_id	   			varchar(255),
	@@cue_id          varchar(255)  

)as 
begin

  set nocount on

declare @emp_id	  		int
declare @prov_id   		int
declare @doc_id   		int
declare @cue_id       int

declare @ram_id_empresa      	int
declare @ram_id_proveedor     int
declare @ram_id_documento     int
declare @ram_id_cuenta        int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out, 			@ram_id_empresa 	out
exec sp_ArbConvertId @@prov_id,  		 @prov_id out,  		@ram_id_proveedor out
exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
exec sp_ArbConvertId @@cue_id,  		 @cue_id out,  			@ram_id_cuenta 		out
  
exec sp_GetRptId @clienteID out

if @ram_id_proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
	end else 
		set @ram_id_proveedor = 0
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

	update FacturaCompra set fc_grabarAsiento = 1
	from Documento doc 
	where 
				fc_fecha between @@Fini and @@Ffin

	  and   (prov_id = @prov_id or @prov_id = 0)
	  and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 29 
	                  and  rptarb_hojaid = prov_id
								   ) 
	           )
	        or 
						 (@ram_id_proveedor = 0)
				 )									

		 and FacturaCompra.doc_id = doc.doc_id

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


			and	(doc.doc_id = @doc_id or @doc_id = 0)
	    and (
	  					(exists(select rptarb_hojaid 
	                    from rptArbolRamaHoja 
	                    where
	                         rptarb_cliente = @clienteID
	                    and  tbl_id = 4001 
	                    and  rptarb_hojaid = doc.doc_id
	  							   ) 
	             )
	          or 
	  					 (@ram_id_documento = 0)
	  			 )

			and ( 		(@cue_id = 0 or @ram_id_cuenta = 0)
						and	exists(select * from AsientoItem 
											 where as_id = FacturaCompra.as_id 
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

	delete FacturaCompraAsiento

  insert into FacturaCompraAsiento (fc_id,fc_fecha) 
	select fc_id,'20040304' from FacturaCompra 
	where fc_grabarAsiento <> 0 
 
  exec sp_DocFacturaCompraAsientosSave 

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los asientos han sido actualizados' as Info

end
go
 