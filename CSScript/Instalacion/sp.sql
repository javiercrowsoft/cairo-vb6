if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SPS_IDS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SPS_IDS]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbBajarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbBajarRama]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbBorrarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbBorrarRama]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbCopiarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbCopiarRama]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbCopyFolder]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbCopyFolder]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbCortarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbCortarRama]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbGetDecendencia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbGetDecendencia]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_ArbSubirRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbSubirRama]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_DBGetNewId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_DBGetNewId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_RolDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_RolDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_SecGetPermisosXRol]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetPermisosXRol]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_SecGetPermisosXUsuario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetPermisosXUsuario]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_SecGetRolesXUsuario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetRolesXUsuario]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SP_UsDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_UsDelete]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ArbGetAllHojas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetAllHojas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ArbGetArboles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetArboles]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ArbGetHojas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetHojas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ArbGetRamas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetRamas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_col]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_col]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_columnas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_columnas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_scriptor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_scriptor]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_strGetBusqueda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strGetBusqueda]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_strGetRealName]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strGetRealName]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_strSetPrefix]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strSetPrefix]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_strStringToTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strStringToTable]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create procedure SPS_IDS(
    @@IDs integer
) as 
select   pr_nombreventa, c1.cue_nombre CuentaVenta, c2.cue_nombre CuentaCompra, u1.un_nombre UnidadCompra,u2.un_nombre UnidadVenta,
  u3.un_nombre UnidadStock ,ti1.ti_nombre   

from   producto, cuenta c1, cuenta c2 , unidad u1, unidad u2 , unidad u3, tasaimpositiva ti1

where   producto.cue_id_venta *= c1.cue_id and
  producto.cue_id_compra *= c2.cue_id and 
  producto.un_id_compra *=u1.un_id and
  producto.un_id_venta *=u2.un_id and
  producto.un_id_stock *=u3.un_id and
  producto.ti_id_ivaricompra *=ti1.ti_id and
  producto.pr_id=@@ids
 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure SP_ArbBajarRama (
  @@ram_id int
)
as

set nocount on

declare @ultimo smallint

select @ultimo = max(ram_orden) from rama where ram_id_padre = (select ram_id_padre from rama where ram_id = @@ram_id) 

declare @ram_orden smallint

select @ram_orden = ram_orden from rama where ram_id = @@ram_id

if @ram_orden = @ultimo return

update rama set ram_orden = ram_orden - 1 

where ram_id_padre = (select ram_id_padre from rama where ram_id = @@ram_id) 

and ram_orden = @ram_orden + 1

update rama set ram_orden = ram_orden +1 where ram_id = @@ram_id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
  creado:    15/05/2000
  Proposito:  Devuelve toda la decendencia de una rama incluyendo a la misma rama

  insert into exec:  - SP_ArbBorrarRama

*/
create procedure SP_ArbBorrarRama (
  @@ram_id int
)
as

set nocount on

create table #t_ramasABorrar(
ram_id int not null
)

begin transaction

if @@ram_id = 0 return

-- si la rama es raiz tengo que borrar el arbol
declare @arb_id int

-- para actulizar el orden
declare @ram_orden smallint
declare @ram_id_padre int

select @arb_id = arb_id, @ram_orden = ram_orden, @ram_id_padre = ram_id_padre from rama where ram_id = @@ram_id and ram_id_padre = 0

-- obtengo la decendencia
insert into #t_ramasABorrar exec SP_ArbGetDecendencia @@ram_id

-- primero las hojas
delete Hoja from #t_ramasABorrar where Hoja.ram_id = #t_ramasABorrar.ram_id

if @@error <> 0 goto ControlError

-- ahora las ramas
delete Rama from #t_ramasABorrar where Rama.ram_id = #t_ramasABorrar.ram_id

if @@error <> 0 goto ControlError

-- si era una raiz borro el arbol
if @arb_id is not null 
  delete Arbol where arb_id = @arb_id
else
-- sino, tengo que actualizar el orden de los que estaban bajo esta rama  
  update rama set ram_orden = ram_orden -1 where ram_id_padre = @ram_id_padre and ram_orden < @ram_orden

if @@error <> 0 goto ControlError

commit transaction
return

ControlError:
rollback transaction

raiserror ('No se pude borrar la rama',
  
     16, 1)



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
  creado:    15/05/2000
  Proposito:  Copia una rama y toda su decendencia en otra rama.
*/
create procedure SP_ArbCopiarRama (
  @@ram_id_ToCopy  int,
  @@ram_id_ToPaste int,
  @@solo_los_hijos smallint
)
as

set nocount on

if @@ram_id_ToCopy = 0 return
if @@ram_id_ToPaste = 0 return

declare @ram_id    int
declare @new_ram_id   int
declare @hoja_id  int
declare @new_hoja_id  int
declare @ram_id_padre  int
declare @arb_id    int

