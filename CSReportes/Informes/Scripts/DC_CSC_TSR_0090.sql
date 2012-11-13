
/*---------------------------------------------------------------------
Nombre: Cheques de terceros
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0090 1,'20060101','20061231','0','0','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0090]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0090]

go
create procedure DC_CSC_TSR_0090 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cue_id  varchar(255),
	@@bco_id  varchar(255),
	@@cli_id  varchar(255),
	@@emp_id  varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id 	int
declare @bco_id 	int
declare @cli_id 	int
declare @emp_id 	int  --TODO:EMPRESA

declare @ram_id_cuenta 		int
declare @ram_id_banco 		int
declare @ram_id_cliente   int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, 	@cue_id out, 	@ram_id_cuenta out
exec sp_ArbConvertId @@bco_id, 	@bco_id out, 	@ram_id_banco out
exec sp_ArbConvertId @@cli_id, 	@cli_id out, 	@ram_id_cliente out
exec sp_ArbConvertId @@emp_id, 	@emp_id out, 	@ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_banco <> 0 begin

--	exec sp_ArbGetGroups @ram_id_banco, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_banco, @clienteID 
	end else 
		set @ram_id_banco = 0
end

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 
						1                 as orden_id,
						cheq_id,
						cheq_propio       as cheq_propio_id,		-- Es para que la grilla oculte la columna

            emp_nombre        as [Empresa], 

						docCobz.doc_nombre as [Doc. Cobranza],
						cobz_nrodoc        as [Cobranza],
            cobz_numero        as [Cobranza Numero],

						docMf.doc_nombre   as [Doc. Fondos],
						mf_nrodoc       	 as [Mov. Fondos],
            mf_numero       	 as [Mov. Fondos Numero],

						cli_codigo         as [Codigo],
						cli_nombre         as [Cliente],
            bco_nombre         as [Banco],
						cue_nombre         as [Cuenta],
            mon_nombre         as [Moneda],
						cheq_numero				 as [Numero],


						IsNull(cobz.cobz_id,
                    mf.mf_id)	as comp_id,

						IsNull(cobz.doct_id,
										mf.mf_id)	as doct_id,

            emp_nombre        as [Empresa], 

						IsNull(docCobz.doc_nombre,
									  docMf.doc_nombre)
															as Documento,

						IsNull('COB ' + cobz_nrodoc,
									 'MF '  + mf_nrodoc)
												      as [Doc. Comprobante],
						IsNull(cobz_numero,
									 mf_numero)
                             	as [Doc. Numero],

						cheq_numerodoc		as [Comprobante],
						cle_nombre        as [Clearing],
						cheq_fechacobro   as [Fecha Cobro],
						dateadd(d,cle_dias,cheq_fechacobro)
															as [Fecha Acreditacion],
						cheq_fechaVto			as [Fecha Vto.],

            case cheq_rechazado
            when 0 then 'No'
            else 'Si'
            end   as [Rechazado],
            cheq_fechaRechazo as [Fecha Rechazo],

            IsNull(l1.lgj_codigo,l2.lgj_codigo)
											        as [Legajo],

            case cheq_propio 
			            when 0 then 'No'
			            else 				'Si'
			      end   						as [Propio],

						cheq_importe      as [Importe],

            ltrim(
										isnull(cheq_descrip,'')
										+' '+
										isnull(cobz_descrip,'')
										+' '+
										isnull(mf_descrip,'')
									)	as [Observaciones]

from 

			Cheque cheq 
                  inner join Banco  b 						on cheq.bco_id    = b.bco_id
                  inner join Moneda m 						on cheq.mon_id 		= m.mon_id
                  inner join Empresa emp          on cheq.emp_id    = emp.emp_id 
									left  join Cliente cli          on cheq.cli_id    = cli.cli_id
									inner join Clearing cle         on cheq.cle_id    = cle.cle_id

									left  join Cobranza cobz        on cheq.cobz_id   = cobz.cobz_id
                  left  join Documento docCobz    on cobz.doc_id    = docCobz.doc_id
                  left  join Legajo l1            on cobz.lgj_id    = l1.lgj_id

									left  join MovimientoFondo mf   on cheq.mf_id     = mf.mf_id
                  left  join Documento docMf      on mf.doc_id      = docMf.doc_id
                  left  join Legajo l2            on mf.lgj_id      = l2.lgj_id

									left  join Cuenta c 						on cheq.cue_id 		= c.cue_id

where (
				(
						  @@Fini <= cobz_fecha
					and	@@Ffin >= cobz_fecha
				)
				or
				(
						  @@Fini <= mf_fecha
					and	@@Ffin >= mf_fecha
				)
			)

			and c.cuec_id = 1	-- Documentos en Cartera

			and cheq_rechazado = 0

			and (
						exists(select * from EmpresaUsuario where emp_id = cheq.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = cheq.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (c.cue_id = @cue_id or @cue_id=0)
and   (b.bco_id = @bco_id or @bco_id=0)
and   (cheq.cli_id = @cli_id or @cli_id=0)
and   (cheq.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = -1017 
                  and  rptarb_hojaid = c.cue_id
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
                  and  tbl_id = 13 
                  and  rptarb_hojaid = b.bco_id
							   ) 
           )
        or 
					 (@ram_id_banco = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cheq.cli_id
							   ) 
           )
        or 
					 (@ram_id_cliente = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = cheq.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )

end
go