if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetTasas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetTasas]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGetTasas 2

create procedure sp_ProductoGetTasas (
	@@pr_id	int
)
as

set nocount on

begin

 select ti_id_ivaricompra, 
				ti_id_ivarnicompra, 
				ti_id_ivariventa, 
				ti_id_ivarniventa, 
				ti_id_internosc, 
				ti_id_internosv,
				pr_porcinternoc,
				pr_porcinternov

 from
 
 Producto

 where
     pr_id = @@pr_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



