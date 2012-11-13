SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[frRecibo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frRecibo]
GO

CREATE procedure frRecibo (

	@@cobz_id			int

)as 

begin

declare @efectivo    decimal(18,6)
declare @facturas    varchar(5000)
declare @fv_nrodoc   varchar(255)
declare @mon_nombre  varchar(255)
declare @mon_id      int
declare @mondef      int
declare @cotiz       decimal(18,3)
declare @importe     decimal(18,6)
declare @fv_id       int

select @mondef = mon_id from Moneda where mon_legal <> 0

set @facturas = ''

declare c_fac insensitive cursor 
	for select fv_nrodoc, m.mon_id, f.fv_id, mon_signo 
			from FacturaVenta f inner join FacturaVentaCobranza fc on f.fv_id = fc.fv_id
                          inner join Moneda m on f.mon_id = m.mon_id
			where cobz_id = @@cobz_id

open c_fac

fetch next from c_fac into @fv_nrodoc, @mon_id, @fv_id, @mon_nombre
while @@fetch_status=0
begin

	set @facturas = @facturas + @fv_nrodoc 

	--///////////////////////////////////////////////////////////////////////////////////
	if @mon_id <> @mondef begin

		
		select @cotiz = min(fvcobz_cotizacion)
		from 
					FacturaVenta f inner join FacturaVentaCobranza fc on f.fv_id 	= fc.fv_id
		where f.fv_id = @fv_id and cobz_id = @@cobz_id
		group by f.fv_id

		select @importe = sum(fvcobz_importeorigen) 
		from 
					FacturaVenta f inner join FacturaVentaCobranza fc on f.fv_id 	= fc.fv_id
		where f.fv_id = @fv_id and cobz_id = @@cobz_id
		group by f.fv_id


	--///////////////////////////////////////////////////////////////////////////////////
	end else begin

		select @importe = sum(fvcobz_importe) 
		from 
					FacturaVenta f inner join FacturaVentaCobranza fc on f.fv_id 	= fc.fv_id
		where f.fv_id = @fv_id and cobz_id = @@cobz_id
		group by f.fv_id
	
	end

	set	@facturas = @facturas + ' ' + @mon_nombre + ' '+ convert(varchar(30),convert(money,@importe),1)

	if @mon_id <> @mondef set @facturas = @facturas + ' x ' + convert(varchar(30),@cotiz)

	set @facturas = @facturas + char(10)+char(13)

	fetch next from c_fac into @fv_nrodoc, @mon_id, @fv_id, @mon_nombre
end
close c_fac
deallocate c_fac

if len(@facturas) > 2 
	set @facturas = substring(@facturas,1,len(@facturas)-2)

select @efectivo = sum(cobzi_importe) from CobranzaItem where cobz_id = @@cobz_id and cobzi_tipo = 2 -- efectivo

select
      c.cobz_id                   						  as cobz_id,
			cli_nombre      												  as Cliente,
      cli_calle + ' ' + cli_callenumero         as Direccion,
      cli_localidad                             as Localidad,
			cobz_fecha                                as Fecha,
      cli_tel                                   as Telefono,

			case cli_catfiscal
				when 1  then 'Responsable Inscripto'
				when 2  then 'Exento'
				when 3  then 'Responsable no Inscripto'
				when 8  then 'No Responsable'
				when 6  then 'Monotributo'
				when 4  then 'Consumidor Final'
				when 11 then 'Responsable Inscripto M'
        else ''
			end             									        as [Cond. IVA],
 			cli_cuit            							        as CUIT,
      ''				                                as Remito,
 			cobz_descrip      						   					as Descrip,
      bco_nombre                                as Banco,
			@efectivo                                 as Efectivo, 
			cheq_numerodoc   									        as [Nro. cheque],
			cheq_importe                 					    as Importe,

			case 
				when cli_catfiscal=1 or cli_catfiscal=11 then 'X'
        else ''
			end as ri,
			case cli_catfiscal
				when 3 then 'X'
        else ''
			end as rni,
			case cli_catfiscal
				when 8 then 'X'
        else ''
			end as noresp,
			case cli_catfiscal
				when 6 then 'X'
        else ''
			end as mono,
			case cli_catfiscal
				when 2 then 'X'
        else ''
			end as exento,
			case cli_catfiscal
				when 4 then 'X'
        else ''
			end as consfinal,
  		cobz_total					    as Total,
			@facturas               as Facturas,
			case 	
					when cobzi_tipo = 1 then														'Cheques'
					when cobzi_tipo = 2 then														'Efectivo'
					when cobzi_tipo = 4 and ci.ret_id is not null then 	'Retenciones'
					else 																								'Otros'
			end 							as Tipo,
			cobzi_importe,
			cobzi_porcretencion/100 as cobzi_porcretencion,
			case 
					when cobzi_fecharetencion <= '19000101' then cobz_fecha 
					else cobzi_fecharetencion 
			end 							as cobzi_fecharetencion,
			
			cobzi_nroretencion,
			ret_nombre

			from Cobranza c inner join Cliente 					on c.cli_id    = Cliente.cli_id

																									-- esto es para no presentar renglones 
																									-- por cuenta corriente ni efectivo
											left join CobranzaItem ci 	on 	c.cobz_id = ci.cobz_id
																									and ci.cobzi_tipo not in (2,5) 

																									-- el efectivo va sumarizado en una 
																									-- variable y la cuenta corriente
																									-- no debe figurar en el recibo


                      left join  Cheque ch        on ci.cheq_id  = ch.cheq_id
                      left join  Banco bco        on ch.bco_id   = bco.bco_id
											left join  Retencion ret    on ci.ret_id   = ret.ret_id
										
			where c.cobz_id = @@cobz_id

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


