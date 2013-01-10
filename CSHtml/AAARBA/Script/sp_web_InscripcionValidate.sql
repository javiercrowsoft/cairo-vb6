if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionValidate]

/*

select * from aaarbaweb..inscripcion where aabainsc_aerea <> 0

sp_web_InscripcionValidate '4376320',4,'','',0,0,0,null

sp_web_InscripcionValidate '4376320',4,341,341,0,0,1,null

*/

go
create procedure sp_web_InscripcionValidate (
  @@nroDoc    varchar(255),
  @@tipoDoc   tinyint,
  @@socio     varchar(255),
  @@sociol     varchar(255),
  @@chkAerea   tinyint,
  @@chkInfo    tinyint,
  @@chkLasra  tinyint,
  @@insc_id   int
)
as

begin

  set nocount on

  declare @insc_id_padre     int
  declare @insc_numero       varchar(255)
  declare @error_message    varchar(5000)
  declare @success          tinyint

  set @error_message   = ''
  set @success         = 1

  if @@insc_id is not null begin
    select @insc_id_padre = insc_id_padre from aaarbaweb..inscripcion where insc_id = @@insc_id

  end else begin

    if @insc_id_padre is null begin
      select @insc_id_padre = insc_id from aaarbaweb..inscripcion 
      where (
                (      insc_documento       = @@nroDoc 
                  and  insc_tipodocumento  = @@tipoDoc 
                )
              or  (insc_socio        = @@socio   and @@socio   <> '')
              or  (insc_socioLASFAR  = @@sociol  and @@sociol   <> '')
            )
          and
              insc_id_padre is null 
    end
  end

  if @insc_id_padre is not null begin

    if @@chkAerea<>0 begin
      if exists(select * from aaarbaweb..inscripcion 
                where (      insc_id = @insc_id_padre 
                        or   insc_id_padre = @insc_id_padre
                      )
                  and
                      insc_id <> IsNull(@@insc_id,0)
                  and
                      AABAinsc_aerea <> 0)
      begin

        select @insc_numero = insc_numero
        from aaarbaweb..inscripcion 
        where (      insc_id = @insc_id_padre 
                or   insc_id_padre = @insc_id_padre
              )
          and
              insc_id <> IsNull(@@insc_id,0)
          and
              AABAinsc_aerea <> 0

        set @error_message = 'Este medico ya esta inscripto al curso "Vía aérea: nuevos dispositivos" en la ficha nro.: ' + @insc_numero + '. '
        set @success = 0
      end
    end

    if @@chkInfo<>0 begin
      if exists(select * from aaarbaweb..inscripcion 
                where (      insc_id = @insc_id_padre 
                        or   insc_id_padre = @insc_id_padre
                      )
                  and
                      insc_id <> IsNull(@@insc_id,0)
                  and
                      AABAinsc_info <> 0)
      begin

        select @insc_numero = insc_numero
        from aaarbaweb..inscripcion 
        where (      insc_id = @insc_id_padre 
                or   insc_id_padre = @insc_id_padre
              )
          and
              insc_id <> IsNull(@@insc_id,0)
          and
              AABAinsc_info <> 0

        set @error_message = @error_message + 'Este medico ya esta inscripto al curso "Informática para Anestesiólogos" en la ficha nro.: ' + @insc_numero + '. '
        set @success = 0
      end
    end

    if @@chkLasra<>0 begin
      if exists(select * from aaarbaweb..inscripcion 
                where (      insc_id = @insc_id_padre 
                        or   insc_id_padre = @insc_id_padre
                      )
                  and
                      insc_id <> IsNull(@@insc_id,0)
                  and
                      AABAinsc_lasra <> 0)
      begin

        select @insc_numero = insc_numero
        from aaarbaweb..inscripcion 
        where (      insc_id = @insc_id_padre 
                or   insc_id_padre = @insc_id_padre
              )
          and
              insc_id <> IsNull(@@insc_id,0)
          and
              AABAinsc_lasra <> 0

        set @error_message = @error_message + 'Este medico ya esta inscripto al curso "Jornada Argentina-LASRA" en la ficha nro.: ' + @insc_numero + '. '
        set @success = 0
      end
    end
    
    if @@chkAerea=0 and @@chkLasra=0 and @@chkInfo=0 begin

      select @insc_numero = insc_numero
      from aaarbaweb..inscripcion 
      where insc_id = @insc_id_padre 

      set @error_message = 'Este medico ya esta inscripto al congreso en la ficha nro.: ' + @insc_numero + '. '
      set @success = 0
    end
  end  

  select @success as success, @error_message as error_message, @insc_id_padre as insc_id_padre
end

go
