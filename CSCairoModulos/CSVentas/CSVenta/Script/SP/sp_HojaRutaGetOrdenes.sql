if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaGetOrdenes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaGetOrdenes]

go

create procedure sp_HojaRutaGetOrdenes (
  @@fDesde datetime,
  @@fHasta datetime,
  @@cli_id varchar(255),
  @@est_id varchar(255),

  @@hr_id int
)
as

begin


  declare @cli_id int
  declare @est_id int
  
  declare @ram_id_Cliente int
  declare @ram_id_Estado int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
  exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_Cliente <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
    end else 
      set @ram_id_Cliente = 0
  end
  
  if @ram_id_Estado <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
    end else 
      set @ram_id_Estado = 0
  end

--///////////////////////////////////////////////////////////////////////////////////////////////


  --///////////////////////////////////////////////////////////////////////////////////////

  declare @os_id      int
  declare @ot          varchar(100)
  declare @ots        varchar(5000)
  declare @last_os_id int

  set @last_os_id = 0

  create table #t_os_ot (os_id int, ots varchar(5000) COLLATE SQL_Latin1_General_CP1_CI_AI not null )

  declare c_os insensitive cursor for 

      select os.os_id, prns_codigo 
      from OrdenServicio os inner join StockItem sti on os.st_id = sti.st_id and sti_ingreso > 0
                            inner join ProductoNumeroSerie prns on sti.prns_id = prns.prns_id

      where os.est_id <> 7

        and os_fecha between @@Fdesde and @@Fhasta

        and not exists(select * from HojaRutaItem where  hr_id = @@hr_id and os_id = os.os_id)
            
        and   (os.cli_id = @cli_id or @cli_id=0)
        and   (os.est_id = @est_id or @est_id=0)
        
        -- Arboles
        and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID  and  tbl_id = 28 and  rptarb_hojaid = os.cli_id)) or (@ram_id_Cliente = 0))
        and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 4005 and  rptarb_hojaid = os.est_id)) or (@ram_id_Estado = 0))


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
            0  as hri_id,
            '' as hri_descrip,
            t.ots,
            os.os_id,
            os_fecha,
            os_nrodoc,
            os_total,
            os.cli_id,

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

            0 as hri_orden
  
    from OrdenServicio os inner join Cliente cli on os.cli_id = cli.cli_id
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
          os.est_id <> 7

      and os_fecha between @@Fdesde and @@Fhasta

      and not exists(select * from HojaRutaItem where  hr_id = @@hr_id and os_id = os.os_id)
      and not exists(select * from HojaRutaItem hri inner join HojaRuta hr on hri.hr_id = hr.hr_id 
                     where hr_cumplida = 0
                       and os_id = os.os_id)
      
  and   (os.cli_id = @cli_id or @cli_id=0)
  and   (os.est_id = @est_id or @est_id=0)
  
  -- Arboles
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID  and  tbl_id = 28 and  rptarb_hojaid = os.cli_id)) or (@ram_id_Cliente = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 4005 and  rptarb_hojaid = os.est_id)) or (@ram_id_Estado = 0))
  

end

go