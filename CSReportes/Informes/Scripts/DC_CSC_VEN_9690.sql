/*---------------------------------------------------------------------
Nombre: Movimientos de Cuenta Corriente (Debe - Haber)
---------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*

 [DC_CSC_VEN_9690] 1,'20060501 00:00:00','20070430 00:00:00','0','0','1',0

*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9690]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9690]
GO

create procedure DC_CSC_VEN_9690 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@doc_id_source     varchar(255),
@@emp_id_source     varchar(255),
@@doc_id            varchar(255),
@@emp_id            varchar(255),
@@cli_id            varchar(255),
@@porc              decimal(18,6)

)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  declare @doc_id_source   int
  declare @emp_id_source  int
  declare @doc_id         int
  declare @emp_id          int
  declare @cli_id          int
  
  declare @ClienteID     int
  declare @IsRaiz        tinyint

  exec sp_ArbConvertId @@doc_id_source,  @doc_id_source out,  0
  exec sp_ArbConvertId @@emp_id_source,  @emp_id_source out,   0  
  exec sp_ArbConvertId @@doc_id,         @doc_id out,          0
  exec sp_ArbConvertId @@emp_id,          @emp_id out,         0
  exec sp_ArbConvertId @@cli_id,          @cli_id out,         0
  
  exec sp_GetRptId @ClienteID out
  
  if @doc_id_source = 0 begin 
  
    select 1, 'Debe indicar un documento origen (no se permite multiple seleccion).' as Info, '' as dummy_col
    return
  end

  if @emp_id_source = 0 begin 
  
    select 1, 'Debe indicar una empresa origen (no se permite multiple seleccion).' as Info, '' as dummy_col
    return
  end

  if @doc_id = 0 begin 
  
    select 1, 'Debe indicar un documento (no se permite multiple seleccion).' as Info, '' as dummy_col
    return
  end
  
  if @emp_id = 0 begin 
  
    select 1, 'Debe indicar una empresa (no se permite multiple seleccion).' as Info, '' as dummy_col
    return
  end

  if @cli_id = 0 begin 
  
    select 1, 'Debe indicar un cliente (no se permite multiple seleccion).' as Info, '' as dummy_col
    return
  end

  declare @doct_id int

  select @doct_id = doct_id from Documento where doc_id = @doc_id_source

  if isnull(@doct_id,0) <> 3 begin

    select 1, 'El documento de origen debe ser de tipo remito de venta.' as Info, '' as dummy_col
    return
  end

  select @doct_id = doct_id from Documento where doc_id = @doc_id

  if isnull(@doct_id,0) <> 3 begin

    select 1, 'El documento debe ser de tipo remito de venta.' as Info, '' as dummy_col
    return
  end

  declare @emp_id_source_doc   int
  declare @emp_id_doc          int
  declare @mon_id_source      int
  declare @mon_id             int

  select @mon_id_source = mon_id, @emp_id_source_doc = emp_id from documento where doc_id = @doc_id_source
  select @mon_id = mon_id, @emp_id_doc = emp_id from documento where doc_id = @doc_id

  if isnull(@mon_id_source,0) <> isnull(@mon_id,0) begin

    select 1, 'Los documentos deben ser de la misma moneda.' as Info, '' as dummy_col
    return
  end

  if isnull(@emp_id_source,0) <> isnull(@emp_id_source_doc,0) begin

    select 1, 'El documento de origen y la empresa de origen no coinciden.' as Info, '' as dummy_col
    return
  end

  if isnull(@emp_id,0) <> isnull(@emp_id_doc,0) begin

    select 1, 'El documento a destino y la empresa de destino no coinciden.' as Info, '' as dummy_col
    return
  end

/*- ///////////////////////////////////////////////////////////////////////

COPIA DE REMITOS

/////////////////////////////////////////////////////////////////////// */

  declare @rv_id int
  declare @rvi_id int
  declare @rvTMP_id int
  declare @rviTMP_id int
  declare @descrip varchar(255)

  declare c_remitos insensitive cursor for 

    select rv_id, rv_nrodoc + ' ' + cli_nombre
    from RemitoVenta rv inner join Cliente cli on rv.cli_id = cli.cli_id
    where rv_id in (
                    select rvi.rv_id
                    from RemitoFacturaVenta rvfv inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
                                                 inner join FacturaVenta fv on fvi.fv_id = fv.fv_id
                                                 inner join RemitoVentaItem rvi on rvfv.rvi_id = rvi.rvi_id
                    where fv_fecha between @@Fini and @@Ffin
                    )
    
      and emp_id = @emp_id_source
      and doc_id = @doc_id_source

  open c_remitos

  fetch next from c_remitos into @rv_id, @descrip
  while @@fetch_status=0
  begin

    set @rvTMP_id = 0

    exec sp_dbgetnewid 'RemitoVentaTMP','rvTMP_id',@rvTMP_id out, 0

    insert into RemitoVentaTMP (
                                rvTMP_id
                                ,rv_id
                                ,rv_numero
                                ,rv_nrodoc
                                ,rv_descrip
                                ,rv_fecha
                                ,rv_fechaentrega
                                ,rv_neto
                                ,rv_ivari
                                ,rv_ivarni
                                ,rv_subtotal
                                ,rv_total
                                ,rv_descuento1
                                ,rv_descuento2
                                ,rv_importedesc1
                                ,rv_importedesc2
                                ,est_id
                                ,suc_id
                                ,cli_id
                                ,doc_id
                                ,lp_id
                                ,ld_id
                                ,lgj_id
                                ,cpg_id
                                ,ccos_id
                                ,ven_id
                                ,st_id
                                ,pro_id_origen
                                ,pro_id_destino
                                ,trans_id
                                ,clis_id
                                ,creado
                                ,modificado
                                ,modifico
                                ,rv_cotizacion
                                ,rv_nrt_d_destino
                                ,rv_nrt_f_grupo_fin
                                ,rv_nrt_f_pedido
                                ,rv_nrt_grupo
                                ,rv_nrt_h_destino
                                ,rv_nrt_hs_inicio
                                ,rv_nrt_hs_llegada
                                ,rv_nrt_id_vehiculo_tipo
                                ,rv_retiro
                                ,rv_guia
                                ,chof_id
                                ,cam_id
                                ,cam_id_semi
                                ,rv_destinatario
                                ,rv_ordencompra
                              )
                      select 
                                @rvTMP_id
                                ,0  --rv_id         tiene que ser nuevo
                                ,0  --rv_numero      idem
                                ,'' --rv_nrodoc      tiene que ser autoimpresor
                                ,rv_descrip + ' [' + @descrip +']'
                                ,rv_fecha
                                ,rv_fechaentrega
                                ,rv_neto*@@porc
                                ,rv_ivari*@@porc
                                ,rv_ivarni*@@porc
                                ,rv_subtotal*@@porc
                                ,rv_total*@@porc
                                ,rv_descuento1
                                ,rv_descuento2
                                ,rv_importedesc1*@@porc
                                ,rv_importedesc2*@@porc
                                ,est_id
                                ,suc_id
                                ,@cli_id
                                ,@doc_id
                                ,lp_id
                                ,ld_id
                                ,lgj_id
                                ,cpg_id
                                ,ccos_id
                                ,ven_id
                                ,st_id
                                ,pro_id_origen
                                ,pro_id_destino
                                ,trans_id
                                ,clis_id
                                ,creado
                                ,modificado
                                ,modifico
                                ,rv_cotizacion
                                ,rv_nrt_d_destino
                                ,rv_nrt_f_grupo_fin
                                ,rv_nrt_f_pedido
                                ,rv_nrt_grupo
                                ,rv_nrt_h_destino
                                ,rv_nrt_hs_inicio
                                ,rv_nrt_hs_llegada
                                ,rv_nrt_id_vehiculo_tipo
                                ,rv_retiro
                                ,rv_guia
                                ,chof_id
                                ,cam_id
                                ,cam_id_semi
                                ,rv_destinatario
                                ,rv_ordencompra

                      from RemitoVenta 
                      where rv_id = @rv_id 

      declare c_items insensitive cursor for select rvi_id from RemitoVentaItem where rv_id = @rv_id

      open c_items

      fetch next from c_items into @rvi_id
      while @@fetch_status=0
      begin

        set @rviTMP_id = 0

        exec sp_dbgetnewid 'RemitoVentaItemTMP','rviTMP_id',@rviTMP_id out, 0

        insert into RemitoVentaItemTMP (
                                        rvTMP_id
                                        ,rviTMP_id
                                        ,rvi_id
                                        ,rvi_orden
                                        ,rvi_cantidad
                                        ,rvi_cantidadaremitir
                                        ,rvi_pendiente
                                        ,rvi_pendientefac
                                        ,rvi_descrip
                                        ,rvi_precio
                                        ,rvi_precioUsr
                                        ,rvi_precioLista
                                        ,rvi_descuento
                                        ,rvi_neto
                                        ,rvi_ivari
                                        ,rvi_ivarni
                                        ,rvi_ivariporc
                                        ,rvi_ivarniporc
                                        ,rvi_importe
                                        ,rvi_importCodigo
                                        ,pr_id
                                        ,ccos_id
                                        ,stl_id
                                      )
                                select
                                        @rvTMP_id
                                        ,@rviTMP_id
                                        ,0 -- rvi_id tiene que ser nuevo
                                        ,rvi_orden
                                        ,rvi_cantidad
                                        ,rvi_cantidadaremitir
                                        ,rvi_pendiente
                                        ,rvi_pendientefac
                                        ,rvi_descrip
                                        ,rvi_precio*@@porc
                                        ,rvi_precioUsr*@@porc
                                        ,rvi_precioLista*@@porc
                                        ,rvi_descuento
                                        ,rvi_neto*@@porc
                                        ,rvi_ivari*@@porc
                                        ,rvi_ivarni*@@porc
                                        ,rvi_ivariporc
                                        ,rvi_ivarniporc
                                        ,rvi_importe*@@porc
                                        ,rvi_importCodigo
                                        ,pr_id
                                        ,ccos_id
                                        ,stl_id

                                from RemitoVentaItem
                                where rvi_id = @rvi_id

        fetch next from c_items into @rvi_id
      end

      set @rv_id = 0

      exec sp_DocRemitoVentaSave @rvTMP_id, @rv_id out, 0
      if @@error <> 0 goto ControlError

      close c_items
      deallocate c_items

    fetch next from c_remitos into @rv_id, @descrip
  end

  close c_remitos
  deallocate c_remitos

  select 1, 'El proceso se ejeucto con éxito' as Info, '' as dummy_col

union all

  select 1, 'Remitos copiados' as Info, '' as dummy_col

union all

  select rv_id, convert(varchar(12),rv_fecha,105) + ' ' + rv_nrodoc + ' ' + cli_nombre as Info, '' as dummy_col
  from RemitoVenta rv inner join Cliente cli on rv.cli_id = cli.cli_id
  where rv_id in (
                  select rvi.rv_id
                  from RemitoFacturaVenta rvfv inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
                                               inner join FacturaVenta fv on fvi.fv_id = fv.fv_id
                                               inner join RemitoVentaItem rvi on rvfv.rvi_id = rvi.rvi_id
                  where fv_fecha between @@Fini and @@Ffin
                  )
  
    and emp_id = @emp_id_source
    and doc_id = @doc_id_source

  return
ControlError:

  select 1, 'Ha ocurrido un error durante la ejecucion del proceso' as Info, '' as dummy_col

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
