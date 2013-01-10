if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveCurso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveCurso]

go

create procedure sp_DocFacturaVentaSaveCurso (
  @fv_id         int,
  @@fvTMP_ID    int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  -- Poner en configuracion de empresa
  --
  if 1=2 begin

    declare @bError tinyint
  
    set @bError     = 0
    set @@bSuccess   = 0
    set @@bErrorMsg = '@@ERROR_SP:'
  
    declare @cli_id       int
    declare @cli_nombre    varchar(255)
    declare @cur_id       int
    declare @curi_id       int
    declare @alum_id       int
    declare @modifico     int
    declare @fv_fecha     datetime
  
    select   @cli_id       = fv.cli_id, 
            @modifico     = fv.modifico,
            @fv_fecha     = fv.fv_fecha,
            @cli_nombre    = cli_nombre
  
    from FacturaVenta fv inner join Cliente cli on fv.cli_id = cli.cli_id
    where fv.fv_id = @fv_id
  
    select @alum_id = alum_id
    from Persona prs inner join Alumno alum on prs.prs_id = alum.prs_id
    where prs.cli_id = @cli_id
  
    --/////////////////////////////////////
    --
    -- Si no existe aun un alumno lo creamos
    --
    if @alum_id is null begin
  
      declare @prs_id         int
      declare @prs_apellido   varchar(255)
      declare @prs_nombre     varchar(255)
      declare @i              int
  
      set @i = charindex(',',@cli_nombre,1)
  
      if @i <> 0 begin
  
        set @prs_apellido = substring(@cli_nombre,1,@i)
        set @prs_nombre   = substring(@cli_nombre,@i+1,1000)
  
      end else begin
  
        set @i = charindex(' ',@cli_nombre,1)
    
        if @i <> 0 begin
    
          set @prs_apellido = substring(@cli_nombre,1,@i)
          set @prs_nombre   = substring(@cli_nombre,@i+1,1000)
    
        end else begin
  
          set @prs_apellido = @cli_nombre
          set @prs_nombre   = '.'
  
        end
      end
  
      exec sp_dbgetnewid 'Persona','prs_id',@prs_id out,0
      
      insert into Persona (prs_id, prs_apellido, prs_nombre, prs_codigo, modifico, cli_id)
                   values (@prs_id, @prs_apellido, @prs_nombre, right('00000'+convert(varchar,@prs_id),5),
                                                                          @modifico, @cli_id)
  
      exec sp_dbgetnewid 'Alumno','alum_id',@alum_id out,0
  
      insert into Alumno (alum_id, alum_codigo, modifico, prs_id, alum_fechaingreso)
                  values (@alum_id, right('00000'+convert(varchar,@alum_id),5),
                                                @modifico, @prs_id, @fv_fecha)
  
    end
  
    if @alum_id is not null begin
  
      declare c_cursos insensitive cursor for
    
        select distinct pr.cur_id
        from FacturaVentaItem t inner join Producto pr on t.pr_id = pr.pr_id
        where t.fv_id = @fv_id 
          and pr.cur_id is not null
    
      open c_cursos
    
      fetch next from c_cursos into @cur_id
    
      while @@fetch_status=0
      begin
    
        if not exists (select * from CursoItem where cur_id = @cur_id and alum_id = @alum_id)
        begin
    
          exec sp_dbgetnewid 'CursoItem','curi_id',@curi_id out,0
    
          insert into CursoItem ( cur_id,
                                  curi_id,
                                  alum_id,
                                  est_id,
                                  fv_id
                                )
                      values     ( @cur_id,
                                  @curi_id,
                                  @alum_id,
                                  10, /*En curso*/
                                  @fv_id
                                )
          if @@error <> 0 begin
      
            set @bError = 1
            set @@bErrorMsg = @@bErrorMsg + 'No se pudo inscribir al alumno a los cursos mencionados por la factura' + char(10)
            goto ControlError
      
          end
    
        end
    
    
        fetch next from c_cursos into @cur_id
      end
    
      close c_cursos
      deallocate c_cursos
  
  
      -- Borro cualquier inscripcion a cursos que ya no este reflejada por esta factura
      -- y se halla generado por esta factura en versiones anteriores de la misma
      -- (en castellano: por que modificaron o borraron los productos de la factura)
      --
      delete CursoItem 
      where fv_id = @fv_id 
        and not exists(  select distinct pr.cur_id
                        from FacturaVentaItem t inner join Producto pr on t.pr_id = pr.pr_id
                        where t.fv_id = @fv_id 
                          and pr.cur_id = CursoItem.cur_id
  
                      )
      if @@error <> 0 begin
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'No se pudo borrar la inscripcion a los cursos mencionados por la version anterior de la factura' + char(10)
        goto ControlError
  
      end
    end
  end

ControlError:

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO