/*---------------------------------------------------------------------
Nombre: Libro Diario
---------------------------------------------------------------------*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0240]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0240]
GO

/*  

Para testear:

DC_CSC_CON_0240 1, 
                '20060101',
                '20060120',
                '0', 
                '0',
                '0',
                '0',
                '0'
*/

create procedure DC_CSC_CON_0240 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,
  @@ejc_id      int,            -- Solo se puede pedir un ejercicio a la vez
  @@cue_id      varchar(255),
  @@cico_id     varchar(255),
  @@doc_id       varchar(255),
  @@mon_id       varchar(255),
  @@emp_id       varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

VERIFICACION DE ALCANCE DEL EJERCICIO

/////////////////////////////////////////////////////////////////////// */

declare @fechaIni datetime
declare @fechaFin datetime

select @fechaIni = ejc_fechaini, @fechaFin = ejc_fechafin 
from EjercicioContable 
where ejc_id = @@ejc_id

if @@Fini < @fechaIni set @@Fini = @fechaIni
if @@Ffin < @fechaFin set @@Ffin = @fechaFin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


declare @cue_id       int
declare @mon_id       int
declare @emp_id       int
declare @cico_id       int
declare @doc_id        int

declare @ram_id_cuenta           int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int


declare @clienteID       int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@mon_id,       @mon_id  out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id  out,        @ram_id_empresa out
exec sp_ArbConvertId @@cue_id,       @cue_id  out,         @ram_id_cuenta out
exec sp_ArbConvertId @@cico_id,      @cico_id out,         @ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id,        @doc_id  out,         @ram_id_Documento out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

if @ram_id_moneda <> 0 begin

--  exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
  end else 
    set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
  end else 
    set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

