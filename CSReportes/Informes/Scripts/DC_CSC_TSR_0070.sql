if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0070]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0070]

go

/*

DC_CSC_TSR_0070
                  1,
                  '20040101',
                  '20140101',
                  '0',
                  '0',
                  '0',
                  '0'

*/
create procedure DC_CSC_TSR_0070 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cue_id varchar(255),
@@mon_id varchar(255),
@@suc_id	varchar(255),
@@emp_id	varchar(255)

)as 
begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id int
declare @mon_id int
declare @suc_id int
declare @emp_id int

declare @ram_id_cuenta int
declare @ram_id_moneda int
declare @ram_id_sucursal int
declare @ram_id_empresa int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out
exec sp_ArbConvertId @@mon_id, @mon_id out, @ram_id_moneda out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

exec sp_GetRptId @clienteID out

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

if @ram_id_sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_sucursal, @clienteID 
	end else 
		set @ram_id_sucursal = 0
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


select 

        0                                as Orden,
        cobz_fecha                       as Fecha,
        case 
            when cheq.cheq_id is not null then 'Cheque'
            when tjcc.tjcc_id is not null then 'Tarjeta'
            else                               'Efectivo'
        end                              as Tipo,
        mon_nombre                       as Moneda,
        emp_nombre                       as Empresa,
        doc_nombre                       as Documento,
        cli_nombre                       as Tercero,
        cobz_numero                      as Numero,
        cobz_nrodoc                      as Comprobante,
        cheq_numero                      as [Ch. Nro.],
        cheq_numerodoc                   as Cheque,
        bco_nombre                       as Banco,
        tjcc_numero                      as [Cp. Nro.],
        tjcc_numerodoc                   as Cupon,
        tjc_nombre                       as Tarjeta,
        cobzi_importe                    as Ingreso,
        cobzi_importeorigen              as IngresoOrigen,
        0                                as Egreso,
        0                                as EgresoOrigen,
        cobz_descrip                     as Observaciones

from 

        Cobranza cobz  inner join CobranzaItem cobzi           on cobz.cobz_id       = cobzi.cobz_id
                       inner join Cliente cli                  on cobz.cli_id        = cli.cli_id
                       inner join Cuenta cue                   on cobzi.cue_id       = cue.cue_id
                       inner join Moneda mon                   on cue.mon_id         = mon.mon_id
                       inner join Sucursal suc                 on cobz.suc_id        = suc.suc_id
                       inner join Documento doc                on cobz.doc_id        = doc.doc_id
                       inner join Empresa emp                  on doc.emp_id         = emp.emp_id
                       left  join Cheque cheq                  on cobzi.cheq_id      = cheq.cheq_id
                       left  join Banco bco                    on cheq.bco_id        = bco.bco_id
                       left  join TarjetaCreditoCupon tjcc     on cobzi.tjcc_id      = tjcc.tjcc_id
                       left  join TarjetaCredito tjc           on tjcc.tjc_id        = tjc.tjc_id
where 

				  cobz_fecha >= @@Fini
			and	cobz_fecha <= @@Ffin 

-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (mon.mon_id = @mon_id or @mon_id=0)
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cobzi.cue_id
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
                  and  tbl_id = 12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cue.mon_id
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
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cobz.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

union all

select 

        1                                as Orden,
        opg_fecha                        as Fecha,
        case 
            when cheq.cheq_id is not null then 'Cheque'
            else                               'Efectivo'
        end                              as Tipo,
        mon_nombre                       as Moneda,
        emp_nombre                       as Empresa,
        doc_nombre                       as Documento,
        prov_nombre                      as Tercero,
        opg_numero                       as Numero,
        opg_nrodoc                       as Comprobante,
        cheq_numero                      as [Ch. Nro.],
        cheq_numerodoc                   as Cheque,
        bco_nombre                       as Banco,
        0                                as [Cp. Nro.],
        ''                               as Cupon,
        ''                               as Tarjeta,
        0                                as Ingreso,
        0                                as IngresoOrigen,
        opgi_importe                     as Egreso,
        opgi_importeorigen               as EgresoOrigen,
        opg_descrip                      as Observaciones

