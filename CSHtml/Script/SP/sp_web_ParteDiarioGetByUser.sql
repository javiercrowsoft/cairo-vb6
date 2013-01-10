if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioGetByUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioGetByUser]

/*

 sp_web_ParteDiarioGetByUser 1

*/

go
create procedure sp_web_ParteDiarioGetByUser (

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
                                @@us_id,
                                0
end