/*- ///////////////////////////////////////////////////////////////////////

ASIENTOS RESUMIDOS DE COMPRAS Y VENTAS

/////////////////////////////////////////////////////////////////////// */

  -- Averiguo el tipo de resumen 
  -- que usa para ventas y compras
  declare @tipo_fc     tinyint
  declare @tipo_fv     tinyint
  declare @cfg_valor   varchar(5000)

  if @cico_id = 0 begin

    set @tipo_fc = 3
    set @tipo_fv = 3

  end else begin

    exec sp_Cfg_GetValor   'Contabilidad-General','Tipo Resumen Libro Diario Compras',  @cfg_valor out, 0
    if @cfg_valor is null         set @tipo_fc = 3
    else begin
      if IsNumeric(@cfg_valor)=0  set @tipo_fc = 3
      else                        set @tipo_fc = convert(smallint,@cfg_valor)
    end
  
    exec sp_Cfg_GetValor   'Contabilidad-General','Tipo Resumen Libro Diario Ventas',  @cfg_valor out, 0
    if @cfg_valor is null         set @tipo_fv = 3
    else begin
      if IsNumeric(@cfg_valor)=0  set @tipo_fv = 3
      else                        set @tipo_fv = convert(smallint,@cfg_valor)
    end

  end

  create table #t_DC_CSC_CON_0240 (

      as_id             int,
      as_numero         int,
      as_nrodoc          varchar(50),
      doc_nombre        varchar(100),
      as_fecha          datetime,
      codigo_doc        varchar(15),
      tipo_doc          varchar(100),

      as_doc_cliente    varchar(5000),
      emp_nombre        varchar(255),

      creado            datetime,
      modificado        datetime,
      modifico          varchar(50),


      cue_nombre        varchar(100),
      asi_debe          decimal(18,6),
      asi_haber         decimal(18,6),

      as_descrip        varchar(5000)
    )

  if @tipo_fc <> 3 or @tipo_fv <> 3 begin

    declare @oldDateFirst int
    set @oldDateFirst = @@DATEFIRST 

    create table #t_DC_CSC_CON_0240_date (as_id    int, 
                                          tipo    tinyint,
                                          fecha   datetime
                                         )

    declare @as_id      int
    declare @tipo        tinyint 
    declare @fecha      datetime
    declare @weekday    int
    declare @monthday   int

    declare c_asiento_fecha insensitive cursor for

      select 
            ast.as_id,
            case 
              when doct_id_cliente in (1,7,9)   then 1
              when doct_id_cliente in (2,8,10)   then 2
            end,
            as_fecha
      
      from 
      
            asiento ast
      
              inner join documento   doc   on ast.doc_id_cliente = doc.doc_id
                                          and (     (ast.doct_id_cliente in (2,8,10) and @tipo_fc <> 3)
                                                or (ast.doct_id_cliente in (1,7,9)  and @tipo_fv <> 3)
                                              )

              inner join asientoItem asi  on ast.as_id = asi.as_id

      
      where 
                as_fecha >= @@Fini
            and  as_fecha <= @@Ffin       
      
      -- Validar usuario - empresa
      and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
      
      and   (@cue_id = 0 or exists(select as_id from AsientoItem where as_id = ast.as_id and asi.cue_id = @cue_id))
      and   (@mon_id = 0 or exists(select as_id from AsientoItem where as_id = ast.as_id and asi.mon_id = @mon_id))
      
      and   (doc.emp_id   = @emp_id   or @emp_id  =0)
      and   (doc.cico_id  = @cico_id  or @cico_id  =0)
      and   (ast.doc_id   = @doc_id   or @doc_id  =0)
      
      -- Arboles
      and   ((exists(select as_id from AsientoItem where as_id = ast.as_id and (exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = cue_id)))) or (@ram_id_cuenta = 0))      
      and   ((exists(select as_id from AsientoItem where as_id = as_id and (exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 12 and rptarb_hojaid = mon_id))))or (@ram_id_moneda = 0))      
      and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_empresa = 0))
      and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = doc.cico_id)) or (@ram_id_circuitocontable = 0))      
      and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 4001 and rptarb_hojaid = ast.doc_id)) or (@ram_id_documento = 0))

    open c_asiento_fecha

    fetch next from c_asiento_fecha into @as_id, @tipo, @fecha
    while @@fetch_status=0
    begin

      if       (@tipo = 2 and @tipo_fc = 1)
          or  (@tipo = 1 and @tipo_fv = 1)
      begin

          set datefirst 1 
      
          set @weekday = datepart(dw,@fecha)
      
          set datefirst @oldDateFirst        

          -- Primer dia de la semana
          set @fecha = dateadd(d,-(@weekday-1),@fecha)

          -- Ultimo dia de la semana
          set @fecha = dateadd(d,6,@fecha)

      end else begin

        if       (@tipo = 2 and @tipo_fc = 2)
            or  (@tipo = 1 and @tipo_fv = 2)
        begin
  
            set @monthday = datepart(d,@fecha)

            -- Primer dia del mes
            set @fecha = dateadd(d,-(@monthday-1),@fecha)
  
            -- Ultimo dia del mes
            set @fecha = dateadd(m,1,@fecha)  -- Primer dia del mes siguiente
            set @fecha = dateadd(d,-1,@fecha) -- Le saco un dia y estamos en el
                                                          -- ultimo dia del mes actual
        end

      end

      insert into #t_DC_CSC_CON_0240_date (as_id, tipo, fecha)
                                    values(@as_id, @tipo, @fecha)

      fetch next from c_asiento_fecha into @as_id, @tipo, @fecha
    end

    close c_asiento_fecha
    deallocate c_asiento_fecha

  /*- ///////////////////////////////////////////////////////////////////////
  
  COMPRAS Y VENTAS
  
  /////////////////////////////////////////////////////////////////////// */

  declare @us_nombre varchar(50)
  select @us_nombre from Usuario where us_id = @@us_id

  insert into  #t_DC_CSC_CON_0240 

      select 
            0             as comp_id,
            0             as doct_id,
            0             as [Número],
            ejcas_nrodoc          as [Comprobante],

            'Asiento Resumen'      as [Documento],
            t.fecha                as [Fecha],
      
            case t.tipo
              when 1 then 'FV'     
              when 2 then 'FC'
            end                    as [Código Doc.],
      
            case t.tipo
              when 1 then 'Ventas'     
              when 2 then 'Compras'
            end                   as [Tipo Doc.],
            
            ''                    as [Documento Aux],
            emp_nombre            as [Empresa],
      
            getdate()              as [Creado],
            getdate()              as [Modificado],
            @us_nombre            as [Modifico],
      
      
            cue_nombre            as Cuenta,
            case 
              when sum(asi_debe-asi_haber) > 0 then sum(asi_debe-asi_haber)
              else                                  0  
            end                    as Debe,

            case 
              when sum(asi_debe-asi_haber) < 0 then abs(sum(asi_debe-asi_haber))
              else                                  0  
            end                    as Haber,
      
            'Asiento Resumen de Ventas'            
                                  as [Observaciones]
      
      from 
      
            asiento ast

                    inner join t_DC_CSC_CON_0240 t on ast.as_id = t.as_id

                    inner join EjercicioAsientoResumen ejcas on   ejcas_tipo   = t.tipo
                                                              and ejc_id      = @@ejc_id
                                                              and ejcas_fecha = t.fecha      
      
                    inner join empresa     emp  on doc.emp_id   = emp.emp_id
                    inner join asientoItem asi  on ast.as_id    = asi.as_id
                    inner join cuenta      cue  on asi.cue_id   = cue.cue_id
      
