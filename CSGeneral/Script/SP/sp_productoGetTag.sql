if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetTag]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetTag]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGetTag 2

create procedure sp_ProductoGetTag (
  @@pr_id  int
)
as

set nocount on

begin

  select   t.*,
          pr_nombrecompra,
          rubti_nombre as Orden

  from ProductoTag t 
    left join Producto pr on pr.pr_id = t.pr_id_tag
    left join RubroTablaItem rubti on pr.rubti_id7 = rubti.rubti_id

  where t.pr_id = @@pr_Id
  order by rubti_descrip

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go