if exists (select * from sysobjects where id = object_id(N'[dbo].[frHojaRutaRendicion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frHojaRutaRendicion]

/*

frHojaRutaRendicion 686

*/

go
create procedure [dbo].[frHojaRutaRendicion] (

  @@hr_id      int

)as 

begin

  set nocount on

-----------------------------------------------------------------------------------------------------------

  /*


    tipo_id =
                1 movimientos
                2 totales


  */

-----------------------------------------------------------------------------------------------------------


declare @total_a_rendir     decimal(18,6)
declare @total_cobrado      decimal(18,6)

declare @total_efectivo      decimal(18,6)
declare @total_cheques      decimal(18,6)
declare @total_retenciones  decimal(18,6)
declare @total_tickets      decimal(18,6)
declare @total_porc_tickets decimal(18,6)
declare @total_anulado      decimal(18,6)
declare @total_notascredito decimal(18,6)

declare @total_cuentacorriente  decimal(18,6)
declare @total_pendiente         decimal(18,6)

declare @total_otros        decimal(18,6)
declare @total_tarjeta      decimal(18,6)

declare @total_pagos        decimal(18,6)

declare @hr_porctickets      decimal(18,6)

declare @hr_faltante        decimal(18,6)

-----------------------------------------------------------------------------------------------------------

  select 
          @total_a_rendir     = sum(hri_acobrar),
          @total_cobrado      = sum(hri_cobrado),

          @total_anulado       = sum(hri_anulado),

          @total_efectivo      = sum(hri_efectivo),
          @total_cheques       = sum(hri_cheques),
          @total_retenciones  = sum(hri_retenciones),
          @total_tickets      = sum(hri_tickets),
          @total_notascredito  = sum(hri_notascredito),

          @total_cuentacorriente  = sum(case when hrct_id = 4 then hri_acobrar else 0 end),
          @total_pendiente        = sum(case when hrct_id = 7 then hri_acobrar else 0 end),

          @total_otros        = sum(hri_otros),
          @total_tarjeta      = sum(hri_tarjeta)

  from HojaRutaItem

  where hr_id = @@hr_id

  select @hr_porctickets = hr_porctickets, @hr_faltante = hr_faltante from HojaRuta where hr_id = @@hr_id

  set @total_porc_tickets = @total_tickets * @hr_porctickets /100

  set @total_pagos =  @total_anulado      
                    +  @total_notascredito  
                    +  @total_efectivo      
                    +  @total_cheques      
                    +  @total_retenciones  
                    +  @total_tickets      
                    +  @total_porc_tickets 
                    +  @total_otros        
                    +  @total_tarjeta      

-----------------------------------------------------------------------------------------------------------

  select  

          1      as tipo_id,

          hr.*,
          hri.*,

          prs_apellido + ', ' + prs_nombre    as persona,
          cam_codigo + ' - ' + cam_patente    as camion,

          cli_nombre,
          fv_nrodoc,
          fv_fecha,
          doc_nombre,
          doct_nombre,
          fv_total,
          
          hri_cobrado
          -hri_notascredito
          -hri_anulado    as cobrado,

          ''              as tipo,

          0  as total_a_rendir,          
          0 as total_cobrado,
          0 as total_cobrado_y_tickets,

          0 as total_anulado,
          0 as total_notascredito,          
          0 as total_efectivo,
          0 as total_cheques,
          0 as total_retenciones,
          0 as total_tickets,
          0 as total_proc_tickets,
          0 as total_otros,
          0 as total_tarjeta,
          0 as total_rendido,
          0 as total_pagos,
          0 as total_anuladonc,
                              
          0  as total_cuentacorriente,
          0 as total_pendiente
            


  from HojaRuta hr inner join HojaRutaItem hri     on hr.hr_id = hri.hr_id
                   inner join FacturaVenta fv      on hri.fv_id = fv.fv_id
                   inner join Cliente cli          on fv.cli_id = cli.cli_id
                   inner join Documento doc         on fv.doc_id = doc.doc_id
                   inner join DocumentoTipo doct  on fv.doct_id = doct.doct_id
                   left  join Persona prs         on hr.prs_id = prs.prs_id
                   left  join Camion cam          on hr.cam_id = cam.cam_id

  where hr.hr_id = @@hr_id

-----------------------------------------------------------------------------------------------------------
  union all
-----------------------------------------------------------------------------------------------------------

  select  

          2      as tipo_id,

          hr.*,
          hri.*,

          ''    as persona,
          ''    as camion,
          ''     as cli_nombre,
          ''     as fv_nrodoc,
          null   as fv_fecha,
          ''    as doc_nombre,
          ''     as doct_nombre,
          0      as fv_total,
          
          hri_cobrado        as cobrado,
          ''                as tipo,

          @total_a_rendir     as total_a_rendir,          

          @total_cobrado 
          - @total_anulado  
          - @total_notascredito  
                              as total_cobrado,

          @total_cobrado 
          - @total_anulado  
          - @total_notascredito  
          + @total_porc_tickets
                              as total_cobrado_y_tickets,

          @total_anulado      as total_anulado,
          @total_notascredito  as total_notascredito,          
          @total_efectivo      as total_efectivo,
          @total_cheques      as total_cheques,
          @total_retenciones  as total_retenciones,
          @total_tickets      as total_tickets,
          @total_porc_tickets as total_proc_tickets,
          @total_otros        as total_otros,
          @total_tarjeta      as total_tarjeta,

          @total_cobrado
          - @total_anulado  
          - @total_notascredito
          +@total_porc_tickets
          -@hr_faltante        as total_rendido,

          @total_cobrado
          - @total_anulado  
          - @total_notascredito
          +@total_porc_tickets
                              as total_pagos,

          @total_anulado  
          + @total_notascredito  
                              as total_anuladonc,
                              
          @total_cuentacorriente     as total_cuentacorriente,
          @total_pendiente           as total_pendiente
            

  from HojaRuta hr left join HojaRutaItem hri on hr.hr_id = hri.hr_id and 1=2

  where hr.hr_id = @@hr_id

end

