if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUsuarioWebSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUsuarioWebSave]

/*

 select * from proveedor where cli_codigo like '300%'
 select * from documento

 sp_clienteUsuarioWebSave 35639

*/

go
create procedure sp_clienteUsuarioWebSave (
	@@cli_id        int,
	@@us_nombre 		varchar(50),
	@@us_clave      varchar(16),
	@@activo        smallint,
	@@modifico      int
)
as

begin

	set nocount on

	declare @Message 	varchar(5000)
	declare @us_id 		int
	declare @usemp_id int
	
	set @@activo = IsNull(@@activo,0)
	if @@activo <> 0 set @@activo = 1

	select @us_id = us_id from cliente where cli_id = @@cli_id

	set @us_id = IsNull(@us_id,0)

	if exists (select * from usuario where us_nombre = @@us_nombre and us_id <> @us_id) begin

		set @Message = '@@ERROR_SP: El usuario ya existe. Debe elegir otro nombre.' 
		raiserror (@Message, 16, 1)

	end else begin

		if exists (select * from usuario where us_nombre = @@us_nombre and us_id = @us_id) begin

			update usuario set activo = @@activo where us_nombre = @@us_nombre
			
		end else begin

			if @@activo <> 0 begin

				exec sp_dbgetnewid 'Usuario','us_id',@us_id out,0

				insert into usuario  (us_id,us_nombre,us_clave,modifico,us_empresaEx, us_externo)
											values (@us_id,@@us_nombre, @@us_clave, @@modifico, 1, 1)

				update cliente set us_id = @us_id where cli_id = @@cli_id

				exec sp_dbgetnewid 'UsuarioEmpresa','usemp_id',@usemp_id out,0

				insert into usuarioempresa (usemp_id,us_id,cli_id,modifico)
													values   (@usemp_id,@us_id,@@cli_id,@@modifico)

			end

		end

		if IsNull(@us_id,0) <> 0 begin

			declare @emp_id 		int
			declare @empus_id 	int
	
			delete EmpresaUsuario where us_id = @us_id
	
			declare c_empresas insensitive cursor for 
		        select emp_id from EmpresaCliente where cli_id = @@cli_id
		
			open c_empresas
	
			fetch next from c_empresas into @emp_id
			while @@fetch_status=0
			begin
	
				exec sp_dbgetnewid 'EmpresaUsuario','empus_id',@empus_id out,0
	
				insert into EmpresaUsuario (empus_id,
																		emp_id,
																		us_id,
																		modifico
																		)
														values (
																		@empus_id,
																		@emp_id,
																		@us_id,
																		@@modifico
																	 )
	
				fetch next from c_empresas into @emp_id
			end
		
			close c_empresas
		
			deallocate c_empresas

		end

	end

end

go