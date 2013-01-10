/*---------------------------------------------------------------------
Nombre: Modifica el documento de una Cobranza
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9997]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9997]

/*

select * from documento where doct_id = 13

select * from cobranza where doct_id = 13

[DC_CSC_TSR_9997] 1,10,172

*/

go
create procedure DC_CSC_TSR_9997 (

  @@us_id        int,

  @@numero      int,
  @@doc_id      int

)as 
begin

  set nocount on

  declare @as_id int
  declare @cobz_id int

  if not exists(select * from Documento where doc_id = @@doc_id and doct_id = 13) begin

    select 1 as aux_id, 'El documento no es valido' as Infor, '' as dummy_col
    return

  end

  select @cobz_id = cobz_id, @as_id = as_id from Cobranza where cobz_numero = @@numero

  if @cobz_id is not null begin

    if @as_id is not null
      update Asiento set doc_id_cliente = @@doc_id where as_id = @as_id

    update Cobranza set doc_id = @@doc_id where cobz_id = @cobz_id
    select 1 as aux_id, 'La cobranza fue modificada' as Infor, '' as dummy_col

  end else begin

    select 1 as aux_id, 'No existe una cobranza con el numero ' + convert(varchar, @@numero) as Infor, '' as dummy_col

  end
end
go
 