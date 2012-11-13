if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[str_from_iso_to_acute]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[str_from_iso_to_acute]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function str_from_iso_to_acute  (

@@source varchar(5000)

)

returns varchar(5000)

as
begin

	declare @c 	 varchar(10)
	declare @len int
	declare @n   int
	declare @rtn varchar(5000)

	set @rtn = ''

	set @len = len(@@source)
	set @n = 1
	while @n< @len
	begin

		set @c = substring(@@source,@n,1)

		if ascii(@c) = 225 set @c = 'a'--'&aacute;'
		if ascii(@c) = 233 set @c = 'e'--'&eacute;'
		if ascii(@c) = 237 set @c = 'i'--'&iacute;'
		if ascii(@c) = 243 set @c = 'o'--'&oacute;'
		if ascii(@c) = 250 set @c = 'u'--'&uacute;'
		if ascii(@c) = 241 set @c = 'n'--'&ntilde;'
		if ascii(@c) = 209 set @c = 'N'--'&Ntilde;'

		set @rtn = @rtn + @c

		set @n = @n+1
	end
  return(@rtn)

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

