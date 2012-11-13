/*

lsProyecto 'N631'

select * from rama where ram_nombre = 'Hojalmar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsProyecto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsProyecto]

go
create procedure lsProyecto (

@@proy_id			varchar(255)

)as 

declare @proy_id                int
declare @ram_id_proyecto        int

declare @clienteID 	int
declare @IsRaiz 		tinyint


exec sp_ArbConvertId @@proy_id, @proy_id out, @ram_id_proyecto out

if @ram_id_proyecto <> 0 begin

	exec sp_ArbIsRaiz @ram_id_proyecto, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_proyecto, @clienteID

	end else begin

		set @ram_id_proyecto = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

print @proy_id                
print @ram_id_proyecto        

select 
	
	proy_nombre, 
  proyi_nombre,
	usuario.us_nombre,
	obje_nombre

from 
	proyectoitem, 
	proyecto, 
	usuario,
	objetivo

where 

-- join
			proyecto.proy_id = proyectoitem.proy_id 
and 	proyecto.modifico = usuario.us_id
and	  objetivo.proy_id = proyecto.proy_id

-- filter
and		(proyecto.proy_id = @proy_id or @proy_id=0)
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = proyecto.proy_id
							   ) 
           )
        or 
					 (@ram_id_proyecto = 0)
			 )