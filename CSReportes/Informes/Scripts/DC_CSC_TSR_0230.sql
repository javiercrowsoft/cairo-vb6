/*---------------------------------------------------------------------
Nombre: Gastos Por Rubro
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0230]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0230]


-- exec [DC_CSC_TSR_0230] 1,'20090101 00:00:00','20091231 00:00:00', 0,'0',0

go
create procedure DC_CSC_TSR_0230 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@rub_id_inversiones   int,
  @@cue_id                varchar(255),
  @@pr_id_inc           varchar(255),
  @@pr_id_exc           varchar(255),
  @@ccos_id_exc          varchar(255),
  @@resumido            smallint

)as 

begin

set nocount on

declare @cue_id       int
declare @pr_id_inc    int
declare @pr_id_exc    int
declare @ccos_id_exc  int

declare @ram_id_cuenta             int
declare @ram_id_producto_inc      int
declare @ram_id_producto_exc      int
declare @ram_id_centrocosto_exc    int

declare @clienteID     int
declare @clienteID2   int
declare @IsRaiz        tinyint

exec sp_ArbConvertId @@cue_id,       @cue_id out,      @ram_id_cuenta out
exec sp_ArbConvertId @@pr_id_inc,    @pr_id_inc out,    @ram_id_producto_inc out
exec sp_ArbConvertId @@pr_id_exc,    @pr_id_exc out,    @ram_id_producto_exc out
exec sp_ArbConvertId @@ccos_id_exc, @ccos_id_exc out, @ram_id_centrocosto_exc out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteID2 out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

if @ram_id_producto_inc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto_inc, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto_inc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto_inc, @clienteID 
  end else 
    set @ram_id_producto_inc = 0
end

if @ram_id_producto_exc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto_exc, @clienteID2, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto_exc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto_exc, @clienteID2 
  end else 
    set @ram_id_producto_exc = 0
end

if @ram_id_centrocosto_exc <> 0 begin

--  exec sp_ArbGetGroups @ram_id_centrocosto_exc, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_centrocosto_exc, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_centrocosto_exc, @clienteID 
  end else 
    set @ram_id_centrocosto_exc = 0
end

/*

1- Debemos crear una tabla con doce columnas para meses (por que en la hoja solo entran 12)
    
2- Obtengo todos los costos por articulo de compra

3- Cargo la tabla de resultados

4- Presento la info

*/


/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id  

/*- ///////////////////////////////////////////////////////////////////////

CODIGO DEL REPORTE

/////////////////////////////////////////////////////////////////////// */

-- Debemos crear una tabla con doce columnas para meses (por que en la hoja solo entran 12)


create table #t_meses(

                        pr_id     int,
                        cue_id    int,

                        mes1            varchar(50),
                        mes2            varchar(50),
                        mes3            varchar(50),
                        mes4            varchar(50),
                        mes5            varchar(50),
                        mes6            varchar(50),
                        mes7            varchar(50),
                        mes8            varchar(50),
                        mes9            varchar(50),
                        mes10            varchar(50),
                        mes11            varchar(50),
                        mes12            varchar(50),

                        imes1            decimal(18,6) not null default(0),
                        imes2            decimal(18,6) not null default(0),
                        imes3            decimal(18,6) not null default(0),
                        imes4            decimal(18,6) not null default(0),
                        imes5            decimal(18,6) not null default(0),
                        imes6            decimal(18,6) not null default(0),
                        imes7            decimal(18,6) not null default(0),
                        imes8            decimal(18,6) not null default(0),
                        imes9            decimal(18,6) not null default(0),
                        imes10          decimal(18,6) not null default(0),
                        imes11          decimal(18,6) not null default(0),
                        imes12          decimal(18,6) not null default(0),

                        Total           decimal(18,6) not null default(0)
                      )


declare @mes       varchar(7)
declare @importe   decimal(18,6)
declare @pr_id     int

-- 2- Obtengo todos los costos por articulo de compra
--

create table #t_costos (pr_id int, cue_id int, importe decimal(18,6), mes varchar(10))

