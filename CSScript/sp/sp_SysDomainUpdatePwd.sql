if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SysDomainUpdatePwd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SysDomainUpdatePwd]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

  select * from basedatos

  sp_SysDomainUpdatePwd 7

*/
create procedure sp_SysDomainUpdatePwd (
  @@pwd varchar(255)
)
as
begin
  set nocount on

  if exists(select * from sistema where si_clave = 'Password_Domain') begin

    update sistema set si_valor = @@pwd where si_clave = 'Password_Domain'

  end else begin

    insert sistema (si_clave,si_valor) values ('Password_Domain',@@pwd)

  end

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

