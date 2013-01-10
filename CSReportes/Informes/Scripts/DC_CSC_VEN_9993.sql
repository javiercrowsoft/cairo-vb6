/*

Permite asociar rapidamente una lista de precios a un conjunto de clientes.

[DC_CSC_VEN_9993] 1,'0','24',-1

OJO: Actualmente esta muy verde, y asocia a todos los clientes la lista 10.

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9993]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9993]


go
create procedure DC_CSC_VEN_9993 (

  @@us_id        int,

  @@cli_id           varchar(255) 

)as 
begin

  set nocount on

  exec lsCliente @@cli_id

end
go
 