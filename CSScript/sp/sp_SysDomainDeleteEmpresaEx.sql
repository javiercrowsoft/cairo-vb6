if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SysDomainDeleteEmpresaEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SysDomainDeleteEmpresaEx]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

  select * from basedatos

  sp_SysDomainDeleteEmpresaEx 7

sp_SysDomainDeleteEmpresaEx 
                        1,
                        'Cairo',
                        'souyirozeta',
                        'Cairo',
                        'sa',
                        0,
                        ''

select * from empresa

sp_SysDomainDeleteEmpresaEx 1,'1,3'


*/
create procedure sp_SysDomainDeleteEmpresaEx (
  @@bd_id         int,
  @@EmpId         varchar(255)
)
as
begin
  set nocount on

  if len(@@EmpId)>0 begin

    declare @sqlstmt varchar(1000) 
    set @sqlstmt = 'delete Empresa where bd_id = ' + convert(varchar(20),@@bd_id) + ' and emp_id not in ('+@@EmpId+')'
    exec (@sqlstmt)

  end

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

