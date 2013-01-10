if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioShowDuplicadosDetalle]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioShowDuplicadosDetalle]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ListaPrecioShowDuplicadosDetalle 3

create procedure sp_ListaPrecioShowDuplicadosDetalle (
  @@lp_id  int
)
as

set nocount on

begin

  select pr_id, pr_nombrecompra as [Nombre Compra], pr_nombreventa as [Nombre Venta]
  from Producto
  where pr_id in (select pr_id 
                  from ListaPrecioItem 
                  where lp_id = @@lp_id 
                  group by pr_id 
                  having count(*)>1)

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



