/*

sp_lsdoc_alarmas 

                0,
                '20000101',
                '20100101',
                '0',
                '0',
                '0',
                '0',
                '0',
                '0',
                '',
                ''

select * from rama where ram_nombre like '%elva%'

select 25.0*(40.0/60.0)

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_alarmas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_alarmas]

go
create procedure sp_lsdoc_alarmas (
  @@us_id    int,

	@@cli_id 							varchar(255),
	@@proy_id 						varchar(255)

)as 

begin

set nocount on

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @proy_id int

declare @ram_id_cliente int
declare @ram_id_proyecto int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@proy_id, @proy_id out, @ram_id_proyecto out

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_proyecto <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_proyecto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proyecto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proyecto, @clienteID 
	end else 
		set @ram_id_proyecto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

	al_id,
	''                as TypeTask,
  cli_nombre				as Cliente,
	proy_nombre				as Proyecto,
	rub_nombre        as [Rubro],
	al_nombre				  as Nombre,
	al_codigo 			  as [Código],
	al_descrip				as [Descripción]

from 

		Alarma al		left join proyecto proy     		on al.proy_id 	= proy.proy_id
								left join cliente c             on al.cli_id 		= c.cli_id
								left join rubro rub             on al.rub_id    = rub.rub_id
where 


/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

		  (c.cli_id            = @cli_id             or @cli_id=0)
and   (proy.proy_id        = @proy_id            or @proy_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = c.cli_id
							   ) 
           )
        or 
					 (@ram_id_cliente = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2005 
                  and  rptarb_hojaid = proy.proy_id
							   ) 
           )
        or 
					 (@ram_id_proyecto = 0)
			 )

end
go