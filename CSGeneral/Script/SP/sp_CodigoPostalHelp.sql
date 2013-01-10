if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_CodigoPostalHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CodigoPostalHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_CodigoPostalHelp 0,0,0,0,'elcano',0,0,''

*/
create procedure sp_CodigoPostalHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@bFilterType     tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@cpa_id          int           = 0,
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

    if @@cpa_id < 0 begin

      select @@cpa_id = cpa_id from CodigoPostalItem where cpai_id = @@cpa_id *-1

    end
  
    select   cpa_id,
            cpa_codigo        as Nombre,
            cpa_codigo        as Codigo

    from CodigoPostal cpa

    where (cpa_codigo = @@filter)
      and (cpa_id = @@cpa_id or @@cpa_id=0)
      and (@@bForAbm <> 0 or cpa.activo <> 0)

  end else begin

    select top 50
            -cpai.cpai_id as cpa_id,
            cpa_codigo    as [Codigo Postal], 
            case cpai_tipo when 1 then cpai_calle else cpai_localidad end as [Calle/Localidad], 
            cpai_desde    as Desde, 
            cpai_hasta    as Hasta, 
            pro_nombre    as Provincia

    from CodigoPostal cpa inner join CodigoPostalItem cpai on cpa.cpa_id = cpai.cpa_id
                          inner join Provincia pro on cpa.pro_id = pro.pro_id

    where (cpa_codigo like @filter
            or (cpai_calle like @filter and cpai_tipo = 1)
            or (cpai_localidad like @filter and cpai_tipo = 2)
            or @@filter = ''
          )
            and ((cpai_desde <= @altura and cpai_hasta >= @altura) or @altura = 0)

      and (@@bForAbm <> 0 or cpa.activo <> 0)

  end    
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

