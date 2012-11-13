/*---------------------------------------------------------------------
Nombre: Listado de Cheques
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0110 1,'20000101','20051231','0','0','0','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0110]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0110]

go
create procedure DC_CSC_TSR_0110 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cheq_id       varchar(255),
	@@cue_id		  	varchar(255),
	@@bco_id  			varchar(255),
	@@cli_id  			varchar(255),
	@@prov_id				varchar(255), 
	@@emp_id  			varchar(255)

)as 

begin

set nocount on

declare @bConCliente 		tinyint
declare @bConProveedor	tinyint

if @@cli_id  <> '0' set @bConCliente = 1
else								set @bConCliente = 0
if @@prov_id <> '0' set @bConProveedor = 1
else								set @bConProveedor = 0

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cheq_id  int
declare @cue_id 	int
declare @bco_id 	int
declare @cli_id 	int
declare @prov_id 	int
declare @emp_id 	int  --TODO:EMPRESA

declare @ram_id_cheque    int
declare @ram_id_cuenta 		int
declare @ram_id_banco 		int
declare @ram_id_cliente   int
declare @ram_id_proveedor int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cheq_id, @cheq_id out, @ram_id_cheque out
exec sp_ArbConvertId @@cue_id, 	@cue_id out, 	@ram_id_cuenta out
exec sp_ArbConvertId @@bco_id, 	@bco_id out, 	@ram_id_banco out
exec sp_ArbConvertId @@cli_id, 	@cli_id out, 	@ram_id_cliente out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
exec sp_ArbConvertId @@emp_id, 	@emp_id out, 	@ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_cheque <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cheque, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cheque, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cheque, @clienteID 
	end else 
		set @ram_id_cheque = 0
end

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
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

						1									as orden_id,
						cheq_id,
						cheq_rechazado 		as cheq_rechazado_id, -- Es para que la grilla oculte la columna
						cheq_propio       as cheq_propio_id,		-- Es para que la grilla oculte la columna

						IsNull(
				            IsNull(opg.opg_id,
				                   cobz.cobz_id),
                    mf.mf_id)	as comp_id,

						IsNull(
										IsNull(opg.doct_id,
													 cobz.doct_id),
										mf.mf_id)	as doct_id,

            emp_nombre        as [Empresa], 

						IsNull(
										IsNull(docOp.doc_nombre,
													 docCobz.doc_nombre),
									  docMf.doc_nombre)
															as Documento,

						IsNull(
						IsNull('OP '  + opg_nrodoc,
									 'COB ' + cobz_nrodoc),
									 'MF '  + mf_nrodoc)
												      as [Doc. Comprobante],
						IsNull(
						IsNull(opg_numero,
									 cobz_numero),
									 mf_numero)
                              	as [Doc. Numero],
						docCobz.doc_nombre  as [Doc. Cobranza],
						cobz_nrodoc       as [Cobranza],
            cobz_numero       as [Cobranza Numero],

						docMf.doc_nombre    as [Doc. Fondos],
						mf_nrodoc       		as [Mov. Fondos],
            mf_numero       		as [Mov. Fondos Numero],

						cli_codigo        as [Codigo],
						cli_nombre        as [Cliente],
            bco_nombre        as [Banco],
						IsNull(cue_nombre,'Entregado a Terceros')        
															as [Cuenta],
            mon_nombre        as [Moneda],
						cheq_numero				as [Numero],

			      cheq_numerodoc		as [Comprobante],

						cle_nombre        as [Clearing],
						cheq_fechacobro   as [Fecha Cobro],
						dateadd(d,cle_dias,cheq_fechacobro)
															as [Fecha Acreditacion],
						cheq_fechaVto			as [Fecha Vto.],

            case cheq_rechazado
			            when 0 then 'No'
			            else 				'Si'
			      end   						as [Rechazado],
            cheq_fechaRechazo as [Fecha Rechazo],

            case cheq_propio
			            when 0 then 'No'
			            else 				'Si'
			      end   						as [Propio],

            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
						docOp.doc_nombre  as [Doc. OP],
						opg_nrodoc        as [Orden Pago],
            opg_numero        as [Orden Pago Numero],
            prov_nombre       as [Proveedor],
						cheq_importe      as [Importe],
            cheq_descrip      as [Observaciones]

from 

			Cheque cheq 
                  inner join Banco  b 						on cheq.bco_id    = b.bco_id
                  inner join Moneda m 						on cheq.mon_id 		= m.mon_id
                  inner join Empresa emp          on cheq.emp_id    = emp.emp_id 
									inner join Clearing cle         on cheq.cle_id    = cle.cle_id

									left  join Cliente cli          on cheq.cli_id    = cli.cli_id
									left  join Cuenta c 						on cheq.cue_id 		= c.cue_id

									left  join Cobranza cobz        on cheq.cobz_id   = cobz.cobz_id
                  left  join Documento docCobz    on cobz.doc_id    = docCobz.doc_id

									left  join MovimientoFondo mf   on cheq.mf_id     = mf.mf_id
									left  join Documento docMf      on mf.doc_id      = docMf.doc_id


									left  join OrdenPago opg        on cheq.opg_id    = opg.opg_id
                  left  join Documento docOp      on opg.doc_id     = docOp.doc_id
                  left  join Proveedor p    			on cheq.prov_id   = p.prov_id
                  left  join Legajo l             on opg.lgj_id     = l.lgj_id

where 

				  @@Fini <= isnull(isnull(cobz_fecha,mf_fecha),opg_fecha)
			and	@@Ffin >= isnull(isnull(cobz_fecha,mf_fecha),opg_fecha)


			and (
						exists(select * from EmpresaUsuario where emp_id = cheq.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = cheq.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

			and (cheq.cli_id is not null or @bConCliente = 0)
			and (cheq.prov_id is not null or @bConProveedor = 0)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cheq.cheq_id = @cheq_id 	or @cheq_id=0)
and   (c.cue_id 		= @cue_id 	or @cue_id=0)
and   (b.bco_id 		= @bco_id 	or @bco_id=0)
and   (cheq.cli_id 	= @cli_id 	or @cli_id=0)
and   (cheq.prov_id = @prov_id 	or @prov_id=0)
and   (cheq.emp_id  = @emp_id 	or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 18001 
                  and  rptarb_hojaid = cheq.cheq_id
							   ) 
           )
        or 
					 (@ram_id_cheque = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
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
                  and  tbl_id = 29 
                  and  rptarb_hojaid = cheq.prov_id
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