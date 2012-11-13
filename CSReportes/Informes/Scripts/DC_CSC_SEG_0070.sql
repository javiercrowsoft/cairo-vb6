/*---------------------------------------------------------------------
  Nombre: Permisos por prestacion, usuario, agenda y departamento
---------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0070]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0070]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create procedure DC_CSC_SEG_0070 (

  @@us_id    int,

@@pre_id        varchar(255),
@@us_id_usuario varchar(255),
@@agn_id        varchar(255),
@@dpto_id       varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pre_id int
declare @us_id_usuario int
declare @agn_id int
declare @dpto_id int

declare @ram_id_prestacion int
declare @ram_id_usuario int
declare @ram_id_agenda int
declare @ram_id_dpto int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pre_id, @pre_id out, @ram_id_prestacion out
exec sp_ArbConvertId @@us_id_usuario, @us_id_usuario out, @ram_id_usuario out
exec sp_ArbConvertId @@agn_id, @agn_id out, @ram_id_agenda out
exec sp_ArbConvertId @@dpto_id, @dpto_id out, @ram_id_dpto out

exec sp_GetRptId @clienteID out

if @ram_id_prestacion <> 0 begin

--	exec sp_ArbGetGroups @ram_id_prestacion, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_prestacion, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_prestacion, @clienteID 
	end else 
		set @ram_id_prestacion = 0
end

if @ram_id_usuario <> 0 begin

--	exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
	end else 
		set @ram_id_usuario = 0
end

if @ram_id_agenda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_agenda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_agenda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_agenda, @clienteID 
	end else 
		set @ram_id_agenda = 0
end

if @ram_id_dpto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_dpto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_dpto, @clienteID 
	end else 
		set @ram_id_dpto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

  p.pre_id,
  dpto_nombre                       as Departamento,
  agn_nombre                        as Agenda,
  pre_nombre                        as Prestacion,
  us_nombre                         as Usuario,
  prs_apellido + ', ' + prs_nombre  as Persona,
  rol_nombre                        as Rol,
  prs_descrip                       as [Observaciones]

from 

    permiso p inner join prestacion pre on p.pre_id = pre.pre_id
              left  join usuario      u on (p.us_id  = u.us_id
                                           or exists(select rol_id from usuariorol
                                                     where  rol_id = p.rol_id
                                                        and us_id = u.us_id
                                                     )
                                           )
              left  join rol          r on p.rol_id = r.rol_id
              left  join persona prs    on u.prs_id = prs.prs_id
              left  join departamento d on (p.pre_id = d.pre_id_vernoticias
                                            or p.pre_id = d.pre_id_editarnoticias
                                            or p.pre_id = d.pre_id_vertareas
                                            or p.pre_id = d.pre_id_asignartareas
                                            or p.pre_id = d.pre_id_verdocumentos
                                            or p.pre_id = d.pre_id_agregardocumentos
                                            or p.pre_id = d.pre_id_borrardocumentos
                                            or p.pre_id = d.pre_id_editardocumentos)
              left join agenda a        on (p.pre_id = a.pre_id_agregar
                                            or p.pre_id = a.pre_id_editar
                                            or p.pre_id = a.pre_id_borrar
                                            or p.pre_id = a.pre_id_listar)
where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (pre.pre_id = @pre_id or @pre_id=0)
and   (u.us_id = @us_id_usuario or @us_id_usuario=0)
and   (a.agn_id = @agn_id or @agn_id=0)
and   (d.dpto_id = @dpto_id or @dpto_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1 -- tbl_id de Proyecto
                  and  rptarb_hojaid = p.pre_id
							   ) 
           )
        or 
					 (@ram_id_prestacion = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- tbl_id de Proyecto
                  and  rptarb_hojaid = p.us_id
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
                  and  tbl_id = 1015 -- select tbl_id from tabla where tbl_nombrefisico ='agenda'
                  and  rptarb_hojaid = d.dpto_id
							   ) 
           )
        or 
					 (@ram_id_dpto = 0)
			 )
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2010 -- select tbl_id from tabla where tbl_nombrefisico ='agenda'
                  and  rptarb_hojaid = a.agn_id
							   ) 
           )
        or 
					 (@ram_id_agenda = 0)
			 )


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

