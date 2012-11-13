if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_UpdateConsultaTalonarios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_UpdateConsultaTalonarios]

/*

  sp_FE_UpdateConsultaTalonarios

*/

go
create procedure [dbo].[sp_FE_UpdateConsultaTalonarios] (

	@@msg varchar(255)

)

as

begin

	set nocount on

	exec sp_cfg_setvalor 'Ventas-General', 'Update Talonarios AFIP-Respuesta', @@msg, null

end
