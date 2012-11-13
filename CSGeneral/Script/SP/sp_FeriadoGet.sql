if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FeriadoGet ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FeriadoGet ]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_FeriadoGet  35639

*/

go
create procedure sp_FeriadoGet  (
	@@fe_id 		int
)
as

begin

	set nocount on

	select  fe.*,
					pa_nombre,
					pro_nombre

	from Feriado fe left join Pais pa 			on fe.pa_id  = pa.pa_id
									left join Provincia pro on fe.pro_id = pro.pro_id

	where fe_id = @@fe_id

end

go