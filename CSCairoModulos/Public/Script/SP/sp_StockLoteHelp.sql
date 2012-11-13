if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_StockLoteHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockLoteHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_stocklotehelp 4, 1, 0, 'GCB0001',1,0,
'pr_id = 99 and exists(select * from StockCache where stl_id = stl.stl_id and pr_id = stl.pr_id and depl_id = 15 and stc_cantidad > 0)'

*/
create procedure sp_StockLoteHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@stl_id       		int						= 0,
  @@filter2         varchar(5000) = ''
)
as
begin

	set nocount on

	set @@filter = replace(@@filter,'''','''''')
	
	declare @sqlstmt varchar(8000)

	if @@check <> 0 begin

		set @sqlstmt = 

	 'select	stl_id,
						stl_codigo				as [Codigo],
						stl_nroLote   		as [Nro. Lote]

		from StockLote stl 
		where (stl_nroLote = '''+@@filter+''' or stl_codigo = '''+@@filter+''') '

		if @@stl_id <> 0
			set @sqlstmt = @sqlstmt + '	 and (stl_id = ' + convert(varchar(20),@@stl_id) + ') '

		if @@filter2 <> '' 
			set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

	end else begin

			set @sqlstmt = 

		 'select top 50
						 stl_id,
						 stl_codigo			   as [Codigo],
						 stl_nroLote   	   as [Nro. Lote],
						 stl_fecha         as [Fecha],
             case 
									when stl_fechaVto <> ''19000101'' then stl_fechaVto
                  else                                   null
             end               as [Vto.],
						 pr_nombrecompra   as [Artículo]

			from StockLote stl inner join Producto pr on stl.pr_id = pr.pr_id
			where (stl_codigo like ''%'+@@filter+'%'' or stl_nrolote like ''%'+@@filter+'%'' or ''' + @@filter + ''' = '''') '

			if @@filter2 <> '' begin
				set @@filter2 = 'stl.' + @@filter2
				set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'
			end

	end

	exec(@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

