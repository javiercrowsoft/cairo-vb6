/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_EmpleadoPeriodo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_EmpleadoPeriodo]


/*

sp_lsdoc_EmpleadoPeriodo 1,'20070101','20071128',0,'0','0'

*/

go
create procedure sp_lsdoc_EmpleadoPeriodo (

  @@empe_id  int

)as 

begin

  set nocount on

  select 
  
    empe_id,
    ''                as TypeTask,
    empe_fecha        as Fecha,
    empe_numero        as Numero,
    ccos_nombre       as [Centro de Costo],
    empe.creado       as Creado,
    empe.modificado   as Modificado,
    us.us_nombre      as Modifico,
    empe_descrip      as [Descripción]
  
  from 
  
      EmpleadoPeriodo empe  inner join Usuario us          on empe.modifico   = us.us_id
                            left  join CentroCosto ccos   on empe.ccos_id    = ccos.ccos_id
  
  
  where empe.empe_id = @@empe_id

end
go