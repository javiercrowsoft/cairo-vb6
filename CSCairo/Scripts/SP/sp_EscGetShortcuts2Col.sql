if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EscGetShortcuts2Col]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EscGetShortcuts2Col]

go

-- sp_EscGetShortcuts2Col 49
create procedure sp_EscGetShortcuts2Col (
	@@us_id int
)
as
begin
	set nocount on

create table #pres(
	id   int,
	pre1 varchar(255),
	pre2 varchar(255),
	preid1 int,
	preid2 int,
	premodulo1 	varchar(1000),
	premodulo2 	varchar(1000),
  predesc1 		varchar(1000),
  predesc2 		varchar(1000),
	sysm_id1    int,
	sysm_id2    int
)

	declare @n int
	declare @id int
	declare @pre varchar(255)
	declare @preid int
	declare @predesc 		 varchar(1000)
	declare @modulo   	 varchar(1000)
	declare @lastmodulo  varchar(1000)
	declare @sysm_id		 int

	declare c_pre insensitive cursor for

		select 
				distinct
				pre.pre_id,
				pre_nombreesc,
				pre_grupoesc,
				'',
				pre.sysm_id

	  from sysModuloUser u 
 							 inner join prestacion pre 

											on 		u.us_id = @@us_id 
												and u.sysm_id = pre.sysm_id_security

												and (			pre.pre_id between	16000 and 16999								-- Ventas
															or	pre.pre_id between	3000  and 3999								-- Ventas
															or	pre.pre_id between	17000 and 17999								-- Compras
														 	or  pre.pre_id between  19000 and 19999               -- Contabilidad
														 	or  pre.pre_id between  18000 and 18999               -- Tesoreria
														 	or  pre.pre_id between  22000 and 22499               -- Exportacion
														 	or  pre.pre_id between  20000 and 20999               -- Stock
														 	or  pre.pre_id between  15000 and 15999               -- Envios
															or  pre.pre_id between  32000 and 32999								-- UTHGRA
															or  pre.pre_id between  37000 and 37999								-- Educacion
														)	
 
 	  where pre_nombreesc <> ''
 
 		order by pre_grupoesc, pre_nombreesc
	
	set @n = 1
	set @id = 0
	
	open c_pre
	fetch next from c_pre into @preid, @pre, @modulo, @predesc, @sysm_id
	while @@fetch_status = 0 begin

		if @n=1 begin
			set @id = @id + 1
			insert into #pres (id,pre1,preid1,predesc1,premodulo1,sysm_id1) values(@id,@pre,@preid,@predesc,@modulo,@sysm_id)
			set @lastmodulo = @modulo 
			set @n = 2
	 	end 
	  else begin
			if @lastmodulo <> @modulo begin
				set @id = @id + 1
				insert into #pres (id,pre1,preid1,predesc1,premodulo1,sysm_id1) values(@id,@pre,@preid,@predesc,@modulo,@sysm_id)
				set @lastmodulo = @modulo 
				set @n = 2
			end else begin
				update #pres set 	pre2 				= @pre, 
													preid2 			= @preid, 
													predesc2 		= @predesc, 
													premodulo2 	= @modulo,
													sysm_id2 		= @sysm_id
				where id = @id
				set @n = 1
			end
		end
	
		fetch next from c_pre into @preid, @pre, @modulo, @predesc, @sysm_id
	end
	close c_pre
	deallocate c_pre
	
	select * from #pres
	
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

