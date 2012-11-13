/*---------------------------------------------------------------------
Nombre: Modificar la fecha de una factura
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9999]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9999]

/*
DC_CSC_VEN_9999 1,'119','20051011'
*/

go
create procedure DC_CSC_VEN_9999 (

  @@us_id     int,
  @@fv_numero varchar(255),
  @@fv_fecha  varchar(255)

)as 
begin
set nocount on

  set nocount on

  update FacturaVenta set fv_fecha = @@fv_fecha where fv_numero = @@fv_numero

  select fv_id,
         fv_numero  as Numero,
         fv_nrodoc  as Documento,
         fv_fecha   as Fecha

  from FacturaVenta where fv_numero = @@fv_numero

end
go