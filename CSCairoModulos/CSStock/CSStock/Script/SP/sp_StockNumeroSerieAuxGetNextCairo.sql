if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockNumeroSerieAuxGetNextCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockNumeroSerieAuxGetNextCairo]

go

/*

sp_StockNumeroSerieAuxGetNextCairo 8,7

*/

-- sp_iddelete

create procedure sp_StockNumeroSerieAuxGetNextCairo 

as

begin

  declare @numero         int
  declare @numero_aux      varchar(255)
  declare @mask           varchar(10) 
  declare @format         varchar(20)
  set @mask = '(AUX)'

  if not exists (select * from Id where Id_Tabla = 'ProductoNumeroSerie' and Id_CampoId = 'prns_codigoaux' and Id_Rango = 0)
  begin

    select @numero_aux = max(prns_codigo) from ProductoNumeroSerie where prns_codigo like @mask + '%'

    set @numero_aux = substring(@numero_aux,len(@mask)+1,100)

    if isnumeric(@numero_aux) <> 0 set @numero = convert(int,@numero_aux)
    else                           set @numero = 1

    insert into Id (Id_Tabla, Id_NextId, Id_CampoId) values( 'ProductoNumeroSerie', @numero, 'prns_codigoaux' )

  end
  
  set @format = '0000000000'

  exec sp_dbgetnewid 'ProductoNumeroSerie','prns_codigoaux', @numero out, 0

  set @numero_aux = convert(varchar(20),@numero)

  if len(@format) <= len(@numero_aux) set @format = ''
  else                                 set @format = substring(@format,1,len(@format)-len(@numero_aux))

  select @mask + @format + @numero_aux
end