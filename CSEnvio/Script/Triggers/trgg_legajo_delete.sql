if exists (select * from sysobjects where id = object_id(N'[dbo].[trgg_legajo_delete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_legajo_delete]
GO


CREATE TRIGGER [trgg_legajo_delete] ON dbo.Legajo
FOR  DELETE
AS

insert into historia (tbl_id, id, hst_operacion, modifico, modificado) 
select 15001, lgj_id, 1, modifico, modificado from deleted

GO
