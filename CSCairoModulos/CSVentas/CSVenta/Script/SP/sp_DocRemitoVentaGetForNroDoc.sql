if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetForNroDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetForNroDoc]

go
/*
sp_DocRemitoVentaGetForNroDoc '454545',1
*/

create procedure sp_DocRemitoVentaGetForNroDoc (
  @@rv_nrodoc    varchar(50),
  @@emp_id      int
)
as

begin

  set nocount on

  select rv_nrodoc,cli_nombre,doc_nombre,rv_fecha 
  from RemitoVenta rv inner join cliente cli    on rv.cli_id = cli.cli_id
                      inner join documento doc on rv.doc_id = doc.doc_id

  where rv_nrodoc = @@rv_nrodoc and rv.emp_id = @@emp_id

end