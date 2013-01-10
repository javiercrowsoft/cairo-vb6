/*---------------------------------------------------------------------
Nombre: Prespuesto Financiero
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0170]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0170]

-- exec [DC_CSC_TSR_0170] 1,'20090101 00:00:00','20091231 00:00:00','N69261',13,30,22,9,29,35

go
create procedure DC_CSC_TSR_0170 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@pr_id      varchar(255),

  @@ccos_id1  int,
  @@ccos_id2  int,
  @@ccos_id3  int,
  @@ccos_id4  int,
  @@ccos_id5  int,

  @@impuestos decimal(18,6)


)as 

begin

set nocount on

/*

1- Debemos crear una tabla con tres columnas para meses (por que en la hoja solo entran 3)
    y 6 centros de costos por mes (siempre pensando en la hoja)

2- Debo declarar 5 variables para los centros de costo. Todos los demas centros de costos
   van a ir en 'otros centros de costo'

3- Debo crear una tabla con los pr_id de costos fijos (para filtrarlos de los costos variables)

4- Obtengo todos los costos variables agrupados por centro de costo

5- Obtengo todos los costos fijos (salen del parametro @@pr_id) y de facturacompra

6- Obtengo todas las ventas por centro de costo (no me importa el producto)

7- Cargo la tabla de resultados

8- Presento la info

*/


/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  declare @pr_id_param int
  declare @ram_id_producto int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@pr_id, @pr_id_param out,  @ram_id_producto out
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
    end else 
      set @ram_id_producto = 0
  end

/*- ///////////////////////////////////////////////////////////////////////

CODIGO DEL REPORTE

/////////////////////////////////////////////////////////////////////// */

-- 1- Debemos crear una tabla con tres columnas para meses (por que en la hoja solo entran 3)
--     y 6 centros de costos por mes (siempre pensando en la hoja)

create table #t_meses(

                        grupo_id        int, -- 1 Ingresos 
                                             -- 2 Gastos Variables 
                                             -- 3 Gastos Fijos

                        concepto_id     int,
                        concepto        varchar(255),

                        mes1            varchar(50),
                        mes2            varchar(50),
                        mes3            varchar(50),

                        ccos_id1        int,
                        ccos_id2        int,
                        ccos_id3        int,
                        ccos_id4        int,
                        ccos_id5        int,


                        mes1_ccos1        decimal(18,6) not null default(0),
                        mes1_ccos2        decimal(18,6) not null default(0),
                        mes1_ccos3        decimal(18,6) not null default(0),
                        mes1_ccos4        decimal(18,6) not null default(0),
                        mes1_ccos5        decimal(18,6) not null default(0),
                        mes1_otros        decimal(18,6) not null default(0),

                        mes2_ccos1        decimal(18,6) not null default(0),
                        mes2_ccos2        decimal(18,6) not null default(0),
                        mes2_ccos3        decimal(18,6) not null default(0),
                        mes2_ccos4        decimal(18,6) not null default(0),
                        mes2_ccos5        decimal(18,6) not null default(0),
                        mes2_otros        decimal(18,6) not null default(0),

                        mes3_ccos1        decimal(18,6) not null default(0),
                        mes3_ccos2        decimal(18,6) not null default(0),
                        mes3_ccos3        decimal(18,6) not null default(0),
                        mes3_ccos4        decimal(18,6) not null default(0),
                        mes3_ccos5        decimal(18,6) not null default(0),
                        mes3_otros        decimal(18,6) not null default(0)
                      )

-- 2- Debo declarar 5 variables para los centros de costo. Todos los demas centros de costos
--    van a ir en 'otros centros de costo'

declare @ccos_id int
declare @mes     varchar(7)
declare @importe decimal(18,6)

declare @concepto_id int
declare @concepto    varchar(255)

declare @ccos_id1 int
declare @ccos_id2 int
declare @ccos_id3 int
declare @ccos_id4 int
declare @ccos_id5 int

