if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_productoGetCueId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoGetCueId]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

  select * from cliente
  select * from Producto
  select * from cuenta where cue_id = 129

  sp_productoGetCueId 6,12

*/

create procedure sp_productoGetCueId (
  @@cli_id      int,
  @@prov_id     int,
  @@pr_id        int,
  @@bSelect     tinyint = 1,
  @@cue_id      int = 0 out
)
as

set nocount on

begin

  declare @cue_id  int

  if @@cli_id is not null begin      

    -- Obtengo la cuenta de ventas
    --
    select @cue_id = ClienteCuentaGrupo.cue_id
    from ClienteCuentaGrupo inner join Producto    on ClienteCuentaGrupo.cueg_id = Producto.cueg_id_venta
    where cli_id = @@cli_id and pr_id = @@pr_id
  
    -- Saco la cuenta de CuentaGrupo
    --
    if @cue_id is null begin
      select @cue_id = CuentaGrupo.cue_id
      from CuentaGrupo inner join Producto  on CuentaGrupo.cueg_id = Producto.cueg_id_venta
      where Producto.pr_id = @@pr_id
    end

  end else begin

    -- Obtengo la cuenta de compras
    --
    select @cue_id = ProveedorCuentaGrupo.cue_id
    from ProveedorCuentaGrupo inner join Producto   on ProveedorCuentaGrupo.cueg_id = Producto.cueg_id_compra
    where prov_id = @@prov_id and pr_id = @@pr_id
  
    -- Saco la cuenta de CuentaGrupo
    --
    if @cue_id is null begin
      select @cue_id = CuentaGrupo.cue_id
      from CuentaGrupo inner join Producto on CuentaGrupo.cueg_id = Producto.cueg_id_compra
      where Producto.pr_id = @@pr_id
    end

  end

  set @@cue_id = @cue_id

  if @@bSelect <> 0 select @cue_id as cue_id
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



