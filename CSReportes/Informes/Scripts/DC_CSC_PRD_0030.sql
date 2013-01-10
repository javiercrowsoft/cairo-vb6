/*---------------------------------------------------------------------
Nombre: Listar articulos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRD_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRD_0030]

/*

  [DC_CSC_PRD_0030] 1,'0','42'

*/

go
create procedure DC_CSC_PRD_0030 (

  @@us_id          int,

  @@pr_id          varchar(255),
  @@rub_id         varchar(255)

)as 

begin

  set nocount on

  declare @pr_id         int
  declare @rub_id       int
  
  declare @ram_id_Producto          int
  declare @ram_id_Rubro            int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@pr_id,        @pr_id  out,       @ram_id_Producto out
  exec sp_ArbConvertId @@rub_id,       @rub_id out,       @ram_id_Rubro out
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_Producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
    end else 
      set @ram_id_Producto = 0
  end

  if @ram_id_Rubro <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Rubro, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Rubro, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Rubro, @clienteID 
    end else 
      set @ram_id_Rubro = 0
  end

  -------------------------------------------------------------------------------  

  if @rub_id = 0 and @pr_id = 0 and @ram_id_Producto = 0 and @ram_id_Rubro = 0 

    select 1 as aux_id, 'Debe indicar un rubro o un producto como filtro' as Info, '' as dummy_col

  else

  -------------------------------------------------------------------------------  

  select 
          pr.pr_id                as pr_id,

          pr.pr_nombrecompra +'-'+ pr.pr_codigo  
                                  as pr_group, 

          pr.pr_codigo            as [Codigo Rubro],
          pr.pr_nombrecompra      as [Articulo], 
          mpr.marc_nombre          as [Marca Articulo],
          rubti_nombre            as Atributo,
          prtag.pr_codigo         as [Codigo Item],
          prtag.pr_nombrecompra    as [Itme],        
          mtag.marc_nombre        as [Marca Item],
          pr.pr_expocairo          as [Expo Cairo],
          pr.pr_expoweb           as [Expo Web],
          prt_expocairo           as [Expo Cairo Tag],
          prt_expoweb             as [Expo Web Tag],
          ''                       as dummy_col
  
  from Producto pr   left join productotag prt on pr.pr_id = prt.pr_id
                    left join  producto prtag on prt.pr_id_tag = prtag.pr_id
                    left join  marca mpr on pr.marc_id = mpr.marc_id
                    left join  marca mtag on pr.marc_id = mtag.marc_id
                    left join rubrotablaitem rubti on prtag.rubti_id7 = rubti.rubti_id
  
  where   
           (pr.rub_id = @rub_id   or @rub_id=0)
    and   (pr.pr_id  = @pr_id   or @pr_id=0) 

    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 5 and  rptarb_hojaid = pr.rub_id)) or (@ram_id_Rubro = 0))
    and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 30 and  rptarb_hojaid = pr.pr_id))or (@ram_id_Producto = 0))
  
  order by mpr.marc_nombre, pr_group, rubti_nombre

  
end
GO