if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_RemitosVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_RemitosVenta]
go

/*
select * from Remitoventa

sp_docRemitoventaget 47

sp_lsdoc_RemitosVenta

  7,
  '20030101',
  '20050101',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'

*/

create procedure sp_lsdoc_RemitosVenta (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@cli_id  varchar(255),
@@est_id  varchar(255),
@@ccos_id  varchar(255),
@@suc_id  varchar(255),
@@ven_id  varchar(255),
@@doc_id  varchar(255),
@@cpg_id  varchar(255),
@@emp_id  varchar(255)

)as 
begin
  set nocount on

  exec sp_lsdoc_RemitosVentaCliente   @@us_id,
                                      @@Fini,
                                      @@Ffin,
                                      
                                      @@cli_id,
                                      @@est_id,
                                      @@ccos_id,
                                      @@suc_id,
                                      @@ven_id,
                                      @@doc_id,
                                      @@cpg_id,
                                      @@emp_id
end
go