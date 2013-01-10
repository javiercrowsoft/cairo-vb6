if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_DespachoImpCalculos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_DespachoImpCalculos]
go

/*
select * from RemitoCompra

sp_docRemitoCompraget 47

sp_lsdoc_DespachoImpCalculos

  7,
  '20030101',
  '20050101',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'

*/

create procedure sp_lsdoc_DespachoImpCalculos (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@prov_id          varchar(255),
@@dic_titulo      varchar(255),
@@dic_via          varchar(255),
@@dic_viaempresa  varchar(255),
@@dic_factura      varchar(255),
@@dic_descrip     varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id int

declare @ram_id_Proveedor int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


if @@dic_titulo     <> '' set @@dic_titulo       = '%' + @@dic_titulo + '%'
if @@dic_via         <> '' set @@dic_via         = '%' + @@dic_via + '%'
if @@dic_viaempresa <> '' set @@dic_viaempresa   = '%' + @@dic_viaempresa + '%'
if @@dic_factura     <> '' set @@dic_factura     = '%' + @@dic_factura + '%'
if @@dic_descrip     <> '' set @@dic_descrip     = '%' + @@dic_descrip + '%'


select 
      dic_id,
      ''                    as [TypeTask],
      case dic_tipo
            when 1 then 'Provisorio'
            when 2 then 'Definitivo'
      end                    as Tipo,
      dic_numero            as [Número],
      prov_nombre           as [Proveedor],
      dic_titulo            as [Título],

      dic_fecha              as [Fecha],
      dic_total              as [Total],

      dic_via                as [Vía],
      dic_viaempresa        as [Empresa],

      dic_factura            as [Factura],
      dic_cambio1            as [Cambio COMEX],
      dic_cambio2            as [Cambio Origen],
      dic_pase              as [Pase],
      dic_totalgtos          as [Total Gtos.],
      dic_porcfob            as [Porc. FOB],
      dic_var                as [Variación],
      dic_porcfobfinal      as [Porc. FOB Final],
      dic_total              as [Total],
      dic_totalorigen        as [Total Origen],
      mon1.mon_nombre        as [Moneda COMEX],
      mon2.mon_nombre        as [Moneda Origen],

      dic.Creado,
      dic.Modificado,
      us_nombre             as [Modifico],
      dic_descrip            as [Observaciones]
from 
      DespachoImpCalculo dic   inner join RemitoCompra rc on dic.rc_id   = rc.rc_id
                              inner join Proveedor prov  on rc.prov_id  = prov.prov_id
                             
                                inner join Usuario us     on dic.modifico = us.us_id
                               inner join Moneda mon1    on dic.mon_id1  = mon1.mon_id
                               left  join Moneda mon2    on dic.mon_id2  = mon2.mon_id

where 

          @@Fini <= dic_fecha
      and  @@Ffin >= dic_fecha     


      and (dic_titulo     like @@dic_titulo     or @@dic_titulo     = '')
      and (dic_via         like @@dic_via         or @@dic_via         = '')
      and (dic_viaempresa like @@dic_viaempresa or @@dic_viaempresa = '')
      and (dic_factura     like @@dic_factura     or @@dic_factura     = '')
      and (dic_descrip     like @@dic_descrip     or @@dic_descrip     = '')


/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (rc.prov_id = @prov_id or @prov_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 
                  and  rptarb_hojaid = rc.prov_id
                 ) 
           )
        or 
           (@ram_id_Proveedor = 0)
       )


  order by dic_fecha
go