select 

  cli_id,
  cli_nombre,
  cli_codigo,

    cli_deudapedido
  +  cli_deudaremito
  +  cli_deudamanifiesto
  +  cli_deudapackinglist
  +  cli_deudactacte,
  (select sum(case doct_id when 13 then -clicc_importe else clicc_importe end) from ClienteCacheCredito where cli_id = cli.cli_id)

from

  cliente cli

where 


    cli_deudapedido
  +  cli_deudaremito
  +  cli_deudamanifiesto
  +  cli_deudapackinglist
  +  cli_deudactacte

<>

isnull((select sum(case doct_id when 13 then -clicc_importe else clicc_importe end) from ClienteCacheCredito where cli_id = cli.cli_id),0)


-- select * from ClienteCacheCredito where cli_id = 6
-- 
-- select * from ClienteCacheCredito where clicc_importe<0 and doct_id = 1
-- select doct_id,* from facturaventa where fv_id in 
-- (select id from ClienteCacheCredito where clicc_importe<0 and doct_id = 1)