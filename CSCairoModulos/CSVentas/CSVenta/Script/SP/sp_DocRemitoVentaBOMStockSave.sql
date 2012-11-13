if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaBOMStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaBOMStockSave]

/*
 select * from Remitoventa
 sp_DocRemitoVentaBOMStockSave 26

*/

go
create procedure sp_DocRemitoVentaBOMStockSave (
	@@rvTMP_id        int,
	@@rv_id 					int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

  declare @IsNew          smallint

	declare @doc_id_Remito  int
	declare	@modificado 		datetime 
	declare	@modifico   		int 
	declare @st_id_n				int
	declare @st_id_t				int

	-- Si no existe chau
	if not exists (select rv_id from RemitoVenta where rv_id = @@rv_id)
		return
	
	select 
					@st_id_n          = st_id_consumo,
					@st_id_t          = st_id_consumoTemp,
					@doc_id_Remito 		= doc_id,
					@modifico					= modifico,
					@modificado       = modificado

	from RemitoVenta where rv_id = @@rv_id

	declare @depl_id_n			int -- Nacional
	declare @depl_id_t			int	-- Temporal

	select 
					@depl_id_n        = depl_id,
					@depl_id_t        = depl_id_temp

	from RemitoVentaTMP where rvTMP_id = @@rvTMP_id
	

	-- Insumos temporales
	--
	exec sp_DocRemitoVentaBOMStockSave2 1,  -- Son insumos temporales
																			@@rvTMP_id,
																			@@rv_id, 
																			@depl_id_t, 
																			@doc_id_Remito, 
																			@modificado, 
																			@modifico, 
																			@st_id_t,
																			@@bRaiseError, 
																			@@bError out, 
																			@@MsgError out
	if @@bError <> 0 return

	-- Insumos nacionales
	--
	exec sp_DocRemitoVentaBOMStockSave2 0,  -- No son insumos temporales
																			@@rvTMP_id,
																			@@rv_id, 
																			@depl_id_n, 
																			@doc_id_Remito, 
																			@modificado, 
																			@modifico, 
																			@st_id_t,
																			@@bRaiseError, 
																			@@bError out, 
																			@@MsgError out
	if @@bError <> 0 return

end