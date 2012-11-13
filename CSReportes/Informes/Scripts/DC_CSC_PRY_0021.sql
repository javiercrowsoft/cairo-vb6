-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Detalle de horas trabajadas
---------------------------------------------------------------------*/
/*

DC_CSC_PRY_0021
                  1,
                  '20010101',
                  '20100101',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0',
                  '',
                  '',
									2
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRY_0021]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRY_0021]

go
create procedure DC_CSC_PRY_0021 (
  @@us_id   					int,
	@@Fini 							datetime,
	@@Ffin 							datetime,
	@@Finalizada 				smallint,
	@@Cumplida 				  smallint,
	@@Rechazada					smallint,
	@@us_id_responsable varchar(255),
	@@us_id_asignador   varchar(255),
	@@cont_id	    			varchar(255),
	@@tarest_id	    		varchar(255),
	@@prio_id	    			varchar(255),
	@@proy_id	    			varchar(255),
	@@activa	    			smallint
)
as

set nocount on

begin

	create table #tmp_dc_csc_proy_0021(

				tar_id							int,
				TypeTask 						int,
				[Tarea Principal]   varchar(255),
				Número              varchar(20),
				Cliente             varchar(255),
				Proyecto            varchar(255),
				[Sub Proyecto]      varchar(255),
				Objetivo            varchar(255),
				Título              varchar(255),
				[Fecha inicio]      datetime,
				[Fecha fin]         datetime,
				[Estado 2]  				varchar(255),
				Activa 							varchar(5),
				Contacto            varchar(255),
				Prioridad           varchar(255),
				Estado              varchar(255),
				Responsable         varchar(255),
				[Asignada por]      varchar(255),
				[Descripción]       varchar(5000)

			)

	insert into #tmp_dc_csc_proy_0021 

	exec DC_CSC_PRY_0020 
														  @@us_id   					,
															@@Fini 							,
															@@Ffin 							,
															@@Finalizada 				,
															@@Cumplida 					,
															@@Rechazada					,
															@@us_id_responsable ,
															@@us_id_asignador   ,
															@@cont_id	    			,
															@@tarest_id	    		,
															@@prio_id	    			,
															@@proy_id	    			,
															@@activa	    			


		select

				tar_id							,
				[Tarea Principal]   ,
				Número              ,
				Cliente             ,
				Proyecto            ,
				[Sub Proyecto]      ,
				Título              ,
				[Fecha inicio]      ,
				[Fecha fin]         ,
				[Estado 2]  				as Progreso,
				Prioridad           ,
				Estado              ,
				Responsable         ,
				[Asignada por]      
				         

	from 

	#tmp_dc_csc_proy_0021 
end

go