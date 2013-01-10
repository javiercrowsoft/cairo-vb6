if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_talonarioGetNextNumber]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_talonarioGetNextNumber]

go

/*

declare @ta_nrodoc varchar(100)

exec sp_talonarioGetNextNumber 2, @ta_nrodoc out

select @ta_nrodoc

*/

create procedure sp_talonarioGetNextNumber (
  @@ta_id           int,
  @@ta_nrodoc       varchar(100) out,
  @@bSelect         tinyint = 0
)
as

begin
  declare @ta_ultimonro int
  declare @ta_mascara   varchar(100)
  declare @lenmascara   smallint

  select  @ta_ultimonro = ta_ultimonro, 
          @ta_mascara = ta_mascara
  from talonario 
  where ta_id = @@ta_id

  set @@ta_nrodoc = convert(varchar(100),@ta_ultimonro+1)
  set @lenMascara = len(@ta_mascara) - len(@@ta_nrodoc)

  if @lenMascara > 0 set @@ta_nrodoc = substring(@ta_mascara,1,@lenMascara) + @@ta_nrodoc

  if @@bSelect <> 0 select @@ta_nrodoc as ta_nrodoc

end

go