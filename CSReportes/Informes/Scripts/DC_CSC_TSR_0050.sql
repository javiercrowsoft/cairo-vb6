-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Facturas de clientes a cobrar
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0050 7,'20000101','20041231','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0050]

go
create procedure DC_CSC_TSR_0050 

as 

begin

select 

      'Lopez GOnzalez'                          as Cliente, 
      convert (datetime, '20040101')            as Vencimiento,
       convert (datetime,'20040101')             as [Fecha corregida],
       convert (datetime,'20040101')             as Fecha,
      'Cabildo 1547'                            as Direccion,
      '4702 6999'                                as Telefono,
      'Factura'                                 as Documento,
      'C-125500014'                              as Comprobante,
      convert (decimal(18,6), 1.6)              as Importe,
      'VE'                                      as [Tipo asiento],
      'Pendiente'                                as Estado,
      'Jose Lopez'                               as Proveedores,
      convert (decimal(18,6), 1.6)              as [Moneda extranjera],
      convert (decimal(18,6), 1.6)              as [Importe Moneda ext.],
      'Casa central'                             as Sucursal,
      '20040101'                                 as Mes
end
go