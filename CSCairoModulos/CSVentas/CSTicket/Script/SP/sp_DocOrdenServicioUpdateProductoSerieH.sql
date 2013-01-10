if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioUpdateProductoSerieH]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioUpdateProductoSerieH]

go
/*

 sp_DocOrdenServicioUpdateProductoSerieH 93

*/

create procedure sp_DocOrdenServicioUpdateProductoSerieH (
  @@os_id int
)
as

begin

  set nocount on

  declare @os_id             int
  declare  @prns_id          int
  declare  @prp_id            int
  declare  @rv_id            int
  declare  @st_id            int
  declare @cli_id            int
  declare @cont_id          int
  declare @etf_id           int
  declare @prnsh_id         int
  declare @modifico         int

  declare c_os insensitive cursor for

    select   os.os_id,
            prns_id,
            os.st_id, 
            os.cli_id, 
            isnull(osi.cont_id,os.cont_id),
            etf_id,
            os.modifico

    from ordenservicio os inner join stockitem sti on os.st_id = sti.st_id and sti_ingreso > 0
                          left  join ordenservicioitem osi on   os.os_id = osi.os_id
                                                            and sti.sti_grupo = osi.osi_id
    where os.os_id = @@os_id

  open c_os

  fetch next from c_os into @os_id, @prns_id, @st_id, @cli_id, @cont_id, @etf_id,@modifico
  while @@fetch_status=0
  begin

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

    set @prnsh_id = 0

    select @prnsh_id = prnsh_id 
    from ProductoNumeroSerieHistoria 
    where prns_id = @prns_id 
      and os_id = @@os_id

    set @prnsh_id = isnull(@prnsh_id,0)

    if @prnsh_id = 0 begin

      exec sp_dbgetnewid 'ProductoNumeroSerieHistoria', 'prnsh_id', @prnsh_id out, 0

      insert into ProductoNumeroSerieHistoria ( 
                                              prnsh_id,
                                              prns_id,
                                              prns_codigo2,
                                              prns_codigo3,
                                              prns_codigo4,
                                              prns_codigo5,
                                              prns_codigo6,
                                              prns_codigo7,
                                              prns_fechavto,
                                              prns_descrip,
                                              tar_id,
                                              tar_id_activa,
                                              os_id,
                                              prp_id,
                                              stprov_id,
                                              cli_id,
                                              cont_id,
                                              prov_id,
                                              etf_id,
                                              tar_id_activa1,
                                              rv_id,
                                              modifico
                                            )
                                      select
                                              @prnsh_id,
                                              prns_id,
                                              prns_codigo2,
                                              prns_codigo3,
                                              '', --prns_codigo4,
                                              '', --prns_codigo5,
                                              '', --prns_codigo6,
                                              '', --prns_codigo7,
                                              prns_fechavto,
                                              prns_descrip,
                                              tar_id,
                                              tar_id,
                                              @@os_id,
                                              @prp_id,
                                              '',
                                              @cli_id,
                                              @cont_id,
                                              null,
                                              @etf_id,
                                              tar_id,
                                              @rv_id,
                                              @modifico

                                      from ProductoNumeroSerie 
                                      where prns_id = @prns_id
    end else begin

      update ProductoNumeroSerieHistoria set   
                                              prns_codigo2      = p.prns_codigo2,
                                              prns_codigo3      = p.prns_codigo3,
                                              prns_codigo4      = '', --p.prns_codigo4,
                                              prns_codigo5      = '', --p.prns_codigo5,
                                              prns_codigo6      = '', --p.prns_codigo6,
                                              prns_codigo7      = '', --p.prns_codigo7,
                                              prns_fechavto      = p.prns_fechavto,
                                              prns_descrip      = p.prns_descrip,
                                              tar_id            = p.tar_id,
                                              tar_id_activa      = p.tar_id,
                                              cli_id            = @cli_id,
                                              cont_id            = @cont_id,
                                              etf_id            = @etf_id,
                                              tar_id_activa1    = p.tar_id,
                                              prp_id            = @prp_id,
                                              rv_id             = @rv_id,
                                              modifico          = @modifico
      from ProductoNumeroSerie p
      where ProductoNumeroSerieHistoria.prnsh_id = @prnsh_id
        and ProductoNumeroSerieHistoria.prns_id  = p.prns_id
                              
    end

    fetch next from c_os into @os_id, @prns_id, @st_id, @cli_id, @cont_id, @etf_id, @modifico
  end

  close c_os
  deallocate c_os

end
GO