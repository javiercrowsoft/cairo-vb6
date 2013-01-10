if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockSave]

/*

 sp_DocRecuentoStockSave 93

*/

go
create procedure sp_DocRecuentoStockSave (
  @@rsTMP_id int
)
as

begin

  set nocount on

  declare @rs_id          int
  declare @depl_id        int
  declare @rsi_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare @bSuccess       tinyint
  declare @MsgError        varchar(5000) set @MsgError = ''

  -- Si no existe chau
  if not exists (select rsTMP_id from RecuentoStockTMP where rsTMP_id = @@rsTMP_id)
    return

-- Talonario
  declare  @doc_id     int
  declare  @rs_nrodoc  varchar (50) 
  
  select @rs_id   = rs_id,  
         @depl_id = depl_id, 

-- Talonario
         @rs_nrodoc  = rs_nrodoc,
         @doc_id    = doc_id

  from RecuentoStockTMP where rsTMP_id = @@rsTMP_id
  
  set @rs_id = isnull(@rs_id,0)
  
  if @rs_id <> 0 begin
    set @MsgError = 'Los Recuentos de stock no pueden modificarse.'
    goto Validate
  end

-- Campos de las tablas

declare  @rs_numero  int 
declare  @rs_descrip varchar (5000)
declare  @rs_fecha   datetime 

