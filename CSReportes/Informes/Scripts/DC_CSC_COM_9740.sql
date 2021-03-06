
/*---------------------------------------------------------------------
Nombre: Compras por articulos con precio distinto a la lista de precios
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9740]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9740]

/*
DC_CSC_COM_9740 1,
                '20010101',
                '20100101',
                '0',
                '0',
                '1'
*/

go
create procedure DC_CSC_COM_9740(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cico_id          varchar(255),
  @@pr_id            varchar(255),
  @@doc_id           varchar(255),
  @@emp_id           varchar(255),
  @@prov_id         varchar(255),
  @@lp_id_param      varchar(255)
) 

as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id         int
declare @emp_id       int 
declare @cico_id      int
declare @doc_id       int
declare @prov_id       int
declare @lp_id        int

declare @ram_id_producto          int
declare @ram_id_Empresa          int 
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_Proveedor        int
declare @ram_id_listaprecio       int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id,        @pr_id out,         @ram_id_producto out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@emp_id,        @emp_id out,       @ram_id_Empresa out 
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_Proveedor out
exec sp_ArbConvertId @@lp_id_param,  @lp_id out,         @ram_id_listaprecio out

exec sp_GetRptId @clienteID out

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
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

if @ram_id_Proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
end

if @ram_id_listaprecio <> 0 begin

  select 1, 'Este reporte no permite seleccionar mas de una lista' as Info
  return

end

create table #t_DC_CSC_COM_9740 ( pr_id         int, 
                                  lp_id         int, 
                                  lp_id_comp     int, 
                                  precio_lp      decimal(18,6), 
                                  precio_comp   decimal(18,6), 
                                  comp_id       int, 
                                  doct_id       int,
                                  prov_id       int
                                )

declare @@lp_id int
set @@lp_id = @lp_id

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  declare @precio_comp   decimal(18,6)
  declare @precio_lp     decimal(18,6)
  declare @lp_id_comp   int
  declare @comp_id      int
  declare @doct_id      int

  declare c_Compras insensitive cursor for 

  select pr.pr_id, fc.lp_id, fci.fci_precio, fc.fc_id, fc.doct_id, fc.prov_id
  
  from
  
        Producto pr inner join FacturaCompraItem fci     on pr.pr_id      = fci.pr_id
                    inner join FacturaCompra fc          on fci.fc_id     = fc.fc_id
                    inner join Documento doc           on fc.doc_id    = doc.doc_id
                    inner join Empresa emp             on doc.emp_id   = emp.emp_id 
  where 
  
            fc_fecha >= @@Fini
        and  fc_fecha <= @@Ffin
  
        and fc.est_id <> 7 -- Todas menos anuladas
  
        and (
              exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
            )
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (fc.doc_id     = @doc_id   or @doc_id=0)
  and   (pr.pr_id     = @pr_id     or @pr_id=0)
  and   (doc.cico_id   = @cico_id  or @cico_id=0)
  and   (emp.emp_id   = @emp_id   or @emp_id=0) 
  and   (fc.prov_id   = @prov_id  or @prov_id=0)
  
  -- Arboles
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 30   and  rptarb_hojaid = fci.pr_id)) or (@ram_id_producto = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and  rptarb_hojaid = doc.cico_id)) or (@ram_id_circuitoContable = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))  
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID  and  tbl_id = 4001 and  rptarb_hojaid = fc.doc_id)) or (@ram_id_documento = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 29   and  rptarb_hojaid = fc.prov_id)) or (@ram_id_Proveedor = 0))

  ---------------  
  -- Remitos
  ---------------

  union all

  select pr.pr_id, rc.lp_id, rci.rci_precio, rc.rc_id, rc.doct_id, rc.prov_id
  
  from
  
        Producto pr inner join remitoCompraItem rci     on pr.pr_id      = rci.pr_id
                    inner join remitoCompra rc          on rci.rc_id     = rc.rc_id
                    inner join Documento doc           on rc.doc_id    = doc.doc_id
                    inner join Empresa emp             on doc.emp_id   = emp.emp_id 
  where 
  
            rc_fecha >= @@Fini
        and  rc_fecha <= @@Ffin
  
        and rc.est_id <> 7 -- Todas menos anuladas
  
        and (
              exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
            )
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (rc.doc_id     = @doc_id   or @doc_id=0)
  and   (pr.pr_id     = @pr_id     or @pr_id=0)
  and   (doc.cico_id   = @cico_id  or @cico_id=0)
  and   (emp.emp_id   = @emp_id   or @emp_id=0) 
  and   (rc.prov_id   = @prov_id  or @prov_id=0)  

  -- Arboles
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 30   and  rptarb_hojaid = rci.pr_id)) or (@ram_id_producto = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and  rptarb_hojaid = doc.cico_id)) or (@ram_id_circuitoContable = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))  
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID  and  tbl_id = 4001 and  rptarb_hojaid = rc.doc_id)) or (@ram_id_documento = 0))
  and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 29   and  rptarb_hojaid = rc.prov_id)) or (@ram_id_Proveedor = 0))

  open c_Compras

  fetch next from c_Compras into @pr_id, @lp_id_comp, @precio_comp, @comp_id, @doct_id, @prov_id
  while @@fetch_status = 0 begin

    if @@lp_id <> 0 set @lp_id = @@lp_id
    else            set @lp_id = @lp_id_comp

    set @precio_lp = 0
    exec sp_LpGetPrecio @lp_id, @pr_id, @precio_lp out

    if @precio_lp <> @precio_comp 
        insert into #t_DC_CSC_COM_9740 (pr_id, lp_id, lp_id_comp, precio_lp, precio_comp, comp_id, doct_id, prov_id)
                                values (@pr_id, @lp_id, @lp_id_comp, @precio_lp, @precio_comp, @comp_id, @doct_id, @prov_id)

    fetch next from c_Compras into @pr_id, @lp_id_comp, @precio_comp, @comp_id, @doct_id, @prov_id
  end

  close c_Compras
  deallocate c_Compras


  select   doc.doc_id,
          comp_id,
          t.doct_id,          
          case 

            when t.doct_id in (2,8,10) then fc_fecha
            when t.doct_id in (3, 24) then rc_fecha

          end                  as Fecha,
          doc_nombre          as Documento,
          case 

            when t.doct_id in (2,8,10) then fc_nrodoc
            when t.doct_id in (3, 24) then rc_nrodoc

          end  as Comprobante,
          
          prov_nombre          as Proveedor,
          pr_nombreCompra      as Articulo,
          lpcomp.lp_nombre    as [Lista Comprobante],
          lpparam.lp_nombre   as [Lista Parametro],
          precio_lp            as [Precio Lista Parametro],
          precio_comp         as [Precio Comprobante],
          abs(precio_lp-precio_comp)         
                              as Diferencia
          

  from #t_DC_CSC_COM_9740 t left join FacturaCompra fc on t.doct_id in (2,8,10) and t.comp_id = fc.fc_id
                            left join RemitoCompra rc  on t.doct_id in (4,25)   and t.comp_id = rc.rc_id
                            left join Proveedor prov   on t.prov_id = prov.prov_id
                            left join Producto pr      on t.pr_id  = pr.pr_id

                            left join Documento doc    on isnull(fc.doc_id,rc.doc_id) = doc.doc_id

                            left join ListaPrecio lpcomp  on t.lp_id_comp = lpcomp.lp_id
                            left join ListaPrecio lpparam on t.lp_id      = lpparam.lp_id
  

end
go