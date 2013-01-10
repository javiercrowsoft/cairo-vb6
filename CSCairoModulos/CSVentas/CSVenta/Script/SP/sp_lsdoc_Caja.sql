/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Caja]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Caja]


/*

sp_lsdoc_Caja 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_lsdoc_Caja (

  @@mcj_id  int

)as 

begin

  set nocount on
  
select 

  mcj_id,
  ''                as TypeTask,
  mcj_fecha          as Fecha,
  convert(varchar,mcj_hora,108)      
                    as Hora,
  mcj_numero        as Numero,
  mcj_nrodoc        as Comprobante,
  suc_nombre        as Sucursal,
  cj_nombre          as Caja,
  usc.us_nombre     as Cajero,

  case mcj_tipo when 1 then 'Apertura' when 2 then 'Cierre' end as [Operación],

  emp_nombre        as Empresa,

  mcj.creado        as Creado,
  mcj.modificado    as Modificado,
  us.us_nombre      as Modifico,
  mcj_descrip        as [Descripción]

from 

    MovimientoCaja mcj  inner join Usuario us      on mcj.modifico     = us.us_id
                        left  join Caja cj        on mcj.cj_id        = cj.cj_id
                        left  join empresa        on cj.emp_id        = empresa.emp_id     
                        left  join Sucursal suc   on cj.suc_id         = suc.suc_id
                        left  join Usuario usc    on mcj.us_id_cajero = usc.us_id
where 
      mcj_id = @@mcj_id
end
go