if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LengGetTextAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LengGetTextAux]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ram_convertid.sql
' Objetivo: Convierte un seudo id en un id real ya sea de rama o de una tabla cliente
'-----------------------------------------------------------------------------------------
*/

/*

select ((((10*1.10)*1.20)*1.05))- (((10*1.10)*1.20)*1.05)*.05

select * from listaprecio
select * from listaprecioitem

sp_LengGetTextAux 4,9,0,1

*/
create Procedure sp_LengGetTextAux(
  @@code        varchar(255),
  @@leng_id     int, 
  @@rtn         varchar (5000)out
)
as
begin

  declare @leng_id    int
  declare @rtn        varchar(5000)

  set @leng_id = @@leng_id
  set @rtn     = @@rtn

  -- Busco un texto para este codigo asociado a este lenguaje
  select @rtn = lengi_texto from lenguajeitem where leng_id = @leng_id and lengi_codigo = @@code

  -- Si no lo encuentro veo si el lenguaje tiene un lenguaje padre
  if isnull(@rtn,'') = '' begin

    -- Busco el lenguaje tiene un lenguaje padre
    select @leng_id = leng_id_padre from lenguaje where leng_id = @leng_id

    -- Si hay un lenguaje padre le pido que me traiga el texto
    if isnull(@leng_id ,0) <> 0 begin

      exec sp_LengGetTextAux @leng_id, @rtn out
    end
  end
  
  set @@rtn = @rtn
end
