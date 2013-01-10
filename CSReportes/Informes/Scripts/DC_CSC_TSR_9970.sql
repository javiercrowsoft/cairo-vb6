/*---------------------------------------------------------------------
Nombre: Lista las diferencias entre una conciliacion 
        y el estado actual de la cuenta conciliada
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_9970 1,20


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9970]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9970]

go
create procedure DC_CSC_TSR_9970 (

  @@us_id    int,

  @@bcoc_id  int

)as 

begin

set nocount on

  exec frBancoConciliacionDif @@bcoc_id

end
go