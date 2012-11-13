/*---------------------------------------------------------------------
Nombre: Compras y ventas por articulos
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0035]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0035]

/*

exec [DC_CSC_VEN_0035] 1,'20000101 00:00:00','20080221 00:00:00','0','0','0','0',3

*/

go
create procedure DC_CSC_VEN_0035(

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cico_id  				varchar(255),
	@@pr_id 	 				varchar(255),
  @@doc_id	 				varchar(255),
  @@emp_id   				varchar(255),
	@@top             tinyint

) 

as 

begin

set nocount on

create table #tbl_dc_csc_ven_0030 (

	Orden										int,
	producto								varchar(255),
	[ventas neto]						decimal(18,6),
	ventas									decimal(18,6),
	[compras neto]					decimal(18,6),
	compras									decimal(18,6),
	ivaventas								decimal(18,6),
	ivacompras							decimal(18,6),
	[cant. ventas]					decimal(18,6),
	[cant. compras]					decimal(18,6)
)


	insert into #tbl_dc_csc_ven_0030 exec DC_CSC_VEN_0030 @@us_id, @@Fini, @@Ffin, @@cico_id, @@pr_id, @@doc_id, @@emp_id

	declare @sqlstmt varchar(255)
	set @sqlstmt = 'select top ' + convert(varchar,@@top) + ' * '
								 + ' from #tbl_dc_csc_ven_0030 where orden = 1'

							+  ' union all '

							+  'select top ' + convert(varchar,@@top) + ' * '
								 + ' from #tbl_dc_csc_ven_0030 where orden = 2'

								 + ' order by orden, [ventas neto] desc, [compras neto] desc'

	exec(@sqlstmt)

end
go