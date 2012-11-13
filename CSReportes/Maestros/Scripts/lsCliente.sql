/*

Lo primero es guardar como NO SEAN GILI....

Nota: todos los ejemplos se basan en un listado sobre la tabla proyecto

Completen los pasos en secuencia:

1)
lsCliente         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
cli_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_cliente      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Cliente Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
28      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

												select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Cliente%'

Para testear:

lsCliente 'n677'

select * from rama where ram_nombre like '%cliente%'

select * from arbol where arb_id in (1,99)

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsCliente]

go
create procedure lsCliente (

@@cli_id			varchar(255)

)as 
Begin
  declare @cli_id int
  declare @ram_id_cliente int

  declare @clienteID 	int
  declare @IsRaiz 		tinyint

  exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out

  if @ram_id_cliente <> 0 begin

	  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out

    if @IsRaiz = 0 begin

		  exec sp_GetRptId @clienteID out
		  exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID

	  end else begin

		  set @ram_id_cliente = 0
  	  set @clienteID = 0
	  end

  end else begin

	  set @clienteID = 0

  end

  select 
	  cliente.*,
    cli_calle + ' ' + cli_callenumero as  direccion,
	  pro_nombre,
    pa_nombre,
		cpg_nombre

  from 

	  Cliente left join Provincia on 	cliente.pro_id = provincia.pro_id  
            left join Pais      on  provincia.pa_id = pais.pa_id
						left join CondicionPago cpg on Cliente.cpg_id = cpg.cpg_id
  where 
  	
      (Cliente.cli_id = @cli_id or @cli_id=0)
    

  -- Arboles
  and   (
					  (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 28 -- tbl_id de Proyecto
                    and  rptarb_hojaid = Cliente.cli_id
							     ) 
             )
          or 
					   (@ram_id_cliente = 0)
			   )

  order by cliente.cli_nombre
end
GO
