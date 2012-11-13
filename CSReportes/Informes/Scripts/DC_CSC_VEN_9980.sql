/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de venta
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9980]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9980]

-- exec [DC_CSC_VEN_9980] 1,'0'

go
create procedure DC_CSC_VEN_9980 (

  @@us_id    		int,

  @@cli_id   		varchar(255)  

)as 
begin

  set nocount on

declare @cli_id   		int

declare @ram_id_cliente       int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente 	out
  
exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

		create table #t_clientes( aux_id              int,
															cli_razonsocial_1 	varchar(255),
															cli_nombre_1 				varchar(255),
															cliente_1 					varchar(255),
															cli_direccion_1 		varchar(1000),
															cli_codpostal_1 		varchar(50),
															cli_localidad_1 		varchar(100),
															cli_direccion2_1 		varchar(1000),
															cli_telefono_1 			varchar(100),
															pro_nombre_1 				varchar(100),

															cli_razonsocial_2 	varchar(255),
															cli_nombre_2 				varchar(255),
															cliente_2 					varchar(255),
															cli_direccion_2 		varchar(1000),
															cli_codpostal_2 		varchar(50),
															cli_localidad_2 		varchar(100),
															cli_direccion2_2 		varchar(1000),
															cli_telefono_2 			varchar(100),
															pro_nombre_2 				varchar(100),

															cli_razonsocial_3 	varchar(255),
															cli_nombre_3 				varchar(255),
															cliente_3 					varchar(255),
															cli_direccion_3 		varchar(1000),
															cli_codpostal_3 		varchar(50),
															cli_localidad_3 		varchar(100),
															cli_direccion2_3 		varchar(1000),
															cli_telefono_3 			varchar(100),
															pro_nombre_3 				varchar(100)


															)

	declare 	@cli_razonsocial 		varchar(255),
						@cli_nombre 				varchar(255),
						@cliente 						varchar(255),
						@cli_direccion 			varchar(1000),
						@cli_codpostal 			varchar(50),
						@cli_localidad 			varchar(255),
						@cli_direccion2 		varchar(1000),
						@cli_telefono 			varchar(255),
						@pro_nombre 				varchar(255)
	
	
	declare c_cli insensitive cursor for 
	
			select 	cli_razonsocial,
							cli_nombre,
							cli_nombre + ' -RZ: ' + cli_razonsocial + ' -CUIT: ' + cli_cuit + ' -TE: ' + cli_tel
												         as [Cliente],

							substring(	
							cli_calle + ' ' + 
							cli_callenumero + ' ' + 
							cli_piso + ' ' + 
							cli_codpostal + ' ' + 
							cli_localidad,1,1000) 		 as cli_direccion,
	
							'(CP '+cli_codpostal+')' 	 as cli_codpostal,

							substring(cli_localidad,1,100) as cli_localidad,
	
							substring(
							cli_calle + ' ' + 
							cli_callenumero + ' ' + 
							cli_piso,1,1000)					 as cli_direccion2,

							substring(
							'Tel: ' + 
							cli_tel  + ' | Fax:' + 
							cli_fax  + ' | Email: ' + 
							cli_email  + ' | Web:' + 
							cli_web,1,100)					   	 as cli_telefono,

							case when cli_localidad = pro_nombre then '' else pro_nombre end as pro_nombre

	
			from Cliente cli left join Provincia pro on cli.pro_id = pro.pro_id
		  where (cli_id = @cli_id or @cli_id = 0)
		  and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 28 
		                  and  rptarb_hojaid = cli_id
									   ) 
		           )
		        or 
							 (@ram_id_cliente = 0)
					 )									

	declare @n int
	set @n = 1
	
	declare @aux_id int
	set @aux_id = 1
	
	open c_cli
	
		fetch next from c_cli into 	@cli_razonsocial,
																@cli_nombre,
																@cliente,
																@cli_direccion,
																@cli_codpostal,
																@cli_localidad,
																@cli_direccion2,
																@cli_telefono,
																@pro_nombre
	
	
	while @@fetch_status=0
	begin

		if @n = 1 begin
	
			insert into #t_clientes( aux_id,
																cli_razonsocial_1,
																cli_nombre_1,
																cliente_1,
																cli_direccion_1,
																cli_codpostal_1,
																cli_localidad_1,
																cli_direccion2_1,
																cli_telefono_1,
																pro_nombre_1
															)
											values (
																@aux_id,
																@cli_razonsocial,
																@cli_nombre,
																@cliente,
																@cli_direccion,
																@cli_codpostal,
																@cli_localidad,
																@cli_direccion2,
																@cli_telefono,
																@pro_nombre
															)
	
	
		end else begin 
	
			if @n = 2 begin
	
				update #t_clientes set cli_razonsocial_2 	= @cli_razonsocial,
															 cli_nombre_2				=	@cli_nombre,
															 cliente_2					=	@cliente,
															 cli_direccion_2		=	@cli_direccion,
															 cli_codpostal_2		=	@cli_codpostal,
															 cli_localidad_2		=	@cli_localidad,
															 cli_direccion2_2		=	@cli_direccion2,
															 cli_telefono_2			=	@cli_telefono,
															 pro_nombre_2				=	@pro_nombre
				where aux_id = @aux_id
		
			end else begin 
	
				if @n = 3 begin
		
					update #t_clientes set cli_razonsocial_3 	= @cli_razonsocial,
																 cli_nombre_3				=	@cli_nombre,
																 cliente_3					=	@cliente,
																 cli_direccion_3		=	@cli_direccion,
																 cli_codpostal_3		=	@cli_codpostal,
																 cli_localidad_3		=	@cli_localidad,
																 cli_direccion2_3		=	@cli_direccion2,
																 cli_telefono_3			=	@cli_telefono,
																 pro_nombre_3				=	@pro_nombre
					where aux_id = @aux_id
			
					set @n = 0
					set @aux_id = @aux_id+1
			
				end
			end
		end
	
		set @n = @n+1
	
		fetch next from c_cli into 	@cli_razonsocial,
																@cli_nombre,
																@cliente,
																@cli_direccion,
																@cli_codpostal,
																@cli_localidad,
																@cli_direccion2,
																@cli_telefono,
																@pro_nombre
	
	
	end
	
	close c_cli
	deallocate c_cli
	
	select * from #t_clientes

end
go
 