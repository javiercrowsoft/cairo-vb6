if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaCdoGetFacturas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaCdoGetFacturas]

go

/*

select max(fv_id) from facturaventa
sp_DocCobranzaCdoGetFacturas  29183

*/

create procedure sp_DocCobranzaCdoGetFacturas (
  @@cj_id   int,
  @@ctacte  tinyint,
  @@filter  varchar(255) = ''
)
as

begin

  set nocount on

  if @@filter <> '' begin

    set @@filter = '%'+replace(@@filter,'*','%') + '%'

  end

  delete FacturaVentaCajero
  where not exists(select 1 from FacturaVenta where fv_id = FacturaVentaCajero.fv_id and fv_pendiente > 0)
    and cj_id = @@cj_id

  declare @fvi_descrip varchar(5000)
  declare @fvi_descrips varchar(8000)
  declare @fv_id int 
  declare @fv_id_old int set @fv_id_old = 0

  create table #t_items (fv_id int, fvi_descrip varchar(8000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL)
  create table #t_pedidos (fv_id int, pv_id int)
  create table #t_pagos (fv_id int, pagos varchar(7000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL)

  declare c_items insensitive cursor for

      select   fv.fv_id,
              convert(varchar(50),convert(decimal(18,2),fvi_cantidad)) + ' ' +
              pr_nombreventa + ' ' +
              convert(varchar(50),convert(decimal(18,2),fvi_importe))
      from FacturaVentaCajero fvcj 
              inner join FacturaVenta fv on fvcj.fv_id = fv.fv_id
              inner join FacturaVentaItem fvi on fv.fv_id = fvi.fv_id
              inner join Producto pr on fvi.pr_id = pr.pr_id
      where fvcj.cj_id = @@cj_id
        and (      (fvcj_ctacte <> 0 and @@ctacte <> 0 and fv_pendiente > 0)
              or  (fvcj_ctacte = 0 and @@ctacte = 0)
            )
        and fv_pendiente > 0

  open c_items 

  fetch next from c_items into @fv_id, @fvi_descrip
  while @@fetch_status = 0
  begin

    if @fv_id_old <> @fv_id begin

      if @fv_id_old <> 0 begin

        insert into #t_items (fv_id, fvi_descrip) values(@fv_id_old, @fvi_descrips)

      end

      set @fv_id_old = @fv_id
      set @fvi_descrips = ''

    end

    set @fvi_descrips = @fvi_descrips + @fvi_descrip + char(10) + char(13)

    fetch next from c_items into @fv_id, @fvi_descrip
  end

  if @fv_id_old <> 0 begin

    insert into #t_items (fv_id, fvi_descrip) values(@fv_id_old, @fvi_descrips)

  end

  close c_items
  deallocate c_items

--/////////////////////////////////////////////////////////////////////////
--
-- Cobros por Comunidad Internet
--
  
  insert into #t_pedidos (fv_id, pv_id)
  select fvcj.fv_id, pvi.pv_id
  from FacturaVentaCajero fvcj inner join FacturaVentaItem fvi on fvcj.fv_id = fvi.fv_id
                               inner join PedidoFacturaVenta pvfv on fvi.fvi_id = pvfv.fvi_id
                               inner join PedidoVentaItem pvi on pvfv.pvi_id = pvi.pvi_id
                               inner join FacturaVenta fv on fvi.fv_id = fv.fv_id
  where fvcj.cj_id = @@cj_id
        and (      (fvcj_ctacte <> 0 and @@ctacte <> 0)
              or  (fvcj_ctacte = 0 and @@ctacte = 0)
            )
        and fv_pendiente > 0
    
  declare c_pagos insensitive cursor for 
  
    select distinct pv.fv_id, 
                      'MercadoPago: ' + cmic_cobrado + ' '
                    + 'Estado: ' + cmic_estado + ' ' + '(' + cmic_cobroid + ')' + char(10)+char(13)                     + convert(varchar,cmic_fecha,105) + ' (' + cmic_fechastr + ')'
                    + '-' + cmic_articulo + char(10)+char(13)
                    + cmic_descrip

    from #t_pedidos pv  inner join PedidoVenta pvc on pv.pv_id = pvc.pv_id 
                        inner join Cliente cli on pvc.cli_id = cli.cli_id 
                        inner join ComunidadInternetCobro cmic on pvc.pv_id = cmic.pv_id

    order by pv.fv_id
  
  open c_pagos
  
  set @fv_id = null
  set @fv_id_old = null

  declare @pago        varchar(4000)
  declare @pagos      varchar(7000)
  
  set @fv_id_old = 0
  fetch next from c_pagos into @fv_id, @pago
  while @@fetch_status=0
  begin

    if @fv_id_old <> @fv_id begin

      if @fv_id_old <> 0 begin
        insert into #t_pagos (fv_id, pagos) values (@fv_id_old, char(10)+char(13)+@pagos)
      end
      
      set @pagos = ''
      set @fv_id_old = @fv_id

    end

    set @pagos = @pagos + @pago + char(10)+char(13)
  
    fetch next from c_pagos into @fv_id, @pago
  end
  
  close c_pagos
  deallocate c_pagos

   if @fv_id_old <> 0 begin
     insert into #t_pagos (fv_id, pagos) values (@fv_id_old, char(10)+char(13)+@pagos)
   end
  
  --/////////////////////////////////////////////////////////////////////////

  select   fv.fv_id, 
          min(convert(varchar,fv.creado,105) + ' ' + convert(varchar(5),fv.creado,14) 
          + ' ' + cli_codigocomunidad + ' - ' 
          + cli_nombre) as cli_nombre, 
          fv_total, 
          fv_nrodoc, 

          min(cli_calle + ' ' +
          cli_callenumero + ' ' +
          cli_piso + ' ' +
          cli_depto  + ' ' +          
          cli_localidad + ' - ' +
          cli_codpostal) as direccion,

          min(fvi_descrip + isnull(char(10) + char(13) + pagos,'')) as fvi_descrip

  from FacturaVentaCajero fvcj 
          inner join FacturaVenta fv   on fvcj.fv_id = fv.fv_id
          inner join Cliente cli       on fv.cli_id = cli.cli_id
          left  join #t_items i       on fv.fv_id = i.fv_id
          left   join #t_pagos p       on fv.fv_id = p.fv_id

  where fvcj.cj_id = @@cj_id
        and (      (fvcj_ctacte <> 0 and @@ctacte <> 0 
                    and (      cli_nombre like @@filter 
                          or  cli_codigo like @@filter
                          or  cli_codigocomunidad like @@filter
                          or   @@filter = ''
                        )
                  )
              or  (fvcj_ctacte = 0 and @@ctacte = 0)
            )
        and fv_pendiente > 0

  group by fv.fv_id,fv_total,fv_nrodoc,fv.creado

  order by fv.creado asc

end