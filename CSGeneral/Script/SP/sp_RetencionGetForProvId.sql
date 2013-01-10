if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RetencionGetForProvId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RetencionGetForProvId]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*
 exec sp_RetencionGetForProvId 2,1
*/

create procedure sp_RetencionGetForProvId (
  @@prov_id        int,
  @@emp_id        int,
  @@fecha         datetime
)
as

set nocount on

begin

  -------------------------------------------------------------
  -- Retenciones explicitas en proveedores 
  --

  if exists(select *
            from  ProveedorRetencion provret inner join Retencion ret on provret.ret_id = ret.ret_id
            where prov_id = @@prov_id)
  begin

    select  provret.ret_id,
            ret_nombre
  
    from  ProveedorRetencion provret inner join Retencion ret on provret.ret_id = ret.ret_id
  
    where prov_id = @@prov_id
      and @@fecha between provret_desde and provret_hasta

  end else begin

    -------------------------------------------------------------
    -- Retenciones por Configuracion General
    --
  
    create table #tmp_retencion (ret_id int)
  
    insert into #tmp_retencion (ret_id)
  
      select convert(int,cfg_valor)
      from configuracion 
      where emp_id = @@emp_id
        and cfg_grupo = 'Tesoreria-General'
        and cfg_aspecto = 'Retencion'
        and isnumeric(cfg_valor) <> 0

    -------------------------------------------------------------
    -- Retenciones por Configuracion General
    --
    select  ret.ret_id,
            ret.ret_nombre
  
    from Retencion ret
    where exists(select * from #tmp_retencion where ret_id = ret.ret_id)

  end

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go