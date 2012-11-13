if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProveedorGetDataAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProveedorGetDataAdd]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

	select * from Proveedor

  sp_ProveedorGetDataAdd 2

update Proveedor set prov_calle = c.prov_calle, prov_localidad = c.prov_localidad,prov_callenumero = c.prov_callenumero, prov_piso = c.prov_piso, prov_tel = c.prov_tel, prov_fax = c.prov_fax, prov_email = c.prov_email
from Proveedor c where c.prov_id = 9 and len(prov_callenumero) = 0

*/

create procedure sp_ProveedorGetDataAdd (
	@@prov_id	int
)
as

set nocount on

begin

	declare @rz 				varchar(255)
	declare @tel 				varchar(255)
	declare @cuit				varchar(255)
	declare @dir 				varchar(255)
	declare @tel2 			varchar(255)

	select

						@rz   = 'RZ: ' + prov_razonsocial,
						@cuit = '(' + prov_cuit + ')',
            @tel  = 'Tel: ' + prov_tel,

						@dir  = prov_calle + ' ' + 
										prov_callenumero + ' ' + 
										prov_piso + ' ' + 
										prov_codpostal + ' ' + 
										case when prov_localidad <> isnull(pro_nombre,'') then prov_localidad + ' ' 
												 else '' 
										end	+									
                    isnull(pro_nombre,'') + ' ' +
                    isnull(pa_nombre,''),

						@tel2 = 'Tel: ' + 
										prov_tel  + ' fax:' + 
										prov_fax  + ' mail: ' + 
										prov_email  + ' web:' + 
										prov_web

	from Proveedor prov left join Provincia pro 			on prov.pro_id = pro.pro_id
									    left join Pais pa       			on pro.pa_id  = pa.pa_id

	where prov_id = @@prov_id

	select  ''
				+ ' ' +	@rz 
				--+ ' ' + @cuit
				--+ ' ' + @tel 
				+ ' ' + @dir 
				+ ' ' + @tel2 

				as Info

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



