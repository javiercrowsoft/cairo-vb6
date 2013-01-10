if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaGetRemitos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaGetRemitos]

go

create procedure sp_HojaRutaGetRemitos (
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
  
    select 
            0  as hri_id,
            '' as hri_descrip,
            rv_id,
            rv_fecha,
            rv_nrodoc,
            rv_total,
            rv.cli_id,

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

            0 as hri_orden
  
    from RemitoVenta rv inner join Cliente cli on rv.cli_id = cli.cli_id

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
          rv.est_id <> 7

      and rv_fecha between @@Fdesde and @@Fhasta

      and not exists(select * from HojaRutaItem where  hr_id = @@hr_id and rv_id = rv.rv_id)
      
  and   (rv.cli_id = @cli_id or @cli_id=0)
  and   (rv.est_id = @est_id or @est_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 28
                    and  rptarb_hojaid = rv.cli_id
                   ) 
             )
          or 
             (@ram_id_Cliente = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 4005
                    and  rptarb_hojaid = rv.est_id
                   ) 
             )
          or 
             (@ram_id_Estado = 0)
         )
  

end

go