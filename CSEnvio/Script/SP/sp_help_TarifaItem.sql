if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_help_TarifaItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_help_TarifaItem]

go

/*

sp_help_TarifaItem 'Varig Log',-1,2,1,3
sp_help_TarifaItem 1,0,1,3

*/
create procedure sp_help_TarifaItem (
  @@filter           varchar(255) = '',
  @@check            smallint = 0,
  @@trfi_id          int,
  @@pue_id_origen    int,
  @@pue_id_destino   int
)
as
begin
  set nocount on

  if @@check <> 0 begin

    select   trfi_id,
            trans_nombre        as [Empresa]

    from TarifaItem inner join Tarifa     on TarifaItem.trf_id   = Tarifa.trf_id
                    inner join Transporte on Tarifa.trans_id     = Transporte.trans_id

    where trfi_id = @@trfi_id
      and pue_id_origen    = @@pue_id_origen 
      and pue_id_destino   = @@pue_id_destino
      and TarifaItem.activo <> 0

  end else begin

    select 
              trfi_id,
              trans_nombre        as [Empresa],
              trfi_minimo         as Minimo,
              trfi_menos45        as [-45],
              trfi_mas45          as [+45],
              trfi_mas100         as [+100],
              trfi_mas300         as [+300],
              trfi_mas500         as [+500],
              trfi_mas1000        as [+1000],
              case trfi_lunes     when 0 then 'no' else 'si' end as Lun,
              case trfi_martes    when 0 then 'no' else 'si' end as Mar,
              case trfi_miercoles when 0 then 'no' else 'si' end as Mie,
              case trfi_jueves    when 0 then 'no' else 'si' end as Jue,
              case trfi_viernes   when 0 then 'no' else 'si' end as Vie,
              case trfi_sabado    when 0 then 'no' else 'si' end as Sab,
              case trfi_domingo   when 0 then 'no' else 'si' end as Dom
  
    from TarifaItem inner join Tarifa     on TarifaItem.trf_id   = Tarifa.trf_id
                    inner join Transporte on Tarifa.trans_id     = Transporte.trans_id
  
    where pue_id_origen    = @@pue_id_origen 
      and pue_id_destino   = @@pue_id_destino
      and TarifaItem.activo <> 0
  end    
end

go