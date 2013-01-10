if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDespachoImpCalculoGetPOAR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDespachoImpCalculoGetPOAR]


-- sp_DocDespachoImpCalculoGetPOAR 4,359,1,0,20.000000,1724.500000

go
create procedure sp_DocDespachoImpCalculoGetPOAR (

  @@dic_id int,
  @@rc_id  int,
  @@bCalc  tinyint,

  @@seguro      decimal(18,6),
  @@embalaje    decimal(18,6),
  @@flete        decimal(18,6)


)as 

begin

--   declare @seguro      decimal(18,6)
--   declare @embalaje    decimal(18,6)
--  declare @flete      decimal(18,6)
   declare @fletecif    decimal(18,6)

--   declare @codigo_seguro      int   set @codigo_seguro      = 2
--   declare @codigo_embalaje    int   set @codigo_embalaje     = 3
--   declare @codigo_flete       int   set @codigo_flete       = 4
-- 
--   select @seguro     = dici_importe from DespachoImpCalculoItem where dic_id = @@dic_id and dici_codigo = @codigo_seguro
--   select @embalaje   = dici_importe from DespachoImpCalculoItem where dic_id = @@dic_id and dici_codigo = @codigo_embalaje
--   select @flete      = dici_importe from DespachoImpCalculoItem where dic_id = @@dic_id and dici_codigo = @codigo_flete

  set @fletecif = @@flete + @@seguro + @@embalaje

  if exists(select * 
            from RemitoCompraItem rci inner join Producto pr on rci.pr_id = pr.pr_id
            where rc_id = @@rc_id
              and poar_id is null
            )
  begin

    select  '@@ERROR_SP_RS:Existen articulos en este remito que no tienen asociada una posicion arancelaria. Debe modificar la configuracion de estos articulos para poder continuar.'
                    as error_in_sp_id, 
            pr_nombrecompra as Articulo

    from RemitoCompraItem rci inner join Producto pr on rci.pr_id = pr.pr_id
    where rc_id = @@rc_id

    return
  end

  if @@bCalc <> 0 begin

    select 
  
          poar.poar_id,
          ltrim(poar_nombre + ' ' + poar_codigo) as poar_nombre,
          poar_descrip,
          dic_id,
          sum((rci_neto + (@fletecif * rci_neto / rc_neto))*tid.ti_porcentaje/100)      as dicp_derechos,
          sum((rci_neto + (@fletecif * rci_neto / rc_neto))*tie.ti_porcentaje/100)      as dicp_estadisticas,


          dicp_gastoenvio,
          dicp_id,

          sum(
              (
                (rci_neto + (@fletecif * (rci_neto / rc_neto)))
                +((rci_neto + (@fletecif * (rci_neto / rc_neto)))*tid.ti_porcentaje/100)
                +((rci_neto + (@fletecif * (rci_neto / rc_neto)))*tie.ti_porcentaje/100)
              )
              *tigan.ti_porcentaje/100)   as dicp_ganancias,

          sum(
              (
                (rci_neto + (@fletecif * (rci_neto / rc_neto)))
                +(rci_neto + (@fletecif * (rci_neto / rc_neto)))*tid.ti_porcentaje/100
                +(rci_neto + (@fletecif * (rci_neto / rc_neto)))*tie.ti_porcentaje/100
              )
              *tiigb.ti_porcentaje/100)   as dicp_igb,

          sum(
              (
                (rci_neto + (@fletecif * rci_neto / rc_neto))
                +(rci_neto + (@fletecif * rci_neto / rc_neto))*tid.ti_porcentaje/100
                +(rci_neto + (@fletecif * rci_neto / rc_neto))*tie.ti_porcentaje/100
              )
              *tiiva.ti_porcentaje/100)   as dicp_iva,

          sum(
              (
                (rci_neto + (@fletecif * rci_neto / rc_neto))
                +(rci_neto + (@fletecif * rci_neto / rc_neto))*tid.ti_porcentaje/100
                +(rci_neto + (@fletecif * rci_neto / rc_neto))*tie.ti_porcentaje/100
              )
              *tiiva3.ti_porcentaje/100)  as dicp_iva3431
          
    from 

          RemitoCompra rc      inner join RemitoCompraItem rci on rc.rc_id = rci.rc_id
                                                                and  rc.rc_id = @@rc_id

                               inner join Producto pr on rci.pr_id = pr.pr_id
                               left  join PosicionArancel poar on pr.poar_id = poar.poar_id
  
                               left  join DespachoImpCalculoPosicionArancel dicp 
                                                  on   poar.poar_id = dicp.poar_id
                                                  and dicp.dic_id = @@dic_id

                               left  join TasaImpositiva tid on poar.ti_id_derechos = tid.ti_id
                               left  join TasaImpositiva tie on poar.ti_id_estadistica = tie.ti_id

                               left  join TasaImpositiva tigan   on pr.ti_id_comex_ganancias   = tigan.ti_id
                               left  join TasaImpositiva tiigb   on pr.ti_id_comex_igb         = tiigb.ti_id
                               left  join TasaImpositiva tiiva3 on pr.ti_id_comex_iva         = tiiva3.ti_id
                               left  join TasaImpositiva tiiva  on pr.ti_id_ivaricompra        = tiiva.ti_id

    where             
          
      rci.rc_id = @@rc_id
  
    group by 
          poar.poar_id,
          ltrim(poar_nombre + ' ' + poar_codigo),
          poar_descrip,
          dic_id,
          dicp_derechos,
          dicp_estadisticas,
          dicp_ganancias,
          dicp_gastoenvio,
          dicp_id,
          dicp_igb,
          dicp_iva,
          dicp_iva3431

  end else begin

    select 
  
          poar.poar_id,
          ltrim(poar_nombre + ' ' + poar_codigo) as poar_nombre,
          poar_descrip,
          dic_id,
          dicp_derechos,
          dicp_estadisticas,
          dicp_ganancias,
          dicp_gastoenvio,
          dicp_id,
          dicp_igb,
          dicp_iva,
          dicp_iva3431
          
    from 
          RemitoCompraItem rci inner join Producto pr on rci.pr_id = pr.pr_id
                               left  join PosicionArancel poar on pr.poar_id = poar.poar_id
  
                               left  join DespachoImpCalculoPosicionArancel dicp 
                                                  on   poar.poar_id = dicp.poar_id
                                                  and dicp.dic_id = @@dic_id
    where             
          
      rci.rc_id = @@rc_id
  
    group by 
          poar.poar_id,
          ltrim(poar_nombre + ' ' + poar_codigo),
          poar_descrip,
          dic_id,
          dicp_derechos,
          dicp_estadisticas,
          dicp_ganancias,
          dicp_gastoenvio,
          dicp_id,
          dicp_igb,
          dicp_iva,
          dicp_iva3431

  end

end
