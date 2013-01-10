-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Stock por depósito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0170]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0170]

GO

/*
DC_CSC_STK_0170 
                      1,
                      '20070101',
                      '0','0','0'

select * from rama where ram_nombre like '%dvd%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_STK_0170 (

  @@us_id    int,
  @@Ffin      datetime,

  @@pr_id     varchar(255),
  @@depl_id   varchar(255),
  @@stl_id    varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

set nocount on

declare @pr_id int
declare @depl_id int
declare @stl_id int

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int
declare @ram_id_stocklote int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@stl_id, @stl_id out, @ram_id_stocklote out

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

if @ram_id_stocklote <> 0 begin

--  exec sp_ArbGetGroups @ram_id_stocklote, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_stocklote, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_stocklote, @clienteID 
  end else 
    set @ram_id_stocklote = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


declare c_stk insensitive cursor for

select distinct

        stl_id

from

      StockItem

where 


-- Discrimino depositos internos
      (depl_id <> -2 and depl_id <> -3)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (pr_id       = @pr_id     or @pr_id    =0)
and   (depl_id     = @depl_id   or @depl_id  =0)
and   (stl_id     = @stl_id   or @stl_id  =0)

-- Arboles
and   (
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

and   (
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

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  (rptarb_hojaid = pr_id or rptarb_hojaid = pr_id_kit)
                 ) 
           )
        or 
           (@ram_id_producto = 0)
       )

group by     
        stl_id,depl_id

having sum(sti_ingreso)-sum(sti_salida)>0


open c_stk

set @stl_id = null

create table #stock_stl (stl_id int, depl_id int, cantidad decimal(18,6)) 

fetch next from c_stk into @stl_id
while @@fetch_status = 0
begin

  insert into #stock_stl (stl_id, depl_id, cantidad) 

  select @stl_id, depl_id, sum(sti_ingreso)-sum(sti_salida)
  from StockItem
  where stl_id = @stl_id
    and depl_id <> -2 
    and depl_id <> -3
  group by depl_id

  fetch next from c_stk into @stl_id
end

close c_stk
deallocate c_stk

select 
        s.stl_id,
        pr_nombrecompra                       as [Artículo],
        stl.stl_codigo                        as [Lote de Stock],
        stl.stl_nroLote                       as Numero,
        stl.stl_fecha                         as Fecha,
        stl.stl_fechaVto                      as Vencimiento,
        stlp.stl_nroLote                      as [Lote Padre],
        pa_nombre                             as Pais,
        depl.depl_nombre                      as Deposito,
        un_codigo                             as Unidad,
        cantidad                              as Cantidad,
        stl.stl_descrip                        as Observaciones
from
      #stock_stl s   inner join depositologico depl         on s.depl_id         = depl.depl_id
                    inner join stocklote stl               on s.stl_id         = stl.stl_id
                    inner join producto pr                on stl.pr_id        = pr.pr_id
                    inner join unidad un                  on pr.un_id_stock   = un.un_id
                    left join stocklote stlp              on stl.stl_id_padre = stlp.stl_id
                    left join pais pa                     on stl.pa_id        = pa.pa_id
GO