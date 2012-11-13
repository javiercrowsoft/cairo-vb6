SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IC_NRT_frFacturaVentaResumido]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[IC_NRT_frFacturaVentaResumido]
GO

/*

IC_NRT_frFacturaVentaResumido 1093

select * from facturaventaitem where fv_id = 1093

*/

CREATE  procedure IC_NRT_frFacturaVentaResumido (

	@@fv_id			int

)as 

begin

	select 	FacturaVenta.doct_id,
					FacturaVenta.fv_id,
					fv_cotizacion,
					fv_descrip, 
					fv_fecha,
					sum(fvi_cantidad)					as fvi_cantidad, 
					sum(fvi_importe)
					/sum(fvi_cantidad)        as fvi_precio,
					sum(fvi_importe)					as fvi_importe,
					sum(fvi_importeOrigen)		as fvi_importeOrigen,
					sum(fvi_ivari)						as fvi_ivari,
					sum(fvi_ivarni)						as fvi_ivarni, 
					cue_nombre, 
					doc_nombre, 
					ccos_nombre, 
					cli_nombre, 
					cli_razonsocial,
					cpg_nombre, 
					cli_cuit,

			case cli_catfiscal
				when 1 then 'Inscripto'
				when 2 then 'Exento'
				when 3 then 'No inscripto'
				when 4 then 'Consumidor Final'
				when 5 then 'Extranjero'
				when 6 then 'Mono Tributo'
				when 7 then 'Extranjero Iva'
				when 8 then 'No responsable'
				when 9 then 'No Responsable exento'
				when 10 then 'No categorizado'
				when 11 then 'Inscripto M'
        else 'Sin categorizar'
			end as cat_fisctal,

			case cli_catfiscal
				when 1 then 'X'
				else ''
			end as inscripto,

			case cli_catfiscal
				when 2 then 'X'
				else ''
			end as exento,

			case cli_catfiscal
				when 3 then 'X'
				else ''
			end as noinscripto,

			case cli_catfiscal
				when 4 then 'X'
				else ''
			end as consumidorfinal,

			case cli_catfiscal
				when 5 then 'X'
				else ''
			end as extranjero,

			case cli_catfiscal
				when 6 then 'X'
				else ''
			end as monotributo,

			case cli_catfiscal
				when 7 then 'X'
				else ''
			end as extranjeroiva,

			case cli_catfiscal
				when 8 then 'X'
				else ''
			end as noresponsable,

			case cli_catfiscal
				when 9 then 'X'
				else ''
			end as norespexento,

			case cli_catfiscal
				when 10 then 'X'
				else ''
			end as nocategorizado,

			sum(
				case 
					when fvi_importe <> 0 and fvi_importeorigen <> 0 then  fvi_importeorigen / fvi_importe
          else  1
      	end
					)
			/ sum(fvi_cantidad) as coef,

			cli_calle as calle,

			cli_callenumero + ' ' +
			cli_piso + ' ' +
			cli_depto  as direccion,
      cli_localidad + 
			cli_codpostal 	as cli_localidad,
      lgj_codigo,
      pr_nombreventa,

			sum (
				case cli_catfiscal
					when 1 then       fvi_precio -- 'Inscripto'
					when 2 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Exento'
					when 3 then       fvi_precio -- 'No inscripto'
					when 4 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Consumidor Final' sp_col facturaventaitem
					when 5 then       fvi_precio -- 'Extranjero'
					when 6 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Mono Tributo'
					when 7 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Extranjero Iva'
					when 8 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'No responsable'
					when 9 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'No Responsable exento'
					when 10 then      fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'No categorizado'
	        else              fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Sin categorizar'
				end 
					) 
				/
				sum(fvi_cantidad) as precio,

			sum (
				case cli_catfiscal
					when 1 then       fvi_neto     -- 'Inscripto'
					when 2 then       fvi_importe  -- 'Exento'
					when 3 then       fvi_neto     -- 'No inscripto'
					when 4 then       fvi_importe  -- 'Consumidor Final' sp_col facturaventaitem
					when 5 then       fvi_neto     -- 'Extranjero'
					when 6 then       fvi_importe  -- 'Mono Tributo'
					when 7 then       fvi_importe  -- 'Extranjero Iva'
					when 8 then       fvi_importe  -- 'No responsable'
					when 9 then       fvi_importe  -- 'No Responsable exento'
					when 10 then      fvi_importe  -- 'No categorizado'
	        else              fvi_importe  -- 'Sin categorizar'
				end 
					) as importe,

			case cli_catfiscal
				when 1 then       1 -- 'Inscripto'
				when 2 then       0 -- 'Exento'
				when 3 then       1 -- 'No inscripto'
				when 4 then       0 -- 'Consumidor Final' sp_col facturaventaitem
				when 5 then       1 -- 'Extranjero'
				when 6 then       0 -- 'Mono Tributo'
				when 7 then       0 -- 'Extranjero Iva'
				when 8 then       0 -- 'No responsable'
				when 9 then       0 -- 'No Responsable exento'
				when 10 then      0 -- 'No categorizado'
        else              0 -- 'Sin categorizar'
			end as bShowIva

      

  from FacturaVenta inner join FacturaVentaItem on FacturaVenta.fv_id = FacturaVentaItem.fv_id
               inner join Cuenta        on FacturaVentaItem.cue_id		= Cuenta.cue_id
               inner join Documento     on FacturaVenta.doc_id        = Documento.doc_id
               inner join Cliente       on FacturaVenta.cli_id        = Cliente.cli_id
               inner join CondicionPago on FacturaVenta.cpg_id        = CondicionPago.cpg_id
               inner join Producto      on FacturaVentaItem.pr_id     = Producto.pr_id
               left join  Legajo        on FacturaVenta.lgj_id        = Legajo.lgj_id
							 left join  CentroCosto on FacturaVentaItem.ccos_id     = CentroCosto.ccos_id
	where FacturaVenta.fv_id = @@fv_id

	group by
					FacturaVenta.doct_id,
					FacturaVenta.fv_id,
					fv_cotizacion,
					fv_descrip, 
					fv_fecha,
					cue_nombre, 
					doc_nombre, 
					ccos_nombre, 
					cli_nombre, 
					cli_razonsocial,
					cpg_nombre, 
					cli_cuit,
					cli_catfiscal,
					cli_calle,
					cli_callenumero + ' ' +
					cli_piso + ' ' +
					cli_depto,
		      cli_localidad + 
					cli_codpostal,
		      lgj_codigo,
      		pr_nombreventa

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*---------------------------------------------------------------------
Nombre: Detalle de comprobantes de facuracion
---------------------------------------------------------------------*/
/*  

Para testear:
select * from documentotipo
frFacturaRemitoVentaResumen 1, '20050311','20050311','0', '0','0','0','0','0','0','0'
,'0','0', 1,'0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frFacturaRemitoVentaResumen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frFacturaRemitoVentaResumen]

go
create procedure frFacturaRemitoVentaResumen (

	@@fv_id  int

)as 
begin

set nocount on

select 
		rv.rv_id        as id,
		1               as tipo_id,
		cli_nombre			as Cliente,
		cli_codigo			as Codigo,
		doct_nombre			as Tipo,
		doc_nombre			as Documento,
		rv_nrodoc				as Comprobante,
		rv_fecha				as Fecha,
		cpg_nombre			as [Condicion de Pago],
		pr_nombreVenta  as Articulo,
		pr_codigo				as [Codigo Articulo],
		rvi_cantidad		as Cantidad,
		depl_nombre     as Deposito,
		rv_descuento1		as Descuento,
		case	
			when doct.doct_id = 24 then -rvi_precio 
		else rvi_precio
		end             as Precio,
		case	
			when doct.doct_id = 24 then -rvi_neto 
		else rvi_neto
		end             as Neto

from
	remitoVenta rv inner join cliente          cli  on rv.cli_id  = cli.cli_id
								 inner join condicionPago    cpg  on rv.cpg_id  = cpg.cpg_id
								 inner join remitoVentaItem  rvi  on rv.rv_id   = rvi.rv_id
								 inner join producto         pr   on rvi.pr_id  = pr.pr_id
								 inner join documentoTipo    doct on rv.doct_id = doct.doct_id
								 inner join documento        doc  on rv.doc_id  = doc.doc_id


                  inner join moneda    mon         on doc.mon_id  = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

									left join centroCosto ccos       on rvi.ccos_id = ccos.ccos_id
           	      left join provincia   pro        on cli.pro_id  = pro.pro_id
                  left join stock       st         on rv.st_id    = st.st_id
									left join depositoLogico depl		 on st.depl_id_origen = depl.depl_id
where 

	exists(select rvfv.rvi_id from RemitoFacturaVenta rvfv 
															inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
				 where fvi.fv_id = @@fv_id and rvi_id = rvi.rvi_id)

order by tipo_id, cliente, fecha, comprobante


end


go


if exists(select * from reporteformulario where rptf_id = 19) begin
update reporteformulario set rptf_id= 19,rptf_nombre= 'Factura',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 173,creado= '20060411 16:39:51',modificado= '20060918 14:25:21',modifico= 1,activo= 1 where rptf_id = 19
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (19,'Factura','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,173,'20060411 16:39:51','20060918 14:25:21',1,1)
end
if exists(select * from reporteformulario where rptf_id = 22) begin
update reporteformulario set rptf_id= 22,rptf_nombre= 'Factura',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 194,creado= '20060411 19:49:01',modificado= '20060426 14:33:33',modifico= 1,activo= 1 where rptf_id = 22
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (22,'Factura','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,194,'20060411 19:49:01','20060426 14:33:33',1,1)
end
if exists(select * from reporteformulario where rptf_id = 43) begin
update reporteformulario set rptf_id= 43,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 193,creado= '20060426 14:33:43',modificado= '20060426 14:32:38',modifico= 1,activo= 1 where rptf_id = 43
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (43,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,193,'20060426 14:33:43','20060426 14:32:38',1,1)
end
if exists(select * from reporteformulario where rptf_id = 44) begin
update reporteformulario set rptf_id= 44,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 175,creado= '20060426 14:34:13',modificado= '20060918 14:22:32',modifico= 1,activo= 1 where rptf_id = 44
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (44,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,175,'20060426 14:34:13','20060918 14:22:32',1,1)
end
if exists(select * from reporteformulario where rptf_id = 45) begin
update reporteformulario set rptf_id= 45,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 259,creado= '20060503 16:52:29',modificado= '20060915 13:41:59',modifico= 1,activo= 1 where rptf_id = 45
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (45,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,259,'20060503 16:52:29','20060915 13:41:59',1,1)
end
if exists(select * from reporteformulario where rptf_id = 47) begin
update reporteformulario set rptf_id= 47,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 266,creado= '20060512 11:46:15',modificado= '20060825 14:53:05',modifico= 1,activo= 1 where rptf_id = 47
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (47,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,266,'20060512 11:46:15','20060825 14:53:05',1,1)
end
if exists(select * from reporteformulario where rptf_id = 57) begin
update reporteformulario set rptf_id= 57,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 294,creado= '20060915 13:24:26',modificado= '20060915 13:28:41',modifico= 1,activo= 1 where rptf_id = 57
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (57,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,294,'20060915 13:24:26','20060915 13:28:41',1,1)
end
if exists(select * from reporteformulario where rptf_id = 58) begin
update reporteformulario set rptf_id= 58,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 295,creado= '20060915 13:25:04',modificado= '20060918 14:24:40',modifico= 1,activo= 1 where rptf_id = 58
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (58,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,295,'20060915 13:25:04','20060918 14:24:40',1,1)
end
if exists(select * from reporteformulario where rptf_id = 59) begin
update reporteformulario set rptf_id= 59,rptf_nombre= 'Factura',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 296,creado= '20060915 13:26:07',modificado= '20060915 13:30:22',modifico= 1,activo= 1 where rptf_id = 59
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (59,'Factura','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,296,'20060915 13:26:07','20060915 13:30:22',1,1)
end
if exists(select * from reporteformulario where rptf_id = 60) begin
update reporteformulario set rptf_id= 60,rptf_nombre= 'Factura',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 297,creado= '20060915 13:26:54',modificado= '20060918 14:25:16',modifico= 1,activo= 1 where rptf_id = 60
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (60,'Factura','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,297,'20060915 13:26:54','20060918 14:25:16',1,1)
end
GO
if exists(select * from reporteformulario where rptf_id = 63) begin
update reporteformulario set rptf_id= 63,rptf_nombre= 'Factura de Ventas',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 300,creado= '20060915 13:37:29',modificado= '20060915 13:41:44',modifico= 1,activo= 1 where rptf_id = 63
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (63,'Factura de Ventas','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,300,'20060915 13:37:29','20060915 13:41:44',1,1)
end
if exists(select * from reporteformulario where rptf_id = 68) begin
update reporteformulario set rptf_id= 68,rptf_nombre= 'Factura',rptf_csrfile= 'IC_NRT_frFacturaVenta.csr',rptf_tipo= 1,rptf_sugerido= 1,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 254,creado= '20060918 14:23:28',modificado= '20060918 14:23:27',modifico= 1,activo= 1 where rptf_id = 68
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (68,'Factura','IC_NRT_frFacturaVenta.csr',1,1,2,0,'',NULL,254,'20060918 14:23:28','20060918 14:23:27',1,1)
end

if exists(select * from reporteformulario where rptf_id = 64) begin
update reporteformulario set rptf_id= 64,rptf_nombre= 'Factura Resumida',rptf_csrfile= 'IC_NRT_frFacturaVentaResumido.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 173,creado= '20060918 14:08:55',modificado= '20060918 14:25:21',modifico= 1,activo= 1 where rptf_id = 64
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (64,'Factura Resumida','IC_NRT_frFacturaVentaResumido.csr',1,0,2,0,'',NULL,173,'20060918 14:08:55','20060918 14:25:21',1,1)
end
if exists(select * from reporteformulario where rptf_id = 66) begin
update reporteformulario set rptf_id= 66,rptf_nombre= 'Factura Resumida',rptf_csrfile= 'IC_NRT_frFacturaVentaResumido.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 175,creado= '20060918 14:22:32',modificado= '20060918 14:22:32',modifico= 1,activo= 1 where rptf_id = 66
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (66,'Factura Resumida','IC_NRT_frFacturaVentaResumido.csr',1,0,2,0,'',NULL,175,'20060918 14:22:32','20060918 14:22:32',1,1)
end
if exists(select * from reporteformulario where rptf_id = 69) begin
update reporteformulario set rptf_id= 69,rptf_nombre= 'Factura Resumida',rptf_csrfile= 'IC_NRT_frFacturaVentaResumido.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 254,creado= '20060918 14:23:28',modificado= '20060918 14:23:27',modifico= 1,activo= 1 where rptf_id = 69
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (69,'Factura Resumida','IC_NRT_frFacturaVentaResumido.csr',1,0,2,0,'',NULL,254,'20060918 14:23:28','20060918 14:23:27',1,1)
end
if exists(select * from reporteformulario where rptf_id = 71) begin
update reporteformulario set rptf_id= 71,rptf_nombre= 'Factura Resumida',rptf_csrfile= 'IC_NRT_frFacturaVentaResumido.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 256,creado= '20060918 14:24:07',modificado= '20060918 14:24:06',modifico= 1,activo= 1 where rptf_id = 71
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (71,'Factura Resumida','IC_NRT_frFacturaVentaResumido.csr',1,0,2,0,'',NULL,256,'20060918 14:24:07','20060918 14:24:06',1,1)
end
if exists(select * from reporteformulario where rptf_id = 73) begin
update reporteformulario set rptf_id= 73,rptf_nombre= 'Factura Resumida',rptf_csrfile= 'IC_NRT_frFacturaVentaResumido.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 295,creado= '20060918 14:24:40',modificado= '20060918 14:24:40',modifico= 1,activo= 1 where rptf_id = 73
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (73,'Factura Resumida','IC_NRT_frFacturaVentaResumido.csr',1,0,2,0,'',NULL,295,'20060918 14:24:40','20060918 14:24:40',1,1)
end
if exists(select * from reporteformulario where rptf_id = 75) begin
update reporteformulario set rptf_id= 75,rptf_nombre= 'Factura Resumida',rptf_csrfile= 'IC_NRT_frFacturaVentaResumido.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 2,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 297,creado= '20060918 14:25:16',modificado= '20060918 14:25:16',modifico= 1,activo= 1 where rptf_id = 75
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (75,'Factura Resumida','IC_NRT_frFacturaVentaResumido.csr',1,0,2,0,'',NULL,297,'20060918 14:25:16','20060918 14:25:16',1,1)
end

if exists(select * from reporteformulario where rptf_id = 65) begin
update reporteformulario set rptf_id= 65,rptf_nombre= 'Resumen de Remitos',rptf_csrfile= 'frFacturaRemitoVentaResumen.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 1,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 173,creado= '20060918 14:08:55',modificado= '20060918 14:25:21',modifico= 1,activo= 1 where rptf_id = 65
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (65,'Resumen de Remitos','frFacturaRemitoVentaResumen.csr',1,0,1,0,'',NULL,173,'20060918 14:08:55','20060918 14:25:21',1,1)
end
if exists(select * from reporteformulario where rptf_id = 67) begin
update reporteformulario set rptf_id= 67,rptf_nombre= 'Resumen de Remitos',rptf_csrfile= 'frFacturaRemitoVentaResumen.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 1,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 175,creado= '20060918 14:22:32',modificado= '20060918 14:22:32',modifico= 1,activo= 1 where rptf_id = 67
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (67,'Resumen de Remitos','frFacturaRemitoVentaResumen.csr',1,0,1,0,'',NULL,175,'20060918 14:22:32','20060918 14:22:32',1,1)
end
GO
if exists(select * from reporteformulario where rptf_id = 70) begin
update reporteformulario set rptf_id= 70,rptf_nombre= 'Resumen de Remitos',rptf_csrfile= 'frFacturaRemitoVentaResumen.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 1,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 254,creado= '20060918 14:23:28',modificado= '20060918 14:23:27',modifico= 1,activo= 1 where rptf_id = 70
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (70,'Resumen de Remitos','frFacturaRemitoVentaResumen.csr',1,0,1,0,'',NULL,254,'20060918 14:23:28','20060918 14:23:27',1,1)
end
if exists(select * from reporteformulario where rptf_id = 72) begin
update reporteformulario set rptf_id= 72,rptf_nombre= 'Resumen de Remitos',rptf_csrfile= 'frFacturaRemitoVentaResumen.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 1,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 256,creado= '20060918 14:24:07',modificado= '20060918 14:24:06',modifico= 1,activo= 1 where rptf_id = 72
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (72,'Resumen de Remitos','frFacturaRemitoVentaResumen.csr',1,0,1,0,'',NULL,256,'20060918 14:24:07','20060918 14:24:06',1,1)
end
if exists(select * from reporteformulario where rptf_id = 74) begin
update reporteformulario set rptf_id= 74,rptf_nombre= 'Resumen de Remitos',rptf_csrfile= 'frFacturaRemitoVentaResumen.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 1,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 295,creado= '20060918 14:24:40',modificado= '20060918 14:24:40',modifico= 1,activo= 1 where rptf_id = 74
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (74,'Resumen de Remitos','frFacturaRemitoVentaResumen.csr',1,0,1,0,'',NULL,295,'20060918 14:24:40','20060918 14:24:40',1,1)
end
if exists(select * from reporteformulario where rptf_id = 76) begin
update reporteformulario set rptf_id= 76,rptf_nombre= 'Resumen de Remitos',rptf_csrfile= 'frFacturaRemitoVentaResumen.csr',rptf_tipo= 1,rptf_sugerido= 0,rptf_copias= 1,rptf_docImprimirEnAlta= 0,rptf_object= '',tbl_id= null,doc_id= 297,creado= '20060918 14:25:16',modificado= '20060918 14:25:16',modifico= 1,activo= 1 where rptf_id = 76
end else begin 
INSERT INTO reporteformulario (rptf_id,rptf_nombre,rptf_csrfile,rptf_tipo,rptf_sugerido,rptf_copias,rptf_docImprimirEnAlta,rptf_object,tbl_id,doc_id,creado,modificado,modifico,activo)VALUES (76,'Resumen de Remitos','frFacturaRemitoVentaResumen.csr',1,0,1,0,'',NULL,297,'20060918 14:25:16','20060918 14:25:16',1,1)
end

go