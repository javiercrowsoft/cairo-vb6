if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProyectoHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProyectoHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

	sp_proyectohelp 1,1,0, '',-1,0,'cli_id = 39'

*/
create procedure sp_ProyectoHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@proy_id         int						= 0,
  @@filteraux       varchar(255)  = ''
)
as
begin

	set nocount on
	
	set @@filter = replace(@@filter,'''','''''')

		declare @sqlstmt varchar(8000)

		if @@check <> 0 begin

			set @sqlstmt = 

		 'select	proy_id,
							proy_nombre				as [Nombre],
							proy_codigo   		as [Codigo]
	
			from Proyecto
	
			where (proy_nombre = '''+convert(varchar(255),@@filter)+''' or proy_codigo = '''+convert(varchar(255),@@filter)+''')
		    and activo <> 0 ' 

			if @@proy_id <> 0 begin
				set @sqlstmt = @sqlstmt + ' and proy_id = ' + convert(varchar(255),@@proy_id) + ' '
			end

			set @sqlstmt = @sqlstmt +

			 'and (			'+convert(varchar(255),@@bForAbm)+' <> 0 
							or (exists (select * from Permiso 
                          where (	 	 pre_id_addTarea   	= pre_id
																	or pre_id_editTarea		= pre_id
																	or pre_id_editTareaP	= pre_id
																	or pre_id_editTareaD	= pre_id
																	or pre_id_addHora			= pre_id
																	or pre_id_editHora		= pre_id
																)
														and (		 us_id  = '+convert(varchar(255),@@us_id)+' 
																	or exists(select * from usuariorol where rol_id = Permiso.rol_id and us_id = '+convert(varchar(255),@@us_id)+')
																)
                         )
									)
						)'
	
		end else begin

				set @sqlstmt = 
	
			 'select top 50
							proy_id,
							proy_nombre				as [Nombre],
							proy_codigo   		as [Codigo]
	
				from Proyecto
		
					where (proy_codigo like ''%'+convert(varchar(255),@@filter)+'%'' or proy_nombre like ''%'+convert(varchar(255),@@filter)+'%'' 
	                or '''+convert(varchar(255),@@filter)+''' = '''')
					and (			'+convert(varchar(255),@@bForAbm)+' <> 0 
								or (exists (select * from Permiso 
	                          where (	 	 pre_id_addTarea 			= pre_id
																		or pre_id_editTarea			= pre_id
																		or pre_id_editTareaP		= pre_id
																		or pre_id_editTareaD		= pre_id
																		or pre_id_addHora				= pre_id
																		or pre_id_editHora			= pre_id
																	)
															and (		 us_id  = '+convert(varchar(255),@@us_id)+'
																		or exists(select * from usuariorol where rol_id = Permiso.rol_id and us_id = '+convert(varchar(255),@@us_id)+')
																	)
	                         )
										)
							)'

		end

		if @@filteraux <> '' set @sqlstmt = @sqlstmt + ' and (' + @@filteraux + ')'

		exec(@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

