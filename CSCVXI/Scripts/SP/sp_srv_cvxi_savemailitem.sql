if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_savemailitem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_savemailitem]

go
/*

*/

create procedure sp_srv_cvxi_savemailitem (

  @@cmie_id              int,
  @@cmiei_texto          varchar(1000),
  @@cmiei_valor          varchar(5000),
  @@cmiei_valorhtml      varchar(5000),
  @@cmiti_id            int

)

as

begin

  set nocount on

  -- Validaciones especiales al campo codigo
  --
  -- Si se leyo mal (a veces incluye un pedazo de codigo html que empieza con <img..)
  -- lo corrijo aca
  --
  if exists(select 1 
            from ComunidadInternetTextoItem 
            where cmiti_id = @@cmiti_id 
              and cmiti_codigomacro = '@@apodo')
  begin

      if charindex('<img',@@cmiei_valor) > 0 begin

        set @@cmiei_valor = rtrim(substring(@@cmiei_valor,1,charindex('<img', @@cmiei_valor)-1))

      end

  end

  declare @cmiei_id int

  select @cmiei_id = cmiei_id 
  from ComunidadInternetMailItem
  where cmie_id = @@cmie_id
    and cmiti_id = @@cmiti_id

  if @cmiei_id is null begin

    exec sp_dbgetnewid 'ComunidadInternetMailItem', 'cmiei_id', @cmiei_id out, 0

    insert into ComunidadInternetMailItem (
                                            cmie_id,
                                            cmiei_id,
                                            cmiei_texto,
                                            cmiei_valor,
                                            cmiei_valorhtml,
                                            cmiti_id
                                          )
                                  values  (
                                            @@cmie_id,
                                            @cmiei_id,
                                            @@cmiei_texto,
                                            @@cmiei_valor,
                                            @@cmiei_valorhtml,
                                            @@cmiti_id
                                          )
  end else begin

    update ComunidadInternetMailItem set
                                        cmiei_texto = @@cmiei_texto,
                                        cmiei_valor = @@cmiei_valor,
                                        cmiei_valorhtml = @@cmiei_valorhtml
    where cmiei_id = @cmiei_id

  end

end