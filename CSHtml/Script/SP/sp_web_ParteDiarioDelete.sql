if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioDelete]

/*

 sp_web_ParteDiarioDelete 1,124,0

*/

go
create procedure sp_web_ParteDiarioDelete (
  @@us_id     int,
  @@ptd_id     int,
  @@rtn       int out

)
as

begin

  set nocount on

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  declare @ptd_titulo varchar(255)
  select @ptd_titulo = IsNull(ptd_titulo,substring(ptd_descrip,1,255)) from ParteDiario where ptd_id = @@ptd_id
  exec sp_HistoriaUpdate 15002, @@ptd_id, @@us_id, 4, @ptd_titulo 

  if exists(select * from ParteDiario ptd
            where ptd_id = @@ptd_id 
              and ptd_recurrente <> 0 and ptd_recurrente <> 10
              and (
                        ptd_id_padre is null
                    or  exists(select * from ParteDiario 
                               where ptd_id = ptd.ptd_id_padre
                                 and (   ptd_recurrente = 0 
                                      or ptd_recurrente = 10
                                     )
                              )
                  )
            ) begin

    delete HojaRutaItem 
    where ptd_id in (  select ptd_id 
                       from ParteDiario 
                       where ptd_id_padre = @@ptd_id and ptd_recurrente <> 0 and ptd_recurrente <> 10
                    )

    delete ParteDiario where ptd_id_padre = @@ptd_id and ptd_recurrente <> 0 and ptd_recurrente <> 10
    
  end                  

  delete HojaRutaItem where ptd_id = @@ptd_id

  update ParteDiario set ptd_id_padre = null where ptd_id_padre = @@ptd_id 
  delete ParteDiario where ptd_id = @@ptd_id 

  set @@rtn = 1

end