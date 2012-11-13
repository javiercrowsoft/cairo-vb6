
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_WEB_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_WEB_0010]

GO

/*
DC_CSC_WEB_0010 
											1,
											'20200101',
											'0',
											'0',
											'0',
											'0'
select * from rama where ram_nombre like '%dvd%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_WEB_0010 (

  @@us_id    int,

	@@pr_id 		varchar(255),
	@@codigo1 	varchar(5000),
	@@codigo2		varchar(5000)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int

declare @ram_id_Producto int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out

exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
	end else 
		set @ram_id_Producto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

-- Articulos que no estan en un kit

update producto set 
			 pr_codigohtmldetalle = case when @@codigo1 <> '' then @@codigo1 else pr_codigohtmldetalle end, 
			 pr_codigohtml 				= case when @@codigo2 <> '' then @@codigo2 else pr_codigohtml end

where (pr_id = @pr_id or @pr_id=0)

	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 30 
	                  and  rptarb_hojaid = pr_id
								   ) 
	           )
	        or 
						 (@ram_id_Producto = 0)
				 )


	select 1 as aux, 'Se actualizaron los siguientes articulos:' as Info, ''

	union

	select pr_id, pr_nombrecompra, '' as dummy
	from producto
	where (pr_id = @pr_id or @pr_id=0)
	
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 30 
		                  and  rptarb_hojaid = pr_id
									   ) 
		           )
		        or 
							 (@ram_id_Producto = 0)
					 )


GO