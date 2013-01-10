if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbIsRaiz]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbIsRaiz]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ram_convertid.sql
' Objetivo: Convierte un seudo id en un id real ya sea de rama o de una tabla cliente
'-----------------------------------------------------------------------------------------
*/

/*

sp_ram_convertid '20030101','20030403',41087

*/
create Procedure sp_ArbIsRaiz(
  @@ram_id    int,
  @@IsRaiz     tinyint out
)
as
begin

    -- Verifico que se trate de una raiz
    if exists (select * from rama where ram_id = @@ram_id and ram_id_padre = 0) 
      set @@IsRaiz = 1
    else
      set @@IsRaiz = 0

end
