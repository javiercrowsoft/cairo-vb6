if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaDescuentoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaDescuentoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ListaDescuentoGet 1

create procedure sp_ListaDescuentoGet (
  @@ld_id  int
)
as

set nocount on

begin

  select 
          ListaDescuento.*,
          padre=l2.ld_nombre,
          mon_nombre

  from ListaDescuento left join ListaDescuento l2 on ListaDescuento.ld_id_padre = l2.ld_id
                       left join moneda m           on ListaDescuento.mon_id = m.mon_id

  where ListaDescuento.ld_id = @@ld_id


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



