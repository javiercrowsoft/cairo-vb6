if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_garantiaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_garantiaGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_garantiaGet 2

create procedure sp_garantiaGet (
  @@gar_id  int
)
as

set nocount on

begin

 select
    Garantia.*,
    prov_nombre,
    mon_nombre
 from
 
 Garantia inner join Proveedor on Garantia.prov_id  = Proveedor.prov_id
          inner join Moneda    on Garantia.mon_id   = Moneda.mon_id

 where
     gar_id = @@gar_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go