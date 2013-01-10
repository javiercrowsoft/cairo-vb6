if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_col]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_col]
GO

CREATE PROCEDURE sp_col (
         @@table_name    nvarchar(384),
         @@sintipo    smallint = 0
)
AS
DECLARE @table_id int

  SELECT @table_id = object_id(@@table_name)

if @@sintipo = 0 


    SELECT 
      COLUMN_NAME = convert(sysname,c.name),
      c.type
    FROM
      syscolumns c,
      sysobjects o
    WHERE
      o.id = @table_id
      AND c.id = o.id

else

    SELECT 
      COLUMN_NAME = convert(sysname,c.name)
    FROM
      syscolumns c,
      sysobjects o
    WHERE
      o.id = @table_id
      AND c.id = o.id

    

GO

