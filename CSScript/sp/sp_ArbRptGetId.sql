if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbRptGetId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbRptGetId]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ArbRptGetId.sql
' Objetivo: Inserta en rptArbolRamaHoja todos los ids contenidos en la rama que recibe como
'           parametro, sin duplicados
'-----------------------------------------------------------------------------------------
*/

/*

sp_ArbRptGetId '20030101','20030403',41087

*/
create Procedure sp_ArbRptGetId(
  @@ram_id     int 
)
as
begin


   select @@hoja_id = 0
   select @@ram_id = 0

    if substring(@@id,1,1) = 'n'  -- esto significa que es un nodo
       select @@ram_id = convert(int,substring(@@id,2,datalength(@@id) -1))
    else
       select @@hoja_id = convert(int,@@id)

end
