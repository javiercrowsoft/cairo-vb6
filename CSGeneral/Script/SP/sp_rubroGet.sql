if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RubroGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RubroGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
-- select max(rub_id) from rubro
-- sp_RubroGet 6

create procedure sp_RubroGet (
  @@rub_id  int
)
as

set nocount on

begin

select 
    Rubro.*, 
    rt1.rubt_nombre as rubro1,
    rt2.rubt_nombre as rubro2,
    rt3.rubt_nombre as rubro3,
    rt4.rubt_nombre as rubro4,
    rt5.rubt_nombre as rubro5,
    rt6.rubt_nombre as rubro6,
    rt7.rubt_nombre as rubro7,
    rt8.rubt_nombre as rubro8,
    rt9.rubt_nombre as rubro9,
    rt10.rubt_nombre as rubro10,
    rti1.rubti_nombre as rubroi1,
    rti2.rubti_nombre as rubroi2,
    rti3.rubti_nombre as rubroi3,
    rti4.rubti_nombre as rubroi4,
    rti5.rubti_nombre as rubroi5,
    rti6.rubti_nombre as rubroi6,
    rti7.rubti_nombre as rubroi7,
    rti8.rubti_nombre as rubroi8,
    rti9.rubti_nombre as rubroi9,
    rti10.rubti_nombre as rubroi10

from 
    Rubro left join RubroTabla as rt1  on Rubro.rubt_id1  = rt1.rubt_id
          left join RubroTabla as rt2  on Rubro.rubt_id2  = rt2.rubt_id
          left join RubroTabla as rt3  on Rubro.rubt_id3  = rt3.rubt_id    
          left join RubroTabla as rt4  on Rubro.rubt_id4  = rt4.rubt_id
          left join RubroTabla as rt5  on Rubro.rubt_id5  = rt5.rubt_id    
          left join RubroTabla as rt6  on Rubro.rubt_id6  = rt6.rubt_id
          left join RubroTabla as rt7  on Rubro.rubt_id7  = rt7.rubt_id    
          left join RubroTabla as rt8  on Rubro.rubt_id8  = rt8.rubt_id
          left join RubroTabla as rt9  on Rubro.rubt_id9  = rt9.rubt_id    
          left join RubroTabla as rt10 on Rubro.rubt_id10 = rt10.rubt_id

          left join RubroTablaItem as rti1  on Rubro.rubti_id1  = rti1.rubti_id    
          left join RubroTablaItem as rti2  on Rubro.rubti_id2  = rti2.rubti_id    
          left join RubroTablaItem as rti3  on Rubro.rubti_id3  = rti3.rubti_id    
          left join RubroTablaItem as rti4  on Rubro.rubti_id4  = rti4.rubti_id    
          left join RubroTablaItem as rti5  on Rubro.rubti_id5  = rti5.rubti_id    
          left join RubroTablaItem as rti6  on Rubro.rubti_id6  = rti6.rubti_id    
          left join RubroTablaItem as rti7  on Rubro.rubti_id7  = rti7.rubti_id    
          left join RubroTablaItem as rti8  on Rubro.rubti_id8  = rti8.rubti_id    
          left join RubroTablaItem as rti9  on Rubro.rubti_id9  = rti9.rubti_id    
          left join RubroTablaItem as rti10 on Rubro.rubti_id10 = rti10.rubti_id    

where 

    rub_id = @@rub_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



