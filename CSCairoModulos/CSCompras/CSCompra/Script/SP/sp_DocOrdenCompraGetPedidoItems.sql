if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraGetPedidoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraGetPedidoItems]

go

/*

sp_DocOrdenCompraGetPedidoItems '1,2'

*/

create procedure sp_DocOrdenCompraGetPedidoItems (
  @@prov_id           int,
  @@strIds             varchar(5000),
  @@bFiltrarProv      tinyint = 0
)
as

begin

  declare @timeCode datetime
  set @timeCode = getdate()
  exec sp_strStringToTable @timeCode, @@strIds, ','

  select 
        pci_id,
        pc.pc_id,
        pc_numero,
        pc_nrodoc,
        pr_nombreCompra,
        pr_llevanroserie,
        pci.pr_id,
        ((pci_neto / pci_cantidad) * (1+tiri.ti_porcentaje/100)) as pci_precio,
        pci_cantidadaremitir,
        pci_pendiente,
        pci_pendiente * ((pci_neto / pci_cantidad) * (1+tiri.ti_porcentaje/100)) as pci_importe,
        pci_descrip,
        pci_precio2 = pci_precio,
        pci_precioLista,
        pci_precioUsr,
        pci.ccos_id,
        tiri.ti_porcentaje  as pci_ivariporc,
        0                    as pci_ivarniporc

  from PedidoCompra pc inner join PedidoCompraItem pci   on pci.pc_id  = pc.pc_id
                       inner join TmpStringToTable      on pc.pc_id   = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                       inner join Producto p            on pci.pr_id  = p.pr_id
                       inner join Usuario us            on pc.us_id   = us.us_id
                       inner join TasaImpositiva tiri   on p.ti_id_ivaricompra  = tiri.ti_id
                       left  join TasaImpositiva tirni  on p.ti_id_ivarnicompra = tirni.ti_id
  where 
          pci_pendiente > 0
    and   tmpstr2tbl_id =  @timeCode
    and   (@@bFiltrarProv = 0 or exists(select * from ProductoProveedor prprov where prprov.prov_id = @@prov_id and prprov.pr_id = pci.pr_id))

  order by 

        pc_nrodoc,
        pc_fecha
end
go