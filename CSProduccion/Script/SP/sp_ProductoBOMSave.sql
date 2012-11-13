if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoBOMSave ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoBOMSave ]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

sp_ProductoBOMSave  4

*/

create procedure sp_ProductoBOMSave (
	@@pbm_id	int
)
as

set nocount on

begin

  set nocount on

	if exists (select * from ProductoBOMItem pbmi
             where not exists(select * from ProductoBOMItemA pbma 
                              where pbma.pbmi_id = pbmi.pbmi_id
														)
							 and pbmi.pr_id is null
							 and pbmi.pbm_id = @@pbm_id
						)
	begin

		update ProductoBOM set activo = 0 where pbm_id = @@pbm_id

		select 1, 'Esta B.O.M. quedará inactiva por que contiene insumos sin producto definido.' +
              ' Para activarla debe indicar al menos un producto para cada insumo.'

	end else begin


		if not exists (select * from ProductoBOMElaborado pbme
	             where pbme.pbm_id = @@pbm_id
							)
		begin
	
			update ProductoBOM set activo = 0 where pbm_id = @@pbm_id
	
			select 1, 'Esta B.O.M. quedará inactiva por que no contiene elaborados.' +
	              ' Para activarla debe indicar al menos un elaborado.'
	
		end else begin

			select 1, ''

		end

	end

/*
    Reglas a cumplir:

    Los elaborados no pueden estar dentro de los insumos

    Los elaborados no pueden ser insumos de los insumos

    Los elaborados deben almacenarse en el stock

    Almenos un insumo debe llevar stock
*/

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
