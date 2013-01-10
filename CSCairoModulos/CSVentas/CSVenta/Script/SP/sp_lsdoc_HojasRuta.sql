/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_HojasRuta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_HojasRuta]


/*

sp_lsdoc_HojasRuta 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_lsdoc_HojasRuta (
  @@us_id    int,

  @@Fini      datetime,
  @@Ffin      datetime,

  @@hr_nrodoc        varchar(255),
  @@cam_id          varchar(255),
  @@prs_id          varchar(255)

)as 

begin

  set nocount on
  
/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cam_id int
declare @prs_id int

declare @ram_id_Camion int
declare @ram_id_Persona int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cam_id,       @cam_id out,       @ram_id_Camion out
exec sp_ArbConvertId @@prs_id,       @prs_id out,       @ram_id_Persona out

exec sp_GetRptId @clienteID out

if @ram_id_Camion <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Camion, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Camion, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Camion, @clienteID 
  end else 
    set @ram_id_Camion = 0
end

if @ram_id_Persona <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Persona, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Persona, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Persona, @clienteID 
  end else 
    set @ram_id_Persona = 0
end

if isnumeric (@@hr_nrodoc)<> 0 set @@hr_nrodoc = right('00000000'+@@hr_nrodoc,8)

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

  hr_id,
  ''                as TypeTask,
  hr_fecha          as Fecha,
  hr_nrodoc          as Numero,
  prs_nombre        as [Salida de],
  cam_patente        as Camion,
  hr.creado          as Creado,
  hr.modificado      as Modificado,
  us.us_nombre      as Modifico,
  case when hr_cumplida <> 0 then 'Si' else 'No' end as Cumplida,
  hr_descrip        as [Descripción]

from 

    HojaRuta hr  inner join Usuario us    on hr.modifico = us.us_id
                left  join Camion cam    on hr.cam_id    = cam.cam_id
                left  join Persona prs   on hr.prs_id   = prs.prs_id

where 
          @@Fini <= hr_fecha
      and  @@Ffin >= hr_fecha     
      and (hr.hr_nrodoc = @@hr_nrodoc or @@hr_nrodoc = '')

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (hr.cam_id   = @cam_id         or @cam_id = 0)
and   (hr.prs_id   = @prs_id         or @prs_id = 0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1019
                  and  rptarb_hojaid = hr.cam_id
                 ) 
           )
        or 
           (@ram_id_Camion = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1004
                  and  rptarb_hojaid = hr.prs_id
                 ) 
           )
        or 
           (@ram_id_Persona = 0)
       )

  order by hr_fecha, hr_nrodoc

end
go