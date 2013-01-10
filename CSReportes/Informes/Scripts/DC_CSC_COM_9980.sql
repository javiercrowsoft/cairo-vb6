/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de compra
---------------------------------------------------------------------*/

/*

--select * from ProductoDepositoEntrega

[DC_CSC_COM_9980] 1,'0','0','0','0','0',2

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9980]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9980]


go
create procedure DC_CSC_COM_9980 (

  @@us_id        int,

  @@pr_id           varchar(255),
  @@depl_id          varchar(255),
  @@suc_id           varchar(255), 
  @@emp_id           varchar(255),
  @@prov_id         varchar(255),

  @@accion          smallint      /*  1 Agregar
                                      2 Borrar
                                  */

)as 
begin

  set nocount on

declare @pr_id         int
declare @depl_id       int
declare @suc_id       int
declare @emp_id        int
declare @prov_id       int

declare @ram_id_Producto         int
declare @ram_id_DepositoLogico   int
declare @ram_id_Sucursal        int
declare @ram_id_empresa          int
declare @ram_id_proveedor       int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@pr_id,        @pr_id out,         @ram_id_Producto  out
exec sp_ArbConvertId @@depl_id,      @depl_id out,       @ram_id_DepositoLogico out
exec sp_ArbConvertId @@suc_id,        @suc_id out,       @ram_id_Sucursal  out
exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_empresa   out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor out
  
exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
  end else 
    set @ram_id_Producto = 0
end

if @ram_id_DepositoLogico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
  end else 
    set @ram_id_DepositoLogico = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
end

--/////////////////////////////////////////////////////////////////////////////////////

    create table #proveedor (prov_id int)
    create table #sucursal  (suc_id  int)
    create table #empresa   (emp_id  int)
    create table #producto  (pr_id   int)
    create table #deposito  (depl_id int)

    insert into #proveedor (prov_id)
    select prov_id 
    from Proveedor
    where
        (@prov_id <> 0 or @ram_id_proveedor <> 0)
    and (prov_id = @prov_id or @prov_id = 0)
    and (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 
                  and  rptarb_hojaid = prov_id
                 ) 
           )
        or 
           (@ram_id_proveedor = 0)
       )                  

    insert into #sucursal (suc_id)
    select suc_id 
    from Sucursal
    where
           (suc_id  = @suc_id  or @suc_id=0)
      and (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1007 
                    and  rptarb_hojaid = suc_id
                   ) 
             )
          or 
             (@ram_id_Sucursal = 0)
         )

    insert into #empresa (emp_id)
    select emp_id 
    from Empresa
    where
           (emp_id = @emp_id or @emp_id = 0)
      and (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1018 
                    and  rptarb_hojaid = emp_id
                   ) 
             )
          or 
             (@ram_id_empresa = 0)
         )

    insert into #producto (pr_id)
    select pr_id 
    from Producto
    where
          (pr_id = @pr_id or @pr_id=0)
     and (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 30 
                    and  rptarb_hojaid = pr_id
                   ) 
             )
          or 
             (@ram_id_Producto = 0)
         )

    insert into #deposito (depl_id)
    select depl_id 
    from DepositoLogico
    where
          (depl_id = @depl_id or @depl_id=0)
      and (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 11 
                    and  rptarb_hojaid = depl_id
                   ) 
             )
          or 
             (@ram_id_DepositoLogico = 0)
         )


--/////////////////////////////////////////////////////////////////////////////////////

    /* Agregar */
    if @@accion = 1 begin

      if (@prov_id <> 0 or @ram_id_proveedor <> 0) begin

        insert into ProductoDepositoEntrega (pr_id, depl_id, emp_id, suc_id, prov_id)
  
        select pr_id, depl_id, emp_id, suc_id, prov_id
        from #producto, #deposito, #empresa, #sucursal, #proveedor
  
        where not exists(select * 
                         from ProductoDepositoEntrega 
                         where  pr_id      = #producto.pr_id 
                          and    depl_id    = #deposito.depl_id
                          and    emp_id    = #empresa.emp_id
                          and    suc_id    = #sucursal.suc_id
                          and    prov_id   = #proveedor.prov_id
                        )

      end else begin

        insert into ProductoDepositoEntrega (pr_id, depl_id, emp_id, suc_id, prov_id)
  
        select pr_id, depl_id, emp_id, suc_id, null
        from #producto, #deposito, #empresa, #sucursal
  
        where not exists(select * 
                         from ProductoDepositoEntrega 
                         where  pr_id      = #producto.pr_id 
                          and    depl_id    = #deposito.depl_id
                          and    emp_id    = #empresa.emp_id
                          and    suc_id    = #sucursal.suc_id
                          and    prov_id is null
                        )
      end

    end else begin

      /* Borrar */
      if @@accion = 2 begin

        if (@prov_id <> 0 or @ram_id_proveedor <> 0) begin

          Delete ProductoDepositoEntrega 
          from #producto, #deposito, #empresa, #sucursal, #proveedor
    
          where   ProductoDepositoEntrega.pr_id      = #producto.pr_id 
            and    ProductoDepositoEntrega.depl_id    = #deposito.depl_id
            and    ProductoDepositoEntrega.emp_id    = #empresa.emp_id
            and    ProductoDepositoEntrega.suc_id    = #sucursal.suc_id
            and    ProductoDepositoEntrega.prov_id    = #proveedor.prov_id

        end else begin

          Delete ProductoDepositoEntrega 
          from #producto, #deposito, #empresa, #sucursal
    
          where   ProductoDepositoEntrega.pr_id      = #producto.pr_id 
            and    ProductoDepositoEntrega.depl_id    = #deposito.depl_id
            and    ProductoDepositoEntrega.emp_id    = #empresa.emp_id
            and    ProductoDepositoEntrega.suc_id    = #sucursal.suc_id
            and    ProductoDepositoEntrega.prov_id is null

        end
      end
    end 

  select   pr.pr_id,
           pr_nombrecompra as Articulo,
          depl_nombre      as Deposito,
          emp_nombre      as Empresa,
          suc_nombre      as Sucursal,
          prov_nombre     as Proveedor,
          ''              as aux

  from ProductoDepositoEntrega t inner join Producto pr on t.pr_id = pr.pr_id
                                 inner join DepositoLogico depl on t.depl_id = depl.depl_id
                                 inner join Empresa emp on t.emp_id = emp.emp_id
                                 inner join Sucursal suc on t.suc_id = suc.suc_id
                                 left  join Proveedor prov on t.prov_id = prov.prov_id
end
go
 