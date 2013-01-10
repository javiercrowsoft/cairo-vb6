if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_articulocheckstock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_articulocheckstock]

go
/*

delete ComunidadInternetCobro

sp_srv_cvxi_articulocheckstock 1, 'HORA230','UPS Atomlux 500 220v 5 salidas c/soft monitoreo Microcentro','89946048','358,90','10025662','Acreditado','09/08/2010','20100809 00:00:00'

*/

create procedure sp_srv_cvxi_articulocheckstock (

  @@cmi_id              int,
  @@articuloid          varchar(255),
  @@articulo           varchar(1000),
  @@disponible          decimal(18,6)

)

as

begin

  set nocount on

  declare @pr_id int

  select @pr_id = min(pr_id)
  from ComunidadInternetProducto
  where cmipr_codigo = @@articuloid
      and cmi_id = @@cmi_id

  if @pr_id is null begin

    select @pr_id = min(pr_id)
    from ProductoComunidadInternet
    where prcmi_codigo = @@articuloid
      and cmi_id = @@cmi_id

  end

  if @pr_id is not null begin

    declare @depl_id int
  
    select @depl_id = depl_id
    from ComunidadInternet
    where cmi_id = @@cmi_id
  
    if @depl_id is not null begin
  
      declare @reposicion decimal(18,6)

      select @reposicion = prdepl_reposicion  
      from ProductoDepositoLogico 
      where pr_id = @pr_id 
        and depl_id = @depl_id 

      if @reposicion >= @@disponible begin

        select '<table><tr><td colspan=2>El articulo <b>' + @@articuloid + '</b> ha alcanzado su punto de reposición<br/>' 
               + '<tr><td colspan=2>' + @@articulo
               + '<tr><td>Reposicion: </td><td align="right">' + convert(varchar,convert(decimal(18,2),@reposicion))
               + '</td></tr><tr><td>Disponible: </td><td align="right">' + convert(varchar,convert(decimal(18,2),@@disponible))
               + '</td></tr></table><br />'
                as msg

      end
  
    end

  end else begin

    select '<p><font color=red>El articulo <b>' + @@articuloid + '</b> aun no esta vinculado a un producto del sistema</font></p>' as msg

  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

