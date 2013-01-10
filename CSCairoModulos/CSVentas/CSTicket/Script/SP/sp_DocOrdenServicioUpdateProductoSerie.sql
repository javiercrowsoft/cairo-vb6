if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioUpdateProductoSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioUpdateProductoSerie]

go
/*

 sp_DocOrdenServicioUpdateProductoSerie 93

*/

create procedure sp_DocOrdenServicioUpdateProductoSerie (
  @@os_id int
)
as

begin

  set nocount on

  declare @os_id             int
  declare  @prns_id          int
  declare  @st_id            int
  declare @prp_id           int
  declare @cli_id            int
  declare @cont_id          int
  declare @etf_id           int
  declare @tar_id_activa    int
  declare @rv_id            int

  declare c_os insensitive cursor for

    select   os.os_id,
            prns_id,
            os.st_id, 
            os.cli_id, 
            isnull(osi.cont_id,os.cont_id),
            etf_id

    from ordenservicio os inner join stockitem sti on os.st_id = sti.st_id and sti_ingreso > 0
                          left  join ordenservicioitem osi on   os.os_id = osi.os_id
                                                            and sti.sti_grupo = osi.osi_id
    where os.os_id = @@os_id

  open c_os

  fetch next from c_os into @os_id, @prns_id, @st_id, @cli_id, @cont_id, @etf_id
  while @@fetch_status=0
  begin

    if not exists(select * 
                  from ordenservicio os inner join stockitem sti on os.st_id = sti.st_id
                  where prns_id = @prns_id 
                    and sti.st_id > @st_id)
    begin

      -- TODO: Tarea Activa @tar_id_activa
      --

      set @prp_id  = null
      set @rv_id   = null

      select @prp_id = prp_id 
      from partereparacion 
      where os_id = @os_id and prns_id = @prns_id

      if @prp_id is null begin

        if exists(select * from partereparacion where os_id is null and prns_id = @prns_id)

          select @prp_id = min(prp_id) from partereparacion where os_id is null and prns_id = @prns_id

          update partereparacion set os_id = @os_id where prp_id = @prp_id

      end      

      select @rv_id = doc_id_salida 
      from ProductoNumeroSerie 
      where prns_id = @prns_id and doct_id_salida = 3


      if not exists (select * from ProductoNumeroSerieServicio where prnss_id = @prns_id) begin

        insert into ProductoNumeroSerieServicio ( prnss_id,
                                                  prns_codigo4,
                                                  prns_codigo5,
                                                  prns_codigo6,
                                                  prns_codigo7,
                                                  prns_id_reemplazo,
                                                  os_id,
                                                  prp_id,
                                                  stprov_id,
                                                  cli_id,
                                                  cont_id,
                                                  prov_id,
                                                  etf_id,
                                                  tar_id_activa,
                                                  rv_id
                                                )
                                        values (
                                                  @prns_id,
                                                  '',
                                                  '',
                                                  '',
                                                  '',
                                                  null,
                                                  @os_id,
                                                  @prp_id,
                                                  null,
                                                  @cli_id,
                                                  @cont_id,
                                                  null,
                                                  @etf_id,
                                                  @tar_id_activa,
                                                  @rv_id
                                                )
      end else begin

        update ProductoNumeroSerieServicio set   
                                                os_id         = @os_id,
                                                prp_id         = @prp_id,
                                                cli_id         = @cli_id,
                                                cont_id       = @cont_id,
                                                etf_id         = @etf_id,
                                                tar_id_activa = @tar_id_activa,
                                                rv_id         = @rv_id
        where prnss_id = @prns_id
                                
      end
    end

    fetch next from c_os into @os_id, @prns_id, @st_id, @cli_id, @cont_id, @etf_id
  end

  close c_os
  deallocate c_os

end
GO