if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_generarDeuda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_generarDeuda]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_generarDeuda 13

sp_columns cuenta_corriente_asociados

*/

go
create procedure sp_web_generarDeuda (
	@@concepto 			int,
  @@empresa       int,
  @@proveedor     int,
	@@importe 			decimal(18,6),
	@@importe_neto  decimal(18,6),
	@@gravamen      decimal(18,2),
	@@cpg_id        int
)
as

begin

	set nocount on

	declare @ivacate 					int
	declare @nro_movimiento		int
	declare @nro_comprobante  int

	select @ivacate = iva from proveedores where proveedor = @@proveedor

	select @nro_movimiento = max(nro_movimiento), 
				 @nro_comprobante = max(nro_comprobante) 
	from cuenta_corriente_asociados 
	where empresa = @@empresa

	set @nro_movimiento  = isnull(@nro_movimiento,0)+1
	set @nro_comprobante = isnull(@nro_comprobante,0)+1

	insert into cuenta_corriente_asociados (		nro_movimiento,
																							empresa,
																							tipo_comprobante,
																							nro_comprobante,
																							asociado,
																							rendidor,
																							importe,
																							saldo_aplicado,
																							fecha,
																							estado,
																							concepto,
																							tipo_de_iva,
																							importe_neto,
																							gravamen_aplicado,
																							tipo_comp_generador,
																							nro_comp_generador,
																							fecha_venc,
																							medio_pago,
																							periodo

																					) values(

																							@nro_movimiento,
																							@@empresa,
																							44,
																							@nro_comprobante,
																							@@proveedor,
																							0,
																							@@importe,
																							@@importe,
																							getdate(),
																							/* Para que puedan modificarla en tesoreria
																											- si es para debito por honorarios debe ser 1
																											- si es para facturar debe ser 2
																							*/
																							case @@cpg_id
																								when 5 then 1
																								else        2
																							end, 
																							@@concepto,
																							@ivacate,
																							@@importe_neto,
																							@@gravamen,
																							0,
																							0,
																							getdate(),
																							null,
																							convert(varchar(6),getdate(),112)
																					)
	

	select @nro_movimiento as deuda, @@proveedor as proveedor
end

go

-- select * from cuenta_corriente_asociados
-- delete cuenta_corriente_asociados
-- select convert(varchar(6),getdate(),112)