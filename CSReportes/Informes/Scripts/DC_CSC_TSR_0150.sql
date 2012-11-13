/*---------------------------------------------------------------------
Nombre: Movimientos de Cheques
---------------------------------------------------------------------*/
/*

select cue_id,* from cheque where cheq_id = 9437

update cheque set cue_id = null where cheq_id = 9437

DC_CSC_TSR_0150 1, 
								'20000601', 
								'20100101',
								'0',
								'0',
								'0',
								'0',
								'0',
								'0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0150]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0150]

go
create procedure DC_CSC_TSR_0150 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cheq_id       varchar(255),
	@@cue_id		  	varchar(255),
	@@bco_id  			varchar(255),
	@@cli_id  			varchar(255),
	@@prov_id				varchar(255), 
	@@emp_id  			varchar(255)

)as 

begin

set nocount on

declare @bConCliente 		tinyint
declare @bConProveedor	tinyint

if @@cli_id  <> '0' set @bConCliente = 1
else								set @bConCliente = 0
if @@prov_id <> '0' set @bConProveedor = 1
else								set @bConProveedor = 0

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cheq_id  int
declare @cue_id 	int
declare @bco_id 	int
declare @cli_id 	int
declare @prov_id 	int
declare @emp_id 	int  

declare @ram_id_cheque    int
declare @ram_id_cuenta 		int
declare @ram_id_banco 		int
declare @ram_id_cliente   int
declare @ram_id_proveedor int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cheq_id, @cheq_id out, @ram_id_cheque out
exec sp_ArbConvertId @@cue_id, 	@cue_id out, 	@ram_id_cuenta out
exec sp_ArbConvertId @@bco_id, 	@bco_id out, 	@ram_id_banco out
exec sp_ArbConvertId @@cli_id, 	@cli_id out, 	@ram_id_cliente out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
exec sp_ArbConvertId @@emp_id, 	@emp_id out, 	@ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_cheque <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cheque, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cheque, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cheque, @clienteID 
	end else 
		set @ram_id_cheque = 0
end

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_banco <> 0 begin

--	exec sp_ArbGetGroups @ram_id_banco, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_banco, @clienteID 
	end else 
		set @ram_id_banco = 0
end

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
	end else 
		set @ram_id_proveedor = 0
end


if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

create table #t_dc_csc_tsr_0150 (cheq_id int not null)

-- cargo en esta tabla todos los cheques que cumplen con los filtros
--
	insert into #t_dc_csc_tsr_0150 (cheq_id)

	select distinct cheq.cheq_id

	from Cheque cheq left join CobranzaItem cobzi 		 on cheq.cheq_id  = cobzi.cheq_id
									 left join OrdenPagoItem opgi 		 on cheq.cheq_id  = opgi.opgi_id
									 left join MovimientoFondoItem mfi on cheq.cheq_id  = mfi.cheq_id
									 left join DepositoBancoItem dbcoi on cheq.cheq_id  = dbcoi.cheq_id
									 left join Cobranza cobz           on cobzi.cobz_id = cobz.cobz_id
									 left join OrdenPago opg           on opgi.opg_id 	= opg.opg_id
									 left join MovimientoFondo mf      on mfi.mf_id 		= mf.mf_id
									 left join DepositoBanco dbco      on dbcoi.dbco_id = dbco.dbco_id

									 left join Cuenta cuecobzi         on cobzi.cue_id     = cuecobzi.cue_id
									 left join Cuenta cuemfid          on mfi.cue_id_debe  = cuemfid.cue_id
									 left join Cuenta cuemfih          on mfi.cue_id_haber = cuemfih.cue_id
									 left join Cuenta cueopg           on opgi.cue_id      = cueopg.cue_id

	where cheq_fechacobro between @@Fini and @@Ffin

			and (
						exists(select * from EmpresaUsuario where emp_id = cheq.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = cheq.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

			and (cheq.cli_id is not null or @bConCliente = 0)
			and (cheq.prov_id is not null or @bConProveedor = 0)

			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */

			and   (cheq.cheq_id = @cheq_id 	or @cheq_id=0)

			and   (		 cheq.cue_id 			= @cue_id 	
							or cobzi.cue_id     = @cue_id
							or mfi.cue_id_debe 	= @cue_id 	
							or mfi.cue_id_haber = @cue_id
							or opgi.cue_id 			= @cue_id
							or dbco.cue_id 			= @cue_id
							or @cue_id					= 0
						)

			and   (		 cheq.bco_id 			= @bco_id 	
							or cuecobzi.bco_id  = @bco_id
							or cuemfid.bco_id   = @bco_id
							or cuemfih.bco_id   = @bco_id
							or cueopg.bco_id    = @bco_id
							or dbco.bco_id      = @bco_id
							or @bco_id					= 0
						)

			and   (cheq.cli_id 	= @cli_id 	or @cli_id  =0)
			and   (cheq.prov_id = @prov_id 	or @prov_id =0)
			and   (cheq.emp_id  = @emp_id 	or @emp_id  =0) 
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 18001 
			                  and  rptarb_hojaid = cheq.cheq_id
										   ) 
			           )
			        or 
								 (@ram_id_cheque = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 17 

												and   (		 cheq.cue_id 			= rptarb_hojaid
																or cobzi.cue_id     = rptarb_hojaid
																or mfi.cue_id_debe 	= rptarb_hojaid
																or mfi.cue_id_haber = rptarb_hojaid
																or opgi.cue_id 			= rptarb_hojaid
																or dbco.cue_id 			= rptarb_hojaid
															)
										   ) 
			           )
			        or 
								 (@ram_id_cuenta = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 13 

												and   (		 cheq.bco_id 			= rptarb_hojaid 	
																or cuecobzi.bco_id  = rptarb_hojaid
																or cuemfid.bco_id   = rptarb_hojaid
																or cuemfih.bco_id   = rptarb_hojaid
																or cueopg.bco_id    = rptarb_hojaid
																or dbco.bco_id      = rptarb_hojaid
																or @bco_id					= 0
															)
										   ) 
			           )
			        or 
								 (@ram_id_banco = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 29 
			                  and  rptarb_hojaid = cheq.prov_id
										   ) 
			           )
			        or 
								 (@ram_id_proveedor = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 28 
			                  and  rptarb_hojaid = cheq.cli_id
										   ) 
			           )
			        or 
								 (@ram_id_cliente = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1018 
			                  and  rptarb_hojaid = cheq.emp_id
										   ) 
			           )
			        or 
								 (@ram_id_Empresa = 0)
						 )
			
