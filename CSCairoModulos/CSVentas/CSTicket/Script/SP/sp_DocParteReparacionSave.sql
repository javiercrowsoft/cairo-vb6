if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionSave]

/*

begin transaction

exec sp_DocParteReparacionSave 4

rollback transaction

*/

go
create procedure sp_DocParteReparacionSave (
  @@prpTMP_ID int,
  @@prp_id    int = 0 out,
  @@bSelect  tinyint = 1
)
as

begin

  set nocount on

  declare @prp_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @doct_id        int
  declare @emp_id         int
  declare  @prns_id         int

  -- Si no existe chau
  if not exists (select prpTMP_ID from ParteReparacionTMP where prpTMP_ID = @@prpTMP_ID)
    return

-- Talonario
  declare  @doc_id       int
  declare  @prp_nrodoc    varchar (50) 
  
  select 
          @prp_id       = prp_id,
          @doct_id       = Documento.doct_id,
          @emp_id       = emp_id,
          @prns_id      = prns_id,

-- Talonario
         @prp_nrodoc = prp_nrodoc,
         @doc_id    = ParteReparacionTMP.doc_id
  
  from ParteReparacionTMP inner join Documento on ParteReparacionTMP.doc_id = Documento.doc_id
  where prpTMP_ID = @@prpTMP_ID
  
  set @prp_id = isnull(@prp_id,0)
  

-- Campos de las tablas

declare  @prp_numero        int 
declare  @prp_descrip       varchar (5000)
declare  @prp_fecha         datetime 
declare  @prp_fechaentrega datetime 
declare  @prp_neto          decimal(18, 6) 
declare  @prp_ivari         decimal(18, 6)
declare  @prp_ivarni        decimal(18, 6)
declare  @prp_total         decimal(18, 6)
declare  @prp_subtotal      decimal(18, 6)
declare  @prp_descuento1   decimal(18, 6)
declare  @prp_descuento2   decimal(18, 6)
declare  @prp_importedesc1 decimal(18, 6)
declare  @prp_importedesc2 decimal(18, 6)
declare  @prp_cotizacion    decimal(18, 6)

declare  @est_id             int
declare  @suc_id             int
declare  @cli_id             int
declare @ta_id              int
declare  @lp_id              int 
declare  @ld_id              int 
declare  @cpg_id             int
declare  @ccos_id            int
declare @stl_id             int
declare @lgj_id             int
declare @us_id2             int
declare @prp_tipo           int
declare @prp_estado        int
declare @clis_id            int
declare @cont_id            int
declare  @creado             datetime 
declare  @modificado         datetime 
declare  @modifico           int 

