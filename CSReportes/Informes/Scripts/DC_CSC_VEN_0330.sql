/*---------------------------------------------------------------------
Nombre: Ranking de Ventas por Empresa, Vendedor 
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_VEN_0330 1, '20060501','20060530','0', '0','0','0','0','0','0','0',0

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0330]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0330]

go
create procedure DC_CSC_VEN_0330 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@cli_id           varchar(255),
  @@ven_id           varchar(255),
  @@pr_id           varchar(255),
  @@cico_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@emp_id           varchar(255),
  @@top             smallint,

  @@orderby         smallint

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
declare @cico_id      int
declare @doc_id       int
declare @mon_id       int
declare @emp_id       int

declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_vendedor         int
declare @ram_id_producto         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@ven_id,       @ven_id out,        @ram_id_vendedor out
exec sp_ArbConvertId @@pr_id,          @pr_id out,        @ram_id_producto out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out

exec sp_GetRptId @clienteID out

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

/*- ///////////////////////////////////////////////////////////////////////

TABLA TEMPORAL CON TODOS LOS MOVIMIENTOS

/////////////////////////////////////////////////////////////////////// */

create table #t_DC_CSC_VEN_0330(
                                pr_id          int,
                                pr_codigo     varchar(50),
                                pr_nombre     varchar(255),
                                emp_id        int,
                                emp_nombre    varchar(255),
                                rvi_cantidad  decimal(18,6),
                                rvi_neto      decimal(18,6),
                                rvi_iva        decimal(18,6),
                                rvi_importe    decimal(18,6)
                                )

insert into #t_DC_CSC_VEN_0330

    /*- ///////////////////////////////////////////////////////////////////////
    
    REMITOS
    
    /////////////////////////////////////////////////////////////////////// */
        select
            pr.pr_id,
            pr_codigo               as Codigo,
            pr_nombreVenta          as Articulo,
            emp.emp_id,
            emp_nombre              as Empresa,
            sum (
                  case 

                    when     rv.doct_id = 24

                               then  -rvi_pendientefac

                    when     rv.doct_id <> 24

                               then    rvi_pendientefac

                    else               0
                  end
                )                    as Cantidad,
            sum (
                  case 

                    when     rv.doct_id = 24
                        and rvi_importe <> 0
                               then  -rvi_neto *((rvi_pendientefac*(rvi_importe/rvi_cantidad))/rvi_importe)                 

                    when     rv.doct_id <> 24
                        and rvi_importe <> 0
                               then    rvi_neto *((rvi_pendientefac*(rvi_importe/rvi_cantidad))/rvi_importe)                 

                    else               0
                  end
                )                    as Neto,
            sum (
                  case 

                    when     rv.doct_id = 24 
                        and rvi_importe <> 0      
                                then  -(rvi_ivari+rvi_ivarni)*((rvi_pendientefac*(rvi_importe/rvi_cantidad))/rvi_importe)

                    when     rv.doct_id <> 24 
                        and rvi_importe <> 0      
                                then   (rvi_ivari+rvi_ivarni)*((rvi_pendientefac*(rvi_importe/rvi_cantidad))/rvi_importe)

                    else              0
                  end
                )                    as IVA,
            sum (
                  case 

                    when     rv.doct_id = 24      
                        and  rvi_importe <> 0
                                then  - rvi_pendientefac *((rvi_pendientefac*(rvi_importe/rvi_cantidad))/rvi_importe)         


                    when     rv.doct_id <> 24      
                        and  rvi_importe <> 0
                                then    rvi_pendientefac *((rvi_pendientefac*(rvi_importe/rvi_cantidad))/rvi_importe)

                    else                0
                  end
                )                    as Total
        
        from 
        
          RemitoVenta rv  inner join remitoventaitem rvi   on rv.rv_id    = rvi.rv_id
                          inner join cliente   cli         on rv.cli_id   = cli.cli_id 
                          inner join documento doc         on rv.doc_id   = doc.doc_id
                          inner join empresa   emp         on doc.emp_id  = emp.emp_id
                          inner join producto pr           on rvi.pr_id   = pr.pr_id
        
        where 
        
                  rv_fecha >= @@Fini
              and  rv_fecha <= @@Ffin 
              and rv.est_id <> 7
              and rvi.rvi_pendientefac <> 0
        
              and (
                    exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                  )
        
        /* -///////////////////////////////////////////////////////////////////////
        
        INICIO SEGUNDA PARTE DE ARBOLES
        
        /////////////////////////////////////////////////////////////////////// */
        
        and   (cli.pro_id  = @pro_id   or @pro_id=0)
        and   (rv.cli_id   = @cli_id   or @cli_id=0)
        and   (cli.ven_id  = @ven_id   or @ven_id=0)
        and   (doc.cico_id = @cico_id  or @cico_id=0)
        and   (rv.doc_id   = @doc_id   or @doc_id=0)
        and   (rvi.pr_id   = @pr_id    or @pr_id=0)
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
        
            emp.emp_id,
            emp_nombre,
            pr.pr_id,
            pr_codigo,
            pr_nombreVenta
    
    union all
    
    /*- ///////////////////////////////////////////////////////////////////////
    
    NOTAS DE CREDITO / DEBITO
    
    /////////////////////////////////////////////////////////////////////// */
        select
            pr.pr_id,
            pr_codigo               as Codigo,
            pr_nombreVenta          as Articulo,
            emp.emp_id,
            emp_nombre              as Empresa,

            sum (
                  case 

                    when     fv.doct_id = 7

                               then  -fvi_cantidad

                    when     fv.doct_id <> 7

                               then    fvi_cantidad

                    else               0
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
        
          facturaventa fv inner join facturaventaitem fvi  on fv.fv_id    = fvi.fv_id
                          inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                          inner join documento doc         on fv.doc_id   = doc.doc_id
                          inner join empresa   emp         on doc.emp_id  = emp.emp_id
                          inner join producto pr           on fvi.pr_id   = pr.pr_id
        
        where 
        
                  fv_fecha >= @@Fini
              and  fv_fecha <= @@Ffin 
              and fv.est_id <> 7
        
              and (
                    exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
                  )
        
        /* -///////////////////////////////////////////////////////////////////////
        
        INICIO SEGUNDA PARTE DE ARBOLES
        
        /////////////////////////////////////////////////////////////////////// */
        
        and   (cli.pro_id  = @pro_id   or @pro_id=0)
        and   (fv.cli_id   = @cli_id   or @cli_id=0)
        and   (cli.ven_id  = @ven_id   or @ven_id=0)
        and   (doc.cico_id = @cico_id  or @cico_id=0)
        and   (fv.doc_id   = @doc_id   or @doc_id=0)
        and   (fvi.pr_id   = @pr_id    or @pr_id=0)
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
        
            emp.emp_id,
            emp_nombre,
            pr.pr_id,
            pr_codigo,
            pr_nombreVenta


/*- ///////////////////////////////////////////////////////////////////////

VENTAS TOTALES POR EMPRESA

/////////////////////////////////////////////////////////////////////// */

create table #t_DC_CSC_VEN_0330_t (
                              emp_id         int,
                              rvi_neto       decimal(18,6),
                              rvi_iva        decimal(18,6),
                              rvi_importe   decimal(18,6)
                            )

