if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponSave]

/*

 sp_DocResolucionCuponSave 124

*/

go
create procedure sp_DocResolucionCuponSave (
  @@rcupTMP_id       int,
  @@bSelect          tinyint = 1,
  @@rcup_id          int     = 0 out,
  @@bSuccess        tinyint = 0 out
)
as

begin

  set nocount on

  declare @rcup_id          int
  declare @rcupi_id          int
  declare @IsNew            smallint
  declare @orden            smallint
  declare  @doct_id          int
  declare  @rcup_total       decimal(18, 6)
  declare  @rcup_fecha       datetime 

  set @@bSuccess = 0

  -- Si no existe chau
  if not exists (select rcupTMP_id from ResolucionCuponTMP where rcupTMP_id = @@rcupTMP_id)
    return
  
  select @rcup_id = rcup_id from ResolucionCuponTMP where rcupTMP_id = @@rcupTMP_id
  
  set @rcup_id = isnull(@rcup_id,0)
  

  -- La moneda y el talonario siempre salen del documento 
  declare @ta_id          int

-- Taloanrio
  declare  @doc_id       int
  declare  @rcup_nrodoc  varchar (50) 

  select @ta_id             = Documento.ta_id,
         @doct_id           = Documento.doct_id,
         @rcup_total        = ResolucionCuponTMP.rcup_total,
         @rcup_fecha        = ResolucionCuponTMP.rcup_fecha,

-- Talonario
         @rcup_nrodoc = rcup_nrodoc,
         @doc_id      = ResolucionCuponTMP.doc_id


  from ResolucionCuponTMP inner join Documento on ResolucionCuponTMP.doc_id = Documento.doc_id
  where rcupTMP_id = @@rcupTMP_id

  if IsNull(@ta_id,0) = 0 begin
    select col1 = 'ERROR', col2 = 'El documento no tiene definido su talonario.'
    return
  end

-- Campos de las tablas

declare  @rcup_numero  int 
declare  @rcup_descrip varchar (5000)

declare @rcup_grabarasiento tinyint

declare  @est_id     int
declare  @suc_id     int
declare  @cue_id     int
declare @tjcc_id    int
declare @lgj_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @rcupi_orden             smallint 
declare  @rcupi_descrip           varchar (5000) 
declare @rcupi_cuota            tinyint
declare @rcupi_comision         decimal(18, 6)
declare @rcupi_importe           decimal(18, 6)
declare @rcupi_importeorigen    decimal(18, 6)
declare @rcupi_rechazado        tinyint

declare @conciliado             decimal(18,6)

