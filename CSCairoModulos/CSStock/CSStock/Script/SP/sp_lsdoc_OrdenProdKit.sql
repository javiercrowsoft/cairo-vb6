if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenProdKit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenProdKit]

-- sp_lsdoc_OrdenProdKit 0

go
create procedure sp_lsdoc_OrdenProdKit (
@@opk_id int
)as 
begin
select 
      opk_id,
      ''                    as [TypeTask],
      opk_numero            as [Número],
      opk_nrodoc            as [Comprobante],
      doc_nombre            as [Documento],
      opk_fecha              as [Fecha],
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      OrdenProdKit.Creado,
      OrdenProdKit.Modificado,
      us_nombre             as [Modifico],
      opk_descrip            as [Observaciones]
from 
      OrdenProdKit        inner join Documento     on OrdenProdKit.doc_id   = Documento.doc_id
                          inner join empresa       on documento.emp_id       = empresa.emp_id
                          inner join Sucursal      on OrdenProdKit.suc_id   = Sucursal.suc_id
                          inner join Usuario       on OrdenProdKit.modifico = Usuario.us_id
                          left join Legajo         on OrdenProdKit.lgj_id   = Legajo.lgj_id
where 
          @@opk_id = opk_id
end

