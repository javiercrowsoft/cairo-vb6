if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_GetRptId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_GetRptId]

go

/* 

  select * from id

  declare @myId int
  exec sp_GetRptId @myId output
  print @myId

*/

create procedure sp_GetRptId (
  @@ClienteID int out
)
as

set nocount on

select @@ClienteID = id_NextId from id where Id_Tabla = 'rptArbolRamaHoja' and id_CampoId = 'rptarb_cliente'

if isnull(@@ClienteID,0) = 0 begin 

  insert into id (id_NextId,id_Tabla,id_CampoId) 
  values (0,'rptArbolRamaHoja','rptarb_cliente')

  set @@ClienteID = 1
end

update id 
set id_NextId = @@ClienteID +1
where Id_Tabla = 'rptArbolRamaHoja' and id_CampoId = 'rptarb_cliente'