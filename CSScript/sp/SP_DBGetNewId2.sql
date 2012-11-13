if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_DBGetNewId2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_DBGetNewId2]

go
/*

sp_iddelete

select max(Id_NextId) from id where Id_Tabla = 'prestacion' and Id_CampoId = 'pre_id' and Id_Rango = 10000000

	creado:		15/05/2000
	Proposito:	Devuelve un id para realizar un insert

	SP_DBGetNewId2 'prestacion', 'pre_id', 0,90000,0,1
*/
create procedure SP_DBGetNewId2 (
	@@tabla sysname,
	@@pk 	sysname,
  @@min int,
  @@max int,
	@@id	int out,
  @@bSelect tinyint = 1
)
as

begin
	set nocount on

	select @@id = max(Id_NextId) from id where Id_Tabla = @@tabla and Id_CampoId = @@pk and Id_Rango = @@min
	
	-- si no existe en la tabla
	if IsNull(@@id,0) = 0
	begin

		declare @sqlstmt varchar(5000)
	
		set @sqlstmt = 'insert into Id (Id_Tabla, Id_NextId, Id_CampoId, Id_Rango) select '''+@@tabla
                   +''',isnull(max(convert(int,'+@@pk+')),0)+1, '''+@@pk+''','+ Convert(VarChar(10),@@min) + ' from '+@@tabla 
                   +' where isnumeric(' + @@pk + ')<>0 and (convert(int,' + @@pk + ') >= ' + Convert(VarChar(10),@@min) + ' and '
																															+' convert(int,'+ @@pk + ') <= ' + Convert(VarChar(10),@@max) + ')'
		exec(@sqlstmt)
	
		select @@id = max(Id_NextId) from id where Id_Tabla = @@tabla and Id_CampoId = @@pk and Id_Rango = @@min
	end

	set @@id = IsNull(@@id,0)
	if @@id = 0 set @@id = @@min
	if @@id < @@min set @@id = @@min
	if @@id > @@max set @@id = @@max
	
	update id set Id_NextId = @@id+1 where Id_Tabla = @@tabla and Id_CampoId = @@pk and Id_Rango = @@min
	
	if @@bSelect <> 0 select @@id

end
go