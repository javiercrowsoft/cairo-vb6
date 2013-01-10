/*

select * from producto
Para testear:


lsProducto '0',3

select * from rama where ram_nombre = 'productos'

select * from producto
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsProducto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsProducto]

go
create procedure lsProducto (

@@pr_id      varchar(255),
@@tipo      tinyint = 0

)as 

declare @pr_id int
declare @ram_id_Producto int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out

if @ram_id_Producto <> 0 begin

  exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID

  end else begin

    set @ram_id_Producto = 0
    set @clienteID = 0
  end


end else begin

  set @clienteID = 0

end

select producto.*,
  ric=tiric.ti_nombre,
  riv=tiriv.ti_nombre,
  rnic=tirnic.ti_nombre,
  rniv=tirnic.ti_nombre,
  ic=tic.ti_nombre,
  iv=tiv.ti_nombre,
  uv=tuv.un_nombre,
  uc=tuc.un_nombre,
  us=tus.un_nombre,
  cv=tcv.cueg_nombre,
  cc=tcc.cueg_nombre,
  ibc_nombre,
  rub_nombre


from 
    Producto left join Unidad tuv on Producto.un_id_venta  = tuv.un_id
             left join Unidad tuc on Producto.un_id_compra = tuc.un_id
             left join Unidad tus on Producto.un_id_stock  = tus.un_id

             left join TasaImpositiva tiric  on Producto.ti_id_ivaricompra = tiric.ti_id
             left join TasaImpositiva tiriv  on Producto.ti_id_ivariventa  = tiriv.ti_id
             left join TasaImpositiva tirnic on Producto.ti_id_ivarnicompra= tirnic.ti_id
             left join TasaImpositiva tirniv on Producto.ti_id_ivarniventa = tirniv.ti_id
             left join TasaImpositiva tic    on Producto.ti_id_internosc   = tic.ti_id
             left join TasaImpositiva tiv    on Producto.ti_id_internosv   = tiv.ti_id
    
             left join CuentaGrupo tcv on Producto.cueg_id_venta  = tcv.cueg_id
             left join CuentaGrupo tcc on Producto.cueg_id_compra = tcc.cueg_id

             left join IngresosBrutosCategoria on Producto.ibc_id = IngresosBrutosCategoria.ibc_id

             left join Rubro on Producto.rub_id = Rubro.rub_id

where 
  
      (producto.pr_id = @pr_id or @pr_id=0)

and   (
        (
          (pr_sevende    <> 0 or @@tipo <> 1) and
          (pr_secompra   <> 0 or @@tipo <> 2) and
          (pr_llevastock <> 0 or @@tipo <> 3) 
        ) or
        (
          @@tipo = 0
        )
      )

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Producto.pr_id
                 ) 
           )
        or 
           (@ram_id_Producto = 0)
       )