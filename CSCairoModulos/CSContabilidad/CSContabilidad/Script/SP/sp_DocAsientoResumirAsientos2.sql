/*

  Este SP a diferencia de sp_DocAsientoResumirAsientos no genera asientos en una temporal
  sino que los genera en la tabla asiento.

  Por esta razon recibe un doc_id que no debe pertencer a los circuitos contables
  mencionados por cico_id.

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoResumirAsientos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoResumirAsientos2]

go
create procedure sp_DocAsientoResumirAsientos2 (

  @@doc_id    int,
  @@emp_id    int,
  @@cico_id    varchar(255),
  @@fDesde    datetime,
  @@fHasta    datetime,
  @@us_id     int,
  @@bSuccess  tinyint out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  -- Actualizo los campos para que no tengan informacion de hora
  --
  update facturacompra set fc_fechaiva = convert(varchar,fc_fechaiva,112)
  update facturaventa set fv_fechaiva = convert(varchar,fv_fechaiva,112)

  declare @fecha_desde datetime
  declare @fecha_hasta datetime

  declare @n         int
  declare @meses     int

  declare @asTMP_id int
  declare @as_id    int

  declare @asiTMP_id int
  declare @asi_debe  decimal(18,6)
  declare @asi_haber decimal(18,6)
  declare @cue_id    int
  declare @asi_orden int
  declare @ccos_id   int
  declare @saldo     decimal(18,6)

  declare  @as_nrodoc  varchar (50) 
  declare @doct_id    int

  --/////////////////////////////////////////////////////////////////////////////////
  --
  -- Circuito Contable
  --

    declare @cico_id     int
    declare @ram_id_circuitocontable int
  
    declare @clienteID int
    declare @IsRaiz    tinyint
  
    exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
  
    exec sp_GetRptId @clienteID out
  
    if @ram_id_circuitocontable <> 0 begin
    
    --  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id
    
      exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
      if @IsRaiz = 0 begin
        exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
      end else 
        set @ram_id_circuitocontable = 0
    end
  
  --
  -- Circuito Contable
  --
  --/////////////////////////////////////////////////////////////////////////////////


  -- //////////////////////////////////////////////////////////////////////////////////
  --
  -- Talonario
  --
        declare @ta_id int

        select @ta_id = ta_id, @doct_id = doct_id from Documento where doc_id = @@doc_id

        declare @ta_propuesto tinyint
        declare @ta_tipo      smallint
    
        exec sp_talonarioGetPropuesto @@doc_id, 0, @ta_propuesto out, 0, 0, @ta_id out, @ta_tipo out
        if @@error <> 0 goto ControlError
    
        declare @ta_nrodoc varchar(100)
  --
  -- Talonario
  --
  -- //////////////////////////////////////////////////////////////////////////////////

  set @n = 1
  set @meses = datediff(m,@@fDesde, @@fHasta)
  
  set @fecha_desde = @@fDesde
  
  while @n <= @meses
  begin

    -- Ultimo dia del mes
    --
    set @fecha_hasta = dateadd(m,1,@fecha_desde)
    set @fecha_hasta = dateadd(d,-day(@fecha_hasta),@fecha_hasta)

    if exists(
                select ast.as_id
            
                from Asiento ast inner join Documento doccl on ast.doc_id_cliente = doccl.doc_id
          
                where as_fecha between @fecha_desde and @fecha_hasta
          
                and as_fecha <= @@fHasta -- Para no incluir operaciones mas alla del periodo solicitado
          
                and doccl.emp_id = @@emp_id
            
                and ast.doct_id_cliente in (2,8,10)
          
                --//////////////////////////////////////////////////////////////////////////////////
                --
                -- Circuito Contable
                --
                and (doccl.cico_id = @cico_id or @cico_id = 0)
                and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doccl.cico_id)) or (@ram_id_circuitocontable = 0))
                --//////////////////////////////////////////////////////////////////////////////////
              )

    begin

      -- //////////////////////////////////////////////////////////////////////////////////
      --
      -- Cabecera del Asiento
      --
  
          -- //////////////////////////////////////////////////////////////////////////////////
          --
          -- Talonario
          --
                exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
                if @@error <> 0 goto ControlError
      
                -- Con esto evitamos que dos tomen el mismo número
                --
                exec sp_TalonarioSet @ta_id, @ta_nrodoc
                if @@error <> 0 goto ControlError
      
                set @as_nrodoc = @ta_nrodoc
      
          --
          -- Fin Talonario
          --
          -- //////////////////////////////////////////////////////////////////////////////////
  
      exec sp_dbgetnewid 'AsientoTMP','asTMP_id', @asTMP_id out, 0
      if @@error <> 0 goto ControlError
  
      insert into AsientoTMP( asTMP_id,
                              as_id,
                              as_numero,
                              as_nrodoc,
                              as_descrip,
                              as_fecha,
                              doc_id,
                              doct_id,
                              modifico
                            )
                        values
                            ( @asTMP_id,
                              0,
                              0,
                              @as_nrodoc,
                              'Asiento resumen de compras de ' + convert(varchar,@fecha_desde,102),
                              @fecha_hasta,
                              @@doc_id,
                              @doct_id,
                              @@us_id
                            )
  
  
      --
      -- Cabecera del Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////
  
      -- //////////////////////////////////////////////////////////////////////////////////
      --
      -- Items del Asiento
      --
  
      set @asi_orden = 0
  
      declare c_items insensitive cursor for
  
            select asi.cue_id, sum(asi_debe) - sum(asi_haber)
        
            from Asiento ast inner join AsientoItem asi   on ast.as_id           = asi.as_id
                             inner join Documento doccl   on ast.doc_id_cliente = doccl.doc_id
      
            where as_fecha between @fecha_desde and @fecha_hasta
      
            and as_fecha <= @@fHasta -- Para no incluir operaciones mas alla del periodo solicitado
      
            and doccl.emp_id = @@emp_id
        
            and ast.doct_id_cliente in (2,8,10)
      
            --//////////////////////////////////////////////////////////////////////////////////
            --
            -- Circuito Contable
            --
            and (doccl.cico_id = @cico_id or @cico_id = 0)
            and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doccl.cico_id)) or (@ram_id_circuitocontable = 0))
            --//////////////////////////////////////////////////////////////////////////////////
      
            group by asi.cue_id

            order by sum(asi_debe) asc, sum(asi_haber) 
  
      open c_items
  
      fetch next from c_items into @cue_id, @saldo
      while @@fetch_status=0
      begin
  
        if @saldo <> 0 begin
  
          if @saldo < 0 begin
  
            set @asi_debe  = 0
            set @asi_haber = abs(@saldo)
  
          end else begin
  
            set @asi_debe  = abs(@saldo)
            set @asi_haber = 0
  
          end
    
          set @asi_orden = @asi_orden + 1
    
          exec sp_dbgetnewid 'AsientoItemTMP','asiTMP_id', @asiTMP_id out, 0
          if @@error <> 0 goto ControlError
    
          insert into AsientoItemTMP (  asTMP_id,
                                        asiTMP_id,
                                        asi_id,
                                        asi_orden,
                                        asi_descrip,
                                        asi_debe,
                                        asi_haber,
                                        asi_origen,
                                        cue_id,
                                        ccos_id
                                      )
                              values
                                      (  @asTMP_id,
                                        @asiTMP_id,
                                        0,
                                        @asi_orden,
                                        '',
                                        @asi_debe,
                                        @asi_haber,
                                        0,
                                        @cue_id,
                                        @ccos_id
                                      )
        end
                                              
        fetch next from c_items into @cue_id, @saldo
  
      end
  
      close c_items
      deallocate c_items
  
      --
      -- Items del Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////
  
      -- //////////////////////////////////////////////////////////////////////////////////
      --
      -- Grabo el Asiento
      --
  
      -- Si ya existe un asiento resumen para esta fecha y este documento lo borro
      --
      set @as_id = null
  
      select @as_id = as_id 
      from Asiento 
      where as_fecha         = @fecha_hasta 
        and doc_id           = @@doc_id 
        and as_doc_cliente   = '[ARC]'
  
      if @as_id is not null begin
  
        exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
        if @@error <> 0 goto ControlError
  
      end    
  
      set @as_id = null
  
      exec sp_DocAsientoSave @asTMP_id, @as_id out, 0
      if @@error <> 0 goto ControlError
  
      update Asiento set as_doc_cliente = '[ARC]' where as_id = @as_id
  
      --
      -- Grabo el Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////

    end
  
    set @fecha_desde = dateadd(d,1,@fecha_hasta)
    set @n = @n+1
  
  end
  
--/////////////////////////////////////////////////////////////////////////////////////////
--
-- VENTAS
--
--/////////////////////////////////////////////////////////////////////////////////////////

  set @fecha_desde = @@fDesde

  set @n = 1

  while @n <= @meses  
  begin

    -- Ultimo dia del mes
    --
    set @fecha_hasta = dateadd(m,1,@fecha_desde)
    set @fecha_hasta = dateadd(d,-day(@fecha_hasta),@fecha_hasta)

    if exists (
                select ast.as_id
            
                from Asiento ast inner join Documento doccl   on ast.doc_id_cliente = doccl.doc_id
          
                where as_fecha between @fecha_desde and @fecha_hasta
          
                and as_fecha <= @@fHasta -- Para no incluir operaciones mas alla del periodo solicitado
          
                and doccl.emp_id = @@emp_id
            
                and ast.doct_id_cliente in (1,7,9)
          
                --//////////////////////////////////////////////////////////////////////////////////
                --
                -- Circuito Contable
                --
                and (doccl.cico_id = @cico_id or @cico_id = 0)
                and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doccl.cico_id)) or (@ram_id_circuitocontable = 0))
                --//////////////////////////////////////////////////////////////////////////////////
              )  
    begin

      -- //////////////////////////////////////////////////////////////////////////////////
      --
      -- Cabecera del Asiento
      --
  
          -- //////////////////////////////////////////////////////////////////////////////////
          --
          -- Talonario
          --
                exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
                if @@error <> 0 goto ControlError
      
                -- Con esto evitamos que dos tomen el mismo número
                --
                exec sp_TalonarioSet @ta_id, @ta_nrodoc
                if @@error <> 0 goto ControlError
      
                set @as_nrodoc = @ta_nrodoc
      
          --
          -- Fin Talonario
          --
          -- //////////////////////////////////////////////////////////////////////////////////
  
      exec sp_dbgetnewid 'AsientoTMP','asTMP_id', @asTMP_id out, 0
      if @@error <> 0 goto ControlError
  
      insert into AsientoTMP( asTMP_id,
                              as_id,
                              as_numero,
                              as_nrodoc,
                              as_descrip,
                              as_fecha,
                              doc_id,
                              doct_id,
                              modifico
                            )
                        values
                            ( @asTMP_id,
                              0,
                              0,
                              @as_nrodoc,
                              'Asiento resumen de ventas de ' + convert(varchar,@fecha_desde,102),
                              @fecha_hasta,
                              @@doc_id,
                              @doct_id,
                              @@us_id
                            )
  
  
      --
      -- Cabecera del Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////
  
      -- //////////////////////////////////////////////////////////////////////////////////
      --
      -- Items del Asiento
      --
  
      set @asi_orden = 0
  
      declare c_items insensitive cursor for
  
            select asi.cue_id, sum(asi_debe) - sum(asi_haber)
        
            from Asiento ast inner join AsientoItem asi   on ast.as_id           = asi.as_id
                             inner join Documento doccl   on ast.doc_id_cliente = doccl.doc_id
      
            where as_fecha between @fecha_desde and @fecha_hasta
      
            and as_fecha <= @@fHasta -- Para no incluir operaciones mas alla del periodo solicitado
      
            and doccl.emp_id = @@emp_id
        
            and ast.doct_id_cliente in (1,7,9)
      
            --//////////////////////////////////////////////////////////////////////////////////
            --
            -- Circuito Contable
            --
            and (doccl.cico_id = @cico_id or @cico_id = 0)
            and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doccl.cico_id)) or (@ram_id_circuitocontable = 0))
            --//////////////////////////////////////////////////////////////////////////////////
      
            group by asi.cue_id

            order by sum(asi_debe) asc, sum(asi_haber) 
  
      open c_items
  
      fetch next from c_items into @cue_id, @saldo
      while @@fetch_status=0
      begin
  
        if @saldo <> 0 begin
  
          if @saldo < 0 begin
  
            set @asi_debe  = 0
            set @asi_haber = abs(@saldo)
  
          end else begin
  
            set @asi_debe  = abs(@saldo)
            set @asi_haber = 0
  
          end
    
          set @asi_orden = @asi_orden + 1
    
          exec sp_dbgetnewid 'AsientoItemTMP','asiTMP_id', @asiTMP_id out, 0
          if @@error <> 0 goto ControlError
    
          insert into AsientoItemTMP (  asTMP_id,
                                        asiTMP_id,
                                        asi_id,
                                        asi_orden,
                                        asi_descrip,
                                        asi_debe,
                                        asi_haber,
                                        asi_origen,
                                        cue_id,
                                        ccos_id
                                      )
                              values
                                      (  @asTMP_id,
                                        @asiTMP_id,
                                        0,
                                        @asi_orden,
                                        '',
                                        @asi_debe,
                                        @asi_haber,
                                        0,
                                        @cue_id,
                                        @ccos_id
                                      )
        end
                                              
        fetch next from c_items into @cue_id, @saldo
  
      end
  
      close c_items
      deallocate c_items
  
      --
      -- Items del Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////
  
  
      -- //////////////////////////////////////////////////////////////////////////////////
      --
      -- Grabo el Asiento
      --
  
      -- Si ya existe un asiento resumen para esta fecha y este documento lo borro
      --
      set @as_id = null
  
      select @as_id=as_id 
      from Asiento 
      where as_fecha         = @fecha_hasta 
        and doc_id           = @@doc_id 
        and as_doc_cliente   = '[ARV]'
  
      if @as_id is not null begin
  
        exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
        if @@error <> 0 goto ControlError
  
      end    
  
      set @as_id = null
  
      exec sp_DocAsientoSave @asTMP_id, @as_id out, 0
      if @@error <> 0 goto ControlError
  
      update Asiento set as_doc_cliente = '[ARV]' where as_id = @as_id
  
      --
      -- Grabo el Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////

    end
  
    set @fecha_desde = dateadd(d,1,@fecha_hasta)
    set @n = @n+1

  end

  set @@bSuccess = 1

  return
ControlError:
                          
  raiserror ('Ha ocurrido un error al grabar los asientos resumidos de compras y ventas. sp_DocAsientoResumirAsientos2.', 16, 1)
    
end
GO