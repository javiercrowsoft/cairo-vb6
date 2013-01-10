/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_EmpleadoPeriodos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_EmpleadoPeriodos]


/*

sp_lsdoc_EmpleadoPeriodos 1,'20070101','20071128',0,'0','0'

*/

go
create procedure sp_lsdoc_EmpleadoPeriodos (
  @@us_id    int,

  @@Fini      datetime,
  @@Ffin      datetime,

  @@empe_numero      int,
  @@ccos_id          varchar(255),
  @@em_id           varchar(255)

)as 

begin

  set nocount on
  
/* -///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @ccos_id int
declare @em_id int

declare @ram_id_CentroCosto int
declare @ram_id_Empleado int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@ccos_id,     @ccos_id out,     @ram_id_CentroCosto out
exec sp_ArbConvertId @@em_id,       @em_id out,       @ram_id_Empleado out

exec sp_GetRptId @clienteID out

if @ram_id_CentroCosto <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
  end else 
    set @ram_id_CentroCosto = 0
end

if @ram_id_Empleado <> 0 begin

  -- exec sp_ArbGetGroups @ram_id_Empleado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empleado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empleado, @clienteID 
  end else 
    set @ram_id_Empleado = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

create table #t_empleado_periodo (empe_id int)

  if not (@em_id = 0 and @ram_id_Empleado = 0) begin

    insert into #t_empleado_periodo
  
    select empe_id 
    from EmpleadoHoras emh
    where (emh.em_id = @em_id or @em_id = 0)
      and (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 35005
                      and  rptarb_hojaid = emh.em_id
                     ) 
               )
            or 
               (@ram_id_Empleado = 0)
           )
  end
  
--////////////////////////////////////////////////////////////////////////

select 

  empe_id,
  ''                as TypeTask,
  empe_fecha        as Fecha,
  empe_numero        as Numero,
  ccos_nombre       as [Centro de Costo],
  empe.creado       as Creado,
  empe.modificado   as Modificado,
  us.us_nombre      as Modifico,
  empe_descrip      as [Descripción]

from 

    EmpleadoPeriodo empe  inner join Usuario us          on empe.modifico   = us.us_id
                          left  join CentroCosto ccos   on empe.ccos_id    = ccos.ccos_id


where 
          @@Fini <= empe_fecha
      and  @@Ffin >= empe_fecha     
      and (empe.empe_numero = @@empe_numero or @@empe_numero = 0)

      and (           (@em_id = 0 and @ram_id_Empleado = 0) 
            or exists(select * from #t_empleado_periodo where empe_id = empe.empe_id)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (empe.ccos_id = @ccos_id       or @ccos_id = 0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1019
                  and  rptarb_hojaid = empe.ccos_id
                 ) 
           )
        or 
           (@ram_id_CentroCosto = 0)
       )

  order by empe_fecha, empe_numero

end
go