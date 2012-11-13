if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RetencionAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RetencionAdd]

/*

*/

go
create procedure sp_RetencionAdd (
	@@rett_id 	int,
	@@porc			decimal(18,6),
	@@us_id			int
)
as

begin

	declare @ta_id  int
	declare @ret_id int

	select @ta_id = min(ta_id) 
	from Retencion
	where rett_id = @@rett_id

	exec sp_dbgetnewid 'Retencion', 'ret_id', @ret_id out, 0

	insert into Retencion ( rett_id,
													ret_id,
													ret_nombre,
													ret_codigo,
													ret_importeminimo,
													ret_regimensicore,
													ret_acumulapor,
													ret_tipoMinimo,
													ret_esiibb,
													ret_descrip,
													ta_id,
													ibc_id,
													creado,
													modificado,
													modifico,
													activo
												)
							values		( @@rett_id,
													@ret_id,
													'Retencion de Ingresos Brutos ' + convert(varchar,convert(decimal(18,2),@@porc)),
													right('00000' + convert(varchar,@ret_id),5),
													0, --ret_importeminimo,
													0, --ret_regimensicore,
													0, --ret_acumulapor,
													2, --ret_tipoMinimo,
													1,
													'Generada automaticamente por el proceso de importacion de retenciones y percepciones de IIBB BS AS', --ret_descrip,
													@ta_id,
													null, 				--ibc_id,
													getdate(), 		--creado,
													getdate(), 		--modificado,
													@@us_id, 			--modifico,
													1 						--activo
												)

	declare @reti_id int
	exec sp_dbgetnewid 'RetencionItem', 'reti_id', @reti_id out, 0

	insert into RetencionItem ( ret_id,
															reti_id,
															reti_importedesde,
															reti_importehasta,
															reti_porcentaje,
															reti_importefijo,
															creado,
															modificado,
															modifico
														)
									values		( @ret_id,
															@reti_id,
															400, 			 -- reti_importedesde,
															999999999, -- reti_importehasta,
															@@porc,
															0,         -- reti_importefijo,
															getdate(),
															getdate(),
															@@us_id
														)

	select @ret_id as ret_id

end

go