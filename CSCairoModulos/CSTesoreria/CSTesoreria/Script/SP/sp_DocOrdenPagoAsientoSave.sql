if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoAsientoSave]

/*

  -- Tipos de items:
                      Cheques = 1
                      Efectivo = 2
                      Tarjeta = 3
                      Otros = 4
                      CtaCte = 5

  -- Tipos de otros en items:
                              Debe = 1
                              Haber = 2

 select * from OrdenPago
 sp_DocOrdenPagoAsientoSave 26

*/

go
create procedure sp_DocOrdenPagoAsientoSave (
  @@opg_id           int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0,
  @@fc_id           int          = null /* Me permite saber si la orden de pago se genero automaticamente
                                           La recibo como parametro ya que no puedo leerla del documento 
                                           cuando la OP es nueva ya que el campo se actualiza recien al 
                                           terminar de grabar el documento
                                        */
)
as

begin

  set nocount on

  declare @IsNew          smallint

  declare @as_id            int
  declare  @prov_id           int
  declare @doc_id_OrdenPago int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select opg_id from OrdenPago where opg_id = @@opg_id and est_id <> 7)
    return
  
  select 
          @as_id             = as_id, 
          @prov_id           = prov_id, 
          @doc_id_OrdenPago = doc_id

  from OrdenPago where opg_id = @@opg_id
  
  set @as_id = isnull(@as_id,0)

-- Campos de las tablas

declare  @as_numero   int 
declare  @as_nrodoc   varchar (50) 
declare  @as_descrip  varchar (5000)
declare  @as_fecha    datetime 
declare  @opg_fecha   datetime 

declare  @doc_id     int
declare @ta_id      int
declare  @doct_id    int

declare @ccos_id_cliente   int
declare  @ccos_id          int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @asi_orden               smallint 
declare  @asi_debe               decimal(18, 6) 
declare  @asi_haber               decimal(18, 6)
declare  @asi_origen             decimal(18, 6)
declare @mon_id                 int
declare @asi_descrip            varchar(5000)

declare  @opgi_orden            smallint 
declare @opgi_importe         decimal(18, 6)
declare @opgi_importeorigen    decimal(18, 6)

declare @cue_id                 int
declare @cheq_id                int
declare @doct_id_OrdenPago      int
declare @doc_id_cliente         int

declare @as_doc_cliente         varchar(5000)

declare @bError      tinyint

