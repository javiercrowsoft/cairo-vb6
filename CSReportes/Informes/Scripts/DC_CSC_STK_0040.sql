-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*

DC_CSC_STK_0040 7,'20000101','20041231','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0040]

go
create procedure DC_CSC_STK_0040 

as 

begin

select 

			'Warning'																	as warning,
			'Lajas'   																as Articulo, 
			'Compras utiles'													as [Centro de Costo],
			convert (datetime, '20040101')            as Fecha,
 			'FACT A'											   					as Documento,
			'A-45000122'														  as Numero,
			'Factura'         											  as Comprobante,
			'lalalalalal'															as Detalle,
			'45.22'																		as Valor,
			'150'																			as Ingreso,
			'853'																			as [Importe Ingresos],
			'120'																			as Egreso,
			'53'																			as [Importe Egresos],
			'50'																			as [Stock Actual],
			'4.45'																		as [Importe Actual]


end
go