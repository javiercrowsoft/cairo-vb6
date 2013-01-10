/*

DC_CSC_VEN_9790 1, '1', '0', 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9790]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9790]

go
create procedure DC_CSC_VEN_9790 (

@@us_id         int,
@@catw_id       varchar(255),
@@pr_id          varchar(255),
@@agregar       smallint

)as 
begin

  set nocount on

--/////////////////////////////////////////////////////////////////////////////////
-- Arboles
--/////////////////////////////////////////////////////////////////////////////////

  declare @catw_id int

  exec sp_ArbConvertId @@catw_id, @catw_id out, 0

  if @catw_id = 0 begin
    select 1 as id_aux, 'Debe seleccionar un catalogo. No puede seleccionar una rama o multiple seleecion en el parametro catalogo. Tampoco puede dejarlo vacio.' as Info
    return
  end

  if @@agregar = 0 delete CatalogoWebItem where catw_id = @catw_id

  declare @catwi_id int

  declare @pr_id int
  declare @ram_id_Producto int
  
  declare @clienteID   int
  declare @IsRaiz     tinyint

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
  
  declare c_items insensitive cursor for 
    select pr_id from Producto pr left join Rubro rub on pr.rub_id = rub.rub_id
      where (      
                      (pr_id = @pr_id or @pr_id=0)
                
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
            )
        and (pr_sevende <> 0 or isnull(rub_escriterio,0) <> 0)

  open c_items

  fetch next from c_items into @pr_id
  while @@fetch_status=0 
  begin

    if not exists(select * from CatalogoWebItem where catw_id = @catw_id and pr_id = @pr_id)
    begin

      exec sp_dbgetnewid 'CatalogoWebItem', 'catwi_id', @catwi_id out, 0

      insert into CatalogoWebItem (catwi_id, catw_id, pr_id, catwi_activo, modifico)
                            values(@catwi_id, @catw_id, @pr_id, 1, @@us_id)
    end

    fetch next from c_items into @pr_id
  end

  close c_items
  deallocate c_items

  select  catwi.pr_id,
          pr_codigo      as Codigo,
          pr_nombreventa as Articulo,
          case when catwi_activo<>0 then 'si' else 'no' end   as Activo
  from CatalogoWebItem catwi inner join Producto pr on catwi.pr_id = pr.pr_id
  where catwi.catw_id = @catw_id

end
go