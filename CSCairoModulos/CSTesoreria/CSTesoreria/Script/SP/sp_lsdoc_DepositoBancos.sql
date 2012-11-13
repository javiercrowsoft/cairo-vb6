if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_DepositoBancos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_DepositoBancos]
go

/*
select * from DepositoBanco

sp_docDepositoBancoget 47

sp_lsdoc_DepositoBancos

  7,
	'20030101',
	'20050101',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0'

*/

create procedure sp_lsdoc_DepositoBancos (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@bco_id  						varchar(255),
@@cue_id  						varchar(255),
@@est_id							varchar(255),
@@suc_id							varchar(255),
@@doc_id							varchar(255),
@@emp_id	varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @bco_id int
declare @cue_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @doc_id int
declare @emp_id int

declare @ram_id_Banco int
declare @ram_id_Cuenta int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Documento int
declare @ram_id_empresa int 

declare @ClienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@bco_id, @bco_id out, @ram_id_Banco out
exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_Cuenta out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

exec sp_GetRptId @ClienteID out

if @ram_id_Banco <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Banco, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Banco, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Banco, @ClienteID 
	end else 
		set @ram_id_Banco = 0
end

if @ram_id_Cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cuenta, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cuenta, @ClienteID 
	end else 
		set @ram_id_Cuenta = 0
end

if @ram_id_CentroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CentroCosto, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CentroCosto, @ClienteID 
	end else 
		set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @ClienteID 
	end else 
		set @ram_id_Estado = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @ClienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Documento, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Documento, @ClienteID 
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
-- sp_columns DepositoBanco


select 
			dbco_id,
			''									  	as [TypeTask],
			dbco_numero             as [Número],
			dbco_nrodoc						  as [Comprobante],
	    bco_nombre            	as [Banco],
      cue_nombre              as [Cuenta],
      doc_nombre					  	as [Documento],
	    est_nombre					  	as [Estado],
			dbco_fecha						  as [Fecha],
			dbco_total							as [Total],
			case dbco_firmado
				when 0 then 'No'
				else        'Si'
			end											as [Firmado],
			
      suc_nombre							as [Sucursal],
			emp_nombre              as [Empresa],

			DepositoBanco.Creado,
			DepositoBanco.Modificado,
			usuario.us_nombre     	as [Modifico],
			dbco_descrip						as [Observaciones]
from 
			DepositoBanco    inner join documento     on DepositoBanco.doc_id   = documento.doc_id
											 inner join empresa       on documento.emp_id       = empresa.emp_id
											 inner join estado        on DepositoBanco.est_id   = estado.est_id
											 inner join sucursal      on DepositoBanco.suc_id   = sucursal.suc_id
		                   inner join Banco         on DepositoBanco.bco_id   = Banco.bco_id
		                   inner join Cuenta        on DepositoBanco.cue_id   = Cuenta.cue_id
		                   left  join usuario       on DepositoBanco.modifico = usuario.us_id
where 

				  @@Fini <= dbco_fecha
			and	@@Ffin >= dbco_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Banco.bco_id 				= @bco_id 				or @bco_id=0)
and   (Cuenta.cue_id 				= @cue_id 				or @cue_id=0)
and   (Estado.est_id 				= @est_id 				or @est_id=0)
and   (Sucursal.suc_id 			= @suc_id 				or @suc_id=0)
and   (Documento.doc_id 		= @doc_id 				or @doc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Banco.bco_id
							   ) 
           )
        or 
					 (@ram_id_Banco = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 17 -- select tbl_id,tbl_nombrefisico from tabla
                  and  rptarb_hojaid = Cuenta.cue_id
							   ) 
           )
        or 
					 (@ram_id_Cuenta = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 4005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Estado.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Sucursal.suc_id
							   ) 
           )
        or 
					 (@ram_id_Sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
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
	order by dbco_fecha
go