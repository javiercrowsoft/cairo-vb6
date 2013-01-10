if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ParteProdKit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ParteProdKit]

-- sp_lsdoc_ParteProdKit 0

go
create procedure sp_lsdoc_ParteProdKit (
@@ppk_id int
)as 
begin
select 
      ppk_id,
      ''                    as [TypeTask],
      ppk_numero            as [Número],
      ppk_nrodoc            as [Comprobante],
      doc_nombre            as [Documento],
      ppk_fecha              as [Fecha],
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      ParteProdKit.Creado,
      ParteProdKit.Modificado,
      us_nombre             as [Modifico],
      ppk_descrip            as [Observaciones]
from 
      ParteProdKit        inner join Documento     on ParteProdKit.doc_id   = Documento.doc_id
                          inner join empresa       on documento.emp_id       = empresa.emp_id
                          inner join Sucursal      on ParteProdKit.suc_id   = Sucursal.suc_id
                          inner join Usuario       on ParteProdKit.modifico = Usuario.us_id
                          left join Legajo         on ParteProdKit.lgj_id   = Legajo.lgj_id
where 
          @@ppk_id = ppk_id
end