declare @bAgruparAsiento smallint

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'Asiento Agrupado',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  set @bAgruparAsiento = convert(smallint,@cfg_valor)

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Obtengo el documento @doc_id
  select 
         @doc_id                 = doc_id_asiento, 
         @doct_id_OrdenPago     = OrdenPago.doct_id, 
         @doc_id_cliente        = Documento.doc_id,
         @ccos_id_cliente       = ccos_id,
         @as_doc_cliente        = opg_nrodoc + ' ' + prov_nombre

  from OrdenPago     inner join Documento       on OrdenPago.doc_id  = Documento.doc_id
                    inner join Proveedor       on OrdenPago.prov_id = Proveedor.prov_id
  where opg_id = @@opg_id

  if @as_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'Asiento','as_id',@as_id out, 0
    exec SP_DBGetNewId 'Asiento','as_numero',@as_numero out, 0

    -- Obtengo el as_nrodoc
    declare @ta_ultimonro  int 
    declare @ta_mascara   varchar(50) 

    select @ta_ultimonro=ta_ultimonro, @ta_mascara=ta_mascara, @doct_id=doct_id
    from documento inner join talonario on documento.ta_id = talonario.ta_id 
    where doc_id = @doc_id

    set @ta_ultimonro = @ta_ultimonro + 1
    set @as_nrodoc = convert(varchar(50),@ta_ultimonro)
    set @as_nrodoc = substring(@ta_mascara,1,len(@ta_mascara) - len(@as_nrodoc)) + @as_nrodoc

    insert into Asiento (
                              as_id,
                              as_numero,
                              as_nrodoc,
                              as_descrip,
                              as_fecha,
                              as_doc_cliente,
                              doc_id,
                              doct_id,
                              doct_id_cliente,
                              doc_id_cliente,
                              id_cliente,
                              modifico
                            )
      select
                              @as_id,
                              @as_numero,
                              @as_nrodoc,
                              opg_descrip,
                              opg_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_OrdenPago,
                              @doc_id_cliente,
                              @@opg_id,
                              modifico
      from OrdenPago
      where opg_id = @@opg_id  

      if @@error <> 0 goto ControlError
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
                              @as_descrip              = opg_descrip,
                              @as_fecha                = opg_fecha,
                              @modifico                = modifico,
                              @modificado             = modificado
    from OrdenPago 
    where 
          opg_id = @@opg_id

    select 
                              @doc_id                  = doc_id,
                              @doct_id                = doct_id
    from Asiento
    where 
          as_id = @as_id

    update Asiento set 
                              as_descrip            = @as_descrip,
                              as_fecha              = @as_fecha,
                              as_doc_cliente        = @as_doc_cliente,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              doct_id_cliente        = @doct_id_OrdenPago,
                              doc_id_cliente        =  @doc_id_cliente,
                              id_cliente            = @@opg_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where as_id = @as_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
  delete AsientoItem where as_id = @as_id

  set @asi_orden = 1

  /*
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                                                                                                    //
  //                          GENERACION AUTOMATICA DE ORDEN DE PAGO                                                    //
  //                                                                                                                    //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  */
  declare @fc_id int

  /*
    Si me llaman sobre una OP que se esta generando, el parametro @@fc_id contiene la
    factura de compra para OPs automaticas, y me lo pasa sp_DocOrdenPagoSave.

    Cuando el que llama es sp_DocOrdenPagoAsiento[s]Save, no recibo el fc_id, asi que
    lo leo de la OP.
  */

  if @@fc_id is not null 
    set @fc_id = @@fc_id
  else
    select @fc_id = fc_id from OrdenPago where opg_id = @@opg_id

  if @fc_id is not null begin

    /* Cuando es un resumen bancario genero un item por cada concepto de la factura
       contra la cuenta de fondos para que la conciliacion bancaria sea mas facil,
       ya que el resumen del banco viene con los importes discriminados.
       Por ejemplo cuando el banco cobra un gasto, y este lleva iva, en el resumen
       figuran dos renglones uno por el gasto y otro por el iva sobre dicho gasto.
    */

    declare @as_id_factura     int
    declare @doct_id_factura  int
    declare @cuec_id          int

    -- Solo puede haber una cuenta
    -- pero por las dudas uso el min
    --
    select @cuec_id = min(cue.cuec_id) 
    from OrdenPagoItem opgi inner join Cuenta cue on opgi.cue_id = cue.cue_id
    where opgi.opg_id = @@opg_id
      and opgi_tipo = 2 -- Efectivo

    -- Necesito saber si es una nota de credito
    --
    select @doct_id_factura    = doct_id
    from FacturaCompra where fc_id = @fc_id

    -- Solo necesito el detalle de los pagos
    -- si la cuenta es de tipo banco
    --
    if @cuec_id = 2 /*Bancos*/begin 

      select @as_id_factura = as_id
      from FacturaCompra where fc_id = @fc_id

    end

    /* Las ordenes de pago automaticas solo tienen efectivo */

    if @as_id_factura is null begin

      if @bAgruparAsiento = 0 begin

        -- Efectivo
        declare c_OrdenPagoItemAsiento cursor for 
      
          select   opgi_importe, 
                  opgi_importeorigen, 
                  cue_id,  
                  ccos_id,
                  opgi.cheq_id,
                  opgi.opgi_descrip
      
          from OrdenPagoItem opgi
      
          where opgi.opg_id = @@opg_id 
            and opgi_tipo = 2 -- Efectivo

      end else begin 

        -- Efectivo
        declare c_OrdenPagoItemAsiento cursor for 

          select   sum(opgi_importe), 
                  sum(opgi_importeorigen), 
                  cue_id,  
                  ccos_id,
                  opgi.cheq_id,
                  '' as opgi_descrip
      
          from OrdenPagoItem opgi
      
          where opgi.opg_id = @@opg_id 
            and opgi_tipo = 2 -- Efectivo

          group by
                  cue_id,  
                  ccos_id,
                  opgi.cheq_id

      end

    end else begin

      declare @as_total decimal(18,6)

      select @as_total = sum(asi_debe) from asientoitem where as_id = @as_id_factura

      if @bAgruparAsiento = 0 begin    
  
        -- Efectivo
        declare c_OrdenPagoItemAsiento cursor for 
  
          /* Cuando es un resumen bancario genero un item por cada concepto de la factura
             contra la cuenta de fondos para que la conciliacion bancaria sea mas facil,
             ya que el resumen del banco viene con los importes discriminados.
             Por ejemplo cuando el banco cobra un gasto, y este lleva iva, en el resumen
             figuran dos renglones uno por el gasto y otro por el iva sobre dicho gasto.
          */
          select   opgi.opgi_importe       * ((asi_debe+asi_haber)/ @as_total), 
                  opgi.opgi_importeorigen * ((asi_debe+asi_haber)/ @as_total), 
                  opgi.cue_id,  
                  opgi.ccos_id,
                  opgi.cheq_id,
                  cue_nombre
      
          from OrdenPagoItem opgi, AsientoItem asi inner join Cuenta cue on asi.cue_id = cue.cue_id
      
          where opgi.opg_id   = @@opg_id 
            and opgi_tipo     = 2 -- Efectivo
            and asi.as_id     = @as_id_factura
            and asi.asi_tipo  <> 2 -- cuenta del acreedor
            and (
                      (asi_debe  <> 0 and @doct_id_factura in (2,10)) -- Facturas y Notas de debito
                  or  (asi_haber <> 0 and @doct_id_factura = 8)       -- Nota de credito
                )

      end else begin

        -- Efectivo
        declare c_OrdenPagoItemAsiento cursor for 
  
          select   sum(opgi.opgi_importe), 
                  sum(opgi.opgi_importeorigen), 
                  opgi.cue_id,  
                  opgi.ccos_id,
                  opgi.cheq_id,
                  '' as cue_nombre
      
          from OrdenPagoItem opgi
      
          where opgi.opg_id   = @@opg_id 
            and opgi_tipo     = 2 -- Efectivo

          group by
                  opgi.cue_id,  
                  opgi.ccos_id,
                  opgi.cheq_id

      end

    end

  end else begin

    -- Efectivo y Otros
    declare c_OrdenPagoItemAsiento cursor for 
  
      select   opgi_importe, 
              opgi_importeorigen, 
              cue_id,  
              ccos_id,
              opgi.cheq_id,
              opgi.opgi_descrip
  
      from OrdenPagoItem opgi 
  
      where opgi.opg_id = @@opg_id 
        and (      opgi_tipo = 2 -- Efectivo
              or  (
                        opgi_tipo = 4 -- Otros 
                    and opgi_otroTipo = 2 -- Haber
                  )
            )
  
    union all
  
      -- Cheques propios
      select   opgi_importe, 
              opgi_importeorigen, 
              Chequera.cue_id,  
              ccos_id,
              opgi.cheq_id,
              opgi.opgi_descrip
  
      from OrdenPagoItem opgi inner join Cheque   on opgi.cheq_id = Cheque.cheq_id
                              inner join Chequera on Cheque.chq_id = Chequera.chq_id
  
      where opgi.opg_id = @@opg_id 
        and opgi_tipo = 1 -- Cheques 
            
    union all
  
      -- Cheques de terceros
      select   opgi_importe, 
              opgi_importeorigen, 
              cobzi.cue_id,  
              opgi.ccos_id,
              opgi.cheq_id,
              opgi.opgi_descrip
  
      from OrdenPagoItem opgi inner join Cheque cheq        on opgi.cheq_id = cheq.cheq_id
                              inner join CobranzaItem cobzi  on opgi.cheq_id = cobzi.cheq_id
  
      where opgi.opg_id = @@opg_id 
        and opgi_tipo = 6 -- Cheques 
        
        -- No tiene que haber sido utilizado por un movimiento de fondos
        and cheq.mf_id is null
  
    union all
  
      -- Cheques de terceros
      select   opgi_importe, 
              opgi_importeorigen, 
              mfi.cue_id_debe,  
              opgi.ccos_id,
              opgi.cheq_id,
              opgi.opgi_descrip
  
      from OrdenPagoItem opgi inner join Cheque cheq              on   opgi.cheq_id = cheq.cheq_id
                              inner join MovimientoFondoItem mfi  on   opgi.cheq_id = mfi.cheq_id
                                                                  and cheq.mf_id    = mfi.mf_id
  
      where opgi.opg_id = @@opg_id 
        and opgi_tipo = 6 -- Cheques 

      --//////////////////////////////////
  end -- FIN Orden de Pago Automatica


  open c_OrdenPagoItemAsiento

  fetch next from c_OrdenPagoItemAsiento into @opgi_importe, @opgi_importeorigen, @cue_id, @ccos_id, @cheq_id, @asi_descrip
  while @@fetch_status = 0 
  begin

    select @mon_id = mon_id from cuenta where cue_id = @cue_id

    set @asi_haber   = @opgi_importe
    set @asi_origen = @opgi_importeorigen 

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            0,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            @cheq_id,

                                            @bError out,

                                            @asi_descrip
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_OrdenPagoItemAsiento into @opgi_importe, @opgi_importeorigen, @cue_id, @ccos_id, @cheq_id, @asi_descrip
  end -- While

  close c_OrdenPagoItemAsiento
  deallocate c_OrdenPagoItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        Hora la cuenta del Proveedor                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare c_OrdenPagoItemAsiento cursor for 

    select   sum(opgi_importe), 
            sum(opgi_importeorigen), 
            cue_id,
            ccos_id
    from OrdenPagoItem 

    where opg_id = @@opg_id 
      and (      opgi_tipo = 5 -- CtaCte 
            or  (
                      opgi_tipo = 4 -- Otros 
                  and opgi_otroTipo = 1 -- Debe
                )
          )
    group by    
            cue_id, ccos_id 

  open c_OrdenPagoItemAsiento

  fetch next from c_OrdenPagoItemAsiento into @opgi_importe, @opgi_importeorigen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    select @mon_id = mon_id from cuenta where cue_id = @cue_id

    set @asi_debe   = @opgi_importe
    set @asi_origen = @opgi_importeorigen 

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            0,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_OrdenPagoItemAsiento into @opgi_importe, @opgi_importeorigen, @cue_id, @ccos_id
  end -- While

  close c_OrdenPagoItemAsiento
  deallocate c_OrdenPagoItemAsiento

  -- Si fue una nota de credito invierto el asiento
  --
  if @fc_id is not null begin

    if @doct_id_factura = 8 begin

      declare @asi_id int

      declare c_items insensitive cursor for  
        select asi_id, asi_debe, asi_haber 
        from AsientoItem where as_id = @as_id
  
      open c_items

      fetch next from c_items into @asi_id, @asi_debe, @asi_haber
      while @@fetch_status = 0
      begin

        if @asi_debe <> 0 begin

          update AsientoItem set asi_haber = @asi_debe, asi_debe = 0 where asi_id = @asi_id

        end else begin

          update AsientoItem set asi_debe = @asi_haber, asi_haber = 0 where asi_id = @asi_id

        end

        fetch next from c_items into @asi_id, @asi_debe, @asi_haber
      end
      close c_items
      deallocate c_items

    end
  end
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Valido el Asiento                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocAsientoValidate @as_id, @bError out, @@MsgError out
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Talonario                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@as_nrodoc

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo la OrdenPago con su asiento                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  update OrdenPago set as_id = @as_id, opg_grabarasiento = 0 where opg_id = @@opg_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la Orden de Pago. sp_DocOrdenPagoAsientoSave.'

  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end