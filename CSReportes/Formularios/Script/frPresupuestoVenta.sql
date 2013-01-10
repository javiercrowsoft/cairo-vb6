/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frPresupuestoVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frPresupuestoVenta]

-- frPresupuestoVenta 2084

go
create procedure frPresupuestoVenta (

  @@pprv_id      int

)as 

begin

  set nocount on

  -----------------------------------------------------------------------------------------
  -- Sucursal del cliente
  --
  declare @succlidir  varchar(1000)
  declare @succliloc  varchar(1000)
  declare @cli_id     int
  declare @clis_id    int

  select @cli_id = cli_id, @clis_id = clis_id from PresupuestoVenta where prv_id = @@pprv_id

  if isnull(@clis_id,0)<>0 begin

    select @succlidir = clis_calle + ' ' + clis_callenumero + ' ' + clis_piso + ' ' + clis_depto,
           @succliloc =clis_localidad from ClienteSucursal where clis_id = @clis_id
  
  end else begin

    select @succlidir = min(clis_calle + ' ' + clis_callenumero + ' ' + clis_piso + ' ' + clis_depto),
           @succliloc = min(clis_localidad) from ClienteSucursal where cli_id = @cli_id
  end
  -----------------------------------------------------------------------------------------

  select
         0                                        as prv_id,
        cli_nombre                                as Cliente,
        prv_nrodoc                                as [NroPresupuesto],
        prv_fecha                                 as Fecha,
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
         prv_descrip                               as Descrip,
        mon_signo                                 as Signo,
        mon_nombre                                as Moneda,

         pr_codigo +' - '+
        +
        case when pr_nombrefactura <> ''       then pr_nombrefactura 
             when pr_codigo = pr_nombreventa   then ''
             else                                  pr_nombreventa 
        end
        + ' '+
        prvi_descrip                               as Articulo,

        prvi_cantidad                              as Cantidad,
        prvi_precio                               as Precio,
        prvi_ivariporc/100                        as [IVA Porc],
        prvi_ivari                                as IVA,
        prvi_neto                                 as Neto,
        prvi_importe                              as Importe,
        replace(prvi_descrip,char(9),'    ')      as Item_Descrip,
        prv_neto                                   as [Neto total],
        prv_subtotal                              as [Sub Total],
        prv_descuento1/100                        as [Desc 1],
        prv_descuento2/100                        as [Desc 2],
        prv_importedesc1                          as [Importe Desc 1],
        prv_importedesc2                          as [Importe Desc 2],
        prv_total                                  as Total,  
        prv_ivari                                  as [Total IVA],        
        @succlidir as SucCliCalle,
        @succliloc as SucCliLocalidad,
        pro.pro_nombre as Provincia,
        trans_nombre,
        trans_direccion,
        IsNull(prot.pro_nombre,prop.pro_nombre) as ProvinciaT,
        prov_cuit

  from PresupuestoVenta prv inner join PresupuestoVentaItem prvi on prv.prv_id       = prvi.prv_id
                      inner join Producto p          on prvi.pr_id     = p.pr_id
                      inner join Cliente c           on prv.cli_id    = c.cli_id
                      inner join Sucursal s          on prv.suc_id    = s.suc_id
                      inner join Documento doc       on doc.doc_id    = prv.doc_id
                      inner join Moneda mon          on doc.mon_id    = mon.mon_id
                      left   join CondicionPago cp     on prv.cpg_id    = cp.cpg_id
                      left  join Provincia pro       on c.pro_id       = pro.pro_id
                      left  join Transporte trans    on prv.trans_id  = trans.trans_id
                      left  join Provincia prot      on trans.pro_id  = prot.pro_id
                      left  join Proveedor prov      on trans.prov_id = prov.prov_id
                      left  join Provincia prop      on prov.pro_id   = prop.pro_id

  where prv.prv_id = @@pprv_id
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

