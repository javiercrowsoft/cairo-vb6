if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_pedidoVentaSaveGetCliIdCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_pedidoVentaSaveGetCliIdCliente]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_pedidoVentaSaveGetCliIdCliente  3

create procedure sp_srv_cvxi_pedidoVentaSaveGetCliIdCliente (
  @@cmie_id         int,
  @@cmi_id          int,
  @@cli_id          int out
)
as

set nocount on

begin

  exec sp_srv_cvxi_pedidoVentaSaveGetCliIdCairo @@cmie_id, @@cmi_id, @@cli_id out

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



