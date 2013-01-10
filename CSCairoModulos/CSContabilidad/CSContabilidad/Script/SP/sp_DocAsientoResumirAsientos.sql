if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoResumirAsientos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoResumirAsientos]

/*

  create table #t_ejasiento (ejcas_id int, cue_id int, debe decimal(18,6), haber decimal(18,6))

  exec sp_DocAsientoResumirAsientos 2, 1, '0', '20060101', '20070430'

  select a.*,  t.* from #t_ejasiento t inner join EjercicioAsientoResumen a on t.ejcas_id = a.ejcas_id
  order by a.ejcas_id, debe desc
  
  drop table #t_ejasiento 

*/

go
create procedure sp_DocAsientoResumirAsientos (

  @@ejc_id     int,
  @@emp_id    int,
  @@cico_id    varchar(255),
  @@fDesde    datetime,
  @@fHasta    datetime,
  @@tipo_fc    tinyint,
  @@tipo_fv    tinyint
)
as

begin

  set nocount on

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
  
  declare @fecha_desde datetime
  declare @fecha_hasta datetime
  declare @ejcas_id     int
  declare @ejcas_tipo  int
  
  set @fecha_desde = @@fDesde
  
  declare c_ejcas insensitive cursor for 
  select ejcas_id, ejcas_fecha, ejcas_tipo 
  from EjercicioAsientoResumen
  where ejc_id = @@ejc_id and ejcas_tipo = 1
  order by ejcas_fecha
  
  open c_ejcas
  
  fetch next from c_ejcas into @ejcas_id, @fecha_hasta, @ejcas_tipo
  while @@fetch_status=0
  begin
  
    insert into #t_ejasiento (ejcas_id, cue_id, debe, haber)
      select @ejcas_id,
             asi.cue_id,
             case when sum(asi_debe) - sum(asi_haber) > 0 then sum(asi_debe) - sum(asi_haber)
                   else 0
             end    as Debe,
             case when sum(asi_haber) - sum(asi_debe) > 0 then sum(asi_haber) - sum(asi_debe)
                   else 0
             end    as Haber
--              sum(asi_debe)   Debe,
--              sum(asi_haber) Haber
  
      from Asiento ast inner join AsientoItem asi   on ast.as_id           = asi.as_id
                       inner join Documento doccl   on ast.doc_id_cliente = doccl.doc_id

      where as_fecha between @fecha_desde and @fecha_hasta

      and as_fecha <= @@fHasta -- Para no incluir operaciones mas alla del periodo solicitado

      and doccl.emp_id = @@emp_id
  
      and(
             (      ast.doct_id_cliente in (2,8,10)
                and @ejcas_tipo = 2 and @@tipo_fc <> 3
              )
          or (      ast.doct_id_cliente in (1,7,9)
                and @ejcas_tipo = 1 and @@tipo_fv <> 3
              )
          )

      --//////////////////////////////////////////////////////////////////////////////////
      --
      -- Circuito Contable
      --
      and (doccl.cico_id = @cico_id or @cico_id = 0)
      and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doccl.cico_id)) or (@ram_id_circuitocontable = 0))
      --//////////////////////////////////////////////////////////////////////////////////

      group by asi.cue_id
  
    set @fecha_desde = dateadd(d,1,@fecha_hasta)
  
    fetch next from c_ejcas into @ejcas_id, @fecha_hasta, @ejcas_tipo
  end
  
  close c_ejcas
  deallocate c_ejcas

--/////////////////////////////////////////////////////////////////////////////////////////
--
-- VENTAS
--
--/////////////////////////////////////////////////////////////////////////////////////////

  set @fecha_desde = @@fDesde
  
  declare c_ejcas insensitive cursor for 
  select ejcas_id, ejcas_fecha, ejcas_tipo 
  from EjercicioAsientoResumen
  where ejc_id = @@ejc_id and ejcas_tipo = 2
  order by ejcas_fecha
  
  open c_ejcas
  
  fetch next from c_ejcas into @ejcas_id, @fecha_hasta, @ejcas_tipo
  while @@fetch_status=0
  begin
  
    insert into #t_ejasiento (ejcas_id, cue_id, debe, haber)
      select @ejcas_id,
             asi.cue_id,
             case when sum(asi_debe) - sum(asi_haber) > 0 then sum(asi_debe) - sum(asi_haber)
                   else 0
             end    as Debe,
             case when sum(asi_haber) - sum(asi_debe) > 0 then sum(asi_haber) - sum(asi_debe)
                   else 0
             end    as Haber
--              sum(asi_debe)   Debe,
--              sum(asi_haber) Haber
  
      from Asiento ast inner join AsientoItem asi   on ast.as_id           = asi.as_id
                       inner join Documento doccl   on ast.doc_id_cliente = doccl.doc_id

      where as_fecha between @fecha_desde and @fecha_hasta

      and as_fecha <= @@fHasta -- Para no incluir operaciones mas alla del periodo solicitado

      and doccl.emp_id = @@emp_id
  
      and(
             (      ast.doct_id_cliente in (2,8,10)
                and @ejcas_tipo = 2 and @@tipo_fc <> 3
              )
          or (      ast.doct_id_cliente in (1,7,9)
                and @ejcas_tipo = 1 and @@tipo_fv <> 3
              )
          )

      --//////////////////////////////////////////////////////////////////////////////////
      --
      -- Circuito Contable
      --
      and (doccl.cico_id = @cico_id or @cico_id = 0)
      and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doccl.cico_id)) or (@ram_id_circuitocontable = 0))
      --//////////////////////////////////////////////////////////////////////////////////

      group by asi.cue_id
  
    set @fecha_desde = dateadd(d,1,@fecha_hasta)
  
    fetch next from c_ejcas into @ejcas_id, @fecha_hasta, @ejcas_tipo
  end
  
  close c_ejcas
  deallocate c_ejcas
  
end
GO