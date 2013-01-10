if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ClienteGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteGetData]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

  select * from cliente

  sp_ClienteGetData 1

*/

create procedure sp_ClienteGetData (
  @@cli_id  int,
  @@mon_id  int
)
as

set nocount on

begin

  declare @lp_id int
  declare @ld_id int

  select @lp_id = lp_id, @ld_id = ld_id
  
  from
  
  Cliente
  
  where
     cli_id = @@cli_id

  if @lp_id is not null begin
    if not exists(select * from ListaPrecio where lp_id = @lp_id and mon_id = @@mon_id and lp_tipo = 1) begin
      select @lp_id = null
    end
  end

  if @lp_id is null
      select @lp_id = min(lp_id) from ListaPrecio where mon_id = @@mon_id and lp_tipo = 1 and lp_default <> 0

  if @ld_id is not null begin
    if not exists(select * from ListaDescuento where ld_id = @ld_id and mon_id = @@mon_id and ld_tipo = 1) begin
      select @ld_id = null
    end
  end

  select 
          @lp_id as lp_id, 
          @ld_id as ld_id, 
          cli.cpg_id, 
          cli.trans_id, 
          cli.ven_id,
          ven_nombre,
          trans_nombre,
          IsNull(
            IsNull(trans.pro_id,prov.pro_id)
            ,cli.pro_id
                ) as pro_id,
          IsNull(
            IsNull(p1.pro_nombre,p2.pro_nombre)
            ,p3.pro_nombre
                ) as pro_nombre
  
  
  from
  
  Cliente cli  left join Transporte trans on cli.trans_id  = trans.trans_id
              left join Proveedor prov   on trans.prov_id = prov.prov_id
              left join Vendedor ven     on cli.ven_id    = ven.ven_id
              left join Provincia p1     on trans.pro_id  = p1.pro_id
              left join Provincia p2     on prov.pro_id   = p2.pro_id
              left join Provincia p3     on cli.pro_id    = p3.pro_id
  where
     cli_id = @@cli_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