insert into #t_DC_CSC_VEN_0330_t 

  select
      emp_id,
      sum (rvi_neto)            as Neto,
      sum (rvi_iva)              as IVA,
      sum (rvi_importe)          as Total
  
  from #t_DC_CSC_VEN_0330

  group by
    
        emp_id

/*- ///////////////////////////////////////////////////////////////////////

VENTAS POR VENDEDOR AGRUPADAS POR EMPRESA

/////////////////////////////////////////////////////////////////////// */

  if @@orderby =1 /*cantidad*/ begin

    select
        pr_id,
        1                       as orden_id,
        pr_codigo                as Codigo,
        pr_nombre                as Articulo,
        t1.emp_id,
        emp_nombre              as Empresa,
        sum (t1.rvi_cantidad)   as Cantidad,
        sum (t1.rvi_neto)        as Neto,
        sum (t1.rvi_iva)        as IVA,
        0                       as [Otros Impuestos],
        sum (t1.rvi_importe)    as Total,
  
        sum (t1.rvi_neto)/t2.rvi_neto          as [Neto %],
        case 
            when t2.rvi_iva = 0 then 0
            else                    sum (t1.rvi_iva)/t2.rvi_iva            
        end                                 as [IVA %],
        0                                   as [Otros Impuestos %],
        sum (t1.rvi_importe)/t2.rvi_importe        as [Total %]
    
    from #t_DC_CSC_VEN_0330 t1 inner join #t_DC_CSC_VEN_0330_t t2 on t1.emp_id = t2.emp_id
  
    group by
      
          t1.emp_id,
          emp_nombre,
          pr_id,
          pr_codigo,
          pr_nombre,
          t2.rvi_neto,
          t2.rvi_iva,
          t2.rvi_importe
  
    order by emp_nombre, Cantidad desc

  end else begin

    select
        pr_id,
        1                       as orden_id,
        pr_codigo                as Codigo,
        pr_nombre                as Articulo,
        t1.emp_id,
        emp_nombre              as Empresa,
        sum (t1.rvi_cantidad)   as Cantidad,
        sum (t1.rvi_neto)        as Neto,
        sum (t1.rvi_iva)        as IVA,
        0                       as [Otros Impuestos],
        sum (t1.rvi_importe)    as Total,
  
        sum (t1.rvi_neto)/t2.rvi_neto          as [Neto %],
        case 
            when t2.rvi_iva = 0 then 0
            else                    sum (t1.rvi_iva)/t2.rvi_iva            
        end                                 as [IVA %],
        0                                   as [Otros Impuestos %],
        sum (t1.rvi_importe)/t2.rvi_importe        as [Total %]
    
    from #t_DC_CSC_VEN_0330 t1 inner join #t_DC_CSC_VEN_0330_t t2 on t1.emp_id = t2.emp_id
  
    group by
      
          t1.emp_id,
          emp_nombre,
          pr_id,
          pr_codigo,
          pr_nombre,
          t2.rvi_neto,
          t2.rvi_iva,
          t2.rvi_importe
  
    order by emp_nombre, Total desc

  end

end
go

