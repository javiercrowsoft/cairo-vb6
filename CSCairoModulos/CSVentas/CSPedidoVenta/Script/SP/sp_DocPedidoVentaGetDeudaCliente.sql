if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGetDeudaCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGetDeudaCliente]

go
create procedure sp_DocPedidoVentaGetDeudaCliente (
  @@cli_id       int,
  @@deuda       decimal(18,6) out,
  @@deudadoc    decimal(18,6) out
)
as

begin

  set nocount on

  select @@deuda = sum(clicc_importe) 
  from ClienteCacheCredito 
  where cli_id = @@cli_id 
    and doct_id <> 1013

  select @@deudadoc = sum(clicc_importe) 
  from ClienteCacheCredito 
  where cli_id = @@cli_id 
    and doct_id = 1013

  set @@deuda     = isnull(@@deuda,0)
  set @@deudadoc   = isnull(@@deudadoc,0)

end