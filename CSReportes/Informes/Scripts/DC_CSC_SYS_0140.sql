/*---------------------------------------------------------------------
Nombre: Copia documentos a una empresa
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0140]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0140]

GO

/*
DC_CSC_SYS_0140 
											1,
											'20061001',
											'0',
											1
				
*/

create procedure DC_CSC_SYS_0140 (

  @@us_id    int,

  @@doc_id	 				varchar(255),
  @@emp_id	 				varchar(255),

	@@prefijo         varchar(10)

)as 

begin

	set nocount on
	
	/*- ///////////////////////////////////////////////////////////////////////
	
	INICIO PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	declare @doc_id   		int
	declare @emp_id   		int
	
	declare @ram_id_documento        int
	declare @ram_id_empresa          int
	
	declare @clienteID       int
	declare @clienteIDccosi  int
	
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@doc_id,  		 @doc_id 	out,  		@ram_id_documento 				out
	exec sp_ArbConvertId @@emp_id,  		 @emp_id 	out,  		@ram_id_empresa   				out
	
	exec sp_GetRptId @clienteID out
	exec sp_GetRptId @clienteIDccosi out
	
	
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
	
	/*- ///////////////////////////////////////////////////////////////////////
	
	FIN PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	declare @doc_nombre							varchar(255)
	declare @doc_codigo							varchar(255)
	declare @doc_id_asiento					int
	declare @doc_id_stock						int
	declare @doc_id_remito					int
	declare @ta_id									int
	declare @ta_id_final						int
	declare @ta_id_inscripto				int
	declare @ta_id_externo					int
	declare @ta_id_inscriptom				int
	declare @pre_id_new							int
	declare @pre_id_edit						int
	declare @pre_id_delete					int
	declare @pre_id_list						int
	declare @pre_id_anular					int
	declare @pre_id_desanular				int
	declare @pre_id_aplicar					int
	declare @pre_id_print						int

	declare c_doc insensitive cursor for 
	
			select doc_id 
			from Documento doc
			where	(doc.doc_id = @doc_id or @doc_id=0)
			and   (doc.emp_id = @emp_id or @emp_id=0)
			and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 4001 and rptarb_hojaid = doc.doc_id)) or (@ram_id_documento = 0))
			and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_empresa = 0))
	
	open c_doc
	
	fetch next from c_doc into @doc_id
	while @@fetch_status=0
	begin
	
		insert into documento
										(
										doc_id
										,doc_nombre
										,doc_codigo
										,doc_descrip
										,doc_llevaFirma
										,doc_llevaFirmaCredito
										,doc_llevaFirmaPrint0
										,doc_id_asiento
										,doc_muevestock
										,doc_id_stock
										,doc_generaremito
										,doc_id_remito
										,doc_rv_desde_pv
										,doc_rv_desde_os
										,doc_rc_desde_oc
										,doc_rv_bom
										,doc_pv_desde_prv
										,doc_tipofactura
										,doc_tipopackinglist
										,doc_tipoordencompra
										,doc_st_consumo
										,doc_rc_despachoimpo
										,doc_fv_sinpercepcion
										,doc_editarimpresos
										,doc_esresumenbco
										,doc_escreditobanco
										,doc_esventaaccion
										,doc_esventacheque
										,doc_escobchequesgr
										,doc_escobcaidasgr
										,doct_id
										,docg_id
										,cico_id
										,fca_id
										,ta_id
										,ta_id_final
										,ta_id_inscripto
										,ta_id_externo
										,ta_id_inscriptom
										,mon_id
										,cueg_id
										,emp_id
										,pre_id_new
										,pre_id_edit
										,pre_id_delete
										,pre_id_list
										,pre_id_anular
										,pre_id_desanular
										,pre_id_aplicar
										,pre_id_print
										,creado
										,modificado
										,modifico
										,activo
										)
		select 
										doc_id
										,doc_nombre
										,doc_codigo
										,doc_descrip
										,doc_llevaFirma
										,doc_llevaFirmaCredito
										,doc_llevaFirmaPrint0
										,doc_id_asiento
										,doc_muevestock
										,doc_id_stock
										,doc_generaremito
										,doc_id_remito
										,doc_rv_desde_pv
										,doc_rv_desde_os
										,doc_rc_desde_oc
										,doc_rv_bom
										,doc_pv_desde_prv
										,doc_tipofactura
										,doc_tipopackinglist
										,doc_tipoordencompra
										,doc_st_consumo
										,doc_rc_despachoimpo
										,doc_fv_sinpercepcion
										,doc_editarimpresos
										,doc_esresumenbco
										,doc_escreditobanco
										,doc_esventaaccion
										,doc_esventacheque
										,doc_escobchequesgr
										,doc_escobcaidasgr
										,doct_id
										,docg_id
										,cico_id
										,fca_id
										,ta_id
										,ta_id_final
										,ta_id_inscripto
										,ta_id_externo
										,ta_id_inscriptom
										,mon_id
										,cueg_id
										,emp_id
										,pre_id_new
										,pre_id_edit
										,pre_id_delete
										,pre_id_list
										,pre_id_anular
										,pre_id_desanular
										,pre_id_aplicar
										,pre_id_print
										,creado
										,modificado
										,modifico
										,activo
		from Documento
		where doc_id = @doc_id
	
		fetch next from c_doc into @doc_id
	end
	
	close c_doc
	deallocate c_doc

end
go