select @arb_id = arb_id from rama where ram_id = @@ram_id_ToPaste

create table #t_ramasACopiar(
ram_id int not null
)
create table #t_rama_ramaNew(
ram_id     int not null,
ram_id_new   int not null
)


declare @incluir_ram_id_to_copy int

if @@solo_los_hijos <> 0 set @incluir_ram_id_to_copy =0
else       set @incluir_ram_id_to_copy =1

-- Obtengo la decendencia
insert into #t_ramasACopiar exec SP_ArbGetDecendencia @@ram_id_ToCopy, @incluir_ram_id_to_copy 


-- Creo un cursor para recorrer cada rama e ir copiandola
declare RamasACopiar insensitive cursor for select ram_id from #t_ramasACopiar

open RamasACopiar

fetch next from RamasACopiar into @ram_id

while @@fetch_status = 0
begin

  -- si esta es la rama principal de la copia, su padre tiene que ser la rama en la que estoy pegando
  if @ram_id = @@ram_id_ToCopy
    set @ram_id_padre = @@ram_id_ToPaste
  else
  begin
    -- Obtengo el padre de la rama que estoy copiando
    select @ram_id_padre = ram_id_padre from rama where ram_id = @ram_id


    -- Si pedi copiar solo los hijos y la rama que estoy copiando es hija directa, entonces su padre es la rama en la que estoy pegando
    if @@solo_los_hijos <> 0 and @ram_id_padre = @@ram_id_ToCopy
    begin
      set @ram_id_padre = @@ram_id_ToPaste
    end
    else
    begin
      -- Obtengo el nuevo padre
      select @ram_id_padre = ram_id_new from rama,#t_rama_ramaNew where rama.ram_id = #t_rama_ramaNew.ram_id and rama.ram_id = @ram_id_padre
    end
  end

  -- Por cada rama obtengo un id nuevo
  exec SP_DBGetNewId 'rama','ram_id',@new_ram_id output

  insert into rama (ram_id, ram_nombre, arb_id, modificado, creado, modifico, ram_id_padre) 
  select @new_ram_id, ram_nombre, @arb_id, getdate(), creado, modifico, @ram_id_padre from rama where ram_id = @ram_id

  insert into #t_rama_ramaNew (ram_id,ram_id_new) values(@ram_id,@new_ram_id)


  -- Creo un cursor para recorrer cada una de las hojas e insertarlas
  declare HojasACopiar insensitive cursor for select hoja_id from Hoja where ram_id = @ram_id

  open HojasACopiar
  
  fetch next from HojasACopiar into @hoja_id

  -- Ahora sus hojas
  while @@fetch_status = 0
  begin

    -- Por cada hoja obtengo un id nuevo
    exec SP_DBGetNewId 'hoja','hoja_id',@new_hoja_id output

    insert into hoja (hoja_id, id, modificado, creado, modifico, ram_id, arb_id) 
    select @new_hoja_id, id, getdate(), creado, modifico, @new_ram_id, @arb_id from hoja where hoja_id = @hoja_id

    fetch next from HojasACopiar into @hoja_id
  end

  close HojasACopiar
  deallocate HojasACopiar

  fetch next from RamasACopiar into @ram_id  
end

close RamasACopiar

deallocate RamasACopiar




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*
  creado:    15/05/2000
  Proposito:  Devuelve toda la decendencia de una rama incluyendo a la misma rama

  insert into exec:  - SP_ArbCopyFolder

*/
create procedure SP_ArbCopyFolder (
  @@ram_id int
)
as

set nocount on

create table #t_rama(
ram_id int not null
)

if @@ram_id = 0 return

declare @tot2 int
declare @tot1 int
declare @n    int

select @tot1 = -1
select @tot2 =  0
select @n    =  1

insert into #t_rama (ram_id,n) values(@@ram_id,0) 

