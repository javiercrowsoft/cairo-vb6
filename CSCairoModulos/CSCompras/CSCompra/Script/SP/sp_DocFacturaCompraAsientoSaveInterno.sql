if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraAsientoSaveInterno]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraAsientoSaveInterno]

/*

 select * from documentotipo
 select * from FacturaCompra where fc_numero = 14704

  sp_DocFacturaCompraAsientoSave 14704

 sp_DocFacturaCompraAsientoSaveInterno 93

*/

go
create procedure sp_DocFacturaCompraAsientoSaveInterno (
  @@fc_id             int,
  @@as_id             int,
  @@mon_id            int,
  @@doct_id_factura    int,
  @@ccos_id            int,
  @@desc1             decimal(18,6),
  @@desc2             decimal(18,6),
  @@bError            tinyint out,

  @@doc_esresumenbco  tinyint
)
as

begin

  set nocount on

  declare  @iva                     decimal(18, 6)
  declare @fci_importe             decimal(18, 6)
  declare @fci_importeorigen      decimal(18, 6)
  declare @cue_id                 int
  declare  @asi_debe               decimal(18, 6) 
  declare  @asi_haber               decimal(18, 6)
  declare  @asi_origen             decimal(18, 6)
  declare  @fci_neto               decimal(18, 6) 
  declare  @asi_orden               smallint 

  declare @asi_id          int
  declare @IsNew          smallint

  select @asi_orden = max(asi_orden) from AsientoItem where as_id = @@as_id

  -- Los resumenes bancarios no agrupan los renlgones por cuenta
  -- para ayudar a la conciliacion bancaria
  --
  if @@doc_esresumenbco <> 0 begin

    declare c_FacturaItemAsientoInternos cursor for 
  
      select fci_internos, fci_importe, fci_importeorigen, ti.cue_id
      from FacturaCompraItem fci inner join Producto p         on fci.pr_id          = p.pr_id
                                 inner join TasaImpositiva ti on p.ti_id_internosc  = ti.ti_id

      where fc_id = @@fc_id

  end else begin

    declare c_FacturaItemAsientoInternos cursor for 
  
      select sum(fci_internos), sum(fci_importe), sum(fci_importeorigen), ti.cue_id
      from FacturaCompraItem fci inner join Producto p         on fci.pr_id          = p.pr_id
                                 inner join TasaImpositiva ti on p.ti_id_internosc  = ti.ti_id

      where fc_id = @@fc_id
      group by    
              ti.cue_id having sum(fci_internos) <> 0
  end

  open c_FacturaItemAsientoInternos

  fetch next from c_FacturaItemAsientoInternos into
        @iva, @fci_importe, @fci_importeorigen, @cue_id

  while @@fetch_status = 0
  begin

    set @asi_id = null

    if @@doct_id_factura = 2 /* Factura */ or @@doct_id_factura = 10 /* Nota de Debito*/ begin
      set @asi_debe  = @iva
      set @asi_debe  = @asi_debe - (@asi_debe * @@desc1 /100)
      set @asi_debe  = @asi_debe - (@asi_debe * @@desc2 /100)
      set @asi_haber = 0

      select @asi_id = asi_id from AsientoItem 
      where as_id = @@as_id and cue_id = @cue_id and asi_haber = 0
            and IsNull(ccos_id,0) = IsNull(@@ccos_id,0)

    end else begin
      if @@doct_id_factura = 8 /* Nota de Credito */ begin
          set @asi_debe  = 0
          set @asi_haber = @iva
          set @asi_haber = @asi_haber - (@asi_haber * @@desc1 /100)
          set @asi_haber = @asi_haber - (@asi_haber * @@desc2 /100)
  
            select @asi_id = asi_id from AsientoItem 
            where as_id = @@as_id and cue_id = @cue_id and asi_debe = 0
                  and IsNull(ccos_id,0) = IsNull(@@ccos_id,0)
      end
    end

    if @fci_importeorigen <> 0 begin
          set @fci_importeorigen = @fci_importeorigen - (@fci_importeorigen * @@desc1 /100)
          set @fci_importeorigen = @fci_importeorigen - (@fci_importeorigen * @@desc2 /100)
          set @asi_origen = @iva /(@fci_importe / @fci_importeorigen)
    end
    else  set @asi_origen = 0

    set @asi_id = isnull(@asi_id,0)

    -- En los resumenes bancarios no juntamos los importes por cuenta
    -- para facilitar la conciliacion con el banco
    --
    if @@doc_esresumenbco <> 0 set @asi_id = 0

    if @asi_id = 0 begin

      exec SP_DBGetNewId 'AsientoItem','asi_id',@asi_id out, 0
  
      set @asi_orden = @asi_orden + 1
  
      insert into AsientoItem (
                                    as_id,
                                    asi_id,
                                    asi_orden,
                                    asi_descrip,
                                    asi_debe,
                                    asi_haber,
                                    asi_origen,
                                    cue_id,
                                    ccos_id,
                                    mon_id
                              )
                          Values(
                                    @@as_id,
                                    @asi_id,
                                    @asi_orden,
                                    '',
                                    @asi_debe,
                                    @asi_haber,
                                    @asi_origen,
                                    @cue_id,
                                    @@ccos_id,
                                    @@mon_id
                              )
  
      if @@error <> 0 goto ControlError

    end else begin 

      update AsientoItem set 
                            asi_debe     = asi_debe   + @asi_debe,
                            asi_haber    = asi_haber  + @asi_haber,
                            asi_origen  = asi_origen + @asi_origen
      where asi_id = @asi_id

    end

    fetch next from c_FacturaItemAsientoInternos into
          @iva, @fci_importe, @fci_importeorigen, @cue_id
  end

  close c_FacturaItemAsientoInternos
  deallocate c_FacturaItemAsientoInternos

  set @@bError = 0

  return
ControlError:

  set @@bError = 1

end

go