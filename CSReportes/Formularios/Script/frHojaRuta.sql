SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- frHojaRuta 2707

ALTER  procedure frHojaRuta (

  @@hr_id      int

)as 

begin

  set nocount on

  --///////////////////////////////////////////////////////////////////////////////////////

  declare @os_id      int
  declare @ot          varchar(100)
  declare @ots        varchar(5000)
  declare @last_os_id int

  set @last_os_id = 0

  create table #t_os_ot (os_id int, ots varchar(5000) COLLATE SQL_Latin1_General_CP1_CI_AI not null )

  declare c_os insensitive cursor for 
      select hri.os_id, prns_codigo 
      from HojaRutaItem hri inner join OrdenServicio os on os.os_id = hri.os_id
                            inner join StockItem sti on os.st_id = sti.st_id and sti_ingreso > 0
                            inner join ProductoNumeroSerie prns on sti.prns_id = prns.prns_id
      where hri.hr_id = @@hr_id

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
  
  select
 
        hojaruta.*,
        case 
          when isnumeric(hr_nrodoc) <> 0 then convert(varchar,convert(int,hr_nrodoc)) 
          else hr_nrodoc 
        end as nro_hoja_ruta,
        hri.*,
        case when hri_descrip = replace(ptd_descrip,char(13)+char(10),' ') then '' else hri_descrip end as hri_descrip2,

        case when hri_descrip <> '' then hri_descrip + char(10) + ots
             else ots
        end   as hri_descrip_os,

        case when hri_importe <> 0 then 'Cobrar'
             else ''
        end as Cobrar,
        suc.suc_nombre,
        est.est_nombre,
        fv.fv_id,
        fv.fv_nrodoc,
        fv.fv_fecha,
        fv.fv_total,

--------------------------------------------------
--         case when cli.cli_id is not null then
--       
--                 cli.cli_nombre + ' - ' +
--                 cli_calle + ' ' +
--                 cli_callenumero + ' ' +
--                 cli_piso + ' ' +
--                 cli_depto + ' (' +
--                 cli_codpostal + ') ' +
--                 cli_localidad + ' - ' +
--                 cli_tel + ' - ' +
--                 cli_contacto      
-- 
--              else '(Sin cliente)'
--         end
--         as cli_nombre,

        isnull(

        /*

        esto estaba por la version pedida por la gente de rosario
        como no se uso y a Juan le molesta lo sacamos.

        isnull(cli.cli_codigo,prov.prov_codigo) + ' - ' +
        */

        case when hri_orden = 0 then '' else right('0000'+convert(varchar,hri_orden),4) + '  ' end +

        isnull(cli.cli_nombre,prov.prov_nombre) + ' - ' +
        case 
             when cli.trans_id is not null then
                  trans_nombre + ' - ' + trans_direccion + ' Te: ' + trans_telefono 

             when clis.clis_calle <> '' then

                  clis.clis_calle + ' ' +
                  clis.clis_callenumero + ' ' +
                  clis.clis_piso + ' ' +
                  clis.clis_depto + ' (' +
                  clis.clis_codpostal + ') ' +
                  clis.clis_localidad + ' - ' +
                  isnull(prosuc.pro_nombre, '') + ' - ' +
                  clis.clis_tel + ' - ' +
                  clis.clis_contacto

             when cli.cli_id is not null then

                  cli_calle + ' ' +
                  cli_callenumero + ' ' +
                  cli_piso + ' ' +
                  cli_depto + ' (' +
                  cli_codpostal + ') ' +
                  cli_localidad + ' - ' +
                  isnull(pro.pro_nombre, '') + ' - ' +
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

        end

        +

        case   
          when  convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_m_desde else trans_horario_m_desde end,prov_horario_m_desde),108) <> '00:00'
            and convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_m_hasta else trans_horario_m_hasta end,prov_horario_m_hasta),108) <> '00:00'
            and convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_t_desde else trans_horario_t_desde end,prov_horario_t_desde),108) <> '00:00'
            and convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_t_hasta else trans_horario_t_hasta end,prov_horario_t_hasta),108) <> '00:00'
          then

            ' Horario: '
            + convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_m_desde else trans_horario_m_desde end,prov_horario_m_desde),108)+ ' a '
            + convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_m_hasta else trans_horario_m_hasta end,prov_horario_m_hasta),108)+ ' y de '
            + convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_t_desde else trans_horario_t_desde end,prov_horario_t_desde),108)+ ' a '
            + convert(varchar(5),isnull(case when cli.trans_id is null then cli_horario_t_hasta else trans_horario_t_hasta end,prov_horario_t_hasta),108)

          else ''
        end

        ,' (sin cliente)') as cli_nombre,

        isnull(cli.cli_id,prov.prov_id*-1) as cli_id,

