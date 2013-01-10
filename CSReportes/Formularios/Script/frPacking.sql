/*

select * from producto
select * from PackingList
select * from PackingListitem

frPackingList 5

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frPackingList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frPackingList]

go
create procedure frPackingList (

  @@pklst_id      int

)
as 

begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        select 
            0 orden,
            pklsti_cajadesde,
            pklsti_cajahasta,
            pklsti_grupoexpo,
            pklsti_pesoneto,
            pklsti_pesototal,
            embl_capacidad pr_cantxcajaexpo,
            pr_codigo,
            un_nombre,
            0 cantidad,
            0 pesoneto,
            0 pesototal,
            '' embl_nombre,
            0 embl_largo,
            0 embl_ancho,
            0 embl_alto,
            0 volumen,
            0 volumenT,
            '' un_codigo,
            0 cajas,
            '' pklst_marca
            
      
        from PackingList inner join PackingListItem         on PackingList.pklst_id       = PackingListItem.pklst_id
                         inner join Producto                on PackingListItem.pr_id       = Producto.pr_id
                         inner join Unidad                  on Producto.un_id_venta       = Unidad.un_id
                         left  join Embalaje                on Producto.embl_id           = Embalaje.embl_id
                         left  join ManifiestoPackingList   on PackingListItem.pklsti_id     = ManifiestoPackingList.pklsti_id
                         left  join ManifiestoCargaItem     on ManifiestoPackingList.mfci_id = ManifiestoCargaItem.mfci_id
      
        where PackingList.pklst_id = @@pklst_id

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  union

        select 
            1 orden,
            0 pklsti_cajadesde,
            0 pklsti_cajahasta,
            '' pklsti_grupoexpo,
            0 pklsti_pesoneto,
            0 pklsti_pesototal,
            0 pr_cantxcajaexpo,
            '' pr_codigo,
            '' un_nombre,
            0 cantidad,
            0 pesoneto,
            0 pesototal,
            '' embl_nombre,
            0 embl_largo,
            0 embl_ancho,
            0 embl_alto,
            0 volumen,
            0 volumenT,
            '' un_codigo,
            0 cajas,
            pklst_marca
      
        from PackingList 
        where PackingList.pklst_id = @@pklst_id

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  union

        select 
            2  orden,
            0  pklsti_cajadesde,
            0  pklsti_cajahasta,
            '' pklsti_grupoexpo,
            0  pklsti_pesoneto,
            0  pklsti_pesototal,
            0  pr_cantxcajaexpo,
            '' pr_codigo,
            un_nombre,
            sum (pklsti_cantidad)  cantidad,
            0                      pesoneto,
            0                      pesototal,
            '' embl_nombre,
            0 embl_largo,
            0 embl_ancho,
            0 embl_alto,
            0 volumen,
            0 volumenT,
            '' un_codigo,
            0 cajas,
            '' pklst_marca
      
        from PackingList inner join PackingListItem on PackingList.pklst_id       = PackingListItem.pklst_id
                         inner join Producto        on PackingListItem.pr_id       = Producto.pr_id
                         inner join Unidad          on Producto.un_id_venta       = Unidad.un_id
      
        where PackingList.pklst_id = @@pklst_id

        group by
                    un_nombre
  
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  union

        select 
            3  orden,
            0  pklsti_cajadesde,
            0  pklsti_cajahasta,
            '' pklsti_grupoexpo,
            0  pklsti_pesoneto,
            0  pklsti_pesototal,
            0  pr_cantxcajaexpo,
            '' pr_codigo,
            '' un_nombre,
            0  cantidad,
            0  pesoneto,
            0  pesototal,
            embl_nombre,
            embl_largo,
            embl_ancho,
            embl_alto,

            embl_largo *
            embl_ancho *
            embl_alto as volumen,

            embl_largo *
            embl_ancho *
            embl_alto  *
            (sum(pklsti_cantidad)/embl_capacidad) as volumenT,

            un.un_codigo as un_codigo,
            sum(pklsti_cantidad)/embl_capacidad cajas,
            '' pklst_marca
            
      
        from PackingList inner join PackingListItem on PackingList.pklst_id       = PackingListItem.pklst_id
                         inner join Producto        on PackingListItem.pr_id       = Producto.pr_id
                         left  join Embalaje        on Producto.embl_id           = Embalaje.embl_id
                         left  join Unidad un       on Embalaje.un_id             = un.un_id
      
        where PackingList.pklst_id = @@pklst_id

        group by

            embl_nombre,
            embl_largo,
            embl_ancho,
            embl_alto,
            un.un_codigo,
            embl_capacidad

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  union

        select 
            4 orden,
            0 pklsti_cajadesde,
            0 pklsti_cajahasta,
            pklsti_grupoexpo,
            0 pklsti_pesoneto,
            0 pklsti_pesototal,
            0 pr_cantxcajaexpo,
            '' pr_codigo,
            un_nombre,
            sum (pklsti_cantidad)  cantidad,
            sum (pklsti_pesoneto)  pesoneto,
            sum (pklsti_pesototal) pesototal,
            '' embl_nombre,
            0 embl_largo,
            0 embl_ancho,
            0 embl_alto,
            0 volumen,
            0 volumenT,
            '' un_codigo,
            0 cajas,
            '' pklst_marca
      
        from PackingList inner join PackingListItem on PackingList.pklst_id       = PackingListItem.pklst_id
                         inner join Cliente         on PackingList.cli_id          = Cliente.cli_id
                         inner join Producto        on PackingListItem.pr_id       = Producto.pr_id
                         inner join Unidad          on Producto.un_id_venta       = Unidad.un_id
      
        where PackingList.pklst_id = @@pklst_id

        group by
                    pklsti_grupoexpo, un_nombre

  order by orden, pklsti_cajadesde
end
go