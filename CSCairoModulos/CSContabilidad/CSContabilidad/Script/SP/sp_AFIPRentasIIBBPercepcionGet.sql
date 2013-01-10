if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AFIPRentasIIBBPercepcionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AFIPRentasIIBBPercepcionGet]

/*
 
 sp_AFIPRentasIIBBPercepcionGet '20070301','20070331',2

*/

go
create procedure sp_AFIPRentasIIBBPercepcionGet (
  @@fdesde     datetime,
  @@fhasta     datetime,
  @@emp_id     int,
  @@cico_id   int
)
as
begin

  set nocount on

  select   case 
               when charindex('-',cli_cuit,1) <> 0 then cli_cuit 
               else                                     substring(cli_cuit,1,2)+'-'
                                                        +substring(cli_cuit,3,8)+'-'
                                                        +substring(cli_cuit,11,2) 
          end as cuit,

                  substring(convert(varchar(12),fv_fecha,112),1,4) -- año
          + '-' + substring(convert(varchar(12),fv_fecha,112),5,2) -- mes
          + '-' + substring(convert(varchar(12),fv_fecha,112),7,2) -- dia

              as Fecha,

          case fv.doct_id 
            when 1 then 'F'
            when 7 then 'C'
            when 9 then 'D'
          end as Tipo,

          substring(fv_nrodoc,1,1) as Letra,
          substring(fv_nrodoc,3,4) as Sucursal,
          substring(fv_nrodoc,8,8) as Emision,

          case fv.doct_id 
            when 7 then
              '-'+replace(
                      substring('00000000000',1,11-len(convert(varchar(12),convert(decimal(18,2),fvperc_base))))+
                      convert(varchar(12),convert(decimal(18,2),fvperc_base)),
                      '.',','
                      )
            else
              replace(
                      substring('000000000000',1,12-len(convert(varchar(12),convert(decimal(18,2),fvperc_base))))+
                      convert(varchar(12),convert(decimal(18,2),fvperc_base)),
                      '.',','
                      )
          end      as Base,

          case fv.doct_id 
            when 7 then
              '-'+replace(
                      substring('0000000000',1,10-len(convert(varchar(11),convert(decimal(18,2),fvperc_importe))))+
                      convert(varchar(11),convert(decimal(18,2),fvperc_importe)),
                      '.',','
                      )
            else
              replace(
                      substring('00000000000',1,11-len(convert(varchar(11),convert(decimal(18,2),fvperc_importe))))+
                      convert(varchar(11),convert(decimal(18,2),fvperc_importe)),
                      '.',','
                      )
          end     as Importe
  
  from FacturaVenta fv inner join FacturaVentaPercepcion fvperc on fv.fv_id  = fvperc.fv_id
                       inner join Cliente cli                   on fv.cli_id = cli.cli_id
                       inner join Documento doc                 on fv.doc_id = doc.doc_id
  
  where fv_fecha >= @@fdesde
    and fv_fecha <= @@fhasta
    and est_id <> 7
    and fv.emp_id = @@emp_id
    and (doc.cico_id = @@cico_id or @@cico_id = 0)

  order by Letra, Fecha

end

GO