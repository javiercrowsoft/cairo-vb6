if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_productoNumeroSerieHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoNumeroSerieHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_productoNumeroSerieHelp 1,'300%',0,0,596

 sp_productoNumeroSerieHelp 3,'',0,0,1 

  select * from usuario where us_nombre like '%ahidal%'

*/
create procedure sp_productoNumeroSerieHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(8000)  = '',
  @@check            smallint        = 0,
  @@prns_id         int            = 0,
  @@filter2         varchar(8000)  = ''
)
as
begin

  set nocount on
  
  set @@filter = replace(@@filter,'''','''''')

  declare @sqlstmt varchar(5000)

  set @@filter2 = replace(@@filter2,'(pr_id','(prns.pr_id')
  set @@filter2 = replace(@@filter2,' pr_id',' prns.pr_id')

  if substring(@@filter2,1,8)='pr_id = ' begin
    set @@filter2 = 'prns.pr_id = ' + substring(@@filter2,9,len(@@filter2))
  end

  if @@check <> 0 begin

    set @sqlstmt =             'select prns_id, '
    set @sqlstmt = @sqlstmt +        'prns_codigo as [Código], '
    set @sqlstmt = @sqlstmt +        'pr_nombreCompra  as [Artículo] '

    set @sqlstmt = @sqlstmt + 'from ProductoNumeroSerie prns inner join Producto pr on prns.pr_id = pr.pr_id '

    set @sqlstmt = @sqlstmt + 'where (prns_codigo = '''+@@filter+''') '

    if @@prns_id <> 0
      set @sqlstmt = @sqlstmt + '   and (prns_id = ' + convert(varchar(20),@@prns_id) + ') '

    if @@filter2 <> '' 
      set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

  end else begin

    set @sqlstmt =             'select top 300 prns_id, '
    set @sqlstmt = @sqlstmt +        'prns_codigo  as [Código], '
    set @sqlstmt = @sqlstmt +        'prns_codigo2 as [Código2], '
    set @sqlstmt = @sqlstmt +        'prns_codigo3 as [Código3], '
    set @sqlstmt = @sqlstmt +        'pr_nombreCompra  as [Artículo], '
    set @sqlstmt = @sqlstmt +        'prns_descrip    as [Observ.], '
    set @sqlstmt = @sqlstmt +        ' '''+ @@filter + ''' as col_aux '

    set @sqlstmt = @sqlstmt + 'from ProductoNumeroSerie prns inner join Producto pr on prns.pr_id = pr.pr_id '
    set @sqlstmt = @sqlstmt + 'where '

    if left(@@filter,2)<>'@@' begin

      set @sqlstmt = @sqlstmt + 
                             '(prns_codigo like ''%'+@@filter 
                            + '%'' or prns_codigo2 like ''%'+@@filter 
                            +'%'' or prns_codigo3 like ''%'+@@filter
                            +'%'' or pr_nombreCompra like ''%'+@@filter
                            +'%'' or prns_descrip like ''%'+@@filter
                            +'%'' or ''' + @@filter + ''' = '''') '
    end else begin
      set @sqlstmt = @sqlstmt + 'prns_codigo = ''' + substring(@@filter,3,len(@@filter)) + ''''
    end

    if @@filter2 <> '' 
      set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

  end    

  exec(@sqlstmt)
  

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

