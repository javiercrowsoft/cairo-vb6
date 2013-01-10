if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_CashFlows]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_CashFlows]
go

/*

sp_lsdoc_CashFlows

  1,
  '20030101',
  '20050101',
    '0',
    '0'

*/

create procedure sp_lsdoc_CashFlows (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@cf_nombre      varchar(255),
@@cf_descrip     varchar(255)
)as 
begin

  set nocount on
  
  if @@cf_nombre     <> '' set @@cf_nombre     = '%' + @@cf_nombre + '%'
  if @@cf_descrip   <> '' set @@cf_descrip     = '%' + @@cf_descrip + '%'
  
  
  select 
        cf_id,
        ''                    as [TypeTask],
        cf_nombre              as [Título],
  
        cf_fecha              as [Fecha],
        cf_fechadesde         as [Fecha Desde],
        cf_fechahasta         as [Fecha Hasta],
        cue_nombre            as Cuenta,
        us_nombre             as Modifico,
        cf.Creado,
        cf.Modificado,
        cf_descrip            as [Observaciones]
  from 
        CashFlow cf inner join Usuario us on cf.modifico = us.us_id
                    left  join Cuenta cue on cf.cue_id = cue.cue_id
  
  where 
  
            @@Fini <= cf_fecha
        and  @@Ffin >= cf_fecha     
  
        and (cf_nombre       like @@cf_nombre     or @@cf_nombre     = '')
        and (cf_descrip     like @@cf_descrip   or @@cf_descrip   = '')
  
  order by cf_fecha
end
go