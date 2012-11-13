if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_pedidoVentaSaveGetCliIdCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_pedidoVentaSaveGetCliIdCairo]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_pedidoVentaSaveGetCliId  3

create procedure sp_srv_cvxi_pedidoVentaSaveGetCliIdCairo (
	@@cmie_id 				int,
	@@cmi_id					int,
	@@cli_id          int out
)
as

set nocount on

begin

			-- Obtengo el codigo del cliente desde el apodo del comprador
			--
			declare @codigo_cliente varchar(255)
			select @codigo_cliente = cmiei_valor 
			from ComunidadInternetMailItem cmiei 
							inner join ComunidadInternetTextoItem cmiti 
								on cmiei.cmiti_id = cmiti.cmiti_id
			where cmie_id = @@cmie_id 
				and cmiti_codigomacro = '@@apodo'

			-- Casos especiales
			--
			-- Los tratamientos especiales sobre el apdodo se resuelven en este sp
			-- ya que no hay un mejor punto dentro del diseño que este.
			--	
			-- Ventajas: No es necesario recompilar
			--           El tratamiento del codigo del apodo esta justo donde se
			--           utiliza dicho apodo
			--
			-- Desventajas: El codigo deja de ser generico para tener conocimiento
			--              de las particularidades de una comunidad
			--
			-- 
			-- Caso 1: Apodo de MercadoLibre
			--
			--						Este apodo contiene las calificaciones ejemplo: 
			-- 																															 ALICETHECOOP (10)
			-- 																															 BIBIANA_VAZQUEZ (161)
			-- 																															 EURIALES (120)
			-- 																															 ARIEL_1969_MF (7)
			--
			--
			if @@cmi_id = 1 begin -- 1 es MercadoLibre

					declare @n int
					declare @codigo_real varchar(255)

					set @n = len(@codigo_cliente)
					set @codigo_real = ''

					while @n > 1 and @codigo_real = ''
					begin
						if substring(@codigo_cliente,@n,1) = '(' begin
							set @codigo_real = substring(@codigo_cliente,1,@n-1)
						end
						set @n = @n-1
					end

					if @codigo_real <> '' set @codigo_cliente = rtrim(ltrim(@codigo_real))

			end
			-- Fin casos especiales
			------------------------------------------------------------------------

			------------------------------------------------------------------------
			-- Prefijos de comunidades
			--
			-- Los clientes van prefijados segun su comunidad
			--
			if @@cmi_id = 1 -- 1 es MercadoLibre

					set @codigo_cliente = '(ML)#'+ @codigo_cliente

			else if @@cmi_id = 2 -- 2 es MasOportunidades

					set @codigo_cliente = '(MO)#'+ @codigo_cliente

			-- Fin casos especiales
			------------------------------------------------------------------------

			------------------------------------------------------------------------
			-- Busco el cliente asociado al apodo de la comprador en la comunidad

			declare @cli_id int

			select @cli_id = cli_id from Cliente where cli_codigo = @codigo_cliente

			-- Si no lo encontre lo doy de alta
			--
			if @cli_id is null begin

				-- Nombre
				declare @cli_nombre varchar(255)
				select @cli_nombre = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@nombre_comprador'

				-- Telefono
				declare @cli_telefono varchar(255)
				select @cli_telefono = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@telefono_comprador'

				-- Interno
				declare @cli_interno varchar(255)
				select @cli_interno = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@tel_interno_comprador'

				-- Email
				declare @cli_email varchar(255)
				select @cli_email = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@email_comprador'

				-- Ciudad
				declare @cli_ciudad varchar(255)
				select @cli_ciudad = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@ciudad_comprador'

				-- Provincia
				declare @cli_provincia varchar(255)
				select @cli_provincia = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@provincia_comprador'

				-- Pais
				declare @cli_pais varchar(255)
				select @cli_pais = cmiei_valor 
				from ComunidadInternetMailItem cmiei 
								inner join ComunidadInternetTextoItem cmiti 
									on cmiei.cmiti_id = cmiti.cmiti_id
				where cmie_id = @@cmie_id 
					and cmiti_codigomacro = '@@pais_comprador'


				declare @lp_id int
				declare @ld_id int
	
				select @lp_id = lp_id, @ld_id = ld_id from ComunidadInternet where cmi_id = @@cmi_id

				if @lp_id is null begin

					declare @cfg_valor varchar(5000)
					exec sp_Cfg_GetValor 'Ventas-General', 'ClientesPVlp_id', @cfg_valor out

					set @cfg_valor = isnull(@cfg_valor,'0')
					if isnumeric(@cfg_valor)<> 0 begin

						set @lp_id = convert(int,@cfg_valor)
						if not exists(select * from ListaPrecio where lp_id = @lp_id and lp_tipo = 1)
							set @lp_id = null

					end
				end

				exec sp_dbgetnewid 'Cliente','cli_id',@cli_id out, 0

				insert into Cliente (

												cli_id
												,cli_nombre
												,cli_razonsocial
												,cli_codigo
												,cli_calle
												,cli_callenumero
												,cli_catfiscal
												,cli_chequeorden
												,cli_codpostal
												,cli_contacto
												,cli_creditoactivo
												,cli_creditoctacte
												,cli_creditototal
												,cli_cuit
												,cli_cuitexterior
												,cli_depto
												,cli_descrip
												,cli_deudactacte
												,cli_deudadoc
												,cli_deudamanifiesto
												,cli_deudaorden
												,cli_deudapackinglist
												,cli_deudapedido
												,cli_deudaremito
												,cli_deudatotal
												,cli_email
												,cli_esprospecto
												,cli_exigeProvincia
												,cli_exigeTransporte
												,cli_fax
												,cli_horario_m_desde
												,cli_horario_m_hasta
												,cli_horario_t_desde
												,cli_horario_t_hasta
												,cli_id_padre
												,cli_id_referido
												,cli_ingresosbrutos
												,cli_localidad
												,cli_messanger
												,cli_pciaTransporte
												,cli_piso
												,cli_tel
												,cli_web
												,cli_yahoo
												,clict_id
												,cpa_id
												,cpg_id
												,creado
												,ld_id
												,lp_id
												,pro_id
												,proy_id
												,trans_id
												,us_id
												,ven_id
												,zon_id
												,activo
												,modificado
												,modifico
											)

							values (
												@cli_id
												,@cli_nombre
												,'CONSUMIDOR FINAL'
												,@codigo_cliente
												,''--cli_calle
												,''--cli_callenumero
												,4 --cli_catfiscal
												,''--cli_chequeorden
												,''--cli_codpostal
												,''--cli_contacto
												,0--cli_creditoactivo
												,0--cli_creditoctacte
												,0--cli_creditototal
												,''--cli_cuit
												,''--cli_cuitexterior
												,''--cli_depto
												, 'Ciudad ' + isnull(@cli_ciudad,'') 
												 +'Provincia ' + isnull(@cli_ciudad,'') 
												 +'Pais ' + isnull(@cli_ciudad,'') --cli_descrip
												,0--cli_deudactacte
												,0--cli_deudadoc
												,0--cli_deudamanifiesto
												,0--cli_deudaorden
												,0--cli_deudapackinglist
												,0--cli_deudapedido
												,0--cli_deudaremito
												,0--cli_deudatotal
												,@cli_email--cli_email
												,0--cli_esprospecto
												,0--cli_exigeProvincia
												,0--cli_exigeTransporte
												,''--cli_fax
												,'00:00:00' --cli_horario_m_desde
												,'00:00:00' --cli_horario_m_hasta
												,'00:00:00' --cli_horario_t_desde
												,'00:00:00' --cli_horario_t_hasta
												,null--cli_id_padre
												,null--cli_id_referido
												,''--cli_ingresosbrutos
												,@cli_ciudad--cli_localidad
												,''--cli_messanger
												,''--cli_pciaTransporte
												,''--cli_piso
												,case 
													when isnull(@cli_interno,'') <> '' 
																then 	isnull(@cli_telefono,'') + ' Interno ' + isnull(@cli_interno,'') 
													else 				isnull(@cli_telefono,'') 
												 end  --cli_tel
												,''--cli_web
												,''--cli_yahoo
												,null--clict_id
												,null--cpa_id
												,null--cpg_id
												,getdate()--creado
												,@ld_id--ld_id
												,@lp_id--lp_id
												,null--pro_id
												,null--proy_id
												,null--trans_id
												,null--us_id
												,null--ven_id
												,null--zon_id
												,1--activo
												,getdate()--modificado
												,1--modifico Administrador
											)

				if @lp_id is not null begin
					declare @lpcli_id int
					exec sp_dbgetnewid 'ListaPrecioCliente','lpcli_id',@lpcli_id out, 0

					insert into ListaPrecioCliente (lpcli_id, lp_id, cli_id, modifico, creado, modificado) 
					values (@lpcli_id, @lp_id, @cli_id, 1, getdate(), getdate())
				end

				if @ld_id is not null begin
					declare @ldcli_id int
					exec sp_dbgetnewid 'ListaDescuentoCliente','ldcli_id',@ldcli_id out, 0

					insert into ListaDescuentoCliente (ldcli_id, ld_id, cli_id, modifico, creado, modificado) 
					values (@ldcli_id, @ld_id, @cli_id, 1, getdate(), getdate())
				end

				-- Empresa y Cliente
				--
				declare @emp_id int
				declare @empcli_id int

				select @emp_id = emp_id 
				from ComunidadInternet cmi inner join Documento doc on cmi.doc_id = doc.doc_id
				where cmi_id = @@cmi_id

		  	exec sp_dbgetnewid 'EmpresaCliente','empcli_id',@empcli_id out, 0
		  
				insert into EmpresaCliente (empcli_id, emp_id, cli_id, modifico) values (@empcli_id, @emp_id, @cli_id, 1)  

			end

			set @@cli_id = @cli_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



