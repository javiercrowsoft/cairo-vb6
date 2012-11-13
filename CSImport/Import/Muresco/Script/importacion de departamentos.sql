/*

Permite asociar los clientes con los departamentos 
basandose en los rangos de libreria y revestimientos

*/


select * from departamento where dpto_nombre like '%rev%'
select cli_codigo from departamentocliente inner join cliente on departamentocliente.cli_id = cliente.cli_id 
where dpto_id = 76

-- Libreria
exec MUR_DepartamentoCliente 215, '400000','500000'
exec MUR_DepartamentoCliente 218, '400000','500000'
exec MUR_DepartamentoCliente 228, '400000','500000'
exec MUR_DepartamentoCliente 230, '400000','500000'
exec MUR_DepartamentoCliente 234, '400000','500000'
exec MUR_DepartamentoCliente 238, '400000','500000'
exec MUR_DepartamentoCliente 245, '400000','500000'

-- Revestimientos
exec MUR_DepartamentoCliente 76, '300000','399999'
exec MUR_DepartamentoCliente 77, '300000','399999'
exec MUR_DepartamentoCliente 96, '300000','399999'
exec MUR_DepartamentoCliente 97, '300000','399999'
exec MUR_DepartamentoCliente 216, '300000','399999'
exec MUR_DepartamentoCliente 235, '300000','399999'
exec MUR_DepartamentoCliente 239, '300000','399999'
exec MUR_DepartamentoCliente 246, '300000','399999'

select max(dptocli_id) from departamentocliente

