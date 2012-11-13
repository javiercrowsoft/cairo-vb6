/*

sp_lsdoc_Garantia 

										1,
										'20000101',
										'20100101',
										'20100101',
										'0',
										'0',
										'',
										'',
										''

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Garantia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Garantia]

GO
create procedure sp_lsdoc_Garantia (

	@@gar_id int

)as 

select 

				gar_id,							
  			''									    as [TypeTask],
				gar_codigo							as [Codigo],
				gar_nropoliza						as [Nro. Poliza],
				gar_codigoaduana				as [Codigo Aduana],
				gar_fecha								as [Fecha],
				gar_fechainicio					as [Fecha Inicio],
				gar_fechavto						as [Fecha Vto.],
				gar_monto								as [Monto],
				gar_cuota								as [Cuota],
				gar_diavtocuota					as [Dia Vto. Cuota],
				prov_nombre							as [Aseguradora],
				mon_nombre							as [Moneda],
				us_nombre								as [Modifico],
				Garantia.creado					as [Creado],
				Garantia.modificado			as [Modificado],
				gar_descrip							as [Observaciones]

from 

			Garantia inner join Proveedor on Garantia.prov_id = Proveedor.prov_id
               inner join Moneda    on Garantia.mon_id = Moneda.mon_id
               inner join Usuario   on Garantia.modifico = Usuario.us_id

where 

				  gar_id = @@gar_id

GO