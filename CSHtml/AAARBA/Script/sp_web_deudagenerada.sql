if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_deudaGenerada]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_deudaGenerada]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_deudaGenerada 13

sp_columns cuenta_corriente_asociados

*/

go
create procedure sp_web_deudaGenerada (
  @@proveedor     int,
  @@empresa       int,
	@@concepto 			int
)
as

begin

	set nocount on

	if exists(select * from cuenta_corriente_asociados 
						where concepto 					= @@concepto 
							and asociado   				= @@proveedor 
							and empresa         	= @@empresa
							and tipo_comprobante	= 44)

			select -1
	else
			select 0
end

go
