if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaGetItems]

go

/*

exec sp_HojaRutaGetItems 1, 0,0,1,0

*/

create procedure sp_HojaRutaGetItems (

  @@hr_id   int,
  @@os       tinyint,
  @@rv      tinyint,
  @@fv       tinyint,
  @@ptd     tinyint

)
as

begin

  set nocount on

  if @@os <> 0 begin

  --///////////////////////////////////////////////////////////////////////////////////////

  -- Identificacion del cliente

  --///////////////////////////////////////////////////////////////////////////////////////

  declare @os_id      int
  declare @ot          varchar(100)
  declare @ots        varchar(5000)
  declare @last_os_id int

  set @last_os_id = 0

  create table #t_os_ot (os_id int, ots varchar(5000) COLLATE SQL_Latin1_General_CP1_CI_AI not null )

  declare c_os insensitive cursor for 

      select hri.os_id, prns_codigo 
      from HojaRutaItem hri inner join OrdenServicio os on hri.os_id = os.os_id
                            inner join StockItem sti on os.st_id = sti.st_id and sti_ingreso > 0
                            inner join ProductoNumeroSerie prns on sti.prns_id = prns.prns_id
      where hri.hr_id = @@hr_id        
      order by hri.os_id, prns_codigo

  open c_os

  fetch next from c_os into @os_id, @ot
  while @@fetch_status=0
  begin

    if @last_os_id <> @os_id begin

      if @last_os_id <> 0 begin

        if len(@ots)>1 set @ots = left(@ots,len(@ots)-1)

        insert into #t_os_ot (os_id, ots) values(@last_os_id, @ots)

      end

      set @ots = ''
      set @last_os_id = @os_id

    end
    
    set @ots = @ots + @ot + ','

    fetch next from c_os into @os_id, @ot
  end

  close c_os
  deallocate c_os

  if @last_os_id <> 0 begin

    if len(@ots)>1 set @ots = left(@ots,len(@ots)-1)

    insert into #t_os_ot (os_id, ots) values(@last_os_id, @ots)

  end


  --///////////////////////////////////////////////////////////////////////////////////////


