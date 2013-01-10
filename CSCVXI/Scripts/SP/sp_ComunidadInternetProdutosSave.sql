if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ComunidadInternetProdutosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ComunidadInternetProdutosSave]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ComunidadInternetProdutosSave  3

create procedure sp_ComunidadInternetProdutosSave

as

set nocount on

begin

  declare @cmipr_codigo varchar(255)
  declare @pr_id         int
  declare @cmi_id        int
  declare @prcmi_id     int
  declare @cmipr_reposicion decimal(18,6)

  declare c_productos_comunidad insensitive cursor for 
    select cmipr_codigo, pr_id, cmi_id, cmipr_reposicion
    from ComunidadInternetProducto

  open c_productos_comunidad

  fetch next from c_productos_comunidad 
                    into  @cmipr_codigo, 
                          @pr_id, 
                          @cmi_id, 
                          @cmipr_reposicion

  while @@fetch_status = 0
  begin

    if @pr_id is null begin

      delete ProductoComunidadInternet where prcmi_codigo = @cmipr_codigo and cmi_id = @cmi_id

    end  else begin

      delete ProductoComunidadInternet 
      where prcmi_codigo = @cmipr_codigo 
        and cmi_id = @cmi_id 
        and pr_id <> @pr_id

      if not exists(select 1 
                    from ProductoComunidadInternet 
                    where prcmi_codigo = @cmipr_codigo 
                      and cmi_id = @cmi_id
                      and pr_id = @pr_id) begin

        exec sp_dbgetnewid 'ProductoComunidadInternet', 'prcmi_id', @prcmi_id out, 0

        insert into ProductoComunidadInternet (prcmi_id, prcmi_codigo, pr_id, cmi_id, modifico)
                                       values (@prcmi_id, @cmipr_codigo, @pr_id, @cmi_id, 1)

      end

      -- Deposito
      --
      declare @depl_id int

      select @depl_id = depl_id from ComunidadInternet where cmi_id = @cmi_id

      if @depl_id is not null begin

        declare @prdepl_id int

        select @prdepl_id = prdepl_id 
        from ProductoDepositoLogico 
        where depl_id = @depl_id 
          and pr_id = @pr_id

        if @prdepl_id is null begin
          
          exec sp_dbgetnewid 'ProductoDepositoLogico','prdepl_id', @prdepl_id out, 0

          insert into ProductoDepositoLogico (prdepl_id, depl_id, pr_id, prdepl_reposicion)
                                      values (@prdepl_id, @depl_id, @pr_id, @cmipr_reposicion)

        end
        else

          update ProductoDepositoLogico 
              set prdepl_reposicion = @cmipr_reposicion 
          where prdepl_id = @prdepl_id

      end

    end

    fetch next from c_productos_comunidad 
                      into  @cmipr_codigo, 
                            @pr_id, 
                            @cmi_id,
                            @cmipr_reposicion
  end

  close c_productos_comunidad
  deallocate c_productos_comunidad

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



