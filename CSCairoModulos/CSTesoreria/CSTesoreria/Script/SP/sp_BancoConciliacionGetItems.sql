if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_BancoConciliacionGetItems ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_BancoConciliacionGetItems ]

go

/*

*/
create procedure sp_BancoConciliacionGetItems  (
  @@bcoc_id    int
)
as

begin

  set nocount on

  declare @fechaCobro tinyint

  select @fechaCobro = bcoc_fechacheque from BancoConciliacion where bcoc_id = @@bcoc_id

  select   
          bcoci.*,

          asi.as_id,
          asi.asi_id,

          bcoci_fecha  as Fecha,

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
          bco_nombre,
          cheq.cli_id,
          cli_nombre,
          cheq.prov_id,
          prov_nombre,
          cheq.mf_id,
          mf_nrodoc,
          cheq.emp_id,
          emp_nombre,
          ccos_nombre,
          cue_nombre,

          ast.doct_id_cliente,
          ast.id_cliente

  from BancoConciliacionItem bcoci 
                  left join AsientoItem asi on bcoci.asi_id = asi.asi_id
                  left join Asiento ast     on asi.as_id     = ast.as_id

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
                   left join Banco bco            on cheq.bco_id  = bco.bco_id
                   left join CentroCosto ccos     on asi.ccos_id  = ccos.ccos_id
                   left join Cuenta cue           on chq.cue_id   = cue.cue_id
                   left join DocumentoTipo doct   on ast.doct_id_cliente = doct.doct_id

  where 
          bcoci.bcoc_id = @@bcoc_id

  order by Fecha, asi_debe desc

end        