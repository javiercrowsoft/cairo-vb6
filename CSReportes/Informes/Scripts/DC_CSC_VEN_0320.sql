/*---------------------------------------------------------------------
Nombre: Ventas por Vendedor, Empresa, Cliente,Carpeta, Articulo 
---------------------------------------------------------------------*/
/*  

Para testear:
select * from producto where pr_nombreventa like '%valvula%cilindro%'
sp_col rubro
DC_CSC_VEN_0320 1, '20051101','20051110','0', '0','0','120','0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0320]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0320]

go
create procedure DC_CSC_VEN_0320 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@cli_id           varchar(255),
  @@ven_id           varchar(255),
  @@pr_id             varchar(255),
  @@rub_id          varchar(255),
  @@cico_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@emp_id           varchar(255),
  @@arb_id          int = 0,
  @@bFacDirec       smallint,
  @@bSoloFac        smallint

)as 
begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pro_id       int
declare @cli_id       int
declare @ven_id       int
declare @pr_id        int
declare @rub_id        int
declare @cico_id      int
declare @doc_id       int
declare @mon_id       int
declare @emp_id       int

declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_vendedor         int
declare @ram_id_producto         int
declare @ram_id_rubro            int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@ven_id,       @ven_id out,        @ram_id_vendedor out
exec sp_ArbConvertId @@pr_id,        @pr_id out,        @ram_id_producto out
exec sp_ArbConvertId @@rub_id,        @rub_id out,        @ram_id_rubro out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out

exec sp_GetRptId @clienteID out

create table #dc_csc_ven_0320_producto (
                                        nodo_id int,
                                        nodo_2 int,
                                        nodo_3 int,
                                        nodo_4 int,
                                        nodo_5 int,
                                        nodo_6 int,
                                        nodo_7 int,
                                        nodo_8 int,
                                        nodo_9 int
                                      )


if @@arb_id = 0  select @@arb_id = min(arb_id) from arbol where tbl_id = 30 -- producto

declare @arb_nombre varchar(255)   select @arb_nombre = arb_nombre from arbol where arb_id = @@arb_id
declare @n           int           set @n = 2
declare @raiz       int

while exists(select * from rama r
             where  arb_id = @@arb_id
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_2 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_3 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_4 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_5 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_6 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_7 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_8 = r.ram_id)
                and not exists (select * from #dc_csc_ven_0320_producto where nodo_9 = r.ram_id)

                and @n <= 9
            )
begin

  if @n = 2 begin

    select @raiz = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0
    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2) 
    select ram_id, ram_id from rama where ram_id_padre = @raiz

  end else begin if @n = 3 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3) 
    select ram_id, nodo_2, ram_id 
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_2

  end else begin if @n = 4 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3, nodo_4) 
    select ram_id, nodo_2, nodo_3, ram_id
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_3

  end else begin if @n = 5 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5) 
    select ram_id, nodo_2, nodo_3, nodo_4, ram_id
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_4

  end else begin if @n = 6 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, ram_id
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_5

  end else begin if @n = 7 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, ram_id
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_6

  end else begin if @n = 8 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, ram_id
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_7

  end else begin if @n = 9 begin

    insert #dc_csc_ven_0320_producto (nodo_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, nodo_9) 
    select ram_id, nodo_2, nodo_3, nodo_4, nodo_5, nodo_6, nodo_7, nodo_8, ram_id
    from rama r inner join #dc_csc_ven_0320_producto n on r.ram_id_padre = n.nodo_8

  end
  end
  end
  end
  end
  end
  end
  end

  set @n = @n + 1

end

if @ram_id_provincia <> 0 begin

--  exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
  end else 
    set @ram_id_provincia = 0
end

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_vendedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_vendedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_vendedor, @clienteID 
  end else 
    set @ram_id_vendedor = 0
end

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_rubro <> 0 begin

--  exec sp_ArbGetGroups @ram_id_rubro, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_rubro, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_rubro, @clienteID 
  end else 
    set @ram_id_rubro = 0
end


if @ram_id_circuitoContable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
  end else 
    set @ram_id_circuitoContable = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
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


select
    ven_id,
    1               as orden_id,
    Codigo,
    Vendedor,
    Empresa,
    Cliente,

    @arb_nombre     as Nivel_1,

    nodo_2.ram_nombre    as Nivel_2,
    nodo_3.ram_nombre    as Nivel_3,
    nodo_4.ram_nombre    as Nivel_4,
    nodo_5.ram_nombre    as Nivel_5,
    nodo_6.ram_nombre    as Nivel_6,
    nodo_7.ram_nombre    as Nivel_7,
    nodo_8.ram_nombre    as Nivel_8,
    nodo_9.ram_nombre    as Nivel_9,

    Articulo,
    [Cod. Art.],

    sum (Cantidad)          as Cantidad,
    sum (Neto)              as Neto,
    sum (IVA)                as IVA,
    0                       as [Otros Impuestos],
    sum (Total)              as Total

from 

(
/*- ///////////////////////////////////////////////////////////////////////

REMITOS  

/////////////////////////////////////////////////////////////////////// */
    select
        ven.ven_id,
        1                       as orden_id,
        ven_codigo               as Codigo,
        IsNull(ven_nombre,'Clientes sin vendedor') 
                                as Vendedor,
        emp_nombre              as Empresa,
        cli_nombre              as Cliente,
        IsNull(rub_nombre,'Articulo sin rubro') 
                                as Rubro,
        pr.pr_id,
        pr_nombreventa          as Articulo,
        pr_codigo                as [Cod. Art.],

        sum (
              case rv.doct_id
                when 24     then -rvi_cantidad                 
                else              rvi_cantidad
              end
            )                    as Cantidad,
        sum (
              case rv.doct_id
                when 24     then -rvi_neto                   
                else              rvi_neto
              end
            )                    as Neto,
        sum (
              case rv.doct_id
                when 24     then  -(rvi_ivari+rvi_ivarni)
                else                rvi_ivari+rvi_ivarni
              end
            )                    as IVA,
        sum (
              case rv.doct_id
                when 24     then  -rvi_importe                
                else               rvi_importe
              end
            )                    as Total
    
    from 
    
      RemitoVenta rv  inner join remitoVentaItem rvi   on rv.rv_id    = rvi.rv_id
                      inner join producto pr           on rvi.pr_id   = pr.pr_id
                      inner join rubro rub             on pr.rub_id    = rub.rub_id
                      inner join cliente   cli         on rv.cli_id   = cli.cli_id 
                      inner join documento doc         on rv.doc_id   = doc.doc_id
                      inner join documentoTipo doct    on rv.doct_id  = doct.doct_id
                      inner join moneda    mon         on doc.mon_id  = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
                       left join vendedor   ven         on cli.ven_id  = ven.ven_id
    
    where 
               @@bSoloFac = 0

          and rv_fecha >= @@Fini
          and  rv_fecha <= @@Ffin 
          and rv.est_id <> 7
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where cli_id = rv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cli.pro_id  = @pro_id   or @pro_id=0)
    and   (rv.cli_id   = @cli_id   or @cli_id=0)
    and   (cli.ven_id  = @ven_id   or @ven_id=0)
    and   (rvi.pr_id   = @pr_id    or @pr_id=0)
    and   (pr.rub_id   = @rub_id   or @rub_id=0)
    and   (doc.cico_id = @cico_id  or @cico_id=0)
    and   (rv.doc_id   = @doc_id   or @doc_id=0)
    and   (doc.mon_id  = @mon_id   or @mon_id=0)
    and   (doc.emp_id  = @emp_id   or @emp_id=0)
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 6 
                      and  rptarb_hojaid = cli.pro_id
                     ) 
               )
            or 
               (@ram_id_provincia = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 28 
                      and  rptarb_hojaid = rv.cli_id
                     ) 
               )
            or 
               (@ram_id_cliente = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 15 
                      and  rptarb_hojaid = cli.ven_id
                     ) 
               )
            or 
               (@ram_id_vendedor = 0)
           )
 
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 30 
                      and  rptarb_hojaid = rvi.pr_id
                     ) 
               )
            or 
               (@ram_id_producto = 0)
           )

    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 5 
                      and  rptarb_hojaid = pr.rub_id
                     ) 
               )
            or 
               (@ram_id_rubro = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4001 
                      and  rptarb_hojaid = rv.doc_id
                     ) 
               )
            or 
               (@ram_id_documento = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 12 
                      and  rptarb_hojaid = doc.mon_id
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
    
    group by
    
        ven.ven_id,
        ven_codigo,
        ven_nombre,
        emp_nombre,
        cli_nombre,
        rub_nombre,
        pr_nombreventa,
        pr_codigo,
        pr.pr_id

union all

/*- ///////////////////////////////////////////////////////////////////////

NOTAS DE CREDITO / DEBITO

/////////////////////////////////////////////////////////////////////// */
    select
        ven.ven_id,
        1                       as orden_id,
        ven_codigo               as Codigo,
        IsNull(ven_nombre,'Clientes sin vendedor') 
                                as Vendedor,
        emp_nombre              as Empresa,
        cli_nombre              as Cliente,
        IsNull(rub_nombre,'Articulo sin rubro') 
                                as Rubro,
        pr.pr_id,
        pr_nombreventa          as Articulo,
        pr_codigo                as [Cod. Art.],

        sum (
              case fv.doct_id
                when 7      then -fvi_cantidad                 
                else              fvi_cantidad
              end
            )                    as Cantidad,
        sum (
              case fv.doct_id
                when 7      then -fvi_neto                   
                else              fvi_neto
              end
            )                    as Neto,
        sum (
              case fv.doct_id
                when 7      then  -(fvi_ivari+fvi_ivarni)
                else                fvi_ivari+fvi_ivarni
              end
            )                    as IVA,
        sum (
              case fv.doct_id
                when 7      then  -fvi_importe                
                else               fvi_importe
              end
            )                    as Total
    
    from 
    
      facturaventa fv inner join facturaVentaItem fvi  on fv.fv_id    = fvi.fv_id
                      inner join producto pr           on fvi.pr_id   = pr.pr_id
                      inner join rubro rub             on pr.rub_id    = rub.rub_id
                      inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                      inner join documento doc         on fv.doc_id   = doc.doc_id
                      inner join documentoTipo doct    on fv.doct_id  = doct.doct_id
                      inner join moneda    mon         on fv.mon_id   = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
                       left join vendedor   ven         on cli.ven_id  = ven.ven_id

    where 
    
              fv_fecha >= @@Fini
          and  fv_fecha <= @@Ffin 
          and fv.est_id <> 7

          and fv.doct_id in (7,9) -- Notas de credito y debito
    
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
              exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cli.pro_id  = @pro_id   or @pro_id=0)
    and   (fv.cli_id   = @cli_id   or @cli_id=0)
    and   (cli.ven_id  = @ven_id   or @ven_id=0)
    and   (fvi.pr_id   = @pr_id    or @pr_id=0) 
    and   (pr.rub_id   = @rub_id   or @rub_id=0)
    and   (doc.cico_id = @cico_id  or @cico_id=0)  
    and   (fv.doc_id   = @doc_id   or @doc_id=0)
    and   (fv.mon_id   = @mon_id   or @mon_id=0)
    and   (doc.emp_id  = @emp_id   or @emp_id=0)
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 6 
                      and  rptarb_hojaid = cli.pro_id
                     ) 
               )
            or 
               (@ram_id_provincia = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 28 
                      and  rptarb_hojaid = fv.cli_id
                     ) 
               )
            or 
               (@ram_id_cliente = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 15 
                      and  rptarb_hojaid = cli.ven_id
                     ) 
               )
            or 
               (@ram_id_vendedor = 0)
           )

    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 30 
                      and  rptarb_hojaid = fvi.pr_id
                     ) 
               )
            or 
               (@ram_id_producto = 0)
           )

      and  (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 5 
                      and  rptarb_hojaid = pr.rub_id
                     ) 
               )
            or 
               (@ram_id_rubro = 0)
          )

    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4001 
                      and  rptarb_hojaid = fv.doc_id
                     ) 
               )
            or 
               (@ram_id_documento = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 12 
                      and  rptarb_hojaid = fv.mon_id
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
    
    group by
    
        ven.ven_id,
        ven_codigo,
        ven_nombre,
        emp_nombre,
        cli_nombre,
        rub_nombre,
        pr_nombreventa,
        pr_codigo,
        pr.pr_id


union all

/*- ///////////////////////////////////////////////////////////////////////

FACTURAS DIRECTAS

/////////////////////////////////////////////////////////////////////// */
    select
        ven.ven_id,
        1                       as orden_id,
        ven_codigo               as Codigo,
        IsNull(ven_nombre,'Clientes sin vendedor') 
                                as Vendedor,
        emp_nombre              as Empresa,
        cli_nombre              as Cliente,
        IsNull(rub_nombre,'Articulo sin rubro') 
                                as Rubro,
        pr.pr_id,
        pr_nombreventa          as Articulo,
        pr_codigo                as [Cod. Art.],

        sum (
              case fv.doct_id
                when 7      then -fvi_cantidad                 
                else              fvi_cantidad
              end
            )                    as Cantidad,
        sum (
              case fv.doct_id
                when 7      then -fvi_neto                   
                else              fvi_neto
              end
            )                    as Neto,
        sum (
              case fv.doct_id
                when 7      then  -(fvi_ivari+fvi_ivarni)
                else                fvi_ivari+fvi_ivarni
              end
            )                    as IVA,
        sum (
              case fv.doct_id
                when 7      then  -fvi_importe                
                else               fvi_importe
              end
            )                    as Total
    
    from 
    
      facturaventa fv inner join facturaVentaItem fvi  on fv.fv_id    = fvi.fv_id
                      inner join producto pr           on fvi.pr_id   = pr.pr_id
                      inner join rubro rub             on pr.rub_id    = rub.rub_id
                      inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                      inner join documento doc         on fv.doc_id   = doc.doc_id
                      inner join documentoTipo doct    on fv.doct_id  = doct.doct_id
                      inner join moneda    mon         on fv.mon_id   = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
                       left join vendedor   ven         on cli.ven_id  = ven.ven_id

    where 
    
              (@@bFacDirec <> 0 or @@bSoloFac <> 0)

          and fv_fecha >= @@Fini
          and  fv_fecha <= @@Ffin 
          and fv.est_id <> 7

          and fv.doct_id = 1 -- Facturas de venta

          and (    @@bSoloFac <> 0
                or
                  not exists(select * from FacturaVentaItem fvi
                                    inner join RemitoFacturaVenta rfv
                                      on   (  
                                                 fv.fv_id  = fvi.fv_id
                                             and fv.fv_fecha >= @@Fini
                                             and fv.fv_fecha <= @@Ffin 
                                           )
                                         and    fvi.fvi_id = rfv.fvi_id

                                        and   (cli.pro_id  = @pro_id   or @pro_id=0)
                                        and   (fv.cli_id   = @cli_id   or @cli_id=0)
                                        and   (cli.ven_id  = @ven_id   or @ven_id=0)
                                        and   (fvi.pr_id   = @pr_id    or @pr_id=0)
                                        and   (pr.rub_id   = @rub_id   or @rub_id=0)
                                        and   (doc.cico_id = @cico_id  or @cico_id=0)
                                        and   (fv.doc_id   = @doc_id   or @doc_id=0)
                                        and   (fv.mon_id   = @mon_id   or @mon_id=0)
                                        and   (doc.emp_id  = @emp_id   or @emp_id=0)
                                        
                                        -- Arboles
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 6 
                                                          and  rptarb_hojaid = cli.pro_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_provincia = 0)
                                               )
                                        
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 28 
                                                          and  rptarb_hojaid = fv.cli_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_cliente = 0)
                                               )
                                        
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 15 
                                                          and  rptarb_hojaid = cli.ven_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_vendedor = 0)
                                               )
                                    
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 30 
                                                          and  rptarb_hojaid = fvi.pr_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_producto = 0)
                                               )
                                    
                                          and  (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 5 
                                                          and  rptarb_hojaid = pr.rub_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_rubro = 0)
                                              )
                                        
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 1016 
                                                          and  rptarb_hojaid = doc.cico_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_circuitoContable = 0)
                                               )
                                        
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 4001 
                                                          and  rptarb_hojaid = fv.doc_id
                                                         ) 
                                                   )
                                                or 
                                                   (@ram_id_documento = 0)
                                               )
                                        
                                        and   (
                                                  (exists(select rptarb_hojaid 
                                                          from rptArbolRamaHoja 
                                                          where
                                                               rptarb_cliente = @clienteID
                                                          and  tbl_id = 12 
                                                          and  rptarb_hojaid = fv.mon_id
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
                        )
               )
          and (
                exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
              )
          and (
                exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
              )

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cli.pro_id  = @pro_id   or @pro_id=0)
    and   (fv.cli_id   = @cli_id   or @cli_id=0)
    and   (cli.ven_id  = @ven_id   or @ven_id=0)
    and   (fvi.pr_id   = @pr_id    or @pr_id=0)
    and   (pr.rub_id   = @rub_id   or @rub_id=0)
    and   (doc.cico_id = @cico_id  or @cico_id=0)
    and   (fv.doc_id   = @doc_id   or @doc_id=0)
    and   (fv.mon_id   = @mon_id   or @mon_id=0)
    and   (doc.emp_id  = @emp_id   or @emp_id=0)
    
    -- Arboles
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 6 
                      and  rptarb_hojaid = cli.pro_id
                     ) 
               )
            or 
               (@ram_id_provincia = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 28 
                      and  rptarb_hojaid = fv.cli_id
                     ) 
               )
            or 
               (@ram_id_cliente = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 15 
                      and  rptarb_hojaid = cli.ven_id
                     ) 
               )
            or 
               (@ram_id_vendedor = 0)
           )

    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 30 
                      and  rptarb_hojaid = fvi.pr_id
                     ) 
               )
            or 
               (@ram_id_producto = 0)
           )

      and  (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 5 
                      and  rptarb_hojaid = pr.rub_id
                     ) 
               )
            or 
               (@ram_id_rubro = 0)
          )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 1016 
                      and  rptarb_hojaid = doc.cico_id
                     ) 
               )
            or 
               (@ram_id_circuitoContable = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 4001 
                      and  rptarb_hojaid = fv.doc_id
                     ) 
               )
            or 
               (@ram_id_documento = 0)
           )
    
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 12 
                      and  rptarb_hojaid = fv.mon_id
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
    
    group by
    
        ven.ven_id,
        ven_codigo,
        ven_nombre,
        emp_nombre,
        cli_nombre,
        rub_nombre,
        pr_nombreventa,
        pr_codigo,
        pr.pr_id

) as t

          left join hoja h    on     t.pr_id = h.id 
                               and h.arb_id = @@arb_id

                               -- Esto descarta la raiz
                               --
                               and not exists(select * from rama 
                                              where ram_id = ram_id_padre 
                                                and arb_id = @@arb_id 
                                                and ram_id = h.ram_id)

                               -- Esto descarta hojas secundarias
                               --
                               and not exists(select * from hoja h2 inner join rama r on h2.ram_id = r.ram_id
                                              where h2.arb_id = @@arb_id
                                                and h2.ram_id < h.ram_id
                                                and h2.ram_id <> r.ram_id_padre 
                                                and h2.id = h.id)
          
          left  join #dc_csc_ven_0320_producto nodo on h.ram_id = nodo.nodo_id
          
          left  join rama nodo_2    on nodo.nodo_2 = nodo_2.ram_id
          left  join rama nodo_3    on nodo.nodo_3 = nodo_3.ram_id
          left  join rama nodo_4    on nodo.nodo_4 = nodo_4.ram_id
          left  join rama nodo_5    on nodo.nodo_5 = nodo_5.ram_id
          left  join rama nodo_6    on nodo.nodo_6 = nodo_6.ram_id
          left  join rama nodo_7    on nodo.nodo_7 = nodo_7.ram_id
          left  join rama nodo_8    on nodo.nodo_8 = nodo_8.ram_id
          left  join rama nodo_9    on nodo.nodo_9 = nodo_9.ram_id


where Total <> 0

    group by
    
        ven_id,
        Codigo,
        Vendedor,
        Empresa,
        Cliente,
        Rubro,
        nodo_2.ram_nombre,
        nodo_3.ram_nombre,
        nodo_4.ram_nombre,
        nodo_5.ram_nombre,
        nodo_6.ram_nombre,
        nodo_7.ram_nombre,
        nodo_8.ram_nombre,
        nodo_9.ram_nombre,
        [Cod. Art.],
        Articulo


order by Vendedor, Empresa, Cliente, Rubro, [Cod. Art.], Articulo

end
go

