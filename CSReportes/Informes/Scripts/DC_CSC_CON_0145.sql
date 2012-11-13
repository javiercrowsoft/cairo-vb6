/*---------------------------------------------------------------------
Nombre: Listado de Sumas y Saldos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0145]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0145]

go

/*  

Para testear:

select * from cuenta where cue_nombre like 'caja'
select * from arbol where arb_nombre like '%00-p%'
select * from rama where ram_id in (549,
17051,
24492,24521
)

select * from hoja where arb_id = 56 and id = 153

DC_CSC_CON_0145 1, 
								'20050101',
								'20051231',
								'153', 
								'0',
								'0',
								'0',
								'2',
								56

*/

create procedure DC_CSC_CON_0145 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,
	@@cue_id          varchar(255),
  @@cico_id         varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@emp_id	 				varchar(255),
	@@arb_id          int = 0
)as 

begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id       int
declare @mon_id   		int
declare @emp_id   		int
declare @cico_id 			int
declare @doc_id				int

declare @ram_id_cuenta           int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int


declare @clienteID 			int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@mon_id,  		 @mon_id  out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
exec sp_ArbConvertId @@cue_id,  		 @cue_id  out, 				@ram_id_cuenta out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id, 		   @doc_id  out, 				@ram_id_Documento out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

create table #DC_CSC_CON_0145_cuentas (
																				nodo_id int,
																				nodo_2 int,
																				nodo_3 int,
																				nodo_4 int,
																				nodo_5 int,
																				nodo_6 int,
																				nodo_7 int,
																				nodo_8 int,
																				nodo_9 int
																			)


if @@arb_id = 0	select @@arb_id = min(arb_id) from arbol where tbl_id = 17 -- cuenta

declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n 					int 					set @n = 2
declare @raiz 			int

while exists(select * from rama r
						 where  arb_id = @@arb_id
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_2 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_3 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_4 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_5 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_6 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_7 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_8 = r.ram_id)
								and not exists (select * from #DC_CSC_CON_0145_cuentas where nodo_9 = r.ram_id)

								and @n <= 9
						)
begin

	if @n = 2 begin

		select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2) 
		select ram_id, ram_id from rama where ram_id_padre = @raiz

	end else begin if @n = 3 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3) 
		select ram_id, nodo_2, ram_id 
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_2

	end else begin if @n = 4 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3, nodo_4) 
		select ram_id, nodo_2, nodo_3, ram_id
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_3

	end else begin if @n = 5 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
		select ram_id, nodo_2, nodo_3, nodo_4, ram_id
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_4

	end else begin if @n = 6 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_5

	end else begin if @n = 7 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_6

	end else begin if @n = 8 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_7

	end else begin if @n = 9 begin

		insert #DC_CSC_CON_0145_cuentas (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
		from rama r inner join #DC_CSC_CON_0145_cuentas n on r.ram_id_padre = n.nodo_8

	end
	end
	end
	end
	end
	end
	end
	end

	set @n = @n + 1

end

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
select  
				cue.cue_id,
				emp_nombre      as Empresa,
				@arb_nombre     as Nivel_1,

				nodo_2.ram_nombre		as Nivel_2,
				nodo_3.ram_nombre		as Nivel_3,
				nodo_4.ram_nombre		as Nivel_4,
				nodo_5.ram_nombre		as Nivel_5,
				nodo_6.ram_nombre		as Nivel_6,
				nodo_7.ram_nombre		as Nivel_7,
				nodo_8.ram_nombre		as Nivel_8,
				nodo_9.ram_nombre		as Nivel_9,

				convert(varchar,nodo_2.ram_orden)+'@'+ nodo_2.ram_nombre		as Nivelg_2,
				convert(varchar,nodo_3.ram_orden)+'@'+ nodo_3.ram_nombre		as Nivelg_3,
				convert(varchar,nodo_4.ram_orden)+'@'+ nodo_4.ram_nombre		as Nivelg_4,
				convert(varchar,nodo_5.ram_orden)+'@'+ nodo_5.ram_nombre		as Nivelg_5,
				convert(varchar,nodo_6.ram_orden)+'@'+ nodo_6.ram_nombre		as Nivelg_6,
				convert(varchar,nodo_7.ram_orden)+'@'+ nodo_7.ram_nombre		as Nivelg_7,
				convert(varchar,nodo_8.ram_orden)+'@'+ nodo_8.ram_nombre		as Nivelg_8,
				convert(varchar,nodo_9.ram_orden)+'@'+ nodo_9.ram_nombre		as Nivelg_9,

			  cuec_nombre     					as Categoria,
				cue_nombre								as Cuenta,
				cue_codigo		  					as Codigo,
				cue_identificacionExterna as [Codigo Contable],
				sum(asi_debe)							as Debe, 
				sum(asi_haber)						as Haber
