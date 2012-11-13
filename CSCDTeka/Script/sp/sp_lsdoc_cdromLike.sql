if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_cdromLike]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_cdromLike]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_lsdoc_cdromLike '','',''

create procedure sp_lsdoc_cdromLike (
  @@carpeta   varchar(255),
  @@archivo   varchar(255),
	@@tipo      varchar(255)
)
as

set nocount on

begin

select 

		top 1000

		HideCol = 1,
		TypeCD  = '',
	  CD      = cd_nombre,
    Codigo  = cd_codigo,
		Carpeta = cdc_nombre,
    Archivo = cda_nombre,
    Path    = cda_path
	from 
	  cdrom cd,
		cdromcarpeta carp,
		cdromarchivo a
	where 
		-- Joins
		cd.cd_id              = carp.cd_id  and
		carp.cdc_id           = a.cdc_id    and

		-- Filtros
		(
			  	(cda_nombre  like @@archivo  or @@archivo	= '')
			and	(cdc_nombre	 like @@carpeta  or @@carpeta	= '')
			and	(cda_tipo    like @@tipo  	 or @@tipo	  = '')
		) 
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go

