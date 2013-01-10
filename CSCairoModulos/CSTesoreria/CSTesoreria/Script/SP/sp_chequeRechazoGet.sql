if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_chequeRechazoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_chequeRechazoGet]

go

/*

sp_chequeRechazoGet 101

*/
create procedure sp_chequeRechazoGet (
  @@cheq_id int
)
as

begin

  set nocount on

  declare @info as varchar(5000)

  select @info = 'Cobranza: ' + doc_nombre + ' ' + cobz_nrodoc + ' ' + convert(varchar,cobz_fecha,102) + ' ' + cli_nombre
  from cheque cheq inner join cobranza cobz on cheq.cobz_id  = cobz.cobz_id
                   inner join documento doc on cobz.doc_id   = doc.doc_id
                   inner join cliente       on cheq.cli_id   = cliente.cli_id
  where cheq.cheq_id = @@cheq_id

  if @info is null
    set @info = ''
  else
    set @info = @info + char(13) + char(10)

  select @info = @info + 'Orden de pago: ' + doc_nombre + ' ' + opg_nrodoc + ' ' + convert(varchar,opg_fecha,102) + ' ' + prov_nombre
  from cheque cheq inner join OrdenPago opg on cheq.opg_id  = opg.opg_id
                   inner join documento doc on opg.doc_id   = doc.doc_id
                   inner join proveedor     on cheq.prov_id = proveedor.prov_id
  where cheq.cheq_id = @@cheq_id

  select 
            @info         as info, 
            cheq_rechazado, 
            case 
                when cheq_fechaRechazo = '19000101' then getdate()
                else                                     cheq_fechaRechazo
            end            as cheq_fechaRechazo,
            fc_id_nd1,
            fc_id_nd2, 
            fv_id_nd, 
            fc1.fc_nrodoc as fc_nrodoc1, 
            fc2.fc_nrodoc as fc_nrodoc2,
            fv_nrodoc,
            case cheq_fc_importe1
                when 0 then cheq_importe
                else        cheq_fc_importe1
            end           as cheq_fc_importe1,
            cheq_fc_importe2,
            case cheq_fv_importe
                when 0 then cheq_importe
                else        cheq_fv_importe
            end           as cheq_fv_importe,
            cheq_descrip,
            cheq.cli_id,
            cheq.prov_id

  from 
        cheque cheq    left  join FacturaCompra fc1 on fc_id_nd1 = fc1.fc_id
                      left  join FacturaCompra fc2 on fc_id_nd2 = fc2.fc_id
                      left  join FacturaVenta  fv  on fv_id_nd  = fv.fv_id

  where cheq_id = @@cheq_id

end