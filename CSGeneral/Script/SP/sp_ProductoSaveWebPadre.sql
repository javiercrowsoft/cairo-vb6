if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoSaveWebPadre]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoSaveWebPadre]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoSaveWebPadre 1,135

-- select rpt_id_nombrecompra,* from producto where rpt_id_nombrecompra is not null

-- DC_CSC_VEN_9700 1,135,1,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- DC_CSC_VEN_9700 1,135,0,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- DC_CSC_VEN_9700 1,135,0,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- Cartucho HP Negro Carga Completa Orignial Toner Laser

create procedure sp_ProductoSaveWebPadre (
	@@us_id int,
	@@pr_id	int
)
as

set nocount on

begin

	declare @pr_id_webpadre int
	declare @pr_id_tag int
	declare @prt_id int
	declare @prt_texto varchar(1000)
	declare @prt_expoweb smallint
	declare @prt_expocairo smallint
	declare @prt_pendienteweb tinyint

	-- // Padre

	select @pr_id_webpadre = pr_id_webpadre from producto where pr_id = @@pr_id

	if @pr_id_webpadre is not null begin

		if exists (select * from producto where pr_id_webpadre = @@pr_id) begin

				raiserror ('@@ERROR_SP:Existen productos que indican como padre web a este producto, por lo tanto este producto no puede tener un padre web. Solo se puede definir un nivel de herencia.', 
										16, 1)
				return
		end

	end

	if @pr_id_webpadre is not null begin

		delete ProductoTag where pr_id = @@pr_id

		declare c_tags insensitive cursor for
			select 	pr_id_tag,
							prt_expocairo,
							prt_expoweb,
							prt_pendienteweb,
							prt_texto
			from ProductoTag
			where pr_id = @pr_id_webpadre

		open c_tags

		fetch next from c_tags into @pr_id_tag, @prt_expocairo, @prt_expoweb, @prt_pendienteweb, @prt_texto
		while @@fetch_status=0
		begin

			exec sp_dbgetnewid 'ProductoTag','prt_id',@prt_id out, 0

			insert into ProductoTag(prt_id, pr_id, pr_id_tag, prt_expoweb, prt_expocairo, prt_pendienteweb, prt_texto)
											values (@prt_id, @@pr_id, @pr_id_tag, @prt_expoweb, @prt_expocairo, @prt_pendienteweb, @prt_texto)

			fetch next from c_tags into @pr_id_tag, @prt_expocairo, @prt_expoweb, @prt_pendienteweb, @prt_texto
		end

		close c_tags
		deallocate c_tags

	end else begin

	-- // Hijos

		declare @pr_id int
	
		declare c_hijos insensitive cursor for select pr_id from Producto where pr_id_webpadre = @@pr_id
	
		open c_hijos
	
		fetch next from c_hijos into @pr_id
		while @@fetch_status=0
		begin
	
			exec sp_ProductoSaveWebPadre @@us_id, @pr_id
	
			fetch next from c_hijos into @pr_id
		end
	
		close c_hijos
		deallocate c_hijos

	end
	
	-- Para que suba al sitio web
	--
	update producto set modificado = getdate() where pr_id = @@pr_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



