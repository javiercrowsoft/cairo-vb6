if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CatalogoWebGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CatalogoWebGetItems]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_CatalogoWebGetItems 2

create procedure sp_CatalogoWebGetItems (
  @@catw_id        int,
  @@pr_nombre      varchar(255)
)
as

set nocount on

begin

  if @@pr_nombre <> '' set @@pr_nombre = '%' + @@pr_nombre + '%'

  select top 50   catwi.*, 
                  pr_nombreventa    as pr_nombre

  from CatalogoWebItem catwi inner join Producto p on catwi.pr_id = p.pr_id
  where catw_id = @@catw_id 
    and (      pr_nombreventa like @@pr_nombre or @@pr_nombre = ''
          or  pr_codigo      like @@pr_nombre or @@pr_nombre = ''
        )
  order by pr_nombreventa

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