/*- ///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

	select cheq.cheq_id,
				 cobz.doct_id     as doct_id,
				 cobz.cobz_id     as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105)+ ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Cobranza'     	as Transaccion,
				 cobz_nrodoc			as Comprobante,
				 cobz_fecha     	as Fecha,
				 est_nombre       as Estado,
				 cli_nombre				as Cliente,
				 ''               as Proveedor,
				 bco.bco_nombre   as Banco,
				 cue_nombre       as Cuenta,
				 ''             	as Origen,
				 cobz.modificado  as Modificado

	from Cheque cheq inner join CobranzaItem cobzi 		 on cheq.cheq_id  = cobzi.cheq_id
									 inner join Cobranza cobz          on cobzi.cobz_id = cobz.cobz_id
									 inner join Estado est             on cobz.est_id   = est.est_id
									 inner join Cliente cli            on cobz.cli_id   = cli.cli_id
									 inner join Cuenta cue             on cobzi.cue_id  = cue.cue_id
									 left  join Banco bco              on cue.bco_id    = bco.bco_id
									 left  join Banco bcoch            on cheq.bco_id   = bcoch.bco_id
									 left  join Empresa emp            on cheq.emp_id   = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)

	union all

	select cheq.cheq_id,
				 opg.doct_id      as doct_id,
				 opg.opg_id       as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105)+ ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Orden de Pago'  as Transaccion,
				 opg_nrodoc     	as Comprobante,
				 opg_fecha				as Fecha,
				 est_nombre       as Estado,
				 ''       				as Cliente,
				 prov_nombre      as Proveedor,
				 ''               as Banco,
				 ''               as Cuenta,
				 ''             	as Origen,
				 opg.modificado   as Modificado

	from Cheque cheq inner join OrdenPagoItem opgi 		 on cheq.cheq_id  = opgi.cheq_id
									 inner join OrdenPago opg          on opgi.opg_id 	= opg.opg_id
									 inner join Estado est             on opg.est_id    = est.est_id
									 inner join Proveedor prov         on opg.prov_id   = prov.prov_id
									 left  join Banco bcoch            on cheq.bco_id   = bcoch.bco_id
									 left  join Empresa emp            on cheq.emp_id   = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)

	union all

	select cheq.cheq_id,
				 mf.doct_id     	as doct_id,
				 mf.mf_id       	as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105)+ ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Movimiento'   	as Transaccion,
				 mf_nrodoc      	as Comprobante,
				 mf_fecha       	as Fecha,
				 est_nombre     	as Estado,
				 ''      					as Cliente,
				 ''             	as Proveedor,
				 bco.bco_nombre   as Banco,
				 cued.cue_nombre	as Cuenta,
				 cueh.cue_nombre	as Origen,
				 mf.modificado  	as Modificado

	from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id  = mfi.cheq_id
									 inner join MovimientoFondo mf      on mfi.mf_id 		 = mf.mf_id
									 inner join Estado est              on mf.est_id     = est.est_id
									 left  join Cliente cli             on mf.cli_id     = cli.cli_id
									 inner join Cuenta cued             on mfi.cue_id_debe    = cued.cue_id
									 inner join Cuenta cueh             on mfi.cue_id_haber   = cueh.cue_id
									 left  join Banco bco               on cued.bco_id   = bco.bco_id
									 left  join Banco bcoch             on cheq.bco_id   = bcoch.bco_id
									 left  join Empresa emp             on cheq.emp_id   = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)


	union all

	select cheq.cheq_id,
				 dbco.doct_id     as doct_id,
				 dbco.dbco_id     as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105) + ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Deposito'     	as Transaccion,
				 dbco_nrodoc    	as Comprobante,
				 dbco_fecha     	as Fecha,
				 est_nombre       as Estado,
				 ''      				  as Cliente,
				 ''               as Proveedor,
				 bco.bco_nombre   as Banco,
				 cue_nombre       as Cuenta,
				 ''             	as Origen,
				 dbco.modificado  as Modificado

	from Cheque cheq inner join DepositoBancoItem dbcoi on cheq.cheq_id  = dbcoi.cheq_id
									 inner join DepositoBanco dbco      on dbcoi.dbco_id = dbco.dbco_id
									 inner join Estado est              on dbco.est_id   = est.est_id
									 inner join Cuenta cue              on dbco.cue_id   = cue.cue_id
									 left  join Banco bco               on cue.bco_id    = bco.bco_id
									 left  join Banco bcoch             on cheq.bco_id   = bcoch.bco_id
									 left  join Empresa emp             on cheq.emp_id   = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)

	union all

	select cheq.cheq_id,
				 fc.doct_id     	as doct_id,
				 fc.fc_id     		as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105) + ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Rechazo'     	  as Transaccion,
				 fc_nrodoc    	  as Comprobante,
				 fc_fecha     	  as Fecha,
				 est_nombre       as Estado,
				 ''      				  as Cliente,
				 prov_nombre      as Proveedor,
				 ''               as Banco,
				 ''               as Cuenta,
				 ''             	as Origen,
				 fc.modificado  as Modificado

	from Cheque cheq inner join FacturaCompra fc on cheq.fc_id_nd1 = fc.fc_id
									 inner join Proveedor prov   on fc.prov_id 		 = prov.prov_id
									 inner join Estado est       on fc.est_id      = est.est_id
									 left  join Banco bcoch      on cheq.bco_id    = bcoch.bco_id
									 left  join Empresa emp      on cheq.emp_id    = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)

	union all

	select cheq.cheq_id,
				 fc.doct_id       as doct_id,
				 fc.fc_id     		as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105) + ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Rechazo'     	  as Transaccion,
				 fc_nrodoc    	  as Comprobante,
				 fc_fecha     	  as Fecha,
				 est_nombre       as Estado,
				 ''      				  as Cliente,
				 prov_nombre      as Proveedor,
				 ''               as Banco,
				 ''               as Cuenta,
				 ''             	as Origen,
				 fc.modificado  as Modificado

	from Cheque cheq inner join FacturaCompra fc on cheq.fc_id_nd2 = fc.fc_id
									 inner join Proveedor prov   on fc.prov_id 		 = prov.prov_id
									 inner join Estado est       on fc.est_id      = est.est_id
									 left  join Banco bcoch      on cheq.bco_id    = bcoch.bco_id
									 left  join Empresa emp      on cheq.emp_id    = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)

	union all

	select cheq.cheq_id,
				 fv.doct_id       as doct_id,
				 fv.fv_id     		as comp_id,
				 cheq_numero			as Numero,
				 cheq_numerodoc		as Cheque,
				 bcoch.bco_nombre + ' a cobrar el ' +
				 convert(varchar(12),cheq_fechacobro,105) + ' $' +
				 convert(varchar,convert(decimal(18,2),cheq_importe)) +
				 case when cheq_anulado<>0   then ' Anulado'   else '' end +
				 case when cheq_rechazado<>0 then ' Rechazado' else '' end
													as Detalle,
				 cheq_fechacobro  as [Fecha Cobro],

				 emp_nombre       as Empresa,
				 'Rechazo'     	  as Transaccion,
				 fv_nrodoc    	  as Comprobante,
				 fv_fecha     	  as Fecha,
				 est_nombre       as Estado,
				 cli_nombre			  as Cliente,
				 ''               as Proveedor,
				 ''               as Banco,
				 ''               as Cuenta,
				 ''             	as Origen,
				 fv.modificado  as Modificado

	from Cheque cheq inner join FacturaVenta fv on cheq.fv_id_nd = fv.fv_id
									 inner join Cliente cli     on fv.cli_id 		 = cli.cli_id
									 inner join Estado est      on fv.est_id     = est.est_id
									 left  join Banco bcoch     on cheq.bco_id   = bcoch.bco_id
									 left  join Empresa emp     on cheq.emp_id   = emp.emp_id

	where cheq_fechacobro between @@Fini and @@Ffin
		
		and cheq.cheq_id in (
					select cheq_id from #t_dc_csc_tsr_0150 --cheque cheq 
					--where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
					)

	order by emp_nombre,
					 cheq_numerodoc,
					 Fecha,
					 Transaccion
					 


-- 	select cheq.cheq_id,
-- 				 cheq_numero		as Numero,
-- 				 cheq_numerodoc	as Cheque,
-- 				 cobz_nrodoc		as Cobranza,
-- 				 cobz_fecha     as [Fecha Cobranza],
-- 				 opg_nrodoc     as [Orden de Pago],
-- 				 opg_fecha			as [Fecha Pago],
-- 				 mf_nrodoc      as [Movimiento de Fondos],
-- 				 mf_fecha       as [Fecha Movimiento],
-- 				 dbco_nrodoc    as Deposito,
-- 				 dbco_fecha     as [Fecha Deposito]
-- 
-- 	from Cheque cheq left join CobranzaItem cobzi 		 on cheq.cheq_id  = cobzi.cheq_id
-- 									 left join OrdenPagoItem opgi 		 on cheq.cheq_id  = opgi.opgi_id
-- 									 left join MovimientoFondoItem mfi on cheq.cheq_id  = mfi.cheq_id
-- 									 left join DepositoBancoItem dbcoi on cheq.cheq_id  = dbcoi.cheq_id
-- 									 left join Cobranza cobz           on cobzi.cobz_id = cobz.cobz_id
-- 									 left join OrdenPago opg           on opgi.opg_id 	= opg.opg_id
-- 									 left join MovimientoFondo mf      on mfi.mf_id 		= mf.mf_id
-- 									 left join DepositoBanco dbco      on dbcoi.dbco_id = dbco.dbco_id
-- 
-- 	where cheq_fechacobro between @@Fini and @@Ffin
-- 		
-- 		and cheq.cheq_id in (
-- 					select cheq_id from cheque cheq 
-- 					where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
-- 					)
-- 
-- 	order by cheq_numerodoc,
-- 					 isnull(isnull(isnull(cobz_fecha,opg_fecha),mf_fecha),dbco_fecha)

/*
 					select cheq_id from cheque cheq 
 					where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)
*/

end

go