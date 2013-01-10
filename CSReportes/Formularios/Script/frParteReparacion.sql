/*

select * from ParteReparacion
frParteReparacion 2

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frParteReparacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frParteReparacion]

go
create procedure frParteReparacion (

  @@prp_id      int

)as 

begin

  select prp_fechaentrega as [Fecha entrega], 
         prp_numero,
         prp_nrodoc,
         doc_nombre, 
         ccos_nombre, 
         cli_nombre as Cliente, 
         cpg_nombre as [Condicion de pago], 
         cli_cuit,
         prpi_neto             as [Importe neto],
         prpi_cantidad         as [Cantidad],
         prpi_ivari            as [IvaRI],
         prpi_precio           as [Precio],
         prpi_importe          as [Importe],
         pr.pr_descripventa   as [Descrip. Producto],
         prp_descrip           as Descripcion,
         cli_tel               as Telefono,

      case cli_catfiscal
        when 1 then 'Inscripto'
        when 2 then 'Exento'
        when 3 then 'No inscripto'
        when 4 then 'Consumidor Final'
        when 5 then 'Extranjero'
        when 6 then 'Mono Tributo'
        when 7 then 'Extranjero Iva'
        when 8 then 'No responsable'
        when 9 then 'No Responsable exento'
        when 10 then 'No categorizado'
        when 11 then 'Inscripto M'
        else 'Sin categorizar'
      end as cat_fisctal,

      cli_calle + ' ' +
      cli_callenumero + ' ' +
      cli_piso + ' ' +
      cli_depto + ' (' +
      cli_codpostal + ')'   as direccion,
      cli_localidad,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,

      case 
          when len(pr.pr_nombreventa)>0 then pr.pr_nombreventa     
          else                               pr.pr_nombrecompra
      end                    as Producto,

      emp_nombre,
      clis_nombre,
      mon_nombre,
      mon_signo,

      prs.pr_nombreventa    as Equipo,
      prns.prns_codigo      as Serie,
      prnsi.prns_codigo     as [Serie Repuesto],

      os_nrodoc,
      os_fecha
      

  from ParteReparacion prp inner join ParteReparacionItem prpi  on prp.prp_id   = prpi.prp_id
                           inner join Documento doc              on prp.doc_id   = doc.doc_id
                           inner join Moneda mon                 on doc.mon_id   = mon.mon_id        
                           inner join Cliente cli                on prp.cli_id   = cli.cli_id
                           inner join CondicionPago cpg          on prp.cpg_id   = cpg.cpg_id
                           inner join Producto pr                on prpi.pr_id   = pr.pr_id
                           inner join Empresa emp                on doc.emp_id   = emp.emp_id

                           inner join ProductoNumeroSerie prns  on prp.prns_id  = prns.prns_id
                           inner join Producto prs              on prns.pr_id   = prs.pr_id

                           left join  Legajo lgj                 on prp.lgj_id   = lgj.lgj_id
                           left join  CentroCosto ccos          on prpi.ccos_id = ccos.ccos_id
                           left join  ClienteSucursal clis      on prp.clis_id  = clis.clis_id

                           left join  OrdenServicio os          on prp.os_id    = os.os_id

                           left join  Stockitem sti              on   prp.st_id    = sti.st_id 
                                                                and prpi.prpi_id = sti.sti_grupo
                                                                and sti_ingreso  > 0

                           left join  ProductoNumeroSerie prnsi  on sti.prns_id = prnsi.prns_id

  where prp.prp_id = @@prp_id
  order by prpi_orden
end
go

