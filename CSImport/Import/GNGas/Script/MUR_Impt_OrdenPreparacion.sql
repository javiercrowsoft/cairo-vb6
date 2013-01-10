if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_Impt_OrdenPreparacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_Impt_OrdenPreparacion]

/*

 MUR_Impt_OrdenPreparacion 94799

*/

go
create procedure MUR_Impt_OrdenPreparacion (
  @@mfc_id int
)
as

begin

set nocount on

declare @mfcTMP_id     int
declare @mfciTMP_id    int
declare @mfc_id        int
declare @mfci_id       int
declare  @mfc_numero    int 
declare  @mfc_nrodoc    varchar (50) 
declare  @mfc_descrip   varchar (5000)
declare  @mfc_fecha         datetime 
declare  @mfc_fechadoc      datetime 
declare @mfc_horapartida  datetime
declare  @mfc_pendiente decimal(18, 6)
declare @mfc_cantidad  decimal(18,6)
declare @mfci_orden    int

declare @MUR_Partida    varchar(255)
declare @MUR_NroPedido  varchar(255)

declare @MUR_mfc_id   int
declare @MUR_mfci_id   int

declare @pr_codigo      varchar(255)
declare @pr_id          int
declare @mfci_cantidad   decimal(18, 6)
declare @mfci_pendiente  decimal(18, 6)

