/*

  Nombre: Historia de uso por usuario o departamento

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_WAU_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_WAU_0010]

/*

DC_CSC_WAU_0010 1,'20010101','20100101','0','0',3002001

*/

go
create procedure DC_CSC_WAU_0010 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@us_id_usuario varchar(255),
@@dpto_id       varchar(255),
@@tipo  	      int,
@@resumido      smallint = 1
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @us_id_usuario int
declare @dpto_id int

declare @ram_id_usuario int
declare @ram_id_departamento int

declare @clienteID int
declare @IsRaiz    tinyint

set @@Ffin = DateAdd(d,1,@@Ffin)

exec sp_ArbConvertId @@us_id_usuario, @us_id_usuario out, @ram_id_usuario out
exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_departamento out

exec sp_GetRptId @clienteID out

if @ram_id_usuario <> 0 begin

--	exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
	end else 
		set @ram_id_usuario = 0
end

if @ram_id_departamento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_departamento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_departamento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_departamento, @clienteID 
	end else 
		set @ram_id_departamento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


if @@resumido <> 0 begin

select 
    u.us_id,
    convert(varchar(12),h.modificado,103) Fecha,
    us_nombre as Usuario,
    prs_apellido + ', ' + prs_nombre as Persona,
    case
      when tbl_id = 25000        and hst_operacion = 1    then    'Cambiar estado de una noticia'
      when tbl_id = 25000        and hst_operacion = 2    then    'Modificar noticia'
      when tbl_id = 25000        and hst_operacion = 3    then    'Ver noticias'
      when tbl_id = 25000        and hst_operacion = 4    then    'Borrar noticias'
      when tbl_id = 1015         and hst_operacion = 1    then    'Departamentos por usuario'
      when tbl_id = 1015         and hst_operacion = 2    then    'Departamento por usuario'
      when tbl_id = 1015         and hst_operacion = 3    then    'Puede editar el departamento?'
      when tbl_id = 2001         and hst_operacion = 1    then    'Modificar contacto'
      when tbl_id = 2001         and hst_operacion = 2    then    'Contactos por usuario'
      when tbl_id = 2001         and hst_operacion = 3    then    'Borrar contacto'
      when tbl_id = 3            and hst_operacion = 1    then    'Cambiar clave'
      when tbl_id = 3            and hst_operacion = 2    then    'Consultar el indice corporativo'

      when tbl_id = 3            and hst_operacion = 3    
                                 and hst_descrip   = '1'  then    'Login exitoso'

      when tbl_id = 3            and hst_operacion = 3    
                                 and hst_descrip   = '0'  then    'Login fallido por clave invalida'

      when tbl_id = 3            and hst_operacion = 4    then    'Consultar un registro del indice corporativo'
      when tbl_id = 2010         and hst_operacion = 1    then    'Obtener agenda personal'
      when tbl_id = 1            and hst_operacion = 1    then    'Tiene acceso a la prestacion?'
      when tbl_id = 7001         and hst_operacion = 1    then    'Listar reportes por usuario y seccion'
      when tbl_id = 7001         and hst_operacion = 2    then    'Obtener definicion de un reporte'
      when tbl_id = 15002        and hst_operacion = 1    then    'Actualizar alarma'
      when tbl_id = 15002        and hst_operacion = 2    then    'Modificar Parte diario'
      when tbl_id = 15002        and hst_operacion = 3    then    'Listar Parte diario'
      when tbl_id = 15002        and hst_operacion = 4    then    'Borrar Parte diario'
      when tbl_id = 15002        and hst_operacion = 5    then    'Editar estado del Parte diario'
      when tbl_id = 15002        and hst_operacion = 6    then    'Listar reclamos de La Europea'
      else                                                        'Sin definir'
  end as Operacion,

  hst_descrip as observaciones

from Historia h inner join Usuario u on h.modifico = u.us_id
                left  join Persona p on u.prs_id = p.prs_id
                left  join Departamento d on p.dpto_id = d.dpto_id
where 

				  h.modificado >= @@Fini
			and	h.modificado <= @@Ffin 
      and ((h.tbl_id + hst_operacion *1000000) = @@tipo or @@tipo = 0)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (h.modifico = @us_id_usuario or @us_id_usuario=0)
and   (d.dpto_id = @dpto_id or @dpto_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- tbl_id de Proyecto
                  and  rptarb_hojaid = h.modifico
							   ) 
           )
        or 
					 (@ram_id_usuario = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1015 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.dpto_id
							   ) 
           )
        or 
					 (@ram_id_departamento = 0)
			 )

