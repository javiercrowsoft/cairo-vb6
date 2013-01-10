/*---------------------------------------------------------------------
Nombre: Crear articulo de Compra desde Cuenta
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRD_9997]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRD_9997]

/*

  DC_CSC_PRD_9997 1,0,'',0

*/

go
create procedure DC_CSC_PRD_9997 (

  @@us_id          int,

  @@pr_id          varchar(255),
  @@descrip        varchar(2000),
  @@tipo           smallint

)as 

begin

set nocount on

  declare @pr_id int
  
  declare @ram_id_Producto int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_Producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
    end else 
      set @ram_id_Producto = 0
  end

  -- Reemplazar
  --
  if @@tipo = 1 begin

    update producto set pr_gng_grupo = @@descrip 
    where (pr_id = @pr_id or @pr_id=0)
    
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30 
                        and  rptarb_hojaid = producto.pr_id
                       ) 
                 )
              or 
                 (@ram_id_Producto = 0)
             )
  end else begin

    -- Agregar
    --
    if @@tipo = 2 begin
  
      update producto set pr_gng_grupo = ltrim(pr_gng_grupo + ' ' + @@descrip)
      where (pr_id = @pr_id or @pr_id=0)
      
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 30 
                          and  rptarb_hojaid = producto.pr_id
                         ) 
                   )
                or 
                   (@ram_id_Producto = 0)
               )
    end
  end

  select   pr_id,
          pr_nombrecompra as Producto,
          pr_gng_grupo    as Grupo

  from Producto
  where (pr_id = @pr_id or @pr_id=0)
  
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

  order by pr_gng_grupo, pr_nombrecompra

end
go