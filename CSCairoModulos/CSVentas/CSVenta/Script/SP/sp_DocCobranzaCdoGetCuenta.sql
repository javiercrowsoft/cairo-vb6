if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaCdoGetCuenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaCdoGetCuenta]

go

/*

sp_DocCobranzaCdoGetCuenta  1,1,3

*/

create procedure sp_DocCobranzaCdoGetCuenta (
  @@cj_id   int,
  @@emp_id  int,
  @@tipo    tinyint
)
as

begin

  if @@tipo = 1 begin

    select   cue.cue_id,
            cue.cue_nombre,
            cue.mon_id,
            mon.mon_nombre
  
    from CajaCuenta cjc inner join Cuenta cue on cjc.cue_id_trabajo = cue.cue_id
                        inner join Moneda mon on cue.mon_id = mon.mon_id
    where cjc.cj_id = @@cj_id
      and cue.activo <> 0
      and (cuec_id = 14 or cuec_id = 2) 
      and (cue.emp_id = @@emp_id or emp_id is null)

  end else begin

    if @@tipo = 2 begin

      select   distinct 
              tjc.tjc_id,
              tjc.tjc_nombre,
              cue.mon_id,
              mon.mon_nombre
    
      from CajaCuenta cjc inner join Cuenta cue on cjc.cue_id_trabajo = cue.cue_id
                          inner join Moneda mon on cue.mon_id = mon.mon_id
                          inner join TarjetaCredito tjc on (
                                                          cjc.cue_id_trabajo = tjc.cue_id_encartera
                                                      or   cjc.cue_id_trabajo = tjc.cue_id_presentado
                                                    )
      where cjc.cj_id = @@cj_id
        and cue.activo <> 0
        and (cue.emp_id = @@emp_id or cue.emp_id is null)

    end else begin

      if @@tipo = 3 begin
  
        select   cue.cue_id,
                cue.cue_nombre,
                cue.mon_id,
                mon.mon_nombre
      
        from CajaCuenta cjc inner join Cuenta cue on cjc.cue_id_trabajo = cue.cue_id
                            inner join Moneda mon on cue.mon_id = mon.mon_id
        where cjc.cj_id = @@cj_id
          and cue.activo <> 0
          and (cuec_id = 1 or cuec_id = 2) 
          and (cue.emp_id = @@emp_id or emp_id is null)
          and not exists(select * from TarjetaCredito where cue_id_presentado = cue.cue_id 
                                                         or cue_id_encartera = cue.cue_id)
  
      end

    end

  end

end