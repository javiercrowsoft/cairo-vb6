if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_CalleHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CalleHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_CalleHelp 0,0,0,0,'elcano',0,0,''

*/
create procedure sp_CalleHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@bFilterType     tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@calle_id          int           = 0,
  @@filter2         varchar(255)  = ''
)
as
begin

  set nocount on
  
  declare @altura int
  declare @n int
  declare @s varchar(50)

  set @altura = 0
  set @n = len(@@filter)
  while @n > 0
  begin

    if substring(@@filter,@n,1)=' ' begin

      set @s = substring(@@filter,@n,50)

      if isnumeric(@s)<>0 begin
        set @altura = convert(int,@s)
        set @@filter = substring(@@filter,1,@n-1)
      end

      set @n = 0

    end
    set @n = @n-1
  end

--/////////////////////////////////////////////////////////////////////////////////////

  declare @filter varchar(255)
  set @filter = @@filter
  exec sp_HelpGetFilter @@bFilterType, @filter out

--/////////////////////////////////////////////////////////////////////////////////////
  
  if @@check <> 0 begin

    if @@calle_id < 0 begin

      select @@calle_id = calle_id from CalleAltura where callea_id = @@calle_id *-1

    end
  
    select   calle_id,
            calle_codigo        as Nombre,
            calle_codigo        as Codigo

    from Calle calle

    where (calle_codigo = @@filter)
      and (calle_id = @@calle_id or @@calle_id=0)
      and (@@bForAbm <> 0 or calle.activo <> 0)

  end else begin

    select top 50
            -callea.calle_id   as calle_id,
            calle_nombre      as Calle,
            callea_desde      as Desde, 
            callea_hasta      as Hasta

    from Calle calle inner join CalleAltura callea on calle.calle_id = callea.calle_id

    where (calle_codigo like @filter
            or calle_nombre like @filter
            or @@filter = ''
          )
            and ((callea_desde <= @altura and callea_hasta >= @altura) or @altura = 0)

      and (@@bForAbm <> 0 or calle.activo <> 0)

  end    
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

