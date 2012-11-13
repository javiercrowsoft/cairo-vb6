if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorCheques2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorCheques2]

/*

sp_infoProveedorCheques '',114,1

*/

go
create procedure sp_infoProveedorCheques2 (
	@@us_id         int,
	@@emp_id        int,
	@@prov_id       int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime

	set @fDesde = dateadd(d,-180,getdate())

	select 	top 20

					cheq.cheq_id, 
					bco_nombre        as Banco,
					cle_nombre        as Clearing,
					cheq_numerodoc		as Comprobante,
					cheq_importe      as Total,
					cheq_fechacobro   as [A depositar2],
					cheq_fecha2       as Acreditacion,

					cheq_fecharechazo as [Rechazado el2],

					case cheq_rechazado    
							when 0 then 'No'
							else        'Si'
          end 							as Rechazado,

					emp_nombre      	as Empresa,
					cheq_descrip      as Observaciones

	from Cheque cheq  inner join Empresa emp 	on cheq.emp_id = emp.emp_id
										inner join Clearing cle on cheq.cle_id = cle.cle_id
										inner join Banco bco    on cheq.bco_id = bco.bco_id

	where cheq.prov_id = @@prov_id 
		and cheq_fechacobro >= @fDesde

	order by cheq_fechacobro, cheq.cheq_id, emp_nombre

end
go
