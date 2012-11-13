if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SysModuloGetEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SysModuloGetEx]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

	select * from usuario

  sp_SysModuloGetEx 38

*/
create procedure sp_SysModuloGetEx (
	@@us_id            int
)
as
begin
	set nocount on

	delete sysModuloUser where us_id = @@us_id

	insert into sysModuloUser (sysm_id, us_id)

	select distinct s.sysm_id, @@us_id from sysModulo s inner join permiso p on s.pre_id = p.pre_id
  
	where (				exists (select per_id from permiso where per_id = p.per_id and us_id = @@us_id)
        	or		
								exists (select per_id from permiso inner join usuariorol on permiso.rol_id = usuariorol.rol_id
                                      where 			per_id = p.per_id
																						and		usuariorol.us_id = @@us_id)
				)

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

