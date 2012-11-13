
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Stock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Stock]

go
create procedure sp_lsdoc_Stock (
@@st_id int
)as 
begin
select 
			st_id,
			''									  as [TypeTask],
			st_numero             as [Número],
			st_nrodoc						  as [Comprobante],
      doc_nombre					  as [Documento],
			st_fecha						  as [Fecha],
	    case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],
			doct.doct_nombre			as [Tipo Doc.],
			st_doc_cliente        as [Documento Aux],
			Stock.Creado,
			Stock.Modificado,
			us_nombre             as [Modifico],
			st_descrip						as [Observaciones]
from 
			Stock       inner join Documento     on Stock.doc_id     = Documento.doc_id
									inner join empresa       on documento.emp_id = empresa.emp_id
									inner join Sucursal      on Stock.suc_id     = Sucursal.suc_id
                  inner join Usuario       on Stock.modifico   = Usuario.us_id
                  left  join Legajo    		 on Stock.lgj_id     = Legajo.lgj_id
									left  join DocumentoTipo doct 
																					 on Stock.doct_id_cliente = doct.doct_id

where 

					@@st_id = st_id

end
