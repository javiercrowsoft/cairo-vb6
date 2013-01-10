if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ListaPrecioGet 3

create procedure sp_ListaPrecioGet (
  @@lp_id  int
)
as

set nocount on

begin

  select 
          ListaPrecio.*,
          padre=l2.lp_nombre,
          mon_nombre

  from ListaPrecio left join ListaPrecio l2 on ListaPrecio.lp_id_padre = l2.lp_id
                   left join moneda m       on ListaPrecio.mon_id = m.mon_id

  where ListaPrecio.lp_id = @@lp_id 


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



