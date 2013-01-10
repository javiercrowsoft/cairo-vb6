-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*
DC_CSC_STK_0060 7,'20000101','20041231','0','0'
select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0060]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0060]

go
create procedure DC_CSC_STK_0060 

as 

begin

select 

      0                                         as st_id,
      'Pacheco Sur'                              as Deposito,
      'piedra caliza'                            as Articulo, 
      convert(datetime,'20040101')              as Fecha,
      'Mov. Stock'                              as Documento,
      'Factura Compra'                          as [Tipo Documento],
      'A-0001-00000000'                         as [Documento Aux],
      'IBM S.A.'                                as Proveedor,
      'Repsol Y.P.F. S.A.'                      as Cliente,

       100                                        as Cantidad,
      'cajones'                                   as Unidad,

      1.20                                      as [Importe unitario],
      1.500                                      as Importe,

      'H255280992648'                            as [Numero Serie],

      100                                        as [Stock Minimo],
      100000                                     as [Stock Maximo],
      'Oeste'                                   as [Deposito Fisico],
      'Legajo'                                  as [Legajo],
      'Banco Frances'                            as [Centro de Costo]

    from usuario

end
go