declare  @est_id     int
declare  @suc_id     int
declare  @cli_id     int
declare  @doc_id     int
declare @ta_id      int
declare  @doct_id    int
declare  @trans_id   int 
declare  @chof_id    int 
declare  @cmarc_id   int
declare  @ccos_id    int
declare  @pue_id_origen            int
declare  @pue_id_destino            int
declare  @depl_id_origen            int
declare  @depl_id_destino          int
declare  @barc_id                  int


  declare c_MUR_OrdenPrep insensitive cursor for 
      select mfc_id, cli_id, mfc_fecha, mfc_horapartida, mfc_numero, mfc_nrodoc, MUR_NroPedido
      from MUR_OrdenPreparacion where mfc_id = @@mfc_id

  open c_MUR_OrdenPrep

  fetch next from c_MUR_OrdenPrep into @MUR_mfc_id, @cli_id, @mfc_fecha, @mfc_horapartida, @mfc_numero, @mfc_nrodoc,
                                       @MUR_NroPedido
  while @@fetch_status = 0 begin

    --///////////////////////////////////////////////////////////////////////////////////////////
    -- Header
    --///////////////////////////////////////////////////////////////////////////////////////////

    select @mfc_id = mfc_id from ManifiestoCarga where MUR_OrdenPreparacion = @MUR_mfc_id
    set @mfc_id = IsNull(@mfc_id,0) 

    select @cli_id = cli_id from Cliente where cli_codigo = convert(varchar(50),@cli_id)

    exec SP_DBGetNewId 'ManifiestoCargaTMP','mfcTMP_id',@mfcTMP_id out,0

    select @mfc_cantidad = sum(mfci_cantidad) from MUR_OrdenPreparacionItem where mfc_id = @MUR_mfc_id
    set @mfc_cantidad = IsNull(@mfc_cantidad,0)

    insert into ManifiestoCargaTMP (
                                    mfcTMP_id,
                                    mfc_id,
                                    mfc_numero,
                                    mfc_nrodoc,
                                    mfc_fecha,
                                    mfc_fechadoc,
                                    mfc_horapartida,
                                    mfc_pendiente,
                                    mfc_chasis,
                                    mfc_acoplado,
                                    mfc_descrip,
                                    mfc_firmado,
                                    mfc_cantidad,
                                    MUR_NroPedido,
                                    est_id,
                                    suc_id,
                                    doc_id,
                                    doct_id,
                                    cli_id,
                                    ccos_id,
                                    cmarc_id,
                                    pue_id_origen,
                                    pue_id_destino,
                                    depl_id_origen,
                                    depl_id_destino,
                                    barc_id,
                                    trans_id,
                                    chof_id,
                                    MUR_OrdenPreparacion,
                                    creado,
                                    modificado,
                                    modifico
                                    )
                          values(
                                    @mfcTMP_id,
                                    @mfc_id,
                                    @mfc_numero,
                                    @mfc_nrodoc,
                                    @mfc_fecha,
                                    @mfc_fecha, -- mfc_fechadoc,
                                    @mfc_horapartida,
                                    0,  -- mfc_pendiente,
                                    '', -- mfc_chasis,
                                    '', -- mfc_acoplado,
                                    '', -- mfc_descrip,
                                    0,  -- mfc_firmado,
                                    @mfc_cantidad,
                                    @MUR_NroPedido,
                                    1,  -- est_id, 1 pendiente
                                    1,  -- suc_id, 1 Casa Central
                                    24, -- doc_id, 24  Manifiesto Carga
                                    20, -- doct_id, 20  Manifiesto Carga
                                    @cli_id,
                                    null, -- ccos_id,
                                    null, -- cmarc_id,
                                    null, -- pue_id_origen,
                                    null, -- pue_id_destino,
                                    null, -- depl_id_origen,
                                    null, -- depl_id_destino,
                                    null, -- barc_id,
                                    null, -- trans_id
                                    null, -- chof_id
                                    @MUR_mfc_id,
                                    getdate(),
                                    getdate(),
                                    1 -- Supervisor
                                  )


    --///////////////////////////////////////////////////////////////////////////////////////////
    -- Items
    --///////////////////////////////////////////////////////////////////////////////////////////
    declare c_MUR_OrdenPrepItem insensitive cursor for
      select mfci_id, mfci_cantidad, pr_id, MUR_Partida
      from MUR_OrdenPreparacionItem where mfc_id = @MUR_mfc_id

    set @mfci_orden = 0

    open c_MUR_OrdenPrepItem
    
    fetch next from c_MUR_OrdenPrepItem into @MUR_mfci_id, @mfci_cantidad, @pr_codigo, @MUR_Partida
    while @@fetch_status = 0 begin

      set @mfci_orden = @mfci_orden + 1

      select @mfci_id = mfci_id from ManifiestoCargaItem where mfc_id = @mfc_id and MUR_OrdenPreparacionItem = @MUR_mfci_id
      select @pr_id = pr_id from Producto where pr_codigo = @pr_codigo

      set @mfci_id = IsNull(@mfci_id,0) 
      if  @mfci_id <> 0 begin
        select @mfci_pendiente = sum(mfcpklst_cantidad) from ManifiestoCargaPackingList where mfci_id = @mfci_id
        set @mfci_pendiente = @mfci_cantidad - IsNull(@mfci_pendiente,0)
      end 
      else set @mfci_pendiente = @mfci_cantidad

      exec SP_DBGetNewId 'ManifiestoCargaItemTMP','mfciTMP_id',@mfciTMP_id out,0

      insert into ManifiestoCargaItemTMP(
                                          mfcTMP_id,
                                          mfciTMP_id,
                                          mfci_id,
                                          mfci_orden,
                                          mfci_cantidad,
                                          mfci_pendiente,
                                          mfci_pallets,
                                          mfci_nropallet,
                                          mfci_descrip,
                                          pr_id,
                                          ccos_id,
                                          MUR_OrdenPreparacionItem,
                                          MUR_Partida
                                        )
                                values  (
                                          @mfcTMP_id,
                                          @mfciTMP_id,
                                          @mfci_id,
                                          @mfci_orden,
                                          @mfci_cantidad,
                                          @mfci_pendiente,
                                          0,  -- @mfci_pallets,
                                          '', -- @mfci_nropallet,
                                          '', -- @mfci_descrip,
                                          @pr_id,
                                          null, -- @ccos_id,
                                          @MUR_mfci_id,
                                          @MUR_Partida
                                        )

      fetch next from c_MUR_OrdenPrepItem into @MUR_mfci_id, @mfci_cantidad, @pr_codigo, @MUR_Partida
    end

    close c_MUR_OrdenPrepItem
    deallocate c_MUR_OrdenPrepItem


    --exec sp_DocManifiestoCargaSave @mfcTMP_id
    --if @@error <> 0 goto ControlError

    fetch next from c_MUR_OrdenPrep into @MUR_mfc_id, @cli_id, @mfc_fecha, @mfc_horapartida, @mfc_numero, @mfc_nrodoc,
                                         @MUR_NroPedido
  end
  close c_MUR_OrdenPrep
  deallocate c_MUR_OrdenPrep

  delete MUR_OrdenPreparacion where mfc_id = @MUR_mfc_id
  delete MUR_OrdenPreparacionItem where mfc_id = @MUR_mfc_id

  select @mfcTMP_id as mfcTMP_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar las ordenes de preparación. MUR_Impt_OrdenPreparacion.', 16, 1)

end
go