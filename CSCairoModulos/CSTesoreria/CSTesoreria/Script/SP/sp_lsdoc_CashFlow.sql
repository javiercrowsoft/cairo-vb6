
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_CashFlow]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_CashFlow]

go
create procedure sp_lsdoc_CashFlow (
@@cf_id int
)as 
begin

	select 
				cf_id,
				''									  as [TypeTask],
				cf_nombre							as [Título],
	
				cf_fecha						  as [Fecha],
				cf_fechadesde         as [Fecha Desde],
				cf_fechahasta         as [Fecha Hasta],
				cue_nombre            as Cuenta,
				us_nombre             as Modifico,
				cf.Creado,
				cf.Modificado,
				cf_descrip						as [Observaciones]
	from 
				CashFlow cf inner join Usuario us on cf.modifico = us.us_id
										left  join Cuenta cue on cf.cue_id = cue.cue_id
	
	where 
				@@cf_id = cf_id

end
