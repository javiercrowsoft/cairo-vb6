/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de ordenes de pago
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9995]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9995]

/*

select * from documento where doct_id = 2

select * from facturacompra

[DC_CSC_COM_9995] 1,2,20

*/

go
create procedure DC_CSC_COM_9995 (

  @@us_id        int,

  @@numero      int,
  @@doc_id      int

)as 
begin

  set nocount on

  declare @as_id int
  declare @fc_id int

  if not exists(select * from Documento where doc_id = @@doc_id and doct_id in(2,8,10)) begin

    select 1 as aux_id, 'El documento no es valido' as Infor, '' as dummy_col
    return

  end

  select @fc_id = fc_id, @as_id = as_id from FacturaCompra where fc_numero = @@numero

  if @fc_id is not null begin

    if @as_id is not null
      update Asiento set doc_id_cliente = @@doc_id where as_id = @as_id

    update FacturaCompra set doc_id = @@doc_id where fc_id = @fc_id
    select 1 as aux_id, 'La factura fue modificada' as Infor, '' as dummy_col

  end else begin

    select 1 as aux_id, 'No existe una factura con el numero ' + convert(varchar, @@numero) as Infor, '' as dummy_col

  end
end
go
 