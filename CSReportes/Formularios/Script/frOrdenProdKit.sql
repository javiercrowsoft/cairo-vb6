if exists (select * from sysobjects where id = object_id(N'[dbo].[frOrdenProdKit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frOrdenProdKit]

go
create procedure frOrdenProdKit (

  @@opk_id      int

)as 

begin

select
      opk.opk_id                                as opk_id,
      opk_nrodoc                                as [NroOrdenProd],
      opk_fecha                                  as Fecha,
       suc_nombre                                 as Sucursal,
       depl_nombre                                as [Desposito destino],
       opk_descrip                               as Descrip,
       pr.pr_nombreventa                          as Articulo,
      opki_cantidad                              as Cantidad,
      opki_descrip                              as [Descrip Item],
      lgj_titulo                                as Legajo

from OrdenProdKit opk  inner join OrdenProdKitItem opki   on opk.opk_id = opki.opk_id
                      inner join Producto pr            on opki.pr_id = pr.pr_id
                      inner join Documento doc          on opk.doc_id = doc.doc_id
                      left  join Sucursal suc            on opk.suc_id = suc.suc_id
                      left  join DepositoLogico depl    on opk.depl_id = depl.depl_id
                      left  join legajo lgj              on lgj.lgj_id = opk.lgj_id


where opk.opk_id = @@opk_id

end
go
