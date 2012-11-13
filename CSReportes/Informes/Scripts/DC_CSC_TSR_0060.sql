-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Caja
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0060 7,'20000101','20041231','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0060]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0060]

go
create procedure DC_CSC_TSR_0060 

as 

begin

select 
 			convert (datetime,'20040101')   					as Fecha,
			'Factura'         											  as Documento,
			'C-125500014'      											  as Comprobante,
			'Jose Lopez'       											  as Proveedores,
      'PAGO ATRASADO M.J.'                      As Descrip,
      'mercaderias'                             as cuenta,
			convert (decimal(18,6), 1.6)	      		  as Haber,
			convert (decimal(18,6), 2.6)	      		  as DEBe,
			convert (decimal(18,6), 2.5)	      		  as Impuestos,            
      'tipo'                                    as Tipo,
      'Orden'                                   as Orden,    
      'Resumido'                                as Resumido
                            
end
go