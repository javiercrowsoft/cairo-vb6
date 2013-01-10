if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getPreguntasByNick]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getPreguntasByNick]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_getPreguntasByNick  3

create procedure sp_srv_cvxi_getPreguntasByNick (
  @@cmi_id      int,
  @@nick        varchar(255),
  @@articuloId   varchar(255)
)
as

set nocount on

begin

  select  convert(varchar,cmip_fecha,105) 
          + convert(varchar(5),cmip_fecha,14) 
          + ' ' + isnull(cmipr_nombre,'(' + cmip_articuloid + ')')
          + '## ' + cmip_pregunta   as pregunta,
          cmip_respuesta   as respuesta
          
  from ComunidadInternetPregunta cp left join ComunidadInternetProducto cpr 
          on case when charindex(' ',cp.cmip_articuloid) <> 0 then ltrim(rtrim(substring(cp.cmip_articuloid,1,charindex(' ',cp.cmip_articuloid))))
                  else cp.cmip_articuloid
              end = cmipr_codigo

  where cmip_nick = @@nick
    and (cmip_articuloId <> @@articuloId or @@articuloId = '')
    and cp.cmi_id = @@cmi_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



