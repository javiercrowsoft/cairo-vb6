if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_GetConsultaTalonarios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_GetConsultaTalonarios]

/*

  exec sp_cfg_setvalor 'Ventas-General', 'Update Talonarios AFIP', '1', null

  exec sp_FE_GetConsultaTalonarios

  update talonario set ta_ultimonro = 10 where ta_id = 119

  select * from talonario where ta_id = 119

  sp_FE_UpdateTalonarios

*/

go
create procedure [dbo].[sp_FE_GetConsultaTalonarios] 

as

begin

  set nocount on

  declare @cfg_valor varchar(5000) 
  exec sp_cfg_getvalor  'Ventas-General',
                        'Update Talonarios AFIP',
                        @cfg_valor out,
                        0,
                        null

  set @cfg_valor = IsNull(@cfg_valor,0)

  select ta_id, ta_puntovta, ta_tipoafip from Talonario where ta_tipoafip <> 0 and @cfg_valor <> '0'

  exec sp_cfg_setvalor  'Ventas-General',
                        'Update Talonarios AFIP',
                        '0',
                        null

end
