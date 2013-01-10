if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ProveedorCreateTreeAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ProveedorCreateTreeAux]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ProveedorCreateTreeAux.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ProveedorCreateTreeAux (
  @@arb_id    int,
  @@raiz       int
)
as
begin

  declare @prov_id  int
  declare @subfolder   varchar(255)
  declare @subfolder2  varchar(255)

  set @subfolder2 = '!#@@!!'
  set @subfolder  = '!#@@!!'

  declare @ram_id_subfolder int

  declare @max_hojas  int set @max_hojas = 300
  declare @n          int set @n = @max_hojas +1

  declare @ram_id  int
  declare @hoja_id int

  set nocount on

  fetch next from c_prov into @prov_id, @subfolder
  while @@fetch_status = 0 
  begin

    if @subfolder = '@@nosubfolder@@' begin  

      set @ram_id_subfolder = @@raiz

    end else begin

      if @subfolder2 <> @subfolder begin
        if not exists(select ram_id from rama where ram_nombre = @subfolder and ram_id_padre = @@raiz) begin
          exec sp_dbgetnewid 'Rama','ram_id',@ram_id_subfolder out, 0
          insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)
                     values(@ram_id_subfolder,@@arb_id,@subfolder,1,@@raiz,1000)
          set @n=1
        end 
        else
          select @ram_id_subfolder = ram_id from rama where ram_nombre = @subfolder and ram_id_padre = @@raiz
    
        set @n = @max_hojas + 1
        set @subfolder2 = @subfolder
      end
    end
  
    if @n > @max_hojas begin
      exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
      insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@@arb_id,'Grupo Aux',1,@ram_id_subfolder,1000)
      set @n=1
    end
  
    exec sp_dbgetnewid 'Hoja','hoja_id',@hoja_id out, 0
  
    insert into Hoja (hoja_id,ram_id,arb_id,id,modifico)values(@hoja_id,@ram_id,@@arb_id,@prov_id,1)
  
    set @n=@n+1
  
    fetch next from c_prov into @prov_id, @subfolder
  end

end