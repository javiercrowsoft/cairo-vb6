if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_InfoParteDiario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_InfoParteDiario]

go
/*

*/
create procedure sp_InfoParteDiario (
  @@ptd_id int
)
as

set nocount on

select ptd_titulo, ptd_descrip from partediario where ptd_id = @@ptd_id