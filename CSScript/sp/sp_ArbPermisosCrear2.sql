if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbPermisosCrear2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbPermisosCrear2]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ArbPermisosCrear2.sql
' Objetivo: Crear el arbol de permisos
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure sp_ArbPermisosCrear2(

  @@ram_nombre   varchar(255),
  @@ram_nombre2 varchar(255),
  @@ram_nombre3 varchar(255),
  @@ram_id      int,
  @@arb_id      int
)
as
begin
  set nocount on

  declare @ram_id int
  
  set @ram_id = @@ram_id

            ------------------------------------------------------------------------------------------------------------
            declare c_rama4 insensitive cursor for select pre_grupo4 from prestacion 
                                                        where pre_grupo1 = @@ram_nombre 
                                                          and pre_grupo2 = @@ram_nombre2 
                                                          and pre_grupo3 = @@ram_nombre3
                                                        group by pre_grupo4 order by pre_grupo4
            open c_rama4
          
            declare @ram_nombre4     varchar(500)
            declare @ram_id_padre4   int
            declare @orden4          int
          
            set @ram_id_padre4 = @ram_id
      
            set @orden4 = 1        
  
            fetch next from c_rama4 into @ram_nombre4
            while @@fetch_status = 0 begin
          
              if @ram_nombre4 <> '' begin
  
                set @orden4 = @orden4 + 1                
  
                exec SP_DBGetNewId 'Rama','ram_id',@ram_id out, 0
                insert into Rama (
                                    ram_id,
                                    ram_nombre,
                                    arb_id,
                                    modificado,
                                    creado,
                                    modifico,
                                    ram_id_padre,
                                    ram_orden
                                  )
                          values (
                                    @ram_id,
                                    @ram_nombre4,
                                    @@arb_id,
                                    getdate(),
                                    getdate(),
                                    1,
                                    @ram_id_padre4,
                                    @orden4
                                  )
          
              end          
  
              --------------------------------------------------------------------------------------------------------
                declare c_hoja insensitive cursor for select pre_id from prestacion 
                                                            where pre_grupo1 = @@ram_nombre 
                                                              and pre_grupo2 = @@ram_nombre2 
                                                              and pre_grupo3 = @@ram_nombre3 
                                                              and pre_grupo4 = @ram_nombre4 
                                                            order by pre_nombre
                open c_hoja
              
                declare @pre_id     varchar(500)
                declare @hoja_id         int
          
      
                fetch next from c_hoja into @pre_id
                while @@fetch_status = 0 begin
              
                  if @pre_id <> '' begin
      
                    exec SP_DBGetNewId 'Hoja','hoja_id',@hoja_id out, 0
                    insert into Hoja (
                                        hoja_id,
                                        id,
                                        modificado,
                                        creado,
                                        modifico,
                                        ram_id,
                                        arb_id
                                      )
                              values (
                                        @hoja_id,
                                        @pre_id,
                                        getdate(),
                                        getdate(),
                                        1,
                                        @ram_id,
                                        @@arb_id
                                      )
              
                  end          
                  
              
                  fetch next from c_hoja into @pre_id
                end
              
                close c_hoja
                deallocate c_hoja
              --------------------------------------------------------------------------------------------------------
              
          
              fetch next from c_rama4 into @ram_nombre4
            end
          
            close c_rama4
            deallocate c_rama4
end
GO