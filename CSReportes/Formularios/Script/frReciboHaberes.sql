/*

select * from liquidacion

frReciboHaberes 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frReciboHaberes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frReciboHaberes]

go
create procedure frReciboHaberes (

  @@liq_id      int,
  @@em_id       int = 0

)as 

begin

  set nocount on

  if @@liq_id < 0 select @@em_id = em_id, @@liq_id = liq_id from LiquidacionItem where liqi_id = @@liq_id *-1

  create table #t_recibo (liqi_id int, haberes decimal(18,6), retenciones decimal(18,6))

  insert into #t_recibo (liqi_id, haberes, retenciones)
  select   liqic.liqi_id, 
          sum(case when liqic_importe>0 then liqic_importe else 0 end),
          sum(case when liqic_importe<0 then liqic_importe else 0 end)
  from LiquidacionItemCodigo liqic inner join LiquidacionItem liqi on liqic.liqi_id = liqi.liqi_id
  where liqic.liq_id = @@liq_id
    and (liqi.em_id = @@em_id or @@em_id = 0)
  group by
    liqic.liqi_id
  
  select 
          liqic.*,
          liq.*,
          em_apellido + ', ' + em_nombre + ' [' + em_codigo + ']' as empleado,
          em_apellido + ', ' + em_nombre as empleado_nombre,
          em_calle + ' ' +
          em_callenumero + ' ' +
          em_piso + ' ' +
          em_depto        as empleado_direccion,
    
          em_localidad + ' - ' +
          em_codpostal     as empleado_localidad,

          em.*,
          liqfi_codigo,
          liqfi_nombre,
          liqfi_descrip,
          liqi_descrip,
          liqi_importe,
          liqi_nrodoc,
          sind_nombre,
          sindco_nombre,
          sindco_codigo,
          sindca_nombre,
          sindca_codigo,

          emp.*,
          emp_calle + ' ' +
          emp_callenumero + ' ' +
          emp_piso + ' ' +
          emp_depto        as empresa_direccion,

          emp_localidad + ' - ' +
          emp_codpostal   as empresa_localidad,

          t.haberes,
          t.retenciones

  from LiquidacionItemCodigo liqic inner join LiquidacionItem liqi on liqic.liqi_id = liqi.liqi_id
                                   inner join Liquidacion liq on liqic.liq_id = liq.liq_id
                                   inner join Empleado em on liqi.em_id = em.em_id
                                   inner join LiquidacionFormulaItem liqfi on liqic.liqfi_id = liqfi.liqfi_id

                                   inner join Documento doc on liq.doc_id = doc.doc_id
                                   inner join Empresa emp on doc.emp_id = emp.emp_id

                                   left  join Sindicato sind on em.sind_id = sind.sind_id
                                   left  join SindicatoConvenio sindco on em.sindco_id = sindco.sindco_id
                                   left  join SindicatoCategoria sindca on em.sindca_id = sindca.sindca_id
                                   left  join #t_recibo t on liqi.liqi_id = t.liqi_id

  where liqic.liq_id = @@liq_id
    and (liqi.em_id = @@em_id or @@em_id = 0)

  order by em_apellido + ', ' + em_nombre + ' [' + em_codigo + ']'
end
go