insert into #t_costos(pr_id, cue_id, importe, mes)

  select   fci.pr_id, 
          null,
          sum(case fc.doct_id when 8 then -fci_importe else fci_importe end),
          convert(varchar(7),fc_fecha,111)

  from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
  where fc_fecha between @@Fini and @@Ffin
    and est_id <> 7

    and (fci.pr_id     =  @pr_id_inc   or @pr_id_inc=0)
    and (fci.pr_id     <> @pr_id_exc   or @pr_id_exc=0)
    and (fci.ccos_id   <> @ccos_id_exc or @ccos_id_exc=0)
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 30 
                      and  rptarb_hojaid = fci.pr_id
                     ) 
               )
            or 
               (@ram_id_producto_inc = 0)
           )
    and   (
              (not 
               exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID2
                      and  tbl_id = 30 
                      and  rptarb_hojaid = fci.pr_id
                     ) 
               )
            or 
               (@ram_id_producto_exc = 0)
           )
    and   (
              (not 
               exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 21
                      and  rptarb_hojaid = fci.ccos_id
                     ) 
               )
            or 
               (@ram_id_centrocosto_exc = 0)
           )

  group by fci.pr_id, convert(varchar(7),fc_fecha,111)

  union all

  select   null, 
          perct.cue_id,
          sum(case fc.doct_id when 8 then -fcperc_importe else fcperc_importe end),
          convert(varchar(7),fc_fecha,111)

  from FacturaCompra fc inner join FacturaCompraPercepcion fcperc on fc.fc_id = fcperc.fc_id
                        inner join Percepcion perc on fcperc.perc_id = perc.perc_id
                        inner join PercepcionTipo perct on perc.perct_id = perct.perct_id
  where fc_fecha between @@Fini and @@Ffin
    and est_id <> 7

  group by perct.cue_id, convert(varchar(7),fc_fecha,111)

  union all

  select   null, 
          fcot.cue_id,
          sum(case fc.doct_id when 8 then -(fcot_debe-fcot_haber) else (fcot_debe-fcot_haber) end),
          convert(varchar(7),fc_fecha,111)

  from FacturaCompra fc inner join FacturaCompraOtro fcot on fc.fc_id = fcot.fc_id
  where fc_fecha between @@Fini and @@Ffin
    and est_id <> 7

  group by fcot.cue_id, convert(varchar(7),fc_fecha,111)

  -- Cuentas de tipo egresos tocadas en Movimientos de fondos
  --
  union all

  select   null,
          mfi.cue_id_debe,
          sum(mfi_importe),
          convert(varchar(7),mf_fecha,111)
  from MovimientoFondo mf inner join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
                          inner join Cuenta cue on mfi.cue_id_debe = cue.cue_id
  where mf_fecha between @@Fini and @@Ffin
    and est_id <> 7
    and cue.cuec_id in (5    --Bienes de Uso
                        ,6  --Bienes de Cambio
                        ,7  --Cuentas Fiscales
                        ,8  --Acreedores por Compras
                        ,9  --Ingresos
                        ,10  --Egresos
                        ,12  --Costos de Mercaderia Vendida
                        ,13  --Otros
                        ,15  --Bienes de Uso
                        ,16  --Locaciones
                        ,17  --Servicios
                        ,18  --Bienes
                        )

-- Arboles
and (mfi.cue_id_debe  = @cue_id or @cue_id=0)
and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = mfi.cue_id_debe)) or (@ram_id_cuenta = 0))

  group by mfi.cue_id_debe, convert(varchar(7),mf_fecha,111)

  -- Cuentas de tipo egresos tocadas en Movimientos de fondos
  --
  union all

  select   null,
          mfi.cue_id_haber,
          -sum(mfi_importe),
          convert(varchar(7),mf_fecha,111)
  from MovimientoFondo mf inner join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
                          inner join Cuenta cue on mfi.cue_id_haber = cue.cue_id
  where mf_fecha between @@Fini and @@Ffin
    and est_id <> 7
    and cue.cuec_id in (5    --Bienes de Uso
                        ,6  --Bienes de Cambio
                        ,7  --Cuentas Fiscales
                        ,8  --Acreedores por Compras
                        ,9  --Ingresos
                        ,10  --Egresos
                        ,12  --Costos de Mercaderia Vendida
                        ,13  --Otros
                        ,15  --Bienes de Uso
                        ,16  --Locaciones
                        ,17  --Servicios
                        ,18  --Bienes
                        )

-- Arboles
and (mfi.cue_id_haber  = @cue_id or @cue_id=0)
and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = mfi.cue_id_haber)) or (@ram_id_cuenta = 0))

  group by mfi.cue_id_haber, convert(varchar(7),mf_fecha,111)

-- 3- Cargo la tabla de resultados
-- 

  -- Esto es para todos:
  --
  --    Por cada fila necesito crear tantos meses como existan entre Fini y Ffin
  --
  --      Para esto tengo el sp DC_CSC_TSR_0230_aux que recibe concepto_id, concepto, Fini y Ffin
  --      y me llena la tabla #t_meses
  --

set @cue_id = null
set @pr_id  = null

  declare c_costos insensitive cursor for

    select distinct t.pr_id, t.cue_id
    from #t_costos t

  open c_costos
  
  fetch next from c_costos into @pr_id, @cue_id
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0230_aux @@Fini, @@Ffin, @pr_id, @cue_id

    fetch next from c_costos into @pr_id, @cue_id
  end

  close c_costos
  deallocate c_costos

  declare c_costos insensitive cursor for

    select pr_id, cue_id, importe, mes
    from #t_costos

  open c_costos
  fetch next from c_costos into @pr_id, @cue_id, @importe, @mes
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0230_aux2 @pr_id, 
                              @cue_id,
                              @mes,
                              @importe

    fetch next from c_costos into @pr_id, @cue_id, @importe, @mes
  end

  close c_costos
  deallocate c_costos

-- Actualizo la columna de totales por fila
--
  update #t_meses set total = imes1+
                              imes2+
                              imes3+
                              imes4+
                              imes5+
                              imes6+
                              imes7+
                              imes8+
                              imes9+
                              imes10+
                              imes11+
                              imes12

-- 8- Presento la info
--

select t.*,

       isnull(pr_nombrecompra,cue_nombre) 
                            as pr_nombrecompra,
       case 
          when t.pr_id is null 
              and cue_codigorpt = '' then '(sin rubro)'
          when t.pr_id is null        then cue_codigorpt 
          else                             isnull(rub_nombre,'(sin rubro)')
       end                   as rub_nombre,

       case 
          when t.pr_id is null 
              and cue_codigorpt = '' then '(sin rubro)'
          when t.pr_id is null        then cue_codigorpt 
          else                             isnull(rub_nombre,'(sin rubro)')
       end                   as group_id,

       isnull(pr.rub_id,0)   as rub_id

from #t_meses t 

    left join Producto pr on t.pr_id = pr.pr_id
    left join Cuenta cue on t.cue_id = cue.cue_id
    left join Rubro rub on pr.rub_id = rub.rub_id

order by mes1, group_id, pr_nombrecompra

end

GO