while @tot1 < @tot2
begin
  select @tot1 = @tot2
  insert into #t_rama (ram_id,n) select r.ram_id,@n from rama r ,#t_rama t 
    where r.ram_id_padre = t.ram_id and t.n = @n - 1

  select @tot2 = (select count(*) from #t_rama)
  select @n= @n + 1
end
select ram_id from #t_rama order by n



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
  creado:    15/05/2000
  Proposito:  Copia una rama y toda su decendencia en otra rama.
*/
create procedure SP_ArbCortarRama (
  @@ram_id_ToCopy  int,
  @@ram_id_ToPaste int,
  @@solo_los_hijos smallint
)
as

set nocount on

if @@ram_id_ToCopy = 0 return
if @@ram_id_ToPaste = 0 return


-- para evitar recursividad
create table #TRama( ram_id int)

declare @incluir_ram_id_to_copy int

if @@solo_los_hijos <> 0 set @incluir_ram_id_to_copy =0
else       set @incluir_ram_id_to_copy =1

insert into #TRama exec SP_ArbGetDecendencia @@ram_id_ToCopy, @incluir_ram_id_to_copy

if exists (select * from #TRama where ram_id = @@ram_id_ToPaste) return


-- si solo corto los hijos, entonces las modificaciones van en el primer nivel de la decendencia de @@ram_id_ToCopy
if @@solo_los_hijos <> 0  update rama set ram_id_padre = @@ram_id_ToPaste where ram_id_padre = @@ram_id_ToCopy
else        update rama set ram_id_padre = @@ram_id_ToPaste where ram_id = @@ram_id_ToCopy


-- si cambio de arbol hay que modificar arb_id
declare @arb_id int

select @arb_id = arb_id from rama where ram_id = @@ram_id_ToPaste

-- esto dice si el arb_id de la rama en la que copio es distinto del arb_id de la rama en la que pego
if not exists (select * from arbol inner join rama on arbol.arb_id = rama.arb_id where @arb_id = rama.arb_id and ram_id = @@ram_id_ToCopy)
begin

  -- primero las ramas
  update rama set arb_id = @arb_id from #TRama where rama.ram_id = #TRama.ram_id


  -- ahora las hojas
  update hoja set arb_id = @arb_id from #TRama where hoja.ram_id = #TRama.ram_id
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
  creado:    15/05/2000
  Proposito:  Devuelve toda la decendencia de una rama incluyendo a la misma rama

  insert into exec:  - SP_ArbCopiarRama
        - SP_ArbBorrarRama
        - SP_ArbCortarRama 

*/
create procedure SP_ArbGetDecendencia (
  @@ram_id     int,
  @@incluir_ram_id   smallint = 1,
  @@incluir_ram_id_padre  smallint = 0,  -- este default es necesario para: SP_ArbCopiarRama, SP_ArbBorrarRama
  @@incluir_nombre  smallint = 0,  -- este default es necesario para: SP_ArbCopiarRama, SP_ArbBorrarRama
  @@incluir_arb_id  smallint = 0  -- este default es necesario para: SP_ArbCopiarRama, SP_ArbBorrarRama
)
as

set nocount on

create table #t_rama(
ram_id     int not null,
n          int not null,
ram_id_padre   int not null,
arb_id    int not null    
)

if @@ram_id = 0 return

declare @tot2 int
declare @tot1 int
declare @n    int

select @tot1 = -1
select @tot2 =  0
select @n    =  1

declare @arb_id int
if @@incluir_arb_id<>0   select @arb_id = arb_id from rama where ram_id = @@ram_id
else      set    @arb_id = 0

insert into #t_rama (ram_id,n,ram_id_padre,arb_id) select @@ram_id,0,ram_id_padre,@arb_id from rama where ram_id = @@ram_id 

while @tot1 < @tot2
begin
  select @tot1 = @tot2
  insert into #t_rama (ram_id,n,ram_id_padre,arb_id) select r.ram_id,@n,r.ram_id_padre,@arb_id from rama r ,#t_rama t 
    where r.ram_id_padre = t.ram_id and t.n = @n - 1 
      -- esto chequea que no existan referencias circulares
      and not exists(select * from #t_rama where #t_rama.ram_id = r.ram_id)
    order by r.ram_orden

  select @tot2 = (select count(*) from #t_rama)
  select @n= @n + 1
end

declare @sqlstmt   varchar(255)
declare @where     varchar(50)
declare @sqlArbId   varchar (50)

if @@incluir_ram_id = 0    set @where = ' where t.ram_id <> ' + convert(varchar(18),@@ram_id)
else        set @where = ''

if @@incluir_arb_id <> 0  set @sqlArbId = ',t.arb_id' 
else        set @sqlArbId = ''


if @@incluir_ram_id_padre <> 0
begin
  if @@incluir_nombre <> 0
    set @sqlstmt = 'select t.ram_id,t.ram_id_padre,r.ram_nombre' + @sqlArbId + ' from #t_rama t inner join rama r on t.ram_id = r.ram_id'
  else
    set @sqlstmt = 'select ram_id,ram_id_padre' + @sqlArbId + ' from #t_rama t'
end
else
begin
  if @@incluir_nombre <> 0
    set @sqlstmt = 'select t.ram_id,r.ram_nombre' + @sqlArbId + ' from #t_rama t inner join rama r on t.ram_id = r.ram_id'
  else
    set @sqlstmt = 'select ram_id' + @sqlArbId + ' from #t_rama t'
end

set @sqlstmt = @sqlstmt + @where + ' order by n'

exec(@sqlstmt)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure SP_ArbSubirRama (
  @@ram_id int
)
as

set nocount on

declare @ram_orden smallint

select @ram_orden = ram_orden from rama where ram_id = @@ram_id

if @ram_orden = 0 return

update rama set ram_orden = ram_orden + 1 

where ram_id_padre = (select ram_id_padre from rama where ram_id = @@ram_id) 

and ram_orden = @ram_orden - 1

update rama set ram_orden = ram_orden -1 where ram_id = @@ram_id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
  creado:    15/05/2000
  Proposito:  Devuelve un id para realizar un insert
*/
create procedure SP_DBGetNewId (
  @@tabla sysname,
  @@pk   sysname,
  @@id  int out
)
as

set nocount on

select @@id = max(Id_NextId) from id where Id_Tabla = @@tabla and Id_CampoId = @@pk

-- si no existe en la tabla
if @@id is null
begin
  declare @sqlstmt varchar(255)

  set @sqlstmt = 'insert into Id (Id_Tabla, Id_NextId, Id_CampoId) select '''+@@tabla+''',isnull(max('+@@pk+'),0)+1, '''+@@pk+''' from '+@@tabla
  exec(@sqlstmt)

  select @@id = max(Id_NextId) from id where Id_Tabla = @@tabla and Id_CampoId = @@pk
end

update id set Id_NextId = @@id+1 where Id_Tabla = @@tabla and Id_CampoId = @@pk

select @@id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*

  04/09/00
  Proposito: Borrar un usuario

*/

create procedure SP_RolDelete(
  @@rol_id int
)
as 

begin transaction

Delete UsuarioRol where rol_id = @@rol_id
  if @@error <> 0 goto error 

Delete Permiso where rol_id = @@rol_id
  if @@error <> 0 goto error 

Delete Rol where rol_id = @@rol_id
  if @@error <> 0 goto error 

commit transaction
return

error:
raiserror ('Error al intentar borrar el rol', 16, -1)
rollback transaction


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*

  04/09/00
  Proposito: Devuelve los permisos asigandos a un rol. Tiene dos
      modos:
          resumido: solo devuelve los id's de las 
              prestaciones a la que accede el usuario
              y el id del permiso
      (default)  extenso:  devuelve:
              per_id      
              pre_id      
              per_Creado                  
              per_Modifico_id 
              per_Modifico                                       
              pre_nombre                                         
              pre_grupo                                          

*/

create procedure SP_SecGetPermisosXRol(
  @@rol_id int,
  @@resumido smallint=0
)
as 

if @@resumido <>0
  select per_id, pre_id from permiso where rol_id = @@rol_id
else
  select     
    p.per_id,
    pr.pre_id,
    per_Creado   = p.creado, 
    per_Modifico_id = p.modifico, 
    per_Modifico   = us_nombre, 
    pr.pre_nombre,
    pr.pre_grupo

    from permiso p inner join usuario u on p.modifico = u.us_id
                   inner join prestacion pr on p.pre_id = pr.pre_id
        where p.rol_id = @@rol_id




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*

  04/09/00
  Proposito: Devuelve los permisos asigandos a un usuario. Tiene dos
      modos:
          resumido: solo devuelve los id's de las 
              prestaciones a la que accede el usuario
              y el id del permiso
      (default)  extenso:  devuelve:
              per_id      
              pre_id      
              rol_nombre                                         
              per_Creado                  
              per_Modifico_id 
              per_Modifico                                       
              pre_nombre                                         
              pre_grupo                                          

*/

create procedure SP_SecGetPermisosXUsuario(
  @@us_id int,
  @@resumido smallint=0
)
as 

set nocount on

declare @rol_id int

create table #roles (rol_id int)
create table #permisos (per_id int,rol_id int)

insert into #roles(rol_id) (select rol_id from usuariorol where us_id=@@us_id)

declare C_R insensitive cursor for select rol_id from #roles

open C_R

fetch next from C_R into @rol_id

while @@fetch_status = 0
begin
  insert into #permisos(per_id,rol_id) (select per_id,@rol_id from permiso where rol_id=@rol_id)

  fetch next from C_R into @rol_id
end

close C_R
deallocate C_R

insert into #permisos(per_id) (select per_id from permiso where us_id = @@us_id)

if @@resumido <>0
  select tp.per_id, pre_id from #permisos tp inner join permiso p on tp.per_id = p.per_id
else
  select 
    p.per_id,
    pr.pre_id,
    rol_nombre,
    per_Creado   = p.creado, 
    per_Modifico_id = p.modifico, 
    per_Modifico   = us_nombre, 
    pr.pre_nombre,
    pr.pre_grupo
  
    from (#permisos tp inner join permiso p on tp.per_id = p.per_id 
               inner join prestacion pr on p.pre_id = pr.pre_id
         inner join usuario u on p.modifico = u.us_id)
      left join rol r on tp.rol_id = r.rol_id


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


create procedure SP_SecGetRolesXUsuario(
  @@us_id int
)
as 

select * from rol inner join usuariorol on rol.rol_id=usuariorol.rol_id

where usuariorol.us_id=@@us_id

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*

  04/09/00
  Proposito: Borrar un usuario

*/

create procedure SP_UsDelete(
  @@us_id int
)
as 

begin transaction

Delete UsuarioRol where us_id = @@us_id
  if @@error <> 0 goto error 

Delete Permiso where us_id = @@us_id
  if @@error <> 0 goto error 

Delete Usuario where us_id = @@us_id
  if @@error <> 0 goto error 

commit transaction
return

error:
raiserror ('Error al intentar borrar el usuario', 16, -1)
rollback transaction


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_ArbGetAllHojas (
  @@ram_id int
)
as

set nocount on

create table #t_rama(
ram_id int not null,
n      int not null    
)

if @@ram_id = 0 return

declare @tot2 int
declare @tot1 int
declare @n    int

select @tot1 = -1
select @tot2 =  0
select @n    =  1

insert into #t_rama (ram_id,n) values(@@ram_id,0) 

while @tot1 < @tot2
begin
  select @tot1 = @tot2
  insert into #t_rama (ram_id,n) select r.ram_id,@n from rama r ,#t_rama t 
    where r.ram_id_padre = t.ram_id and t.n = @n - 1

  select @tot2 = (select count(*) from #t_rama)
  select @n= @n + 1
end
select id from hoja h,#t_rama t where h.ram_id = t.ram_id



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_ArbGetArboles (
  @@tbl_id int
)
as


select Arbol.arb_Id,arb_Nombre,ram_id from 
Arbol,Rama where Rama.ram_id_padre = 0  AND Arbol.arb_Id = Rama.arb_Id AND tbl_id = @@tbl_id AND Rama.ram_id <> 0


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_ArbGetHojas (
  @@ram_id int,
  @@soloColumnas smallint = 0,
  @@aBuscar varchar(255) =''
)
as

set nocount on

-- 1 Averiguo de que tabla se trata
declare @tabla       varchar(50)
declare @campoId    varchar(50)
declare @campoNombre    varchar(50)
declare @campos     varchar(255)
declare @camposRama    varchar(255)
declare @tablasRama    varchar(255)
declare @where      varchar(255)
declare @prefix      varchar(50)
declare @sqlstmt    varchar(510)
declare @sqlstmt2    varchar(510)
declare @sqlwhere    varchar(510)
declare @esRaiz      smallint
declare @arb_id      int

--------------------------------------------------------------------
select   @camposRama  = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'Campos'
select   @tablasRama  = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'Tablas'
select   @prefix    = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'Prefix'
select   @where    = ramc_valor  from RamaConfig where ram_id = @@ram_id and ramc_aspecto = 'where'

if @camposRama is null set @camposRama = ''
if @tablasRama is null set @tablasRama = ''
if @prefix is null set @prefix = ''
if @where is null set @where = ''

--------------------------------------------------------------------
select   @tabla       = tbl_nombreFisico,
  @campos     = tbl_camposInView, 
  @campoId    = tbl_campoId,
  @campoNombre    = tbl_campoNombre
  from Arbol,Rama,Tabla 

  where  Arbol.arb_id = Rama.arb_id 
  and   Tabla.tbl_id = Arbol.tbl_id
  and  Rama.ram_id  = @@ram_id

--------------------------------------------------------------------
if ltrim(@camposRama) <> '' set @campos = @camposRama
if ltrim(@prefix) = '' set @prefix = @tabla

--------------------------------------------------------------------

-- armo la sentencia sql
set @sqlstmt = 'select hoja_id,' 
set @sqlstmt = @sqlstmt +'ID ='  + @prefix+ '.' + @campoId  +','
set @sqlstmt = @sqlstmt +'Nombre = '  + @prefix+ '.' + @campoNombre

exec sp_strSetPrefix @prefix, @campos out

if ltrim(@campos) <> '' set @sqlstmt = @sqlstmt +','+ @campos

set @sqlstmt = @sqlstmt + ' from ' + @tabla + ' ' + @prefix 

if ltrim(@tablasRama) <> '' set @sqlstmt = @sqlstmt +','+ @tablasRama

set @sqlwhere = ' where Hoja.ram_id = ' + convert(varchar(15),@@ram_id) + ' and Hoja.id = ' + @prefix + '.' + @campoId + @where


-- si solo quieren las columnas
if isnull(@@soloColumnas,0) <> 0 
 begin
  set @sqlstmt = @sqlstmt + ', Hoja ' + @sqlwhere
  set @sqlstmt = @sqlstmt + ' and 1=2'
 end
else
 begin
  -- si se trata de la raiz tambien entran los que no estan asignados a ninguna rama
  select @esRaiz = ram_id_padre, @arb_id = arb_id from rama where ram_id = @@ram_id
  if @esRaiz = 0 
   begin
    create table #HojaId (hoja_id int, id int)

    -- Ids de la raiz
    set @sqlstmt2 = ' insert into #HojaId select hoja_id,id from Hoja where ram_id = ' + convert(varchar(15),@@ram_id)
    exec(@sqlstmt2)--print (@sqlstmt2)--

    -- Ids sin asignar
    set @sqlstmt2 =  'insert into #HojaId select ' + @campoId + '*-1,' + @campoId + ' from ' + @tabla + ' where not exists (select * from Hoja where Hoja.id = ' + @tabla + '.' + @campoId + ' and arb_id = '+ convert(varchar(15),@arb_id) +')'
    exec(@sqlstmt2)--print (@sqlstmt2)--

    -- el filtro esta en #HojaId
    set @sqlstmt = @sqlstmt + ', #HojaId where #HojaId.id = ' + @prefix + '.' + @campoId + @where
   end
  else
    set @sqlstmt = @sqlstmt + ', Hoja ' + @sqlwhere
 end
exec (@sqlstmt) 
--print (@sqlstmt)--



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_ArbGetRamas (
  @@arb_id int
)
as

set nocount on
                        -- para traer la raiz primero
--select ram_id, ram_nombre, ram_id_padre from rama where arb_id = @@arb_id and ram_id <> 0 order by ram_id_padre

declare @raiz_id int

select @raiz_id = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0

exec SP_ArbGetDecendencia @raiz_id,1,1,1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE sp_col (
         @@table_name    nvarchar(384),
         @@sintipo    smallint = 0
)
AS
DECLARE @table_id int

  SELECT @table_id = object_id(@@table_name)

if @@sintipo = 0 


    SELECT 
      COLUMN_NAME = convert(sysname,c.name),
      c.type
    FROM
      syscolumns c,
      sysobjects o
    WHERE
      o.id = @table_id
      AND c.id = o.id

else

    SELECT 
      COLUMN_NAME = convert(sysname,c.name)
    FROM
      syscolumns c,
      sysobjects o
    WHERE
      o.id = @table_id
      AND c.id = o.id

    


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE sp_columnas (
         @@table_name    nvarchar(384)
)
AS
DECLARE @table_id int

  SELECT @table_id = object_id(@@table_name)

    SELECT 
      COLUMN_NAME = convert(sysname,c.name),
      c.type
    FROM
      syscolumns c,
      sysobjects o
    WHERE
      o.id = @table_id
      AND c.id = o.id



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_scriptor(
  @@table varchar(50),
  @@condicion varchar(8000)='',
  @@PrintPlantilla smallint = 0
)
as
set nocount on

declare @sqlselect varchar(20)
declare @sqlstmt varchar(8000)
declare @sqlstmt2 varchar(8000)
declare @campo varchar(50)
declare @tipo int

create table #tcampos (nombre varchar(50),tipo int)

insert into #tcampos exec sp_columnas @@table

select @sqlselect = 'select p = '''
select @sqlstmt = ' insert into ' + @@table + ' ('
select @sqlstmt2 =''

declare campos insensitive cursor for select nombre,tipo from #tcampos

open campos
fetch next from campos
into @campo,@tipo
 while @@fetch_status= 0
 begin
  select @sqlstmt = @sqlstmt + @campo + ','
  if @campo is null 
    select @sqlstmt2 = @sqlstmt2 + 'NULL +' + ''',''' + '+'  
  else
  begin
    if (@tipo = 56 
    or @tipo = 52)select @sqlstmt2 = @sqlstmt2 + 'convert(varchar(15),' + @campo + ')+' + ''',''' + '+'
    if @tipo = 39 select @sqlstmt2 = @sqlstmt2 + '''''''''' + '+' + @campo + '+' + '''''''''' + '+' + ''',''' + '+'
    if @tipo = 61 select @sqlstmt2 = @sqlstmt2 + '''''''''' + '+' + 'convert(varchar(10),' + @campo + ',20)+' +'''''''''' + '+' + ''',''' + '+'
  end
  
  fetch next from campos
  into @campo,@tipo
 end
close campos
deallocate campos

select @sqlstmt = substring(@sqlstmt,1,len(@sqlstmt)-1) + ') values ('
select @sqlstmt2 = substring(@sqlstmt2,1,len(@sqlstmt2)-5) +'+'+''''+ ')'+ ''''
select @sqlstmt = @sqlselect + @sqlstmt +''''+'+'+ @sqlstmt2 + 'from '+ @@table 

if @@PrintPlantilla <> 0 print @sqlstmt

exec (@sqlstmt)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_strGetBusqueda (
  @@prefix varchar (50),
  @@campos varchar (500) output
)
as

set nocount on

declare @retval  varchar(500)
declare @campo  varchar(500)
declare @caracter varchar(1)
declare @i  int
declare @j  int
declare @z  int
declare @q  int
declare @r  int
declare @t  int
declare @p  int

set @i = 1
set @j = 0
set @z = 0

set @retval =''

--------------------------------------------
-- si no hay prefijo no toco los campos
if @@prefix is null or @@prefix = '' return
-- si no hay campos tampoco
if @@campos is null or @@campos = '' return
--------------------------------------------

set @j = isnull(charindex(',',@@campos,@j+1),0)
set @z = isnull(charindex('(',@@campos,@z+1),0)
--------------------------------------------
if @j = 0
begin

  if @i < @z begin
    --leeo caracter por caracter hasta encontrar el cierre del parentesis
    set @r = len(@@campos)+1
    set @t = @z
    while @t < @r
    begin
      set @caracter = substring(@@campos,@t,1)
      -- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
      if @caracter = '(' set @p = @p + 1
      if @caracter = ')' begin
        -- si encontre el cierre del primer parentesis termine con este campo
        if @p = 0 goto ExitWhile4
        -- sino sigo buscando el parentesis que cierra
        else set @p = @p - 1
      end
      set @t = @t+1
    end
    ExitWhile4:
    set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
    set @retval   = @retval + @campo
    set @@campos = @retval
  end
  else  exec sp_strGetRealName @@prefix, @@campos out
  
  return
end
else
begin
  while @j <> 0
  begin  
    -- si hay un parentesis es por que hay un subselect, en cuyo caso no toco nada que este en
    -- el parentesis
    if @i < @z and @z < @j begin

      --leeo caracter por caracter hasta encontrar el cierre del parentesis
      set @r = len(@@campos)+1
      set @t = @z
      while @t < @r
      begin
        set @caracter = substring(@@campos,@t,1)
        -- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
        if @caracter = '(' set @p = @p + 1
        if @caracter = ')' begin
          -- si encontre el cierre del primer parentesis termine con este campo
          if @p = 0 goto ExitWhile1
          -- sino sigo buscando el parentesis que cierra
          else set @p = @p - 1
        end
        set @t = @t+1
      end
      ExitWhile1:
      -- ahora busco una coma a partir del ultimo parentesis
      set @j    = charindex(',',@@campos,@t+1)

      -- si la encuentro agrego el campo tal como esta a la sentencia
      if @j > 0 begin
        set @campo  = ltrim(substring(@@campos,@i,@j-@i+1))
        set @retval   = @retval + @campo
        -- me preparo para buscar la proxima coma
        set @i     = @j + 1
        set @j    = charindex(',',@@campos,@j+1)
        set @z = charindex('(',@@campos,@i+1)
      -- si no encuentro la coma es porque se terminaron los campos, asi que
      -- agrego el campo a la sentencia y termine
      end
      else
      begin
        set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
        set @retval   = @retval + @campo
        -- con esto voy al final
        goto ExitWhile2
      end
      
    end
    else begin
      set @campo  = ltrim(substring(@@campos,@i,@j-@i+1))
      exec sp_strGetRealName @@prefix, @campo out
      set @retval   = @retval + @campo
      set @i     = @j + 1
      set @j    = charindex(',',@@campos,@j+1)
      -- busco el proximo parentesis
      set @z = charindex('(',@@campos,@i+1)
    end
  end

  if @i < @z begin
    --leeo caracter por caracter hasta encontrar el cierre del parentesis
    set @r = len(@@campos)+1
    set @t = @z
    while @t < @r
    begin
      set @caracter = substring(@@campos,@t,1)
      -- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
      if @caracter = '(' set @p = @p + 1
      if @caracter = ')' begin
        -- si encontre el cierre del primer parentesis termine con este campo
        if @p = 0 goto ExitWhile3
        -- sino sigo buscando el parentesis que cierra
        else set @p = @p - 1
      end

      set @t = @t+1
    end
    ExitWhile3:
    set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
    set @retval   = @retval + @campo
  end
  else begin
    set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
    exec sp_strGetRealName @@prefix, @campo out
    set @retval   = @retval + @campo
  end
end
ExitWhile2:

--------------------------------------------
set @@campos = @retval


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_strGetRealName (
  @@prefix varchar (50),
  @@campo   varchar (50) output
)
as

declare @j int

set @j = isnull(charindex('=',@@campo,1),0)

if @j = 0 
  set @@campo = @@prefix + '.' + @@campo
else
  set @@campo = substring(@@campo,1,@j) + @@prefix + '.' + ltrim(substring(@@campo,@j+1,len(@@campo)))



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_strSetPrefix (
  @@prefix varchar (50),
  @@campos varchar (500) output
)
as

set nocount on

declare @retval  varchar(500)
declare @campo  varchar(500)
declare @caracter varchar(1)
declare @i  int
declare @j  int
declare @z  int
declare @q  int
declare @r  int
declare @t  int
declare @p  int

set @i = 1
set @j = 0
set @z = 0

set @retval =''

--------------------------------------------
-- si no hay prefijo no toco los campos
if @@prefix is null or @@prefix = '' return
-- si no hay campos tampoco
if @@campos is null or @@campos = '' return
--------------------------------------------

set @j = isnull(charindex(',',@@campos,@j+1),0)
set @z = isnull(charindex('(',@@campos,@z+1),0)
--------------------------------------------
if @j = 0
begin

  if @i < @z begin
    --leeo caracter por caracter hasta encontrar el cierre del parentesis
    set @r = len(@@campos)+1
    set @t = @z
    while @t < @r
    begin
      set @caracter = substring(@@campos,@t,1)
      -- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
      if @caracter = '(' set @p = @p + 1
      if @caracter = ')' begin
        -- si encontre el cierre del primer parentesis termine con este campo
        if @p = 0 goto ExitWhile4
        -- sino sigo buscando el parentesis que cierra
        else set @p = @p - 1
      end
      set @t = @t+1
    end
    ExitWhile4:
    set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
    set @retval   = @retval + @campo
    set @@campos = @retval
  end
  else  exec sp_strGetRealName @@prefix, @@campos out
  
  return
end
else
begin
  while @j <> 0
  begin  
    -- si hay un parentesis es por que hay un subselect, en cuyo caso no toco nada que este en
    -- el parentesis
    if @i < @z and @z < @j begin

      --leeo caracter por caracter hasta encontrar el cierre del parentesis
      set @r = len(@@campos)+1
      set @t = @z
      while @t < @r
      begin
        set @caracter = substring(@@campos,@t,1)
        -- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
        if @caracter = '(' set @p = @p + 1
        if @caracter = ')' begin
          -- si encontre el cierre del primer parentesis termine con este campo
          if @p = 0 goto ExitWhile1
          -- sino sigo buscando el parentesis que cierra
          else set @p = @p - 1
        end
        set @t = @t+1
      end
      ExitWhile1:
      -- ahora busco una coma a partir del ultimo parentesis
      set @j    = charindex(',',@@campos,@t+1)

      -- si la encuentro agrego el campo tal como esta a la sentencia
      if @j > 0 begin
        set @campo  = ltrim(substring(@@campos,@i,@j-@i+1))
        set @retval   = @retval + @campo
        -- me preparo para buscar la proxima coma
        set @i     = @j + 1
        set @j    = charindex(',',@@campos,@j+1)
        set @z = charindex('(',@@campos,@i+1)
      -- si no encuentro la coma es porque se terminaron los campos, asi que
      -- agrego el campo a la sentencia y termine
      end
      else
      begin
        set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
        set @retval   = @retval + @campo
        -- con esto voy al final
        goto ExitWhile2
      end
      
    end
    else begin
      set @campo  = ltrim(substring(@@campos,@i,@j-@i+1))
      exec sp_strGetRealName @@prefix, @campo out
      set @retval   = @retval + @campo
      set @i     = @j + 1
      set @j    = charindex(',',@@campos,@j+1)
      -- busco el proximo parentesis
      set @z = charindex('(',@@campos,@i+1)
    end
  end

  if @i < @z begin
    --leeo caracter por caracter hasta encontrar el cierre del parentesis
    set @r = len(@@campos)+1
    set @t = @z
    while @t < @r
    begin
      set @caracter = substring(@@campos,@t,1)
      -- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
      if @caracter = '(' set @p = @p + 1
      if @caracter = ')' begin
        -- si encontre el cierre del primer parentesis termine con este campo
        if @p = 0 goto ExitWhile3
        -- sino sigo buscando el parentesis que cierra
        else set @p = @p - 1
      end
      set @t = @t+1
    end
    ExitWhile3:
    set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
    set @retval   = @retval + @campo
  end
  else begin
    set @campo  = ltrim(substring(@@campos,@i,len(@@campos)))
    exec sp_strGetRealName @@prefix, @campo out
    set @retval   = @retval + @campo
  end
end
ExitWhile2:

--------------------------------------------
set @@campos = @retval


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

create procedure sp_strStringToTable (
  @@Codigo  datetime,
  @@aBuscar   varchar (255),
  @@Separador  varchar (1) = ' '
)
as

set nocount on

declare @i     smallint
declare @s    varchar(255)

SET @@aBuscar = Rtrim(Ltrim(ISNULL ( @@aBuscar , '')))

while len(@@aBuscar)>0 begin

  set @i = 1
  while @i <= len(@@aBuscar) and len(@@aBuscar)>0
  begin
    set @s = substring(@@aBuscar,@i,1)
    if @s = @@Separador goto FinWhile2
    set @i = @i + 1
  end
  FinWhile2:

  insert into TmpStringToTable (tmpstr2tbl_campo,tmpstr2tbl_id)
  values(ltrim(substring(@@aBuscar,1,@i)),@@Codigo)

  set @@aBuscar = ltrim(substring(@@aBuscar,@i,len(@@aBuscar)))
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

