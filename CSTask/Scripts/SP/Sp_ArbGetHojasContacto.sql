if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetHojasContacto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetHojasContacto]

/*

Sp_ArbGetHojasContacto 1, 69252

*/

go
create procedure sp_ArbGetHojasContacto (
	@@agn_id        int,
	@@ram_id 				int,
	@@soloColumnas 	smallint = 0,
	@@aBuscar 			varchar(255) ='',
	@@top 					int = 1500
)
as
begin
set nocount on

declare @esRaiz			int
declare @arb_id			int

	declare @sqlstmt varchar(8000)

	select @esRaiz = ram_id_padre, @arb_id = arb_id from rama where ram_id = @@ram_id
	if @esRaiz = 0 
	 begin

		create table #HojaId (hoja_id int, id int)

		-- Ids de la raiz
		insert into #HojaId select hoja_id,id from Hoja where ram_id = @@ram_id

		-- Ids sin asignar
		insert into #HojaId select cont_id *-1, cont_id from Contacto 
				where not exists (select * from Hoja where Hoja.id = Contacto.cont_id and arb_id = @arb_id and agn_id = @@agn_id)

		set @sqlstmt = 'select top '+ convert(varchar,@@top)
	
					 + 'hoja_id, 
							cont_id 			        as ID, 
							ltrim(cont_apellido + '' '' +
							cont_nombre)					as Nombre,
							cont_codigo						as Codigo,
							cont_cargo						as Cargo,
							cont_tel							as Telefono,
							cont_celular					as Celular,
							cont_email						as Mail,
							cont_direccion				as Direccion,
							cont_cliente					as Cliente,
							cont_proveedor				as Proveedor,
							cont_ciudad						as Ciudad,
							cont_provincia				as Provincia
	
			from 
						-- el filtro esta en #HojaId
						Contacto  inner join #HojaId         on #HojaId.id = Contacto.cont_id and agn_id = '+ convert(varchar,@@agn_id)
	 end
	else

		set @sqlstmt = 'select top '+ convert(varchar,@@top)
	
					 + 'hoja_id, 
							cont_id 			        as ID, 
							ltrim(cont_apellido + '' '' +
							cont_nombre)					as Nombre,
							cont_codigo						as Codigo,
							cont_cargo						as Cargo,
							cont_tel							as Telefono,
							cont_celular					as Celular,
							cont_email						as Mail,
							cont_direccion				as Direccion,
							cont_cliente					as Cliente,
							cont_proveedor				as Proveedor,
							cont_ciudad						as Ciudad,
							cont_provincia				as Provincia
	
			from 
						Contacto  inner join Hoja on Hoja.id = Contacto.cont_id and agn_id = '+ convert(varchar,@@agn_id) +'
			where 
						Hoja.ram_id = '+ convert(varchar,@@ram_id)

	exec (@sqlstmt)
 end

go