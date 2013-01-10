if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_rv_getCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_rv_getCliente]
GO

create procedure sp_rv_getCliente (
  @@id         varchar(255),
  @@bIsCuit   smallint

)as 
begin

  set nocount on

  if @@bIsCuit <> 0 begin

    select cli_id from cliente where replace(cli_cuit,'-','') = replace(@@id,'-','') and replace(@@id,'-','') <> ''

  end else begin

    select cli_id, cli_nombre from cliente where cli_codigo = @@id and @@id <> ''

  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
