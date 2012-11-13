/*---------------------------------------------------------------------
Nombre: modifica la fecha de un remito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9998]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9998]

/*
select * from remitoventa where rv_nrodoc = 'x-0001-00001903'
DC_CSC_VEN_9998 1,'2216','20050226'
*/

go
create procedure DC_CSC_VEN_9998 (

  @@us_id     int,
  @@rv_numero varchar(255),
  @@rv_fecha  varchar(255)

)as 
begin
set nocount on

  set nocount on

  update remitoVenta set rv_fecha = @@rv_fecha where rv_numero = @@rv_numero

  select rv_id,
         rv_numero  as Numero,
         rv_nrodoc  as Documento,
         rv_fecha   as Fecha

  from remitoVenta where rv_numero = @@rv_numero

end
go