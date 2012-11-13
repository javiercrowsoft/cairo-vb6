if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionEsEditable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionEsEditable]

/*


*/

go
create procedure sp_web_InscripcionEsEditable (
  @@insc_id   int
)
as

begin

	set nocount on

	declare @est_id 					int
	declare @aabainsc_pagada 	tinyint
	declare @insc_categoria   int

	select @est_id 						= est_id, 
				 @insc_categoria 		= insc_categoria,
				 @aabainsc_pagada 	= aabainsc_pagada

	from aaarbaweb..inscripcion 

	where insc_id = @@insc_id

	if (@est_id = 5 or @aabainsc_pagada <> 0) and @insc_categoria not in (4,7,8)

			select 0 as editable

	else
			select 1 as editable

end

go
