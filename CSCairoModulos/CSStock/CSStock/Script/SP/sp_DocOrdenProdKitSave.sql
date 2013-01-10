if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenProdKitSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenProdKitSave]

/*

 sp_DocOrdenProdKitSave 93

*/

go
create procedure sp_DocOrdenProdKitSave (
  @@opkTMP_id int
)
as

begin

  set nocount on

  declare @opk_id          int
  declare @opki_id        int
  declare  @doct_id        int
  declare @IsNew          smallint
  declare @orden          smallint
  declare @bSuccess       tinyint
  declare @MsgError        varchar(5000) set @MsgError = ''

  -- Si no existe chau
  if not exists (select opkTMP_id from OrdenProdKitTMP where opkTMP_id = @@opkTMP_id)
    return

-- Talonario
  declare  @opk_nrodoc    varchar (50) 
  declare  @doc_id       int
  
  select @opk_id   = opk_id, 
         @doct_id = doct_id, 

-- Talonario
         @opk_nrodoc = opk_nrodoc,
         @doc_id     = doc_id

  from OrdenProdKitTMP where opkTMP_id = @@opkTMP_id
  
  set @opk_id = isnull(@opk_id,0)
  
-- Campos de las tablas

declare  @opk_numero  int 
declare  @opk_descrip varchar (5000)
declare  @opk_fecha   datetime 

declare  @suc_id     int
declare @ta_id      int
declare @lgj_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare @opkiTMP_id             int
declare  @opki_orden             smallint 
declare  @opki_cantidad           decimal(18, 6) 
declare  @opki_descrip           varchar (5000) 
declare  @pr_id                   int
declare @depl_id                int
declare @prfk_id                int

  begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @opk_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'OrdenProdKit','opk_id',@opk_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'OrdenProdKit','opk_numero',@opk_numero out, 0
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

              set @opk_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into OrdenProdKit (
                              opk_id,
                              opk_numero,
                              opk_nrodoc,
                              opk_descrip,
                              opk_fecha,
                              suc_id,
                              lgj_id,
                              doc_id,
                              doct_id,
                              depl_id,
                              modifico
                            )
      select
                              @opk_id,
                              @opk_numero,
                              @opk_nrodoc,
                              opk_descrip,
                              opk_fecha,
                              suc_id,
                              lgj_id,
                              doc_id,
                              doct_id,
                              depl_id,
                              modifico
      from OrdenProdKitTMP
      where opkTMP_id = @@opkTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @opk_nrodoc = opk_nrodoc from OrdenProdKit where opk_id = @opk_id
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
                              @opk_id                 = opk_id,
                              @opk_nrodoc              = opk_nrodoc,
                              @opk_descrip            = opk_descrip,
                              @opk_fecha              = opk_fecha,
                              @suc_id                  = suc_id,
                              @lgj_id                  = lgj_id,
                              @doc_id                  = doc_id,
                              @doct_id                = doct_id,
                              @depl_id                = depl_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from OrdenProdKitTMP 
    where 
          opkTMP_id = @@opkTMP_id
  
    update OrdenProdKit set 
                              opk_nrodoc            = @opk_nrodoc,
                              opk_descrip            = @opk_descrip,
                              opk_fecha              = @opk_fecha,
                              suc_id                = @suc_id,
                              lgj_id                = lgj_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              depl_id                = @depl_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where opk_id = @opk_id
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
  while exists(select opki_orden from OrdenProdKitItemTMP where opkTMP_id = @@opkTMP_id and opki_orden = @orden) 
  begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @opki_id                    = opki_id,
            @opki_orden                  = opki_orden,
            @opki_cantidad              = opki_cantidad,
            @opki_descrip                = opki_descrip,
            @pr_id                      = pr_id,
            @depl_id                    = depl_id,
            @prfk_id                    = prfk_id,
            @opkiTMP_id                 = opkiTMP_id

    from OrdenProdKitItemTMP where opkTMP_id = @@opkTMP_id and opki_orden = @orden

    if @IsNew <> 0 or @opki_id = 0 begin

        exec SP_DBGetNewId 'OrdenProdKitItem','opki_id',@opki_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into OrdenProdKitItem (
                                      opk_id,
                                      opki_id,
                                      opki_orden,
                                      opki_cantidad,
                                      opki_descrip,
                                      pr_id,
                                      prfk_id
                                )
                            Values(
                                      @opk_id,
                                      @opki_id,
                                      @opki_orden,
                                      @opki_cantidad,
                                      @opki_descrip,
                                      @pr_id,
                                      @prfk_id
                                )

        if @@error <> 0 goto ControlError

        update OrdenProdKitItemTMP set opki_id = @opki_id where opkiTMP_id = @opkiTMP_id

    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          update OrdenProdKitItem set

                  opk_id                    = @opk_id,
                  opki_orden                = @opki_orden,
                  opki_cantidad              = @opki_cantidad,
                  opki_descrip              = @opki_descrip,
                  pr_id                      = @pr_id,
                  prfk_id                   = @prfk_id

        where opk_id = @opk_id and opki_id = @opki_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     DELETE                                                                         //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin

    delete OrdenProdKitItem 
            where exists (select opki_id 
                          from OrdenProdKitItemBorradoTMP 
                          where opk_id     = @opk_id 
                            and opkTMP_id = @@opkTMP_id
                            and opki_id   = OrdenProdKitItem.opki_id
                          )
    if @@error <> 0 goto ControlError

    delete OrdenProdKitItemBorradoTMP where opk_id = @opk_id and opkTMP_id = @@opkTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  declare @bError          smallint

  select 
          @ta_id             = ta_id,
          @depl_id          = OrdenProdKitTMP.depl_id

  from OrdenProdKitTMP inner join documento on OrdenProdKitTMP.doc_id = documento.doc_id
  where opkTMP_id = @@opkTMP_id

  exec sp_TalonarioSet @ta_id, @opk_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete OrdenProdKitItemTMP where opkTMP_id = @@opkTMP_id
  delete OrdenProdKitTMP where opkTMP_id = @@opkTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from OrdenProdKit where opk_id = @opk_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 20025, @opk_id, @modifico, 1
  else           exec sp_HistoriaUpdate 20025, @opk_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  select @opk_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la Orden de Producción de kit. sp_DocOrdenProdKitSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  goto Roll

Validate:

  raiserror (@MsgError, 16, 1)

Roll:

  if @@trancount > 0 begin
    rollback transaction  
  end

end