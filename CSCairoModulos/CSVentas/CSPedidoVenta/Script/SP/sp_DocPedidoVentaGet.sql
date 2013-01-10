if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGet]

go

/*

sp_DocPedidoVentaGet 8,7

*/

create procedure sp_DocPedidoVentaGet (
  @@emp_id   int,
  @@pv_id    int,
  @@us_id    int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
declare @doc_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint

declare @bIvari    tinyint
declare @bIvarni  tinyint
declare @cli_id   int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @cli_id = cli_id, @doc_id = doc_id from PedidoVenta where pv_id = @@pv_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocPedidoVentaEditableGet @@emp_id, @@pv_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             RAMA DE DEPOSITOS                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @ram_id_stock varchar(50)
declare @RamaStock varchar(50)
select @ram_id_stock = ram_id_stock from PedidoVenta where pv_id = @@pv_id

if IsNull(@ram_id_stock,'') <> '' begin
  if substring(@ram_id_stock,1,1)='N' begin
    declare @ram_id int
    set @ram_id = convert(int,substring(@ram_id_stock,2,50))
    select @RamaStock = ram_nombre from Rama where ram_id = @ram_id
  end else begin
    if isnumeric(@ram_id_stock)<>0 begin
      select @RamaStock = depl_nombre from DepositoLogico where depl_id = convert(int,@ram_id_stock)
    end
  end
end

set @RamaStock = IsNull(@RamaStock,'')

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      pedidoventa.*,
      @RamaStock as RamaStock,
      cli_nombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,

      ven_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      pOrigen.pro_nombre  as ProOrigen,
      pDestino.pro_nombre as ProDestino,
      trans_nombre,
      chof_nombre,
      cam.cam_patente,
      case semi.cam_essemi
        when 0 then semi.cam_patentesemi
        else        semi.cam_patente
      end                  as cam_patentesemi,
      clis_nombre,

      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      pedidoventa inner join documento     on pedidoventa.doc_id  = documento.doc_id
                  inner join condicionpago on pedidoventa.cpg_id  = condicionpago.cpg_id
                  inner join estado        on pedidoventa.est_id  = estado.est_id
                  inner join sucursal      on pedidoventa.suc_id  = sucursal.suc_id
                  inner join cliente       on pedidoventa.cli_id  = cliente.cli_id
                  left join centrocosto    on pedidoventa.ccos_id = centrocosto.ccos_id
                  left join listaprecio    on pedidoventa.lp_id   = listaprecio.lp_id
                  left join listadescuento on pedidoventa.ld_id   = listadescuento.ld_id

                  left join vendedor        on pedidoventa.ven_id  = vendedor.ven_id
                  left join legajo          on pedidoventa.lgj_id  = legajo.lgj_id
                  
                  left join Provincia as pOrigen  on  pedidoventa.pro_id_origen  = pOrigen.pro_id
                  left join Provincia as pDestino on  pedidoventa.pro_id_destino = pDestino.pro_id
                  
                   left join Transporte      on pedidoventa.trans_id = Transporte.trans_id
                   left join Chofer chof     on pedidoventa.chof_id      = chof.chof_id
                   left join Camion cam      on pedidoventa.cam_id       = cam.cam_id
                   left join Camion semi     on pedidoventa.cam_id_semi = semi.cam_id

                  left join ClienteSucursal on pedidoventa.clis_id = ClienteSucursal.clis_id

  where pv_id = @@pv_id

end