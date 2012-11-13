if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_socioUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_socioUpdate]

/*

sp_web_socioUpdate 

*/

go
create procedure sp_web_socioUpdate as

begin

	set nocount on

	insert into aaba_socio (					AABAsoc_id,
																		AABAsoc_codigo,
																		AABAsoc_apellido,
																		AABAsoc_nombre,
																		AABAsoc_descrip,
																		aabasoc_documento,
																		aabasoc_tipodocumento
													)
	select
																		medico,
																		medico,
																		'',
																		'',
																		nombre,
																		docu_nume,
																		case docu_tipo
																			when 'LE' 	then 2
																			when 'DNI'	then 1
																			when 'CE' 	then 0
																			when 'CI' 	then 4
																			when 'DD' 	then 0
																			else             0
																		end



	from aaarbaweb..medicos where not exists(select * from aaba_socio where aabasoc_id = medico)

	declare c_socio insensitive cursor for select aabasoc_descrip,aabasoc_id from aaba_socio where aabasoc_nombre = ''
	open c_socio

	declare @descrip 		varchar(255)
  declare @nombre 		varchar(255)
	declare @apellido		varchar(255)
	declare @id         int

	fetch next from c_socio into @descrip,@id
	while @@fetch_status = 0
	begin

		if charindex(',',@descrip,1)>0 begin

			set @apellido = substring(@descrip,1,charindex(',',@descrip,1)-1)
			set @nombre = substring(@descrip,charindex(',',@descrip,1)+1,len(@descrip))

			update aaba_socio set aabasoc_nombre = @nombre, aabasoc_apellido = @apellido where aabasoc_id = @id

		end

		fetch next from c_socio into @descrip, @id
	end

	close c_socio
	deallocate c_socio


	insert into aaba_sociolasfar (		AABAsocl_id,
																		AABAsocl_codigo,
																		AABAsocl_apellido,
																		AABAsocl_nombre,
																		AABAsocl_descrip,
																		AABAsocl_documento,
																		aabasocl_provincia,
																		aabaasoc_id,
																		aabasocl_asociacion,
																		aabasocl_email
													)
	select
																		aabasoc_id,
																		aabasoc_codigo,
																		aabasoc_apellido,
																		aabasoc_nombre,
																		aabasoc_descrip,
																		case aabasoc_tipodocumento
																				when 1 then 'DNI'
																				when 2 then 'LE'
																				when 3 then 'LC'
																				when 4 then 'CI'
																				when 5 then 'Pasaporte'
																				else        ''
																		end + aabasoc_documento,
																		'Buenos Aires',
																		5,
																		'ASOCIACION DE ANESTESIA, ANALGESIA Y REANIMACION DE BUENOS AIRES',
																		''

	from aaba_socio where not exists(select * from aaba_sociolasfar where aabasocl_id = aaba_socio.aabasoc_id)


end

go

/*
*/