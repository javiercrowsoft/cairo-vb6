if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioGet]

/*

 sp_web_ParteDiarioGet 1

*/

go
create procedure sp_web_ParteDiarioGet (

  @@us_id int

)
as

begin

  set nocount on

  exec sp_web_ParteDiarioGetEx 
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                '20000101',
                                '21000101',
                                @@us_id

end
go