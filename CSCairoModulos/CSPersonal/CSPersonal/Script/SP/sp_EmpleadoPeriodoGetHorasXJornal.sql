if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EmpleadoPeriodoGetHorasXJornal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoPeriodoGetHorasXJornal]

go

-- sp_EmpleadoPeriodoGetHorasXJornal 1

create procedure sp_EmpleadoPeriodoGetHorasXJornal (
  @@ccos_id int,
  @@fecha   datetime
)
as

begin

  declare @ems_horas decimal(18,6)
  declare @ccos_id_padre int

  if @@ccos_id <> 0 begin

    select @ems_horas = ems_horas 
    from EmpleadoSemana 
    where ems_fecha = @@fecha
      and ccos_id   = @@ccos_id

    if @ems_horas is null begin
  
      select @ccos_id_padre = ccos_id_padre from CentroCosto where ccos_id = @@ccos_id
  
      select @ems_horas = ems_horas 
      from EmpleadoSemana 
      where ems_fecha = @@fecha
        and ccos_id   = @ccos_id_padre

    end

  end

  if @ems_horas is null begin

    select @ems_horas = ems_horas 
    from EmpleadoSemana 
    where ems_fecha = @@fecha
      and ccos_id is null

  end

  select @ems_horas

end

go