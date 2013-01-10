/*---------------------------------------------------------------------
Nombre: Listar articulos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRD_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRD_0010]

/*

 DC_CSC_PRD_0010 1, '0'
select * from productotag
*/

go
create procedure DC_CSC_PRD_0010 (

  @@us_id          int,

  @@pr_id          varchar(255)

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

  --//////////////////////////////////////////////////////////////////////////////////////////////

  create table #producto_tag (pr_id int not null, tag varchar(8000) not null default(''))

  declare c_tags insensitive cursor for 

      select pr_id, prt_texto 
      from ProductoTag
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

  declare @pr_id_tag     int
  declare @last_pr_id    int
  declare @tag           varchar(8000)
  declare @tags          varchar(8000)

  set @last_pr_id = 0
  set @tags = ''

  open c_tags
  fetch next from c_tags into @pr_id_tag, @tag
  while @@fetch_status=0
  begin

    if @last_pr_id <> @pr_id_tag begin

      insert into #producto_tag (pr_id, tag) values (@last_pr_id, @tags)
      set @last_pr_id = @pr_id_tag
      set @tags = ''
    end

    set @tags = @tags + '[' + @tag + ']'

    fetch next from c_tags into @pr_id_tag, @tag
  end
  close c_tags
  deallocate c_tags

  if len(@tags)>0 begin

    insert into #producto_tag (pr_id, tag) values (@last_pr_id, @tags)

  end

  --//////////////////////////////////////////////////////////////////////////////////////////////

  select
        pr.pr_id,
        pr_codigo           as Codigo,            -- # Código
        pr_aliasweb          as [Alias Web],        -- # Alias Web
        pr_activoweb        as [Activo Web],      -- # Activo Web
        marc_nombre          as Marca,             -- # Marca
        pr_descripcompra    as [Desc. Compras],    -- # General/Compras Descripción
        rub_nombre          as Rubro,             -- # Rubro
        t1.rubti_nombre     as [Atributo 01],      -- # Tabla Rubro 1 Cod padre
        t2.rubti_nombre     as [Atributo 02],          -- # Tabla Rubro 2 Orden
        t3.rubti_nombre     as [Atributo 03],          -- # Tabla Rubro 3 Material
        t4.rubti_nombre     as [Atributo 04],          -- # Tabla Rubro 4 Color
        t5.rubti_nombre     as [Atributo 05],          -- # Tabla Rubro 5 Paginas
        t6.rubti_nombre     as [Atributo 06],          -- # Tabla Rubro 6 Tipo envase
        t7.rubti_nombre     as [Atributo 07],          -- # Tabla Rubro 7 Categoria
        t8.rubti_nombre     as [Atributo 08],
        t9.rubti_nombre     as [Atributo 09],
        t10.rubti_nombre    as [Atributo 10],
        tag.tag              as [Tags]

  from Producto pr  left join Marca marc on pr.marc_id = marc.marc_id
                    left join Rubro rub  on pr.rub_id  = rub.rub_id
                    left join RubroTablaItem t1  on pr.rubti_id1  = t1.rubti_id
                    left join RubroTablaItem t2  on pr.rubti_id2  = t2.rubti_id
                    left join RubroTablaItem t3  on pr.rubti_id3  = t3.rubti_id
                    left join RubroTablaItem t4  on pr.rubti_id4  = t4.rubti_id
                    left join RubroTablaItem t5  on pr.rubti_id5  = t5.rubti_id
                    left join RubroTablaItem t6  on pr.rubti_id6  = t6.rubti_id
                    left join RubroTablaItem t7  on pr.rubti_id7  = t7.rubti_id
                    left join RubroTablaItem t8  on pr.rubti_id8  = t8.rubti_id
                    left join RubroTablaItem t9  on pr.rubti_id9  = t9.rubti_id
                    left join RubroTablaItem t10 on pr.rubti_id10 = t10.rubti_id
                    left join #producto_tag tag  on pr.pr_id      = tag.pr_id

  where (pr.pr_id = @pr_id or @pr_id=0)
  
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 30 
                      and  rptarb_hojaid = pr.pr_id
                     ) 
               )
            or 
               (@ram_id_Producto = 0)
           )
end
go