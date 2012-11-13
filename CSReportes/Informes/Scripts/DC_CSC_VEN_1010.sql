/*---------------------------------------------------------------------
Nombre: Catalogo Web

Lista los articulos asociados a un catalgo web

Esta sin terminar.

Falta agregarle los parametros

Catalogo web		obvio
Rubro 1 al 10   para filtrar por atributos de los articulos
url							para filtrar por sitio web
---------------------------------------------------------------------*/
/*  

Para testear:

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_1010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_1010]

go
create procedure DC_CSC_VEN_1010 (

  @@us_id    		int,

  @@pr_id           varchar(255)

)as 
begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id        int

declare @ram_id_producto         int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id,  		 	 @pr_id out,  			@ram_id_producto out

exec sp_GetRptId @clienteID out

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

select catw_nombre, pr_nombreventa, pr_nombrecompra, pr_nombreweb, pr_aliasweb, rubti_nombre
from catalogoweb catw inner join catalogowebitem catwi on catw.catw_id = catwi.catw_id
                      inner join producto pr on catwi.pr_id = pr.pr_id
										  inner join rubrotablaitem rubti on pr.rubti_id7 = rubti.rubti_id

where catw.catw_id = 3

and rubti_nombre not like '%original%'

order by catw_nombre, rubti_nombre, pr_nombreventa


				and   (fvi.pr_id   = @pr_id    or @pr_id  =0)
		    and   (
		    					(exists(select rptarb_hojaid 
		                      from rptArbolRamaHoja 
		                      where
		                           rptarb_cliente = @clienteID
		                      and  tbl_id = 30 
		                      and  rptarb_hojaid = fvi.pr_id
		    							   ) 
		               )
		            or 
		    					 (@ram_id_producto = 0)
		    			 )


-- delete catalogowebitem where catwi_id in (
-- 	select catwi_id
-- 	from catalogoweb catw inner join catalogowebitem catwi on catw.catw_id = catwi.catw_id
-- 	                      inner join producto pr on catwi.pr_id = pr.pr_id
-- 											  inner join rubrotablaitem rubti on pr.rubti_id7 = rubti.rubti_id
-- 	
-- 	where  rubti_nombre not like '%original%'
-- )
--order by catw_nombre, rubti_nombre, pr_nombreventa


--select * from catalogoweb

end
go
