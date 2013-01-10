SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0900]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0900]
GO


create procedure DC_CSC_VEN_0900 (

  @@us_id        int,

  @@fdesde      datetime,
  @@fhasta      datetime,
  @@cli_id       varchar(255),
  @@pr_id        varchar(255)

)as 

begin

  set nocount on

  declare @cli_id             int
  declare @pr_id_param        int

  declare @ram_id_cliente     int
  declare @ram_id_producto    int

  declare @IsRaiz              tinyint
  
  exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
  exec sp_ArbConvertId @@pr_id, @pr_id_param out, @ram_id_producto out

  declare @clienteID int

  exec sp_GetRptId @clienteID out  

  if @ram_id_cliente <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
    end else 
      set @ram_id_cliente = 0
  end

  if @ram_id_producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
    end else 
      set @ram_id_producto = 0
  end

  -----------------------------------------------------------------------------------------
  -- Numeros de serie
  --
  create table #nroserie(rvi_id int, codigo varchar(5000))
  declare @codigo  varchar(100)
  declare @codigo2 varchar(5000)
  declare @rvi_id       int
  declare @prns_id       int
  declare @pr_eskit      smallint
  declare @prsk_id      int
  declare @stl_id        int
  declare @pr_id        int
  declare @codigo_barra  varchar(255)
  declare @codigo_item  varchar(5000)
  declare @codigo_lote  varchar(5000)
  declare @last_rvi_id   int

  set @last_rvi_id=0

  declare c_nroserie insensitive cursor for
  select 
                  rvi_id,
                  p.pr_eskit,
                  prns.prns_id,
                  prns_codigo

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join RemitoVentaItem rvi       on sti.sti_grupo  = rvi.rvi_id
                                inner join RemitoVenta rv            on rvi.rv_id      = rv.rv_id
                                inner join Producto p               on prns.pr_id     = p.pr_id
  where   
          rv.rv_fecha between @@fdesde and @@fhasta
      and sti.st_id = rv.st_id

      and (rv.cli_id = @cli_id or @cli_id =0)
      and (rvi.pr_id = @pr_id_param or @pr_id_param =0)

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
                 (@ram_id_cliente = 0)
             )

      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30 
                        and  rptarb_hojaid = rvi.pr_id
                       ) 
                 )
              or 
                 (@ram_id_producto = 0)
             )

  group by
          prns.prns_id,
          prns_codigo,
          p.pr_eskit,
          prns.prns_id,
          rvi_id
  order by
          rvi_id

  open c_nroserie
  fetch next from c_nroserie into @rvi_id, @pr_eskit, @prns_id, @codigo
  while @@fetch_status=0
  begin
    
    if @rvi_id <> @last_rvi_id begin

      if @last_rvi_id <> 0 begin
        set @codigo2 = substring(@codigo2,1,len(@codigo2)-1)
        insert into #nroserie(rvi_id,codigo)values(@last_rvi_id,@codigo2)
      end

      set @last_rvi_id = @rvi_id
      set @codigo2 = 'ns: '
    end

    set @codigo_item = ''
    set @codigo_lote = ''

    --/////////////////////////////////////////////////////////////////////////
    -- Series que componen el Kit
    --
    if @pr_eskit <> 0 begin

      select @prsk_id = prsk_id from productoseriekit where prns_id = @prns_id --and 1=2

      declare c_serie_items insensitive cursor for
        select prns_id, stl_id, pr_id from ProductoSerieKitItem where prsk_id = @prsk_id
      open c_serie_items
      fetch next from c_serie_items into @prns_id, @stl_id, @pr_id
      while @@fetch_status=0
      begin

        select @codigo_barra = pr_codigobarra from producto where pr_id = @pr_id

        set @codigo_barra = substring(@codigo_barra,2,10)

        if @prns_id is not null begin
          select @codigo_item = @codigo_item + @codigo_barra +':'+ prns_codigo + ',' 
          from ProductoNumeroSerie where prns_id = @prns_id
        end

        if @stl_id is not null begin
          select @codigo_lote = @codigo_lote + @codigo_barra +':'+ stl_codigo + ',' 
          from StockLote where stl_id = @stl_id
        end

        fetch next from c_serie_items into @prns_id, @stl_id, @pr_id
      end
      close c_serie_items
      deallocate c_serie_items

      set @codigo_item = @codigo_item + @codigo_lote
      if len(@codigo_item) > 0 set @codigo_item = substring(@codigo_item,1,len(@codigo_item)-1)
      if len(@codigo_item) > 0 set @codigo_item = '('+@codigo_item+'), '
      set @codigo = ''

    end else begin

      set @codigo = @codigo + ', '
    end
    --
    --/////////////////////////////////////////////////////////////////////////

    set @codigo2 = @codigo2 + @codigo + @codigo_item

    fetch next from c_nroserie into @rvi_id, @pr_eskit, @prns_id, @codigo
  end
  close c_nroserie
  deallocate c_nroserie  

  if @last_rvi_id <> 0 begin
    set @codigo2 = substring(@codigo2,1,len(@codigo2)-1)
    insert into #nroserie(rvi_id,codigo)values(@last_rvi_id,@codigo2)
  end

  -----------------------------------------------------------------------------------------

  select
        rv.rv_id                                  as rv_id,
        cli_nombre                                as Cliente,
        rv_nrodoc                                 as [NroRemito],
        rv_fecha                                  as Fecha,
        cli_calle + ' ' +
        cli_callenumero + ' ' +
        cli_piso + ' ' +
        cli_depto + ' (' +
        cli_codpostal + ')'                        As Direccion,
        cli_localidad                             as Localidad,
        cli_tel                                   as Telefono,
        cli_cuit                                  as cuit,         
        cpg_nombre                                as CondicionPago,
        suc_nombre                                as Sucursal,
         depl_nombre                                as [Desposito origen],
         rv_descrip                                 as Descrip,
         pr_nombreventa                            as Articulo,
        rvi_cantidad                              as Cantidad,
        rvi_precio                                as Precio,
        rvi_ivari                                 as IVA,
        rvi_neto                                  as Neto,
        rvi_importe                                as Importe,
        replace(rvi_descrip,char(9),'    ')       as Item_Descrip,
        rv_neto                                   as [Neto total],
        rv_total                                  as Total,  
        rv_ivari                                  as [Total IVA],
        
          case 
            when cli_catfiscal=1 or cli_catfiscal=11 then 'X'
            else ''
          end as inscripto,
    
          case cli_catfiscal
            when 6 then 'X'
            else ''
          end as monotributo,
    
          case cli_catfiscal
            when 4 then 'X'
            else ''
          end as consumidorFinal,

        pro.pro_nombre as Provincia,
        trans_nombre,
        trans_direccion,
        IsNull(prot.pro_nombre,prop.pro_nombre) as ProvinciaT,
        prov_cuit,
        codigo as nro_serie  

  from RemitoVenta rv inner join RemitoVentaItem rvi on rv.rv_id       = rvi.rv_id
                      inner join Producto p          on rvi.pr_id      = p.pr_id
                      inner join Cliente c           on rv.cli_id      = c.cli_id
                      inner join Sucursal s          on rv.suc_id      = s.suc_id
                      left  join Stock st            on rv.st_id       = st.st_id
                      left  join DepositoLogico d    on st.depl_id_origen = d.depl_id
                      left   join CondicionPago cp     on rv.cpg_id      = cp.cpg_id
                      left  join #nroserie ns        on rvi.rvi_id     = ns.rvi_id
                      left  join Provincia pro       on c.pro_id       = pro.pro_id
                      left  join Transporte trans    on rv.trans_id    = trans.trans_id
                      left  join Provincia prot      on trans.pro_id  = prot.pro_id
                      left  join Proveedor prov      on trans.prov_id = prov.prov_id
                      left  join Provincia prop      on prov.pro_id   = prop.pro_id

  where   rv.rv_fecha between @@fdesde and @@fhasta
      and st.st_id = rv.st_id

      and (rv.cli_id = @cli_id or @cli_id =0)
      and (rvi.pr_id = @pr_id_param or @pr_id_param =0)

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
                 (@ram_id_cliente = 0)
             )

      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30 
                        and  rptarb_hojaid = rvi.pr_id
                       ) 
                 )
              or 
                 (@ram_id_producto = 0)
             )

  order by

      cli_nombre, rv_fecha, rv.rv_id
end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

