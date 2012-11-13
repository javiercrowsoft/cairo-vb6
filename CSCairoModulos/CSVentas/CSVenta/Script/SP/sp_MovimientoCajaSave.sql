/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaSave]


/*

sp_MovimientoCajaSave 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_MovimientoCajaSave (
  @@mcj_id    int

)as 

begin

	set nocount on

	declare @mcj_nrodoc 	varchar(255)
	declare @cj_id 				int
	declare @mcj_tipo 		int	

	select 	@cj_id 			= cj_id, 
					@mcj_nrodoc = mcj_nrodoc,
					@mcj_tipo 	= mcj_tipo

	from MovimientoCaja where mcj_id = @@mcj_id

	if @mcj_nrodoc = '' begin

		select @mcj_nrodoc = max(convert(int,mcj_nrodoc)) 
		from MovimientoCaja 
		where cj_id = @cj_id
			and isnumeric(mcj_nrodoc)<>0
	
		if @mcj_nrodoc is null set @mcj_nrodoc = '1'
		else 									 set @mcj_nrodoc = convert(int,@mcj_nrodoc)+1
	
		set @mcj_nrodoc = right('00000000'+@mcj_nrodoc,8)

	end

	update MovimientoCaja 
		set mcj_numero = mcj_id, 
				mcj_nrodoc = @mcj_nrodoc 
	where mcj_id = @@mcj_id

	--/////////////////////////////////////////////////////////////////////////////////////////
	-- Asiento
	--

	-- Cuando se abre una caja se guarda el asiento de movimiento 
	-- de cuentas de fondos a cuentas de trabajo
	--
	if @mcj_tipo = 1 begin

		-- Tiene que ser el ultimo movimiento de esta caja
		--
		declare @last_mcj_id int

		select @last_mcj_id = max(mcj_id) from MovimientoCaja where cj_id = @cj_id
	
		if @last_mcj_id = @@mcj_id begin

			declare @bError smallint
		
			exec sp_MovimientoCajaSaveAsiento @@mcj_id, 1, @bError out
		
			if @bError <> 0 begin
		
				select 0 as success
				return
			end

		end

	end

	--/////////////////////////////////////////////////////////////////////////////////////////

	select 1 as success
	
end
go