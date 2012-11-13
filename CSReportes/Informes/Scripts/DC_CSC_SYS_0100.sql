/*---------------------------------------------------------------------
Nombre: Realiza un backup de la base de datos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0100]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0100]

/*

 select * from TmpStringToTable

 DC_CSC_SYS_0100 1, 'cairo','d:\cairo'

*/

go
create procedure DC_CSC_SYS_0100 (

  @@us_id          int,

	@@database       varchar(255),
	@@file           varchar(260)

)as 
begin
set nocount on

	BACKUP DATABASE @@database TO DISK=@@file WITH NOUNLOAD ,  NOSKIP,  INIT

	if @@error<>0 select 1, 'No se pudo realizar el backup' as Error
	else          select 2, 'El backup se realizo con éxito' as Resultado


end
go