--///////////////////////////////////////////////////////////////////////////////////////////////

    select 
            hri_id,
            hri_importe,
            hri_cobrado,
            hri_acobrar,
            hri.os_id,
            hri_descrip,
            os_fecha,
            os_nrodoc,
            os_total,
            os_pendiente,
            os.cli_id,
            os.est_id   as est_id_orden,

            '*) ' + right('0000'+convert(varchar,case when hri_orden = 0 then 9999 else hri_orden end),4) + ') ' +
            cli.cli_nombre + ' - ' +

            case
                 when clisos.clis_calle <> '' then

                      clisos.clis_calle + ' ' +
                      clisos.clis_callenumero + ' ' +
                      clisos.clis_piso + ' ' +
                      clisos.clis_depto + ' (' +
                      clisos.clis_codpostal + ') ' +
                      clisos.clis_localidad + ' - ' +
                      clisos.clis_tel + ' - ' +
                      clisos.clis_contacto
 
                 when clis.clis_calle <> '' then

                      clis.clis_calle + ' ' +
                      clis.clis_callenumero + ' ' +
                      clis.clis_piso + ' ' +
                      clis.clis_depto + ' (' +
                      clis.clis_codpostal + ') ' +
                      clis.clis_localidad + ' - ' +
                      clis.clis_tel + ' - ' +
                      clis.clis_contacto

                 else

                      cli_calle + ' ' +
                      cli_callenumero + ' ' +
                      cli_piso + ' ' +
                      cli_depto + ' (' +
                      cli_codpostal + ') ' +
                      cli_localidad + ' - ' +
                      cli_tel + ' - ' +
                      cli_contacto

            end as cli_nombre,

            hri_orden,

            t.ots
  
    from 
          HojaRutaItem hri inner join OrdenServicio os on hri.os_id = os.os_id
                           inner join Cliente cli on os.cli_id = cli.cli_id
                           left  join #t_os_ot t on os.os_id = t.os_id

                           -- Sucursal de entrega del cliente
                           --
                           left  join ClienteSucursal clis on   os.cli_id = clis.cli_id 
                              -- El codigo debe ser "e" para que el sistema la tome 
                              -- como sucursal de entrega 
                                                            and clis_codigo = 'e' 
                              -- El documento no debe indicar una sucursal
                                                            and os.clis_id is null 

                           -- Sucursal explicitamente indicada en la orden de servicio
                           --
                           left  join ClienteSucursal clisos on os.clis_id = clisos.clis_id

    where 
            hri.hr_id = @@hr_id        

    order by hri_orden, os_fecha

  end else

  if @@rv <> 0 begin

    select 
            hri_id,
            hri_importe,
            hri_cobrado,
            hri_acobrar,
            hri.rv_id,
            hri_descrip,
            rv_fecha,
            rv_nrodoc,
            rv_total,
            rv_pendiente,
            rv.cli_id,
            rv.est_id   as est_id_remito,

            '*) ' + right('0000'+convert(varchar,case when hri_orden = 0 then 9999 else hri_orden end),4) + ') ' +
            cli.cli_nombre + ' - ' +

            case
                 when clisrv.clis_calle <> '' then

                      clisrv.clis_calle + ' ' +
                      clisrv.clis_callenumero + ' ' +
                      clisrv.clis_piso + ' ' +
                      clisrv.clis_depto + ' (' +
                      clisrv.clis_codpostal + ') ' +
                      clisrv.clis_localidad + ' - ' +
                      clisrv.clis_tel + ' - ' +
                      clisrv.clis_contacto
 
                 when clis.clis_calle <> '' then

                      clis.clis_calle + ' ' +
                      clis.clis_callenumero + ' ' +
                      clis.clis_piso + ' ' +
                      clis.clis_depto + ' (' +
                      clis.clis_codpostal + ') ' +
                      clis.clis_localidad + ' - ' +
                      clis.clis_tel + ' - ' +
                      clis.clis_contacto

                 else

                      cli_calle + ' ' +
                      cli_callenumero + ' ' +
                      cli_piso + ' ' +
                      cli_depto + ' (' +
                      cli_codpostal + ') ' +
                      cli_localidad + ' - ' +
                      cli_tel + ' - ' +
                      cli_contacto

            end as cli_nombre,

            hri_orden
  
    from 
          HojaRutaItem hri inner join RemitoVenta rv on hri.rv_id = rv.rv_id
                           inner join Cliente cli on rv.cli_id = cli.cli_id

                           -- Sucursal de entrega del cliente
                           --
                           left  join ClienteSucursal clis on   rv.cli_id = clis.cli_id
                              -- El codigo debe ser "e" para que el sistema la tome 
                              -- como sucursal de entrega 
                                                            and clis_codigo = 'e' 
                              -- El documento no debe indicar una sucursal
                                                            and rv.clis_id is null 

                           -- Sucursal explicitamente indicada en la orden de servicio
                           --
                           left  join ClienteSucursal clisrv on rv.clis_id = clisrv.clis_id

    where 
            hri.hr_id = @@hr_id        

    order by hri_orden, rv_fecha

  end

  if @@fv <> 0 begin

    select 
            hri_id,
            hri_importe,
            hri_cobrado,
            hri_acobrar,

            hri_anulado,
            hri_cheques,
            hri_efectivo,
            hri_notascredito,
            hri_otros,
            hri_retenciones,
            hri_tarjeta,
            hri_tickets,

            hri.fv_id,
            hri_descrip,
            fv_fecha,
            fv_fechavto,
            fv_nrodoc,
            fv_total,
            fv_pendiente,
            fv.cli_id,
            fv.est_id   as est_id_factura,
            fv.doct_id,

            '*) ' + right('0000'+convert(varchar,case when hri_orden = 0 then 9999 else hri_orden end),4) + ') ' +
            cli.cli_nombre + ' - ' +

            case
                 when clisfv.clis_calle <> '' then

                      clisfv.clis_calle + ' ' +
                      clisfv.clis_callenumero + ' ' +
                      clisfv.clis_piso + ' ' +
                      clisfv.clis_depto + ' (' +
                      clisfv.clis_codpostal + ') ' +
                      clisfv.clis_localidad + ' - ' +
                      clisfv.clis_tel + ' - ' +
                      clisfv.clis_contacto
 
                 when clis.clis_calle <> '' then

                      clis.clis_calle + ' ' +
                      clis.clis_callenumero + ' ' +
                      clis.clis_piso + ' ' +
                      clis.clis_depto + ' (' +
                      clis.clis_codpostal + ') ' +
                      clis.clis_localidad + ' - ' +
                      clis.clis_tel + ' - ' +
                      clis.clis_contacto

                 else

                      cli_calle + ' ' +
                      cli_callenumero + ' ' +
                      cli_piso + ' ' +
                      cli_depto + ' (' +
                      cli_codpostal + ') ' +
                      cli_localidad + ' - ' +
                      cli_tel + ' - ' +
                      cli_contacto

            end as cli_nombre,

            hri_orden,
            case when hri_acobrar > 0 then 1 else 0 end as cobrar,
            hri.hrct_id,
            hrct_nombre,
            0 as iluminar
  
    from 
          HojaRutaItem hri inner join FacturaVenta fv on hri.fv_id = fv.fv_id
                           inner join Cliente cli on fv.cli_id = cli.cli_id

                           -- Sucursal de entrega del cliente
                           --
                           left  join ClienteSucursal clis on   fv.cli_id = clis.cli_id
                              -- El codigo debe ser "e" para que el sistema la tome 
                              -- como sucursal de entrega 
                                                            and clis_codigo = 'e' 
                              -- El documento no debe indicar una sucursal
                                                            and fv.clis_id is null 

                           -- Sucursal explicitamente indicada en la orden de servicio
                           --
                           left  join ClienteSucursal clisfv on fv.clis_id = clisfv.clis_id

                           left  join HojaRutaCobranzaTipo hrct on hri.hrct_id = hrct.hrct_id
    where 
            hri.hr_id = @@hr_id        

    order by hri_orden, fv_fecha

  end else

  if @@ptd <> 0 begin

    select 
            hri_id,
            hri_importe,
            hri_cobrado,
            hri_acobrar,
            hri.ptd_id,
            hri_descrip,
            ptd_fechaini,
            ptd_numero,
            ptd_titulo,
            ptd.cli_id,
            case when ptd_cumplida = 3 then 1 else 0 end as ptd_cumplido,

            ptd.tarest_id as est_id_parte,


            isnull(
            '*) ' + right('0000'+convert(varchar,case when hri_orden = 0 then 9999 else hri_orden end),4) + ') ' +
            isnull(cli.cli_nombre,prov.prov_nombre) + ' - ' +
            case 
                 when clis.clis_calle <> '' then

                      clis.clis_calle + ' ' +
                      clis.clis_callenumero + ' ' +
                      clis.clis_piso + ' ' +
                      clis.clis_depto + ' (' +
                      clis.clis_codpostal + ') ' +
                      clis.clis_localidad + ' - ' +
                      clis.clis_tel + ' - ' +
                      clis.clis_contacto

                 when ptd.cli_id is not null then

                      cli_calle + ' ' +
                      cli_callenumero + ' ' +
                      cli_piso + ' ' +
                      cli_depto + ' (' +
                      cli_codpostal + ') ' +
                      cli_localidad + ' - ' +
                      cli_tel + ' - ' +
                      cli_contacto

                 else

                      prov_calle + ' ' +
                      prov_callenumero + ' ' +
                      prov_piso + ' ' +
                      prov_depto + ' (' +
                      prov_codpostal + ') ' +
                      prov_localidad + ' - ' +
                      prov_tel + ' - ' +
                      prov_contacto

            end,' (sin cliente)') as cli_nombre,

            hri_orden
  
    from 
          HojaRutaItem hri inner join ParteDiario ptd on hri.ptd_id = ptd.ptd_id 
                           left  join Cliente cli on ptd.cli_id = cli.cli_id

                           -- Sucursal de entrega del cliente
                           --
                           left  join ClienteSucursal clis on   ptd.cli_id = clis.cli_id
                              -- El codigo debe ser "e" para que el sistema la tome 
                              -- como sucursal de entrega 
                                                            and clis_codigo = 'e' 

                          left join Proveedor prov on ptd.prov_id = prov.prov_id
    where 
            hri.hr_id = @@hr_id        

    order by hri_orden, ptd_fechaini

  end

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

