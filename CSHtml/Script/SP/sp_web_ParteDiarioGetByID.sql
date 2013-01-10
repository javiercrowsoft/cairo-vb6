if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioGetByID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioGetByID]

/*
select * from partediario
 sp_web_ParteDiarioGetByID 181,1

*/

go
create procedure sp_web_ParteDiarioGetByID (

  @@ptd_id int,
  @@us_id  int

)
as

begin

  set nocount on

--/////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////
--
--  Un parte diario
--
--/////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////

    declare @sqlstmt varchar(5000)
    declare @ptd_listausuarios varchar(5000)
    declare @us_nombre varchar(255)

    select @ptd_listausuarios = ptd_listausuariosid from ParteDiario where ptd_id = @@ptd_id

    declare @clientId datetime
    set @clientId = getdate()
    exec sp_strStringToTable @clientId, @ptd_listausuarios, ', '

    declare c_usuarios insensitive cursor for
     select us_nombre from usuario where us_id in (select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @clientId)
    
    open c_usuarios

    set @ptd_listausuarios = ''

    fetch next from c_usuarios into @us_nombre
    while @@fetch_status=0 begin

      set @ptd_listausuarios = @ptd_listausuarios + @us_nombre + ', '
      
      fetch next from c_usuarios into @us_nombre
    end

    close c_usuarios
    deallocate c_usuarios

    exec (@sqlstmt)

    if len(@ptd_listausuarios) > 0 set @ptd_listausuarios = substring(@ptd_listausuarios,1,len(@ptd_listausuarios)-1)

    declare @bCanEdit tinyint

    if exists(select ptd_id from ParteDiario 
              where (
                    us_id_responsable = @@us_id  ------------------------------------------- Soy el responsable                                        
                                                 ------------------------------------------- Soy el asignador
                or  (us_id_asignador = @@us_id and (ptdt_id not in (100001,100002,100003,100004) or ptd_cumplida = 1))
                or  exists (select dpto_id from Departamento ------------------------------- Tengo permiso de asignar
                            where                                                         -- tareas sobre el departamento
                                  dpto_id = ParteDiario.dpto_id
                              and exists (select per_id from permiso 
                                          where 
                                                pre_id = pre_id_asignartareas
                                            and (    us_id  = @@us_id                     -- Permiso sobre el usuario
                                                  or exists(select us_id from UsuarioRol  -- Permiso sobre un rol
                                                            where rol_id = permiso.rol_id 
                                                              and us_id = @@us_id)
                                                )
                                          )
                            )
                    )
                and ptd_id = @@ptd_id
              )
          set @bCanEdit = 1
    else  set @bCanEdit = 0

    select
          p.*,
          @bCanEdit           as bCanEdit,
          @ptd_listausuarios  as ptd_listausuarios,
          ptdt_nombre,
          u1.us_nombre        as us_asignador,
          u2.us_nombre        as us_responsable,
          cli_nombre,
          prov_nombre,
          cont_nombre,
          tarest_nombre,
          prio_nombre,
          case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
          dpto_nombre,
          ven_nombre,
          suc_nombre
          
    from 
          ParteDiario p inner join partediariotipo pt on p.ptdt_id        = pt.ptdt_id
                        left  join usuario u1     on p.us_id_asignador     = u1.us_id
                        left  join usuario u2     on p.us_id_responsable   = u2.us_id
                        left  join cliente c      on p.cli_id              = c.cli_id
                        left  join proveedor pr   on p.prov_id              = pr.prov_id
                        left  join contacto ct     on p.cont_id              = ct.cont_id
                        left  join tareaestado t   on p.tarest_id            = t.tarest_id
                        left  join prioridad pri  on p.prio_id              = pri.prio_id
                        left  join legajo l       on p.lgj_id               = l.lgj_id
                        left  join departamento d on p.dpto_id             = d.dpto_id
                        left  join vendedor v     on p.ven_id             = v.ven_id
                        left  join sucursal s     on p.suc_id             = s.suc_id            
                        
    where
  
        ptd_id = @@ptd_id
  
    order by
  
      ptd_fechaini, ptd_fechafin

end