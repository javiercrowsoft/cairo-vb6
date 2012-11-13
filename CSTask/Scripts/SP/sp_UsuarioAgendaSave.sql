if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_UsuarioAgendaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_UsuarioAgendaSave]

/*

 sp_UsuarioAgendaSave 

*/

go
create procedure sp_UsuarioAgendaSave 
as

begin

declare c_Usuario insensitive cursor for select us_id, 'AG-'+ us_nombre, 'Agenda de '+ prs_apellido+', '+ prs_nombre 
                                     from Usuario inner join Persona on Usuario.prs_id = Persona.prs_id
open c_Usuario

  declare @us_id int 
  declare @agn_id int
  declare @agn_nombre varchar (255)
  declare @agn_codigo varchar (100)

  fetch next from c_Usuario into @us_id, @agn_codigo, @agn_nombre
  while @@fetch_status = 0
  begin
    if not exists  (select * from Agenda where modifico=@us_id) begin 
      
      exec sp_dbGetNewId 'Agenda', 'agn_id', @agn_id out, 0
 
      insert into Agenda (agn_id, agn_nombre, agn_codigo, modifico)
                  values (@agn_id, @agn_nombre, @agn_codigo, @us_id)

      exec sp_AgendaSavePrestacion @agn_id

    end
    fetch next from c_Usuario into @us_id, @agn_codigo, @agn_nombre
  end


close c_Usuario
deallocate c_Usuario


end 
go