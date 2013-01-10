/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetMovimientos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetMovimientos]


/*

sp_MovimientoCajaGetMovimientos 5

*/

go
create procedure sp_MovimientoCajaGetMovimientos (

  @@mcj_id  int

)as 

begin

  set nocount on

  select   mcjm.*,
          as_doc_cliente,
          as_nrodoc,
          as_fecha,
          case when doct_id_cliente = 13 then id_cliente else 0 end as cobz_id

  from MovimientoCajaMovimiento  mcjm inner join Asiento ast on mcjm.as_id = ast.as_id
                                    
  where mcj_id = @@mcj_id

end
go