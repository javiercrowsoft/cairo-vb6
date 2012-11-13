if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocGetCueId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocGetCueId]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

	select * from cliente
	select * from documento
	select * from cuenta where cue_id = 129

	sp_DocGetCueId 6,12

*/

create procedure sp_DocGetCueId (
	@@tercero_id	int, -- puede ser un cliente o un proveedor
  @@doc_id  		int,
  @@bSelect 		tinyint = 1,
  @@cue_id  		int = 0 out,
  @@mon_id  		int = 0 out,
  @@to_id   		int = 1 -- Tipo de operacion
)
as

set nocount on

begin

	declare @doct_id int
	declare @cue_id  int
	declare @mon_id  int

	-- Ojo: resistir la tentacion de meter esto
	--      en el select de abajo, ya que si no
	--      hay tipo de operacion, va a dejar
	--      el doct_id en null y no va a funcar
	--
	select @doct_id = documento.doct_id
  from Documento
	where doc_id = @@doc_id

	-- Saco la cuenta del tipo de operacion
	--
	select @cue_id = Cuenta.cue_id, @mon_id = Cuenta.mon_id
  from TipoOperacionCuentaGrupo inner join Documento   on TipoOperacionCuentaGrupo.cueg_id = Documento.cueg_id
                          			inner join Cuenta      on TipoOperacionCuentaGrupo.cue_id  = Cuenta.cue_id
  where to_id = @@to_id and doc_id = @@doc_id

	if @cue_id is null begin

		if @doct_id in (1,7,9,13) begin			
	
			-- Saco la cuenta del cliente
			--
			select @cue_id = Cuenta.cue_id, @mon_id = Cuenta.mon_id
		  from ClienteCuentaGrupo inner join Documento   on ClienteCuentaGrupo.cueg_id = Documento.cueg_id
		                          inner join Cuenta      on ClienteCuentaGrupo.cue_id  = Cuenta.cue_id
		  where cli_id = @@tercero_id and doc_id = @@doc_id
		
			-- Saco la cuenta de CuentaGrupo
			--
			if @cue_id is null begin
				select @cue_id = Cuenta.cue_id, @mon_id = Cuenta.mon_id
				from CuentaGrupo inner join Documento on CuentaGrupo.cueg_id = Documento.cueg_id
		                     inner join Cuenta    on CuentaGrupo.cue_id  = Cuenta.cue_id
				where Documento.doc_id = @@doc_id
			end

		end else begin
	
			-- Saco la cuenta del cliente
			--
			select @cue_id = Cuenta.cue_id, @mon_id = Cuenta.mon_id
		  from ProveedorCuentaGrupo inner join Documento   on ProveedorCuentaGrupo.cueg_id = Documento.cueg_id
		                            inner join Cuenta      on ProveedorCuentaGrupo.cue_id  = Cuenta.cue_id
		  where prov_id = @@tercero_id and doc_id = @@doc_id
		
			-- Saco la cuenta de CuentaGrupo
			--
			if @cue_id is null begin
				select @cue_id = Cuenta.cue_id, @mon_id = Cuenta.mon_id
				from CuentaGrupo inner join Documento on CuentaGrupo.cueg_id = Documento.cueg_id
		                     inner join Cuenta    on CuentaGrupo.cue_id  = Cuenta.cue_id
				where Documento.doc_id = @@doc_id
			end

		end

	end

	set @@cue_id = @cue_id
  set @@mon_id = @mon_id

	if @@bSelect <> 0 select @cue_id as cue_id, @mon_id as mon_id
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



