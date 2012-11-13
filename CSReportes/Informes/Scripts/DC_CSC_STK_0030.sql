-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*

DC_CSC_STK_0030 7,'20000101','20041231','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0030]

go
create procedure DC_CSC_STK_0030 

as 

begin

select 

			'Marmol'  																as Articulo, 
			convert (datetime, '20040101')            as Fecha,
			'Pacheco Oeste'								   					as Deposito,
			'445'																			as [Stock anterior],
			'120'																			as Egreso,
			'150'																			as Ingreso,
			'50'																			as [Stock Actual],
 			'FACT A'											   					as Documento,
			'A-45000122'														  as Numero,
			'Piedra Libre S.R.L.'									    as Proveedor,
			'Factura'         											  as Comprobante


end
go