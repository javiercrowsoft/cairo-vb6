if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetCjForUsId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetCjForUsId]

-- sp_MovimientoCajaGetCjForUsId 2

go

create procedure sp_MovimientoCajaGetCjForUsId (
  @@us_id int,
  @@bSelect tinyint = 1,
  @@cj_id int = 0 out ,
  @@bError tinyint = 0 out ,
  @@errorMsg varchar(2000) = '' out,
  @@hr tinyint = 0
)
as

begin

  declare @cj_id int

  if exists(select cj.cj_id from CajaCajero cjc inner join caja cj on cjc.cj_id = cj.cj_id
            where cjc.us_id = @@us_id and cj.activo <> 0
              and ((cj_hojaruta <> 0 and @@hr <> 0) or (cj_hojaruta = 0 and @@hr = 0))
            ) begin
  
    select @cj_id = min(cj_id)
    from MovimientoCaja mcj
    where mcj_tipo = 1
      and cj_id in (select cjc.cj_id from CajaCajero cjc inner join caja cj on cjc.cj_id = cj.cj_id
                    where cjc.us_id = @@us_id and cj.activo <> 0
                      and ((cj_hojaruta <> 0 and @@hr <> 0) or (cj_hojaruta = 0 and @@hr = 0))
                    )
      and not exists(  select 1 from MovimientoCaja m inner join caja cj on m.cj_id = cj.cj_id
                      where m.cj_id = mcj.cj_id 
                        and ((cj_hojaruta <> 0 and @@hr <> 0) or (cj_hojaruta = 0 and @@hr = 0))
                        and mcj_id > mcj.mcj_id 
                        and mcj_tipo = 2
                    )
  
    if @cj_id is null begin

      if @@bSelect <> 0
  
        select   0       as success,
                '' 
                        as info,
                'El usuario esta configurado como cajero, pero no existe ninguna caja en estado "Abierta" asociada a este cajero. Debe abrir la caja para poder operar.' 
                        as warning,
                @cj_id   as cj_id,
                ''      as cj_nombre,
                ''      as cj_codigo
      else begin

        set @@bError = 1
        set @@errorMsg = '@@ERROR_SP:El usuario esta configurado como cajero, pero no existe ninguna caja en estado "Abierta" asociada a este cajero. Debe abrir la caja para poder operar.'
        return

      end
  
    end else begin

      if @@bSelect <> 0  

        select   1       as success,
                'Estas operaciones de venta trabajarán con la caja: '  + cj_nombre + ' [' + cj_codigo + '].'
                        as info,
                '' 
                        as warning,
                @cj_id   as cj_id,
                cj_nombre,
                cj_codigo
  
        from Caja
        where cj_id = @cj_id

      else begin
        set @@bError = 0
        set @@cj_id = @cj_id
        return

      end

    end

  end else begin

    -- Si en ventas se exige que este la caja abierta para generar facturas
    -- los usuarios que no tienen una caja asociada no pueden facturar
    --

    declare @cfg_clave varchar(255)
    declare @cfg_valor varchar(5000) 
  
    set @cfg_clave = 'Exigir que la Caja Este Abierta para Facturar'
  
    exec sp_Cfg_GetValor  'Ventas-General',
                          @cfg_clave,
                          @cfg_valor out,
                          0
  
    declare @exige_caja int
    if isnumeric(@cfg_valor) <> 0 
      set @exige_caja = convert(int,@cfg_valor)
    else
      set @exige_caja = 0

    if @exige_caja <> 0

      if @@bSelect <> 0  

        select   0       as success,
                ''       as info,
                'El sistema esta configurado para exigir una caja al facturar pero el usuario no esta configurado como cajero.'       
                        as warning,
                null     as cj_id,
                ''      as cj_nombre,
                ''      as cj_codigo

      else begin

        set @@bError = 1
        set @@errorMsg = '@@ERROR_SP:El sistema esta configurado para exigir una caja al facturar pero el usuario no esta configurado como cajero.'
        return

      end

    else

      if @@bSelect <> 0  

        select   1       as success,
                ''      as info,
                ''      as warning,
                null     as cj_id,
                ''      as cj_nombre,
                ''      as cj_codigo

  end  
end

go