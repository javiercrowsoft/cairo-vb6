if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Asientos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Asientos]
go

/*
select * from asiento

sp_docasientoget 47

sp_lsdoc_Asientos

  7,
	'20030101',
	'20050101',
		'0',
		'2'

*/

create procedure sp_lsdoc_Asientos (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@doc_id	varchar(255),
@@emp_id	varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @doc_id int
declare @emp_id int

declare @ram_id_Documento int
declare @ram_id_empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
	end else 
		set @ram_id_Documento = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns asiento


select 
			as_id,
			''									  as [TypeTask],
			as_numero             as [Número],
			as_nrodoc						  as [Comprobante],
      doc_nombre					  as [Documento],
			as_fecha						  as [Fecha],
      case doct_id_cliente

				when 1  then           'Factura de Venta'
				when 2  then           'Factura de Compra'
				when 7  then           'Nota de Credito Venta'
				when 8  then           'Nota de Credito Compra'
				when 9  then           'Nota de Debito Venta'
				when 10  then          'Nota de Debito Compra'
				when 13  then          'Cobranza'
				when 16  then          'Orden de Pago'
				when 17  then          'Deposito Banco'
				when 26  then          'Movimiento de Fondos'

			end  									as [Tipo Doc.],
			as_doc_cliente        as [Documento Aux],
			emp_nombre            as [Empresa],
			(	select sum(asi_debe)
				from asientoitem   
				where asientoitem.as_id = asiento.as_id
					and asi_debe <> 0)as [Total],

			asiento.Creado,
			asiento.Modificado,
			us_nombre             as [Modifico],
			as_descrip						as [Observaciones]
from 
			asiento inner join documento     on asiento.doc_id   = documento.doc_id
              inner join usuario       on Asiento.modifico = usuario.us_id
							inner join empresa       on documento.emp_id = empresa.emp_id
							

where 

				  @@Fini <= as_fecha
			and	@@Ffin >= as_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Documento.doc_id
							   ) 
           )
        or 
					 (@ram_id_Documento = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

	order by as_fecha
go