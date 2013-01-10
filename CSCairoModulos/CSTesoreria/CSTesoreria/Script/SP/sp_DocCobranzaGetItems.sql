if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaGetItems]

go

/*


exec sp_DocCobranzaGetItems 12,1
exec sp_DocCobranzaGetItems 12,2
exec sp_DocCobranzaGetItems 12,3
exec sp_DocCobranzaGetItems 12,4
exec sp_DocCobranzaGetItems 12,5

sp_columns cheque

*/
create procedure sp_DocCobranzaGetItems (
  @@cobz_id       int,
  @@tipo          tinyint
)
as

begin

declare @CobziTCheques      tinyint set @CobziTCheques  = 1
declare @CobziTEfectivo     tinyint set @CobziTEfectivo = 2
declare @CobziTTarjeta      tinyint set @CobziTTarjeta  = 3
declare @CobziTOtros        tinyint set @CobziTOtros    = 4
declare @CobziTCtaCte       tinyint set @CobziTCtaCte   = 5

  if @@tipo = @CobziTCheques begin

    select   CobranzaItem.*, 
            cheq_numero,
            cheq_propio,
            ccos_nombre,
            cue_nombre,
            bco_nombre,
            cle_nombre,
            cue_nombre,
            mon_nombre,
            mon.mon_id,
            cheq_numerodoc,
            bco.bco_id,
            cle.cle_id,
            cheq_fechavto,
            cheq_fechacobro
  
    from   CobranzaItem
          inner join cheque     as cheq     on CobranzaItem.cheq_id = cheq.cheq_id
          left join centrocosto as ccos     on CobranzaItem.ccos_id = ccos.ccos_id
          left join banco       as bco      on cheq.bco_id  = bco.bco_id
          left join clearing    as cle      on cheq.cle_id  = cle.cle_id
          left join cuenta      as cue      on CobranzaItem.cue_id  = cue.cue_id
          left join moneda      as mon      on cheq.mon_id  = mon.mon_id
    where 
        CobranzaItem.cobz_id     = @@cobz_id
    and cobzi_tipo              = @CobziTCheques
    order by cobzi_orden

  end else begin

    if @@tipo = @CobziTEfectivo begin
  
      select   CobranzaItem.*, 
              ccos_nombre,
              cue_nombre,
              mon_nombre,
              mon.mon_id
    
      from   CobranzaItem
            inner join cuenta      as cue      on CobranzaItem.cue_id  = cue.cue_id
            inner join moneda      as mon      on cue.mon_id  = mon.mon_id
            left join centrocosto as ccos     on CobranzaItem.ccos_id = ccos.ccos_id
      where 
          CobranzaItem.cobz_id     = @@cobz_id
      and cobzi_tipo              = @CobziTEfectivo
      order by cobzi_orden
  
    end else begin

      if @@tipo = @CobziTTarjeta begin
    
        select   CobranzaItem.*, 
                ccos_nombre,
                tjc_nombre,
                mon_nombre,
                tjcc_numero,
                tjcc_numerodoc,
                tjcc_descrip,
                tjcc_fechavto,
                tjcc_nroTarjeta,
                tjcc_nroAutorizacion,
                tjcc_titular,
                tjcc.tjc_id,
                tjccu.tjccu_id,
                tjccu.tjccu_cantidad,
                mon.mon_id,
                tjc.tjc_id
      
        from   CobranzaItem
              inner join tarjetacreditocupon   as tjcc  on CobranzaItem.tjcc_id  = tjcc.tjcc_id
              left join centrocosto            as ccos   on CobranzaItem.ccos_id  = ccos.ccos_id
              left join moneda                 as mon   on tjcc.mon_id           = mon.mon_id
              left join tarjetacredito         as tjc   on tjcc.tjc_id           = tjc.tjc_id
              left join tarjetacreditocuota    as tjccu on tjcc.tjccu_id         = tjccu.tjccu_id  
        where 
            CobranzaItem.cobz_id     = @@cobz_id
        and cobzi_tipo              = @CobziTTarjeta
        order by cobzi_orden
    
      end else begin
    
        if @@tipo = @CobziTOtros begin
      
          select   CobranzaItem.*, 
                  ccos_nombre,
                  cue_nombre,
                  ret_nombre,
                  fv_nrodoc
        
          from   CobranzaItem
                left join centrocosto  as ccos      on CobranzaItem.ccos_id     = ccos.ccos_id
                left join cuenta       as cue      on CobranzaItem.cue_id      = cue.cue_id
                left join retencion    as ret      on CobranzaItem.ret_id      = ret.ret_id
                left join facturaventa as fv       on CobranzaItem.fv_id_ret  = fv.fv_id
          where 
              CobranzaItem.cobz_id     = @@cobz_id
          and cobzi_tipo              = @CobziTOtros
          order by cobzi_orden
      
        end else begin
      
          if @@tipo = @CobziTCtaCte begin
        
            select   CobranzaItem.*, 
                    ccos_nombre,
                    cue_nombre
          
            from   CobranzaItem
                  left join centrocosto as ccos     on CobranzaItem.ccos_id = ccos.ccos_id
                  left join cuenta      as cue      on CobranzaItem.cue_id  = cue.cue_id
            where 
                CobranzaItem.cobz_id     = @@cobz_id
            and cobzi_tipo              = @CobziTCtaCte
            order by cobzi_orden
          end      
        end
      end
    end
  end
end

