/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_preguntas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_preguntas]

go
create procedure sp_lsdoc_preguntas (
  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@us_id_respondio     varchar(255),
  @@cli_id               varchar(255),

  @@nick       varchar(1000),
  @@pregunta  varchar(1000),
  @@observada tinyint

)as 

begin

set nocount on

set @@nick = replace(@@nick,'*','%')
set @@pregunta = replace(@@pregunta,'*','%')

/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare  @us_id_respondio       int
declare  @cli_id               int

declare @ram_id_respondio     int
declare @ram_id_cliente       int

declare @clienteID             int
declare @IsRaiz                tinyint

exec sp_ArbConvertId @@us_id_respondio, @us_id_respondio out, @ram_id_respondio out
exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out

exec sp_GetRptId @clienteID out

if @ram_id_respondio <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_respondio, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_respondio, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_respondio, @clienteID
  end else 
    set @ram_id_respondio = 0
end

if @ram_id_cliente <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

  cmip_id,
  ''                           as TypeTask,
  cmip_nick + '   ' + isnull(cli_nombre,'')                   
                              as Cliente,
  cmip_fecha                   as [Fecha Pregunta],
  cmip_fecha_respuesta         as [Fecha Respuesta],
  us.us_nombre                 as Respondio,

  cmip_articuloid             as Codigo,
  case when cmip_articulo = '' then pr_nombreventa else cmip_articulo end as Articulo,
  cmi_nombre                  as Cliente,
  cmip_pregunta + char(10) 
              + char(10) + '-----------------------------------' 
              + char(10) + '   respuesta ' 
              + char(10) + '-----------------------------------' 
              + char(10) + cmip_respuesta + char(10) 
              + char(10) + '-----------------------------------' 
              + char(10) + '   Observaciones ' 
              + char(10) + '-----------------------------------'
              + char(10) + cmip_descrip
                              as Descripcion

from 

    ComunidadInternetPregunta cmip 
      left join Cliente cli   on cmip_nick = substring(cli_codigocomunidad,5,100)
      left join ProductoComunidadInternet prcmi on prcmi_codigo = cmip_articuloid
      left join Producto pr on prcmi.pr_id = pr.pr_id
      left join ComunidadInternet cmi on cmip.cmi_id = cmi.cmi_id
      left join usuario us on cmip.us_id_respondio = us.us_id

where 

    -- Filtros
    (
        
          @@Fini <= cmip_fecha
      and  @@Ffin >= cmip_fecha

      and (
                cmip_pregunta like @@pregunta 
            or   cmip_respuesta like @@pregunta
            or   @@pregunta = ''
          )
      and (cmip_nick like @@nick or @@nick = '')
      and (cmip_descrip <> '' or @@observada = 0)

    ) 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (us.us_id     = @us_id_respondio    or @us_id_respondio=0)
and   (cli.cli_id   = @cli_id             or @cli_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 3 -- usuario
                  and  rptarb_hojaid = cmip.us_id_respondio
                 ) 
           )
        or 
           (@ram_id_respondio = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 -- cliente
                  and  rptarb_hojaid = cli.cli_id
                 ) 
           )
        or 
           (@ram_id_cliente = 0)
       )

  order by cmip_fecha
end

go