group by

    u.us_id,
    convert(varchar(12),h.modificado,103),
    us_nombre,
    prs_apellido + ', ' + prs_nombre,
    case
      when tbl_id = 25000        and hst_operacion = 1    then    'Cambiar estado de una noticia'
      when tbl_id = 25000        and hst_operacion = 2    then    'Modificar noticia'
      when tbl_id = 25000        and hst_operacion = 3    then    'Ver noticias'
      when tbl_id = 25000        and hst_operacion = 4    then    'Borrar noticias'
      when tbl_id = 1015         and hst_operacion = 1    then    'Departamentos por usuario'
      when tbl_id = 1015         and hst_operacion = 2    then    'Departamento por usuario'
      when tbl_id = 1015         and hst_operacion = 3    then    'Puede editar el departamento?'
      when tbl_id = 2001         and hst_operacion = 1    then    'Modificar contacto'
      when tbl_id = 2001         and hst_operacion = 2    then    'Contactos por usuario'
      when tbl_id = 2001         and hst_operacion = 3    then    'Borrar contacto'
      when tbl_id = 3            and hst_operacion = 1    then    'Cambiar clave'
      when tbl_id = 3            and hst_operacion = 2    then    'Consultar el indice corporativo'

      when tbl_id = 3            and hst_operacion = 3    
                                 and hst_descrip   = '1'  then    'Login exitoso'

      when tbl_id = 3            and hst_operacion = 3    
                                 and hst_descrip   = '0'  then    'Login fallido por clave invalida'

      when tbl_id = 3            and hst_operacion = 4    then    'Consultar un registro del indice corporativo'
      when tbl_id = 2010         and hst_operacion = 1    then    'Obtener agenda personal'
      when tbl_id = 1            and hst_operacion = 1    then    'Tiene acceso a la prestacion?'
      when tbl_id = 7001         and hst_operacion = 1    then    'Listar reportes por usuario y seccion'
      when tbl_id = 7001         and hst_operacion = 2    then    'Obtener definicion de un reporte'
      when tbl_id = 15002        and hst_operacion = 1    then    'Actualizar alarma'
      when tbl_id = 15002        and hst_operacion = 2    then    'Modificar Parte diario'
      when tbl_id = 15002        and hst_operacion = 3    then    'Listar Parte diario'
      when tbl_id = 15002        and hst_operacion = 4    then    'Borrar Parte diario'
      when tbl_id = 15002        and hst_operacion = 5    then    'Editar estado del Parte diario'
      when tbl_id = 15002        and hst_operacion = 6    then    'Listar reclamos de La Europea'
      else                                                        'Sin definir'
  end,

  hst_descrip

end else begin

select 
    u.us_id,
    convert(varchar(12),h.modificado,103) Fecha,
    convert(varchar(2),datepart(hh,h.modificado)) + ':' 
    + convert(varchar(2),datepart(n,h.modificado)) + ':'
    + convert(varchar(2),datepart(s,h.modificado)) Hora,
    us_nombre as Usuario,
    prs_apellido + ', ' + prs_nombre as Persona,
    case
      when tbl_id = 25000        and hst_operacion = 1    then    'Cambiar estado de una noticia'
      when tbl_id = 25000        and hst_operacion = 2    then    'Modificar noticia'
      when tbl_id = 25000        and hst_operacion = 3    then    'Ver noticias'
      when tbl_id = 25000        and hst_operacion = 4    then    'Borrar noticias'
      when tbl_id = 1015         and hst_operacion = 1    then    'Departamentos por usuario'
      when tbl_id = 1015         and hst_operacion = 2    then    'Departamento por usuario'
      when tbl_id = 1015         and hst_operacion = 3    then    'Puede editar el departamento?'
      when tbl_id = 2001         and hst_operacion = 1    then    'Modificar contacto'
      when tbl_id = 2001         and hst_operacion = 2    then    'Contactos por usuario'
      when tbl_id = 2001         and hst_operacion = 3    then    'Borrar contacto'
      when tbl_id = 3            and hst_operacion = 1    then    'Cambiar clave'
      when tbl_id = 3            and hst_operacion = 2    then    'Consultar el indice corporativo'

      when tbl_id = 3            and hst_operacion = 3    
                                 and hst_descrip   = '1'  then    'Login exitoso'

      when tbl_id = 3            and hst_operacion = 3    
                                 and hst_descrip   = '0'  then    'Login fallido por clave invalida'

      when tbl_id = 3            and hst_operacion = 4    then    'Consultar un registro del indice corporativo'
      when tbl_id = 2010         and hst_operacion = 1    then    'Obtener agenda personal'
      when tbl_id = 1            and hst_operacion = 1    then    'Tiene acceso a la prestacion?'
      when tbl_id = 7001         and hst_operacion = 1    then    'Listar reportes por usuario y seccion'
      when tbl_id = 7001         and hst_operacion = 2    then    'Obtener definicion de un reporte'
      when tbl_id = 15002        and hst_operacion = 1    then    'Actualizar alarma'
      when tbl_id = 15002        and hst_operacion = 2    then    'Modificar Parte diario'
      when tbl_id = 15002        and hst_operacion = 3    then    'Listar Parte diario'
      when tbl_id = 15002        and hst_operacion = 4    then    'Borrar Parte diario'
      when tbl_id = 15002        and hst_operacion = 5    then    'Editar estado del Parte diario'
      when tbl_id = 15002        and hst_operacion = 6    then    'Listar reclamos de La Europea'
      else                                                        'Sin definir'
  end as Operacion,

  hst_descrip as observaciones

from Historia h inner join Usuario u on h.modifico = u.us_id
                left  join Persona p on u.prs_id = p.prs_id
                left  join Departamento d on p.dpto_id = d.dpto_id
where 

				  h.modificado >= @@Fini
			and	h.modificado <= @@Ffin 
      and ((h.tbl_id + hst_operacion *1000000) = @@tipo or @@tipo = 0)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (h.modifico = @us_id_usuario or @us_id_usuario=0)
and   (d.dpto_id = @dpto_id or @dpto_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- tbl_id de Proyecto
                  and  rptarb_hojaid = h.modifico
							   ) 
           )
        or 
					 (@ram_id_usuario = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1015 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.dpto_id
							   ) 
           )
        or 
					 (@ram_id_departamento = 0)
			 )
end

GO