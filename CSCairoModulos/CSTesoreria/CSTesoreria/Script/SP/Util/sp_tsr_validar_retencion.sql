if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tsr_validar_retencion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tsr_validar_retencion]

-- frRetencionIIBB 0

go
create procedure sp_tsr_validar_retencion (

  @@opg_id      int

)as 

begin

  set nocount on

  -- Cabecera
  --
  declare @emp_id     int
  declare @opg_total   decimal(18,6)

  select  @emp_id    = emp_id,
          @opg_total = opg_total

  from OrdenPago where opg_id = @@opg_id

  declare @emp_razonsocial varchar(255)
  declare @emp_cuit        varchar(255)

  select  @emp_razonsocial   = emp_razonsocial,
          @emp_cuit         = emp_cuit

  from Empresa where emp_id = @emp_id

  -- Retenciones
  --
  create table #t_frRetencionIIBB (opgi_id int, alicuota decimal(18,6))

  declare @alicuota     decimal(18,6)
  declare @ret_id       int
  declare @opgi_id       int
  declare @ret_nrodoc    varchar(255)
  
  declare c_opgi insensitive cursor for 

    select opgi.ret_id, 
           opgi_id,
           opgi_nroRetencion
  
    from OrdenPagoItem opgi inner join Retencion ret on opgi.ret_id = ret.ret_id
    where opg_id = @@opg_id
      and ret.ibc_id is not null

  open c_opgi

  fetch next from c_opgi into @ret_id, @opgi_id, @ret_nrodoc
  while @@fetch_status=0
  begin
  
    select @alicuota = reti_porcentaje 
    from RetencionItem
    where ret_id = @ret_id
      and @opg_total between reti_importedesde and reti_importehasta 

    insert into #t_frRetencionIIBB (opgi_id,  alicuota) 
                            values (@opgi_id, @alicuota)

    fetch next from c_opgi into @ret_id, @opgi_id, @ret_nrodoc
  end

  close c_opgi
  deallocate c_opgi

  -- Facturas
  --
  declare @error_msg       varchar(500)
  declare @fc_id           int
  declare @last_fc_id     int
  declare @last_opgi_id   int
  declare @pago           decimal(18,6)
  declare @total          decimal(18,6)
  declare @neto           decimal(18,6)
  declare @item_neto      decimal(18,6)
  declare @item_total     decimal(18,6)
  declare @percepciones   decimal(18,6)
  declare @opgi_importe       decimal(18,6)
  declare @last_opgi_importe  decimal(18,6)
  declare @porcentaje     decimal(18,6)
  declare @base           decimal(18,6)
  declare @retencion      decimal(18,6)

  declare @base_opgi           decimal(18,6)
  declare @retencion_opgi      decimal(18,6)

  declare @last_alicuota  decimal(18,6)
  declare @prov_catfiscal int

  select @prov_catfiscal = prov_catfiscal 
  from OrdenPago opg inner join Proveedor prov on opg.prov_id = prov.prov_id
  where opg_id = @@opg_id

