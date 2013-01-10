-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Stock por depósito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_9994]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_9994]

GO

/*

(107280,107279)

*/

create procedure DC_CSC_STK_9994 (

  @@us_id        int,
  @@st_numero   int

)as 

begin

set nocount on

  declare @prns_id   int
  declare @pr_id    int
  
  declare c_prns_to_validate insensitive cursor for 
  
  select distinct pr_id, prns_id from stock st inner join stockitem sti on st.st_id = sti.st_id where st_numero = @@st_numero

  open c_prns_to_validate

  fetch next from c_prns_to_validate into @pr_id, @prns_id
  while @@fetch_status = 0 begin

    exec sp_DocStockNroSerieValidate @pr_id, @prns_id
    exec sp_StockNroSerieClienteProveedor @prns_id

    fetch next from c_prns_to_validate into @pr_id, @prns_id
  end

  close c_prns_to_validate

  select 1, 'Se valido el Stock para los siguientes numeros de serie' as Resultado, '' as dummy_col

  union all

  select distinct 2, pr_nombrecompra + ' -NS: ' + prns_codigo as Resultado, '' as dummy_col
  from stock st inner join stockitem sti on st.st_id = sti.st_id 
                inner join producto pr on sti.pr_id = pr.pr_id
                inner join productonumeroserie prns on sti.prns_id = prns.prns_id
  where st_numero = @@st_numero  

end

GO