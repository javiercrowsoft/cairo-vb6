if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_embarques]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_embarques]
go
/*

sp_lsdoc_embarques 7,'20000101','21000101','0','0','0',2

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_embarques]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_embarques]

go
create procedure sp_lsdoc_embarques (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@pue_id_origen 	varchar(255),
@@pue_id_destino 	varchar(255),
@@barc_id					varchar(255),
@@activa	    		tinyint
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pue_id_origen int
declare @pue_id_destino int
declare @barc_id int

declare @ram_id_origen int
declare @ram_id_destino int
declare @ram_id_barco int

declare @clienteID int
declare @clienteID2 int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pue_id_origen, @pue_id_origen out, @ram_id_origen out
exec sp_ArbConvertId @@pue_id_destino, @pue_id_destino out, @ram_id_destino out
exec sp_ArbConvertId @@barc_id, @barc_id out, @ram_id_barco out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteID2 out

if @ram_id_origen <> 0 begin

--	exec sp_ArbGetGroups @ram_id_origen, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_origen, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_origen, @clienteID 
	end else 
		set @ram_id_origen = 0
end

if @ram_id_destino <> 0 begin

--	exec sp_ArbGetGroups @ram_id_destino, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_destino, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_destino, @clienteID2 
	end else 
		set @ram_id_destino = 0
end

if @ram_id_barco <> 0 begin

--	exec sp_ArbGetGroups @ram_id_barco, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_barco, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_barco, @clienteID 
	end else 
		set @ram_id_barco = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @ambas tinyint
set @ambas = 2

select

	emb_id,
	'TypeTask'			= '',
	'Embarque'			= emb_nombre,
  'Codigo' 				= emb_codigo,
	'Fecha'					= emb_fecha,
	'Activo'				= case 
										when e.activo <> 0 then 	'Si'
										else 				'No'
										end,
	'Barco'					= barc_nombre,
	'Puerto Origen'	= o.pue_nombre,
	'Puerto Destino'= d.pue_nombre,
	
	-- Tiene que ser la ultima columna para que funcione bien el ABM de documentos
	'Descripcion'  	= emb_descrip

from 
				Embarque e inner join Barco b 		on e.barc_id = b.barc_id
                   inner join Puerto o 		on e.pue_id_origen  = o.pue_id
                   inner join Puerto d 		on e.pue_id_destino = d.pue_id

where 

				  @@Fini <= emb_fecha
			and	@@Ffin >= emb_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (o.pue_id  = @pue_id_origen  or @pue_id_origen=0)
and   (d.pue_id  = @pue_id_destino or @pue_id_destino=0)
and   (b.barc_id = @barc_id or @barc_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = o.pue_id
							   ) 
           )
        or 
					 (@ram_id_origen = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID2
                  and  tbl_id = 12005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.pue_id
							   ) 
           )
        or 
					 (@ram_id_destino = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12004 -- tbl_id de Proyecto
                  and  rptarb_hojaid = b.barc_id
							   ) 
           )
        or 
					 (@ram_id_barco = 0)
			 )
go
