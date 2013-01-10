-- Script de Chequeo de Integridad de:

-- 2 - Control de vencimientos FC y FV

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaVtoValidateDocFVList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaVtoValidateDocFVList]

go

create procedure sp_AuditoriaVtoValidateDocFVList (

  @@fv_id       int

)
as

begin

  set nocount on

  declare @doct_id      int
  declare @fv_nrodoc     varchar(50) 
  declare @fv_numero     varchar(50) 

  select 
            @doct_id     = doct_id,
            @fv_nrodoc  = fv_nrodoc,
            @fv_numero  = convert(varchar,fv_numero)

  from FacturaVenta where fv_id = @@fv_id

  select *,
         IsNull(
          (select sum(fvcobz_importe) from FacturaVentaCobranza 
           where fvd_id = fvd.fvd_id),0)

              as Cobranzas,

         IsNull(
          (select sum(fvnc_importe)   from FacturaVentaNotaCredito 
           where 
                 (fvd_id_factura     = fvd.fvd_id and @doct_id in (1,9))
              or (fvd_id_notacredito = fvd.fvd_id and @doct_id = 7)
          ),0) 

              as [Notas de Credito]

  from FacturaVentaDeuda fvd
  where (fvd_pendiente +  (    IsNull(
                                (select sum(fvcobz_importe) from FacturaVentaCobranza 
                                 where fvd_id = fvd.fvd_id),0)
                            +  IsNull(
                                (select sum(fvnc_importe)   from FacturaVentaNotaCredito 
                                 where 
                                       (fvd_id_factura     = fvd.fvd_id and @doct_id in (1,9))
                                    or (fvd_id_notacredito = fvd.fvd_id and @doct_id = 7)
                                ),0)
                          ) 
        ) <> fvd_importe

    and fv_id = @@fv_id
  
  select *,
         IsNull(
          (select sum(fvcobz_importe) from FacturaVentaCobranza 
           where fvp_id = fvp.fvp_id),0)

              as Cobranzas,

         IsNull(
          (select sum(fvnc_importe)   from FacturaVentaNotaCredito 
           where 
                 (fvp_id_factura     = fvp.fvp_id and @doct_id in (1,9))
              or (fvp_id_notacredito = fvp.fvp_id and @doct_id = 7)
          ),0) 

              as [Notas de Credito]

  from FacturaVentaPago fvp
  where fvp_importe   <> (    IsNull(
                                (select sum(fvcobz_importe) from FacturaVentaCobranza 
                                 where fvp_id = fvp.fvp_id),0)
                            +  IsNull(
                                (select sum(fvnc_importe)   from FacturaVentaNotaCredito 
                                 where 
                                       (fvp_id_factura     = fvp.fvp_id and @doct_id in (1,9))
                                    or (fvp_id_notacredito = fvp.fvp_id and @doct_id = 7)
                                ),0)
                          ) 
    and fv_id = @@fv_id

end
GO