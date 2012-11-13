if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaGetPartes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaGetPartes]

go

create procedure sp_HojaRutaGetPartes (
	@@fDesde 			datetime,
	@@fHasta 			datetime,
	@@cli_id 			varchar(255),
	@@tarest_id 	varchar(255),

	@@hr_id 			int
)
as

begin


	declare @cli_id int
	declare @tarest_id int
	
	declare @ram_id_Cliente int
	declare @ram_id_TareaEstado int
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	-- Por ahora no lo recibo
	-- ya que la interfaz me esta enviando un est_id y no un tarest_id
	--
	set @@tarest_id = 0

	exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
	exec sp_ArbConvertId @@tarest_id, @tarest_id out, @ram_id_TareaEstado out
	
	exec sp_GetRptId @clienteID out
	
	if @ram_id_Cliente <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
		end else 
			set @ram_id_Cliente = 0
	end
	
	if @ram_id_TareaEstado <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_TareaEstado, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_TareaEstado, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_TareaEstado, @clienteID 
		end else 
			set @ram_id_TareaEstado = 0
	end


		declare @prs_id			int
		declare @us_id			int
	
		select @prs_id = prs_id from HojaRuta where hr_id = @@hr_id
		select @us_id = us_id from Usuario where prs_id = @prs_id


		select 
						0  as hri_id,
						null hri_descrip,
						null ptd_id,
						null ptd_fechaini,
						null ptd_numero,
						null ptd_titulo,
						null cli_id,
						null ptd_cumplido,

						'ZZ-(FIN)' as cli_nombre,

						0 as hri_orden,
						0 as cobrar

union all
	
		select 
						0  as hri_id,
						left(replace(ptd_descrip,char(13)+char(10),' '),255) as hri_descrip,
						ptd_id,
						ptd_fechaini,
						ptd_numero,
						ptd_titulo,
						ptd.cli_id,
						case when ptd_cumplida = 3 then 1 else 0 end as ptd_cumplido,

						isnull(
						isnull(cli.cli_nombre,prov.prov_nombre) + ' - ' +
						case 
								 when clis.clis_calle <> '' then

											clis.clis_calle + ' ' +
											clis.clis_callenumero + ' ' +
											clis.clis_piso + ' ' +
											clis.clis_depto + ' (' +
											clis.clis_codpostal + ') ' +
											clis.clis_localidad + ' - ' +
											clis.clis_tel + ' - ' +
											clis.clis_contacto

								 when ptd.cli_id is not null then

											cli_calle + ' ' +
											cli_callenumero + ' ' +
											cli_piso + ' ' +
											cli_depto + ' (' +
											cli_codpostal + ') ' +
											cli_localidad + ' - ' +
											cli_tel + ' - ' +
											cli_contacto

								 else

											prov_calle + ' ' +
											prov_callenumero + ' ' +
											prov_piso + ' ' +
											prov_depto + ' (' +
											prov_codpostal + ') ' +
											prov_localidad + ' - ' +
											prov_tel + ' - ' +
											prov_contacto

						end,'Z-(sin cliente)') as cli_nombre,

						0 as hri_orden,
						0 as cobrar
	
		from ParteDiario ptd left join Cliente cli on ptd.cli_id = cli.cli_id

													 -- Sucursal de entrega del cliente
													 --
													 left  join ClienteSucursal clis on 	ptd.cli_id = clis.cli_id
															-- El codigo debe ser "e" para que el sistema la tome 
															-- como sucursal de entrega 
																														and clis_codigo = 'e' 

													left join Proveedor prov on ptd.prov_id = prov.prov_id
		where 

					ptd_fechaini between @@Fdesde and @@Fhasta

			and not exists(select * from HojaRutaItem where	hr_id = @@hr_id and ptd_id = ptd.ptd_id)
			and not exists(select * from HojaRutaItem hri inner join HojaRuta hr on hri.hr_id = hr.hr_id 
                     where hr_cumplida = 0
											 and ptd_id = ptd.ptd_id)

	and ptd_cumplida = 1

	--and 	(ptd.us_id_responsable = @us_id or ptd.us_id_responsable is null)
			
	and   (ptd.cli_id = @cli_id or @cli_id=0)
	and   (ptd.tarest_id = @tarest_id or @tarest_id=0)
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 28
	                  and  rptarb_hojaid = ptd.cli_id
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
	                  and  tbl_id = 2004
	                  and  rptarb_hojaid = ptd.tarest_id
								   ) 
	           )
	        or 
						 (@ram_id_TareaEstado = 0)
				 )
	

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

