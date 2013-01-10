if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocEsCobranzaPorCajero]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocEsCobranzaPorCajero]

go

/*

  sp_DocEsCobranzaPorCajero 34

*/

create procedure sp_DocEsCobranzaPorCajero (
  @@fv_id        int
)
as

set nocount on

begin

  -- Antes que nada valido que este el centro de costo
  --
  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Ventas-General',
                        'Concentrar Cobranzas en Cajero',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 
    select 1
  else
    select 0
end

go