declare  @suc_id     int
declare @ta_id      int
declare  @doct_id    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare @rsiTMP_id              int
declare  @rsi_orden               smallint 
declare  @rsi_cantidad           decimal(18, 6) 
declare  @rsi_descrip             varchar (5000) 
declare  @pr_id                   int
declare @stl_id                 int

  begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @rs_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'RecuentoStock','rs_id',@rs_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'RecuentoStock','rs_numero',@rs_numero out, 0
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

              set @rs_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into RecuentoStock (
                              rs_id,
                              rs_numero,
                              rs_nrodoc,
                              rs_descrip,
                              rs_fecha,
                              suc_id,
                              doc_id,
                              doct_id,
                              depl_id,
                              modifico
                            )
      select
                              @rs_id,
                              @rs_numero,
                              @rs_nrodoc,
                              rs_descrip,
                              rs_fecha,
                              suc_id,
                              doc_id,
                              doct_id,
                              depl_id,
                              modifico
      from RecuentoStockTMP
      where rsTMP_id = @@rsTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @rs_nrodoc = rs_nrodoc from RecuentoStock where rs_id = @rs_id
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
                              @rs_id                   = rs_id,
                              @rs_nrodoc              = rs_nrodoc,
                              @rs_descrip              = rs_descrip,
                              @rs_fecha                = rs_fecha,
                              @suc_id                  = suc_id,
                              @doc_id                  = doc_id,
                              @doct_id                = doct_id,
                              @depl_id                = depl_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from RecuentoStockTMP 
    where 
          rsTMP_id = @@rsTMP_id
  
    update RecuentoStock set 
                              rs_nrodoc              = @rs_nrodoc,
                              rs_descrip            = @rs_descrip,
                              rs_fecha              = @rs_fecha,
                              suc_id                = @suc_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              depl_id                = @depl_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where rs_id = @rs_id
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
  while exists(select rsi_orden from RecuentoStockItemTMP where rsTMP_id = @@rsTMP_id and rsi_orden = @orden) 
  begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @rsi_id                      = rsi_id,
            @rsi_orden                  = rsi_orden,
            @rsi_cantidad                = rsi_cantidad,
            @rsi_descrip                = rsi_descrip,
            @pr_id                      = pr_id,
            @depl_id                    = depl_id,
            @rsiTMP_id                  = rsiTMP_id,
            @stl_id                     = stl_id

    from RecuentoStockItemTMP where rsTMP_id = @@rsTMP_id and rsi_orden = @orden

    if @IsNew <> 0 or @rsi_id = 0 begin

        exec SP_DBGetNewId 'RecuentoStockItem','rsi_id',@rsi_id out, 0
        if @@error <> 0 goto ControlError

        insert into RecuentoStockItem (
                                      rs_id,
                                      rsi_id,
                                      rsi_orden,
                                      rsi_cantidad,
                                      rsi_descrip,
                                      pr_id,
                                      depl_id,
                                      stl_id
                                )
                            Values(
                                      @rs_id,
                                      @rsi_id,
                                      @rsi_orden,
                                      @rsi_cantidad,
                                      @rsi_descrip,
                                      @pr_id,
                                      @depl_id,
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

          update RecuentoStockItem set

                  rs_id                      = @rs_id,
                  rsi_orden                  = @rsi_orden,
                  rsi_cantidad              = @rsi_cantidad,
                  rsi_descrip                = @rsi_descrip,
                  pr_id                      = @pr_id,
                  depl_id                    = @depl_id,
                  stl_id                    = @stl_id

        where rs_id = @rs_id and rsi_id = @rsi_id 
        if @@error <> 0 goto ControlError
    end -- Update

    update RecuentoStockItemTMP set rsi_id = @rsi_id where rsiTMP_id = @rsiTMP_id and rsi_orden = @orden
    if @@error <> 0 goto ControlError

    update RecuentoStockItemSerieTMP set rsi_id = @rsi_id where rsiTMP_id = @rsiTMP_id
    if @@error <> 0 goto ControlError

    set @orden = @orden + 1
  end -- While

/* ///////////////////////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

  Ahora tengo que calcular el ajuste que se divide en tres tipos:

    Productos que son Kit
    Productos que llevan Numero de Serie
    El resto de los productos

/////////////////////////////////////////////////////////////////////////////////////////////////////// */

/* ///////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////// */

  -- Empiezo por Productos que llevan Numero de Serie y el resto de los productos (no son kit y no llevan nro serie)

  declare @ajuste         decimal(18,6)
  declare @cantidadStock   decimal(18,6)
  declare @stl_codigo      varchar(50)

  declare c_UpdateStock insensitive cursor for

      select rsi.rsi_id, p.pr_id, rsi.rsi_cantidad, rsi.stl_id, rsit.stl_codigo
      from RecuentoStockItem rsi  inner join RecuentoStockItemTMP rsit on     rsi.rsi_id = rsit.rsi_id
                                                                          and  rsit.rsTMP_id = @@rsTMP_id
                                  inner join Producto p on rsi.pr_id = p.pr_id 
      where rs_id              = @rs_id
        and p.pr_eskit         = 0

  open c_UpdateStock

  fetch next from c_UpdateStock into @rsi_id, @pr_id, @rsi_cantidad, @stl_id, @stl_codigo
  while @@fetch_status = 0
  begin

    if @stl_id is null and @stl_codigo <> '' begin
      select @stl_id = stl_id from StockLote 
      where stl_codigo = @stl_codigo and pr_id = @pr_id

      if @stl_id is null and @stl_codigo <> '' begin
        set @stl_id = -1
      end
    end

    select @cantidadStock = sum(sti_ingreso) - sum(sti_salida) 
    from StockItem 
    where depl_id = @depl_id 
      and pr_id = @pr_id 
      and pr_id_kit is null
      and IsNull(stl_id,0) = IsNull(@stl_id,0)
    set @cantidadStock = IsNull(@cantidadStock,0)

    set @ajuste = @rsi_cantidad - @cantidadStock

    update RecuentoStockItem set 
                                rsi_cantidadStock = @cantidadStock,
                                rsi_ajuste        = @ajuste
    where rsi_id = @rsi_id

    fetch next from c_UpdateStock into @rsi_id, @pr_id, @rsi_cantidad, @stl_id, @stl_codigo
  end

  close c_UpdateStock
  deallocate c_UpdateStock

/* ///////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////// */

--  Productos que son Kit

  declare c_UpdateStock insensitive cursor for

      select rsi_id, p.pr_id, rsi_cantidad 
      from RecuentoStockItem r inner join Producto p on r.pr_id = p.pr_id 
      where rs_id = @rs_id
        and p.pr_eskit <> 0

  open c_UpdateStock

  fetch next from c_UpdateStock into @rsi_id, @pr_id, @rsi_cantidad
  while @@fetch_status = 0
  begin

    select 
            @cantidadStock =(sum(sti_ingreso)  - sum(sti_salida))/pr_kitItems
    from
        StockItem sti  inner join DepositoLogico d           on sti.depl_id     = d.depl_id  
                      inner join Producto p                 on sti.pr_id_kit  = p.pr_id
    where 
              sti.depl_id = @depl_id and p.pr_id = @pr_id
    group by 
              p.pr_id, pr_kitItems

    set @cantidadStock = IsNull(@cantidadStock,0)

    set @ajuste = @rsi_cantidad - @cantidadStock

    update RecuentoStockItem set 
                                rsi_cantidadStock = @cantidadStock,
                                rsi_ajuste        = @ajuste
    where rsi_id = @rsi_id

    fetch next from c_UpdateStock into @rsi_id, @pr_id, @rsi_cantidad
  end

  close c_UpdateStock
  deallocate c_UpdateStock

  /*
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                                                                                                    //
  //                                     STOCK                                                                          //
  //                                                                                                                    //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  */
  declare @depl_id_interno    int
  declare @bError          smallint

  set @depl_id_interno = -2 /*select * from depositologico*/

  if exists(select rsi_ajuste from RecuentoStockItem where rs_id = @rs_id  and rsi_ajuste > 0) begin

                                              -- Origen          Destino/* 1 -> Ingreso a Stock*/
    exec sp_DocRecuentoStockStockSave @@rsTMP_id, @rs_id, @depl_id_interno, @depl_id, 1, 0, @bError out, @MsgError out
    if @bError <> 0 goto Validate

  end 

  if exists(select rsi_ajuste from RecuentoStockItem where rs_id = @rs_id and rsi_ajuste < 0) begin

                                              -- Origen  Destino         /* 2 -> Salida de Stock*/
    exec sp_DocRecuentoStockStockSave @@rsTMP_id, @rs_id, @depl_id, @depl_id_interno, 2, 0, @bError out, @MsgError out
    if @bError <> 0 goto Validate

  end


/* ///////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////// */

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
          @ta_id             = ta_id

  from RecuentoStockTMP inner join documento on RecuentoStockTMP.doc_id = documento.doc_id
  where rsTMP_id = @@rsTMP_id

  exec sp_TalonarioSet @ta_id, @rs_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- FECHAS

-- STOCK
  exec sp_AuditoriaStockCheckDocRS    @rs_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete RecuentoStockItemSerieTMP where rsTMP_id = @@rsTMP_id
  delete RecuentoStockItemTMP where rsTMP_id = @@rsTMP_id
  delete RecuentoStockTMP where rsTMP_id = @@rsTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from RecuentoStock where rs_id = @rs_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 20002, @rs_id, @modifico, 1
  else           exec sp_HistoriaUpdate 20002, @rs_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  select @rs_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar el recuento de stock. sp_DocRecuentoStockSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  goto Roll

Validate:

  raiserror (@MsgError, 16, 1)

Roll:
  if @@trancount > 0 begin
    rollback transaction  
  end

end