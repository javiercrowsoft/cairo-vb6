if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorGet]

/*

 select * from proveedor where cli_codigo like '300%'
 select * from documento

 sp_proveedorGet 35639

*/

go
create procedure sp_proveedorGet (
  @@prov_id     int
)
as

begin

  set nocount on


  select 
        proveedor.*,
        pro_nombre,
        zon_nombre,
        cpg_nombre,
        lp_nombre,
        ld_nombre,
        us_nombre

  from 
        proveedor left join provincia          on proveedor.pro_id = provincia.pro_id
                  left join zona              on proveedor.zon_id = zona.zon_id
                  left join condicionpago     on proveedor.cpg_id = condicionpago.cpg_id
                  left join listaprecio       on proveedor.lp_id  = listaprecio.lp_id
                  left join listadescuento    on proveedor.ld_id  = listadescuento.ld_id
                  left join usuario us        on proveedor.us_id  = us.us_id

 where prov_id = @@prov_id

end

go