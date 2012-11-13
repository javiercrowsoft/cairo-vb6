/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de venta
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9970]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9970]

-- exec [DC_CSC_COM_9970] 1,'0'

go
create procedure DC_CSC_COM_9970 (

  @@us_id    		int,

  @@prov_id   		varchar(255)  

)as 
begin

  set nocount on

declare @prov_id   		int

declare @ram_id_Proveedor       int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@prov_id,  		 @prov_id out,  			@ram_id_Proveedor 	out
  
exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @ProveedorID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
	end else 
		set @ram_id_Proveedor = 0
end

		create table #t_Proveedores( aux_id              int,
															prov_razonsocial_1 		varchar(255),
															prov_nombre_1 				varchar(255),
															Proveedor_1 					varchar(255),
															prov_direccion_1 			varchar(1000),
															prov_codpostal_1 			varchar(50),
															prov_localidad_1 			varchar(100),
															prov_direccion2_1 		varchar(1000),
															prov_telefono_1 			varchar(100),
															pro_nombre_1 					varchar(100),

															prov_razonsocial_2 		varchar(255),
															prov_nombre_2 				varchar(255),
															Proveedor_2 					varchar(255),
															prov_direccion_2 			varchar(1000),
															prov_codpostal_2 			varchar(50),
															prov_localidad_2 			varchar(100),
															prov_direccion2_2 		varchar(1000),
															prov_telefono_2 			varchar(100),
															pro_nombre_2 					varchar(100),

															prov_razonsocial_3 		varchar(255),
															prov_nombre_3 				varchar(255),
															Proveedor_3 					varchar(255),
															prov_direccion_3 			varchar(1000),
															prov_codpostal_3 			varchar(50),
															prov_localidad_3 			varchar(100),
															prov_direccion2_3 		varchar(1000),
															prov_telefono_3 			varchar(100),
															pro_nombre_3 					varchar(100)


															)

	declare 	@prov_razonsocial 		varchar(255),
						@prov_nombre 					varchar(255),
						@Proveedor 						varchar(255),
						@prov_direccion 			varchar(1000),
						@prov_codpostal 			varchar(50),
						@prov_localidad 			varchar(255),
						@prov_direccion2 			varchar(1000),
						@prov_telefono 				varchar(255),
						@pro_nombre 					varchar(255)
	
	
	declare c_prov insensitive cursor for 
	
			select 	prov_razonsocial,
							prov_nombre,
							prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
												         as [Proveedor],

							substring(	
							prov_calle + ' ' + 
							prov_callenumero + ' ' + 
							prov_piso + ' ' + 
							prov_codpostal + ' ' + 
							prov_localidad,1,1000) 		 as prov_direccion,
	
							'(CP '+prov_codpostal+')' 	 as prov_codpostal,

							substring(prov_localidad,1,100) as prov_localidad,
	
							substring(
							prov_calle + ' ' + 
							prov_callenumero + ' ' + 
							prov_piso,1,1000)					 as prov_direccion2,

							substring(
							'Tel: ' + 
							prov_tel  + ' | Fax:' + 
							prov_fax  + ' | Email: ' + 
							prov_email  + ' | Web:' + 
							prov_web,1,100)					   	 as prov_telefono,

							case when prov_localidad = pro_nombre then '' else pro_nombre end as pro_nombre

	
			from Proveedor prov left join Provincia pro on prov.pro_id = pro.pro_id
		  where (prov_id = @prov_id or @prov_id = 0)
		  and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 29 
		                  and  rptarb_hojaid = prov_id
									   ) 
		           )
		        or 
							 (@ram_id_Proveedor = 0)
					 )									

	declare @n int
	set @n = 1
	
	declare @aux_id int
	set @aux_id = 1
	
	open c_prov
	
		fetch next from c_prov into 	@prov_razonsocial,
																@prov_nombre,
																@Proveedor,
																@prov_direccion,
																@prov_codpostal,
																@prov_localidad,
																@prov_direccion2,
																@prov_telefono,
																@pro_nombre
	
	
	while @@fetch_status=0
	begin

		if @n = 1 begin
	
			insert into #t_Proveedores( aux_id,
																prov_razonsocial_1,
																prov_nombre_1,
																Proveedor_1,
																prov_direccion_1,
																prov_codpostal_1,
																prov_localidad_1,
																prov_direccion2_1,
																prov_telefono_1,
																pro_nombre_1
															)
											values (
																@aux_id,
																@prov_razonsocial,
																@prov_nombre,
																@Proveedor,
																@prov_direccion,
																@prov_codpostal,
																@prov_localidad,
																@prov_direccion2,
																@prov_telefono,
																@pro_nombre
															)
	
	
		end else begin 
	
			if @n = 2 begin
	
				update #t_Proveedores set prov_razonsocial_2 	= @prov_razonsocial,
															 prov_nombre_2				=	@prov_nombre,
															 Proveedor_2					=	@Proveedor,
															 prov_direccion_2		=	@prov_direccion,
															 prov_codpostal_2		=	@prov_codpostal,
															 prov_localidad_2		=	@prov_localidad,
															 prov_direccion2_2		=	@prov_direccion2,
															 prov_telefono_2			=	@prov_telefono,
															 pro_nombre_2				=	@pro_nombre
				where aux_id = @aux_id
		
			end else begin 
	
				if @n = 3 begin
		
					update #t_Proveedores set prov_razonsocial_3 	= @prov_razonsocial,
																 prov_nombre_3				=	@prov_nombre,
																 Proveedor_3					=	@Proveedor,
																 prov_direccion_3		=	@prov_direccion,
																 prov_codpostal_3		=	@prov_codpostal,
																 prov_localidad_3		=	@prov_localidad,
																 prov_direccion2_3		=	@prov_direccion2,
																 prov_telefono_3			=	@prov_telefono,
																 pro_nombre_3				=	@pro_nombre
					where aux_id = @aux_id
			
					set @n = 0
					set @aux_id = @aux_id+1
			
				end
			end
		end
	
		set @n = @n+1
	
		fetch next from c_prov into 	@prov_razonsocial,
																@prov_nombre,
																@Proveedor,
																@prov_direccion,
																@prov_codpostal,
																@prov_localidad,
																@prov_direccion2,
																@prov_telefono,
																@pro_nombre
	
	
	end
	
	close c_prov
	deallocate c_prov
	
	select * from #t_Proveedores

end
go
 