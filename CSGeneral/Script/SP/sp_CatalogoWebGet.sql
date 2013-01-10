if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CatalogoWebGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CatalogoWebGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_CatalogoWebGet 3

create procedure sp_CatalogoWebGet (
  @@catw_id  int
)
as

set nocount on

begin

  select 
          CatalogoWeb.*

  from CatalogoWeb 

  where CatalogoWeb.catw_id = @@catw_id 


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



