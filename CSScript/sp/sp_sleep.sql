if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_sleep]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_sleep]
GO
-- This next statement executes the time_delay procedure.
-- EXEC sp_sleep '000:00:10'

CREATE PROCEDURE sp_sleep (
 @@DELAYLENGTH char(9)
)
AS
DECLARE @@RETURNINFO varchar(255)
BEGIN
   WAITFOR DELAY @@DELAYLENGTH
   /*
   SELECT @@RETURNINFO = 'A total time of ' + 
                  SUBSTRING(@@DELAYLENGTH, 1, 3) +
                  ' hours, ' +
                  SUBSTRING(@@DELAYLENGTH, 5, 2) + 
                  ' minutes, and ' +
                  SUBSTRING(@@DELAYLENGTH, 8, 2) + 
                  ' seconds, ' +
                  'has elapsed! Your time is up.'
   PRINT @@RETURNINFO
   */
END
GO
