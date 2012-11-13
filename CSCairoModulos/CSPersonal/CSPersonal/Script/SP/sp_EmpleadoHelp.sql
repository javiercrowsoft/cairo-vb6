if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_EmpleadoHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_EmpleadoHelp 3,'',0,0,1 

 select * from empleado

*/
create procedure sp_EmpleadoHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@em_id          	int           = 0,
	@@filter2         varchar(255)  = ''
)
as
begin

	set nocount on

	set @@filter = replace(@@filter,'''','''''')
	
	declare @sqlstmt      varchar(5000)
  
	if @@check <> 0 begin
		set @sqlstmt = '
		select 	em_id,
						em_apellido + '', '' + em_nombre
														as [Nombre],
						em_codigo   		as [Codigo]

		from Empleado

		where (em_apellido + '', '' + em_nombre = '''+@@filter+''' or em_codigo = '''+@@filter+''')
			and (em_id = '+convert(varchar(50),@@em_id)+' or '+convert(varchar(50),@@em_id)+'=0)
			and ('+convert(varchar(50),@@bForAbm)+' <> 0 or activo <> 0)'

	end else begin

		set @sqlstmt = '  	
		select top 50
					 em_id,
           em_apellido + '', '' + em_nombre        
														as Nombre,
           em_codigo        as Codigo,
					 em_dni           as DNI,
					 em_legajo        as Legajo,
           em_cuil          as CUIL,
					 em_libreta				as Libreta,
					 em_tel						as Telefono
		from Empleado 

		where (em_codigo like ''%'+@@filter+'%'' or em_nombre like ''%'+@@filter+'%'' 
            or em_apellido like ''%'+@@filter+'%'' 
            or em_cuil like ''%'+@@filter+'%'' 
            or em_dni like ''%'+@@filter+'%'' 
            or em_legajo like ''%'+@@filter+'%'' 
            or em_libreta like ''%'+@@filter+'%'' 
            or '''+@@filter+''' = '''')
		and ('+convert(varchar(50),@@bForAbm)+' <> 0 or activo <> 0)'

	end		

	if @@filter2 <> '' set @sqlstmt = @sqlstmt + ' and (' + @@filter2 + ')'

	--print (@sqlstmt)
	exec (@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

