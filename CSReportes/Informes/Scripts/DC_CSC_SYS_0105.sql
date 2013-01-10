/*---------------------------------------------------------------------
Nombre: Realiza un backup de la base de datos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0105]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0105]

/*

 select * from TmpStringToTable

 DC_CSC_SYS_0105 1, 'cairo','d:\cairo'

*/

go
create procedure DC_CSC_SYS_0105 (

  @@us_id          int,

  @@size           smallint

)as 
begin
set nocount on

  exec sp_force_shrink_log @target_size_MB=100

end
go