-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Parte diario
---------------------------------------------------------------------*/
/*

DC_CSC_ENV_0030 3

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_ENV_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_ENV_0030]

-- DC_CSC_ENV_0030 0

go
create procedure DC_CSC_ENV_0030 (

	@@lgj_id			int

)as 

begin

  select 
        partediario.*,
        usuario.us_nombre as responsable,
        us.us_nombre      as asignador,
        tareaestado.tarest_nombre,
        contacto.cont_nombre,
        prioridad.prio_nombre,
        legajo.lgj_titulo,
        legajo.lgj_codigo,
        cliente.cli_nombre,
        departamento.dpto_nombre,
        proveedor.prov_nombre
  from 

      partediario left join usuario     on partediario.us_id_responsable = usuario.us_id
                  left join usuario us  on partediario.us_id_asignador   = us.us_id
                  left join tareaestado on partediario.tarest_id         = tareaestado.tarest_id
                  left join contacto     on partediario.cont_id           = contacto.cont_id
                  left join prioridad    on partediario.prio_id           = prioridad.prio_id
                  left join legajo       on partediario.lgj_id            = legajo.lgj_id
                  left join cliente      on partediario.cli_id            = cliente.cli_id
                  left join departamento on partediario.dpto_id           = departamento.dpto_id
                  left join proveedor    on partediario.prov_id           = proveedor.prov_id

end
go