from 

        OrdenPago opg  inner join OrdenPagoItem opgi           on opg.opg_id        = opgi.opg_id
                       inner join Proveedor prov               on opg.prov_id       = prov.prov_id
                       inner join Cuenta cue                   on opgi.cue_id       = cue.cue_id
                       inner join Moneda mon                   on cue.mon_id        = mon.mon_id
                       inner join Sucursal suc                 on opg.suc_id        = suc.suc_id
                       inner join Documento doc                on opg.doc_id        = doc.doc_id
                       inner join Empresa emp                  on doc.emp_id        = emp.emp_id
                       left  join Cheque cheq                  on opgi.cheq_id      = cheq.cheq_id
                       left  join Banco bco                    on cheq.bco_id       = bco.bco_id
where 

				  opg_fecha >= @@Fini
			and	opg_fecha <= @@Ffin 

-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (mon.mon_id = @mon_id or @mon_id=0)
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = opgi.cue_id
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
                  and  tbl_id = 12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cue.mon_id
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
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = opg.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

union all

select 
        3                                as Orden,
        mf_fecha                         as Fecha,
        'Efectivo'                       as Tipo,
        mon_nombre                       as Moneda,
        emp_nombre                       as Empresa,
        doc_nombre                       as Documento,
        ''                               as Tercero,
        mf_numero                        as Numero,
        mf_nrodoc                        as Comprobante,
        ''                               as [Ch. Nro.],
        ''                               as Cheque,
        ''                               as Banco,
        0                                as [Cp. Nro.],
        ''                               as Cupon,
        ''                               as Tarjeta,
        0                                as Ingreso,
        0                                as IngresoOrigen,
        mfi_importe                      as Egreso,
        mfi_importeorigen                as EgresoOrigen,
        mf_descrip                       as Observaciones

from 

        MovimientoFondo mf   inner join MovimientoFondoItem mfi      on mf.mf_id          = mfi.mf_id
                             inner join Cuenta cue                   on mfi.cue_id_haber  = cue.cue_id
                             inner join Moneda mon                   on cue.mon_id        = mon.mon_id
                             inner join Sucursal suc                 on mf.suc_id         = suc.suc_id
                             inner join Documento doc                on mf.doc_id         = doc.doc_id
                             inner join Empresa emp                  on doc.emp_id        = emp.emp_id
where 

				  mf_fecha >= @@Fini
			and	mf_fecha <= @@Ffin 

-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id = @cue_id or @cue_id=0)
and   (mon.mon_id = @mon_id or @mon_id=0)
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfi.cue_id_haber
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
                  and  tbl_id = 12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cue.mon_id
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
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mf.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

union all

select 
        3                                as Orden,
        mf_fecha                         as Fecha,
        'Efectivo'                       as Tipo,
        mon_nombre                       as Moneda,
        emp_nombre                       as Empresa,
        doc_nombre                       as Documento,
        ''                               as Tercero,
        mf_numero                        as Numero,
        mf_nrodoc                        as Comprobante,
        ''                               as [Ch. Nro.],
        ''                               as Cheque,
        ''                               as Banco,
        0                                as [Cp. Nro.],
        ''                               as Cupon,
        ''                               as Tarjeta,
        mfi_importe                      as Ingreso,
        mfi_importeorigen                as IngresoOrigen,
        0                                as Egreso,
        0                                as EgresoOrigen,
        mf_descrip                       as Observaciones

from 

        MovimientoFondo mf   inner join MovimientoFondoItem mfi      on mf.mf_id          = mfi.mf_id
                             inner join Cuenta cue                   on mfi.cue_id_debe   = cue.cue_id
                             inner join Moneda mon                   on cue.mon_id        = mon.mon_id
                             inner join Sucursal suc                 on mf.suc_id         = suc.suc_id
                             inner join Documento doc                on mf.doc_id         = doc.doc_id
                             inner join Empresa emp                  on doc.emp_id        = emp.emp_id
where 

				  mf_fecha >= @@Fini
			and	mf_fecha <= @@Ffin 

-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id = @cue_id or @cue_id=0)
and   (mon.mon_id = @mon_id or @mon_id=0)
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mfi.cue_id_debe
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
                  and  tbl_id = 12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cue.mon_id
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
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = mf.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

order by Fecha, Tipo, Moneda, Orden

end
go