declare @MsgError  varchar(5000) set @MsgError = ''

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @rcup_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'ResolucionCupon','rcup_id',@rcup_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'ResolucionCupon','rcup_numero',@rcup_numero out, 0
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

              set @rcup_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into ResolucionCupon (
                              rcup_id,
                              rcup_numero,
                              rcup_nrodoc,
                              rcup_descrip,
                              rcup_fecha,
                              rcup_total,
                              rcup_grabarasiento,
                              est_id,
                              suc_id,
                              doc_id,
                              doct_id,
                              lgj_id,
                              modifico
                            )
      select
                              @rcup_id,
                              @rcup_numero,
                              @rcup_nrodoc,
                              rcup_descrip,
                              rcup_fecha,
                              rcup_total,
                              rcup_grabarasiento,
                              est_id,
                              suc_id,
                              doc_id,
                              @doct_id,
                              lgj_id,
                              modifico
      from ResolucionCuponTMP
      where rcupTMP_id = @@rcupTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @rcup_nrodoc = rcup_nrodoc from ResolucionCupon where rcup_id = @rcup_id
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
                              @rcup_id                   = rcup_id,
                              @rcup_nrodoc              = rcup_nrodoc,
                              @rcup_descrip              = rcup_descrip,
                              @rcup_grabarasiento       = rcup_grabarasiento,
                              @est_id                    = est_id,
                              @suc_id                    = suc_id,
                              @doc_id                    = doc_id,
                              @lgj_id                   = lgj_id,
                              @modifico                  =  modifico,
                              @modificado               = modificado
    from ResolucionCuponTMP 
    where 
          rcupTMP_id = @@rcupTMP_id
  
    update ResolucionCupon set 
                              rcup_nrodoc              = @rcup_nrodoc,
                              rcup_descrip            = @rcup_descrip,
                              rcup_fecha              = @rcup_fecha,
                              rcup_total              = @rcup_total,
                              rcup_grabarasiento      = @rcup_grabarasiento,
                              est_id                  =  @est_id,
                              suc_id                  = @suc_id,
                              doc_id                  = @doc_id,
                              doct_id                  = @doct_id,
                              lgj_id                  = @lgj_id,
                              modifico                = @modifico,
                              modificado              = @modificado
  
    where rcup_id = @rcup_id
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
  while exists(select rcupi_orden from ResolucionCuponItemTMP where rcupTMP_id = @@rcupTMP_id and rcupi_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @rcupi_id                      = rcupi_id,
            @rcupi_orden                  = rcupi_orden,
            @rcupi_descrip                = rcupi_descrip,
            @rcupi_cuota                  = rcupi_cuota,
            @rcupi_comision               = rcupi_comision,
            @rcupi_importe                = rcupi_importe,
            @rcupi_importeorigen          = rcupi_importeorigen,
            @tjcc_id                      = tjcc_id,
            @cue_id                       = cue_id,
            @rcupi_rechazado              = rcupi_rechazado

    from ResolucionCuponItemTMP where rcupTMP_id = @@rcupTMP_id and rcupi_orden = @orden

    if not exists (select * from ResolucionCuponItem where tjcc_id = @tjcc_id and rcup_id <> @rcup_id) begin

      if @IsNew <> 0 or @rcupi_id = 0 begin
  
          exec SP_DBGetNewId 'ResolucionCuponItem','rcupi_id',@rcupi_id out, 0
          if @@error <> 0 goto ControlError

          insert into ResolucionCuponItem (
                                        rcup_id,
                                        rcupi_id,
                                        rcupi_orden,
                                        rcupi_descrip,
                                        rcupi_cuota,
                                        rcupi_comision,
                                        rcupi_importe,
                                        rcupi_importeorigen,
                                        rcupi_rechazado,
                                        tjcc_id,
                                        cue_id
                                  )
                              Values(
                                        @rcup_id,
                                        @rcupi_id,
                                        @rcupi_orden,
                                        @rcupi_descrip,
                                        @rcupi_cuota,
                                        @rcupi_comision,
                                        @rcupi_importe,
                                        @rcupi_importeorigen,
                                        @rcupi_rechazado,
                                        @tjcc_id,
                                        @cue_id
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
  
            update ResolucionCuponItem set
  
                    rcup_id                      = @rcup_id,
                    rcupi_orden                  = @rcupi_orden,
                    rcupi_descrip                = @rcupi_descrip,
                    rcupi_cuota                 = @rcupi_cuota,
                    rcupi_comision              = @rcupi_comision,
                    rcupi_importe                = @rcupi_importe,
                    rcupi_importeorigen          = @rcupi_importeorigen,
                    rcupi_rechazado             = @rcupi_rechazado,
                    tjcc_id                      = @tjcc_id,
                    cue_id                      = @cue_id
  
          where rcup_id = @rcup_id and rcupi_id = @rcupi_id 
          if @@error <> 0 goto ControlError
      end -- Update

      select @conciliado = sum(rcupi_importe) from ResolucionCuponItem where tjcc_id = @tjcc_id

      update TarjetaCreditoCupon set cue_id = @cue_id,
                                     tjcc_pendiente = tjcc_importe - IsNull(@conciliado,0)  
      where tjcc_id = @tjcc_id
      if @@error <> 0 goto ControlError

    end

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar los items borrados de la resolucion de cupones
  if @IsNew = 0 begin
    
    delete ResolucionCuponItem 
            where exists (select *
                          from ResolucionCuponItemBorradoTMP rb inner join ResolucionCuponItemTMP r on rb.rcupi_id = r.rcupi_id
                          where rb.rcup_id    = @rcup_id 
                            and rb.rcupTMP_id  = @@rcupTMP_id
                            and rb.rcupi_id   = ResolucionCuponItem.rcupi_id
                            and not exists (select * from ResolucionCuponItem where tjcc_id = r.tjcc_id)
                          )
    if @@error <> 0 goto ControlError

    -- Actualizo todos los cupones
    update TarjetaCreditoCupon set cue_id = cbi.cue_id from CobranzaItem cbi
    where 
          TarjetaCreditoCupon.tjcc_id = cbi.tjcc_id
          and exists (select * 
                      from ResolucionCuponItemBorradoTMP rb inner join ResolucionCuponItemTMP r on rb.rcupi_id = r.rcupi_id
                      where rb.rcup_id     = @rcup_id 
                        and rb.rcupTMP_id  = @@rcupTMP_id
                        and tjcc_id       = TarjetaCreditoCupon.tjcc_id
                        and not exists (select * from ResolucionCuponItem where tjcc_id = r.tjcc_id)
                      )
    if @@error <> 0 goto ControlError

    delete ResolucionCuponItemBorradoTMP where rcup_id = @rcup_id and rcupTMP_id = @@rcupTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete ResolucionCuponItemTMP where rcupTMP_id = @@rcupTMP_id
  delete ResolucionCuponTMP where rcupTMP_id = @@rcupTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_TalonarioSet @ta_id,@rcup_nrodoc
  if @@error <> 0 goto ControlError

  exec sp_DocResolucionCuponSetEstado @rcup_id
  if @@error <> 0 goto ControlError

  declare @cfg_valor varchar(5000) 
  declare @bError    smallint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'ResolucionCupon-Grabar Asiento',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    select rcup_id=@rcup_id

    exec sp_DocResolucionCuponAsientoSave @rcup_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

  end else begin

    if not exists (select rcup_id from ResolucionCuponAsiento where rcup_id = @rcup_id) begin
      insert into ResolucionCuponAsiento (rcup_id,rcup_fecha) 
             select rcup_id,rcup_fecha from ResolucionCupon 
              where rcup_grabarAsiento <> 0 and rcup_id = @rcup_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from ResolucionCupon where rcup_id = @rcup_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 18009, @rcup_id, @modifico, 1
  else           exec sp_HistoriaUpdate 18009, @rcup_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@rcup_id = @rcup_id
  set @@bSuccess = 1

  if @@bSelect <> 0 select @rcup_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la resolucion de cupones. sp_DocResolucionCuponSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end