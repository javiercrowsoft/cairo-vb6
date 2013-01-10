if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FeriadoSave ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FeriadoSave ]

/*

  exec sp_FeriadoSave  1

  select * from feriadoitem

*/

go
create procedure sp_FeriadoSave  (
  @@fe_id     int
)
as

begin

  set nocount on

  create table #t_docs (id int, fecha datetime, cle_id int, tipo tinyint)

  exec sp_FeriadoFillTableAux @@fe_id

  declare @dia           tinyint
  declare @mes           tinyint
  declare @anio          smallint
  declare @recurrente    tinyint
  declare @fei_id        int
  declare @fei_fecha    datetime
  declare @max          smallint

  delete FeriadoItem where fe_id = @@fe_id

  select @dia = fe_dia, @mes = fe_mes, @anio = fe_anio, @recurrente = fe_recurrente

  from Feriado

  where fe_id = @@fe_id

  if @anio = 0 set @anio = datepart(y,getdate())

  if @anio < 2000 set @anio = 2000

  if @recurrente <> 0 set @max = 2100
  else                set @max = @anio

  while @anio <= @max 
  begin

    exec sp_dbgetnewid 'FeriadoItem','fei_id',@fei_id out, 0

    set @fei_fecha = convert(datetime, 
                            convert(varchar(4), @anio)+
                            substring('00',1,2-len(convert(varchar(2), @mes)))+convert(varchar(2), @mes)+
                            substring('00',1,2-len(convert(varchar(2), @dia)))+convert(varchar(2), @dia)
                            )

    insert into FeriadoItem  (fei_id, fe_id, fei_fecha) 
                      values (@fei_id, @@fe_id, @fei_fecha)
    set @anio = @anio + 1

  end

  exec sp_DocFeriadoUpdate @@fe_id

end

go