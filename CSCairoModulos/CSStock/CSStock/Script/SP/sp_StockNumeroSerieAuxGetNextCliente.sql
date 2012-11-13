if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockNumeroSerieAuxGetNextCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockNumeroSerieAuxGetNextCliente]

go

/*

sp_StockNumeroSerieAuxGetNextCliente 8,7

*/

-- sp_iddelete

create procedure sp_StockNumeroSerieAuxGetNextCliente 

as

begin

	exec sp_StockNumeroSerieAuxGetNextCairo

end