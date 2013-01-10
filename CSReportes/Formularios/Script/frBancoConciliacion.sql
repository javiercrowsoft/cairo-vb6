if exists (select * from sysobjects where id = object_id(N'[dbo].[frBancoConciliacion ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frBancoConciliacion ]

go

/*
select * from cuenta where cue_nombre like '%doc%'
frBancoConciliacion 496,'20060606','21000101',1
frBancoConciliacion 141,'20060106','21000101',1

frBancoConciliacion 141,'19900101 00:00:00','20061029 00:00:00',1

*/
create procedure frBancoConciliacion  (

  @@bcoc_id     int

)
as

begin

  select   bcoc.*,
          bcoci.*,
  
          case bcoci_estado
                when 3 then 'Rechazado'
                when 2 then 'Conciliado'
                else         'Pendiente'
          end          as Estado,

          cue_nombre,
          bco.bco_nombre    [Banco Cuenta],

          bcoci_fecha as Fecha,

          asi.asi_orden,
          case 
              when len(ast.as_doc_cliente)>0 then 
                    doct.doct_nombre + ' ' + ast.as_doc_cliente + '. ' + asi.asi_descrip
              else  asi.asi_descrip
          end asi_descrip,
          asi.asi_debe,
          asi.asi_haber,
          asi.asi_origen,
          asi.asi_tipo,
          bcoci_estado as asi_conciliado,
          asi.mon_id,
          asi.cue_id,
          asi.ccos_id,
          asi.cheq_id,

          cheq_importe,
          cheq_importeorigen,
          cheq_numero,
          cheq_numerodoc,
          cheq_fechacobro,
          cheq_fechaVto,
          cheq_descrip,

          mon_nombre,

          cheq.cobz_id,
          cobz_nrodoc,
          cheq.opg_id,
          opg_nrodoc,
          cheq.cle_id,
          cle_nombre,
          cheq.chq_id,
          chq_codigo,          
          cheq.bco_id,

          bcoch.bco_nombre  [Banco Cheque],

          cheq.cli_id,
          cli_nombre,
          cheq.prov_id,
          prov_nombre,
          cheq.mf_id,
          mf_nrodoc,
          cheq.emp_id,
          emp_nombre,
          ccos_nombre,

          ast.doct_id_cliente  as doct_id,
          ast.id_cliente

  from

    BancoConciliacion bcoc left join BancoConciliacionItem bcoci on bcoc.bcoc_id = bcoci.bcoc_id
                           left join Cuenta cue on bcoc.cue_id = cue.cue_id
                           left join Banco bco on cue.bco_id = bco.bco_id


                   left join AsientoItem asi   on bcoci.asi_id = asi.asi_id 
                   left join Asiento ast       on asi.as_id    = ast.as_id

                   left join Cheque cheq          on asi.cheq_id  = cheq.cheq_id
                   left join Cliente cli          on cheq.cli_id  = cli.cli_id
                   left join Proveedor prov       on cheq.prov_id = prov.prov_id
                   left join Cobranza cobz        on cheq.cobz_id = cobz.cobz_id
                   left join OrdenPago opg        on cheq.opg_id  = opg.opg_id
                   left join MovimientoFondo mf    on cheq.mf_id   = mf.mf_id
                   left join Moneda mon           on cheq.mon_id  = mon.mon_id
                   left join Clearing cle         on cheq.cle_id  = cle.cle_id
                   left join Chequera chq         on cheq.chq_id  = chq.chq_id
                   left join Empresa emp          on cheq.emp_id  = emp.emp_id
                   left join Banco bcoch          on cheq.bco_id  = bcoch.bco_id
                   left join CentroCosto ccos     on asi.ccos_id  = ccos.ccos_id
                   left join DocumentoTipo doct   on ast.doct_id_cliente = doct.doct_id

  where bcoc.bcoc_id = @@bcoc_id

end        