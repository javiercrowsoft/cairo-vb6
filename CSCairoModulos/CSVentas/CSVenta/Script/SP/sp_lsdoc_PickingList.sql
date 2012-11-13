/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PickingList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PickingList]


/*

sp_lsdoc_PickingList 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_lsdoc_PickingList (
  @@pkl_id    int
)as 

begin

select 

	pkl_id,
	''                as TypeTask,
	pkl_fecha				  as Fecha,
  pkl_nrodoc				as Numero,
	hr.creado         as Creado,
	hr.modificado     as Modificado,
	us.us_nombre			as Modifico,
	case when pkl_cumplido <> 0 then 'Si' else 'No' end as Cumplida,
	pkl_descrip				as [Descripción]

from 

		PickingList hr	left join Usuario us    on hr.modifico = us.us_id

where 
				  pkl_id = @@pkl_id
end
go



