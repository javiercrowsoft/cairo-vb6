if exists (select * from sysobjects where id = object_id(N'[dbo].[trgg_permiso_update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_permiso_update]
GO


CREATE TRIGGER [trgg_permiso_update] ON dbo.Permiso 
FOR  UPDATE
AS

UPDATE Permiso SET modificado = GETDATE() WHERE per_id IN (SELECT per_id FROM INSERTED)
INSERT INTO Historia (tbl_id, id, modifico, modificado) SELECT 4, per_id, modifico, modificado FROM INSERTED

GO