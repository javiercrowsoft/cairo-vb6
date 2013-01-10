if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListSaveHojaRuta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListSaveHojaRuta]

go

create procedure sp_PickingListSaveHojaRuta (
  @@us_id             int,
  @@pkl_id             int,
  @@strIds             varchar(5000)
)
as

begin

  set nocount on

  declare @timeCode datetime
  set @timeCode = getdate()
  exec sp_strStringToTable @timeCode, @@strIds, ','

  declare @hr_id         int
  declare @hr_fecha     datetime
  declare @hr_total     decimal(18,6)

  declare @hri_id       int

  declare @pkl_nrodoc   varchar(50)
  declare @suc_id       int
  declare @fv_id         int
  declare @fv_total     decimal(18,6)

  set @hr_fecha = getdate()

  set @hr_fecha = dateadd(hh,-datepart(hh,@hr_fecha),@hr_fecha)
  set @hr_fecha = dateadd(n,-datepart(n,@hr_fecha),@hr_fecha)
  set @hr_fecha = dateadd(ss,-datepart(ss,@hr_fecha),@hr_fecha)
  set @hr_fecha = dateadd(ms,-datepart(ms,@hr_fecha),@hr_fecha)

  select @pkl_nrodoc = pkl_nrodoc, @suc_id = suc_id from PickingList where pkl_id = @@pkl_id

  select @hr_total = sum(fv_total)
  from  FacturaVenta 
      where fv_id in (  select convert(int,TmpStringToTable.tmpstr2tbl_campo) 
                        from TmpStringToTable      
                        where tmpstr2tbl_id =  @timeCode
                      )

  begin transaction

    exec sp_dbgetnewid 'HojaRuta', 'hr_id', @hr_id out, 0

    insert into HojaRuta ( hr_id
                          ,cam_id
                          ,cam_id_semi
                          ,chof_id
                          ,creado
                          ,est_id
                          ,hr_cumplida
                          ,hr_descrip
                          ,hr_fecha
                          ,hr_fechaentrega
                          ,hr_firmado
                          ,hr_ivari
                          ,hr_neto
                          ,hr_nrodoc
                          ,hr_numero
                          ,hr_pendiente
                          ,hr_recibidocantcheque
                          ,hr_recibidocheque
                          ,hr_recibidodescrip
                          ,hr_recibidoefectivo
                          ,hr_subtotal
                          ,hr_total
                          ,impreso
                          ,modificado
                          ,modifico
                          ,prs_id
                          ,suc_id
                          )

                  values (
                          @hr_id
                          ,null --cam_id
                          ,null --cam_id_semi
                          ,null --chof_id
                          ,getdate() --creado
                          ,1 --est_id
                          ,0 --hr_cumplida
                          ,'Generada por Lista de Despacho Nro: ' + @pkl_nrodoc --hr_descrip
                          ,@hr_fecha --hr_fecha
                          ,@hr_fecha --hr_fechaentrega
                          ,0 --hr_firmado
                          ,0--hr_ivari
                          ,0--hr_neto
                          ,right('00000000'+convert(varchar,@hr_id),8) --hr_nrodoc
                          ,@hr_id --hr_numero
                          ,0 --hr_pendiente
                          ,0 --hr_recibidocantcheque
                          ,0 --hr_recibidocheque
                          ,'' --hr_recibidodescrip
                          ,0 --hr_recibidoefectivo
                          ,0 --hr_subtotal
                          ,@hr_total
                          ,0 --impreso
                          ,getdate() --modificado
                          ,@@us_id --modifico
                          ,null --prs_id
                          ,@suc_id --suc_id
                          )

    declare c_items insensitive cursor for

        select fv_id, fv_total 
    
        from  FacturaVenta 
        where fv_id in (  select convert(int,TmpStringToTable.tmpstr2tbl_campo) 
                          from TmpStringToTable      
                          where tmpstr2tbl_id =  @timeCode
                        )

    open c_items

    fetch next from c_items into @fv_id, @fv_total
    while @@fetch_status=0
    begin

      exec sp_dbgetnewid 'HojaRutaItem','hri_id', @hri_id out, 0

      insert into HojaRutaItem (
                                 hri_id
                                ,est_id
                                ,fv_id
                                ,hr_id
                                ,hri_acobrar
                                ,hri_cobrado
                                ,hri_descrip
                                ,cont_id
                                ,hri_importe
                                ,hri_orden
                                ,os_id
                                ,ptd_id
                                ,rv_id
                                )
                        values (
                                 @hri_id
                                ,1 --est_id
                                ,@fv_id
                                ,@hr_id
                                ,@fv_total
                                ,0 --hri_cobrado
                                ,'' --hri_descrip
                                ,null --cont_id
                                ,0 --hri_importe
                                ,0 --hri_orden
                                ,null --os_id
                                ,null --ptd_id
                                ,null --rv_id
                                )

      fetch next from c_items into @fv_id, @fv_total
    end

    close c_items
    deallocate c_items    

  commit transaction

  select @hr_id as hr_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar la hoja de ruta. sp_PickingListSaveHojaRuta.', 16, 1)
  rollback transaction  


end

go