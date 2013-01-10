if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGet 2

create procedure sp_ProductoGet (
  @@pr_id  int
)
as

set nocount on

begin

 select
    Producto.*,
    ric=tiric.ti_nombre,
    riv=tiriv.ti_nombre,
    rnic=tirnic.ti_nombre,
    rniv=tirniv.ti_nombre,
    ic=tic.ti_nombre,
    iv=tiv.ti_nombre,
    uv=tuv.un_nombre,
    uc=tuc.un_nombre,
    us=tus.un_nombre,
    up=tup.un_nombre,
    cv=tcv.cueg_nombre,
    cc=tcc.cueg_nombre,
    marc_nombre,
    ibc_nombre,
    rub_nombre,
    rti1.rubti_nombre  as rubroi1,
    rti2.rubti_nombre  as rubroi2,
    rti3.rubti_nombre  as rubroi3,
    rti4.rubti_nombre  as rubroi4,
    rti5.rubti_nombre  as rubroi5,
    rti6.rubti_nombre  as rubroi6,
    rti7.rubti_nombre  as rubroi7,
    rti8.rubti_nombre  as rubroi8,
    rti9.rubti_nombre  as rubroi9,
    rti10.rubti_nombre as rubroi10,
    embl_nombre,
    egp_nombre,
    efm_nombre,
    tas.ta_nombre      as TalonarioSerie,
    tal.ta_nombre      as TalonarioLote,
    ley_nombre,

    ccosc.ccos_nombre  as centro_costo_compra,
    ccosv.ccos_nombre  as centro_costo_venta,
    cur_nombre,

    rptcompra.rpt_nombre     as rpt_nombrecompra,
    rptventa.rpt_nombre     as rpt_nombreventa,
    rptfactura.rpt_nombre   as rpt_nombrefactura,
    rptweb.rpt_nombre       as rpt_nombreweb,
    rptimg.rpt_nombre       as rpt_nombreimg,
    rptimgalt.rpt_nombre     as rpt_nombreimgalt,
    ticomexgan.ti_nombre    as tiComexGanancias,
    ticomexigb.ti_nombre    as tiComexIGB,
    ticomexiva.ti_nombre    as tiComexIVA,

    prwebpadre.pr_nombrecompra as webpadre,

    poar_nombre

 from
 
 Producto left join RubroTablaItem as rti1  on Producto.rubti_id1  = rti1.rubti_id    
          left join RubroTablaItem as rti2  on Producto.rubti_id2  = rti2.rubti_id    
          left join RubroTablaItem as rti3  on Producto.rubti_id3  = rti3.rubti_id    
          left join RubroTablaItem as rti4  on Producto.rubti_id4  = rti4.rubti_id    
          left join RubroTablaItem as rti5  on Producto.rubti_id5  = rti5.rubti_id    
          left join RubroTablaItem as rti6  on Producto.rubti_id6  = rti6.rubti_id    
          left join RubroTablaItem as rti7  on Producto.rubti_id7  = rti7.rubti_id    
          left join RubroTablaItem as rti8  on Producto.rubti_id8  = rti8.rubti_id    
          left join RubroTablaItem as rti9  on Producto.rubti_id9  = rti9.rubti_id    
          left join RubroTablaItem as rti10 on Producto.rubti_id10 = rti10.rubti_id    
          left join Unidad as tuv  on Producto.un_id_venta           =tuv.un_id
          left join Unidad as tuc  on Producto.un_id_compra          =tuc.un_id
          left join Unidad as tus  on Producto.un_id_stock           =tus.un_id
          left join Unidad as tup  on Producto.un_id_peso            =tup.un_id
          left join TasaImpositiva as tiric    on Producto.ti_id_ivaricompra     =tiric.ti_id 
          left join TasaImpositiva as tiriv    on Producto.ti_id_ivariventa      =tiriv.ti_id
          left join TasaImpositiva as tirnic   on Producto.ti_id_ivarnicompra    =tirnic.ti_id
          left join TasaImpositiva as tirniv   on Producto.ti_id_ivarniventa     =tirniv.ti_id
          left join TasaImpositiva as tic      on Producto.ti_id_internosc       =tic.ti_id
          left join TasaImpositiva as tiv      on Producto.ti_id_internosv       =tiv.ti_id
          left join CuentaGrupo as tcv         on Producto.cueg_id_venta         =tcv.cueg_id
          left join CuentaGrupo as tcc         on Producto.cueg_id_compra        =tcc.cueg_id
          left join IngresosBrutosCategoria    on Producto.ibc_id                =IngresosBrutosCategoria.ibc_id
          left join Rubro                      on Producto.rub_id                =Rubro.rub_id
          left join Marca                      on Producto.marc_id               =Marca.marc_id
          left join Embalaje                   on Producto.embl_id               =Embalaje.embl_id
          left join ExpoGrupoPrecio  egp       on Producto.egp_id                =egp.egp_id
          left join ExpoFamilia efm            on Producto.efm_id                =efm.efm_id
          left join Talonario tas              on Producto.ta_id_kitSerie        =tas.ta_id
          left join Talonario tal              on Producto.ta_id_kitLote         =tal.ta_id
          left join Leyenda ley                on producto.ley_id                =ley.ley_id

          left join CentroCosto ccosc          on producto.ccos_id_compra        = ccosc.ccos_id
          left join CentroCosto ccosv          on producto.ccos_id_venta         = ccosv.ccos_id

          left join Curso cur                  on producto.cur_id                = cur.cur_id

          left join Reporte rptcompra   on producto.rpt_id_nombrecompra   = rptcompra.rpt_id
          left join Reporte rptventa     on producto.rpt_id_nombreventa     = rptventa.rpt_id
          left join Reporte rptfactura   on producto.rpt_id_nombrefactura   = rptfactura.rpt_id
          left join Reporte rptweb       on producto.rpt_id_nombreweb       = rptweb.rpt_id
          left join Reporte rptimg       on producto.rpt_id_nombreimg       = rptimg.rpt_id
          left join Reporte rptimgalt   on producto.rpt_id_nombreimgalt   = rptimgalt.rpt_id

          left join TasaImpositiva ticomexgan on producto.ti_id_comex_ganancias = ticomexgan.ti_id
          left join TasaImpositiva ticomexigb on producto.ti_id_comex_igb = ticomexigb.ti_id
          left join TasaImpositiva ticomexiva on producto.ti_id_comex_iva = ticomexiva.ti_id

          left join PosicionArancel poar on producto.poar_id = poar.poar_id
          left join Producto prwebpadre on producto.pr_id_webpadre = prwebpadre.pr_id

 where

     producto.pr_id = @@pr_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



