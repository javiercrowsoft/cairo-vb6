/*---------------------------------------------------------------------
Nombre: Reportes por Usuario
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0020]

go
create procedure DC_CSC_SYS_0020 (

  @@us_id    int

)as 
begin
set nocount on

select 
    inf.*,
    us_nombre
from 
    informe inf inner join reporte rpt on inf.inf_id = rpt.inf_id
                inner join usuario us  on rpt.us_id  = us.us_id

end

go