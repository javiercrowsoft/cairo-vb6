-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Stock por depósito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0150]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0150]

GO

/*
DC_CSC_STK_0150 
                      1,
                      '20200101',
                      '648',
                      '12'

select * from rama where ram_nombre like '%dvd%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_STK_0150 (

  @@us_id    int,
  @@Ffin      datetime,

@@pr_id varchar(255),
@@depl_id varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @depl_id int

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out

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

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


declare c_stk insensitive cursor for

select distinct

        prns_id

from

      StockItem

where 


-- Discrimino depositos internos
      (depl_id <> -2 and depl_id <> -3)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (pr_id = @pr_id or @pr_id=0)
and   (depl_id = @depl_id or @depl_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 -- tbl_id de Proyecto
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
                  and  tbl_id = 11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = depl_id
                 ) 
           )
        or 
           (@ram_id_DepositoLogico = 0)
       )

group by     
        prns_id,depl_id

having sum(sti_ingreso)-sum(sti_salida)>0


open c_stk

declare @prns_id int

create table #stock_prns (prns_id int, depl_id int, cantidad decimal(18,6)) 

fetch next from c_stk into @prns_id
while @@fetch_status = 0
begin

  insert into #stock_prns (prns_id, depl_id, cantidad) 

  select @prns_id, depl_id, sum(sti_ingreso)-sum(sti_salida)
  from StockItem
  where prns_id = @prns_id
    and depl_id <> -2 
    and depl_id <> -3
  group by depl_id
  having sum(sti_ingreso)-sum(sti_salida)<>0

  fetch next from c_stk into @prns_id
end

close c_stk
deallocate c_stk

select 
        s.prns_id,
        pr.pr_nombrecompra                as [Artículo],
        prkit.pr_nombrecompra             as [Kit],
        prns_codigo                        as [Numero de Serie],
        depl.depl_nombre                  as Deposito,
        deplactual.depl_nombre            as [Deposito Actual],
        cantidad                          as Cantidad
from
      #stock_prns s inner join depositologico depl         on s.depl_id       = depl.depl_id
                    inner join productonumeroserie prns   on s.prns_id       = prns.prns_id
                    inner join depositologico deplactual  on prns.depl_id   = deplactual.depl_id
                    inner join producto pr                on prns.pr_id     = pr.pr_id
                    inner join producto prkit             on prns.pr_id_kit = prkit.pr_id

GO