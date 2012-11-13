if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaGetFacturas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaGetFacturas]

go

create procedure sp_HojaRutaGetFacturas (
	@@fDesde datetime,
	@@fHasta datetime,
	@@cli_id varchar(255),
	@@est_id varchar(255),

	@@hr_id int
)
as

begin

-- 	declare @hoy datetime
-- 
-- 	set @hoy = getdate()
-- 	set @hoy = dateadd(hh,-datepart(hh,@hoy),@hoy)
-- 	set @hoy = dateadd(n,-datepart(n,@hoy),@hoy)
-- 	set @hoy = dateadd(s,-datepart(s,@hoy),@hoy)
-- 	set @hoy = dateadd(ms,-datepart(ms,@hoy),@hoy)

	declare @cli_id int
	declare @est_id int
	
	declare @ram_id_Cliente int
	declare @ram_id_Estado int
	
	declare @clienteID int
	declare @IsRaiz    tinyint

	-- Me guardo el DATEFIRST original
	--
	declare @oldDateFirst int
	set @oldDateFirst = @@DATEFIRST 

	declare @hoy int
	declare @very_old datetime

	-- Obtenemos el dia de la semana
	-- para esta fecha
	--
	set datefirst 1 
	set @hoy = datepart(dw,getdate())
	set datefirst @oldDateFirst			  

	declare @Fhasta datetime
	set @Fhasta = dateadd(d,1,@@Fhasta)
	set @very_old = dateadd(d,-10,@@Fhasta)
	exec sp_DocGetFecha2 @Fhasta, @Fhasta out, 0, null
	
	exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
	exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
	
	exec sp_GetRptId @clienteID out
	
	if @ram_id_Cliente <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
		end else 
			set @ram_id_Cliente = 0
	end
	
	if @ram_id_Estado <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
		end else 
			set @ram_id_Estado = 0
	end
	
		select 
						0  as hri_id,
						0  as hri_importe,
						0  as hri_cobrado,
						0  as hri_acobrar,
						'' as hri_descrip,
						fv_id,
						fv_fecha,
						fv_nrodoc,
						fv_total,
						fv_pendiente,
						fv.cli_id,
						fv.doct_id,

						cli.cli_nombre + ' - ' +

						case
								 when clisfv.clis_calle <> '' then

											clisfv.clis_calle + ' ' +
											clisfv.clis_callenumero + ' ' +
											clisfv.clis_piso + ' ' +
											clisfv.clis_depto + ' (' +
											clisfv.clis_codpostal + ') ' +
											clisfv.clis_localidad + ' - ' +
											clisfv.clis_tel + ' - ' +
											clisfv.clis_contacto
 
								 when clis.clis_calle <> '' then

											clis.clis_calle + ' ' +
											clis.clis_callenumero + ' ' +
											clis.clis_piso + ' ' +
											clis.clis_depto + ' (' +
											clis.clis_codpostal + ') ' +
											clis.clis_localidad + ' - ' +
											clis.clis_tel + ' - ' +
											clis.clis_contacto

								 else

											cli_calle + ' ' +
											cli_callenumero + ' ' +
											cli_piso + ' ' +
											cli_depto + ' (' +
											cli_codpostal + ') ' +
											cli_localidad + ' - ' +
											cli_tel + ' - ' +
											cli_contacto

						end as cli_nombre,

						0 as hri_orden,
						0 as cobrar,

						case
							when fv_fechavto > '19900101' then 1
							when
											((@hoy = 5 or @hoy = 1) and fp_lunes <> 0)
									or  ((@hoy = 1 or @hoy = 2) and fp_martes <> 0)
									or  ((@hoy = 2 or @hoy = 3) and fp_miercoles <> 0)
									or  ((@hoy = 3 or @hoy = 4) and fp_jueves <> 0)
									or  ((@hoy = 4 or @hoy = 5) and fp_viernes <> 0)
									or  ((@hoy = 5 or @hoy = 6) and fp_sabado <> 0)
									or  (@hoy = 6 and fp_domingo <> 0)
								
								then 1
							when fv_fecha < @very_old then 1
							else 0
						end	as iluminar
	
		from FacturaVenta fv inner join Cliente cli on fv.cli_id = cli.cli_id

													 -- Sucursal de entrega del cliente
													 --
													 left  join ClienteSucursal clis on 	fv.cli_id = clis.cli_id
															-- El codigo debe ser "e" para que el sistema la tome 
															-- como sucursal de entrega 
																														and clis_codigo = 'e' 
															-- El documento no debe indicar una sucursal
																														and fv.clis_id is null 

													 -- Sucursal explicitamente indicada en la orden de servicio
													 --
													 left  join ClienteSucursal clisfv on fv.clis_id = clisfv.clis_id
													 left  join FormaPago fp on cli.fp_id = fp.fp_id

		where 
					fv.est_id <> 7

			and (			(				fv_fecha <= @Fhasta 
										and fv_fechavto < '19900101'
								)
						or (				fv_fechavto <= @Fhasta 
										and fv_fechavto > '19900101'
								)
						or (
											((@hoy = 5 or @hoy = 1) and fp_lunes <> 0)
									or  ((@hoy = 1 or @hoy = 2) and fp_martes <> 0)
									or  ((@hoy = 2 or @hoy = 3) and fp_miercoles <> 0)
									or  ((@hoy = 3 or @hoy = 4) and fp_jueves <> 0)
									or  ((@hoy = 4 or @hoy = 5) and fp_viernes <> 0)
									or  ((@hoy = 5 or @hoy = 6) and fp_sabado <> 0)
									or  (@hoy = 6 and fp_domingo <> 0)
								
								)
					)

			and fv_pendiente <> 0

			and not exists(select * from HojaRutaItem where	hr_id = @@hr_id and fv_id = fv.fv_id)
			and not exists(select * from HojaRutaItem hri inner join HojaRuta hr on hri.hr_id = hr.hr_id 
                     where hr_cumplida = 0
											 and fv_id = fv.fv_id)
			
	and   (fv.cli_id = @cli_id or @cli_id=0)
	and   (fv.est_id = @est_id or @est_id=0)
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 28
	                  and  rptarb_hojaid = fv.cli_id
								   ) 
	           )
	        or 
						 (@ram_id_Cliente = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 4005
	                  and  rptarb_hojaid = fv.est_id
								   ) 
	           )
	        or 
						 (@ram_id_Estado = 0)
				 )
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

