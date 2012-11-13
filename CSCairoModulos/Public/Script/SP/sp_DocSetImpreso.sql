if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocSetImpreso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocSetImpreso]

go

/*

  sp_DocSetImpreso 133,84

*/

create procedure sp_DocSetImpreso (
	@@doc_id    		int,
	@@id						int
)
as

set nocount on

begin

	set nocount on

	declare @doct_id int

	select @doct_id = doct_id from documento where doc_id = @@doc_id

	set @doct_id = isnull(@doct_id,0)

	--FacturaVenta, NotaCreditoVenta, NotaDebitoVenta 
	--
	if @doct_id in (1,7,9) begin

		update FacturaVenta set impreso = 1 where fv_id = @@id

	end else
	--FacturaCompra,NotaCreditoCompra, NotaDebitoCompra
	--
  if @doct_id in (2,8,10) begin

		update FacturaCompra set impreso = 1 where fc_id = @@id

	end else
	--RemitoVenta, DevolucionRemitoVta
	--
  if @doct_id in (3,24) begin

		update RemitoVenta set impreso = 1 where rv_id = @@id

	end else
	--RemitoCompra, DevolucionRemitoCpra
	--
  if @doct_id in (4,25) begin

		update RemitoCompra set impreso = 1 where rc_id = @@id

	end else
	--PedidoVenta, DevolucionPedidoVta
	--
  if @doct_id in (5,22) begin

		update PedidoVenta set impreso = 1 where pv_id = @@id
	
	end else
	--PedidoCompra, DevolucionPedidoCpra
	--
  if @doct_id in (6,23) begin

		update PedidoCompra set impreso = 1 where pc_id = @@id

	end else
	--PresupuestoVenta,DevolucionPresuVta)
	--
  if @doct_id in (11,39) begin

		update PresupuestoVenta set impreso = 1 where prv_id = @@id

	end else
	--PresupuestoCompra, DevolucionPresuCpra
	--
  if @doct_id in (12,40) begin

		update PresupuestoCompra set impreso = 1 where prc_id = @@id

	end else
	--Cobranza = 13
	--
  if @doct_id =13 begin

		update Cobranza set impreso = 1 where cobz_id = @@id

	end else
	--TrasferenciaStock = 14
	--
  if @doct_id =14 begin

		update Stock set impreso = 1 where st_id = @@id

	end else
	--AsientoContable = 15
	--
  if @doct_id =15 begin

		update Asiento set impreso = 1 where as_id = @@id

	end else
	--OrdenPago = 16
	--
  if @doct_id =16 begin

		update OrdenPago set impreso = 1 where opg_id = @@id

	end else
	--DepositoBanco = 17
	--
  if @doct_id =17 begin

		update DepositoBanco set impreso = 1 where dbco_id = @@id

	end else
	--PresupuestoEnvio = 18
	--
  if @doct_id =18 begin

		update PresupuestoEnvio set impreso = 1 where pree_id = @@id

	end else
	--PermisoEmbarque = 19
	--
  if @doct_id =19 begin

		update PermisoEmbarque set impreso = 1 where pemb_id = @@id

	end else
	--ManifiestoCarga, DevolucionManifiesto
	--
  if @doct_id in(20,41) begin

		update ManifiestoCarga set impreso = 1 where mfc_id = @@id

	end else
	--PackingList, PackingListDevolucion
	--
  if @doct_id in(21,22) begin

		update PackingList set impreso = 1 where pklst_id = @@id

	end else
	--MovimientoFondo = 26
	--
  if @doct_id =26 begin

		update MovimientoFondo set impreso = 1 where mf_id = @@id

	end else
	--RecuentoStock = 28
	--
  if @doct_id =28 begin

		update RecuentoStock set impreso = 1 where rs_id = @@id

	end else
	--ImportacionTemp = 29
	--
  if @doct_id =29 begin

		update ImportacionTemp set impreso = 1 where impt_id = @@id

	end else
	--ParteProdKit, ParteDesarmeKit 
	--
  if @doct_id in (30,34) begin

		update ParteProdKit set impreso = 1 where ppk_id = @@id

	end else
	--DepositoCupon = 32
	--
  if @doct_id =32 begin

		update DepositoCupon set impreso = 1 where dcup_id = @@id

	end else
	--ResolucionCupon = 33
	--
  if @doct_id =33 begin

		update ResolucionCupon set impreso = 1 where rcup_id = @@id

	end else
	--OrdenCompra, DevolucionOrdenCpra
	--
  if @doct_id in (35,36) begin

		update OrdenCompra set impreso = 1 where oc_id = @@id

	end else
	--CotizacionCompra, DevolucionCotizacionCpra
	--
  if @doct_id in (37,38) begin

		update CotizacionCompra set impreso = 1 where cot_id = @@id

	end else
	--OrdenServicio = 42
	--
  if @doct_id =42 begin

		update OrdenServicio set impreso = 1 where os_id = @@id

	end else
	--ParteReparacion = 43
	--
  if @doct_id =43 begin

		update ParteReparacion set impreso = 1 where prp_id = @@id

	end else
	--StockProveedor = 44
	--
  if @doct_id =44 begin

		update StockProveedor set impreso = 1 where stprov_id = @@id

	end else
	--StockCliente = 45
	--
  if @doct_id =45 begin

		update StockCliente set impreso = 1 where stcli_id = @@id

	end else

	--OrdenProdKit = 46
	--
  if @doct_id =46 begin

		update OrdenProdKit set impreso = 1 where opk_id = @@id

	end else

	--Liquidacion = 47
	--
  if @doct_id =47 begin

		update Liquidacion set impreso = 1 where liq_id = @@id

	end else

	--Seudo documentos
	--
  if @doct_id = 0 begin

		-- Esto no hace nada, esta para que no chille el if
		set @doct_id = @doct_id

	end	else begin

		declare @MsgError 		varchar(5000)
		declare @doct_nombre 	varchar(255)

		select @doct_nombre = doct_nombre 
		from DocumentoTipo doct inner join Documento doc on doct.doct_id = doc.doct_id 
		where doc_id = @@id

		set @MsgError = '@@ERROR_SP:El documento ' 
										+ '[' + isnull(@doct_nombre,'') + '] (' + convert(varchar, @doct_id) + ')'
										+ ' no esta definido en el procedimiento sp_DocSetImpreso. Comuniquese con soporte@crowsoft.com.ar para obtener una versión actualizada del sistema.'

		raiserror (@MsgError, 16, 1)

	end

end

go
