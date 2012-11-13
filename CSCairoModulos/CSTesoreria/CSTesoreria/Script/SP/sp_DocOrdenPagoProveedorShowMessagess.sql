if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoProveedorShowMessagess]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoProveedorShowMessagess]

go

-- select * from proveedor where prov_id = 23

-- update proveedor set prov_cuit = '20-00000016-8' where prov_id = 23

-- sp_col ARBA_Deudores

-- sp_DocOrdenPagoProveedorShowMessagess 22, 1

-- select * from ARBA_Deudores where arbad_cuit in (select replace(prov_cuit, '-','') from proveedor)

create procedure sp_DocOrdenPagoProveedorShowMessagess (
	@@prov_id     int,
	@@emp_id      int
)
as

begin

	declare @cuit varchar(50)

	select @cuit = replace(prov_cuit, '-', '') from Proveedor where prov_id = @@prov_id

	if exists(select * from ARBA_Deudores where arbad_cuit = @cuit) 
		select 'Este proveedor figura en el padron de deduores de ARBA con los siguientes datos:'

						+ char(10) + char(13)
						+ 'Fecha: ' + arbad_archivo
						+ char(10) + char(13)
						+ 'Saldo: ' + convert(varchar,convert(decimal(18,2),arbad_deuda))

		from ARBA_Deudores

		where arbad_cuit = @cuit

	else

		select '' where 1=2

end