set @ccos_id1 = case when @@ccos_id1 <> 0 then @@ccos_id1 else -1 end
set @ccos_id2 = case when @@ccos_id2 <> 0 then @@ccos_id2 else -1 end
set @ccos_id3 = case when @@ccos_id3 <> 0 then @@ccos_id3 else -1 end
set @ccos_id4 = case when @@ccos_id4 <> 0 then @@ccos_id4 else -1 end
set @ccos_id5 = case when @@ccos_id5 <> 0 then @@ccos_id5 else -1 end

-- 3- Debo crear una tabla con los pr_id de costos fijos (para filtrarlos de los costos variables)
--

create table #t_pr_cf(pr_id int)

insert into #t_pr_cf (pr_id)

  select pr_id 
  from Producto
  where (pr_id = @pr_id_param or @pr_id_param  =0)
    and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 30 and  rptarb_hojaid = pr_id))or (@ram_id_producto = 0))



-- 4- Obtengo todos los costos variables agrupados por centro de costo
--

create table #t_costos_variables (pr_id int, ccos_id int, importe decimal(18,6), mes varchar(10))
create table #t_costos_variables_aux (pr_id int, ccos_id int, importe decimal(18,6), mes varchar(10))

insert into #t_costos_variables_aux(pr_id, ccos_id, importe, mes)

  select   fci.pr_id, 
          isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), 
          sum(fci_importe * fcd_importe / fc_total),
          convert(varchar(7),fcd_fecha,111)

  from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
                        inner join Producto pr on fci.pr_id = pr.pr_id
                        inner join FacturaCompraDeuda fcd on fc.fc_id = fcd.fc_id
  where fcd_fecha between @@Fini and @@Ffin
    and fci.pr_id not in (select pr_id from #t_pr_cf)
    and fc_total <> 0
    and est_id <> 7

  group by fci.pr_id, isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), convert(varchar(7),fcd_fecha,111)

  union all

  select   fci.pr_id, 
          isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), 
          sum(fci_importe * fcp_importe / fc_total),
          convert(varchar(7),fcp_fecha,111)

  from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
                        inner join Producto pr on fci.pr_id = pr.pr_id
                        inner join FacturaCompraPago fcp on fc.fc_id = fcp.fc_id
  where fcp_fecha between @@Fini and @@Ffin
    and fci.pr_id not in (select pr_id from #t_pr_cf)
    and fc_total <> 0
    and est_id <> 7

  group by fci.pr_id, isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), convert(varchar(7),fcp_fecha,111)

insert into #t_costos_variables(pr_id, ccos_id, importe, mes)

  select pr_id, ccos_id, sum(importe), mes
  from #t_costos_variables_aux
  group by pr_id, ccos_id, mes

-- 5- Obtengo todos los costos fijos (salen del parametro @@pr_id) y de facturacompra
-- 
create table #t_costos_fijos (pr_id int, ccos_id int, importe decimal(18,6), mes varchar(10))
create table #t_costos_fijos_aux (pr_id int, ccos_id int, importe decimal(18,6), mes varchar(10))

