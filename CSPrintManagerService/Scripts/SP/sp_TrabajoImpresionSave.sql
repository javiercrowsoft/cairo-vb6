if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TrabajoImpresionSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TrabajoImpresionSave]

/*

*/

go
create procedure sp_TrabajoImpresionSave (
	@@timp_id 			int,
	@@timp_creado 	datetime,
	@@timp_pc 			varchar(255),
	@@timp_estado 	tinyint,
	@@tbl_id 				int,
	@@doc_id 				int,
	@@id 						int,
	@@us_id					int,
	@@emp_id				int,
  @@timp_sendByEmail tinyint = 0,
	@@timp_emailSubject varchar(1000) = '',
  @@timp_emailBody varchar(5000) = ''
)
as

begin

	if @@timp_id = 0 begin

		-- email address
		--
			declare @emailAdress varchar(1000)

			if @@timp_sendByEmail <> 0 and @@doc_id is not null begin

				declare @doct_id int

				select @doct_id = doct_id from Documento where doc_id = @@doc_id

				if @doct_id in (1,7,9) begin
					select @emailAdress = cli_email
					from FacturaVenta fv inner join Cliente cli on fv.cli_id = cli.cli_id
					where fv.fv_id = @@id
				end

			end

			set @emailAdress = isnull(@emailAdress, '')
		--
		-- end email address

		exec sp_dbgetnewid 'TrabajoImpresion', 'timp_id', @@timp_id out, 0

		insert into TrabajoImpresion (timp_id, timp_creado, timp_pc, timp_estado, tbl_id, doc_id, id, us_id, emp_id, timp_sendByEmail, timp_emailAddress, timp_emailSubject, timp_emailBody)
												  values (@@timp_id, @@timp_creado, @@timp_pc, @@timp_estado, @@tbl_id, @@doc_id, @@id, @@us_id, @@emp_id, @@timp_sendByEmail, @emailAdress, @@timp_emailSubject, @@timp_emailBody)

	end else begin

		update TrabajoImpresion set timp_creado = @@timp_creado,
																timp_pc = @@timp_pc,
																timp_estado = @@timp_estado,
																tbl_id = @@tbl_id,
																doc_id = @@doc_id,
																id = @@id
		where timp_id = @@timp_id																

	end

	select @@timp_id as timp_id

end

go