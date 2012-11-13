if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_DepartamentoCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_DepartamentoCliente]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_DepartamentoCliente.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*
select * from documento where doct_id = 1
select * from facturaventa where doc_id = 29
MUR_DepartamentoCliente 106,2
select * from departamento order by 2
select * from usuariodepartamento where dpto_id = 95
select * from usuario where us_id = 597
select * from cliente where cli_codigo > '300000' and cli_codigo < '300010'

select dpto_nombre from departamento where dpto_id in (
select dpto_id from departamentocliente where cli_id = 35641)

*/
create Procedure MUR_DepartamentoCliente (
	@@dpto_id          int,
  @@cli_codigo_min   int,
  @@cli_codigo_max   int
)
as
begin

  set nocount on

  declare @dptocli_id int
  declare @cli_id     int

	create table #tcli (cli_id int not null,cli_codigo varchar(255))
	insert into #tcli (cli_id,cli_codigo) select cli_id,cli_codigo from cliente where isnumeric(cli_codigo)<>0

  declare c_cli insensitive cursor for 
  select cli_id from #tcli 
  where convert(int,cli_codigo) >= @@cli_codigo_min
    and convert(int,cli_codigo) <= @@cli_codigo_max
    and not exists(select cli_id from DepartamentoCliente where cli_id = #tcli.cli_id and dpto_id = @@dpto_id)

  open c_cli
  fetch next from c_cli into @cli_id
  while @@fetch_status = 0 begin

    exec sp_dbgetnewid 'DepartamentoCliente','dptocli_id',@dptocli_id out, 0
    insert into DepartamentoCliente (dptocli_id, cli_id, dpto_id)
                              values(@dptocli_id, @cli_id, @@dpto_id)
    fetch next from c_cli into @cli_id
  end
  close c_cli
  deallocate c_cli

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

