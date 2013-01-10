if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CatalogoWebCategoriaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CatalogoWebCategoriaGetItems]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_CatalogoWebCategoriaGetItems 2

create procedure sp_CatalogoWebCategoriaGetItems (
  @@catwc_id      int,
  @@pr_nombre      varchar(255)
)
as

set nocount on

begin

  if @@pr_nombre <> '' set @@pr_nombre = '%' + @@pr_nombre + '%'

  select top 50   catwci.*, 
                  pr_nombreventa    as pr_nombre

  from CatalogoWebCategoriaItem catwci inner join Producto p on catwci.pr_id = p.pr_id
  where catwc_id = @@catwc_id 
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



