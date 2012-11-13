if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_talonarioNoDocGetPropuesto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_talonarioNoDocGetPropuesto]

go

/*

*/

create procedure sp_talonarioNoDocGetPropuesto (
	@@ta_id           int,
	@@ta_Mascara			varchar(100) out,
	@@ta_Propuesto		tinyint out,
	@@ta_tipo         smallint = 0 out
)
as

begin

  select 	@@ta_Mascara 		= ta_mascara, 
					@@ta_Propuesto 	= ta_tipo, 
					@@ta_tipo				= ta_tipo 
	from Talonario where ta_id = @@ta_id

	if IsNull(@@ta_Propuesto,0)<> 1 set @@ta_Propuesto = 0
	else                            set @@ta_Propuesto = 1

	set @@ta_Mascara = IsNull(@@ta_Mascara,'')


end

go