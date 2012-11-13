/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ProductoSeriesCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ProductoSeriesCliente]
go

/*
select * from Stock

sp_docStockget 47

sp_lsdoc_ProductoSeriesCliente

  1,0,1,
	'20030101',
	'20050101',
		'0',
		'0',
		'17',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		0,
		0
*/

create procedure sp_lsdoc_ProductoSeriesCliente (

  @@us_id    int,

	@@FiltrarFecha smallint,
	@@SinAsignar   smallint,

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

  @@prns_id   				varchar(255),
  @@rub_id				  	varchar(255),
  @@pr_id	 				  	varchar(255),
	@@depl_id 					varchar(255),

	@@cli_id 						varchar(255),
	@@suc_id						varchar(255),

	@@us_id_responsable varchar(255),
	@@us_id_asignador   varchar(255),
	@@cont_id	    			varchar(255),
	@@tarest_id	    		varchar(255),
	@@prio_id	    			varchar(255),
	@@proy_id	    			varchar(255),

	@@soloEnEmpresa     smallint,

	@@emp_id	varchar(255)

)as 

begin

	set nocount on

	exec sp_lsdoc_ProductoSeriesCairo	

																@@us_id,
																	
																@@FiltrarFecha,
																@@SinAsignar,
															
																@@Fini,
																@@Ffin,
															
															  @@prns_id,
															  @@rub_id,
															  @@pr_id,
																@@depl_id,
															
																@@cli_id,
																@@suc_id,
															
																@@us_id_responsable,
																@@us_id_asignador,
																@@cont_id,
																@@tarest_id,
																@@prio_id,
																@@proy_id,
															
																@@soloEnEmpresa,
															
																@@emp_id

end


go