if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9960]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9960]
GO
/*  

Para testear:

[DC_CSC_CON_9960] 70,'20051001 00:00:00','20060930 00:00:00','0','0','0','0','5'

DC_CSC_CON_9960 1, 
                '20060101',
                '20060120',
                '0', 
                '0',
                '0',
                '0',
                '0'
*/

create procedure DC_CSC_CON_9960 (

  @@us_id     int

)as 

begin
  set nocount on

  select  cue_id,
          emp_nombre     as Empresa,
          cue_nombre     as Nombre,
          cue_codigo    as Codigo,
          cue_identificacionexterna    as [Identificacion Externa],
          cue_descrip   as Descripcion

  from Cuenta cue left join Empresa emp on cue.emp_id = emp.emp_id


end
GO