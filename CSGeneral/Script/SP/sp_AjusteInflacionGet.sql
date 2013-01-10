if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AjusteInflacionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AjusteInflacionGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_AjusteInflacionGet  3

create procedure sp_AjusteInflacionGet  (
  @@aje_id  int
)
as

set nocount on

begin

  declare @ccos_nombre varchar(255)
  declare @ccos_id     varchar(255)

  select @ccos_id = ccos_id from AjusteInflacion where aje_id = @@aje_id

  if isnumeric(@ccos_id) <> 0 begin

    declare @ccos_id_real int
    select @ccos_id_real = convert(int,@ccos_id)

    select @ccos_nombre = ccos_nombre from CentroCosto where ccos_id = @ccos_id

  end else begin

    if substring(@ccos_id,1,1)='n' begin
      set @ccos_id = substring(@ccos_id,2,len(@ccos_id))

      if isnumeric(@ccos_id) <> 0 begin
        select @ccos_nombre = ram_nombre from rama where ram_id = convert(int,@ccos_id)
      end
    end

  end

  select 
          aje.*,
          cuep.cue_nombre as cuenta_patrimonial,
          cuer.cue_nombre as cuenta_resultados,
          @ccos_nombre    as ccos_nombre

  from AjusteInflacion aje inner join Cuenta cuep on aje.cue_id_patrimonial = cuep.cue_id
                           inner join cuenta cuer on aje.cue_id_resultados  = cuer.cue_id

  where aje.aje_id = @@aje_id 


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



