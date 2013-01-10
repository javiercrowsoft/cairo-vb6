/*---------------------------------------------------------------------
Nombre: Actualiza la Fecha de IVA y la Fecha de Asientos con el valor de fv_fecha
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9992]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9992]

/*

[DC_CSC_CON_9992] 1,1

*/

go
create procedure DC_CSC_CON_9992 (

  @@us_id        int,

  @@pr_id              varchar(255),
  @@cueg_id_compra     varchar(255),
  @@cueg_id_venta     varchar(255)

)as 
begin

  set nocount on

  declare @pr_id_param int
  declare @ram_id_Producto int

  declare @cueg_id_compra int
  declare @cueg_id_venta int
  
  declare @clienteID int
  declare @IsRaiz    tinyint

  exec sp_ArbConvertId @@pr_id, @pr_id_param out, @ram_id_Producto out
  exec sp_ArbConvertId @@cueg_id_compra, @cueg_id_compra out, 0
  exec sp_ArbConvertId @@cueg_id_venta,  @cueg_id_venta out, 0

  if @cueg_id_compra = 0 begin

    select 1 as info_id, 'Debe seleccionar un grupo de cuenta de compras' as Info, '' as dummy_col
    return
  end

  if @cueg_id_venta = 0 begin

    select 1 as info_id, 'Debe seleccionar un grupo de cuenta de ventas' as Info, '' as dummy_col
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

  declare @pr_id int

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

  open c_items

  declare @lpi_id int

  fetch next from c_items into @pr_id
  while @@fetch_status=0 
  begin

    if exists(select * from producto where pr_id = @pr_id and pr_secompra <> 0)
      update Producto set cueg_id_compra = @cueg_id_compra where pr_id = @pr_id


    if exists(select * from producto where pr_id = @pr_id and pr_sevende <> 0)
      update Producto set cueg_id_venta = @cueg_id_venta where pr_id = @pr_id

    fetch next from c_items into @pr_id
  end

  close c_items
  deallocate c_items

  select  pr.pr_id,
          pr_codigo          as Codigo,
          pr_nombrecompra   as [Nombre Compra],
          pr_nombreventa    as [Nombre Venta],
          cuec.cue_nombre    as [Cuenta Compra],
          cuev.cue_nombre    as [Cuenta Venta],
          cuegc.cueg_nombre  as [Grupo Compra],
          cuegv.cueg_nombre  as [Grupo Venta]
          
  from Producto pr left join CuentaGrupo cuegc on pr.cueg_id_compra = cuegc.cueg_id
                   left join CuentaGrupo cuegv on pr.cueg_id_venta = cuegv.cueg_id
                   left join Cuenta cuec on cuegc.cue_id = cuec.cue_id
                   left join Cuenta cuev on cuegv.cue_id = cuev.cue_id

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

end
go
 