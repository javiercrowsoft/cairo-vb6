if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_BancoConciliacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_BancoConciliacion]
go

/*
select * from Cobranza

sp_docCobranzaget 47

sp_lsdoc_BancoConciliacion

  7,
	'20030101',
	'20050101',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0'

*/

create procedure sp_lsdoc_BancoConciliacion (

	@@bcoc_id	int

)as 

begin

	set nocount on
	
	select 
				bcoc_id,
				''									  	as [TypeTask],
				bcoc_numero             as [Número],
				emp_nombre            	as [Empresa],
		    cue_nombre            	as [Cuenta],
		    bco_nombre					  	as [Banco],
				bcoc_fecha						  as [Fecha],
	
				bcoc_fechadesde	  		  as [Desde],
				bcoc_fechahasta 			  as [Hasta],
	
				bcoc_saldoBco						as [Saldo],
	
				bcoc.Creado,
				bcoc.Modificado,
				us_nombre             as [Modifico],
				bcoc_descrip				  as [Observaciones]
	from 
				BancoConciliacion bcoc
	                   inner join cuenta 		cue   on bcoc.cue_id   	= cue.cue_id
										 inner join banco     bco   on cue.bco_id   	= bco.bco_id
	                   inner join usuario   us    on bcoc.modifico 	= us.us_id
										 left  join empresa   emp   on cue.emp_id  		= emp.emp_id
	where 
	
				bcoc.bcoc_id = @@bcoc_id

end

go