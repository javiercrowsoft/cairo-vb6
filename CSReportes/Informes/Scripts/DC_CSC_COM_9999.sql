/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9999]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9999]

/*
DC_CSC_COM_9999 1,'119','20051011'
*/

go
create procedure DC_CSC_COM_9999 (

  @@us_id     int,
  @@fc_numero varchar(255),
  @@fc_fecha  varchar(255)

)as 
begin
set nocount on

  set nocount on

  update FacturaCompra set fc_fecha = @@fc_fecha where fc_numero = @@fc_numero

  select fc_id,
         fc_numero  as Numero,
         fc_nrodoc  as Documento,
         fc_fecha   as Fecha

  from FacturaCompra where fc_numero = @@fc_numero

end
go