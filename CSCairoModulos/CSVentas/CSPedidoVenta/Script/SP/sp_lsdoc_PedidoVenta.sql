
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PedidoVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PedidoVenta]

-- sp_lsdoc_PedidoVenta 1

go
create procedure sp_lsdoc_PedidoVenta (

	@@pv_id int

)as 

begin

	set nocount on

	create table #t_preguntas (pv_id int, preguntas varchar(7000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL)
	
	declare c_preguntas insensitive cursor for 
	
		select pv.pv_id, cmip_pregunta, cmip_respuesta 
		from PedidoVenta pv
												inner join Cliente cli on pv.cli_id = cli.cli_id 
												inner join ComunidadInternetPregunta cmip 
												on replace(cli_codigocomunidad,'(ML)#','') = cmip_nick
		where pv.pv_id = @@pv_id
		order by pv.pv_id
	
	open c_preguntas
	
	declare @pv_id			int
	declare @last_pv_id int
	declare @pregunta		varchar(4000)
	declare @respuesta	varchar(4000)
	declare @preguntas  varchar(7000)
	
	set @last_pv_id = 0
	fetch next from c_preguntas into @pv_id, @pregunta, @respuesta
	while @@fetch_status=0
	begin

		if @last_pv_id <> @pv_id begin

			if @last_pv_id <> 0 begin
				insert into #t_preguntas (pv_id, preguntas) values (@pv_id, char(10)+char(13)+@preguntas)
			end
			
			set @preguntas = ''
			set @last_pv_id = @pv_id

		end

		set @preguntas = @preguntas + @pregunta + char(10)+char(13)

		if @respuesta <> '' set set @preguntas = @preguntas + 'Respuesta: ' + @respuesta + char(10)+char(13)
	
		fetch next from c_preguntas into @pv_id, @pregunta, @respuesta
	end
	
	close c_preguntas
	deallocate c_preguntas

	if @last_pv_id <> 0 begin
		insert into #t_preguntas (pv_id, preguntas) values (@pv_id, char(10)+char(13)+@preguntas)
	end
	
	select 
				pedidoventa.pv_id,
				''									  as [TypeTask],
				pv_numero             as [Número],
				pv_nrodoc						  as [Comprobante],
		    cli_nombre            as [Cliente],
				cli_codigo            as [Codigo],
				cli_codigocomunidad 	as [Codigo Com.],
				cli_email             as [Mail],
	      doc_nombre					  as [Documento],
		    est_nombre					  as [Estado],
				case pv_cvxi_calificado when 0 then 'No' else 'Si' end as Calificado,
				pv_fecha						  as [Fecha],
				pv_fechaentrega				as [Fecha de entrega],
				case impreso
					when 0 then 'No'
					else        'Si'
				end										as [Impreso],
				pv_neto								as [Neto],
				pv_ivari							as [IVA RI],
				pv_ivarni							as [IVA RNI],
				pv_subtotal						as [Subtotal],
				pv_total							as [Total],
				pv_pendiente					as [Pendiente],
				case pv_firmado
					when 0 then 'No'
					else        'Si'
				end										as [Firmado],
				
				pv_descuento1					as [% Desc. 1],
				pv_descuento2					as [% Desc. 2],
				pv_importedesc1				as [Desc. 1],
				pv_importedesc2				as [Desc. 2],
	
		    lp_nombre						  as [Lista de Precios],
		    ld_nombre						  as [Lista de descuentos],
		    cpg_nombre					  as [Condicion de Pago],
		    ccos_nombre					  as [Centro de costo],
	      suc_nombre					  as [Sucursal],
				emp_nombre            as [Empresa],
	
				PedidoVenta.Creado,
				PedidoVenta.Modificado,
				us_nombre             as [Modifico],
				pv_descrip + isnull(preguntas,'')
															as [Observaciones]
	from 
				pedidoventa inner join documento     on pedidoventa.doc_id   = documento.doc_id
									  inner join empresa       on documento.emp_id 		 = empresa.emp_id
	                  inner join condicionpago on pedidoventa.cpg_id   = condicionpago.cpg_id
										inner join estado        on pedidoventa.est_id   = estado.est_id
										inner join sucursal      on pedidoventa.suc_id   = sucursal.suc_id
	                  inner join cliente       on pedidoventa.cli_id   = cliente.cli_id
	                  inner join usuario       on pedidoventa.modifico = usuario.us_id
	                  left join vendedor       on pedidoventa.ven_id   = vendedor.ven_id
	                  left join centrocosto    on pedidoventa.ccos_id  = centrocosto.ccos_id
	                  left join listaprecio    on pedidoventa.lp_id    = listaprecio.lp_id
	  								left join listadescuento on pedidoventa.ld_id    = listadescuento.ld_id

										left join #t_preguntas t on pedidoventa.pv_id    = t.pv_id

	where @@pv_id = pedidoventa.pv_id

end

GO