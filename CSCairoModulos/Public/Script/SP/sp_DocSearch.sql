if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocSearch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocSearch]

go

/*

sp_DocSearch 'dd',1,15,-1017,'20070201 00:00:00','20070311 00:00:00',0,0,0,0,0,0,0,0,0,0

*/

create procedure sp_DocSearch (

  @@toSearch						varchar(5000),
	@@searchType          tinyint,
	@@fieldsToSearch 			int,
  @@doct_id							int,
  @@Fini								datetime,
  @@Ffin								datetime,
  @@cli_id							int,
  @@prov_id							int,
  @@est_id							int,
  @@suc_id							int,
  @@ven_id							int,
  @@cue_id							int,
  @@bco_id							int,
	@@barc_id							int,
  @@doc_id							int,
  @@emp_id							int
)
as

set nocount on

begin

exec sp_DocSearchCliente

  @@toSearch						,
	@@searchType          ,
	@@fieldsToSearch 			,
  @@doct_id							,
  @@Fini								,
  @@Ffin								,
  @@cli_id							,
  @@prov_id							,
  @@est_id							,
  @@suc_id							,
  @@ven_id							,
  @@cue_id							,
  @@bco_id							,
	@@barc_id							,
  @@doc_id							,
  @@emp_id							
end

go
