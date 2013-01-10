if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_si_getProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_si_getProveedor]
GO

create procedure sp_si_getProveedor (
  @@id         varchar(255),
  @@bIsCuit   smallint

)as 
begin

  set nocount on

  if @@bIsCuit <> 0 begin

    select prov_id from proveedor where replace(prov_cuit,'-','') = replace(@@id,'-','') and replace(@@id,'-','') <> ''

  end else begin

    select prov_id from proveedor where prov_codigo = @@id and @@id <> ''

  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
