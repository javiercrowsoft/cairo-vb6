if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockNumeroSerieAuxGetNext]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockNumeroSerieAuxGetNext]

go

/*

sp_StockNumeroSerieAuxGetNext 8,7

*/

-- sp_iddelete

create procedure sp_StockNumeroSerieAuxGetNext 

as

begin

  exec sp_StockNumeroSerieAuxGetNextCliente

end