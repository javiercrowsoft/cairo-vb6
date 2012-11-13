-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Lista de tareas entre fechas
---------------------------------------------------------------------*/
/*

DC_CSC_PRY_0050
                  1,
                  '20010101',
                  '20100101',
                  '0'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRY_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRY_0050]

go
create procedure DC_CSC_PRY_0050 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@us_id_agenda				varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @us_id_agenda int

declare @ram_id_usuarioAgenda int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_agenda, @us_id_agenda out, @ram_id_usuarioAgenda out

exec sp_GetRptId @clienteID out

if @ram_id_usuarioAgenda <> 0 begin

	-- exec sp_ArbGetGroups @ram_id_usuarioAgenda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_usuarioAgenda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_usuarioAgenda, @clienteID 
	end else 
		set @ram_id_usuarioAgenda = 0
end


/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

		ptd_id,
		ptd_numero				as Numero,
		ptd_titulo        as Titulo,
		ptd_descrip       as Descrip,
		ptd_fechaini			as Inicio,
		ptd_fechafin      as Fin,
		ptd_cumplida      as Cumplida,
    ptd_horaini       as [Hora Desde],
    ptd_horafin       as [Hora Hasta],
		us_nombre         as Usuario,
		prs_apellido 
		+ ' ' 
		+ prs_nombre      as Persona,
		cont_nombre       as Contacto,
		tarest_nombre     as Estado,
		prio_nombre       as Prioridad,
    cli_nombre        as Cliente,
    prov_nombre       as Proveedor

from 

		partediario ptd left join usuario us on ptd.us_id_responsable = us.us_id
										left join persona prs on us.prs_id = prs.prs_id
										left join contacto cont on ptd.cont_id = cont.cont_id
										left join tareaestado tarest on ptd.tarest_id = tarest.tarest_id
                    left join prioridad prio on ptd.prio_id = prio.prio_id
										left join cliente cli on ptd.cli_id = cli.cli_id
                    left join proveedor prov on ptd.prov_id = prov.prov_id
where 

		-- Filtros
		(
				
				  @@Fini <= ptd_fechaini
			and	@@Ffin >= ptd_fechafin

		) 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (ptd.us_id_responsable = @us_id_agenda or @us_id_agenda=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 
                  and  rptarb_hojaid = ptd.us_id_responsable
							   ) 
           )
        or 
					 (@ram_id_usuarioAgenda = 0)
			 )
end
go