if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbConvertId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbConvertId]

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
create Procedure sp_ArbConvertId(
  @@id         varchar(255),
  @@hoja_id   int out,
  @@ram_id     int out
)
as
begin


   select @@hoja_id = 0
   select @@ram_id = 0

    if substring(@@id,1,1) = 'n' -- esto significa que es un nodo
       select @@ram_id = convert(int,substring(@@id,2,datalength(@@id) -1))
    else
       select @@hoja_id = convert(int,@@id)

end
