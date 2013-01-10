if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionLabSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionLabSave]

/*

insert into aaba_inscripcionMail (aabainscm_id,aabainscm_nombre,aabainscm_fecha,modifico,aabainscm_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into aaba_inscripcionMailinscripcion values(4,1,18) 
select * from condicionpago

sp_web_InscripcionLabSave 13

sp_col inscripcion

*/

go
create procedure sp_web_InscripcionLabSave (
  @@fecha         datetime,
  @@aabalab_id     int,
  @@desde         varchar(30),
  @@hasta         varchar(30),
  @@est_id        int,
  @@us_id         int
)
as

begin

  declare @n         int
  declare @desde     int
  declare @hasta     int
  declare @insc_id  int

  if isnumeric(@@desde)<> 0 set @desde = convert(int,@@desde)
  else return
  if isnumeric(@@hasta)<> 0 set @hasta = convert(int,@@hasta)
  else return

  if @desde <= 0         return
  if @desde >  @hasta   return

  set nocount on

  set @n = @desde

  while @n <= @hasta begin

    if not exists(select * from aaarbaweb..Inscripcion where insc_numero = convert(varchar,@n)) 
    begin

      exec SP_DBGetNewId 'aaarbaweb..Inscripcion', 'insc_id', @insc_id out, 0
      insert into aaarbaweb..Inscripcion (
                                insc_id,
                                insc_fecha,
                                insc_apellido,
                                insc_nombre,
                                insc_numero,
                                insc_socio,
                                insc_email,
                                insc_categoria,
                                aabalab_id,
                                cong_id,
                                est_id,
                                cpg_id,
                                pa_id,
                                catf_id,
                                insc_importe,
                                insc_tipodocumento,
                                insc_direccion,
                                insc_codPostal,
                                insc_localidad,
                                modifico
                              )
                      values  (
                                @insc_id,
                                @@fecha,
                                'ha informar por el laboratorio',
                                'ha informar por el laboratorio',
                                convert(varchar,@n),
                                0,
                                'ha informar por el laboratorio',
                                4,
                                @@aabalab_id,
                                1,
                                @@est_id,
                                10,
                                12,
                                99,
                                350,
                                99,
                                'ha informar por el laboratorio',
                                'desconocido',
                                'ha informar por el laboratorio',
                                @@us_id
                              )
    end
    set @n = @n+1
  end

  select   count(*)
  
  from aaarbaweb..inscripcion insc left join aaba_laboratorio l on insc.aabalab_id = l.aabalab_id

  where insc_numero between @desde and @hasta
    and (insc.aabalab_id = @@aabalab_id or @@aabalab_id = 0)
  
end

go
