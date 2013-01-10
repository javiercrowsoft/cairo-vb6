if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepositoLogicoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepositoLogicoGet]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_DepositoLogicoGet 35639

*/

go
create procedure sp_DepositoLogicoGet (
  @@depl_id     int
)
as

begin

  set nocount on

  select depl.*,
         depf_nombre,
         emp_nombre,
         cli_nombre,
         prov_nombre

  from depositologico depl inner join depositofisico depf on depl.depf_id = depf.depf_id
                           left  join empresa emp         on depl.emp_id  = emp.emp_id
                           left  join cliente cli         on depl.cli_id  = cli.cli_id
                           left  join proveedor prov      on depl.prov_id = prov.prov_id

  where depl_id = @@depl_id

end

go