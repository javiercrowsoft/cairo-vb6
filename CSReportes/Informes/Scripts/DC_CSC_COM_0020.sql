/*---------------------------------------------------------------------
Nombre: Aplicacion de documentos de compra
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0020]

/*

select * from EmpresaUsuario

DC_CSC_COM_0020      1,
										 '20050701',
										 '20050710',
										 '0',
                     '0',
                     '0'

*/

go
create procedure DC_CSC_COM_0020 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prov_id varchar(255),
@@suc_id  varchar(255), 
@@emp_id  varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id  int
declare @suc_id   int
declare @emp_id   int 

declare @ram_id_Proveedor int
declare @ram_id_Sucursal  int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
	end else 
		set @ram_id_Proveedor = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

----------------------------------------

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end
----------------------------------------

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
select 

	opg.opg_id								as opg_id,
  fc.fc_id									as fc_id,
	prov_nombre								as Proveedor,
  emp_nombre                as Empresa, 
  opg_fecha									as [Orden de Pago/NC Fecha],
  docopg.doc_nombre         as [Orden de Pago/NC],

	case opg.est_id
		when 7 then opg_nrodoc + ' (Anulada)'
		else				opg_nrodoc
	end                     	as [Orden de Pago/NC Comprobante],

  opg_numero               	as [Orden de Pago/NC Numero],
  
	case opg.est_id
		when 7 then 0
		else				opg_total
	end                     	as [Orden de Pago/NC Total],

	case opg.est_id
		when 7 then 0
		else				opg_pendiente
	end              					as [Orden de Pago/NC Pendiente],

  lgjopg.lgj_codigo         as [Orden de Pago/NC Legajo],
  fc_fecha                  as [Factura Fecha],
  docfc.doc_nombre          as [Documento de Compra],
  fc_nrodoc                 as [Factura Comprobante],
  fc_numero                 as [Factura Numero],
  mon_nombre                as [Moneda],

	case opg.est_id
		when 7 then 0
		else				fcopg_importe
	end                     	as [Aplicacion],

	fc_total                  as [Factura Total],
  0                         as [Factura Pendiente],
  lgjfc.lgj_codigo          as [Factura Legajo],
  0                       	as Orden
  

from

	OrdenPago opg 			inner join Proveedor prov 										on opg.prov_id 			= prov.prov_id
											inner join Sucursal                       		on opg.suc_id       = Sucursal.suc_id
                      inner join Documento docopg               		on opg.doc_id       = docopg.doc_id
                      inner join Empresa                            on docopg.emp_id    = Empresa.emp_id 
                      left  join Legajo lgjopg                  		on opg.lgj_id       = lgjopg.lgj_id
											left  join FacturaCompraOrdenPago fcopg     	on opg.opg_id 			= fcopg.opg_id
											left  join FacturaCompra fc                		on fcopg.fc_id      = fc.fc_id
											left  join Documento docfc                		on fc.doc_id        = docfc.doc_id
                      left  join Moneda m                       		on fc.mon_id        = m.mon_id
                      left  join Legajo lgjfc                   		on fc.lgj_id        = lgjfc.lgj_id
where 

				  opg_fecha >= @@Fini
			and	opg_fecha <= @@Ffin 

---------------------------------------------------------------------------

			and (
						exists(select * from EmpresaUsuario where emp_id = docopg.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
---------------------------------------------------------------------------

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.prov_id = @prov_id or @prov_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29
                  and  rptarb_hojaid = opg.prov_id
							   ) 
           )
        or 
					 (@ram_id_Proveedor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007
                  and  rptarb_hojaid = opg.suc_id
							   ) 
           )
        or 
					 (@ram_id_Sucursal = 0)
			 )

----------------------------------------------

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = docopg.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )
----------------------------------------------

union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////

select 

	nc.fc_id     							as opg_id,
  fc.fc_id									as fc_id,
	prov_nombre								as Proveedor,
  emp_nombre                as Empresa, 
  nc.fc_fecha								as [Orden de Pago/NC Fecha],
  docnc.doc_nombre          as [Orden de Pago/NC],

  case nc.est_id
		when 7 then nc.fc_nrodoc + ' (Anulada)'
		else	      nc.fc_nrodoc
	end												as [Orden de Pago/NC Comprobante],

  nc.fc_numero              as [Orden de Pago/NC Numero],

  case nc.est_id
		when 7 then 0
		else				nc.fc_total
	end				                as [Orden de Pago/NC Total],

  case nc.est_id
		when 7 then 0
		else				nc.fc_pendiente
	end				                as [Orden de Pago/NC Pendiente],

  lgjnc.lgj_codigo          as [Orden de Pago/NC Legajo],
  fc.fc_fecha               as [Factura Fecha],
  docfc.doc_nombre          as [Documento de Compra],
  fc.fc_nrodoc              as [Factura Comprobante],
  fc.fc_numero              as [Factura Numero],
  mon_nombre                as [Moneda],

  case nc.est_id
		when 7 then 0
		else				fcnc_importe
	end				                as [Aplicacion],

	fc.fc_total               as [Factura Total],
  0                         as [Factura Pendiente],
  lgjfc.lgj_codigo          as [Factura Legajo],
  0                       	as Orden
  

