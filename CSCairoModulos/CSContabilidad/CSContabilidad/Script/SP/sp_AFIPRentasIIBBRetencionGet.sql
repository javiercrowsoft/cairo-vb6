if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AFIPRentasIIBBRetencionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AFIPRentasIIBBRetencionGet]

/*
 
 select * from rama where ram_nombre = 'Agente IIBB GNGroup'

 sp_AFIPRentasIIBBRetencionGet '20070301','20070331','N38158',2,1

*/

go
create procedure sp_AFIPRentasIIBBRetencionGet (
  @@fdesde     datetime,
  @@fhasta     datetime,
  @@ret_id     varchar(255),
  @@emp_id     int,
  @@cico_id   int  
)
as
begin

  set nocount on

declare @ret_id                    int
declare @ram_id_retencion         int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@ret_id,   @ret_id  out,  @ram_id_retencion out

exec sp_GetRptId @clienteID out

if @ram_id_retencion <> 0 begin

--  exec sp_ArbGetGroups @ram_id_retencion, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_retencion, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_retencion, @clienteID 
  end else 
    set @ram_id_retencion = 0
end

  select   case 
            when charindex('-',prov_cuit,1) <> 0 then prov_cuit 
            else substring(prov_cuit,1,2)+'-'+substring(prov_cuit,3,8)+'-'+substring(prov_cuit,11,2) 
          end  
          as CUIT,

                  substring(convert(varchar(12),opg_fecha,112),1,4) -- año
          + '-' + substring(convert(varchar(12),opg_fecha,112),5,2) -- mes
          + '-' + substring(convert(varchar(12),opg_fecha,112),7,2) -- dia


          as Fecha,

          substring(opgi_nroRetencion,1,4) as Sucursal,
          substring(opgi_nroRetencion,6,13) as Emision,

          replace(
                  substring('0000000000',1,10-len(convert(varchar(11),convert(decimal(18,2),opgi_importe))))+
                  convert(varchar(11),convert(decimal(18,2),opgi_importe)),
                  '.',','
                  )
          as Importe
  
  from OrdenPago opg inner join OrdenPagoItem opgi  on opg.opg_id  = opgi.opg_id
                     inner join Proveedor prov      on opg.prov_id = prov.prov_id
                     inner join Documento doc       on opg.doc_id  = doc.doc_id
  
  where opg_fecha >= @@fdesde
    and opg_fecha <= @@fhasta
    and opgi.opgi_tipo = 4

    and est_id <> 7
    and opg.emp_id = @@emp_id
    and (doc.cico_id = @@cico_id or @@cico_id = 0)

    and opgi.ret_id is not null

    and (opgi.ret_id = @ret_id or @ret_id = 0)

    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1014
                      and  rptarb_hojaid  = opgi.ret_id
                     )
               )
            or 
               (@ram_id_retencion = 0)
           )


  order by Fecha, Emision

end

GO