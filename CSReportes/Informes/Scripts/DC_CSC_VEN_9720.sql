/*

DC_CSC_VEN_9720 1, '1', '0', 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9720]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9720]

go
create procedure DC_CSC_VEN_9720 (

@@us_id               int,
@@lp_id                varchar(255),
@@pr_id                varchar(255),
@@precio              decimal(18,6)

)as 
begin

  set nocount on

  declare @lp_id int
  declare @pr_id int

  declare @pr_id_param     int
  declare @ram_id_Producto int
  
  declare @clienteID   int
  declare @IsRaiz     tinyint

  exec sp_ArbConvertId @@lp_id, @lp_id out, 0
  exec sp_ArbConvertId @@pr_id, @pr_id_param out, @ram_id_Producto out


  if @lp_id = 0 begin

    select 1 as info_id, 'Debe seleccionar solo una lista de precios.' as Info

    return
  end  

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
    select pr_id from Producto 
      where (      
                      (pr_id = @pr_id_param or @pr_id_param=0)
                
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

  declare @pr_id_new int

  open c_items

  declare @lpi_id int

  fetch next from c_items into @pr_id
  while @@fetch_status=0 
  begin

    set @lpi_id = null

    select @lpi_id = lpi_id from ListaPrecioItem where lp_id = @lp_id and pr_id = @pr_id

    if @lpi_id is null begin

      if @@precio <> 0 begin

        exec sp_dbgetnewid 'ListaPrecioItem','lpi_id', @lpi_id out, 0

        insert into ListaPrecioItem (lp_id, lpi_id, pr_id, lpi_precio, modifico) values (@lp_id, @lpi_id, @pr_id, @@precio, @@us_id)

      end

    else

      if @@precio <> 0 begin

        update ListaPrecioItem set lpi_precio = @@precio, modifico = @@us_id where lpi_id = @lpi_id

      end else begin

        delete ListaPrecioItem where lpi_id = @lpi_id

      end
    end

    fetch next from c_items into @pr_id
  end

  close c_items
  deallocate c_items

  select  pr.pr_id,
          pr_codigo          as Codigo,
          pr_nombrecompra   as [Nombre Compra],
          pr_nombreventa    as [Nombre Venta],
          isnull(convert(varchar,convert(decimal(18,3),lpi_precio)),'borrado')        
                            as precio
          
  from Producto pr left join ListaPrecioItem lpi on pr.pr_id = lpi.pr_id
  where pr.pr_id in (

                    select pr_id from Producto 
                      where (      
                                      (pr_id = @pr_id_param or @pr_id_param=0)
                                
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

                  )
    and lpi.lp_id = @lp_id
end
go