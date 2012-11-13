
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioContableGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioContableGet]

go
create procedure sp_EjercicioContableGet (

	@@ejc_id int

)as 
begin

-----------------------------------------------------------------------------------------
	declare @@emp_id 			varchar(50)
	declare @@cico_id			varchar(50)

	declare @emp_id 			int
	declare @cico_id			int

	declare @ram_id_empresa          int
	declare @ram_id_circuitocontable int

	select 	@@emp_id 		= emp_id,
					@@cico_id 	= cico_id

	from EjercicioContable

	where ejc_id = @@ejc_id

	declare @clienteID 				int
	declare @IsRaiz    				tinyint

	exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
	exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out

	declare @empresa 	varchar(255)
	declare @circuito varchar(255)

	if @ram_id_empresa <> 0 begin
		select @empresa = ram_nombre from rama where ram_id = @ram_id_empresa
	end
	
	if @ram_id_circuitocontable <> 0 begin
		select @circuito = ram_nombre from rama where ram_id = @ram_id_circuitocontable	
	end

-----------------------------------------------------------------------------------------

select 
			ejc.*,

			isnull(emp_nombre,@empresa)				as emp_nombre,
			isnull(cico_nombre,@circuito)			as cico_nombre,
			doc_nombre,
			cue_nombre,

			convert(varchar(255),ap.as_fecha,107) 
			+ ' ' + ap.as_nrodoc          as [Apertura],

			convert(varchar(255),acp.as_fecha,107) 
			+ ' ' + acp.as_nrodoc         as [Cierre Patrimonial],

			convert(varchar(255),acr.as_fecha,107) 
			+ ' ' + acr.as_nrodoc         as [Cierre Resultados]

from 
			EjercicioContable ejc

							left  join empresa       				 on @emp_id	 = empresa.emp_id
							left  join circuitocontable cico on @cico_id = cico.cico_id

							left  join documento doc         on ejc.doc_id  = doc.doc_id
							left  join cuenta cue            on ejc.cue_id_resultado = cue.cue_id

							left  join asiento ap    on ejc.as_id_apertura 					= ap.as_id
							left  join asiento acp   on ejc.as_id_cierrepatrimonial = acp.as_id
							left  join asiento acr	 on ejc.as_id_cierreresultados 	= acr.as_id

where 			  

			ejc.ejc_id = @@ejc_id

end
