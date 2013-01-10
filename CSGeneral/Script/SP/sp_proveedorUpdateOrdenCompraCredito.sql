if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorUpdateOrdenCompraCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorUpdateOrdenCompraCredito]

/*

 sp_proveedorUpdateOrdenCompraCredito 12

*/

go
create procedure sp_proveedorUpdateOrdenCompraCredito (
  @@prov_id     int,
  @@emp_id       int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_Ordencompra      int
  declare @deudaOrdenAnterior    decimal(18,6)
  declare @deudaOrden            decimal(18,6)

  set @doct_Ordencompra = 35

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @deudaOrden = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_Ordencompra and prov_id = @@prov_id

  -- Deuda en el proveedor
  --
  select @deudaOrdenAnterior = prov_deudaOrden from Proveedor where prov_id = @@prov_id

  update Proveedor set 
                    prov_deudaOrden   = IsNull(@deudaOrden,0), 
                    prov_deudaTotal   = prov_deudaTotal - IsNull(@deudaOrdenAnterior,0) + IsNull(@deudaOrden,0)
        where prov_id = @@prov_id

  -- Actualizo la deuda en la tabla EmpresaProveedorDeuda
  --
  select @deudaOrden          = 0, 
         @deudaOrdenAnterior = 0

  -- Deuda en el cache para la empresa del documento modificado
  --
  select @deudaOrden = sum(provcc_importe) from ProveedorCacheCredito where   doct_id = @doct_Ordencompra 
                                                                           and prov_id = @@prov_id
                                                                           and emp_id  = @@emp_id

  declare @empprovd_id int
  select @empprovd_id = empprovd_id from EmpresaProveedorDeuda where  prov_id = @@prov_id
                                                                  and emp_id   = @@emp_id
  if isnull(@empprovd_id,0)<>0 begin

    select @deudaOrdenAnterior = empprovd_deudaOrden from EmpresaProveedorDeuda where empprovd_id = @empprovd_id
  
    update EmpresaProveedorDeuda set 
                      empprovd_deudaOrden   = IsNull(@deudaOrden,0),
                      empprovd_deudaTotal   =   empprovd_deudaTotal 
                                              - IsNull(@deudaOrdenAnterior,0) 
                                              + IsNull(@deudaOrden,0)
          where empprovd_id = @empprovd_id

  end else begin

    exec sp_dbgetnewid 'EmpresaProveedorDeuda', 'empprovd_id', @empprovd_id out, 0

    insert into EmpresaProveedorDeuda (empprovd_id,  emp_id,   prov_id,   empprovd_deudaOrden,   empprovd_deudaTotal)
                              values  (@empprovd_id, @@emp_id, @@prov_id, IsNull(@deudaOrden,0), IsNull(@deudaOrden,0))

  end
end
go