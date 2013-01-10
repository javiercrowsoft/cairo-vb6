if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_DBGetNewId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_DBGetNewId]

go
/*
  creado:    15/05/2000
  Proposito:  Devuelve un id para realizar un insert

  SP_DBGetNewId 'Asiento', 'as_id', 0

*/
create procedure SP_DBGetNewId (
  @@tabla   sysname,
  @@pk       sysname,
  @@id      int out,
  @@bSelect tinyint = 1
)
as

begin

  set nocount on

  declare @sqlstmt varchar(255)
  
  if lower(@@tabla) = 'stock' or lower(@@tabla) = 'stockitem' begin

    select @@id = max(Id_NextId) from idStock where Id_Tabla = @@tabla and Id_CampoId = @@pk and Id_Rango = 0
    
    -- si no existe en la tabla
    if @@id is null
    begin

    
      set @sqlstmt = 'insert into idStock (Id_Tabla, Id_NextId, Id_CampoId) select '''+@@tabla+''',isnull(max('+@@pk+'),0)+1, '''+@@pk+''' from '+@@tabla
                     +' where isnumeric(' + @@pk + ')<>0' 
      exec(@sqlstmt)
    
      select @@id = max(Id_NextId) from idStock where Id_Tabla = @@tabla and Id_CampoId = @@pk
    end
    
    update idStock set Id_NextId = @@id+1 where Id_Tabla = @@tabla and Id_CampoId = @@pk

  end else begin

    if lower(@@tabla) = 'asiento' or lower(@@tabla) = 'asientoitem' begin
  
      select @@id = max(Id_NextId) from idAsiento where Id_Tabla = @@tabla and Id_CampoId = @@pk and Id_Rango = 0
      
      -- si no existe en la tabla
      if @@id is null
      begin
  
      
        set @sqlstmt = 'insert into idAsiento (Id_Tabla, Id_NextId, Id_CampoId) select '''+@@tabla+''',isnull(max('+@@pk+'),0)+1, '''+@@pk+''' from '+@@tabla
                       +' where isnumeric(' + @@pk + ')<>0' 
        exec(@sqlstmt)
      
        select @@id = max(Id_NextId) from idAsiento where Id_Tabla = @@tabla and Id_CampoId = @@pk
      end
      
      update idAsiento set Id_NextId = @@id+1 where Id_Tabla = @@tabla and Id_CampoId = @@pk
  
    end else begin
  
      select @@id = max(Id_NextId) from id where Id_Tabla = @@tabla and Id_CampoId = @@pk and Id_Rango = 0
      
      -- si no existe en la tabla
      if @@id is null
      begin
      
        set @sqlstmt = 'insert into Id (Id_Tabla, Id_NextId, Id_CampoId) select '''+@@tabla+''',isnull(max('+@@pk+'),0)+1, '''+@@pk+''' from '+@@tabla
                       +' where isnumeric(' + @@pk + ')<>0' 
        exec(@sqlstmt)
      
        select @@id = max(Id_NextId) from id where Id_Tabla = @@tabla and Id_CampoId = @@pk
      end
      
      update id set Id_NextId = @@id+1 where Id_Tabla = @@tabla and Id_CampoId = @@pk
  
    end
  end
  
  if @@bSelect <> 0 select @@id

end
go