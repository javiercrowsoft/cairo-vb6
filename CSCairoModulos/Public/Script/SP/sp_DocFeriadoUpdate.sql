if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFeriadoUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFeriadoUpdate]

go

/*

  sp_DocFeriadoUpdate 

*/

create procedure sp_DocFeriadoUpdate (
  @@fe_id        int
)
as

set nocount on

begin

  set nocount on
  
  declare @fvd_id       int
  declare @fvd_fecha     datetime
  declare @fecha2       datetime

  declare @hoy          datetime
  set @hoy = getdate()
  set @hoy = dateadd(d,-1,@hoy)
  
  declare c_facturaventa insensitive cursor for 
    select fvd_id, fvd_fecha from facturaventadeuda
    where fvd_fecha >= @hoy
      and exists(select fei_id 
                 from FeriadoItem fei inner join Feriado fe
                        on fei.fe_id = fe.fe_id and fei.fe_id = @@fe_id 
                 where fei_fecha = fvd_fecha and fe_laboral <> 0)

    union 

    select id, fecha from #t_docs where tipo = 1

  open c_facturaventa
  
  fetch next from c_facturaventa into @fvd_id, @fvd_fecha
  while @@fetch_status=0
  begin
  
  
    exec sp_DocGetFecha2 @fvd_fecha,@fecha2 out, 0, null
    update facturaventadeuda set fvd_fecha2 = @fecha2 where fvd_id = @fvd_id
      
    fetch next from c_facturaventa into @fvd_id, @fvd_fecha
  end
  
  close c_facturaventa
  deallocate c_facturaventa
  
  declare @fcd_id       int
  declare @fcd_fecha     datetime
  
  declare c_facturacompra insensitive cursor for 
    select fcd_id, fcd_fecha from facturacompradeuda
    where fcd_fecha >= @hoy
      and exists(select fei_id 
                 from FeriadoItem fei inner join Feriado fe
                        on fei.fe_id = fe.fe_id and fei.fe_id = @@fe_id 
                 where fei_fecha = fcd_fecha and fe_laboral <> 0)

    union 

    select id, fecha from #t_docs where tipo = 2

  open c_facturacompra
  
  fetch next from c_facturacompra into @fcd_id, @fcd_fecha
  while @@fetch_status=0
  begin
  
  
    exec sp_DocGetFecha2 @fcd_fecha,@fecha2 out, 0, null
    update facturacompradeuda set fcd_fecha2 = @fecha2 where fcd_id = @fcd_id
      
    fetch next from c_facturacompra into @fcd_id, @fcd_fecha
  end
  
  close c_facturacompra
  deallocate c_facturacompra
  
  declare @cheq_id       int
  declare @cheq_fecha   datetime
  declare @cle_id       int
  
  declare c_cheque insensitive cursor for 
    select cheq_id, cheq_fechacobro, cle_id from cheque
    where cheq_fechacobro >= @hoy
      and exists(select fei_id 
                 from FeriadoItem fei inner join Feriado fe
                        on fei.fe_id = fe.fe_id and fei.fe_id = @@fe_id 
                 where fei_fecha between cheq_fechacobro and cheq_fecha2
                   and fe_banco <> 0)

    union 

    select id, fecha, cle_id from #t_docs where tipo = 3

  open c_cheque
  
  fetch next from c_cheque into @cheq_id, @cheq_fecha, @cle_id
  while @@fetch_status=0
  begin
  
    exec sp_DocGetFecha2 @cheq_fecha,@fecha2 out, 1, @cle_id
    update cheque set cheq_fecha2 = @fecha2 where cheq_id = @cheq_id
      
    fetch next from c_cheque into @cheq_id, @cheq_fecha, @cle_id
  end
  
  close c_cheque
  deallocate c_cheque

end

go