--       where 
--                 as_fecha >= @@Fini
--             and  as_fecha <= @@Ffin 
--       
--             and (ast.doct_id_cliente not in (2,8,10) or @tipo_fc = 3)
--             and (ast.doct_id_cliente not in (1,7,9)  or @tipo_fv = 3)
--       
--       -- Validar usuario - empresa
--       and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
--       
--       and   (@cue_id = 0 or exists(select as_id from AsientoItem where as_id = ast.as_id and asi.cue_id = @cue_id))
--       and   (@mon_id = 0 or exists(select as_id from AsientoItem where as_id = ast.as_id and asi.mon_id = @mon_id))
--       
--       and   (doc.emp_id   = @emp_id   or @emp_id  =0)
--       and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id  =0)
--       and   (ast.doc_id   = @doc_id   or @doc_id  =0)
--       
--       -- Arboles
--       and   ((exists(select as_id from AsientoItem where as_id = ast.as_id and (exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = cue_id)))) or (@ram_id_cuenta = 0))      
--       and   ((exists(select as_id from AsientoItem where as_id = as_id and (exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 12 and rptarb_hojaid = mon_id))))or (@ram_id_moneda = 0))      
--       and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_empresa = 0))
--       and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id))) or (@ram_id_circuitocontable = 0))      
--       and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 4001 and rptarb_hojaid = ast.doc_id)) or (@ram_id_documento = 0))

  end

/*- ///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

      select 
            ast.as_id             as comp_id,
            ast.doct_id           as doct_id,
            as_numero             as [Número],
            as_nrodoc              as [Comprobante],
            doc.doc_nombre        as [Documento],
            as_fecha              as [Fecha],
      
            (select doct_codigo from DocumentoTipo where doct_id = ast.doct_id_cliente)
                                  as [Código Doc.],
      
            (select doct_nombre from DocumentoTipo where doct_id = ast.doct_id_cliente)
                                  as [Tipo Doc.],
            
            as_doc_cliente        as [Documento Aux],
            emp_nombre            as [Empresa],
      
            ast.Creado,
            ast.Modificado,
            us_nombre             as [Modifico],
      
      
            cue_nombre            as Cuenta,
            asi_debe              as Debe,
            asi_haber             as Haber,
      
            as_descrip            as [Observaciones]
      
      from 
      
            asiento ast
      
                    inner join documento  doc    on ast.doc_id         = doc.doc_id
                    left  join documento   doccl on ast.doc_id_cliente = doccl.doc_id
      
                    inner join usuario     us   on ast.modifico = us.us_id
                    inner join empresa     emp  on doc.emp_id   = emp.emp_id
                    inner join asientoItem asi  on ast.as_id    = asi.as_id
                    inner join cuenta      cue  on asi.cue_id   = cue.cue_id
      
      where 
                as_fecha >= @@Fini
            and  as_fecha <= @@Ffin 
      
            and (ast.doct_id_cliente not in (2,8,10) or @tipo_fc = 3)
            and (ast.doct_id_cliente not in (1,7,9)  or @tipo_fv = 3)
      
      -- Validar usuario - empresa
            and (
                  exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                )
      
      /* -///////////////////////////////////////////////////////////////////////
      
      INICIO SEGUNDA PARTE DE ARBOLES
      
      /////////////////////////////////////////////////////////////////////// */
      
      and   (  @cue_id = 0
             or
               exists(select as_id from AsientoItem 
                      where as_id = ast.as_id 
                        and asi.cue_id = @cue_id
                      )       
            )
      
      
      and   (  @mon_id = 0
             or
               exists(select as_id from AsientoItem 
                      where as_id = ast.as_id 
                        and asi.mon_id = @mon_id
                      )       
            )
      
      and   (doc.emp_id   = @emp_id   or @emp_id  =0)
      
      and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id  =0)
      
      and   (ast.doc_id   = @doc_id   or @doc_id  =0)
      
      -- Arboles
      
      and   (
                (exists(select as_id from AsientoItem
                        where as_id = ast.as_id
                          and (
                                exists(select rptarb_hojaid 
                                       from rptArbolRamaHoja 
                                       where rptarb_cliente = @clienteID
                                         and tbl_id = 17 
                                         and rptarb_hojaid = cue_id
                                       ) 
                              )
                        )
                 )
              or 
                 (@ram_id_cuenta = 0)
             )
      
      and   (
                (exists(select as_id from AsientoItem
                        where as_id = as_id
                          and (
                                exists(select rptarb_hojaid 
                                       from rptArbolRamaHoja 
                                       where rptarb_cliente = @clienteID
                                         and tbl_id = 12 
                                         and rptarb_hojaid = mon_id
                                       ) 
                              )
                        )
                 )
              or 
                 (@ram_id_moneda = 0)
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
                 (@ram_id_empresa = 0)
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
                        and  tbl_id = 4001
                        and  rptarb_hojaid = ast.doc_id
                       ) 
                 )
              or 
                 (@ram_id_documento = 0)
             )
      
      union
      
      select 
      
            as_id,
            as_numero,
            as_nrodoc,
            doc_nombre,
            as_fecha,
            codigo_doc,
            tipo_doc,
      
            as_doc_cliente,
            emp_nombre,
      
            creado,
            modificado,
            modifico,      
      
            cue_nombre,
            asi_debe,
            asi_haber,
      
            as_descrip
      
      from #t_DC_CSC_CON_0240
      
      
      order by Fecha, Comprobante, Debe desc

end
GO