---------------------------------------------------

        rv.rv_nrodoc,
        rv.rv_fecha,
        rv.rv_total,
        rv.rv_id,

        os.os_fecha,
        os.os_nrodoc,
        os.os_id,

        ptd.ptd_titulo,
        ptd.ptd_fechaini,
        ptd.ptd_descrip,

        prs.prs_nombre,
        cho.chof_nombre,
        cams.cam_patentesemi,
        cam.cam_patente,

        right('0000'+convert(varchar,case when hri_orden = 0 then 9999 else hri_orden end),4) 
                  as orden,

        us.us_nombre,

        trans_nombre + '    -    ' + trans_direccion + '               Te: ' + trans_telefono as trans_nombre         


  from HojaRuta inner join Estado  est      on HojaRuta.est_id = est.est_id
                inner join Sucursal suc     on HojaRuta.suc_id = suc.suc_id
                left  join HojaRutaItem hri on HojaRuta.hr_id = hri.hr_id

                left join FacturaVenta fv   on hri.fv_id = fv.fv_id
                left join RemitoVenta rv    on hri.rv_id = rv.rv_id
                left join OrdenServicio os  on hri.os_id = os.os_id
                left join ParteDiario ptd   on hri.ptd_id = ptd.ptd_id
                left join Cliente  cli        on fv.cli_id = cli.cli_id or 
                                               rv.cli_id = cli.cli_id or
                                               os.cli_id = cli.cli_id or
                                               ptd.cli_id = cli.cli_id

                -- Sucursal de entrega del cliente
                --
                left  join ClienteSucursal clis 
                on    (fv.clis_id = clis.clis_id)
                  or (rv.clis_id = clis.clis_id)
                  or (os.clis_id = clis.clis_id)
                  or (
                                                    fv.clis_id is null
                                                and rv.clis_id is null
                                                and os.clis_id is null
                                                
                                                and cli.cli_id = clis.cli_id
                        -- El codigo debe ser "e" para que el sistema la tome 
                        -- como sucursal de entrega 
                                                and clis_codigo = 'e' 
                      )

                left join Proveedor  prov  on ptd.prov_id = prov.prov_id

                left join Chofer  cho     on HojaRuta.chof_id  = cho.chof_id
                left join Camion  cam     on HojaRuta.cam_id  = Cam.cam_id
                left join Camion  cams    on HojaRuta.cam_id_semi  = cams.cam_id
                left join Persona prs     on HojaRuta.prs_id  = Prs.prs_id

                left join Usuario us      on HojaRuta.modifico = us.us_id

                left join #t_os_ot t      on os.os_id = t.os_id

                left join Transporte trans on cli.trans_id = trans.trans_id

              left join provincia pro on cli.pro_id = pro.pro_id
              left join provincia prosuc on clis.pro_id = prosuc.pro_id

  where HojaRuta.hr_id = @@hr_id

  order by   orden, 
            cli_nombre, 
            case 
              when fv.fv_id   is not null then 1
              when rv.rv_id   is not null then 2
              when os.os_id   is not null then 3
              when ptd.ptd_id is not null then 4
            end

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

