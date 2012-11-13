if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOPMFChequeSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOPMFChequeSave]

/*

Graba los cheques de ordenes de pago y movimientos de fondo

*/

go
create procedure sp_DocOPMFChequeSave (
  @@bSuccess            int out,
  @@tipo                tinyint,
  @@cheq_id             int out,
  @@cheq_numerodoc      varchar(100),
  @@importe             decimal(18,6),
  @@importeOrigen       decimal(18,6),
  @@cheq_fechaCobro     datetime,
  @@cheq_fechaVto       datetime,
  @@descrip             varchar(5000),
  @@chq_id              int,
  @@opg_id              int,
  @@mf_id               int,
  @@dbco_id             int,
  @@cle_id              int,
	@@mon_id              int,
  @@prov_id             int,
  @@cue_id              int
)
as

begin

  set nocount on

set @@bSuccess = 0

declare @opgiTCheques 						tinyint set @opgiTCheques 	= 1
declare @opgiTChequesT            tinyint set @opgiTChequesT  = 6
declare @CheqPropio               tinyint set @CheqPropio     = 1

declare @bco_id              int
declare @cheq_numero         int

declare @emp_id              int
declare @cheq_fecha2 				 datetime

	-- Obtengo la empresa de este cheque
	--
	if IsNull(@@opg_id,0) <> 0
		select @emp_id = doc.emp_id 
		from OrdenPago opg inner join Documento doc on opg.doc_id = doc.doc_id 
		where opg_id = @@opg_id
	else
		if IsNull(@@mf_id,0) <> 0
			select @emp_id = doc.emp_id 
			from MovimientoFondo mf inner join Documento doc on mf.doc_id = doc.doc_id 
			where mf_id = @@mf_id	
		else
			if IsNull(@@dbco_id,0) <> 0
				select @emp_id = doc.emp_id 
				from DepositoBanco dbco inner join Documento doc on dbco.doc_id = doc.doc_id 
				where dbco_id = @@dbco_id

  -- Esto es aproposito, ya que los cheques propios que se utilizan para
  -- pagar a proveedores no estan asociados a ninguna cuenta contable
  --
  if exists(select * from Cheque where cheq_id = @@cheq_id and @@opg_id is not null)
    set @@cue_id = null

	else
		if exists(select * from Cheque 
							where cheq_id = @@cheq_id 
								and IsNull(mf_id,0) > IsNull(@@mf_id,0)
							)
			select @@cue_id = cue_id, @@mf_id = mf_id from Cheque where cheq_id = @@cheq_id 


	-- Si este renglon es un cheque lo doy de alta en la tabla Cheque
	--
	if @@tipo = @opgiTCheques or @@tipo = @opgiTChequesT begin

		-- Obtengo el banco
		--
		select @bco_id = bco_id from Cuenta inner join Chequera on Cuenta.cue_id = Chequera.cue_id where chq_id = @@chq_id

		-- Si es nuevo Insert
		--
		if @@cheq_id is null begin

			exec SP_DBGetNewId 'Cheque','cheq_id',@@cheq_id out,0
			if @@error <> 0 goto ControlError

			exec SP_DBGetNewId 'Cheque','cheq_numero',@cheq_numero out,0
			if @@error <> 0 goto ControlError
			
			exec sp_DocGetFecha2 @@cheq_fechaCobro,@cheq_fecha2 out, 1, @@cle_id
			if @@error <> 0 goto ControlError

			insert into Cheque (
														cheq_id,
														cheq_numero,
														cheq_numerodoc,
														cheq_importe,
														cheq_importeOrigen,
														cheq_tipo,
														cheq_fechaCobro,
														cheq_fechaVto,
														cheq_fecha2,
                            cheq_descrip,
                            chq_id,
														opg_id,
                            mf_id,
														dbco_id,
														cle_id,
														bco_id,
                            cue_id,
														mon_id,
                            prov_id,
														emp_id
													)
                  values  (
														@@cheq_id,
														@cheq_numero,
														@@cheq_numerodoc,
														@@importe,
														@@importeOrigen,
														@CheqPropio,
														@@cheq_fechaCobro,
														@@cheq_fechaVto,
														@cheq_fecha2,
                            @@descrip,
                            @@chq_id,
														@@opg_id,
                            @@mf_id,
														@@dbco_id,
														@@cle_id,
														@bco_id,
                            @@cue_id, 
														@@mon_id,
                            @@prov_id,
														@emp_id
													)
					if @@error <> 0 goto ControlError

				  exec sp_ChequeraSet @@chq_id, @@cheq_numerodoc
					if @@error <> 0 goto ControlError

    end else begin

			-- Cheque de tercero ya que no tiene chequera
			if @@chq_id is null begin

				update Cheque set 
														opg_id		= IsNull(@@opg_id,opg_id),
                            mf_id     = IsNull(@@mf_id,mf_id),
														dbco_id		= IsNull(@@dbco_id, dbco_id),
                            cue_id    = @@cue_id, 
                            prov_id   = IsNull(@@prov_id,prov_id)
				where cheq_id = @@cheq_id
				if @@error <> 0 goto ControlError

			-- Cheque propio 
			end else begin

				exec sp_DocGetFecha2 @@cheq_fechaCobro,@cheq_fecha2 out, 1, @@cle_id
				if @@error <> 0 goto ControlError

				-- Sino Update
				--
				update Cheque set 
														cheq_numerodoc					= @@cheq_numerodoc,
														cheq_importe						= @@importe,
														cheq_importeOrigen			= @@importeOrigen,
														cheq_tipo								= @CheqPropio,
														cheq_fechaCobro					= @@cheq_fechaCobro,
														cheq_fechaVto						= @@cheq_fechaVto,
														cheq_fecha2 						= @cheq_fecha2,
                            cheq_descrip            = @@descrip,
                            chq_id                  = @@chq_id, 
														opg_id									= IsNull(@@opg_id,opg_id),
                            mf_id                   = IsNull(@@mf_id,mf_id),
                            dbco_id                 = IsNull(@@dbco_id,dbco_id),
														cle_id									= @@cle_id,
														bco_id									= @bco_id,
                            cue_id                  = @@cue_id,
														mon_id									= @@mon_id,
                            prov_id                 = IsNull(@@prov_id,prov_id)
				where cheq_id = @@cheq_id
				if @@error <> 0 goto ControlError
			end

    end

	end -- Fin cheque

  set @@bSuccess = 1

	return
ControlError:

  set @@bSuccess = 0

end
go