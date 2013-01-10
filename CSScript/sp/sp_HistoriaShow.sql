if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HistoriaShow]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HistoriaShow]
/*

select tbl_id,tbl_nombrefisico from tabla 
where tbl_nombrefisico like '%factura%'

delete historia
select * from historia
select * from historiaoperacion

exec sp_HistoriaShow 16001, 8

*/
go
create procedure sp_HistoriaShow (
  @@tbl_id          int,
  @@id              int
)
as
begin

  select   hst_id, 
          hst.modificado                as Modificado,
          us_nombre                     as Usuario,
           isnull(hsto1.hsto_nombre,
                 hsto2.hsto_nombre)     as Operacion,
           hst_descrip                   as Observaciones

  from Historia hst left join HistoriaOperacion hsto1 on hst_operacion = hsto1.hsto_id and hst.tbl_id = hsto1.tbl_id
                    left join HistoriaOperacion hsto2 on hst_operacion = hsto2.hsto_id and hsto2.tbl_id = 0
                    left join Usuario us              on hst.modifico  = us.us_id

  where hst.tbl_id = @@tbl_id
    and id = @@id

  order by hst.modificado

end
go