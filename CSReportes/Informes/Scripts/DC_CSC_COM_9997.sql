/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9997]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9997]

/*
DC_CSC_COM_9997 1,'241','20080828',49.67
*/

go
create procedure DC_CSC_COM_9997 (

  @@us_id     int,
  @@fc_numero varchar(255),
  @@dia       smallint

)as 
begin
set nocount on

  set nocount on

  if @@dia < 1 or @@dia > 31 begin

    select 1 as aux_id, 'El valor para el parametro dia debe estar entre 1 y 31.' as Info, '' as dummy_col

    return

  end

  declare @fc_id int
  declare @fcd_id int

  select @fc_id = fc_id from FacturaCompra where fc_numero = @@fc_numero

  if @fc_id is null begin

    select 1 as aux_id, 'No se encontro una factura con numero interno igual a ' + @@fc_numero + '.' as Info, '' as dummy_col

  end else begin

    if exists(select * from FacturaCompraOrdenPago where fcd_id in (select fcd_id from FacturaCompraDeuda where fc_id = @fc_id)) begin

      select 1 as aux_id, 'La factura posee aplicaciones, debe desaplicarla para poder modificar el vto.' as Info, '' as dummy_col

      return

    end

    if exists(select * from FacturaCompraNotaCredito where fc_id_factura = @fc_id or fc_id_notacredito = @fc_id) begin

      select 1 as aux_id, 'La factura posee aplicaciones, debe desaplicarla para poder modificar el vto.' as Info, '' as dummy_col

      return

    end

    declare c_vtos insensitive cursor for select fcd_id from FacturaCompraDeuda where fc_id = @fc_id

    open c_vtos

    fetch next from c_vtos into @fcd_id
    while @@fetch_status=0
    begin

      update FacturaCompraDeuda set fcd_fecha = dateadd(d,@@dia,dateadd(d,-day(fcd_fecha),fcd_fecha))
      where fcd_id = @fcd_id

      fetch next from c_vtos into @fcd_id
    end
    close c_vtos
    deallocate c_vtos

    select 1 as aux_id, 'El día de los vencimientos se modificaron con exito' as Info, '' as dummy_col

  end

end
go