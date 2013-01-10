if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockGet]

go

/*

sp_DocStockGet 8,7

*/

create procedure sp_DocStockGet (
  @@emp_id   int,
  @@st_id    int,
  @@us_id    int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
declare @doc_id        int
declare @ta_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint


  select @doc_id = doc_id from Stock where st_id = @@st_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocStockEditableGet @@emp_id, @@st_id, @@us_id, @bEditable out, @editMsg out

  select 
      st.*,
      doct_nombre + ' ' + st_doc_cliente as doc_cliente,
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
      Stock st    inner join documento doc             on st.doc_id  = doc.doc_id
                  inner join sucursal suc              on st.suc_id  = suc.suc_id
                  inner join DepositoLogico origen    on st.depl_id_origen  = origen.depl_id
                  inner join DepositoLogico destino    on st.depl_id_destino = destino.depl_id
                  left  join legajo lgj                on st.lgj_id  = lgj.lgj_id
                  left  join documentotipo doct       on st.doct_id_cliente = doct.doct_id

  where st_id = @@st_id

end