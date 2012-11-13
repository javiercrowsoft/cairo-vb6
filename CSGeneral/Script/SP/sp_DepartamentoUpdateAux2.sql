if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentoUpdateAux2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentoUpdateAux2]

/*


 select * from departamento

 sp_DepartamentoUpdateAux2 47,1

*/

go
create procedure sp_DepartamentoUpdateAux2 (
	@@pre_id		 int,
  @@bHeredar   tinyint,
  @@modifico   int
)
as

begin

	set nocount on

  declare @per_id       int
  declare @per_id_padre int
  declare @us_id        int
  declare @rol_id       int
  declare @bPermisoHeredado tinyint

  declare c_DptoPermiso insensitive cursor for 
  select per_id, rol_id, us_id, per_id_padre 
  from permiso where pre_id = @@pre_id
  open c_DptoPermiso

  fetch next from c_DptoPermiso into @per_id, @rol_id, @us_id, @per_id_padre 
  while @@fetch_status = 0
  begin

    -- Si tiene un padre voy a borrar el permiso padre
    -- para regenerar todos los permisos de ese departamento.
    --
    -- Esto es por que si el permiso es heredado entre departamentos
    -- tengo que ir hasta el departamento que posee el permiso genuino
    -- y regenerar a partir de ese permiso. Si el departamento que estoy
    -- editando continua siendo hijo del departamento dueño del permiso
    -- original, se le concedera permiso a este departamento, en caso
    -- contrario, el permiso desaparece y esta bien que asi suceda ya
    -- que la relacion de herencia entre departamentos que genero el permiso
    -- ya no existe.
    -- Por ejemplo si tenemos los departamentos A, B, C Y D donde A padre de B y D, y 
    -- B padre de C, y sobre A hay un permiso x que se propaga sobre sus decendientes
    -- tenemos: 
    --                   A - x
    --            B - x'      D - x'
    --            C - x''
    -- Si modificamos B y decimos que A ya no pertence a B entonces
    -- tenemos:
    --                  A - x
    --            B          D - x'
    --            C
    --
    if @per_id_padre is not null begin 
      set @per_id = @per_id_padre
  
      -- Obtengo los datos del permiso padre
      --
      select @@pre_id = pre_id, @us_id = us_id, @rol_id = rol_id from Permiso where per_id = @per_id
  
      -- El permiso es heredado
      --
      set @bPermisoHeredado = 1
    end
    else 
      set @bPermisoHeredado = 0
  
    -- Esto borra el permiso y todos los permisos hijos de este
    -- departamento
    --
    exec sp_permisoDelete @per_id
  
    -- Agrego un nuevo permiso igual al que borre
    --
    exec sp_dbgetnewid 'Permiso', 'per_id', @per_id out, 0
  
    insert into Permiso (per_id, pre_id, us_id, rol_id, per_id_padre, modifico) 
                 values (@per_id, @@pre_id, @us_id, @rol_id, null, @@modifico)
  
    -- Si debo heredar permisos propios
    -- o si el permiso es heredado
    --
    if @bPermisoHeredado <> 0 or @@bHeredar <> 0 begin
  
      exec sp_DepartamentoApplySecSubDpto @per_id
    end

    fetch next from c_DptoPermiso into @per_id, @rol_id, @us_id, @per_id_padre 
  end

  close c_DptoPermiso
  deallocate c_DptoPermiso

end
GO