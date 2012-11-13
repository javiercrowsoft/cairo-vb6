/*---------------------------------------------------------------------
Nombre: Ingresos y Egresos de Stock por Articulo
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0420]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0420]
go

-- select pr_id from remitocompraitem order by rci_id desc
-- DC_CSC_STK_0420 1,'20090801','20090905', 1991

create procedure DC_CSC_STK_0420 (

	@@us_id 	int,
	@@Fini  	datetime,
	@@Ffin  	datetime,
	@@pr_id		varchar(255)

)
as
begin

set nocount on

declare @pr_id 										int
declare @ram_id_producto 					int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_producto out

exec sp_GetRptId @clienteID out

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

	create table #t_saldos (pr_id int, ingreso decimal(18,6), egreso decimal(18,6))

	insert into #t_saldos (pr_id, ingreso, egreso)

	select 	pr.pr_id,
					sum(sti_salida)   as Ingreso,
					sum(sti_ingreso)  as Egreso

	from Producto pr inner join StockItem sti on 		pr.pr_id = sti.pr_id
																							and sti.depl_id in (-2,-3)

									 inner join Stock st on 		sti.st_id = st.st_id
																					and st.st_fecha < @@Fini

	where sti.depl_id in (-2,-3)
			and st.st_fecha < @@Fini

			and (pr.pr_id = @pr_id or @pr_id=0)
			and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 30 and rptarb_hojaid = pr.pr_id)) or (@ram_id_producto = 0))

	group by pr.pr_id

	select 
					pr.pr_id,
					pr_nombrecompra				as Producto,
					'19000101'						as Fecha,
					''										as Codigo,
					''										as Tipo,
					''                    as Documento,
					'(Saldo Inicial)'			as Comprobante,
					ingreso               as Ingreso,
					egreso                as Egreso

	from Producto pr left join #t_saldos t on pr.pr_id = t.pr_id
	where
					(pr.pr_id = @pr_id or @pr_id=0)
			and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 30 and rptarb_hojaid = pr.pr_id)) or (@ram_id_producto = 0))

	union all

	select 	pr.pr_id,
					pr_nombrecompra   		as Producto,					
					st_fecha          		as Fecha,

					isnull(doct2.doct_codigo,doct.doct_codigo)
																as Codigo,

					isnull(doct2.doct_nombre,doct.doct_nombre)
																as Tipo,

					isnull(doc2.doc_nombre,doc.doc_nombre)        
																as Documento,

					isnull(rc.rc_nrodoc, 
					isnull(prp.prp_nrodoc, 
					isnull(rv.rv_nrodoc, 
					isnull(os.os_nrodoc, 
					isnull(impt.impt_nrodoc, 
					isnull(stcli.stcli_nrodoc, 
					isnull(stprov.stprov_nrodoc, 
					isnull(fv.fv_nrodoc,
					isnull(fc.fc_nrodoc,
					isnull(rv1.rv_nrodoc,
					isnull(rv2.rv_nrodoc,
					isnull(rv3.rv_nrodoc,
					isnull(rs1.rs_nrodoc,
					isnull(rs2.rs_nrodoc,
					isnull(ppk1.ppk_nrodoc,
					isnull(ppk2.ppk_nrodoc,st.st_nrodoc)))))))))))))))) + ' ' + isnull(cli_nombre,'')
																as Comprobante,

					sum(sti_salida)	  		as Ingreso,
					sum(sti_ingreso)			as Egreso

	from Producto pr inner join StockItem sti on 		pr.pr_id = sti.pr_id
																							and sti.depl_id in (-2,-3)

									 inner join Stock st on 		sti.st_id = st.st_id
																					and st.st_fecha between @@Fini and @@Ffin

									 left join documento doc on st.doc_id = doc.doc_id
									 left join documentotipo doct on doc.doct_id = doct.doct_id

									 left join RemitoCompra rc 						on st.st_id = rc.st_id
									 left join ParteReparacion prp  			on st.st_id = prp.st_id
									 left join RemitoVenta rv							on st.st_id = rv.st_id
									 left join OrdenServicio os						on st.st_id = os.st_id
									 left join ImportacionTemp impt				on st.st_id = impt.st_id
									 left join StockCliente stcli					on st.st_id = stcli.st_id
									 left join StockProveedor stprov			on st.st_id = stprov.st_id
									 left join FacturaVenta fv						on st.st_id = fv.st_id
									 left join FacturaCompra fc						on st.st_id = fc.st_id
									 left join RemitoVenta rv1						on st.st_id = rv1.st_id_consumo
									 left join RemitoVenta rv2						on st.st_id = rv2.st_id_consumotemp
									 left join RemitoVenta rv3						on st.st_id = rv3.st_id_producido
									 left join RecuentoStock rs1					on st.st_id = rs1.st_id1
									 left join RecuentoStock rs2					on st.st_id = rs2.st_id2
									 left join ParteProdKit ppk1					on st.st_id = ppk1.st_id1
									 left join ParteProdKit ppk2					on st.st_id = ppk2.st_id2

									 left join documento doc2 on doc2.doc_id in ( rc.doc_id, 
																																prp.doc_id, 
																																rv.doc_id, 
																																os.doc_id, 
																																impt.doc_id, 
																																stcli.doc_id, 
																																stprov.doc_id, 
																																fv.doc_id,
																																fc.doc_id,
																																rv1.doc_id,
																																rv2.doc_id,
																																rv3.doc_id,
																																rs1.doc_id,
																																rs2.doc_id,
																																ppk1.doc_id,
																																ppk2.doc_id
																																)
									 left join documentotipo doct2 on doc2.doct_id = doct2.doct_id

									 left join cliente cli on cli.cli_id in ( 
																																rv.cli_id, 
																																os.cli_id, 
																																stcli.cli_id, 
																																fv.cli_id,
																																rv1.cli_id,
																																rv2.cli_id,
																																rv3.cli_id
																																)

	where sti.depl_id in (-2,-3)

			and st.st_fecha between @@Fini and @@Ffin
			and (pr.pr_id = @pr_id or @pr_id=0)
			and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 30 and rptarb_hojaid = pr.pr_id)) or (@ram_id_producto = 0))

	group by 

					pr.pr_id,
					pr_nombrecompra,
					st_fecha,

					isnull(doct2.doct_codigo,doct.doct_codigo),

					isnull(doct2.doct_nombre,doct.doct_nombre),

					isnull(doc2.doc_nombre,doc.doc_nombre),

					isnull(rc.rc_nrodoc, 
					isnull(prp.prp_nrodoc, 
					isnull(rv.rv_nrodoc, 
					isnull(os.os_nrodoc, 
					isnull(impt.impt_nrodoc, 
					isnull(stcli.stcli_nrodoc, 
					isnull(stprov.stprov_nrodoc, 
					isnull(fv.fv_nrodoc,
					isnull(fc.fc_nrodoc,
					isnull(rv1.rv_nrodoc,
					isnull(rv2.rv_nrodoc,
					isnull(rv3.rv_nrodoc,
					isnull(rs1.rs_nrodoc,
					isnull(rs2.rs_nrodoc,
					isnull(ppk1.ppk_nrodoc,
					isnull(ppk2.ppk_nrodoc,st.st_nrodoc)))))))))))))))) + ' ' + isnull(cli_nombre,'')

	order by Fecha
	
end
go