from

				 asiento ast     inner join asientoitem 			asi  	on ast.as_id   = asi.as_id
												 inner join cuenta 						cue  	on asi.cue_id  = cue.cue_id
												 inner join documento					doc  	on ast.doc_id  = doc.doc_id
												 inner join cuentacategoria		cuec	on cue.cuec_id = cuec.cuec_id
											   inner join empresa           emp   on doc.emp_id  = emp.emp_id
                         left  join Documento 				doccl	on ast.doc_id_cliente	= doccl.doc_id

												 left  join hoja h    on     cue.cue_id = h.id 
                                                 and h.arb_id = @@arb_id

																								 -- Esto descarta la raiz
																								 --
																		             and not exists(select * from rama 
                                                                where ram_id = ram_id_padre 
                                                                  and arb_id = @@arb_id 
                                                                  and ram_id = h.ram_id)

															                   -- Esto descarta hojas secundarias
															                   --
															                   and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
																							                  where h2.arb_id = @@arb_id
																								                  and h2.ram_id < h.ram_id
																								                  and h2.ram_id <> r.ram_id_padre 
																								                  and h2.id = h.id)

												 left  join #DC_CSC_CON_0145_cuentas nodo on h.ram_id = nodo.nodo_id

                         left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
                         left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
                         left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
                         left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
                         left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
                         left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
                         left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
                         left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id

												 left  join FacturaCompra fc on ast.doct_id_cliente in (2,8,10) and ast.id_cliente = fc.fc_id
												 left  join FacturaVenta  fv on ast.doct_id_cliente in (1,7,9)  and ast.id_cliente = fv.fv_id
where 
				  isnull(isnull(fc_fechaiva,fv_fechaiva),as_fecha) >= @@Fini
			and	isnull(isnull(fc_fechaiva,fv_fechaiva),as_fecha) <= @@Ffin 

-- Validar usuario - empresa
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (asi.cue_id 	= @cue_id 	or @cue_id	=0)
and   (asi.mon_id 	= @mon_id 	or @mon_id	=0)
and   (doc.emp_id   = @emp_id 	or @emp_id	=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)

and   (			ast.doc_id = @doc_id 	
				or 	ast.doc_id_cliente = @doc_id 
				or 	@doc_id	=0
			)

-- Arboles

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = asi.cue_id
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
                  and  tbl_id = 12 
                  and  rptarb_hojaid = asi.mon_id
							   ) 
           )
        or 
					 (@ram_id_moneda = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
							   ) 
           )
        or 
					 (@ram_id_circuitocontable = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001
                  and  (rptarb_hojaid = ast.doc_id or 	rptarb_hojaid = ast.doc_id_cliente)
							   ) 
           )
        or 
					 (@ram_id_documento = 0)
			 )


group by 

		emp_nombre,
		cuec_nombre,
		nodo_2.ram_nombre,
		nodo_3.ram_nombre,
		nodo_4.ram_nombre,
		nodo_5.ram_nombre,
		nodo_6.ram_nombre,
		nodo_7.ram_nombre,
		nodo_8.ram_nombre,
		nodo_9.ram_nombre,

		convert(varchar,nodo_2.ram_orden)+'@'+ nodo_2.ram_nombre,
		convert(varchar,nodo_3.ram_orden)+'@'+ nodo_3.ram_nombre,
		convert(varchar,nodo_4.ram_orden)+'@'+ nodo_4.ram_nombre,
		convert(varchar,nodo_5.ram_orden)+'@'+ nodo_5.ram_nombre,
		convert(varchar,nodo_6.ram_orden)+'@'+ nodo_6.ram_nombre,
		convert(varchar,nodo_7.ram_orden)+'@'+ nodo_7.ram_nombre,
		convert(varchar,nodo_8.ram_orden)+'@'+ nodo_8.ram_nombre,
		convert(varchar,nodo_9.ram_orden)+'@'+ nodo_9.ram_nombre,

		cue.cue_id,
		cue_nombre,
		cue_codigo,
		cue_identificacionExterna

order by Empresa, Nivel_1, Nivelg_2, Nivelg_3, Nivelg_4, Nivelg_5, Nivelg_6, Nivelg_7, Nivelg_8, Nivelg_9, cue_identificacionexterna,cue_codigo
end

go

