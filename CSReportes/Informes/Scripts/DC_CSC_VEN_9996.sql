/*---------------------------------------------------------------------
Nombre: Inserta una sucursal en ClienteSucursal con los datos de direccion del cliente
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9996]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9996]

/*

DC_CSC_VEN_9996 1,'0'

select cli_id from cliente where not exists(select * from clienteSucursal where cli_id = cliente.cli_id)

*/

go
create procedure DC_CSC_VEN_9996 (

  @@us_id     int,
	@@cli_id    varchar(255)

)as 
begin
set nocount on

  set nocount on

	declare @cli_id  int
	declare @clis_id int

	declare @ram_id_Cliente int

	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out

	exec sp_GetRptId @clienteID out

	if @ram_id_Cliente <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
		end else 
			set @ram_id_Cliente = 0
	end

	declare c_suc insensitive cursor for 
		select cli_id from cliente cli
		where 
						not exists(select * from clienteSucursal where cli_id = cli.cli_id)
			-- Arboles
			and   (cli.cli_id = @cli_id or @cli_id=0)

			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 28 -- tbl_id de Proyecto
			                  and  rptarb_hojaid = cli.cli_id
										   ) 
			           )
			        or 
								 (@ram_id_Cliente = 0)
						 )

	open c_suc

	create table #succli(
												clis_id int
											)

	fetch next from c_suc into @cli_id

	while @@fetch_status=0
	begin

		exec SP_DBGetNewId 'ClienteSucursal', 'clis_id', @clis_id out, 0

		insert into clienteSucursal
							(
								clis_id,
								clis_nombre,
								clis_codigo,
								cli_id,
								clis_descrip,
								clis_localidad,
								clis_calle,
								clis_callenumero,
								clis_piso,
								clis_depto,
								clis_tel,
								clis_fax,
								clis_email,
								zon_id,
								modifico
								)

							select

								@clis_id,
								cli_nombre,
								cli_codigo,
								@cli_id,
								'',
								cli_localidad,
								cli_calle,
								cli_callenumero,
								cli_piso,
								cli_depto,
								cli_tel,
								cli_fax,
								cli_email,
								zon_id,
								@@us_id

							from cliente where cli_id = @cli_id

		insert into #succli (clis_id) values(@clis_id)

		fetch next from c_suc into @cli_id
	end
	close c_suc
	deallocate c_suc

	select 
								clis.clis_id,
								cli_nombre				as Cliente,
								clis_nombre				as Sucursal,
								clis_codigo				as Codigo,
								clis_calle				as Calle,
								clis_callenumero	as Numero,
								clis_localidad		as Localidad,
								clis_piso					as Piso,
								clis_depto				as Departamento,
								clis_tel					as Telefono,
								clis_fax					as Fax,
								clis_email				as [E-mail],
								zon_nombre				as Zona,
								clis_descrip			as Observaciones

	from clienteSucursal clis inner join #succli sc 		on clis.clis_id = sc.clis_id
														inner join cliente cli 		on clis.cli_id  = cli.cli_id
														left  join zona zon       on clis.zon_id  = zon.zon_id

end
go