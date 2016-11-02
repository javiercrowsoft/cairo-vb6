if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_UpdateConsultaTalonario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_UpdateConsultaTalonario]

/*

  sp_FE_UpdateConsultaTalonario

*/

go
create procedure [dbo].[sp_FE_UpdateConsultaTalonario] (

	@@ta_id int,
	@@ta_lastNumber int

)

as

begin

	set nocount on

	update Talonario set ta_ultimoNro = @@ta_lastNumber where ta_id = @@ta_id

end
