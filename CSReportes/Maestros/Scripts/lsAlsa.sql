/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto
Completen los pasos en secuencia:

1)
lsAlsa         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
alsa_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_alsa      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Alsa Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
11000      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Alsa%'

Para testear:

lsAlsa 'N596'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsAlsa]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsAlsa]

go
create procedure lsAlsa (

@@alsa_id			varchar(255)

)as 

declare @alsa_id int
declare @ram_id_alsa int

declare @clienteID 	int
declare @IsRaiz 		tinyint

exec sp_ArbConvertId @@alsa_id, @alsa_id out, @ram_id_alsa out

if @ram_id_alsa <> 0 begin

	exec sp_ArbIsRaiz @ram_id_alsa, @IsRaiz out

  if @IsRaiz = 0 begin

		exec sp_GetRptId @clienteID out
		exec sp_ArbGetAllHojas @ram_id_alsa, @clienteID

	end else begin

		set @ram_id_alsa = 0
  	set @clienteID = 0
	end

end else begin

	set @clienteID = 0

end

select alsa.*,
       case alsa_tipoMadera
       when 1 then 'Pino'
       when 2 then 'Calden'
       when 3 then 'Saligna'
       else 'Sin definir'
       end
       as TipoMadera, 

       case alsa_tipoCamara
       when 1 then 'Con cría'
       when 2 then 'Melaria'
       else 'Sin definir'
       end
       as TipoCamara,

       case alsa_tipoAlsa
       when 1 then 'Media alsa'
       when 2 then 'Alsa'
       else 'Sin definir'
       end
       as TipoAlsa,
      
       colm_codigo

-- Listado de columnas que corresponda	

from 

    alsa left join colmena on alsa.colm_id = colmena.colm_id

where 
      (Alsa.alsa_id = @alsa_id or @alsa_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11000 -- tbl_id de Alsa
                  and  rptarb_hojaid = Alsa.alsa_id
							   ) 
           )
        or 
					 (@ram_id_alsa = 0)
			 )