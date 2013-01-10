if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraSave]

/*

 sp_DocOrdenCompraSave 93

*/

go
create procedure sp_DocOrdenCompraSave (
  @@ocTMP_id int
)
as

begin

  set nocount on

  declare @oc_id          int
  declare @oci_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare @emp_id         int

  -- Si no existe chau
  if not exists (select ocTMP_id from OrdenCompraTMP where ocTMP_id = @@ocTMP_id)
    return

  declare  @doct_id    int

-- Talonario
  declare  @oc_nrodoc  varchar (50) 
  declare  @doc_id     int
  
  select   @oc_id = oc_id, 
          @doct_id = doct_id, 
          @emp_id = emp_id,

-- Talonario
         @oc_nrodoc  = oc_nrodoc,
         @doc_id    = OrdenCompraTMP.doc_id

  from 
        OrdenCompraTMP inner join Documento on OrdenCompraTMP.doc_id = Documento.doc_id
  where 
        ocTMP_id = @@ocTMP_id
  
  set @oc_id = isnull(@oc_id,0)
  

-- Campos de las tablas

declare  @oc_numero  int 
declare  @oc_descrip varchar (5000)
declare  @oc_fecha   datetime 
declare  @oc_fechaentrega datetime 
declare  @oc_neto      decimal(18, 6) 
declare  @oc_ivari     decimal(18, 6)
declare  @oc_ivarni    decimal(18, 6)
declare  @oc_total     decimal(18, 6)
declare  @oc_subtotal  decimal(18, 6)
declare  @oc_descuento1    decimal(18, 6)
declare  @oc_descuento2    decimal(18, 6)
declare  @oc_importedesc1  decimal(18, 6)
declare  @oc_importedesc2  decimal(18, 6)

declare @oc_ordencompra        varchar(50)
declare @oc_presupuesto        varchar(50)
declare @oc_maquina            varchar(255)
declare @oc_maquinanro        varchar(50)
declare @oc_maquinamodelo      varchar(50)
declare @oc_fleteaereo        tinyint
declare @oc_fletemaritimo      tinyint
declare @oc_fletecorreo        tinyint
declare @oc_fletecamion        tinyint
declare @oc_fleteotros        tinyint
declare @cli_id                int

declare  @est_id     int
declare  @suc_id     int
declare  @prov_id    int
declare @ta_id      int
declare  @lp_id      int 
declare  @ld_id      int 
declare  @cpg_id     int
declare  @ccos_id    int
declare @lgj_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 


declare  @oci_orden               smallint 
declare  @oci_cantidad           decimal(18, 6) 
declare  @oci_cantidadaremitir   decimal(18, 6) 
declare  @oci_pendientefac       decimal(18, 6) 
declare  @oci_descrip             varchar (5000) 
declare  @oci_precio             decimal(18, 6) 
declare  @oci_precioUsr           decimal(18, 6)
declare  @oci_precioLista         decimal(18, 6)
declare  @oci_descuento           varchar (100) 
declare  @oci_neto               decimal(18, 6) 
declare  @oci_ivari               decimal(18, 6)
declare  @oci_ivarni             decimal(18, 6)
declare  @oci_ivariporc           decimal(18, 6)
declare  @oci_ivarniporc         decimal(18, 6)
declare @oci_importe             decimal(18, 6)
declare  @pr_id                   int

declare @bSuccess tinyint

