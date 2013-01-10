if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocSearchCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocSearchCliente]

go

/*

select * from comunidadinternetpregunta where cmip_pregunta like '%a cuanto del obelisco%'

sp_DocSearch 'pregunta:a cuanto del obelisco',1,15,5,'20100501 00:00:00','20100601 00:00:00',0,0,0,0,0,0,0,0,0,0

*/

create procedure sp_DocSearchCliente (

  @@toSearch            varchar(5000),
  @@searchType          tinyint,
  @@fieldsToSearch       int,
  @@doct_id              int,
  @@Fini                datetime,
  @@Ffin                datetime,
  @@cli_id              int,
  @@prov_id              int,
  @@est_id              int,
  @@suc_id              int,
  @@ven_id              int,
  @@cue_id              int,
  @@bco_id              int,
  @@barc_id              int,
  @@doc_id              int,
  @@emp_id              int
)
as

set nocount on

begin

  declare @@csEDocFieldNumero         int
  declare @@csEDocFieldComprobante     int
  declare @@csEDocFieldTotal           int
  declare @@csEDocFieldObservaciones  int

  declare @@csEDocFieldCodigo         int
  declare @@csEDocFieldCodigo2         int
  declare @@csEDocFieldCodigo3         int
  declare @@csEDocFieldCodigo4         int
  declare @@csEDocFieldContacto       int

  set @@csEDocFieldNumero         = 1
  set @@csEDocFieldComprobante     = 2
  set @@csEDocFieldTotal           = 4
  set @@csEDocFieldObservaciones  = 8

  set @@csEDocFieldCodigo         = 16
  set @@csEDocFieldCodigo2         = 32
  set @@csEDocFieldCodigo3         = 64
  set @@csEDocFieldCodigo4         = 128
  set @@csEDocFieldCodigo4         = 256

  if @@toSearch = ''

      select 'Debe indicar un texto a buscar' as Mensaje

  else begin

    select @@toSearch = case @@searchType 
                          when 1 then  '%' + @@toSearch + '%'
                          when 2 then  @@toSearch + '%'
                          else        @@toSearch
                        end

    if @@doct_id in (1, 7, 9)

      select top 100

              fv.fv_id          as comp_id,
              fv.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              fv_fecha          as [Fecha],
              fv_nrodoc          as [Comprobante],
              fv_numero         as [Numero],
              cli_nombre        as [Cliente],
              fv_descrip        as [__details]

      from facturaVenta fv inner join cliente cli                 on fv.cli_id     = cli.cli_id
                           inner join documento doc                on fv.doc_id     = doc.doc_id 
                           inner join documentotipo doct          on doc.doct_id  = doct.doct_id
                           inner join empresa emp                  on doc.emp_id   = emp.emp_id

      where     (convert(varchar,fv_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (fv_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,fv_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (fv_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id in (2, 8, 10)

      select top 100

              fc.fc_id          as comp_id,
              fc.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              fc_fecha          as [Fecha],
              fc_nrodoc          as [Comprobante],
              fc_numero         as [Numero],
              prov_nombre       as [Proveedor],
              fc_descrip        as [__details]

      from facturaCompra fc inner join proveedor prov             on fc.prov_id   = prov.prov_id
                            inner join documento doc              on fc.doc_id    = doc.doc_id 
                            inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                            inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,fc_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (fc_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,fc_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (fc_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id in (3, 24)

      select top 100

              rv.rv_id          as comp_id,
              rv.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              rv_fecha          as [Fecha],
              rv_nrodoc          as [Comprobante],
              rv_numero         as [Numero],
              cli_nombre        as [Cliente],
              rv_descrip        as [__details]

      from remitoVenta rv inner join cliente cli                 on rv.cli_id     = cli.cli_id
                          inner join documento doc              on rv.doc_id     = doc.doc_id 
                          inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                          inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,rv_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (rv_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,rv_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (rv_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)

    else if @@doct_id in (4, 25)

      select top 100

              rc.rc_id          as comp_id,
              rc.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              rc_fecha          as [Fecha],
              rc_nrodoc          as [Comprobante],
              rc_numero         as [Numero],
              prov_nombre       as [Proveedor],
              rc_descrip        as [__details]

      from remitoCompra rc inner join proveedor prov             on rc.prov_id   = prov.prov_id
                           inner join documento doc              on rc.doc_id    = doc.doc_id 
                           inner join documentotipo doct        on doc.doct_id  = doct.doct_id
                           inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,rc_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (rc_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,rc_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (rc_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id in (5, 22)

      if (substring(@@toSearch,1,10) = '%pregunta:') begin

        set @@toSearch = '%' + ltrim(substring(@@toSearch,11,100))

        create table #t_pedidos (pv_id int, cmip_id int)

        insert into #t_pedidos (pv_id, cmip_id)

        select pv.pv_id, cmip_id
        from ComunidadInternetPregunta cmip 
                left join Cliente cli 
                            on cmip_nick = replace(cli_codigocomunidad,'(ML)#','')

                left join PedidoVenta pv
                            on cli.cli_id = pv.cli_id
        where cmip_pregunta like @@toSearch
          
        select top 100
  
                isnull(pv.pv_id,0)    as comp_id,
                isnull(pv.doct_id,0)  as doct_id, 
  
                isnull(emp_nombre,'El Nick aun no registra compras') as [Empresa],
                isnull(doct_nombre,'')       as [Tipo],
                isnull(doc_nombre,'')        as [Documento],
                isnull(pv_fecha,'')          as [Fecha],
                isnull(pv_nrodoc,'')         as [Comprobante],
                isnull(pv_numero,0)          as [Numero],
                isnull(cli_nombre,'')        as [Cliente],
                isnull(cli_tel,'')           as [Telefono],
                isnull(cli_email,'')         as [E-mail],
                isnull(pv_descrip ,'')
                + char(10) + char(13)
                + 'Nick: ' + cmip_nick
                + char(10) + char(13)
                + 'Pregunta: ' + cmip_pregunta
                + char(10) + char(13)
                + 'Respuesta: ' + cmip_respuesta
                + char(10) + char(13)
                                  as [__details]
  
        from #t_pedidos t   inner join ComunidadInternetPregunta cmip on t.cmip_id = cmip.cmip_id
                            left  join pedidoVenta pv             on t.pv_id       = pv.pv_id
                            left  join cliente cli                 on pv.cli_id     = cli.cli_id
                            left  join documento doc              on pv.doc_id     = doc.doc_id 
                            left  join documentotipo doct         on doc.doct_id  = doct.doct_id
                            left  join empresa emp                on doc.emp_id   = emp.emp_id
                            


      end else begin

        select top 100
  
                pv.pv_id          as comp_id,
                pv.doct_id        as doct_id, 
  
                emp_nombre        as [Empresa],
                doct_nombre       as [Tipo],
                doc_nombre        as [Documento],
                pv_fecha          as [Fecha],
                pv_nrodoc          as [Comprobante],
                pv_numero         as [Numero],
                cli_nombre        as [Cliente],
                pv_descrip        as [__details]
  
        from pedidoVenta pv inner join cliente cli                 on pv.cli_id     = cli.cli_id
                            inner join documento doc              on pv.doc_id     = doc.doc_id 
                            inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                            inner join empresa emp                on doc.emp_id   = emp.emp_id
  
        where     (convert(varchar,pv_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
              or  (pv_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
              or  (convert(varchar,pv_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
              or  (pv_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)
  
      end

    else if @@doct_id in (6, 23)

      select top 100

              pc.pc_id          as comp_id,
              pc.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              pc_fecha          as [Fecha],
              pc_nrodoc          as [Comprobante],
              pc_numero         as [Numero],
              us_nombre         as [Usuario],
              pc_descrip        as [__details]

      from pedidoCompra pc inner join usuario us                 on pc.us_id     = us.us_id
                           inner join documento doc              on pc.doc_id    = doc.doc_id 
                           inner join documentotipo doct        on doc.doct_id  = doct.doct_id
                           inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,pc_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (pc_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,pc_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (pc_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id in (35, 36)

      select top 100

              oc.oc_id          as comp_id,
              oc.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              oc_fecha          as [Fecha],
              oc_nrodoc          as [Comprobante],
              oc_numero         as [Numero],
              oc_ordencompra    as [PO],
              oc_presupuesto    as [RMA],
              prov_nombre       as [Proveedor],
              oc_descrip        as [__details]

      from OrdenCompra oc  inner join proveedor prov             on oc.prov_id   = prov.prov_id
                           inner join documento doc              on oc.doc_id    = doc.doc_id 
                           inner join documentotipo doct        on doc.doct_id  = doct.doct_id
                           inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,oc_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (oc_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,oc_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (oc_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)

            or  (oc_ordencompra             like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (oc_presupuesto             like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)

    else if @@doct_id = 11

      select top 100

              prv.prv_id        as comp_id,
              prv.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              prv_fecha         as [Fecha],
              prv_nrodoc        as [Comprobante],
              prv_numero        as [Numero],
              cli_nombre        as [Cliente],
              prv_descrip       as [__details]

      from presupuestoVenta prv inner join cliente cli               on prv.cli_id   = cli.cli_id
                                 inner join documento doc            on prv.doc_id   = doc.doc_id 
                                 inner join documentotipo doct       on doc.doct_id  = doct.doct_id
                                inner join empresa emp              on doc.emp_id   = emp.emp_id

      where     (convert(varchar,prv_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (prv_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,prv_total)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (prv_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 12

      select top 100

              prc.prc_id        as comp_id,
              prc.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              prc_fecha         as [Fecha],
              prc_nrodoc        as [Comprobante],
              prc_numero        as [Numero],
              prov_nombre       as [Proveedor],
              prc_descrip       as [__details]

      from presupuestoCompra prc inner join proveedor prov             on prc.prov_id = prov.prov_id
                                  inner join documento doc              on prc.doc_id  = doc.doc_id 
                                  inner join documentotipo doct        on doc.doct_id = doct.doct_id
                                 inner join empresa emp                on doc.emp_id  = emp.emp_id

      where     (convert(varchar,prc_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (prc_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,prc_total)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (prc_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 13

      select top 100

              cobz.cobz_id        as comp_id,
              cobz.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              cobz_fecha          as [Fecha],
              cobz_nrodoc          as [Comprobante],
              cobz_numero         as [Numero],
              cli_nombre          as [Cliente],
              cobz_descrip        as [__details]

      from cobranza cobz   inner join cliente cli                 on cobz.cli_id   = cli.cli_id
                          inner join documento doc              on cobz.doc_id   = doc.doc_id 
                          inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                          inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,cobz_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (cobz_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,cobz_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (cobz_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 14

      select top 100

              st.st_id          as comp_id,
              st.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              st_fecha          as [Fecha],
              st_nrodoc          as [Comprobante],
              st_numero          as [Numero],
              st_descrip         as [__details]

      from stock st  inner join documento doc        on st.doc_id    = doc.doc_id 
                    inner join documentotipo doct   on doc.doct_id  = doct.doct_id
                    inner join empresa emp          on doc.emp_id   = emp.emp_id

      where     (convert(varchar,st_numero)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (st_nrodoc                     like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (st_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 15

      select top 100

              ac.as_id          as comp_id,
              ac.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              as_fecha          as [Fecha],
              as_nrodoc          as [Comprobante],
              as_numero          as [Numero],
              as_descrip         as [__details]

      from asiento ac  inner join documento doc        on ac.doc_id    = doc.doc_id 
                      inner join documentotipo doct    on doc.doct_id  = doct.doct_id
                      inner join empresa emp          on doc.emp_id   = emp.emp_id

      where     (convert(varchar,as_numero)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (as_nrodoc                     like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (as_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 16

      select top 100

              opg.opg_id        as comp_id,
              opg.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              opg_fecha         as [Fecha],
              opg_nrodoc        as [Comprobante],
              opg_numero        as [Numero],
              prov_nombre       as [Proveedor],
              opg_descrip       as [__details]

      from ordenPago opg     inner join proveedor prov             on opg.prov_id   = prov.prov_id
                            inner join documento doc              on opg.doc_id    = doc.doc_id 
                            inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                            inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,opg_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (opg_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,opg_total)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (opg_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 17

      select top 100

              dbco.dbco_id        as comp_id,
              dbco.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              dbco_fecha          as [Fecha],
              dbco_nrodoc          as [Comprobante],
              dbco_numero         as [Numero],
              bco_nombre          as [banco],
              dbco_descrip        as [__details]

      from depositoBanco dbco inner join banco bco                 on dbco.bco_id = bco.bco_id
                              inner join documento doc            on dbco.doc_id = doc.doc_id 
                              inner join documentotipo doct       on doc.doct_id = doct.doct_id
                              inner join empresa emp              on doc.emp_id  = emp.emp_id

      where     (convert(varchar,dbco_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (dbco_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,dbco_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (dbco_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 18

      select top 100

              pree.pree_id        as comp_id,
              pree.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              pree_fecha          as [Fecha],
              pree_nrodoc          as [Comprobante],
              pree_numero         as [Numero],
              cli_nombre           as [Cliente],
              pree_descrip        as [__details]

      from presupuestoEnvio pree inner join cliente cli               on pree.cli_id = cli.cli_id
                                 inner join documento doc              on pree.doc_id = doc.doc_id 
                                  inner join documentotipo doct        on doc.doct_id = doct.doct_id
                                  inner join empresa emp                on doc.emp_id  = emp.emp_id

      where     (convert(varchar,pree_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (pree_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,pree_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (pree_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 19

      select top 100

              pemb.pemb_id        as comp_id,
              pemb.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              pemb_fecha          as [Fecha],
              pemb_nrodoc          as [Comprobante],
              pemb_numero         as [Numero],
              bco_nombre          as [banco],
              pemb_descrip        as [__details]

      from permisoEmbarque pemb inner join banco bco                 on pemb.bco_id = bco.bco_id
                                inner join documento doc            on pemb.doc_id = doc.doc_id 
                                inner join documentotipo doct       on doc.doct_id = doct.doct_id
                                 inner join empresa emp              on doc.emp_id  = emp.emp_id

      where     (convert(varchar,pemb_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (pemb_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,pemb_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (pemb_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 20

      select top 100

              mfc.mfc_id        as comp_id,
              mfc.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              mfc_fecha         as [Fecha],
              mfc_nrodoc        as [Comprobante],
              mfc_numero        as [Numero],
              cli_nombre        as [Cliente],
              mfc_descrip       as [__details]

      from manifiestoCarga mfc   inner join cliente cli                 on mfc.cli_id   = cli.cli_id
                                inner join documento doc              on mfc.doc_id   = doc.doc_id 
                                inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                                 inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,mfc_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (mfc_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (mfc_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id in (21,31)

      select top 100

              pklst.pklst_id      as comp_id,
              pklst.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              pklst_fecha         as [Fecha],
              pklst_nrodoc        as [Comprobante],
              pklst_numero        as [Numero],
              cli_nombre          as [Cliente],
              pklst_descrip       as [__details]

      from packingList pklst   inner join cliente cli                 on pklst.cli_id = cli.cli_id
                              inner join documento doc              on pklst.doc_id = doc.doc_id 
                              inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                               inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,pklst_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (pklst_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,pklst_total)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (pklst_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 26

      select top 100

              mf.mf_id         as comp_id,
              mf.doct_id       as doct_id, 

              emp_nombre       as [Empresa],
              doct_nombre      as [Tipo],
              doc_nombre       as [Documento],
              mf_fecha         as [Fecha],
              mf_nrodoc         as [Comprobante],
              mf_numero        as [Numero],
              cli_nombre       as [Cliente],
              mf_descrip       as [__details]

      from movimientoFondo mf   inner join documento doc              on mf.doc_id     = doc.doc_id 
                                inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                                inner join empresa emp                on doc.emp_id   = emp.emp_id                                
                                left join cliente cli                 on mf.cli_id     = cli.cli_id

      where     (convert(varchar,mf_numero)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (mf_nrodoc                     like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,mf_total)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (mf_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 28

      select top 100

              rs.rs_id        as comp_id,
              rs.doct_id      as doct_id, 

              emp_nombre      as [Empresa],
              doct_nombre     as [Tipo],
              doc_nombre      as [Documento],
              rs_fecha        as [Fecha],
              rs_nrodoc        as [Comprobante],
              rs_numero       as [Numero],
              rs_descrip      as [__details]

      from recuentoStock rs  inner join documento doc       on rs.doc_id     = doc.doc_id 
                            inner join documentotipo doct on doc.doct_id  = doct.doct_id
                             inner join empresa emp        on doc.emp_id   = emp.emp_id

      where     (convert(varchar,rs_numero)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (rs_nrodoc                     like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (rs_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 29

      select top 100

              impt.impt_id        as comp_id,
              impt.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              impt_fecha          as [Fecha],
              impt_nrodoc          as [Comprobante],
              impt_numero         as [Numero],
              prov_nombre         as [Proveedor],
              impt_descrip        as [__details]

      from importacionTemp impt inner join proveedor prov             on impt.prov_id = prov.prov_id
                                 inner join documento doc              on impt.doc_id  = doc.doc_id 
                                inner join documentotipo doct         on doc.doct_id  = doct.doct_id
                                 inner join empresa emp                on doc.emp_id   = emp.emp_id

      where     (convert(varchar,impt_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (impt_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,impt_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (impt_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)

    else if @@doct_id = 30

      select top 100

              ppk.ppk_id          as comp_id,
              ppk.doct_id          as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              ppk_fecha           as [Fecha],
              ppk_nrodoc          as [Comprobante],
              ppk_numero          as [Numero],
              ppk_descrip         as [__details]

      from parteProdKit ppk  inner join documento doc       on ppk.doc_id  = doc.doc_id 
                            inner join documentotipo doct  on doc.doct_id = doct.doct_id
                             inner join empresa emp         on doc.emp_id  = emp.emp_id

      where     (convert(varchar,ppk_numero)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (ppk_nrodoc                     like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (ppk_descrip                     like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)


    else if @@doct_id = 32

      select top 100

              dcup.dcup_id        as comp_id,
              dcup.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              dcup_fecha          as [Fecha],
              dcup_nrodoc          as [Comprobante],
              dcup_numero         as [Numero],
              dcup_descrip        as [__details]

      from depositoCupon dcup inner join documento doc       on dcup.doc_id = doc.doc_id 
                              inner join documentotipo doct on doc.doct_id = doct.doct_id
                               inner join empresa emp        on doc.emp_id  = emp.emp_id

      where     (convert(varchar,dcup_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (dcup_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,dcup_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (dcup_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)  


    else if @@doct_id = 33

      select top 100

              rcup.rcup_id        as comp_id,
              rcup.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              rcup_fecha          as [Fecha],
              rcup_nrodoc          as [Comprobante],
              rcup_numero         as [Numero],
              rcup_descrip        as [__details]

      from resolucionCupon rcup inner join documento doc       on rcup.doc_id = doc.doc_id 
                                inner join documentotipo doct on doc.doct_id = doct.doct_id
                                 inner join empresa emp        on doc.emp_id  = emp.emp_id

      where     (convert(varchar,rcup_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (rcup_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,rcup_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (rcup_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)  

    else if @@doct_id = 42

      select top 100

              os.os_id          as comp_id,
              os.doct_id        as doct_id, 

              emp_nombre        as [Empresa],
              doct_nombre       as [Tipo],
              doc_nombre        as [Documento],
              os_fecha          as [Fecha],
              os_nrodoc          as [Comprobante],
              os_numero         as [Numero],
              os_descrip        as [__details]

      from OrdenServicio os     inner join documento doc       on os.doc_id = doc.doc_id 
                                inner join documentotipo doct on doc.doct_id = doct.doct_id
                                 inner join empresa emp        on doc.emp_id  = emp.emp_id

      where     (convert(varchar,os_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (os_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,os_total)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (os_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)  

    else if @@doct_id = 43

      select top 100

              prp.prp_id        as comp_id,
              prp.doct_id        as doct_id, 

              emp_nombre          as [Empresa],
              doct_nombre         as [Tipo],
              doc_nombre          as [Documento],
              prp_fecha            as [Fecha],
              prp_nrodoc          as [Comprobante],
              prp_numero           as [Numero],
              prp_descrip          as [__details]

      from ParteReparacion prp   inner join documento doc       on prp.doc_id = doc.doc_id 
                                inner join documentotipo doct on doc.doct_id = doct.doct_id
                                 inner join empresa emp        on doc.emp_id  = emp.emp_id

      where     (convert(varchar,prp_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (prp_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (convert(varchar,prp_total)    like @@toSearch and @@fieldsToSearch & @@csEDocFieldTotal <> 0)
            or  (prp_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)  

    else if @@doct_id = 44

      select top 100

              stprov.stprov_id        as comp_id,
              stprov.doct_id          as doct_id, 

              emp_nombre              as [Empresa],
              doct_nombre             as [Tipo],
              doc_nombre              as [Documento],
              stprov_fecha            as [Fecha],
              stprov_nrodoc            as [Comprobante],
              stprov_numero           as [Numero],
              stprov_descrip          as [__details]

      from StockProveedor stprov   inner join documento doc       on stprov.doc_id   = doc.doc_id 
                                  inner join documentotipo doct on doc.doct_id     = doct.doct_id
                                   inner join empresa emp        on doc.emp_id      = emp.emp_id

      where     (convert(varchar,stprov_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (stprov_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (stprov_descrip                 like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)  

    else if @@doct_id = 45

      select top 100

              stcli.stcli_id        as comp_id,
              stcli.doct_id          as doct_id, 

              emp_nombre            as [Empresa],
              doct_nombre           as [Tipo],
              doc_nombre            as [Documento],
              stcli_fecha            as [Fecha],
              stcli_nrodoc          as [Comprobante],
              stcli_numero           as [Numero],
              stcli_descrip          as [__details]

      from StockCliente stcli   inner join documento doc       on stcli.doc_id   = doc.doc_id 
                                inner join documentotipo doct on doc.doct_id     = doct.doct_id
                                 inner join empresa emp        on doc.emp_id      = emp.emp_id

      where     (convert(varchar,stcli_numero)  like @@toSearch and @@fieldsToSearch & @@csEDocFieldNumero <> 0)
            or  (stcli_nrodoc                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldComprobante <> 0)
            or  (stcli_descrip                   like @@toSearch and @@fieldsToSearch & @@csEDocFieldObservaciones <> 0)  

    else if @@doct_id = -1017

      select top 100

              prns.prns_id        as comp_id,
              -1017                as doct_id, 

              pr_nombrecompra        as [Producto],
              rub_nombre            as [Rubro],
              prns_codigo            as [Codigo],
              prns_codigo2           as [Codigo2],
              prns_codigo3          as [Codigo3],
              prns_codigo4          as [Codigo4],
              prns_codigo5          as [Codigo5],
              prns_codigo6          as [Codigo6],
              cont_nombre           as [Contacto],
              IsNull(clis.cli_nombre,cli.cli_nombre)
                                    as [Cliente],
              IsNull(provs.prov_nombre,prov.prov_nombre)
                                    as [Proveedor],
              
              os_nrodoc              as [Orden Servicio],
              os_fecha               as [Ingreso],
              rv_fecha              as [Salida],
              prns_descrip          as [__details]

      from ProductoNumeroSerie prns 
                                inner join Producto pr on prns.pr_id = pr.pr_id
                                left  join Rubro rub   on pr.rub_id  = rub.rub_id

                                left join ProductoNumeroSerieServicio prnss on prns.prns_id = prnss.prnss_id

                                left join Contacto cont     on prnss.cont_id = cont.cont_id

                                left join Cliente cli       on prns.cli_id  = cli.cli_id
                                left join Proveedor prov    on prns.prov_id = prov.prov_id
  
                                left join Cliente clis       on prnss.cli_id  = clis.cli_id
                                left join Proveedor provs   on prnss.prov_id = provs.prov_id

                                left join OrdenServicio os   on prnss.os_id = os.os_id
                                left join RemitoVenta rv    on prnss.rv_id = rv.rv_id



      where     (prns_codigo  like @@toSearch and @@fieldsToSearch & @@csEDocFieldCodigo  <> 0)
            or  (prns_codigo2 like @@toSearch and @@fieldsToSearch & @@csEDocFieldCodigo2 <> 0)
            or  (prns_codigo3 like @@toSearch and @@fieldsToSearch & @@csEDocFieldCodigo3 <> 0)
            or  (prns_codigo4 like @@toSearch and @@fieldsToSearch & @@csEDocFieldCodigo4 <> 0)
            or  (cont_nombre   like @@toSearch and @@fieldsToSearch & @@csEDocFieldContacto <> 0)


  end
end

go
