if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentoApplySecSubDpto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentoApplySecSubDpto]

/*


 select * from departamento

 sp_DepartamentoApplySecSubDpto 59

*/

go
create procedure sp_DepartamentoApplySecSubDpto (
  @@per_id     int
)
as

begin

  set nocount on

  declare @dpto_id   int
  declare @n         int
  declare @per_id    int
  declare @pre_id    int
  declare @us_id     int
  declare @rol_id    int
  declare @modifico  int

  select 
          @pre_id     = pre_id ,
          @us_id      = us_id,
          @rol_id     = rol_id,
          @modifico   = modifico

  from permiso where per_id = @@per_id

  select @dpto_id = dpto_id from departamento 
  where 
          pre_id_vernoticias         = @pre_id
      or  pre_id_vernoticias         = @pre_id
      or  pre_id_editarnoticias      = @pre_id
      or  pre_id_vertareas           = @pre_id
      or  pre_id_asignartareas       = @pre_id
      or  pre_id_verdocumentos       = @pre_id
      or  pre_id_agregardocumentos   = @pre_id
      or  pre_id_borrardocumentos    = @pre_id
      or  pre_id_editardocumentos    = @pre_id

  create table #tmpDpto (
                         dpto_id      int not null,
                         n            int
                        )
  set @n = 1
  insert into #tmpDpto (dpto_id,n) values(@dpto_id, @n)

  while exists(select * from Departamento inner join #tmpDpto on IsNull(dpto_id_padre,0) = #tmpDpto.dpto_id where n = @n)
  begin

    insert into #tmpDpto (dpto_id, n) 
    select d.dpto_id, @n+1 from Departamento d inner join #tmpDpto on IsNull(dpto_id_padre,0) = #tmpDpto.dpto_id where n = @n

    set @n=@n+1

  end


  declare @pre_id_vernoticias           int
  declare @pre_id_editarnoticias        int
  declare @pre_id_vertareas             int
  declare @pre_id_asignartareas         int
  declare @pre_id_verdocumentos         int
  declare @pre_id_agregardocumentos     int
  declare @pre_id_borrardocumentos      int
  declare @pre_id_editardocumentos      int
  declare @pre_tipo                     tinyint

  select 
          @pre_id_vernoticias       = pre_id_vernoticias,
          @pre_id_editarnoticias    = pre_id_editarnoticias,
          @pre_id_vertareas         = pre_id_vertareas,
          @pre_id_asignartareas     = pre_id_asignartareas,
          @pre_id_verdocumentos     = pre_id_verdocumentos,
          @pre_id_agregardocumentos = pre_id_agregardocumentos,
          @pre_id_borrardocumentos  = pre_id_borrardocumentos,
          @pre_id_editardocumentos  = pre_id_editardocumentos  

  from Departamento where dpto_id = @dpto_id

  select @pre_tipo = case @pre_id
                          when @pre_id_vernoticias        then 1
                          when @pre_id_editarnoticias     then 2
                          when @pre_id_vertareas          then 3
                          when @pre_id_asignartareas      then 4
                          when @pre_id_verdocumentos      then 5
                          when @pre_id_agregardocumentos  then 6
                          when @pre_id_borrardocumentos   then 7
                          when @pre_id_editardocumentos   then 8
                      end

  declare c_dpto insensitive cursor for select dpto_id from #tmpDpto where n > 1 order by n

  open c_dpto

  fetch next from c_dpto into @dpto_id  
  while @@fetch_status = 0
  begin

    set @pre_id = null

    select @pre_id = case @pre_tipo
                          when 1 then pre_id_vernoticias        
                          when 2 then pre_id_editarnoticias     
                          when 3 then pre_id_vertareas          
                          when 4 then pre_id_asignartareas      
                          when 5 then pre_id_verdocumentos      
                          when 6 then pre_id_agregardocumentos  
                          when 7 then pre_id_borrardocumentos   
                          when 8 then pre_id_editardocumentos   
                      end
    from Departamento 
    where dpto_id = @dpto_id

    if not @pre_id is null begin

      exec sp_dbgetnewid 'Permiso', 'per_id', @per_id out, 0

      insert into Permiso (per_id, pre_id, us_id, rol_id, per_id_padre, modifico) 
                   values (@per_id, @pre_id, @us_id, @rol_id, @@per_id, @modifico)
    end

    fetch next from c_dpto into @dpto_id
  end

  close c_dpto
  deallocate c_dpto

  return
ControlError:

  raiserror ('Ha ocurrido un guardar los permisos para el departamento. sp_DepartamentoApplySecSubDpto.', 16, 1)

end
go