if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockClienteGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockClienteGet]

go

/*

sp_DocStockClienteGet 8,7

*/

create procedure sp_DocStockClienteGet (
  @@emp_id         int,
  @@stcli_id      int,
  @@us_id          int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
declare @doc_id        int
declare @ta_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint


  select @doc_id = doc_id from StockCliente where stcli_id = @@stcli_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocStockClienteEditableGet @@emp_id, @@stcli_id, @@us_id, @bEditable out, @editMsg out

  select 
      stcli.*,
      cli_nombre,
      origen.depl_nombre   as [Origen],
      destino.depl_nombre as [Destino],
      origen.depf_id,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      suc_nombre,
      doc_nombre,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      StockCliente stcli    
                  inner join cliente cli              on stcli.cli_id = cli.cli_id
                  inner join documento doc             on stcli.doc_id  = doc.doc_id
                  inner join sucursal suc              on stcli.suc_id  = suc.suc_id
                  inner join DepositoLogico origen    on stcli.depl_id_origen  = origen.depl_id
                  inner join DepositoLogico destino    on stcli.depl_id_destino = destino.depl_id
                  left  join legajo lgj                on stcli.lgj_id  = lgj.lgj_id

  where stcli_id = @@stcli_id

end