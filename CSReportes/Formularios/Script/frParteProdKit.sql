if exists (select * from sysobjects where id = object_id(N'[dbo].[frParteProdKit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frParteProdKit]

go
create procedure frParteProdKit (

  @@ppk_id      int

)as 

begin

select
      ppk.ppk_id                                as ppk_id,
      ppk_nrodoc                                as [NroParteProd],
      ppk_fecha                                  as Fecha,
       suc_nombre                                 as Sucursal,
       depl_nombre                                as [Desposito destino],
       ppk_descrip                               as Descrip,
       pr.pr_nombreventa                          as Articulo,
      ppki_cantidad                              as Cantidad,
      ppki_descrip                              as [Descrip Item],
      lgj_titulo                                as Legajo

from ParteProdKit ppk  inner join ParteProdKitItem ppki   on ppk.ppk_id = ppki.ppk_id
                      inner join Producto pr            on ppki.pr_id = pr.pr_id
                      inner join Documento doc          on ppk.doc_id = doc.doc_id
                      left  join Sucursal suc            on ppk.suc_id = suc.suc_id
                      left  join DepositoLogico depl    on ppk.depl_id = depl.depl_id
                      left  join legajo lgj              on lgj.lgj_id = ppk.lgj_id


where ppk.ppk_id = @@ppk_id

end
go
