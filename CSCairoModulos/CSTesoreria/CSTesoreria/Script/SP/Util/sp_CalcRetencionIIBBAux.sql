/*

select * from ordenpagoitem where opg_id = 21

sp_CalcRetencionIIBBAux 21

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CalcRetencionIIBBAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CalcRetencionIIBBAux]

-- sp_CalcRetencionIIBBAux 0

go
create procedure sp_CalcRetencionIIBBAux (

  @@opg_id      int,
  @@base        decimal(18,6) out,
  @@retencion   decimal(18,6) out

)as 

begin

  declare @ret_id       int
  declare @opgi_id       int
  declare @ret_nrodoc    varchar(255)
  
  select @ret_id       = opgi.ret_id, 
         @opgi_id     = opgi_id,
         @ret_nrodoc   = opgi_nroRetencion

  from OrdenPagoItem opgi inner join Retencion ret on opgi.ret_id = ret.ret_id
  where opg_id = @@opg_id
    and ret.ibc_id is not null

  declare @emp_id     int
  declare @opg_total   decimal(18,6)

  select  @emp_id    = emp_id,
          @opg_total = opg_total

  from OrdenPago where opg_id = @@opg_id

  declare @emp_razonsocial varchar(255)
  declare @emp_cuit        varchar(255)

  select  @emp_razonsocial   = emp_razonsocial,
          @emp_cuit         = emp_cuit

  from Empresa where emp_id = @emp_id

  declare @alicuota decimal(18,6)

  select @alicuota = reti_porcentaje 
  from RetencionItem
  where ret_id = @ret_id
    and @opg_total between reti_importedesde and reti_importehasta 

  --///////////////////////////////////////////////////////////////////////////
  --
  --
  --///////////////////////////////////////////////////////////////////////////

  select   @@base = sum(case prov_catfiscal
                      when 1    then (
                                        (    fcopg_importe 
                                          -(  fcopg_importe
                                            *  (fc_totalpercepciones/fc_total)
                                            )
                                        )
                                        * (fc_neto/(fc_total)
                                          )
                                        
                                      )
          
                      when 11   then (
                                        (    fcopg_importe 
                                          -(  fcopg_importe
                                            *  (fc_totalpercepciones/fc_total)
                                            )
                                        )
                                        * (fc_neto/(fc_total)
                                          )
                                        
                                      )
          
                      when 6     then (    fcopg_importe 
                                          -(  fcopg_importe
                                            *  (fc_totalpercepciones/fc_total)
                                            )
                                      )
          
                      else            0
                    end),

          @@retencion =sum(case prov_catfiscal
                            when 1    then (
                                              (    fcopg_importe 
                                                -(  fcopg_importe
                                                  *  (fc_totalpercepciones/fc_total)
                                                  )
                                              )
                                              * (fc_neto/(fc_total)
                                                )
                                              
                                            )*@alicuota/100
                
                            when 11   then (
                                              (    fcopg_importe 
                                                -(  fcopg_importe
                                                  *  (fc_totalpercepciones/fc_total)
                                                  )
                                              )
                                              * (fc_neto/(fc_total)
                                                )
                                              
                                            )*@alicuota/100
                
                            when 6     then (    fcopg_importe 
                                                -(  fcopg_importe
                                                  *  (fc_totalpercepciones/fc_total)
                                                  )
                                            )*@alicuota/100
                
                            else            0
                          end)
  
  from OrdenPagoItem opgi inner join OrdenPago opg     on opgi.opg_id = opg.opg_id
                          inner join Proveedor prov   on opg.prov_id = prov.prov_id
                          left  join Provincia pro    on prov.pro_id = pro.pro_id

                          left  join FacturaCompraOrdenPago fcopg on opg.opg_id = fcopg.opg_id

                          left  join FacturaCompra fc on fcopg.fc_id = fc.fc_id

  where opgi_id       = @opgi_id
    and opg.opg_id    = @@opg_id
    and opgi.ret_id   = @ret_id
    and not exists(  select * 
                    from FacturaCompraItem fci 
                            left  join Producto pr           
                              on fci.pr_id = pr.pr_id
                    where fc.fc_id = fci.fc_id and pr.ibc_id = 1 
                  )

end
go
