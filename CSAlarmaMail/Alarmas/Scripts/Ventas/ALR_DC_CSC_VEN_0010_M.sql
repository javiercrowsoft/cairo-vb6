/*
	Facturas con mas de 30 dias de vencidas
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ALR_DC_CSC_VEN_0010_M]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ALR_DC_CSC_VEN_0010_M]
go

/*

ALR_DC_CSC_VEN_0010_M

*/

create procedure ALR_DC_CSC_VEN_0010_M 

as 
begin

	set nocount on

	declare @alm_id int
	set @alm_id = 1

	declare @fecha datetime

	set @fecha = dateadd(d,-30,getdate())

	-- Obtengo la direccion de email
	--
	declare @mail_emailTo		varchar(1000)
	declare @mail_emailCc 	varchar(1000)
	declare @mail_id				int
	
	select @mail_emailTo = alm_mails from AlarmaMail where alm_id = @alm_id

	if exists(select * from Mail where mail_codigo = @mail_emailTo) begin

		select  @mail_emailTo = mail_emailTo,
					  @mail_emailCc = mail_emailCc,
						@mail_id		  = mail_id
		from Mail
		where mail_codigo = @mail_emailTo

	end

	-- Facturas Vencidas por mas de 30 dias
	--
	select 

				fvd.fvd_id 		as almr_id_mail,

				@mail_id		  as mail_id,
				null		  		as maili_id,
				@mail_emailTo as mail_emailTo,
			  @mail_emailCc as mail_emailCc,
				'Facturas Vencidas por mas de 30 dias'
											as almr_subject,

				 'La factura ' + fv_nrodoc 
			 + ' del cliente ' + cli_nombre 
			 + ' de fecha ' + convert(varchar(255),fv_fecha,103)
			 + ' y vencimiento el ' + convert(varchar(255),fvd_fecha,103)
       + ' ya posee ' + convert(varchar(255),datediff(d,fvd_fecha,getdate()))
			 + ' dias de vencida'
											as msg
				
	from (
				FacturaVentaDeuda fvd 
					inner join FacturaVenta fv 
							on 		fvd.fv_id = fv.fv_id
								and fvd_fecha < @fecha
				)
					inner join Cliente cli 		on fv.cli_id = cli.cli_id

	where not exists (select * from AlarmaMailResult where alm_id = @alm_id and almr_id_mail = fvd.fvd_id)
end

go