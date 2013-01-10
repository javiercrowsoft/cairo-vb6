if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_DepartamentoCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_DepartamentoCliente]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_DepartamentoCliente.sql
' Objetivo: Obtiene los textos asociados a una factura de venta para imprimir el formulario
'           de exportacion.
'-----------------------------------------------------------------------------------------
*/

/*
select * from documento where doct_id = 1
select * from facturaventa where doc_id = 29
MUR_DepartamentoCliente 106,2

*/
create Procedure MUR_DepartamentoCliente (
  @@dpto_id          int,
  @@cli_codigo_min   varchar(50),
  @@cli_codigo_max   varchar(50)
)
as
begin

  set nocount on

  declare @dptocli_id int
  declare @cli_codigo varchar(50)
  declare @cli_id     int

  declare c_cli insensitive cursor for 
  select cli_id, cli_codigo from cliente 
  where cli_codigo >= @@cli_codigo_min
    and cli_codigo <= @@cli_codigo_max
    and not exists(select cli_id from DepartamentoCliente where cli_id = cliente.cli_id and dpto_id = @@dpto_id)

  open c_cli
  fetch next from c_cli into @cli_id, @cli_codigo
  while @@fetch_status = 0 begin

    if isnumeric(@cli_codigo)<>0 begin
      exec sp_dbgetnewid 'DepartamentoCliente','dptocli_id',@dptocli_id out, 0
      insert into DepartamentoCliente (dptocli_id, cli_id, dpto_id)
                                values(@dptocli_id, @cli_id, @@dpto_id)
    end
    fetch next from c_cli into @cli_id, @cli_codigo
  end
  close c_cli
  deallocate c_cli

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