from

	FacturaCompra nc 		inner join Proveedor prov 								on nc.prov_id 			  	= prov.prov_id
											inner join Sucursal                       on nc.suc_id        		= Sucursal.suc_id
                      inner join Documento docnc                on nc.doc_id        		= docnc.doc_id
                      inner join Empresa                        on docnc.emp_id         = Empresa.emp_id 
                      left  join Legajo lgjnc                   on nc.lgj_id        		= lgjnc.lgj_id
											left  join FacturaCompraNotaCredito fcnc  on nc.fc_id 			  		= fcnc.fc_id_notacredito
											left  join FacturaCompra fc               on fcnc.fc_id_factura   = fc.fc_id
											left  join Documento docfc                on fc.doc_id        		= docfc.doc_id
                      left  join Moneda m                       on fc.mon_id        		= m.mon_id
                      left  join Legajo lgjfc                   on fc.lgj_id        		= lgjfc.lgj_id
where 

				  nc.fc_fecha >= @@Fini
			and	nc.fc_fecha <= @@Ffin 
      and docnc.doct_id = 8 /* 8	Nota de Credito Compra */

---------------------------------------------------------------------------

			and (
						exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
---------------------------------------------------------------------------

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.prov_id = @prov_id or @prov_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29
                  and  rptarb_hojaid = nc.prov_id
							   ) 
           )
        or 
					 (@ram_id_Proveedor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007
                  and  rptarb_hojaid = nc.suc_id
							   ) 
           )
        or 
					 (@ram_id_Sucursal = 0)
			 )

----------------------------------------------

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = docnc.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )
----------------------------------------------

--////////////////////////////////////////////////////////////////////////////////////////////////////////
union all

select 

	0													as opg_id,
  fc.fc_id									as fc_id,
	prov_nombre								as Proveedor,
  emp_nombre                as Empresa, 
  convert(datetime,'19900101')
			      								as [Orden de Pago/NC Fecha],
  ''                        as [Orden de Pago/NC],
  ''                        as [Orden de Pago/NC Comprobante],
  null             					as [Orden de Pago/NC Numero],
  0                					as [Orden de Pago/NC Total],
  0            							as [Orden de Pago/NC Pendiente],
  ''                        as [Orden de Pago/NC Legajo],
  fc_fecha                  as [Factura Fecha],
  docfc.doc_nombre          as [Documento de Compra],

  case fc.est_id
		when 7 then fc_nrodoc + ' (Anulada)'
		else				fc_nrodoc
	end				                as [Factura Comprobante],

  fc_numero                 as [Factura Numero],
  mon_nombre                as [Moneda],

  case fc.est_id
		when 7 then 0
		else				fc_total - fc_pendiente
	end				                as [Aplicacion],

  case fc.est_id
		when 7 then 0
		else				fc_total
	end				                as [Factura Total],

  case fc.est_id
		when 7 then 0
		else				fc_pendiente
	end				                as [Factura Pendiente],

  lgjfc.lgj_codigo          as [Factura Legajo],
  1                       	as Orden

from

	FacturaCompra fc 				inner join Proveedor prov 								on fc.prov_id 		= prov.prov_id
													inner join Sucursal                       on fc.suc_id      = Sucursal.suc_id
													inner join Documento docfc                on fc.doc_id      = docfc.doc_id
                      		inner join Empresa                        on docfc.emp_id   = Empresa.emp_id 
		                      inner join Moneda m                       on fc.mon_id      = m.mon_id
                          left  join Legajo lgjfc                   on fc.lgj_id      = lgjfc.lgj_id
where 

				  fc_fecha >= @@Fini
			and	fc_fecha <= @@Ffin 
			and fc_pendiente > 0
      and docfc.doct_id in(2,10)  /* 8	Nota de Credito Compra */

---------------------------------------------------------------------------

			and (
						exists(select * from EmpresaUsuario where emp_id = docfc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
---------------------------------------------------------------------------

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.prov_id = @prov_id or @prov_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) 

-- Arboles
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
					 (@ram_id_Proveedor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007
                  and  rptarb_hojaid = fc.suc_id
							   ) 
           )
        or 
					 (@ram_id_Sucursal = 0)
			 )

----------------------------------------------

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = docfc.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )
----------------------------------------------

--///////////////////////////////////////////////////////////////

order by

	Orden, Proveedor, [Orden de Pago/NC Fecha], [Factura Fecha]


go