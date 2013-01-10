/*---------------------------------------------------------------------
Nombre: Modifica el documento de un Movimiento de Fondos
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9995]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9995]

/*

select * from documento where doct_id = 26

select * from movimientofondo where doct_id = 26

[DC_CSC_TSR_9995] 1,1,94

*/

go
create procedure DC_CSC_TSR_9995 (

  @@us_id        int,

  @@numero      int,
  @@doc_id      int

)as 
begin

  set nocount on

  declare @as_id int
  declare @mf_id int

  if not exists(select * from Documento where doc_id = @@doc_id and doct_id = 26) begin

    select 1 as aux_id, 'El documento no es valido' as Infor, '' as dummy_col
    return

  end

  select @mf_id = mf_id, @as_id = as_id from MovimientoFondo where mf_numero = @@numero

  if @mf_id is not null begin

    if @as_id is not null
      update Asiento set doc_id_cliente = @@doc_id where as_id = @as_id

    update MovimientoFondo set doc_id = @@doc_id where mf_id = @mf_id
    select 1 as aux_id, 'El movimiento de fondos fue modificado' as Infor, '' as dummy_col

  end else begin

    select 1 as aux_id, 'No existe un movimiento de fondos con el numero ' + convert(varchar, @@numero) as Infor, '' as dummy_col

  end
end
go
 