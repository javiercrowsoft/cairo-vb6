-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*

DC_CSC_STK_0020 7,'20000101','20041231','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0020]

go
create procedure DC_CSC_STK_0020 

as 

begin

select 

      'piedra pomez'                            as Articulo, 
      'Pacheco Norte'                            as Deposito,
       '45000'                                     as Cantidad,
      'BOLSA'                                    as Unidad,
      'C554XP8'                                 as Lote

end
go