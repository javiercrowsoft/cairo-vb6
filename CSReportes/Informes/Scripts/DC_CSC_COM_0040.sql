
/*---------------------------------------------------------------------
Nombre: Compras por proveedor y articulo
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0040]

/*
DC_CSC_COM_0040 1,
								'20050501',
								'20060531',
								'0',
								'0',
								'0',
                '1'
*/

go
create procedure DC_CSC_COM_0040(

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cico_id  				varchar(255),
	@@pr_id 	 				varchar(255),
  @@prov_id         varchar(255),
  @@emp_id   				varchar(255)

) 

as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id 				int
declare @prov_id 			int
declare @emp_id   		int 
declare @cico_id  		int

declare @ram_id_producto 				 int
declare @ram_id_proveedor				 int
declare @ram_id_Empresa   			 int 
declare @ram_id_circuitoContable int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, 			 @pr_id out, 				@ram_id_producto out
exec sp_ArbConvertId @@prov_id, 		 @prov_id out, 			@ram_id_proveedor out
exec sp_ArbConvertId @@emp_id, 			 @emp_id out, 			@ram_id_Empresa out 
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable out

exec sp_GetRptId @clienteID out

declare @arb_id int

if @ram_id_producto <> 0 
	select @arb_id = arb_id from Rama where ram_id = @ram_id_producto
else
	set @arb_id = 0

create table #dc_csc_com_0040_productos (
																				nodo_id int,
																				nodo_2 int,
																				nodo_3 int,
																				nodo_4 int,
																				nodo_5 int,
																				nodo_6 int,
																				nodo_7 int,
																				nodo_8 int,
																				nodo_9 int,
																			)


if @arb_id = 0	select @arb_id = min(arb_id) from arbol where tbl_id = 30 -- producto

declare @arb_nombre varchar(255) 	select @arb_nombre = arb_nombre from arbol where arb_id = @arb_id
declare @n 					int 					set @n = 2
declare @raiz 			int

while exists(select * from rama r
						 where  arb_id = @arb_id
								and not exists (select * from #dc_csc_com_0040_productos where nodo_2 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_3 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_4 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_5 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_6 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_7 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_8 = r.ram_id)
								and not exists (select * from #dc_csc_com_0040_productos where nodo_9 = r.ram_id)

								and @n <= 9
						)
begin

	if @n = 2 begin

		select @raiz = ram_id from rama where arb_id = @arb_id and ram_id_padre = 0
		insert #dc_csc_com_0040_productos (nodo_id, nodo_2) 
		select ram_id, ram_id from rama where ram_id_padre = @raiz

	end else begin if @n = 3 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3) 
		select ram_id, nodo_2, ram_id 
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_2

	end else begin if @n = 4 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3, nodo_4) 
		select ram_id, nodo_2, nodo_3, ram_id
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_3

	end else begin if @n = 5 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
		select ram_id, nodo_2, nodo_3, nodo_4, ram_id
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_4

	end else begin if @n = 6 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_5

	end else begin if @n = 7 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_6

	end else begin if @n = 8 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_7

	end else begin if @n = 9 begin

		insert #dc_csc_com_0040_productos (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
		select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
		from rama r inner join #dc_csc_com_0040_productos n on r.ram_id_padre = n.nodo_8

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



if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
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

