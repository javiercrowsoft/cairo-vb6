if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LengGetText]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LengGetText]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ram_convertid.sql
' Objetivo: Convierte un seudo id en un id real ya sea de rama o de una tabla cliente
'-----------------------------------------------------------------------------------------
*/

/*

sp_LengGetText 'menu-tarea',8

*/
create Procedure sp_LengGetText(
  @@code        varchar(255),
	@@us_id 			int
)
as
begin

  declare @leng_id    int
  declare @rtn        varchar(5000)

  set @rtn = ''

  -- Busco un lenguaje para este usuario
  select @leng_id = convert(int,cfg_valor) from configuracion 
  where 
      cfg_grupo = 'Usuario-Config' 
  and cfg_aspecto = 'Lenguaje Gral_' + convert(varchar(18),@@us_id)

  -- Si no hay para este usuario busco un lenguaje general
  if isnull(@leng_id,0) = 0 begin

    select @leng_id = convert(int,cfg_valor) from configuracion 
    where 
        cfg_grupo = 'general' 
    and cfg_aspecto = 'lenguaje'

  end

	if isnull(@leng_id,0) = 0 set @leng_id = 1 -- Lenguaje nativo de CrowSoft (Castellano)

  -- Si hay ningun lenguaje definido 
  if isnull(@leng_id,0) <> 0 begin

    -- Busco un texto para este codigo asociado a este lenguaje
    select @rtn = lengi_texto from lenguajeitem where leng_id = @leng_id and lengi_codigo = @@code
  
    -- Si no lo encuentro veo si el lenguaje tiene un lenguaje padre
  	if isnull(@rtn,'') = '' begin
  
      -- Busco el lenguaje tiene un lenguaje padre
      select @leng_id = leng_id_padre from lenguaje where leng_id = @leng_id
  
      -- Si hay un lenguaje padre le pido que me traiga el texto
      if isnull(@leng_id ,0) <> 0 begin
  
    		exec sp_LengGetTextAux @@code, @leng_id, @rtn out
      end
  	end
  end
	
	select @rtn
end
