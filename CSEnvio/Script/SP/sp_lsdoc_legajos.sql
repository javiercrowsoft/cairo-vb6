/*

sp_lsdoc_legajos 

                0,
                '20000101',
                '20100101',
                '0',
                '0',
                '',
                '',
                ''

select * from rama where ram_nombre like '%elva%'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_legajos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_legajos]

go
create procedure sp_lsdoc_legajos (
  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@est_id 							varchar(255),
	@@cli_id 							varchar(255),

  @@descrip  varchar(1000),
  @@titulo   varchar(1000),
  @@codigo   varchar(1000)
)as 

begin

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @est_id int

declare @ram_id_cliente int
declare @ram_id_estado int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_estado out

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_estado <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_estado, @clienteID 
	end else 
		set @ram_id_estado = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

	lgj_id,
	'TypeTask'	  = '',
  'Cliente'     = cli_nombre,
	'Estado'	    = est_nombre,
	'Código'      = lgj_codigo,
	'Título'	    = lgj_titulo,
	'Fecha'       = lgj_fecha,
	'Descripción' = lgj_descrip

from 

		legajo lgj 	inner join estado est 	on lgj.est_id	=	est.est_id
    				 		left  join cliente cli  on lgj.cli_id = cli.cli_id
where 


		(
				
				  @@Fini <= lgj_fecha
			and	@@Ffin >= lgj_fecha 		

      and (@@descrip 					like lgj.lgj_descrip or @@descrip  = '')
      and (@@titulo 					like lgj.lgj_titulo  or @@titulo   = '')
		) 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.cli_id            = @cli_id             or @cli_id=0)
and   (est.est_id            = @est_id             or @est_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cli.cli_id
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
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = est.est_id
							   ) 
           )
        or 
					 (@ram_id_estado = 0)
			 )

	order by lgj_fecha
end
go