--   select opgi.opgi_id,
--          fc.fc_id, 
--          alicuota,
--          fcopg_importe,
--          fc_total,
--          fc_neto,
--          fc_totalpercepciones,
--          sum(fci_neto),
--          sum(fci_importe),
--          opgi_importe
-- 
--   from OrdenPagoItem opgi inner join OrdenPago opg         on opgi.opg_id   = opg.opg_id
--                           inner join #t_frRetencionIIBB t on opgi.opgi_id = t.opgi_id
--                           inner join Retencion ret         on opgi.ret_id   = ret.ret_id
-- 
--                           inner join FacturaCompraOrdenPago fcopg on opg.opg_id = fcopg.opg_id
-- 
--                           inner join FacturaCompra fc       on fcopg.fc_id = fc.fc_id
--                           inner join FacturaCompraItem fci  on fc.fc_id    = fci.fc_id
--                           inner join Producto pr            on fci.pr_id   = pr.pr_id
--                                                             and ret.ibc_id = pr.ibc_id                      
--   group by
--          opgi.opgi_id,
--          fc.fc_id, 
--          alicuota,
--          fcopg_importe,
--          fc_total,
--          fc_neto,
--          fc_totalpercepciones,
--          opgi_importe

  create table #t_Facturas (  opgi_id   int,
                              fc_id     int, 
                              base       decimal(18,6), 
                              alicuota  decimal(18,6),
                              retencion decimal(18,6)
                            )

  declare c_fac insensitive cursor for 

  select opgi.opgi_id,
         fc.fc_id, 
         alicuota,
         fcopg_importe,
         fc_total,
         fc_neto,
         fc_totalpercepciones,
         sum(fci_neto),
         sum(fci_importe),
         opgi_importe

  from OrdenPagoItem opgi inner join OrdenPago opg         on opgi.opg_id   = opg.opg_id
                          inner join #t_frRetencionIIBB t on opgi.opgi_id = t.opgi_id
                          inner join Retencion ret         on opgi.ret_id   = ret.ret_id

                          inner join FacturaCompraOrdenPago fcopg on opg.opg_id = fcopg.opg_id

                          inner join FacturaCompra fc       on fcopg.fc_id = fc.fc_id
                          inner join FacturaCompraItem fci  on fc.fc_id    = fci.fc_id
                          inner join Producto pr            on fci.pr_id   = pr.pr_id
                                                            and ret.ibc_id = pr.ibc_id                      
  group by
         opgi.opgi_id,
         fc.fc_id, 
         alicuota,
         fcopg_importe,
         fc_total,
         fc_neto,
         fc_totalpercepciones,
         opgi_importe

  open c_fac

  set @last_opgi_id       = 0
  set @last_opgi_importe   = 0
  set @last_alicuota       = 0
  set @last_fc_id         = 0

  fetch next from c_fac into @opgi_id, @fc_id, @alicuota, @pago, @total, @neto, 
                             @percepciones, @item_neto, @item_total, @opgi_importe
  while @@fetch_status=0
  begin

    if @last_opgi_id <> @opgi_id begin

      if @last_opgi_id <> 0 begin

        if    (abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2)) > 0.01)
           or (abs(round(@last_opgi_importe,2) - round(@base_opgi*@last_alicuota/100,2)) > 0.01) begin

          -- para debug
          -- select @last_opgi_importe, @retencion, @base, @last_alicuota, @base*@last_alicuota/100

          -- Se pudrio todo, yo no se como resolver esto asi que se lo dejo al usuario
          --
          set @error_msg =  
                      '@@ERROR_SP:El sistema fallo al calcular las bases de las ' 
                     +'retenciones para esta orden de pago.'+char(13)+char(13)
                     +'Esto puede deberse a que la orden de pago esta hecha sobre '
                     +'varios parciales.'+char(13)+char(13)
                     +'Comuniquese con CrowSoft para obtener una solucion a este problema.'
                     +char(13)+char(13)
                     +char(13)+char(13)
                     +'dif: ' + convert(varchar,abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2)))
                     +char(13)+char(13)
                     +'dif: ' + convert(varchar,abs(round(@last_opgi_importe,2) - round(@base_opgi*@last_alicuota/100,2)))
                     /*+'(sepa disculpar la ignorancia de nuestros programadores :)'*/

          select opg_fecha, @@opg_id,@base_opgi, opgi_descrip
          from ordenpagoitem opgi inner join ordenpago opg on opg.opg_id = opgi.opg_id
          where opgi.opg_id = @@opg_id and ret_id is not null
          --raiserror (@error_msg, 16, 1) -- :) sefini
          return
           
        end

        insert into #t_Facturas (opgi_id, fc_id, base, alicuota, retencion)
                        values  (@last_opgi_id, @last_fc_id, @base, @last_alicuota/100, @retencion)
      end

      set @last_opgi_id       = @opgi_id
      set @last_fc_id         = @fc_id
      set @last_opgi_importe   = @opgi_importe
      set @last_alicuota       = @alicuota
      set @base               = 0
      set @retencion           = 0

      set @base_opgi           = 0
      set @retencion_opgi      = 0

    end else begin

      if @last_fc_id <> @fc_id begin

        if @last_fc_id <> 0 begin
          
          insert into #t_Facturas (opgi_id, fc_id, base, alicuota, retencion)
                          values  (@last_opgi_id, @last_fc_id, @base, @last_alicuota/100, @retencion)


          set @last_fc_id         = @fc_id
          set @base               = 0
          set @retencion           = 0
        end
      end
    end

    set @porcentaje = @item_total / (@total - @percepciones)

    set @base = @base +
                @porcentaje * (
                                case @prov_catfiscal
                                  when 1    then @pago * (@neto/@total)
                      
                                  when 11   then @pago * (@neto/@total)
                      
                                  when 6     then @pago 
                                                -(@pago  *  (@percepciones/@total))
                    
                                  else            0
                                end
                            )

    set @retencion = @retencion +
                     @porcentaje * (
                                case @prov_catfiscal
                                  when 1    then (@pago * (@neto/@total))*@alicuota/100
                      
                                  when 11   then (@pago * (@neto/@total))*@alicuota/100
                      
                                  when 6     then (  @pago 
                                                    -(@pago  *  (@percepciones/@total))
                                                  )*@alicuota/100
                    
                                  else            0
                                end
                            )

    set @base_opgi           = @base_opgi + @base
    set @retencion_opgi      = @retencion_opgi + @retencion

    fetch next from c_fac into @opgi_id, @fc_id, @alicuota, @pago, @total, @neto, 
                               @percepciones, @item_neto, @item_total, @opgi_importe
  end

  close c_fac
  deallocate c_fac

  --// la ultima retencion
  --
  if    (abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2)) > 0.01)
     or (abs(round(@last_opgi_importe,2) - round(@base_opgi*@alicuota/100,2)) > 0.01) begin

    -- Se pudrio todo, yo no se como resolver esto asi que se lo dejo al usuario
    --
    set @error_msg =  
                '@@ERROR_SP:El sistema fallo al calcular las bases de las ' 
               +'retenciones para esta orden de pago.'+char(13)+char(13)
               +'Esto puede deberse a que la orden de pago esta hecha sobre '
               +'varios parciales.'+char(13)+char(13)
               +'Comuniquese con CrowSoft para obtener una solucion a este problema.'
               +char(13)+char(13)
               +char(13)+char(13)
               +'dif: ' + convert(varchar,abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2)))
               +char(13)+char(13)
               +'dif: ' + convert(varchar,abs(round(@last_opgi_importe,2) - round(@base_opgi*@alicuota/100,2)))
               +'base: ' + convert(varchar,@base_opgi)
               /*+'(sepa disculpar la ignorancia de nuestros programadores :)'*/

    select opg_fecha, @@opg_id,@base_opgi, opgi_descrip
    from ordenpagoitem opgi inner join ordenpago opg on opg.opg_id = opgi.opg_id
    where opgi.opg_id = @@opg_id and ret_id is not null
    --raiserror (@error_msg, 16, 1) -- :) sefini
    return
     
  end


end
go

declare @opg_id int

declare c_opg insensitive cursor for
select opg_id from ordenpago where opg_id in

(select opg_id from ordenpagoitem where ret_id is not null)

open c_opg

fetch next from c_opg into @opg_id
while @@fetch_status=0
begin

  exec sp_tsr_validar_retencion @opg_id

  fetch next from c_opg into @opg_id
end

close c_opg
deallocate c_opg
go