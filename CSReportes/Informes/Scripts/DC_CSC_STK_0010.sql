-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*

DC_CSC_STK_0010 7,'20000101','20041231','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0010]

go
create procedure DC_CSC_STK_0010 

as 

begin

select 

			'piedra caliza'	  												as Articulo, 
			'Pacheco Sur'									            as Deposito,
 			'45000'												   					as Cantidad,
			'cajones'												 					as Unidad,
			'1.500'																	  as Importe,
			'1.20'      		    									    as [Importe unitario],
			'DISCRIMINADOR1'													as Discriminador1,
			'DISCRIMINADOR2'													as Discriminador2,
			'5800'																		as [Punto de Reposicion],
			'350'			         											  as [Stock Minimo],
			'700'			         											  as [Stock Maximo],
			'PicaPiedra Zuli S.A.' 									  as Proveedor,
			'C-4.23' 		      											  as [Lugar Fisico]

end
go