insert into #t_costos_fijos_aux(pr_id, ccos_id, importe, mes)

  select   fci.pr_id, 
          isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), 
          sum(fci_importe * fcd_importe / fc_total),
          convert(varchar(7),fcd_fecha,111)

  from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
                        inner join Producto pr on fci.pr_id = pr.pr_id
                        inner join FacturaCompraDeuda fcd on fc.fc_id = fcd.fc_id
  where fc_fecha between @@Fini and @@Ffin
    and fci.pr_id in (select pr_id from #t_pr_cf)
    and fc_total <> 0
    and est_id <> 7

  group by fci.pr_id, isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), convert(varchar(7),fcd_fecha,111)

  union all

  select   fci.pr_id, 
          isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), 
          sum(fci_importe * fcp_importe / fc_total),
          convert(varchar(7),fcp_fecha,111)

  from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
                        inner join Producto pr on fci.pr_id = pr.pr_id
                        inner join FacturaCompraPago fcp on fc.fc_id = fcp.fc_id
  where fcp_fecha between @@Fini and @@Ffin
    and fci.pr_id in (select pr_id from #t_pr_cf)
    and fc_total <> 0
    and est_id <> 7

  group by fci.pr_id, isnull(isnull(fci.ccos_id,fc.ccos_id),pr.ccos_id_compra), convert(varchar(7),fcp_fecha,111)

insert into #t_costos_fijos(pr_id, ccos_id, importe, mes)

  select pr_id, ccos_id, sum(importe), mes
  from #t_costos_fijos_aux
  group by pr_id, ccos_id, mes
-- 6- Obtengo todas las ventas por centro de costo (no me importa el producto)
--
create table #t_ventas (ccos_id int, importe decimal(18,6), mes varchar(10))
create table #t_ventas_aux (ccos_id int, importe decimal(18,6), mes varchar(10))

insert into #t_ventas_aux(ccos_id, importe, mes)

  select   isnull(isnull(fvi.ccos_id,fv.ccos_id),pr.ccos_id_venta), 
          sum(fvi_importe*fvd_importe/fv_total),
          convert(varchar(7),fvd_fecha,111)

  from FacturaVenta fv inner join FacturaVentaItem fvi on fv.fv_id = fvi.fv_id
                       inner join Producto pr on fvi.pr_id = pr.pr_id
                       inner join FacturaVentaDeuda fvd on fv.fv_id = fvd.fv_id
  where fvd_fecha between @@Fini and @@Ffin and fv_total <> 0
    and est_id <> 7

  group by fvi.pr_id, isnull(isnull(fvi.ccos_id,fv.ccos_id),pr.ccos_id_venta), convert(varchar(7),fvd_fecha,111)

  union all

  select   isnull(isnull(fvi.ccos_id,fv.ccos_id),pr.ccos_id_venta), 
          sum(fvi_importe*fvp_importe/fv_total),
          convert(varchar(7),fvp_fecha,111)

  from FacturaVenta fv inner join FacturaVentaItem fvi on fv.fv_id = fvi.fv_id
                       inner join Producto pr on fvi.pr_id = pr.pr_id
                       inner join FacturaVentaPago fvp on fv.fv_id = fvp.fv_id
  where fvp_fecha between @@Fini and @@Ffin and fv_total <> 0
    and est_id <> 7

  group by fvi.pr_id, isnull(isnull(fvi.ccos_id,fv.ccos_id),pr.ccos_id_venta), convert(varchar(7),fvp_fecha,111)

insert into #t_ventas (ccos_id, importe, mes)

  select ccos_id, sum(importe), mes
  from #t_ventas_aux
  group by ccos_id, mes

-- 7- Cargo la tabla de resultados
--

  -- Esto es para todos:
  --
  --    Por cada fila necesito crear tantos meses como existan entre Fini y Ffin
  --
  --      Para esto tengo el sp DC_CSC_TSR_0170_aux que recibe concepto_id, concepto, Fini y Ffin
  --      y me llena la tabla #t_meses
  --

  -- 1- Primero ingresos
  --

  declare @concepto_id_ingresos int

  set @concepto_id_ingresos = 0

  exec DC_CSC_TSR_0170_aux @@Fini, @@Ffin, 1 /*Ingresos*/, @concepto_id_ingresos, 'Ingresos', @ccos_id1, @ccos_id2, @ccos_id3, @ccos_id4, @ccos_id5

  declare c_ingresos insensitive cursor for

    select isnull(ccos_id,0), importe, mes
    from #t_ventas

  open c_ingresos
  fetch next from c_ingresos into @ccos_id, @importe, @mes
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0170_aux2 @concepto_id_ingresos, 
                              @ccos_id1,
                              @ccos_id2,
                              @ccos_id3,
                              @ccos_id4,
                              @ccos_id5,                            
                              @mes,
                              @ccos_id,
                              @importe

    fetch next from c_ingresos into @ccos_id, @importe, @mes
  end

  close c_ingresos
  deallocate c_ingresos

  -- 2- Costos Variables
  --

  declare c_costos_v insensitive cursor for

    select distinct t.pr_id, pr_nombrecompra
    from #t_costos_variables t inner join Producto pr on t.pr_id = pr.pr_id

  open c_costos_v
  
  fetch next from c_costos_v into @concepto_id, @concepto
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0170_aux @@Fini, @@Ffin, 2 /*Costos Variables*/, @concepto_id, @concepto, @ccos_id1, @ccos_id2, @ccos_id3, @ccos_id4, @ccos_id5

    fetch next from c_costos_v into @concepto_id, @concepto
  end

  close c_costos_v
  deallocate c_costos_v

  declare c_costos_v insensitive cursor for

    select pr_id, isnull(ccos_id,0), importe, mes
    from #t_costos_variables

  open c_costos_v
  fetch next from c_costos_v into @concepto_id, @ccos_id, @importe, @mes
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0170_aux2 @concepto_id, 
                              @ccos_id1,
                              @ccos_id2,
                              @ccos_id3,
                              @ccos_id4,
                              @ccos_id5,                            
                              @mes,
                              @ccos_id,
                              @importe

    fetch next from c_costos_v into @concepto_id, @ccos_id, @importe, @mes
  end

  close c_costos_v
  deallocate c_costos_v

  -- 3- Costos Fijos
  --

  declare c_costos_f insensitive cursor for

    select distinct t.pr_id, pr_nombrecompra
    from #t_costos_fijos t inner join Producto pr on t.pr_id = pr.pr_id

  open c_costos_f
  
  fetch next from c_costos_f into @concepto_id, @concepto
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0170_aux @@Fini, @@Ffin, 3 /*Costos Fijos*/, @concepto_id, @concepto, @ccos_id1, @ccos_id2, @ccos_id3, @ccos_id4, @ccos_id5

    fetch next from c_costos_f into @concepto_id, @concepto
  end

  close c_costos_f
  deallocate c_costos_f

  declare c_costos_f insensitive cursor for

    select pr_id, isnull(ccos_id,0), importe, mes
    from #t_costos_fijos

  open c_costos_f
  fetch next from c_costos_f into @concepto_id, @ccos_id, @importe, @mes
  while @@fetch_status=0
  begin

    exec DC_CSC_TSR_0170_aux2 @concepto_id, 
                              @ccos_id1,
                              @ccos_id2,
                              @ccos_id3,
                              @ccos_id4,
                              @ccos_id5,                            
                              @mes,
                              @ccos_id,
                              @importe

    fetch next from c_costos_f into @concepto_id, @ccos_id, @importe, @mes
  end

  close c_costos_f
  deallocate c_costos_f

-- 8- Presento la info
--

select t.*,

       case grupo_id
        when 1 then 'Ingresos'
        when 2 then 'Costos Variables'
        when 3 then 'Costos Fijos'
       end as Grupo,

       ccos1.ccos_codigo as ccos1,
       ccos2.ccos_codigo as ccos2,
       ccos3.ccos_codigo as ccos3,
       ccos4.ccos_codigo as ccos4,
       ccos5.ccos_codigo as ccos5

from #t_meses t 

    left join CentroCosto ccos1 on ccos1.ccos_id = @ccos_id1
    left join CentroCosto ccos2 on ccos2.ccos_id = @ccos_id2
    left join CentroCosto ccos3 on ccos3.ccos_id = @ccos_id3
    left join CentroCosto ccos4 on ccos4.ccos_id = @ccos_id4
    left join CentroCosto ccos5 on ccos5.ccos_id = @ccos_id5

order by grupo_id

end

GO