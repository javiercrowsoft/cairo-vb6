if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorUpdateRemitoCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorUpdateRemitoCredito]

/*

 sp_proveedorUpdateRemitoCredito 12

*/

go
create procedure sp_proveedorUpdateRemitoCredito (
  @@prov_id     int,
  @@emp_id       int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_remitocompra    int
  declare @deudaRemitoAnterior  decimal(18,6)
  declare @deudaRemito          decimal(18,6)

  set @doct_remitocompra = 4

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @deudaRemito = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_remitocompra and prov_id = @@prov_id

  -- Deuda en el proveedor
  --
  select @deudaRemitoAnterior = prov_deudaRemito from Proveedor where prov_id = @@prov_id

  update Proveedor set 
                    prov_deudaRemito   = IsNull(@deudaRemito,0), 
                    prov_deudaTotal   = prov_deudaTotal - IsNull(@deudaRemitoAnterior,0) + IsNull(@deudaRemito,0)
        where prov_id = @@prov_id

  -- Actualizo la deuda en la tabla EmpresaProveedorDeuda
  --
  select @deudaRemito         = 0, 
         @deudaRemitoAnterior = 0

  -- Deuda en el cache para la empresa del documento modificado
  --
  select @deudaRemito = sum(provcc_importe) from ProveedorCacheCredito where  doct_id = @doct_remitocompra 
                                                                           and prov_id = @@prov_id
                                                                           and emp_id  = @@emp_id

  declare @empprovd_id int
  select @empprovd_id = empprovd_id from EmpresaProveedorDeuda where  prov_id = @@prov_id
                                                                  and emp_id   = @@emp_id
  if isnull(@empprovd_id,0)<>0 begin

    select @deudaRemitoAnterior = empprovd_deudaRemito from EmpresaProveedorDeuda where empprovd_id = @empprovd_id
  
    update EmpresaProveedorDeuda set 
                      empprovd_deudaRemito   = IsNull(@deudaRemito,0),
                      empprovd_deudaTotal   =   empprovd_deudaTotal 
                                              - IsNull(@deudaRemitoAnterior,0) 
                                              + IsNull(@deudaRemito,0)
          where empprovd_id = @empprovd_id

  end else begin

    exec sp_dbgetnewid 'EmpresaProveedorDeuda', 'empprovd_id', @empprovd_id out, 0

    insert into EmpresaProveedorDeuda (empprovd_id,  emp_id,   prov_id,   empprovd_deudaRemito,   empprovd_deudaTotal)
                              values  (@empprovd_id, @@emp_id, @@prov_id, IsNull(@deudaRemito,0), IsNull(@deudaRemito,0))

  end
end
go