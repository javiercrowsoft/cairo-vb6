if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DepositoLogicoHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepositoLogicoHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 update depositologico set emp_id = 1 where emp_id is null

 sp_depositologicohelp '',0,0,'depl_esTemp <> 0'
 sp_DepositoLogicoHelp 4,1,0,'',0,0,'depl_estemp<>1' -- update usuario set us_deposito = 1 where us_id = 1

*/

create procedure sp_DepositoLogicoHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@depl_id         int           = 0,
	@@filter2         varchar(255)  = ''
)
as

begin

	set nocount on

	set @@filter = replace(@@filter,'''','''''')
	
	declare @sqlstmt varchar(5000)
  declare @bFilterXEmpresa tinyint

	if charindex('{emp_id=0}',@@filter2)<>0 begin
					set @@filter2 = replace(@@filter2,'{emp_id=0}','')
					set @bFilterXEmpresa = 0
	end
	else		set @bFilterXEmpresa = 1

	if charindex('emp_id = ',@@filter2)<>0
					set @bFilterXEmpresa = 0


	/*------------------------------------------
	Este codigo es el que se asigna a @permiso. 
	Se asigna en una sola linea para que sea mas rapida la sentencia

	*/
	declare @strUsId varchar(10)
	declare @permisos varchar(500)

	set @strUsId  = convert(varchar,@@us_id)
	
	-- Si el usuario no tiene acceso irestricto sobre los depositos
	--
	if not exists(select * from Usuario where us_deposito <> 0 and us_id = @@us_id) begin
		set @permisos = ' and exists(select * from UsuarioDepositoLogico '
	                            + 'where depl_id = depl.depl_id and us_id = ' + @strUsId + ')'
	end else 
		set @permisos = ''
	
	/*-----------------------------------------*/


	if @@check <> 0 begin
	
		set @sqlstmt = 						'select depl_id, '
		set @sqlstmt = @sqlstmt + '				depl_nombre			as [Nombre], '
		set @sqlstmt = @sqlstmt + '				depl_codigo   	as [Codigo] '

		set @sqlstmt = @sqlstmt + 'from DepositoLogico depl '

		set @sqlstmt = @sqlstmt + 'where (depl_id > 0) and '
                            + '(depl_nombre = '''+@@filter+''' or depl_codigo = '''+@@filter+''') '

		if @@depl_id <> 0
			set @sqlstmt = @sqlstmt + '	 and (depl_id = ' + convert(varchar(20),@@depl_id) + ') '

		if @@emp_id <> 0 and @bFilterXEmpresa <> 0 and @@bForAbm = 0
			set @sqlstmt = @sqlstmt + '	 and (emp_id = ' + convert(varchar(20),@@emp_id) + ' or emp_id is null) '

	  if @@bForAbm = 0 set @sqlstmt = @sqlstmt + '  and activo <> 0 ' 

		if @@filter2 <> '' 
			set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

	end else begin

			set @sqlstmt =            'select depl_id, '
	    set @sqlstmt = @sqlstmt + '       depl_nombre   as Nombre, '
	    set @sqlstmt = @sqlstmt + '       depl_codigo   as Codigo '
			set @sqlstmt = @sqlstmt + 'from DepositoLogico depl '

			set @sqlstmt = @sqlstmt + 'where (depl_id > 0 ) and '+
                                '(depl_codigo like ''%'+@@filter+'%'' or depl_nombre like ''%'+@@filter+'%'' or ''' + @@filter + ''' = '''') '

			if @@emp_id <> 0 and @bFilterXEmpresa <> 0 and @@bForAbm = 0
				set @sqlstmt = @sqlstmt + '	 and (emp_id = ' + convert(varchar(20),@@emp_id) + ' or emp_id is null) '

	  	if @@bForAbm = 0 set @sqlstmt = @sqlstmt + '  and activo <> 0 ' 

			if @@filter2 <> '' 
				set @sqlstmt = @sqlstmt + '  and (' + @@filter2 + ')'

	end		

	if @@bForAbm = 0 set @sqlstmt = @sqlstmt + @permisos

	exec(@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

