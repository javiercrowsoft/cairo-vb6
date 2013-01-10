-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre:
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0080]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0080]

GO

/*
1- obtengo cuantas unidades de cada componente se necesitan
2- obtengo cuantas unidades hay en stock
3- informo cuanto falta y cuanto hay (ambas en kits y en unidades)
select * from producto where pr_eskit <> 0
DC_CSC_STK_0080 
                      1,
                      '20200101',
                      '255',
                      30,
                      '0',
                      '0',
                      '0'
*/

create procedure DC_CSC_STK_0080 (

  @@us_id    int,
  @@Ffin      datetime,

@@pr_id      varchar(255),
@@cantidad   int,
@@depl_id    varchar(255),
@@depf_id     varchar(255),
@@suc_id     varchar(255), -- TODO:EMPRESA
@@emp_id     varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  set nocount on

declare @pr_id int
declare @depl_id int
declare @depf_id int
declare @suc_id int
declare @emp_id   int -- TODO:EMPRESA

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int
declare @ram_id_Sucursal int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

declare @pr_nombrekit varchar(255)

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out -- TODO:EMPRESA

exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

  raiserror ('@@ERROR_SP:No se puede indicar una carpeta de productos para este reporte. Debe indicar un unico producto que sea un Kit para poder ejecutar este reporte.', 16, 1)
  Goto fin

end

if @ram_id_DepositoLogico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
  end else 
    set @ram_id_DepositoLogico = 0
end

if @ram_id_DepositoFisico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoFisico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoFisico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoFisico, @clienteID 
  end else 
    set @ram_id_DepositoFisico = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

-- TODO:EMPRESA
if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


/*- ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////// */

-- 1- obtengo cuantas unidades de cada componente se necesitan

  create table #KitItems      (
                                pr_id int not null, 
                                nivel int not null
                              )

  create table #KitItemsSerie(
                                pr_id_kit       int null,
                                cantidad         decimal(18,6) not null,
                                pr_id           int not null, 
                                prk_id           int not null,
                                nivel           smallint not null default(0)
                              )

  exec sp_StockProductoGetKitInfo @pr_id, 0

-- 2- obtengo cuantas unidades hay en stock


-- Articulos que no estan en un kit

create table #KitItemsInStock (pr_id int not null, cantidad decimal(18,6) not null)
insert into #KitItemsInStock (pr_id, cantidad)

select 
        p.pr_id,
        IsNull(sum(sti_ingreso)  - sum(sti_salida),0)
from

      Stock   inner join StockItem sti              on Stock.st_id     = sti.st_id
              inner join Documento doc              on Stock.doc_id   = doc.doc_id
              inner join Empresa                    on doc.emp_id     = Empresa.emp_id -- TODO:EMPRESA
              inner join DepositoLogico d           on sti.depl_id     = d.depl_id  
              inner join Producto p                 on sti.pr_id       = p.pr_id
              inner join DepositoFisico df          on d.depf_id      = df.depf_id
              inner join Sucursal s                 on Stock.suc_id   = s.suc_id
              inner join #KitItemsSerie kis         on p.pr_id        = kis.pr_id

where 

          st_fecha <= @@Ffin 
      and  sti.pr_id_kit is null
-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
        )

-- Discrimino depositos internos
      and (d.depl_id <> -2 and d.depl_id <> -3)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (d.depl_id = @depl_id or @depl_id=0)
and   (df.depf_id = @depf_id or @depf_id=0)
and   (s.suc_id = @suc_id or @suc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = sti.depl_id
                 ) 
           )
        or 
           (@ram_id_DepositoLogico = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.depf_id
                 ) 
           )
        or 
           (@ram_id_DepositoFisico = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Stock.suc_id
                 ) 
           )
        or 
           (@ram_id_Sucursal = 0)
       )
-- TODO:EMPRESA
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by     

        p.pr_id


-- 3- informo cuanto falta y cuanto hay (ambas en kits y en unidades)

select @pr_nombrekit = pr_nombrecompra from producto where pr_id = @pr_id

select   kis.pr_id, 
        @@cantidad                  as [Cant a Producir],
        @pr_nombrekit               as [Articulo Kit],
        pr_nombrecompra             as [Articulo Compra],
        pr_nombreventa              as [Articulo Venta],
        pr_reposicion               as [Punto de Reposición],
        pr_stockminimo              as [Sotck Minimo],
        pr_stockmaximo              as [Stock Maximo],
        un_nombre                    as [Unidad],
        kis.cantidad * @@cantidad   as [Cant. Necesaria],
        kist.cantidad                as [Cant. en Stock], 
        case 
          when kis.cantidad * @@cantidad - IsNull(kist.cantidad,0) > 0 then kis.cantidad * @@cantidad - IsNull(kist.cantidad,0)
          else 0
        end                          as [Cant. a Comprar] 

from #KitItemsSerie kis left join #KitItemsInStock kist on kis.pr_id = kist.pr_id
                         inner join Producto p on kis.pr_id = p.pr_id
                        inner join Unidad   u on p.un_id_compra = u.un_id

-- create table #KitNecesidad(
--                             pr_id int not null, 
--                             cantidadStock decimal(18,6) not null, 
--                             cantidadComprar decimal(18,6) not null
--                           )
-- 
-- declare c_necesidad insensitive cursor for select pr_id, cantidad from #KitItemsSerie
-- 
-- open 
-- 
-- select * from #KitItemsSerie
-- select * from #KitItemsInStock

fin:
GO