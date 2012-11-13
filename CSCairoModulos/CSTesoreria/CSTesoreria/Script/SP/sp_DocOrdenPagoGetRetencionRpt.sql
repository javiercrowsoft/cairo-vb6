if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetRetencionRpt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetRetencionRpt]
go

/*

	

*/

create procedure sp_DocOrdenPagoGetRetencionRpt (
  @@fdesde         datetime,
  @@fhasta         datetime,
  @@prov_id        int,
  @@emp_id         varchar(255),
  @@pago           decimal(18,6),
	@@opg_total			 decimal(18,6),
	@@nuevoPago			 decimal(18,6),
	@@base					 decimal(18,6),
	@@tasa					 decimal(18,6),
	@@ret 					 decimal(18,6)
)
as 
begin

  set nocount on

  select 
            0              as orden,  
            @@opg_total    as [Pagado sin IVA],
            @@nuevoPago    as [Nuevo pago sin IVA],
            @@base         as [Base Imponible],
            @@tasa         as [Tasa],
            @@ret          as [Importe a retener],
            @@pago - @@ret as [Total a pagar],

            null fc_fecha,
            null fc_numero,
            null fc_nrodoc,
            null fc_total,
            null           as Pagado,
            null fc_pendiente,
            null fc_ivari,
            null fc_ivarni,
            null           as [IVA pagado],
            null           as [IVA pendiente],

            null opg_fecha,
            null opg_numero,
            null opg_nrodoc,
            null opg_total,
            null opg_pendiente

  union

  select 
            1        as orden,
            null     as [Pagado sin IVA],
            null     as [Nuevo pago sin IVA],
            null     as [Base Imponible],
            null     as [Tasa],
            null     as [Importe a retener],
            null     as [Total a pagar],

            fc_fecha,
            fc.fc_numero,
            fc_nrodoc,
            fc_total,
            fc_total - fc_pendiente as Pagado,
            null fc_pendiente,
            fc_ivari,
            fc_ivarni,
              fc_ivari  - (fc_ivari  * (fc_pendiente/fc_total))
            + fc_ivarni - (fc_ivarni * (fc_pendiente/fc_total))   as [IVA pagado],
            null     as [IVA pendiente],

            null opg_fecha,
            null opg_numero,
            null opg_nrodoc,
            null opg_total,
            null opg_pendiente

  from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc on fcopg.fc_id   = fc.fc_id
                                    inner join OrdenPago  opg   on fcopg.opg_id  = opg.opg_id
                                    inner join Documento d      on fc.doc_id     = d.doc_id
  where opg_fecha between @@fdesde and @@fhasta 
    and opg.prov_id = @@prov_id 
    and d.emp_id    = @@emp_id
		and not exists(select * 
                 from facturacompraitem fci inner join producto pr on fci.pr_id = pr.pr_id
								 where pr.ibc_id = 1 -- Exento
                   and fci.fc_id = fc.fc_id
								)

  union

  select 
            2         as orden,
            null      as [Pagado sin IVA],
            null      as [Nuevo pago sin IVA],
            null      as [Base Imponible],
            null      as [Tasa],
            null      as [Importe a retener],
            null      as [Total a pagar],

            null fc_fecha,
            null fc_numero,
            null fc_nrodoc,
            null fc_total,
            null      as Pagado,
            null fc_pendiente,
            null fc_ivari,
            null fc_ivarni,
            null      as [IVA pagado],
            null      as [IVA pendiente],

            opg_fecha,
            opg_numero,
            opg_nrodoc,
            opg_total,
            opg_pendiente

  from OrdenPago c inner join Documento d on c.doc_id = d.doc_id
  where opg_fecha between @@fdesde and @@fhasta 
    and prov_id  = @@prov_id 
    and d.emp_id = @@emp_id
    and opg_pendiente > 0 -- Solo anticipos

  union

  select 
            3        as orden,
            null     as [Pagado sin IVA],
            null     as [Nuevo pago sin IVA],
            null     as [Base Imponible],
            null     as [Tasa],
            null     as [Importe a retener],
            null     as [Total a pagar],

            fc_fecha,
            fc.fc_numero,
            fc_nrodoc,
            fc_total,
            fc_total - fc_pendiente as Pagado,
            fc_pendiente,
            fc_ivari,
            fc_ivarni,
            null     as [IVA pagado],
              (fc_ivari  * (fc_pendiente/fc_total))
            + (fc_ivarni * (fc_pendiente/fc_total))   as [IVA pendiente],

            null opg_fecha,
            null opg_numero,
            null opg_nrodoc,
            null opg_total,
            null opg_pendiente

  from FacturaCompra fc inner join Documento d on fc.doc_id = d.doc_id
                        inner join #nuevoPago t on fc.fc_numero = t.fc_numero
  where prov_id   = @@prov_id 
    and d.emp_id  = @@emp_id

end
go