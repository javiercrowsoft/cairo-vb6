if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EquipoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EquipoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(al_id) from tarea

-- sp_EquipoGet 131

create procedure sp_EquipoGet (
  @@prns_id  int
)
as

set nocount on

begin

  -- Detalle del equipo
  --
  select  prns.*,
          prnss_id,
          prnss.prns_codigo4,
          prnss.prns_codigo5,
          prnss.prns_codigo6,
          prnss.prns_codigo7,
          prnss.os_id,
          prnss.prp_id,
          prnss.stprov_id,
          prnss.cli_id,
          prnss.cont_id,
          prnss.prov_id,
          prnss.etf_id,
          prnss.tar_id_activa,
          pr_nombrecompra,
          pr_nombreventa,
          os_nrodoc,
          os_fecha,
          etf_nombre,
          etf_codigo,
          prp_nrodoc,
          cont_nombre,
          cont_tel,
          cont_email,
          cont_celular,
          cont_fax,
          cont_cargo,
          cont_direccion,
          cont_codpostal,
          cont_ciudad,
          cont_provincia,
          cli_nombre,
          prov_nombre,
          stprov_nrodoc,
          prp_descrip,
          depl_nombre,
          tar_nombre,
          us_nombre,
          prp_estado,
          rv_retiro,
          rv_guia,
          trans_nombre

  from ProductoNumeroSerie prns 
          inner join Producto pr                        on prns.pr_id   = pr.pr_id
          left  join ProductoNumeroSerieServicio prnss  on prns.prns_id  = prnss.prnss_id

                                left join OrdenServicio os       on prnss.os_id       = os.os_id
                                left join Contacto cont          on prnss.cont_id     = cont.cont_id
                                left join Cliente cli            on prnss.cli_id      = cli.cli_id
                                left join ParteReparacion prp    on prnss.prp_id      = prp.prp_id
                                left join StockProveedor stprov on prnss.stprov_id   = stprov.stprov_id
                                left join Proveedor prov        on prnss.prov_id     = prov.prov_id
                                left join EquipoTipoFalla etf   on prnss.etf_id      = etf.etf_id
                                left join DepositoLogico depl   on prns.depl_id     = depl.depl_id
                                left join Tarea tar             on prnss.tar_id_activa   = tar.tar_id
                                left join Usuario us            on tar.us_id_responsable = us.us_id
                                left join RemitoVenta rv        on prnss.rv_id       = rv.rv_id
                                left join Transporte trans      on rv.trans_id      = trans.trans_id

  where prns.prns_id = @@prns_id                                


  -- Comentarios - Laboratorio
  --
  select ptd.* 
  from ParteDiario ptd inner join Departamento dpto on ptd.dpto_id = dpto.dpto_id
  where prns_id  = @@prns_id          
    and dptot_id = 3

  -- Comentarios - Call Center
  --
  select ptd.* 
  from ParteDiario ptd inner join Departamento dpto on ptd.dpto_id = dpto.dpto_id
  where prns_id  = @@prns_id          
    and dptot_id = 4

  -- Comentarios - Administracion y otros
  --
  select ptd.* 
  from ParteDiario ptd inner join Departamento dpto on ptd.dpto_id = dpto.dpto_id
  where prns_id  = @@prns_id          
    and dptot_id not in (3,4)

          
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



