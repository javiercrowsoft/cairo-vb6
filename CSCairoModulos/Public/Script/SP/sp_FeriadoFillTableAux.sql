if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FeriadoFillTableAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FeriadoFillTableAux]

go

/*

  sp_FeriadoFillTableAux 

*/

create procedure sp_FeriadoFillTableAux (
  @@fe_id        int
)
as

set nocount on

begin

  set nocount on

  declare @hoy          datetime
  set @hoy = getdate()
  set @hoy = dateadd(d,-1,@hoy)

  insert into #t_docs (id, fecha, tipo)
  
    select fvd_id, fvd_fecha, 1 from facturaventadeuda
    where fvd_fecha >= @hoy
      and exists(select fei_id 
                 from FeriadoItem fei inner join Feriado fe
                        on fei.fe_id = fe.fe_id and fei.fe_id = @@fe_id 
                 where fei_fecha = fvd_fecha and fe_laboral <> 0)

  insert into #t_docs (id, fecha, tipo)

    select fcd_id, fcd_fecha, 2 from facturacompradeuda
    where fcd_fecha >= @hoy
      and exists(select fei_id 
                 from FeriadoItem fei inner join Feriado fe
                        on fei.fe_id = fe.fe_id and fei.fe_id = @@fe_id 
                 where fei_fecha = fcd_fecha and fe_laboral <> 0)

  insert into #t_docs (id, fecha, cle_id, tipo)

    select cheq_id, cheq_fechacobro, cle_id, 3 from cheque
    where cheq_fechacobro >= @hoy
      and exists(select fei_id 
                 from FeriadoItem fei inner join Feriado fe
                        on fei.fe_id = fe.fe_id and fei.fe_id = @@fe_id 
                 where fei_fecha between cheq_fechacobro and cheq_fecha2
                   and fe_banco <> 0)
end

go
