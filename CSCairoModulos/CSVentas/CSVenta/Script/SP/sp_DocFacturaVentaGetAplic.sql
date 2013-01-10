if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetAplic]

go

/*

sp_DocFacturaVentaGetAplic 1,112,6

select * from cliente where cli_id = 23
select * from cliente where cli_id = 26

*/
create procedure sp_DocFacturaVentaGetAplic (
  @@emp_id      int,
  @@fv_id       int,
  @@tipo        tinyint    /* 1: Vencimientos 
                              2: Aplicaciones Cobranzas y Notas de credito 
                              3: Aplicaciones posibles (Cobranzas y Notas de credito) 
                              4: Pendientes Items (Articulos)
                              5: Aplicaciones Pedidos y Remitos
                              6: Aplicaciones posibles (Pedidos y Remitos)
                            */
)
as
begin

  exec sp_DocFacturaVentaGetAplicCliente @@emp_id, @@fv_id, @@tipo

end

go
