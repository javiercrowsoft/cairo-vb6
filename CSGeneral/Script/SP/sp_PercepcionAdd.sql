if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PercepcionAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PercepcionAdd]

/*

*/

go
create procedure sp_PercepcionAdd (
	@@perct_id 	int,
	@@porc			decimal(18,6),
	@@pro_id    int,
	@@us_id			int,
	@@emp_id		int
)
as

begin

	declare @ta_id  	int
	declare @perc_id 	int

	select @ta_id = min(ta_id) 
	from Percepcion
	where perct_id = @@perct_id

	exec sp_dbgetnewid 'Percepcion', 'perc_id', @perc_id out, 0

	insert into Percepcion (perct_id,
													perc_id,
													perc_nombre,
													perc_codigo,
													perc_importeminimo,
													perc_regimensicore,
													perc_descrip,
													ta_id,
													creado,
													modificado,
													modifico,
													activo
												)
							values		( @@perct_id,
													@perc_id,
													'Percepcion de Ingresos Brutos ' + convert(varchar,convert(decimal(18,2),@@porc)),
													right('00000' + convert(varchar,@perc_id),5),
													0, --perc_importeminimo,
													0, --perc_regimensicore,
													'Generada automaticamente por el proceso de importacion de Percepciones y percepciones de IIBB BS AS', --perc_descrip,
													@ta_id,
													getdate(), 		--creado,
													getdate(), 		--modificado,
													@@us_id, 			--modifico,
													1 						--activo
												)

	declare @perci_id int
	exec sp_dbgetnewid 'PercepcionItem', 'perci_id', @perci_id out, 0

	insert into PercepcionItem (perc_id,
															perci_id,
															perci_importedesde,
															perci_importehasta,
															perci_porcentaje,
															perci_importefijo,
															creado,
															modificado,
															modifico
														)
									values		( @perc_id,
															@perci_id,
															50, 			 -- perci_importedesde,
															999999999, -- perci_importehasta,
															@@porc,
															0,         -- perci_importefijo,
															getdate(),
															getdate(),
															@@us_id
														)


	declare @percpro_id int
	exec sp_dbgetnewid 'PercepcionProvincia', 'percpro_id', @percpro_id out, 0

	insert into PercepcionProvincia (percpro_id,
																	 perc_id,
																	 pro_id
																	)
													values	(@percpro_id,
																	 @perc_id,
																	 @@pro_id --pro_id BS AS
																	)

	declare @perccatf_id int
	exec sp_dbgetnewid 'PercepcionCategoriaFiscal', 'perccatf_id', @perccatf_id out, 0

	insert into PercepcionCategoriaFiscal (perccatf_id,
																				 perc_id,
																				 catf_id,
																				 perccatf_base
																				)
																values	(@perccatf_id,
																				 @perc_id,
																				 1, -- RI,
																				 2
																				)

	exec sp_dbgetnewid 'PercepcionCategoriaFiscal', 'perccatf_id', @perccatf_id out, 0

	insert into PercepcionCategoriaFiscal (perccatf_id,
																				 perc_id,
																				 catf_id,
																				 perccatf_base
																				)
																values	(@perccatf_id,
																				 @perc_id,
																				 11, -- RI M,
																				 2
																				)

	exec sp_dbgetnewid 'PercepcionCategoriaFiscal', 'perccatf_id', @perccatf_id out, 0

	insert into PercepcionCategoriaFiscal (perccatf_id,
																				 perc_id,
																				 catf_id,
																				 perccatf_base
																				)
																values	(@perccatf_id,
																				 @perc_id,
																				 6, -- Mono,
																				 3
																				)

	declare @percemp_id int
	exec sp_dbgetnewid 'PercepcionEmpresa', 'percemp_id', @percemp_id out, 0

	insert into PercepcionEmpresa (percemp_id,
																 perc_id,
																 emp_id
																)
												values	(@percemp_id,
																 @perc_id,
																 @@emp_id
																)

	select @perc_id perc_id

end

go