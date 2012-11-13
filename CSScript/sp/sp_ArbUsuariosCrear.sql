if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbUsuariosCrear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbUsuariosCrear]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  sp_ArbUsuariosCrear.sql
' Objetivo: Crear el arbol de permisos
'-----------------------------------------------------------------------------------------
*/

/*

select * from arbol order by arb_id
select * from rama where arb_id = 162 order by ram_orden
madase
*/
create Procedure sp_ArbUsuariosCrear

as
begin

	set nocount on
  declare @arb_id int
  declare @ram_id int
  declare @dpto_id int

  declare c_arb insensitive cursor for 
  select ram_id from rama inner join arbol on rama.arb_id = arbol.arb_id 
  where ram_nombre = 'Usuarios x Departamento' and tbl_id = 3

  open c_arb
  fetch next from c_arb into @ram_id
  while @@fetch_status = 0 
  begin

    exec SP_ArbBorrarRama @ram_id

    fetch next from c_arb into @ram_id
  end
  close c_arb
  deallocate c_arb

  set @ram_id = null
  
	exec SP_DBGetNewId 'Arbol','arb_id',@arb_id out,0

  insert into  Arbol (
                          arb_id,
                          arb_nombre,
                          modificado,
                          creado,
                          tbl_Id,
                          modifico
                      )
            values   (
                      @arb_id,
                      'Usuarios x Departamento',
                      getdate(),
                      getdate(),
                      3, /*Usuarios*/
                      1
                     )

	exec SP_DBGetNewId 'Rama','ram_id',@ram_id out,0

  insert into Rama (
                      ram_id,
                      ram_nombre,
                      arb_id,
                      modificado,
                      creado,
                      modifico,
                      ram_id_padre
                    )
            values (
                      @ram_id,
                      'Usuarios x Departamento',
                      @arb_id,
                      getdate(),
                      getdate(),
                      1,
                      0
                    )

  declare c_rama insensitive cursor for select Persona.dpto_id, dpto_nombre from usuario inner join persona on usuario.prs_id = persona.prs_id inner join departamento on persona.dpto_id = departamento.dpto_id
																				group by Persona.dpto_id, dpto_nombre order by dpto_nombre
  open c_rama

  declare @ram_nombre varchar(255)
  declare @ram_id_padre int
  declare @orden int

  set @ram_id_padre = @ram_id
  set @orden = 1

  fetch next from c_rama into @dpto_id, @ram_nombre
  while @@fetch_status = 0 begin

    if @ram_nombre = '' set @ram_nombre = 'Configuracion'

    set @orden = @orden + 1

  	exec SP_DBGetNewId 'Rama','ram_id',@ram_id out,0
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
                        @ram_nombre,
                        @arb_id,
                        getdate(),
                        getdate(),
                        1,
                        @ram_id_padre,
                        @orden
                      )



            --------------------------------------------------------------------------------------------------------
              declare c_hoja insensitive cursor for select us_id from Usuario inner join Persona on Usuario.prs_id = Persona.prs_id
                                                          where dpto_id = @dpto_id
                                                          order by us_nombre
              open c_hoja
            
              declare @us_id     varchar(255)
              declare @hoja_id         int
        
    
              fetch next from c_hoja into @us_id
              while @@fetch_status = 0 begin
            
                if @us_id <> '' begin
    
                	exec SP_DBGetNewId 'Hoja','hoja_id',@hoja_id out,0
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
                                      @us_id,
                                      getdate(),
                                      getdate(),
                                      1,
                                      @ram_id,
                                      @arb_id
                                    )
            
                end          
            
                fetch next from c_hoja into @us_id
              end
            
              close c_hoja
              deallocate c_hoja

    ----------------------------------------------------------------------------------------------------------------
    

    fetch next from c_rama into @dpto_id, @ram_nombre
  end

  close c_rama
  deallocate c_rama

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

