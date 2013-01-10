if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGetManifiestos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGetManifiestos]

go

/*
select * from cliente where cli_nombre like 'deco%'
select * from documentotipo
select mon_id from manifiestocarga
update ManifiestoCarga set mfc_nrodoc = mfc_numero

exec sp_DocPackingListGetManifiestos 2,35460,2,''

*/

create procedure sp_DocPackingListGetManifiestos (
  @@emp_id          int,
  @@cli_id           int,
  @@mon_id          int, 
  -- ' MURESCO (Para poder sacarlo despues)
  @@pedido          varchar(255)
  -- ' MURESCO (Para poder sacarlo despues)
)
as

begin

declare @doct_Manifiesto     int set @doct_Manifiesto     = 20

if @@Pedido <> '' set @@Pedido = '%'+ @@Pedido +'%'

  select 

        mfc.mfc_id,
        d.doc_nombre,
        mfc_numero,
        mfc_nrodoc,
        mfc_fecha,
        mfc_pendiente,
        mfc_descrip

  from ManifiestoCarga mfc inner join Documento d on mfc.doc_id = d.doc_id
  where 
          mfc.cli_id  = @@cli_id
    and    mfc.doct_id = @doct_Manifiesto
    and   d.emp_id    = @@emp_id
    and   exists(select mfci_id from ManifiestoCargaItem where mfc_id = mfc.mfc_id and mfci_pendiente > 0)

  order by 
        mfc_nrodoc,
        mfc_fecha
end
go