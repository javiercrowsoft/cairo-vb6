if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_cuentaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cuentaGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_cuentaGet 2

create procedure sp_cuentaGet (
  @@cue_id  int
)
as

set nocount on

begin

  select c.*,
         c1.cuec_nombre, 
         c2.cuec_nombre as cueclibroiva, 
         c1.cuec_tipo, 
         mon_nombre,
         bco_nombre,
         emp_nombre
  
  from cuenta c left join cuentacategoria c1 on c.cuec_id = c1.cuec_id 
                left join cuentacategoria c2 on c.cuec_id_libroiva = c2.cuec_id 
                 left join moneda m           on c.mon_id = m.mon_id
                left join banco b            on c.bco_id = b.bco_id
                left join empresa e          on c.emp_id = e.emp_id


  where c.cue_id = @@cue_id  

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



