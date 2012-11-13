if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getLeyendas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getLeyendas]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_getLeyendas  1, '74520017'

create procedure sp_srv_cvxi_getLeyendas (
	@@cmi_id			int,
	@@articuloId 	varchar(255)
)
as

set nocount on

begin

	declare @pr_id int

	select @pr_id = pr_id from ProductoComunidadInternet where prcmi_codigo = @@articuloId

	declare @cmi_codigo varchar(15)
	select @cmi_codigo = cmi_codigo from ComunidadInternet where cmi_id = @@cmi_id

	select  	ley_nombre  as nombre,
            ley_codigo  as orden,
						convert(varchar(5000),ley_texto) 	
												as texto
					
	from Leyenda

	where (		charindex(ley_descrip,'cvxi')<>0 
				and charindex(ley_descrip,'-' + @cmi_codigo)<>0
				)
		or ley_descrip = 'cvxi'

	union all

	select  	prl_nombre  as nombre,
            prl_orden   as orden,
						prl_texto 	as texto
					
	from ProductoLeyenda

	where pr_id = @pr_id
		and (charindex(prl_tag,'-' + @cmi_codigo)<>0 or prl_tag = '')

	order by orden

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



