if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteInformeSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteInformeSave]

/*

 select * from proveedor where cli_codigo like '300%'
 select * from documento

 sp_clienteInformeSave 35639

*/

go
create procedure sp_clienteInformeSave (
  @@cli_id        int,
  @@pre_id        int,
  @@modifico      int
)
as

begin

  set nocount on
  
  declare @us_id     int
  declare @per_id   int
  
  select @us_id = us_id from cliente where cli_id = @@cli_id

  set @us_id = IsNull(@us_id,0)

  if not exists(select * from permiso where pre_id = @@pre_id and us_id = @us_id) begin

    exec sp_dbgetnewid 'Permiso','per_id',@per_id out,0

    insert into permiso (per_id, pre_id, us_id, modifico)
                values  (@per_id, @@pre_id, @us_id, @@modifico)
  end

  declare @inf_id       int
  declare @inf_nombre    varchar(255)
  declare @inf_descrip  varchar(255)

  select @inf_id         = inf_id,
         @inf_nombre    = inf_nombre,
         @inf_descrip   = inf_descrip

  from informe where pre_id = @@pre_id

  if not exists(select * from reporte where inf_id = @inf_id and us_id = @us_id)
  begin

    declare @rpt_id int

    exec sp_dbgetnewid 'Reporte','rpt_id',@rpt_id out

    insert into reporte (
                          rpt_id,
                          rpt_nombre,
                          rpt_descrip,
                          inf_id,
                          us_id,
                          modifico
                        )
                values (
                          @rpt_id,
                          @inf_nombre,
                          @inf_descrip,
                          @inf_id,
                          @us_id,
                          @@modifico
                        )

    declare c_params insensitive cursor for 
                select 
                        infp_id

                from informeparametro

                where inf_id = @inf_id and infp_visible <> 0

                order by infp_orden

    open c_params

    declare @infp_id  int
    declare @rptp_id  int

    fetch next from c_params into @infp_id
    while @@fetch_status=0
    begin

      exec sp_dbgetnewid 'ReporteParametro','rptp_id',@rptp_id out,0

      insert into ReporteParametro (
                                    rptp_id,
                                    rptp_valor,
                                    rptp_visible,
                                    rpt_id,
                                    infp_id,
                                    modifico
                                    )
                          values   (
                                    @rptp_id,
                                    '',
                                    1,
                                    @rpt_id,
                                    @infp_id,
                                    @@modifico
                                  )


      fetch next from c_params into @infp_id
    end

    close c_params

    deallocate c_params

  end

end

go