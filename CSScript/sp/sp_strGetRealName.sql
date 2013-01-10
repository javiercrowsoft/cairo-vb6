if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_strGetRealName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strGetRealName]

go
create procedure sp_strGetRealName (
  @@prefix varchar (255),
  @@campo   varchar (1000) output
)
as

declare @j int

set @j = isnull(charindex('=',@@campo,1),0)

if @j = 0 
  set @@campo = @@prefix + '.' + @@campo
else
  set @@campo = substring(@@campo,1,@j) + @@prefix + '.' + ltrim(substring(@@campo,@j+1,len(@@campo)))

