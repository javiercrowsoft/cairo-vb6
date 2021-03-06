if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_EquipoDetalleGetDetalle ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EquipoDetalleGetDetalle ]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_EquipoDetalleGetDetalle  '',-1,0,7

 sp_EquipoDetalleGetDetalle  '',0,0,7

*/

create procedure sp_EquipoDetalleGetDetalle  (
  @@prns_id  int,
  @@pr_id    int
)
as
begin

  set nocount on

  declare @ed_id  int
  declare @pr_id  int
  declare @rub_id int

  declare @pr_nombrecompra   varchar(255)
  declare @rub_nombre        varchar(255)

  if @@prns_id < 0 
    set    @pr_id = @@pr_id
  else
    select @pr_id = pr_id from ProductoNumeroSerie where prns_id = @@prns_id

  select @rub_id = rub_id, @pr_nombrecompra = pr_nombrecompra from Producto where pr_id = @pr_id

  if @rub_id is null begin

    select 0 as result, 'Debe configurar el rubro de este articulo ['+@pr_nombrecompra+']para poder trabajar con el.'

  end else begin

    select @ed_id = ed_id from EquipoDetalle where rub_id = @rub_id and activo <> 0
  
    if @ed_id is null begin
  
      select @rub_nombre = rub_nombre from Rubro where rub_id = @rub_id  

      select 0 as result, 'Este rubro ['+@rub_nombre+'] no posee ningun detalle de equipo asociado.'
  
    end else begin
  
      select   @@prns_id as prns_id,
              @pr_id    as pr_id,
              ed_nombre,
              ed_id
    
      from EquipoDetalle ed
      where  ed_id   = @ed_id
  
    end
  end
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

