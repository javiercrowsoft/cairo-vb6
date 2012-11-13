if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoSaveKit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoSaveKit]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select pr_kititems from producto where pr_id = 255
-- sp_ProductoSaveKit 255

create procedure sp_ProductoSaveKit (
	@@pr_id	int
)
as

set nocount on

begin

  set nocount on

	declare @bResumido 	tinyint
	declare @cantidad 	decimal(18,6)

	if exists(select * from Producto where pr_id = @@pr_id and pr_eskit <> 0) begin

		select @bResumido = pr_kitResumido from Producto where pr_id = @@pr_id
	
		if @bResumido <> 0 begin
	
			set @cantidad = 1
	
		end else begin
	
			create table #KitItems			(
																		pr_id int not null, 
																		nivel int not null
																	)
		
			create table #KitItemsSerie(
																		pr_id_kit 			int null,
																		cantidad 				decimal(18,6) not null,
																		pr_id 					int not null, 
		                                prk_id 					int not null,
																		nivel       		smallint not null default(0)
																	)
		
			exec sp_StockProductoGetKitInfo @@pr_id, 0
		
			select @cantidad = sum (cantidad) from #KitItemsSerie
		
			set @cantidad = IsNull(@cantidad,0)
		
		end
	
		update Producto set pr_kitItems = @cantidad where pr_id = @@pr_id
	
	  declare @bLlevaNroSerie  tinyint
	
	  set @bLlevaNroSerie = 0
	  exec sp_StockProductoKitLlevaNroSerie @@pr_id, @bLlevaNroSerie out
	
	  if @bLlevaNroSerie <> 0 update Producto set pr_llevanroserie = 1 where pr_id = @@pr_id

	end else begin

		update Producto set pr_kitItems = 0 where pr_id = @@pr_id

	end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



--select * from stockitem