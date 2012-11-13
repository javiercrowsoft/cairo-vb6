if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_RecuentoStock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_RecuentoStock]

-- sp_lsdoc_RecuentoStock 0

go
create procedure sp_lsdoc_RecuentoStock (
@@rs_id int
)as 
begin
select 
			rs_id,
			''									  as [TypeTask],
			rs_numero             as [Número],
			rs_nrodoc						  as [Comprobante],
      doc_nombre					  as [Documento],
			rs_fecha						  as [Fecha],
	    case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],

			RecuentoStock.Creado,
			RecuentoStock.Modificado,
			us_nombre             as [Modifico],
			rs_descrip						as [Observaciones]
from 
			RecuentoStock       inner join Documento     on RecuentoStock.doc_id   = Documento.doc_id
											    inner join empresa       on documento.emp_id 			 = empresa.emp_id
													inner join Sucursal      on RecuentoStock.suc_id   = Sucursal.suc_id
				                  inner join Usuario       on RecuentoStock.modifico = Usuario.us_id
				                  left join Legajo    		 on RecuentoStock.lgj_id   = Legajo.lgj_id
where 
					@@rs_id = rs_id
end
