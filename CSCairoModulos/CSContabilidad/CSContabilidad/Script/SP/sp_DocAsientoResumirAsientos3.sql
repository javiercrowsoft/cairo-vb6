/*

  Este SP a diferencia de sp_DocAsientoResumirAsientos no genera asientos en una temporal
  sino que los genera en la tabla asiento.

  Por esta razon recibe un doc_id que no debe pertencer a los circuitos contables
  mencionados por cico_id.

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoResumirAsientos3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoResumirAsientos3]

go
create procedure sp_DocAsientoResumirAsientos3 (

  @@doc_id    int,
  @@emp_id    int,
  @@cue_id    int,
  @@cue_id_si int,
  @@ccos_id   varchar(255),
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

  declare @cue_nombre varchar(255)

  select @cue_nombre = cue_nombre from Cuenta where cue_id = @@cue_id

  ------------------------------------------------------------------------------------------------------
        
        declare @ccos_id       int
        declare @cico_id       int
        declare @emp_id       int 
        
        declare @ram_id_centrocosto       int
        declare @ram_id_circuitocontable   int
        declare @ram_id_Empresa           int 
        
        declare @clienteID int
        declare @IsRaiz    tinyint
        
        exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
        exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
        exec sp_ArbConvertId @@emp_id,   @emp_id out,   @ram_id_Empresa out 
        
        exec sp_GetRptId @clienteID out
                
        if @ram_id_centrocosto <> 0 begin
        
        --  exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id
        
          exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
          if @IsRaiz = 0 begin
            exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
          end else 
            set @ram_id_centrocosto = 0
        end
        
        if @ram_id_circuitocontable <> 0 begin
        
        --  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id
        
          exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
          if @IsRaiz = 0 begin
            exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
          end else 
            set @ram_id_circuitocontable = 0
        end
        
        if @ram_id_Empresa <> 0 begin
        
        --  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id
        
          exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
          if @IsRaiz = 0 begin
            exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
          end else 
            set @ram_id_Empresa = 0
        end
        
        create table #t_asiento_resumen_0001 (
                cue_id                  int,
                 asi_id                  int
        )
        
        create table #t_asiento_resumen_0002 (
                cue_id                  int,
                asi_id                  int,
                asi_id2                  int,
                Debe                    decimal(18,6),
                Haber                    decimal(18,6),
                [Debe mon Ext]          decimal(18,6),
                [Haber mon Ext]          decimal(18,6)
        )
        
                
        insert into #t_asiento_resumen_0001
        
                    select 
                          asi.cue_id,
                          asi.asi_id
                    
                    from
                    
                          AsientoItem asi         inner join Cuenta cue             on asi.cue_id          = cue.cue_id
                                                  inner join Asiento ast            on asi.as_id           = ast.as_id
                                                  inner join Documento doc          on ast.doc_id          = doc.doc_id
                                                  inner join Empresa emp           on doc.emp_id          = emp.emp_id 
                                                  left  join Documento doccl       on ast.doc_id_cliente  = doccl.doc_id
                                                  left  join Cheque cheq           on asi.cheq_id         = cheq.cheq_id
                    
                    where 
                              cue.cue_id = @@cue_id
                          and   
        
                          (
                              (      as_fecha between @@Fdesde and @@Fhasta
                                and asi.cheq_id is null
                              )
                            or (cheq_fechacobro between @@Fdesde and @@Fhasta and cheq_fechacobro >= as_fecha)
                            or (as_fecha between @@Fdesde and @@Fhasta and as_fecha > cheq_fechacobro)
                          )
                    
                          and (
                                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                              )
                    
                    /* -///////////////////////////////////////////////////////////////////////
                    
                    INICIO SEGUNDA PARTE DE ARBOLES
                    
                    /////////////////////////////////////////////////////////////////////// */
                    
                    and   (asi.ccos_id = @ccos_id   or @ccos_id=0)
                    and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
                    and   (emp.emp_id   = @emp_id   or @emp_id=0) 
        
                    -- Arboles
                    
                    and   (
                              (exists(select rptarb_hojaid 
                                      from rptArbolRamaHoja 
                                      where
                                           rptarb_cliente = @clienteID
                                      and  tbl_id = 21 
                                      and  rptarb_hojaid = asi.ccos_id
                                     ) 
                               )
                            or 
                               (@ram_id_centrocosto = 0)
                           )
                    
                    and   (
                              (exists(select rptarb_hojaid 
                                      from rptArbolRamaHoja 
                                      where
                                           rptarb_cliente = @clienteID
                                      and  tbl_id = 1016 
                                      and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
                                     ) 
                               )
                            or 
                               (@ram_id_circuitocontable = 0)
                           )
                    
                    and   (
                              (exists(select rptarb_hojaid 
                                      from rptArbolRamaHoja 
                                      where
                                           rptarb_cliente = @clienteID
                                      and  tbl_id = 1018 
                                      and  rptarb_hojaid = doc.emp_id
                                     ) 
                               )
                            or 
                               (@ram_id_Empresa = 0)
                           )
        
        
        --////////////////////////////////////////////////////////////////////////
        --
        --
        -- Aplicacion de las cuentas del asiento entre debe y haber
        --
        --
        --////////////////////////////////////////////////////////////////////////
                          
                          declare @asi_id       int    
                          declare @asi_id2      int
                          declare @asi_id3      int
                          declare @cue_id_asi3  int
                          declare @monto        decimal(18,6)
                          declare @monto2       decimal(18,6)
                          declare @monto3       decimal(18,6)
                          declare @aplicado     decimal(18,6)
                          declare @as_id        int
                          declare @asi_orden    int
                          declare @isdebe       tinyint
                          
                          
                          -- Creamos un cursor sobre todos los asientoitems 
                          -- que afectan a nuestra cuenta
                          --
                          declare c_asi insensitive cursor for 
                          
                                select asi_id 
                                from #t_asiento_resumen_0001 
                                order by asi_id
                          
                          open c_asi
                          
                          fetch next from c_asi into @asi_id
                          while @@fetch_status = 0
                          begin
                          
                            select   @as_id       = as_id, 
                                    @asi_orden   = asi_orden,  
                                    @isdebe     = case when asi_debe <> 0 then 1 else 0 end,
                                    @monto3     = case when asi_debe <> 0 then asi_debe else asi_haber end
                          
                            from AsientoItem 
                            where asi_id = @asi_id
                          
                            -------------------------------------------------------------------------------------------
                            --
                            declare c_asi2 insensitive cursor for 
                          
                                select asi_id, case @isdebe when 0 then asi_haber else asi_debe end
                                from AsientoItem asi
                                where as_id = @as_id 

                                  -- not tiene que ser la cuenta excluida
                                  and asi.cue_id <> @@cue_id_si
                          
                                  -- Debe estar antes que el asientoitem que estamos procesando
                                  --
                                  and asi_orden < @asi_orden
                          
                                  -- Debe estar del mismo lado (debe o haber) 
                                  -- que el asientoitem que estamos procesando
                                  --
                                  and (    
                                          (@isdebe <> 0 and asi_debe  <> 0) 
                                        or
                                          (@isdebe = 0  and asi_haber <> 0) 
                                      )
                          
                                  -- No tiene que estar procesada aun
                                  --
                                  and not exists(select * from #t_asiento_resumen_0002 where asi_id = asi.asi_id)
                            
                                order by asi_orden
                          
                            open c_asi2
                            
                            fetch next from c_asi2 into @asi_id2, @monto
                            while @@fetch_status = 0
                            begin
                          
                              -------------------------------------------------------------------------------------------
                              --
                          
                              -- Otro cursorsito mas :)
                              --
                          
                              -- Buscamos todos los asientoitem
                              -- que esten del OTRO lado (debe o haber) (EL LADO OSCURO :)
                              -- que el asientoitem que estamos procesando
                              --
                          
                              declare c_asi3 insensitive cursor for
                          
                                  select   asi_id, 
                                          cue_id,
                          
                                            asi_debe 
                                          + asi_haber 
                                          - IsNull((select sum(debe + haber)
                                             from #t_asiento_resumen_0002 
                                             where asi_id2 = asi.asi_id
                                            ),0)
                          
                                  from AsientoItem asi
                                  where as_id = @as_id 

                                    -- not tiene que ser la cuenta excluida
                                    and asi.cue_id <> @@cue_id_si
                            
                                    -- Debe estar del lado contrario (debe o haber) 
                                    -- que el asientoitem que estamos procesando
                                    --
                                    and (    
                                            (@isdebe <> 0 and asi_haber <> 0) 
                                          or
                                            (@isdebe = 0  and asi_debe  <> 0) 
                                        )
                            
                                    -- No tiene que estar procesada aun
                                    --
                                    and not exists( select * from #t_asiento_resumen_0002 
                                                    where asi_id2 = asi.asi_id 
                                                      and debe + haber = (asi_debe + asi_haber)
                                                  )
                          
                                  order by asi_orden
                          
                              open c_asi3
                              
                              fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
                              while @@fetch_status = 0
                              begin
                          
                                if @monto < @monto2 set @aplicado = @monto
                                else                set @aplicado = @monto2
                          
                                insert into #t_asiento_resumen_0002 (        
                                                                  cue_id,                  
                                                                  asi_id,                
                                                                  asi_id2,                  
                                                                  Debe,                    
                                                                  Haber,                    
                                                                  [Debe mon Ext],          
                                                                  [Haber mon Ext]          
                                                                  )
                                                          values (
                                                                  @cue_id_asi3,
                                                                  @asi_id2,     --> OJO al Piojo: Esto no es un bug
                                                                  @asi_id3,      -->               y esto tampoco
                                                                  case @isdebe when 0 then @aplicado   else 0 end,
                                                                  case @isdebe when 0 then 0           else  @aplicado end,
                                                                  0,
                                                                  0
                                                                  )
                          
                          
                                set @monto = @monto - @aplicado
                          
                                if @monto <=0 goto exit_c_asi3
                          
                                fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
                              end
                          
                          exit_c_asi3:
                              
                              close c_asi3
                              deallocate c_asi3
                              --
                              -------------------------------------------------------------------------------------------
                          
                          
                              fetch next from c_asi2 into @asi_id2, @monto
                            end
                            
                            close c_asi2
                            deallocate c_asi2
                            --
                            -------------------------------------------------------------------------------------------
                          
                            -------------------------------------------------------------------------------------------
                            /*
                          
                          
                                  OK, si llegamos hasta aqui solo nos falta procesa el asientoitem de nuestra cuenta
                          
                          
                            */
                            -------------------------------------------------------------------------------------------
                          
                              -------------------------------------------------------------------------------------------
                              --
                          
                              set @monto = @monto3
                          
                              -- Otro cursorsito mas :)
                              --
                          
                              -- Buscamos todos los asientoitem
                              -- que esten del OTRO lado (debe o haber) (EL LADO OSCURO :)
                              -- que el asientoitem que estamos procesando
                              --
                          
                              declare c_asi3 insensitive cursor for
                          
                                  select   asi_id, 
                                          cue_id,
                          
                                            asi_debe 
                                          + asi_haber 
                                          - IsNull((select sum(debe + haber)
                                             from #t_asiento_resumen_0002 
                                             where asi_id2 = asi.asi_id
                                            ),0)
                          
                                  from AsientoItem asi
                                  where as_id = @as_id 

                                    -- not tiene que ser la cuenta excluida
                                    and asi.cue_id <> @@cue_id_si
                            
                                    -- Debe estar del lado contrario (debe o haber) 
                                    -- que el asientoitem que estamos procesando
                                    --
                                    and (    
                                            (@isdebe <> 0 and asi_haber <> 0) 
                                          or
                                            (@isdebe = 0  and asi_debe  <> 0) 
                                        )
                            
                                    -- No tiene que estar procesada aun
                                    --
                                    and not exists( select * from #t_asiento_resumen_0002 
                                                    where asi_id2 = asi.asi_id 
                                                      and (debe + haber) = (asi_debe + asi_haber)
                                                  )
                          
                                  order by asi_orden
                          
                              open c_asi3
                              
                              fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
                              while @@fetch_status = 0
                              begin
                          
                                if @monto < @monto2 set @aplicado = @monto
                                else                set @aplicado = @monto2
                          
                                insert into #t_asiento_resumen_0002 (        
                                                                  cue_id,                  
                                                                  asi_id,                
                                                                  asi_id2,                  
                                                                  Debe,                    
                                                                  Haber,                    
                                                                  [Debe mon Ext],          
                                                                  [Haber mon Ext]          
                                                                  )
                                                          values (
                                                                  @cue_id_asi3,
                                                                  @asi_id,      --> OJO al Piojo: Esto no es un bug
                                                                  @asi_id3,      -->               y esto tampoco
                                                                  case @isdebe when 0 then @aplicado   else 0 end,
                                                                  case @isdebe when 0 then 0           else  @aplicado end,
                                                                  0,
                                                                  0
                                                                  )
                          
                          
                                set @monto = @monto - @aplicado
                          
                                if @monto <=0 goto exit_c_asi3_2
                          
                                fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
                              end
                          
                          exit_c_asi3_2:
                              
                              close c_asi3
                              deallocate c_asi3
                              --
                              -------------------------------------------------------------------------------------------
                          
                            fetch next from c_asi into @asi_id
                          end
                          
                          close c_asi
                          deallocate c_asi
                          --
                          -------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------

  set @as_id      =null
  set @asi_orden   =null
  set @ccos_id     =null

  declare @asTMP_id  int
  declare @asiTMP_id int
  declare @asi_debe  decimal(18,6)
  declare @asi_haber decimal(18,6)
  declare @cue_id    int
  declare @saldo     decimal(18,6)

  declare  @as_nrodoc  varchar (50) 
  declare @doct_id    int

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

    if exists(
              select *              
              from #t_asiento_resumen_0001 asi    
                        inner join #t_asiento_resumen_0002 asi2     
                          on asi.asi_id   = asi2.asi_id
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
                              'Asiento resumen de cuenta ' + @cue_nombre + ' de ' + convert(varchar,@@Fdesde,102),
                              @@FHasta,
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
  
            select             -- Esto no es un bug, yo reparti el debe de la cuenta principal
                              -- en sus contra cuentas y lo mismo hice con el haber, y por
                              -- ende los importes estan al reves, es decir el debe contiene
                              -- el valor del haber de la contracuenta, es decir de asi.cue_id
                              -- por eso esta haber-debe en lugar de debe-haber
                              --
                  asi2.cue_id, sum(asi2.haber) - sum(asi2.debe)
            
            from #t_asiento_resumen_0001 asi    
                      inner join #t_asiento_resumen_0002 asi2     
                        on asi.asi_id   = asi2.asi_id
            group by   asi2.cue_id
  
      open c_items
  
      fetch next from c_items into @cue_id, @saldo
      while @@fetch_status=0
      begin
  
        if @saldo <> 0 begin
  
          if @saldo < 0 begin
  
            set @asi_debe  = abs(@saldo)
            set @asi_haber = 0
  
          end else begin
  
            set @asi_debe  = 0
            set @asi_haber = abs(@saldo)
  
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


      -- Item de la cuenta que origina el asiento
      --

      declare c_items insensitive cursor for
  
            select             
                  ccos_id, sum(asi_debe) - sum(asi_haber) 
            
            from AsientoItemTMP
            where asTMP_id = @asTMP_id
            group by   ccos_id
  
      open c_items
  
      fetch next from c_items into @ccos_id, @saldo
      while @@fetch_status=0
      begin
  
        if @saldo <> 0 begin
  
          if @saldo < 0 begin
  
            set @asi_debe  = abs(@saldo)
            set @asi_haber = 0
  
          end else begin
  
            set @asi_debe  = 0
            set @asi_haber = abs(@saldo)
  
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
                                        @@cue_id,
                                        @ccos_id
                                      )

        end
                                              
        fetch next from c_items into @ccos_id, @saldo
  
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
      where as_fecha         = @@Fhasta 
        and doc_id           = @@doc_id 
        and as_doc_cliente   = '[AR-CUENTA- '+ @cue_nombre +' ('+convert(varchar,@@cue_id)+')]'
  
      if @as_id is not null begin
  
        exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
        if @@error <> 0 goto ControlError
  
      end    
  
      set @as_id = null
  
      exec sp_DocAsientoSave @asTMP_id, @as_id out, 0
      if @@error <> 0 goto ControlError
  
      update Asiento set as_doc_cliente = '[AR-CUENTA- '+ @cue_nombre +' ('+convert(varchar,@@cue_id)+')]' where as_id = @as_id
  
      --
      -- Grabo el Asiento
      --
      -- //////////////////////////////////////////////////////////////////////////////////

    end

  set @@bSuccess = 1

  return
ControlError:
                          
  raiserror ('Ha ocurrido un error al grabar los asientos resumidos por cuenta. sp_DocAsientoResumirAsientos3.', 16, 1)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