if @ram_id_circuitoContable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
	end else 
		set @ram_id_circuitoContable = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
			1                                         as Orden,

			@arb_nombre     as Nivel_1,

			nodo_2.ram_nombre		as Nivel_2,
			nodo_3.ram_nombre		as Nivel_3,
			nodo_4.ram_nombre		as Nivel_4,
			nodo_5.ram_nombre		as Nivel_5,
			nodo_6.ram_nombre		as Nivel_6,
			nodo_7.ram_nombre		as Nivel_7,
			nodo_8.ram_nombre		as Nivel_8,
			nodo_9.ram_nombre		as Nivel_9,

			pr_nombrecompra													  as Articulo,
			pr_codigo																	as Codigo,

			sum(case doc.doct_id
        when 8  then -(fci_neto
														- (fci_neto * fc_descuento1 / 100)
														- (
																(
																	fci_neto - (fci_neto * fc_descuento1 / 100)
																) * fc_descuento2 / 100
															)
													)
        else          (fci_neto
														- (fci_neto * fc_descuento1 / 100)
														- (
																(
																	fci_neto - (fci_neto * fc_descuento1 / 100)
																) * fc_descuento2 / 100
															)
													)
      end
					)  				             			  				as [compras neto],

			sum(case doc.doct_id
        when 8  then -((fci_ivari+fci_ivarni)
														- ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
														- (
																(
																	(fci_ivari+fci_ivarni) - ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
																) * fc_descuento2 / 100
															)
													)
        else         ((fci_ivari+fci_ivarni)
														- ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
														- (
																(
																	(fci_ivari+fci_ivarni) - ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
																) * fc_descuento2 / 100
															)
												)
			end
					)	 														  			as ivacompras,

			sum(case doc.doct_id
        when 8  then -(fci_importe
														- (fci_importe * fc_descuento1 / 100)
														- (
																(
																	fci_importe - (fci_importe * fc_descuento1 / 100)
																) * fc_descuento2 / 100
															)
													)
        else          (fci_importe
														- (fci_importe * fc_descuento1 / 100)
														- (
																(
																	fci_importe - (fci_importe * fc_descuento1 / 100)
																) * fc_descuento2 / 100
															)
													)
      end
					)  				             			  				as compras,

	  	sum(case doc.doct_id
	        	when 8  then -(fci_cantidad)
	        	else          fci_cantidad
	      	end
					)							                        as [cant. compras]

from

			Producto pr inner join FacturaCompraItem fci	 on pr.pr_id   = fci.pr_id
									inner join FacturaCompra fc     	 on fci.fc_id  = fc.fc_id
                  inner join Documento doc           on fc.doc_id  = doc.doc_id
                  inner join Empresa emp             on doc.emp_id = emp.emp_id 

												 left  join hoja h    on     pr.pr_id = h.id 
                                                 and h.arb_id = @arb_id
	
																								 -- Esto descarta la raiz
																								 --
																		             and not exists(select * from rama 
                                                                where ram_id = ram_id_padre 
                                                                  and arb_id = @arb_id 
                                                                  and ram_id = h.ram_id)

															                   -- Esto descarta hojas secundarias
															                   --
															                   and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
																							                  where h2.arb_id = @arb_id
																								                  and h2.ram_id < h.ram_id
																								                  and h2.ram_id <> r.ram_id_padre 
																								                  and h2.id = h.id)

												 left  join #dc_csc_com_0040_productos nodo on h.ram_id = nodo.nodo_id

                         left  join rama nodo_2		on nodo.nodo_2 = nodo_2.ram_id
                         left  join rama nodo_3		on nodo.nodo_3 = nodo_3.ram_id
                         left  join rama nodo_4		on nodo.nodo_4 = nodo_4.ram_id
                         left  join rama nodo_5		on nodo.nodo_5 = nodo_5.ram_id
                         left  join rama nodo_6		on nodo.nodo_6 = nodo_6.ram_id
                         left  join rama nodo_7		on nodo.nodo_7 = nodo_7.ram_id
                         left  join rama nodo_8		on nodo.nodo_8 = nodo_8.ram_id
                         left  join rama nodo_9		on nodo.nodo_9 = nodo_9.ram_id

where 

				  fc_fecha >= @@Fini
			and	fc_fecha <= @@Ffin

			and fc.est_id <> 7 -- Todas menos anuladas

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (pr.pr_id 		= @pr_id 		or @pr_id   =0)
and   (doc.cico_id 	= @cico_id  or @cico_id =0)
and   (emp.emp_id 	= @emp_id 	or @emp_id  =0) 
and   (fc.prov_id   = @prov_id  or @prov_id =0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  rptarb_hojaid = fci.pr_id
							   ) 
           )
        or 
					 (@ram_id_producto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 
                  and  rptarb_hojaid = fc.prov_id
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
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = doc.cico_id
							   ) 
           )
        or 
					 (@ram_id_circuitoContable = 0)
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
					 (@ram_id_Empresa = 0)
			 )

group by 	pr_nombrecompra,
					pr_codigo,
					nodo_2.ram_nombre,
					nodo_3.ram_nombre,
					nodo_4.ram_nombre,
					nodo_5.ram_nombre,
					nodo_6.ram_nombre,
					nodo_7.ram_nombre,
					nodo_8.ram_nombre,
					nodo_9.ram_nombre

order by pr_nombrecompra, Nivel_1, Nivel_2, Nivel_3, Nivel_4, Nivel_5, Nivel_6, Nivel_7, Nivel_8, Nivel_9

end
go