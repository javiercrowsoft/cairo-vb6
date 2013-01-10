if exists (select * from sysobjects where id = object_id(N'[dbo].[frRemitoCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frRemitoCompra]

go
create procedure frRemitoCompra (

  @@rc_id      int

)as 

begin

select
      rc.rc_id                                  as rc_id,
      prov_nombre                               as Proveedor,
      rc_nrodoc                                 as [NroRemito],
      rc_fecha                                  as Fecha,
       prov_calle + ' ' +
      prov_callenumero + ' ' +
      prov_piso + ' ' +
      prov_depto + ' (' +
      prov_codpostal + ')'                       as Direccion,
      prov_localidad                            as Localidad,
      prov_tel                                  as Telefono,
       ''                                        as Sucursal,
       depl_nombre                                as [Desposito destino],
       rc_descrip                                 as Descrip,
       pr_nombrecompra                           as Articulo,
      mon_nombre                                as Moneda,
      mon_signo                                 as Signo,
      rci_cantidad                              as Cantidad,
      rci_precio                                as Precio,
      rci_ivari + rci_ivarni                    as IVA,
      rci_neto                                  as Neto,
      rci_importe                                as Importe,
      rc_neto                                   as [Neto total],
      rc_total                                   as Total,  
      rc_ivari + rc_ivarni                      as [Total IVA]

from RemitoCompra rc   inner join RemitoCompraItem rci   on rc.rc_id = rci.rc_id
                      inner join Proveedor prov          on rc.prov_id = prov.prov_id
                      inner join Producto pr            on rci.pr_id = pr.pr_id
                      inner join Documento doc          on rc.doc_id = doc.doc_id
                      inner join Moneda  mon            on doc.mon_id = mon.mon_id
                      left  join Stock st               on rc.st_id = st.st_id
                      left  join DepositoLogico depl    on st.depl_id_origen = depl.depl_id


where rc.rc_id = @@rc_id

end
go
