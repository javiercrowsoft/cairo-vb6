
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
/*
 DC_CSC_ENV_0040 	1,
									'20040802',
									'20040802',
									0,
									0,
									0,
									0,
									0,
									0,
									0,
									0,
									0,
									0
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_ENV_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_ENV_0040]

go
create procedure DC_CSC_ENV_0040 (
	@@us_id       int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@lgj_id 				varchar(255),
	@@cli_id 				varchar(255),
	@@mon_id				varchar(255),
	@@trans_id			varchar(255),
	@@barc_id				varchar(255),
	@@vue_id				varchar(255),
	@@pue_id				varchar(255),
	@@est_id				varchar(255),
	@@prov_id				varchar(255), 
  @@emp_id        varchar(255)

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

declare @lgj_id int
declare @cli_id int
declare @mon_id int
declare @trans_id int
declare @barc_id int
declare @vue_id int
declare @pue_id int
declare @est_id int
declare @prov_id int
declare @emp_id   int 

declare @ram_id_legajo int
declare @ram_id_cliente int
declare @ram_id_moneda int
declare @ram_id_transporte int
declare @ram_id_barco int
declare @ram_id_vuelo int
declare @ram_id_puerto int
declare @ram_id_estado int
declare @ram_id_proveedor int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@lgj_id, @lgj_id out, @ram_id_legajo out
exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@mon_id, @mon_id out, @ram_id_moneda out
exec sp_ArbConvertId @@trans_id, @trans_id out, @ram_id_transporte out
exec sp_ArbConvertId @@barc_id, @barc_id out, @ram_id_barco out
exec sp_ArbConvertId @@vue_id, @vue_id out, @ram_id_vuelo out
exec sp_ArbConvertId @@pue_id, @pue_id out, @ram_id_puerto out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_estado out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_legajo <> 0 begin

--	exec sp_ArbGetGroups @ram_id_legajo, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_legajo, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_legajo, @clienteID 
	end else 
		set @ram_id_legajo = 0
end

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_transporte <> 0 begin

--	exec sp_ArbGetGroups @ram_id_transporte, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_transporte, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_transporte, @clienteID 
	end else 
		set @ram_id_transporte = 0
end

if @ram_id_barco <> 0 begin

--	exec sp_ArbGetGroups @ram_id_barco, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_barco, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_barco, @clienteID 
	end else 
		set @ram_id_barco = 0
end

if @ram_id_vuelo <> 0 begin

--	exec sp_ArbGetGroups @ram_id_vuelo, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_vuelo, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_vuelo, @clienteID 
	end else 
		set @ram_id_vuelo = 0
end

if @ram_id_puerto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_puerto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_puerto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_puerto, @clienteID 
	end else 
		set @ram_id_puerto = 0
end

if @ram_id_estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_estado, @clienteID 
	end else 
		set @ram_id_estado = 0
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


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					LEGAJO
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              0                   as rslt_id,
              lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              '' as cpg_nombre,
              '' as suc_nombre,
              '' as Empresa, 

							'' as observaciones
  
    from legajo inner join estado          on legajo.est_id     = estado.est_id
                inner join legajotipo      on legajo.lgjt_id    = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id     = cliente.cli_id
                left  join moneda          on legajo.mon_id     = moneda.mon_id

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 

					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )
					
  union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					PARTES DIARIOS
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              1                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              ptd_numero,
              ptd_alarma,
              ptd_fechaini,
              ptd_fechafin,
              cliptd.cli_nombre as ptdcli_nombre,
              case ptd_cumplida
                  when 1 then 'Pendiente'  -- csECumplida_Pendiente = 1
                  when 2 then 'Rechazada'  -- csECumplida_Rechazada = 2
                  when 3 then 'Cumplido'   -- csECumplida_Cumplida = 3
              end               as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              '' as cpg_nombre,
              '' as suc_nombre,
              '' as Empresa, 

							case 
									when ptd_descrip  <> '' then ptd_titulo + char(10)+char(13)+ptd_descrip
									else												 ptd_titulo
							end	as observaciones

    from legajo inner join estado          on legajo.est_id         = estado.est_id
                inner join legajotipo      on legajo.lgjt_id        = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id         = cliente.cli_id
                left  join moneda          on legajo.mon_id         = moneda.mon_id
                inner join partediario     on legajo.lgj_id         = partediario.lgj_id
                left  join cliente cliptd  on partediario.cli_id    = cliptd.cli_id

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 

					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )

	union all					

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					PEDIDO VENTA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              2                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

              pv_numero,
              pv_nrodoc,
              pv_fecha,
              pv_pendiente,
              clipv.cli_nombre as pvcli_nombre,
              pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,              
              emp_nombre as Empresa, 

							pv_descrip as observaciones

    from legajo inner join estado          on legajo.est_id         = estado.est_id
                inner join legajotipo      on legajo.lgjt_id        = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id         = cliente.cli_id
                left  join moneda          on legajo.mon_id         = moneda.mon_id
                inner join pedidoVenta     on legajo.lgj_id         = pedidoVenta.lgj_id
                inner join cliente clipv   on pedidoVenta.cli_id    = clipv.cli_id
                inner join condicionpago   on pedidoVenta.cpg_id    = condicionpago.cpg_id
                inner join sucursal        on pedidoVenta.suc_id    = sucursal.suc_id
                inner join Documento doc   on pedidoVenta.doc_id    = doc.doc_id
                inner join Empresa         on doc.emp_id            = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 
					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
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

  union all
					
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					REMITO VENTA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              3                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

              rv_numero,
              rv_nrodoc,
              rv_fecha,
              rv_pendiente,
              clirv.cli_nombre as rvcli_nombre,
              rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,              
              emp_nombre as Empresa, 

							rv_descrip as observaciones

    from legajo inner join estado          on legajo.est_id         = estado.est_id
                inner join legajotipo      on legajo.lgjt_id        = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id         = cliente.cli_id
                left  join moneda          on legajo.mon_id         = moneda.mon_id
                inner join remitoventa     on legajo.lgj_id         = remitoventa.lgj_id
                inner join cliente clirv   on remitoventa.cli_id    = clirv.cli_id
                inner join condicionpago   on remitoventa.cpg_id    = condicionpago.cpg_id
                inner join sucursal        on remitoventa.suc_id    = sucursal.suc_id
                inner join Documento doc   on remitoventa.doc_id    = doc.doc_id
                inner join Empresa         on doc.emp_id            = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 
					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
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

	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					FACTURA VENTA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              4                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              fv_numero,
              fv_nrodoc,
              fv_fecha,
              fv_pendiente,
              clifac.cli_nombre as fvcli_nombre,
              fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,              
              emp_nombre as Empresa, 

							fv_descrip as observaciones

    from legajo inner join estado          on legajo.est_id         = estado.est_id
                inner join legajotipo      on legajo.lgjt_id        = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id         = cliente.cli_id
                left  join moneda          on legajo.mon_id         = moneda.mon_id
                inner join facturaventa    on legajo.lgj_id         = facturaventa.lgj_id
                inner join cliente clifac  on facturaventa.cli_id   = clifac.cli_id
                inner join condicionpago   on facturaventa.cpg_id   = condicionpago.cpg_id
                inner join sucursal        on facturaventa.suc_id   = sucursal.suc_id
                inner join Documento doc   on facturaventa.doc_id   = doc.doc_id
                inner join Empresa         on doc.emp_id            = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 
					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
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
					
	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					COBRANZAS
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              5                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							cobz_numero,
              cobz_nrodoc,
              cobz_fecha,
              cobz_pendiente,
              clicob.cli_nombre as cobcli_nombre,
              cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              '' as cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							cobz_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id

                inner join Cobranza           on legajo.lgj_id         	= Cobranza.lgj_id
                inner join Cliente cliCob     on Cobranza.cli_id        = clicob.cli_id
                inner join sucursal           on cobranza.suc_id   			= sucursal.suc_id

                inner join Documento doc      on Cobranza.doc_id        = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id   

								left  join transporte         on legajo.trans_id        = transporte.trans_id
								left  join barco              on legajo.barc_id         = barco.barc_id
								left  join vuelo              on legajo.vue_id          = vuelo.vue_id
								left  join puerto             on legajo.pue_id          = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
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
					
	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					ORDEN DE COMPRA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              6                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

              oc_numero,
              oc_nrodoc,
              oc_fecha,
              oc_pendiente,
              provoc.prov_nombre,
              oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							oc_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id
                inner join ordenCompra        on legajo.lgj_id         	= ordenCompra.lgj_id
                inner join proveedor provoc   on ordenCompra.prov_id    = provoc.prov_id
                inner join condicionpago      on ordenCompra.cpg_id     = condicionpago.cpg_id
                inner join sucursal           on ordenCompra.suc_id     = sucursal.suc_id
                inner join Documento doc      on ordenCompra.doc_id     = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					and   (provoc.prov_id = @prov_id or @prov_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 29 
					                  and  rptarb_hojaid = provoc.prov_id
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
					                  and  tbl_id = 1018 
					                  and  rptarb_hojaid = doc.emp_id
												   ) 
					           )
					        or 
										 (@ram_id_Empresa = 0)
								 )

	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					REMITO DE COMPRA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              7                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

              rc_numero,
              rc_nrodoc,
              rc_fecha,
              rc_pendiente,
              provrc.prov_nombre,
              rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							rc_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id
                inner join remitoCompra       on legajo.lgj_id         	= remitoCompra.lgj_id
                inner join proveedor provrc   on remitoCompra.prov_id   = provrc.prov_id
                inner join condicionpago      on remitoCompra.cpg_id    = condicionpago.cpg_id
                inner join sucursal           on remitoCompra.suc_id    = sucursal.suc_id
                inner join Documento doc      on remitoCompra.doc_id    = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					and   (provrc.prov_id = @prov_id or @prov_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 29 
					                  and  rptarb_hojaid = provrc.prov_id
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
					                  and  tbl_id = 1018 
					                  and  rptarb_hojaid = doc.emp_id
												   ) 
					           )
					        or 
										 (@ram_id_Empresa = 0)
								 )

	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					FACTURA DE COMPRA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              8                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              fc_numero,
              fc_nrodoc,
              fc_fecha,
              fc_pendiente,
              provfac.prov_nombre,
              fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							fc_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id
                inner join facturaCompra      on legajo.lgj_id         	= facturaCompra.lgj_id
                inner join proveedor provfac  on facturaCompra.prov_id  = provfac.prov_id
                inner join condicionpago      on facturaCompra.cpg_id   = condicionpago.cpg_id
                inner join sucursal           on facturaCompra.suc_id   = sucursal.suc_id
                inner join Documento doc      on facturaCompra.doc_id   = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					and   (provfac.prov_id = @prov_id or @prov_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 29 
					                  and  rptarb_hojaid = provfac.prov_id
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
					                  and  tbl_id = 1018 
					                  and  rptarb_hojaid = doc.emp_id
												   ) 
					           )
					        or 
										 (@ram_id_Empresa = 0)
								 )

	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					FACTURA DE COMPRA
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              8                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              fc_numero,
              fc_nrodoc,
              fc_fecha,
              fclgj_importe * (fc_pendiente / fc_total),
              provfac.prov_nombre,
              fclgj_importe,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							fc_descrip as observaciones

    from legajo inner join estado          	   on legajo.est_id              = estado.est_id
                inner join legajotipo      	   on legajo.lgjt_id             = legajotipo.lgjt_id
                left  join cliente             on legajo.cli_id              = cliente.cli_id
                left  join moneda              on legajo.mon_id          		 = moneda.mon_id
								inner join FacturaCompraLegajo on legajo.lgj_id              = FacturaCompraLegajo.lgj_id
                inner join facturaCompra       on FacturaCompraLegajo.fc_id  = facturaCompra.fc_id
                inner join proveedor provfac   on facturaCompra.prov_id      = provfac.prov_id
                inner join condicionpago       on facturaCompra.cpg_id       = condicionpago.cpg_id
                inner join sucursal            on facturaCompra.suc_id       = sucursal.suc_id
                inner join Documento doc       on facturaCompra.doc_id       = doc.doc_id
                inner join Empresa             on doc.emp_id                 = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					and   (provfac.prov_id = @prov_id or @prov_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 29 
					                  and  rptarb_hojaid = provfac.prov_id
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
					                  and  tbl_id = 1018 
					                  and  rptarb_hojaid = doc.emp_id
												   ) 
					           )
					        or 
										 (@ram_id_Empresa = 0)
								 )

	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					ORDENES DE PAGO
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              9                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							opg_numero,
              opg_nrodoc,
              opg_fecha,
              opg_pendiente,
              provopg.prov_nombre as opgprov_nombre,
              opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              '' as cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							opg_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id

                inner join OrdenPago          on legajo.lgj_id         	= OrdenPago.lgj_id
                inner join Proveedor provopg  on OrdenPago.prov_id      = provopg.prov_id
                inner join sucursal           on OrdenPago.suc_id   		= sucursal.suc_id

                inner join Documento doc      on OrdenPago.doc_id       = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id 
  
								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
					and   (provopg.prov_id = @prov_id or @prov_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 29 
					                  and  rptarb_hojaid = provopg.prov_id
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
					                  and  tbl_id = 1018 
					                  and  rptarb_hojaid = doc.emp_id
												   ) 
					           )
					        or 
										 (@ram_id_Empresa = 0)
								 )

	union all

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					MOVIMIENTOS DE FONDO
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              10                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							doc_nombre as doc_movimientofondo,
							mf_numero,
							mf_nrodoc,
							mf_fecha,
							mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							'' as doc_stock,
							0 as st_numero,
							'' as st_nrodoc,
							'19000101' as st_fecha,
              '' as st_origen,
              '' as st_destino,

              '' as cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							mf_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id

                inner join MovimientoFondo mf on legajo.lgj_id         	= mf.lgj_id
                inner join sucursal           on mf.suc_id   		        = sucursal.suc_id

                inner join Documento doc      on mf.doc_id              = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id 
  
								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
 			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
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

  union all
					
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////
--///////					MOVIMIENTO DE STOCK
--///////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    select
              11                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              0 as ptd_numero,
              '19000101' as ptd_alarma,
              '19000101' as ptd_fechaini,
              '19000101' as ptd_fechafin,
              '' as ptdcli_nombre,
							'' as ptd_cumplida,

              0 as fv_numero,
              '' as fv_nrodoc,
              '19000101' as fv_fecha,
              0 as fv_pendiente,
              '' as fvcli_nombre,
              0 as fv_total,

              0 as fc_numero,
              '' as fc_nrodoc,
              '19000101' as fc_fecha,
              0 as fc_pendiente,
              '' as prov_nombre,
              0 as fc_total,

							0 as cobz_numero,
              '' as cobz_nrodoc,
              '19000101' as cobz_fecha,
              0 as cobz_pendiente,
              '' as cobcli_nombre,
              0 as cobz_total,

							0 as opg_numero,
              '' as opg_nrodoc,
              '19000101' as opg_fecha,
              0 as opg_pendiente,
              '' as opgprov_nombre,
              0 as opg_total,

							'' as doc_movimientofondo,
							0 as mf_numero,
							'' as mf_nrodoc,
							'19000101' as mf_fecha,
							0 as mf_total,

							0 as pv_numero,
							'' as pv_nrodoc,
							'19000101' as pv_fecha,
              0 as pv_pendiente,
              '' as pvcli_nombre,
							0 as pv_total,

							0 as rv_numero,
							'' as rv_nrodoc,
							'19000101' as rv_fecha,
              0 as rv_pendiente,
              '' as rvcli_nombre,
							0 as rv_total,

							0 as oc_numero,
							'' as oc_nrodoc,
							'19000101' as oc_fecha,
              0 as oc_pendiente,
              '' as ocprov_nombre,
							0 as oc_total,

							0 as rc_numero,
							'' as rc_nrodoc,
							'19000101' as rc_fecha,
              0 as rc_pendiente,
              '' as rcprov_nombre,
							0 as rc_total,

							doc_nombre as doc_stock,
							st_numero,
							st_nrodoc,
							st_fecha,
              o.depl_nombre as st_origen,
              d.depl_nombre as st_destino,

              '' as cpg_nombre,
              suc_nombre,
              emp_nombre as Empresa, 

							st_descrip as observaciones

    from legajo inner join estado          	  on legajo.est_id          = estado.est_id
                inner join legajotipo      	  on legajo.lgjt_id         = legajotipo.lgjt_id
                left  join cliente            on legajo.cli_id          = cliente.cli_id
                left  join moneda             on legajo.mon_id          = moneda.mon_id
                inner join stock              on legajo.lgj_id         	= stock.lgj_id
								inner join depositologico o   on stock.depl_id_origen   = o.depl_id
								inner join depositologico d   on stock.depl_id_destino  = d.depl_id
                inner join sucursal           on stock.suc_id    				= sucursal.suc_id
                inner join Documento doc      on stock.doc_id           = doc.doc_id
                inner join Empresa            on doc.emp_id             = Empresa.emp_id 

								left  join transporte      on legajo.trans_id   = transporte.trans_id
								left  join barco           on legajo.barc_id    = barco.barc_id
								left  join vuelo           on legajo.vue_id     = vuelo.vue_id
								left  join puerto          on legajo.pue_id     = puerto.pue_id
    where 

				  lgj_fecha >= @@Fini
			and	lgj_fecha <= @@Ffin 


			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = Cliente.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)


					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
					and   (Cliente.cli_id = @cli_id or @cli_id=0)
					and   (Moneda.mon_id = @mon_id or @mon_id=0)
					and   (Transporte.trans_id = @trans_id or @trans_id=0)
					and   (Barco.barc_id = @barc_id or @barc_id=0)
					and   (Vuelo.vue_id = @vue_id or @vue_id=0)
					and   (Puerto.pue_id = @pue_id or @pue_id=0)
					and   (Estado.est_id = @est_id or @est_id=0)
          and   (Empresa.emp_id = @emp_id or @emp_id=0) 					
					-- Arboles
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15001 
					                  and  rptarb_hojaid = Legajo.lgj_id
												   ) 
					           )
					        or 
										 (@ram_id_legajo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 28 
					                  and  rptarb_hojaid = Legajo.cli_id
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
					                  and  tbl_id = 12 
					                  and  rptarb_hojaid = Legajo.mon_id
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
					                  and  tbl_id = 34 
					                  and  rptarb_hojaid = Legajo.trans_id
												   ) 
					           )
					        or 
										 (@ram_id_transporte = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12004 
					                  and  rptarb_hojaid = Legajo.barc_id
												   ) 
					           )
					        or 
										 (@ram_id_barco = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 15006 
					                  and  rptarb_hojaid = Legajo.vue_id
												   ) 
					           )
					        or 
										 (@ram_id_vuelo = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 12005 
					                  and  rptarb_hojaid = Legajo.pue_id
												   ) 
					           )
					        or 
										 (@ram_id_puerto = 0)
								 )
					
					and   (
										(exists(select rptarb_hojaid 
					                  from rptArbolRamaHoja 
					                  where
					                       rptarb_cliente = @clienteID
					                  and  tbl_id = 4005 
					                  and  rptarb_hojaid = Legajo.est_id
												   ) 
					           )
					        or 
										 (@ram_id_estado = 0)
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

	order by Legajo.lgj_id

end
go