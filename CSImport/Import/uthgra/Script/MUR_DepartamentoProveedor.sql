if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_DepartamentoProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_DepartamentoProveedor]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_DepartamentoProveedor.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_DepartamentoProveedor (
  @@dpto_id          int,
  @@prov_codigo_min   int,
  @@prov_codigo_max   int
)
as
begin

  set nocount on

  declare @dptoprov_id int
  declare @prov_id     int

  create table #tprov (prov_id int not null, prov_codigo varchar(255))
  insert into #tprov (prov_id,prov_codigo) select prov_id,prov_codigo from Proveedor where isnumeric(prov_codigo)<>0

  declare c_prov insensitive cursor for 
  select prov_id from #tprov 
  where convert(int,prov_codigo) >= @@prov_codigo_min
    and convert(int,prov_codigo) <= @@prov_codigo_max
    and not exists(select prov_id from DepartamentoProveedor where prov_id = #tprov.prov_id and dpto_id = @@dpto_id)

  open c_prov
  fetch next from c_prov into @prov_id
  while @@fetch_status = 0 begin

    exec sp_dbgetnewid 'DepartamentoProveedor','dptoprov_id',@dptoprov_id out, 0
    insert into DepartamentoProveedor (dptoprov_id, prov_id, dpto_id)
                              values(@dptoprov_id, @prov_id, @@dpto_id)
    fetch next from c_prov into @prov_id
  end
  close c_prov
  deallocate c_prov

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