declare @prpi_id                int
declare @prpiTMP_id              int
declare  @prpi_orden             smallint 
declare  @prpi_cantidad           decimal(18, 6) 
declare  @prpi_descrip           varchar (5000) 
declare  @prpi_precio             decimal(18, 6) 
declare  @prpi_precioUsr         decimal(18, 6)
declare  @prpi_precioLista       decimal(18, 6)
declare  @prpi_descuento         varchar (100) 
declare  @prpi_neto               decimal(18, 6) 
declare  @prpi_ivari             decimal(18, 6)
declare  @prpi_ivarni             decimal(18, 6)
declare  @prpi_ivariporc         decimal(18, 6)
declare  @prpi_ivarniporc         decimal(18, 6)
declare @prpi_importe           decimal(18, 6)
declare @pr_id                  int
declare @os_id                   int  

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @prp_id = 0 begin

    set @IsNew = -1
  
    select @os_id = doc_id_ingreso from ProductoNumeroSerie where prns_id = @prns_id and doct_id_ingreso = 42

    exec SP_DBGetNewId 'ParteReparacion','prp_id',@prp_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'ParteReparacion','prp_numero',@prp_numero out, 0
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

              set @prp_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into ParteReparacion (
                              prp_id,
                              prp_numero,
                              prp_nrodoc,
                              prp_descrip,
                              prp_fecha,
                              prp_fechaentrega,
                              prp_neto,
                              prp_ivari,
                              prp_ivarni,
                              prp_total,
                              prp_subtotal,
                              prp_descuento1,
                              prp_descuento2,
                              prp_importedesc1,
                              prp_importedesc2,
                              prp_cotizacion,
                              prp_tipo,
                              prp_estado,
                              est_id,
                              suc_id,
                              cli_id,
                              emp_id,
                              doc_id,
                              doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              us_id,
                              clis_id,
                              prns_id,
                              cont_id,
                              os_id,
                              modifico
                            )
      select
                              @prp_id,
                              @prp_numero,
                              @prp_nrodoc,
                              prp_descrip,
                              prp_fecha,
                              prp_fechaentrega,
                              prp_neto,
                              prp_ivari,
                              prp_ivarni,
                              prp_total,
                              prp_subtotal,
                              prp_descuento1,
                              prp_descuento2,
                              prp_importedesc1,
                              prp_importedesc2,
                              prp_cotizacion,
                              prp_tipo,
                              prp_estado,
                              est_id,
                              suc_id,
                              cli_id,
                              @emp_id,
                              doc_id,
                              @doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              us_id,
                              clis_id,
                              prns_id,
                              cont_id,
                              @os_id,
                              modifico
      from ParteReparacionTMP
      where prpTMP_ID = @@prpTMP_ID  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @prp_nrodoc = prp_nrodoc from ParteReparacion where prp_id = @prp_id
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
                              @prp_id                 = prp_id,
                              @prp_nrodoc              = prp_nrodoc,
                              @prp_descrip            = prp_descrip,
                              @prp_fecha              = prp_fecha,
                              @prp_fechaentrega        = prp_fechaentrega,
                              @prp_neto                = prp_neto,
                              @prp_ivari              = prp_ivari,
                              @prp_ivarni              = prp_ivarni,
                              @prp_total              = prp_total,
                              @prp_descuento1         = prp_descuento1,
                              @prp_descuento2         = prp_descuento2,
                              @prp_subtotal            = prp_subtotal,
                              @prp_importedesc1       = prp_importedesc1,
                              @prp_importedesc2       = prp_importedesc2,
                              @prp_cotizacion          = prp_cotizacion,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,
                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @cpg_id                  = cpg_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                 = lgj_id,
                              @us_id2                 = us_id,
                              @prp_tipo                = prp_tipo,
                              @prp_estado            = prp_estado,
                              @clis_id                = clis_id,
                              @cont_id                = cont_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from ParteReparacionTMP 
    where 
          prpTMP_ID = @@prpTMP_ID

    declare @prns_id_actual int
    select @prns_id_actual = prns_id from ParteReparacion where prp_id = @prp_id
  
    update ParteReparacion set 
                              prp_nrodoc            = @prp_nrodoc,
                              prp_descrip            = @prp_descrip,
                              prp_fecha              = @prp_fecha,
                              prp_fechaentrega      = @prp_fechaentrega,
                              prp_neto              = @prp_neto,
                              prp_ivari              = @prp_ivari,
                              prp_ivarni            = @prp_ivarni,
                              prp_total              = @prp_total,
                              prp_descuento1        = @prp_descuento1,
                              prp_descuento2        = @prp_descuento2,
                              prp_subtotal          = @prp_subtotal,
                              prp_importedesc1      = @prp_importedesc1,
                              prp_importedesc2      = @prp_importedesc2,
                              prp_cotizacion        = @prp_cotizacion,
                              prp_tipo              = @prp_tipo,
                              prp_estado            = @prp_estado,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              cli_id                = @cli_id,
                              emp_id                = @emp_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              ccos_id                = @ccos_id,
                              lgj_id                = @lgj_id,
                              us_id                 = @us_id2,
                              clis_id               = @clis_id,
                              prns_id               = @prns_id,
                              cont_id               = @cont_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where prp_id = @prp_id
    if @@error <> 0 goto ControlError

    declare @bUpdateOs tinyint

    if @prns_id <> @prns_id_actual begin

      set @bUpdateOs = 1

    end else begin

      if not exists(select * from stockitem sti inner join ordenservicio os 
                                on sti.st_id = os.st_id and os.os_id = @os_id
                    where prns_id = @prns_id)
        set @bUpdateOs = 1
    end

    if @bUpdateOs <> 0 begin
      set @os_id = null
      select @os_id = doc_id_ingreso 
      from ProductoNumeroSerie 
      where prns_id = @prns_id 
        and doct_id_ingreso = 42

      update ParteReparacion set os_id = @os_id where prp_id = @prp_id 
      if @@error <> 0 goto ControlError
    end

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @orden = 1
  while exists(select prpi_orden from ParteReparacionItemTMP where prpTMP_ID = @@prpTMP_ID and prpi_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @prpiTMP_id                  = prpiTMP_id,
            @prpi_id                    = prpi_id,
            @prpi_orden                  = prpi_orden,
            @prpi_cantidad              = prpi_cantidad,
            @prpi_descrip                = prpi_descrip,
            @prpi_precio                = prpi_precio,
            @prpi_precioUsr              = prpi_precioUsr,
            @prpi_precioLista            = prpi_precioLista,
            @prpi_descuento              = prpi_descuento,
            @prpi_neto                  = prpi_neto,
            @prpi_ivari                  = prpi_ivari,
            @prpi_ivarni                = prpi_ivarni,
            @prpi_ivariporc              = prpi_ivariporc,
            @prpi_ivarniporc            = prpi_ivarniporc,
            @prpi_importe                = prpi_importe,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id,
            @stl_id                     = stl_id

    from ParteReparacionItemTMP where prpTMP_ID = @@prpTMP_ID and prpi_orden = @orden

    if @IsNew <> 0 or @prpi_id = 0 begin

        exec SP_DBGetNewId 'ParteReparacionItem','prpi_id',@prpi_id out, 0
        if @@error <> 0 goto ControlError

        insert into ParteReparacionItem (
                                      prp_id,
                                      prpi_id,
                                      prpi_orden,
                                      prpi_cantidad,
                                      prpi_descrip,
                                      prpi_precio,
                                      prpi_precioUsr,
                                      prpi_precioLista,
                                      prpi_descuento,
                                      prpi_neto,
                                      prpi_ivari,
                                      prpi_ivarni,
                                      prpi_ivariporc,
                                      prpi_ivarniporc,
                                      prpi_importe,
                                      pr_id,
                                      ccos_id,
                                      stl_id
                                )
                            Values(
                                      @prp_id,
                                      @prpi_id,
                                      @prpi_orden,
                                      @prpi_cantidad,
                                      @prpi_descrip,
                                      @prpi_precio,
                                      @prpi_precioUsr,
                                      @prpi_precioLista,
                                      @prpi_descuento,
                                      @prpi_neto,
                                      @prpi_ivari,
                                      @prpi_ivarni,
                                      @prpi_ivariporc,
                                      @prpi_ivarniporc,
                                      @prpi_importe,
                                      @pr_id,
                                      @ccos_id,
                                      @stl_id
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

          update ParteReparacionItem set

                  prp_id                      = @prp_id,
                  prpi_orden                  = @prpi_orden,
                  prpi_cantidad                = @prpi_cantidad,
                  prpi_descrip                = @prpi_descrip,
                  prpi_precio                  = @prpi_precio,
                  prpi_precioUsr              = @prpi_precioUsr,
                  prpi_precioLista            = @prpi_precioLista,
                  prpi_descuento              = @prpi_descuento,
                  prpi_neto                    = @prpi_neto,
                  prpi_ivari                  = @prpi_ivari,
                  prpi_ivarni                  = @prpi_ivarni,
                  prpi_ivariporc              = @prpi_ivariporc,
                  prpi_ivarniporc              = @prpi_ivarniporc,
                  prpi_importe                = @prpi_importe,
                  pr_id                        = @pr_id,
                  ccos_id                      = @ccos_id,
                  stl_id                      = @stl_id

        where prp_id = @prp_id and prpi_id = @prpi_id 
        if @@error <> 0 goto ControlError
    end -- Update

    update ParteReparacionItemSerieTMP set prpi_id = @prpi_id where prpiTMP_id = @prpiTMP_id 
    if @@error <> 0 goto ControlError

    set @orden = @orden + 1
  end -- While

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ITEM'S BORRADOS                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin
    
    delete ParteReparacionItem 
            where exists (select prpi_id 
                          from ParteReparacionItemBorradoTMP 
                          where prp_id     = @prp_id 
                            and prpTMP_id  = @@prpTMP_id
                            and prpi_id   = ParteReparacionItem.prpi_id
                          )
    if @@error <> 0 goto ControlError

    delete ParteReparacionItemBorradoTMP where prp_id = @prp_id and prpTMP_id = @@prpTMP_id

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TALONARIO                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bError          smallint
  declare @depl_id        int

  select 
          @ta_id             = ta_id,
          @depl_id          = ParteReparacionTMP.depl_id

  from ParteReparacionTMP inner join documento on ParteReparacionTMP.doc_id = documento.doc_id
  where prpTMP_id = @@prpTMP_id

  exec sp_TalonarioSet @ta_id,@prp_nrodoc
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocParteReparacionSetEstado @prp_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  declare @MsgError  varchar(5000) set @MsgError = ''

  -- Stock Tradicional
  --
  exec sp_DocParteReparacionStockSave   
                                    @@prpTMP_id,
                                    @prp_id, 
                                    @depl_id, 
                                    0, 
                                    0, 
                                    @bError out, 
                                    @MsgError out
  if @bError <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bSuccess  tinyint

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocPRP  @prp_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- STOCK
  exec sp_AuditoriaStockCheckDocPRP    @prp_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocPRP  @prp_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 BORRAR TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  delete ParteReparacionItemSerieTMP where prpTMP_id = @@prpTMP_ID
  delete ParteReparacionItemTMP where prpTMP_ID = @@prpTMP_ID
  delete ParteReparacionTMP where prpTMP_ID = @@prpTMP_ID

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from ParteReparacion where prp_id = @prp_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 28007, @prp_id, @modifico, 1
  else           exec sp_HistoriaUpdate 28007, @prp_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@prp_id = @prp_id

  if @@bSelect <> 0 select @prp_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar el parte de reparación. sp_DocParteReparacionSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end