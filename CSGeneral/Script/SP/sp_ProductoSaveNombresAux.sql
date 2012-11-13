if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoSaveNombresAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoSaveNombresAux]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

create procedure sp_ProductoSaveNombresAux (
	@@us_id 	int,
	@@pr_id		int,
	@@rpt_id 	int
)
as

set nocount on

begin

	declare @sqlstmt 							varchar(5000)
	declare @param                varchar(255)
	declare @param_tipo           tinyint
	declare @inf_id  							int

	if @@rpt_id is not null begin

		select @inf_id = inf_id from Reporte where rpt_id = @@rpt_id
		select @sqlstmt = inf_storedprocedure from Informe where inf_id = @inf_id

		set @sqlstmt = @sqlstmt + ' ' + convert(varchar,@@us_id) + ',' + convert(varchar,@@pr_id) + ','

		declare c_params insensitive cursor for 
			select isnull(rptp_valor,infp_default), infp_tipo
			from Reporte rpt inner join InformeParametro infp on rpt.inf_id = infp.inf_id
											 left  join ReporteParametro rptp on 		rpt.rpt_id   = rptp.rpt_id
																													and rptp.infp_id = infp.infp_id
	
			where rpt.rpt_id = @@rpt_id and infp_orden > 1
				order by infp_orden

		open c_params

		fetch next from c_params into @param, @param_tipo
		while @@fetch_status=0
		begin

			set @param = 
									case @param_tipo
									  when 1 then case when @param = '' 	then ''''''   else ''''+@param+'''' end--csInfParamDate = 1
									  when 2 then case when @param = ''   then '''0'''  else ''''+@param+'''' end--csInfParamHelp = 2
									  when 3 then case when @param = '' 	then '0'      else @param 					end--csInfParamNumeric = 3
									  --when 4 --csInfParamSqlstmt = 4
									  when 5 then case when @param = '' 	then ''''''   else ''''+@param+'''' end--csInfParamText = 5
									  when 6 then case when @param = ''   then '0' 			else @param 					end--csInfParamList = 6
									  when 7 then case when @param = ''   then '0' 			else @param 					end--csInfParamCheck = 7
										else '@@@'
									end

			set @sqlstmt = @sqlstmt + @param + ','

			fetch next from c_params into @param, @param_tipo
		end

		set @sqlstmt = substring(@sqlstmt,1,len(@sqlstmt)-1)

		close c_params
		deallocate c_params

		--print (@sqlstmt)
		exec (@sqlstmt)

	end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



