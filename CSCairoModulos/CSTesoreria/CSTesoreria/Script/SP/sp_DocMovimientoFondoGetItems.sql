if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoGetItems]

go

/*

sp_DocMovimientoFondoGetItems 1

*/
create procedure sp_DocMovimientoFondoGetItems (
  @@mf_id     int,
  @@tipo      tinyint
)
as

begin

  declare @MfiTCheques      tinyint set @MfiTCheques  = 1
  declare @MfiTEfectivo     tinyint set @MfiTEfectivo = 2
  declare @MfiTChequesT     tinyint set @MfiTChequesT = 6
  declare @MfiTChequesI     tinyint set @MfiTChequesI = 7

  if @@tipo = @MfiTEfectivo begin
  
    select   MovimientoFondoItem.*, 
            cdebe.cue_nombre       as [Debe],
            chaber.cue_nombre      as [Haber],
            ccos_nombre
  
    from   MovimientoFondoItem
          inner join Cuenta cdebe            on MovimientoFondoItem.cue_id_debe  = cdebe.cue_id
          inner join Cuenta chaber          on MovimientoFondoItem.cue_id_haber = chaber.cue_id
          left join centrocosto as ccos     on MovimientoFondoItem.ccos_id      = ccos.ccos_id
    where 
            mf_id    = @@mf_id
        and mfi_tipo = @MfiTEfectivo
  
    order by mfi_orden
  
  end else begin
    
    if @@tipo = @mfiTCheques begin
    
      select   MovimientoFondoItem.*, 
              cdebe.cue_nombre       as [Debe],
              chaber.cue_nombre      as [Haber],
              chq_codigo,
              cheq_numero,
              ccos_nombre,
              bco_nombre,
              cle_nombre,
              mon_nombre,
              mon.mon_id,
              cheq_numerodoc,
              bco.bco_id,
              cle.cle_id,
              cheq_fechavto,
              cheq_fechacobro
    
      from   MovimientoFondoItem
            inner join cheque     as cheq     on MovimientoFondoItem.cheq_id = cheq.cheq_id

            inner join Cuenta cdebe            on MovimientoFondoItem.cue_id_debe  = cdebe.cue_id
            inner join Cuenta chaber          on MovimientoFondoItem.cue_id_haber = chaber.cue_id
    
            -- Este Inner join filtra a los cheques de tercero ya que estos no tienen
            -- chequera
            --
            inner join chequera   as chq      on MovimientoFondoItem.chq_id  = chq.chq_id   
    
            left join centrocosto as ccos     on MovimientoFondoItem.ccos_id      = ccos.ccos_id
            left join banco       as bco      on cheq.bco_id                      = bco.bco_id
            left join clearing    as cle      on cheq.cle_id                      = cle.cle_id
            left join moneda      as mon      on cheq.mon_id                      = mon.mon_id
      where 
          MovimientoFondoItem.mf_id = @@mf_id
      and mfi_tipo                  = @mfiTCheques
      order by mfi_orden
      
    end else begin
      
      if @@tipo = @mfiTChequesT begin
    
        select   MovimientoFondoItem.*, 
                cdebe.cue_nombre       as [Debe],
                chaber.cue_nombre      as [Haber],
                cheq_numero,
                ccos_nombre,
                bco_nombre,
                cle_nombre,
                cli_nombre,
                mon_nombre,
                mon.mon_id,
                cheq_numerodoc,
                cheq_fechavto,
                cheq_fechacobro
      
        from   MovimientoFondoItem
              inner join cheque     as cheq     on MovimientoFondoItem.cheq_id = cheq.cheq_id

              inner join Cuenta cdebe            on MovimientoFondoItem.cue_id_debe  = cdebe.cue_id
              inner join Cuenta chaber          on MovimientoFondoItem.cue_id_haber = chaber.cue_id
    
              left join cliente     as cli      on cheq.cli_id  = cli.cli_id   
              
              left join centrocosto as ccos     on MovimientoFondoItem.ccos_id      = ccos.ccos_id
              left join banco       as bco      on cheq.bco_id                      = bco.bco_id
              left join clearing    as cle      on cheq.cle_id                      = cle.cle_id
              left join moneda      as mon      on cheq.mon_id                      = mon.mon_id
        where 
            MovimientoFondoItem.mf_id = @@mf_id
        and mfi_tipo                  = @mfiTChequesT
        order by mfi_orden

      end else begin

        if @@tipo = @mfiTChequesI begin
      
          select   MovimientoFondoItem.*, 
                  cdebe.cue_nombre       as [Debe],
                  chaber.cue_nombre      as [Haber],
                  cheq_numero,
                  ccos_nombre,
                  cheq.bco_id,
                  bco_nombre,
                  cheq.cle_id,
                  cle_nombre,
                  mon_nombre,
                  mon.mon_id,
                  cheq_numerodoc,
                  cheq_fechavto,
                  cheq_fechacobro
        
          from   MovimientoFondoItem
                inner join cheque     as cheq     on MovimientoFondoItem.cheq_id = cheq.cheq_id
  
                inner join Cuenta cdebe            on MovimientoFondoItem.cue_id_debe  = cdebe.cue_id
                inner join Cuenta chaber          on MovimientoFondoItem.cue_id_haber = chaber.cue_id
      
                left join centrocosto as ccos     on MovimientoFondoItem.ccos_id      = ccos.ccos_id
                left join banco       as bco      on cheq.bco_id                      = bco.bco_id
                left join clearing    as cle      on cheq.cle_id                      = cle.cle_id
                left join moneda      as mon      on cheq.mon_id                      = mon.mon_id
          where 
              MovimientoFondoItem.mf_id = @@mf_id
          and mfi_tipo                  = @mfiTChequesI
          order by mfi_orden

        end
      end
    end
  end
end