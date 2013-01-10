if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ClienteCreateTreeAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ClienteCreateTreeAux]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ClienteCreateTreeAux.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ClienteCreateTreeAux (
  @@arb_id    int,
  @@raiz       int
)
as
begin

  declare @cli_id  int
  declare @ven_nombre   varchar(255)
  declare @ven_nombre2  varchar(255)

  set @ven_nombre2 = '!#@@!!'
  set @ven_nombre  = '!#@@!!'

  declare @ram_id_vendedor int

  declare @max_hojas  int set @max_hojas = 300
  declare @n          int set @n = @max_hojas +1

  declare @ram_id  int
  declare @hoja_id int

  set nocount on

  fetch next from c_cli into @cli_id, @ven_nombre
  while @@fetch_status = 0 
  begin

    if @ven_nombre = '@@Expo@@' begin  

      set @ram_id_vendedor = @@raiz

    end else begin

      if @ven_nombre2 <> @ven_nombre begin
        if not exists(select ram_id from rama where ram_nombre = @ven_nombre and ram_id_padre = @@raiz) begin
          exec sp_dbgetnewid 'Rama','ram_id',@ram_id_vendedor out, 0
          insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)
                     values(@ram_id_vendedor,@@arb_id,@ven_nombre,1,@@raiz,1000)
          set @n=1
        end 
        else
          select @ram_id_vendedor = ram_id from rama where ram_nombre = @ven_nombre and ram_id_padre = @@raiz
    
        set @n = @max_hojas + 1
        set @ven_nombre2 = @ven_nombre
      end
    end
  
    if @n > @max_hojas begin
      exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
      insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@@arb_id,'Grupo Aux',1,@ram_id_vendedor,1000)
      set @n=1
    end
  
    exec sp_dbgetnewid 'Hoja','hoja_id',@hoja_id out, 0
  
    insert into Hoja (hoja_id,ram_id,arb_id,id,modifico)values(@hoja_id,@ram_id,@@arb_id,@cli_id,1)
  
    set @n=@n+1
  
    fetch next from c_cli into @cli_id, @ven_nombre
  end

end