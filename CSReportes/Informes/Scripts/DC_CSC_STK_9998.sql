if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_9998]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_9998]

GO

/*

Proposito: Compensar el stock de numeros de serie que se han movido desde
           un deposito donde no estaban y han quedado en -1.
           El sp detecta donde hay stock del numero de serie y lo mueve
           al deposito con faltante.

select * from rama where ram_nombre like '%cilbras%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%ThinkPad G41-28814FU%'

select * from documento where doc_nombre like '%trans%'

DC_CSC_STK_9998 
											1,
											'7',
											35,
											1,
											'20051001'

*/

create procedure DC_CSC_STK_9998 (
  @@us_id    				int,
	@@pr_id 					varchar(255),
	@@doc_id					int,
	@@suc_id          int,
	@@st_fecha				datetime,
	@@noTransferir    smallint 
)as 

begin

exec sp_DocStockCompensar 
													  @@us_id,
														@@pr_id,
														@@doc_id,
														@@suc_id,
														@@st_fecha,
														@@noTransferir  

end
go