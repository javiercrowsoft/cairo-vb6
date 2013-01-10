/*

DC_CSC_VEN_9710 1, '1', '0', 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9710]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9710]

go
create procedure DC_CSC_VEN_9710 (

@@us_id               int,
@@pr_id                varchar(255),
@@prefijocodigo       varchar(255),
@@postfijocodigo      varchar(255),

@@rubti_id1            varchar(255),
@@rubti_id2            varchar(255),
@@rubti_id3            varchar(255),
@@rubti_id4            varchar(255),
@@rubti_id5            varchar(255),
@@rubti_id6            varchar(255),
@@rubti_id7            varchar(255),
@@rubti_id8            varchar(255),
@@rubti_id9            varchar(255),
@@rubti_id10          varchar(255)


)as 
begin

  set nocount on

  create table #t_dc_csc_ven_9710 (pr_id int not null)

  declare @pr_id int

  declare @rubti_id1            int
  declare @rubti_id2            int
  declare @rubti_id3            int
  declare @rubti_id4            int
  declare @rubti_id5            int
  declare @rubti_id6            int
  declare @rubti_id7            int
  declare @rubti_id8            int
  declare @rubti_id9            int
  declare @rubti_id10            int


  declare @pr_id_param     int
  declare @ram_id_Producto int
  
  declare @clienteID   int
  declare @IsRaiz     tinyint

  exec sp_ArbConvertId @@pr_id, @pr_id_param out, @ram_id_Producto out
  
  exec sp_ArbConvertId @@rubti_id1,  @rubti_id1  out, 0
  exec sp_ArbConvertId @@rubti_id2,  @rubti_id2  out, 0
  exec sp_ArbConvertId @@rubti_id3,  @rubti_id3  out, 0
  exec sp_ArbConvertId @@rubti_id4,  @rubti_id4  out, 0
  exec sp_ArbConvertId @@rubti_id5,  @rubti_id5  out, 0
  exec sp_ArbConvertId @@rubti_id6,  @rubti_id6  out, 0
  exec sp_ArbConvertId @@rubti_id7,  @rubti_id7  out, 0
  exec sp_ArbConvertId @@rubti_id8,  @rubti_id8  out, 0
  exec sp_ArbConvertId @@rubti_id9,  @rubti_id9  out, 0
  exec sp_ArbConvertId @@rubti_id10, @rubti_id10 out, 0

  if @rubti_id1  = 0 set @rubti_id1  = null
  if @rubti_id2  = 0 set @rubti_id2  = null
  if @rubti_id3  = 0 set @rubti_id3  = null
  if @rubti_id4  = 0 set @rubti_id4  = null
  if @rubti_id5  = 0 set @rubti_id5  = null
  if @rubti_id6  = 0 set @rubti_id6  = null
  if @rubti_id7  = 0 set @rubti_id7  = null
  if @rubti_id8  = 0 set @rubti_id8  = null
  if @rubti_id9  = 0 set @rubti_id9  = null
  if @rubti_id10 = 0 set @rubti_id10 = null

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

  fetch next from c_items into @pr_id
  while @@fetch_status=0 
  begin

    exec sp_dbgetnewid 'Producto','pr_id', @pr_id_new out, 0

    -- select c.name +',' from sysobjects t inner join syscolumns c on t.id = c.id and t.name = 'producto' and t.xtype='u'

    insert into producto (

                            pr_id,
                            pr_codigo,
                            pr_nombrecompra,
                            pr_nombrefactura,
                            pr_nombreventa,
                            pr_nombreweb,

                            activo,
                            cueg_id_compra,
                            cueg_id_venta,
                            efm_id,
                            egp_id,
                            embl_id,
                            ibc_id,
                            marc_id,
                            modificado,
                            modifico,
                            pr_activoweb,
                            pr_aliasweb,
                            pr_borrado,
                            pr_cantxcajaexpo,
                            pr_codigoexterno,
                            pr_codigohtml,
                            pr_codigohtmldetalle,
                            pr_descripcompra,
                            pr_descripventa,
                            pr_dinerario,
                            pr_editarpreciohijo,
                            pr_eskit,
                            pr_eslista,
                            pr_esrepuesto,
                            pr_fleteExpo,
                            pr_id_padre,
                            pr_kitIdentidad,
                            pr_kitIdentidadXItem,
                            pr_kitItems,
                            pr_kitLote,
                            pr_kitLoteXItem,
                            pr_kitResumido,
                            pr_kitStkItem,
                            pr_llevanrolote,
                            pr_llevanroserie,
                            pr_llevastock,
                            pr_lotefifo,
                            pr_permiteedicion,
                            pr_pesoneto,
                            pr_pesototal,
                            pr_porcinternoc,
                            pr_porcinternov,
                            pr_reposicion,
                            pr_secompra,
                            pr_seproduce,
                            pr_sevende,
                            pr_stockcompra,
                            pr_stockmaximo,
                            pr_stockminimo,
                            pr_tienehijo,
                            pr_ventacompra,
                            pr_ventastock,
                            pr_x,
                            pr_y,
                            pr_z,
                            rub_id,
                            rubti_id1,
                            rubti_id2,
                            rubti_id3,
                            rubti_id4,
                            rubti_id5,
                            rubti_id6,
                            rubti_id7,
                            rubti_id8,
                            rubti_id9,
                            rubti_id10,
                            ta_id_kitLote,
                            ta_id_kitSerie,
                            ti_id_internosc,
                            ti_id_internosv,
                            ti_id_ivaricompra,
                            ti_id_ivariventa,
                            ti_id_ivarnicompra,
                            ti_id_ivarniventa,
                            un_id_compra,
                            un_id_peso,
                            un_id_stock,
                            un_id_venta
                          )

              select 
                            @pr_id_new,
                            @@prefijocodigo + pr_codigo+ @@postfijocodigo,

                            '(C)-'+pr_nombrecompra,
                            '(C)-'+pr_nombrefactura,
                            '(C)-'+pr_nombreventa,
                            '(C)-'+pr_nombreweb,

                            activo,
                            cueg_id_compra,
                            cueg_id_venta,
                            efm_id,
                            egp_id,
                            embl_id,
                            ibc_id,
                            marc_id,
                            modificado,
                            modifico,
                            pr_activoweb,
                            pr_aliasweb,
                            pr_borrado,
                            pr_cantxcajaexpo,
                            pr_codigoexterno,
                            pr_codigohtml,
                            pr_codigohtmldetalle,
                            pr_descripcompra,
                            pr_descripventa,
                            pr_dinerario,
                            pr_editarpreciohijo,
                            pr_eskit,
                            pr_eslista,
                            pr_esrepuesto,
                            pr_fleteExpo,
                            pr_id_padre,
                            pr_kitIdentidad,
                            pr_kitIdentidadXItem,
                            pr_kitItems,
                            pr_kitLote,
                            pr_kitLoteXItem,
                            pr_kitResumido,
                            pr_kitStkItem,
                            pr_llevanrolote,
                            pr_llevanroserie,
                            pr_llevastock,
                            pr_lotefifo,
                            pr_permiteedicion,
                            pr_pesoneto,
                            pr_pesototal,
                            pr_porcinternoc,
                            pr_porcinternov,
                            pr_reposicion,
                            pr_secompra,
                            pr_seproduce,
                            pr_sevende,
                            pr_stockcompra,
                            pr_stockmaximo,
                            pr_stockminimo,
                            pr_tienehijo,
                            pr_ventacompra,
                            pr_ventastock,
                            pr_x,
                            pr_y,
                            pr_z,
                            rub_id,
                            isnull(@rubti_id1, rubti_id1),
                            isnull(@rubti_id2, rubti_id2),
                            isnull(@rubti_id3, rubti_id3),
                            isnull(@rubti_id4, rubti_id4),
                            isnull(@rubti_id5, rubti_id5),
                            isnull(@rubti_id6, rubti_id6),
                            isnull(@rubti_id7, rubti_id7),
                            isnull(@rubti_id8, rubti_id8),
                            isnull(@rubti_id9, rubti_id9),
                            isnull(@rubti_id10,rubti_id10),
                            ta_id_kitLote,
                            ta_id_kitSerie,
                            ti_id_internosc,
                            ti_id_internosv,
                            ti_id_ivaricompra,
                            ti_id_ivariventa,
                            ti_id_ivarnicompra,
                            ti_id_ivarniventa,
                            un_id_compra,
                            un_id_peso,
                            un_id_stock,
                            un_id_venta

              from producto
              where pr_id = @pr_id

      insert into #t_dc_csc_ven_9710 values(@pr_id_new)

    fetch next from c_items into @pr_id
  end

  close c_items
  deallocate c_items

  select  pr.pr_id,
          pr_codigo          as Codigo,
          pr_nombreweb       as [Nombre Web],
          pr_nombrecompra   as [Nombre Compra],
          pr_nombreventa    as [Nombre Venta],
          pr_nombrefactura   as [Nombre Factura],
          ' '                as aux
          
  from Producto pr
  where pr_id in (select pr_id from #t_dc_csc_ven_9710)
end
go