declare @MsgError  varchar(5000) set @MsgError = ''

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @oc_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'OrdenCompra','oc_id',@oc_id out,0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'OrdenCompra','oc_numero',@oc_numero out,0
    if @@error <> 0 goto ControlError

    -- //////////////////////////////////////////////////////////////////////////////////
    --
    -- Talonario
    --
          declare @ta_propuesto tinyint
          declare @ta_tipo      smallint
      
          exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, 0, 0, @ta_id out, @ta_tipo out
          if @@error <> 0 goto ControlError
      
          if @ta_propuesto = 0 begin
      
            if @ta_tipo = 3 /*Auto Impresor*/ begin

              declare @ta_nrodoc varchar(100)

              exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
              if @@error <> 0 goto ControlError

              -- Con esto evitamos que dos tomen el mismo número
              --
              exec sp_TalonarioSet @ta_id, @ta_nrodoc
              if @@error <> 0 goto ControlError

              set @oc_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into OrdenCompra (
                              oc_id,
                              oc_numero,
                              oc_nrodoc,
                              oc_descrip,
                              oc_fecha,
                              oc_fechaentrega,
                              oc_neto,
                              oc_ivari,
                              oc_ivarni,
                              oc_total,
                              oc_subtotal,
                              oc_descuento1,
                              oc_descuento2,
                              oc_importedesc1,
                              oc_importedesc2,

                              oc_ordencompra,
                              oc_presupuesto,
                              oc_maquina,
                              oc_maquinanro,
                              oc_maquinamodelo,
                              oc_fleteaereo,
                              oc_fletemaritimo,
                              oc_fletecorreo,
                              oc_fletecamion,
                              oc_fleteotros,

                              est_id,
                              suc_id,
                              prov_id,
                              cli_id,

                              emp_id,
                              doc_id,
                              doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              modifico
                            )
      select
                              @oc_id,
                              @oc_numero,
                              @oc_nrodoc,
                              oc_descrip,
                              oc_fecha,
                              oc_fechaentrega,
                              oc_neto,
                              oc_ivari,
                              oc_ivarni,
                              oc_total,
                              oc_subtotal,
                              oc_descuento1,
                              oc_descuento2,
                              oc_importedesc1,
                              oc_importedesc2,

                              oc_ordencompra,
                              oc_presupuesto,
                              oc_maquina,
                              oc_maquinanro,
                              oc_maquinamodelo,
                              oc_fleteaereo,
                              oc_fletemaritimo,
                              oc_fletecorreo,
                              oc_fletecamion,
                              oc_fleteotros,

                              est_id,
                              suc_id,
                              prov_id,
                              cli_id,

                              @emp_id,
                              doc_id,
                              @doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              modifico
      from OrdenCompraTMP
      where ocTMP_id = @@ocTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @oc_nrodoc = oc_nrodoc from OrdenCompra where oc_id = @oc_id
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        UPDATE                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  else begin

    set @IsNew = 0

    select
                              @oc_id                   = oc_id,
                              @oc_nrodoc              = oc_nrodoc,
                              @oc_descrip              = oc_descrip,
                              @oc_fecha                = oc_fecha,
                              @oc_fechaentrega        = oc_fechaentrega,
                              @oc_neto                = oc_neto,
                              @oc_ivari                = oc_ivari,
                              @oc_ivarni              = oc_ivarni,
                              @oc_total                = oc_total,
                              @oc_descuento1          = oc_descuento1,
                              @oc_descuento2          = oc_descuento2,
                              @oc_subtotal            = oc_subtotal,
                              @oc_importedesc1        = oc_importedesc1,
                              @oc_importedesc2        = oc_importedesc2,

                              @oc_ordencompra          = oc_ordencompra,
                              @oc_presupuesto          = oc_presupuesto,
                              @oc_maquina              = oc_maquina,
                              @oc_maquinanro          = oc_maquinanro,
                              @oc_maquinamodelo        = oc_maquinamodelo,
                              @oc_fleteaereo          = oc_fleteaereo,
                              @oc_fletemaritimo        = oc_fletemaritimo,
                              @oc_fletecorreo          = oc_fletecorreo,
                              @oc_fletecamion          = oc_fletecamion,
                              @oc_fleteotros          = oc_fleteotros,

                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @prov_id                = prov_id,
                              @cli_id                  = cli_id,

                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @cpg_id                  = cpg_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                  = lgj_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from OrdenCompraTMP 
    where 
          ocTMP_id = @@ocTMP_id
  
    update OrdenCompra set 
                              oc_nrodoc              = @oc_nrodoc,
                              oc_descrip            = @oc_descrip,
                              oc_fecha              = @oc_fecha,
                              oc_fechaentrega        = @oc_fechaentrega,
                              oc_neto                = @oc_neto,
                              oc_ivari              = @oc_ivari,
                              oc_ivarni              = @oc_ivarni,
                              oc_total              = @oc_total,
                              oc_descuento1         = @oc_descuento1,
                              oc_descuento2         = @oc_descuento2,
                              oc_subtotal            = @oc_subtotal,
                              oc_importedesc1       = @oc_importedesc1,
                              oc_importedesc2       = @oc_importedesc2,

                              oc_ordencompra        = @oc_ordencompra,
                              oc_presupuesto        = @oc_presupuesto,
                              oc_maquina            = @oc_maquina,
                              oc_maquinanro          = @oc_maquinanro,
                              oc_maquinamodelo      = @oc_maquinamodelo,
                              oc_fleteaereo          = @oc_fleteaereo,
                              oc_fletemaritimo      = @oc_fletemaritimo,
                              oc_fletecorreo        = @oc_fletecorreo,
                              oc_fletecamion        = @oc_fletecamion,
                              oc_fleteotros          = @oc_fleteotros,

                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              prov_id                = @prov_id,
                              cli_id                = @cli_id,

                              emp_id                = @emp_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              ccos_id                = @ccos_id,
                              lgj_id                = @lgj_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where oc_id = @oc_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @orden = 1
  while exists(select oci_orden from OrdenCompraItemTMP where ocTMP_id = @@ocTMP_id and oci_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @oci_id                      = oci_id,
            @oci_orden                  = oci_orden,
            @oci_cantidad                = oci_cantidad,
            @oci_cantidadaremitir        = oci_cantidadaremitir,
            @oci_descrip                = oci_descrip,
            @oci_precio                  = oci_precio,
            @oci_precioUsr              = oci_precioUsr,
            @oci_precioLista            = oci_precioLista,
            @oci_descuento              = oci_descuento,
            @oci_neto                    = oci_neto,
            @oci_ivari                  = oci_ivari,
            @oci_ivarni                  = oci_ivarni,
            @oci_ivariporc              = oci_ivariporc,
            @oci_ivarniporc              = oci_ivarniporc,
            @oci_importe                = oci_importe,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id

    from OrdenCompraItemTMP where ocTMP_id = @@ocTMP_id and oci_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @oci_cantidadaremitir = @oci_cantidad

    if @IsNew <> 0 or @oci_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @oci_pendientefac         = @oci_cantidadaremitir     

        exec SP_DBGetNewId 'OrdenCompraItem','oci_id',@oci_id out,0
        if @@error <> 0 goto ControlError
    
        insert into OrdenCompraItem (
                                      oc_id,
                                      oci_id,
                                      oci_orden,
                                      oci_cantidad,
                                      oci_cantidadaremitir,
                                      oci_pendientefac,
                                      oci_descrip,
                                      oci_precio,
                                      oci_precioUsr,
                                      oci_precioLista,
                                      oci_descuento,
                                      oci_neto,
                                      oci_ivari,
                                      oci_ivarni,
                                      oci_ivariporc,
                                      oci_ivarniporc,
                                      oci_importe,
                                      pr_id,
                                      ccos_id
                                )
                            Values(
                                      @oc_id,
                                      @oci_id,
                                      @oci_orden,
                                      @oci_cantidad,
                                      @oci_cantidadaremitir, 
                                      @oci_pendientefac, 
                                      @oci_descrip,
                                      @oci_precio,
                                      @oci_precioUsr,
                                      @oci_precioLista,
                                      @oci_descuento,
                                      @oci_neto,
                                      @oci_ivari,
                                      @oci_ivarni,
                                      @oci_ivariporc,
                                      @oci_ivarniporc,
                                      @oci_importe,
                                      @pr_id,
                                      @ccos_id
                                )

        if @@error <> 0 goto ControlError
    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          -- Cuando se actualiza se encarga el sp sp_DocOrdenVentaSetPendiente de actulizar
          -- oci_pendientefac y oc_pendiente

          update OrdenCompraItem set

                  oc_id                      = @oc_id,
                  oci_orden                  = @oci_orden,
                  oci_cantidad              = @oci_cantidad,
                  oci_cantidadaremitir      = @oci_cantidadaremitir,
                  oci_descrip                = @oci_descrip,
                  oci_precio                = @oci_precio,
                  oci_precioUsr              = @oci_precioUsr,
                  oci_precioLista            = @oci_precioLista,
                  oci_descuento              = @oci_descuento,
                  oci_neto                  = @oci_neto,
                  oci_ivari                  = @oci_ivari,
                  oci_ivarni                = @oci_ivarni,
                  oci_ivariporc              = @oci_ivariporc,
                  oci_ivarniporc            = @oci_ivarniporc,
                  oci_importe                = @oci_importe,
                  pr_id                      = @pr_id,
                  ccos_id                    = @ccos_id

        where oc_id = @oc_id and oci_id = @oci_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados del Orden
  if @IsNew = 0 begin
    
    delete OrdenCompraItem 
            where exists (select oci_id 
                          from OrdenCompraItemBorradoTMP 
                          where oc_id     = @oc_id 
                            and ocTMP_id  = @@ocTMP_id
                            and oci_id     = OrdenCompraItem.oci_id
                          )
    if @@error <> 0 goto ControlError

    delete OrdenCompraItemBorradoTMP where oc_id = @oc_id and ocTMP_id = @@ocTMP_id

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION ORDEN - REMITO                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocOrdenCpraSaveAplic @oc_id, @@ocTMP_id, 0, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@oc_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     CREDITO Y ESTADO                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  
  -- Actualizo la deuda de la Orden
  exec sp_DocOrdenCompraSetPendiente @oc_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  exec sp_DocOrdenCompraSetCredito @oc_id
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenCompraSetEstado @oc_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocOC    @oc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocOC  @oc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocOC  @oc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  delete OrdenCompraItemTMP where ocTMP_ID = @@ocTMP_id
  delete OrdenCompraTMP where ocTMP_ID = @@ocTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from OrdenCompra where oc_id = @oc_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 17004, @oc_id, @modifico, 1
  else           exec sp_HistoriaUpdate 17004, @oc_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  commit transaction

  select @oc_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar el Orden de compra. sp_DocOrdenCompraSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end