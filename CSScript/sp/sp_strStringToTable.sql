if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_strStringToTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strStringToTable]

go
create procedure sp_strStringToTable (
  @@Codigo    datetime,
  @@aBuscar   varchar (5000),
  @@Separador  varchar (1) = ' '
)
as

set nocount on

declare @i     smallint
declare @s    varchar(255)

SET @@aBuscar = Rtrim(Ltrim(ISNULL ( @@aBuscar , '')))

while len(@@aBuscar)>0 begin

  set @i = 1
  while @i <= len(@@aBuscar) and len(@@aBuscar)>0
  begin
    set @s = substring(@@aBuscar,@i,1)
    if @s = @@Separador goto FinWhile2
    set @i = @i + 1
  end
  FinWhile2:

  if @s = @@Separador begin
    insert into TmpStringToTable (tmpstr2tbl_campo,tmpstr2tbl_id)
    values(ltrim(substring(@@aBuscar,1,@i-1)),@@Codigo)
  end else begin
    insert into TmpStringToTable (tmpstr2tbl_campo,tmpstr2tbl_id)
    values(ltrim(substring(@@aBuscar,1,@i)),@@Codigo)
  end

  set @i = @i + 1
  set @@aBuscar = ltrim(substring(@@aBuscar,@i,len(@@aBuscar)))
end
