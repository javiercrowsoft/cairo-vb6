/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0210]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0210]

/*
DC_CSC_STK_0210 1,619,0
*/

go
create procedure DC_CSC_STK_0210 (

  @@us_id     int,
  @@pr_id     varchar(255),
  @@prns_id   varchar(255),
  @@depl_id   varchar(255),
  @@depf_id    varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @prns_id int
declare @depl_id int
declare @depf_id int

declare @ram_id_producto int
declare @ram_id_productoserie int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_producto out
exec sp_ArbConvertId @@prns_id, @prns_id out, @ram_id_productoserie out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out

exec sp_GetRptId @clienteID out

if @@prns_id = '0' and @@pr_id = '0' and @@depl_id = '0' begin
  select 1,'Debe indicar un articulo o un numero de serie, no puede dejar los dos campos en blanco'
  return
end

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_productoserie <> 0 begin

--  exec sp_ArbGetGroups @ram_id_productoserie, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_productoserie, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_productoserie, @clienteID 
  end else 
    set @ram_id_productoserie = 0
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

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  select  sti.depl_id, 
          sti.prns_id, 
          p.pr_nombrecompra    as [Nombre Compra],
          p.pr_nombreventa     as [Nombre Venta],
          depl_nombre           as Deposito,
          prns_codigo          as [Numero Serie],
          sum(sti_ingreso-sti_salida) as Cantidad

  from stockitem sti inner join productonumeroserie prns on sti.prns_id  = prns.prns_id
                     inner join depositologico depl      on sti.depl_id  = depl.depl_id
                     inner join Producto p               on prns.pr_id   = p.pr_id
                     inner join depositofisico df        on depl.depf_id = df.depf_id

  where 

      sti.depl_id not in (-2,-3)

and   (sti.prns_id = @prns_id or @prns_id=0)
and   (sti.pr_id   = @pr_id   or prns.pr_id_kit = @pr_id or @pr_id=0)

and   (sti.depl_id  = @depl_id or @depl_id=0)
and   (df.depf_id   = @depf_id or @depf_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  (rptarb_hojaid = prns.pr_id or rptarb_hojaid = prns.pr_id_kit)
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
                  and  tbl_id = 1017 
                  and  rptarb_hojaid = sti.prns_id
                 ) 
           )
        or 
           (@ram_id_productoserie = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
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
                  and  tbl_id = 10 
                  and  rptarb_hojaid = depl.depf_id
                 ) 
           )
        or 
           (@ram_id_DepositoFisico = 0)
       )


  group by   sti.depl_id, 
            sti.prns_id, 
            prns_codigo, 
            depl_nombre,
            p.pr_nombrecompra,
            p.pr_nombreventa

  having sum(sti_ingreso-sti_salida)<>0

  order by prns_codigo

end

GO