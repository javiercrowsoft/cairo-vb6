if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProveedorGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProveedorGetData]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProveedorGetData 2

create procedure sp_ProveedorGetData (
  @@prov_id  int,
  @@mon_id  int
)
as

set nocount on

begin

  declare @cpg_id int
  declare @lp_id  int
  declare @ld_id  int

  select @lp_id = lp_id, @ld_id = ld_id, @cpg_id = cpg_id
  
  from
  
  Proveedor
  
  where
     prov_id = @@prov_id

  if @lp_id is not null begin
    if not exists(select * from ListaPrecio where lp_id = @lp_id and mon_id = @@mon_id and lp_tipo in (2,3)) begin
      select @lp_id = null
    end
  end

  if @lp_id is null
      select @lp_id = min(lp_id) from ListaPrecio where mon_id = @@mon_id and lp_tipo in (2,3) and lp_default <> 0

  if @ld_id is not null begin
    if not exists(select * from ListaDescuento where ld_id = @ld_id and mon_id = @@mon_id and ld_tipo = 2) begin
      select @ld_id = null
    end
  end

  select @lp_id as lp_id, @ld_id as ld_id, @cpg_id as cpg_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



