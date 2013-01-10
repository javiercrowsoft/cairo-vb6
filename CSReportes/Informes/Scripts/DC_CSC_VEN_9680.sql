/*

select * from catalogoweb

DC_CSC_VEN_9680 1, '3'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9680]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9680]

go
create procedure DC_CSC_VEN_9680 (

@@us_id         int,
@@catw_id       varchar(255)

)as 
begin

  set nocount on

--/////////////////////////////////////////////////////////////////////////////////
-- Arboles
--/////////////////////////////////////////////////////////////////////////////////

  declare @catw_id int
  declare @ram_id_CatalogoWeb int

  exec sp_ArbConvertId @@catw_id, @catw_id out, @ram_id_CatalogoWeb out
  
  declare @clienteID   int
  declare @IsRaiz     tinyint
  
  exec sp_GetRptId @clienteID out

  if @ram_id_CatalogoWeb <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_CatalogoWeb, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_CatalogoWeb, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_CatalogoWeb, @clienteID 
    end else 
      set @ram_id_CatalogoWeb = 0
  end

  --//////////////////////////////////////////////////////////////////////////////

  declare @object int
  declare @hr int
  declare @src varchar(255), @desc varchar(255)
  exec @hr = sp_OACreate 'CSSQLArticulo.cImageValidator', @object out
  if @hr <> 0
  begin
    exec sp_OAGetErrorInfo @object, @src out, @desc out 
    select hr=convert(varbinary(4),@hr), source=@src, description=@desc
    return
  end

  --//////////////////////////////////////////////////////////////////////////////
  
  create table #t_imagenes (prwi_id int, catwi_id int)

  declare c_img insensitive cursor  for

  select distinct
          prwi.prwi_id,
          catwi.catwi_id,

          case 
                when substring(pr_webimagefolder,2,2) = ':\' then ''

                when substring(pr_webimagefolder,1,2) = '\\' then ''

                when catw_folderimage <> '' then  catw_folderimage + '\'
                else                              ''
          end 
          +
          case when pr_webimagefolder <> '' then pr_webimagefolder + '\'
          else                                   ''
          end 
          + prwi.prwi_archivo as imageFile

  from catalogoweb catw        inner join catalogowebitem catwi on catw.catw_id = catwi.catw_id
                              inner join Producto pr on catwi.pr_id = pr.pr_id
                              inner join ProductoWebImage prwi on pr.pr_id  = prwi.pr_id
  
  where (      
                  (catw.catw_id = @catw_id or @catw_id=0)
            
            -- Arboles
            and   (
                      (exists(select rptarb_hojaid 
                              from rptArbolRamaHoja 
                              where
                                   rptarb_cliente = @clienteID
                              and  tbl_id = 1035
                              and  rptarb_hojaid = catw.catw_id
                             ) 
                       )
                    or 
                       (@ram_id_CatalogoWeb = 0)
                   )
        )

  open c_img

  declare @prwi_id  int
  declare @catwi_id int
  declare @isvalid  smallint
  declare @image     varchar(500)

  fetch next from c_img into @prwi_id, @catwi_id, @image
  while @@fetch_status = 0
  begin
    
    exec @hr = sp_OAMethod @object, 'ValidateImage', @isvalid out, @image

    if @hr <> 0
    begin
      exec sp_OAGetErrorInfo @object, @src out, @desc out 
      select hr=convert(varbinary(4),@hr), source=@src, description=@desc
      return
    end

    if @isvalid = 0 begin

      insert into #t_imagenes (prwi_id, catwi_id) values(@prwi_id, @catwi_id)

    end    

    fetch next from c_img into @prwi_id, @catwi_id, @image
  end

  close c_img
  deallocate c_img

  select   pr.pr_id, 
          pr_codigo         as Codigo,
          pr_nombreventa     as Articulo, 
          pr_nombreweb       as [Nombre Web],  

          case 
                when substring(pr_webimagefolder,2,2) = ':\' then ''

                when substring(pr_webimagefolder,1,2) = '\\' then ''

                when catw_folderimage <> '' then  catw_folderimage + '\'
                else                              ''
          end 
          +
          case when pr_webimagefolder <> '' then pr_webimagefolder + '\'
          else                                   ''
          end 
          + prwi.prwi_archivo as imageFile,
          '' as dummy_col

  from catalogoweb catw        inner join catalogowebitem catwi on catw.catw_id = catwi.catw_id
                              inner join Producto pr on catwi.pr_id = pr.pr_id
                              inner join ProductoWebImage prwi on pr.pr_id  = prwi.pr_id
  where 
        prwi.prwi_id in (select prwi_id from #t_imagenes)
    and  catwi.catwi_id in (select catwi_id from #t_imagenes)

end