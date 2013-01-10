/*

Completen los pasos en secuencia:
1)
lsProveedor         Reemplazar por el nombre del sp ejemplo lsProyecto
2)
prov_id          Reemplazar por el nombre del pk de la tabla a listar ejemplo proy_id
3)
ram_id_Proveedor      Reemplazar por el nombre de la tabla a listar ejemplo ram_id_Proyecto (incluyan 'ram_id_')
4)
Proveedor Reemplazar por el nombre de la tabla a listar ejemplo Proyecto
5)
29      Reemplazar por el tbl_id de la tabla a listar ejemplo 2005 para la tabla proyecto. 
                  Para saber el id de la tabla a listar usen:

                        select tbl_id,tbl_nombrefisico,tbl_nombre from tabla where tbl_nombrefisico like '%Proveedor%'

Para testear:

lsProveedor 'N555'

select * from rama where ram_nombre like '%proveedor%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsProveedor]

go
create procedure lsProveedor (

@@prov_id      varchar(255)

)as 

declare @prov_id int
declare @ram_id_Proveedor int

declare @clienteID   int
declare @IsRaiz     tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out

if @ram_id_Proveedor <> 0 begin

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out

  if @IsRaiz = 0 begin

    exec sp_GetRptId @clienteID out
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID

  end else begin

    set @ram_id_Proveedor = 0
    set @clienteID = 0
  end

end else begin

  set @clienteID = 0

end

select 
    proveedor.*,
    pro_nombre,
    pa_nombre,
    cpg_nombre,
    case proveedor.activo
      when 0 then 'no'
      else 'si'
    end
  as Activos,
    case prov_catfiscal
      when 1 then 'Inscripto'
      when 2 then 'Exento'
      when 3 then 'No Inscripto'
      when 4 then 'Consumidor final'
      when 5 then 'Extranjero' 
      when 11 then 'Inscripto M'
     else 'Sin definir'    
    end
    as CatFiscal

-- Listado de columnas que corresponda  select * from provincia

from 

-- Listado de tablas que corresponda  
        Proveedor       left join provincia pro     on pro.pro_id = proveedor.pro_id
                       left join pais pa           on pro.pa_id  = pa.pa_id
                       left join condicionPago cpg on proveedor.cpg_id = cpg.cpg_id

where 
      (Proveedor.prov_id = @prov_id or @prov_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 -- tbl_id de Proveedor
                  and  rptarb_hojaid = Proveedor.prov_id
                 ) 
           )
        or 
           (@ram_id_Proveedor = 0)
       )