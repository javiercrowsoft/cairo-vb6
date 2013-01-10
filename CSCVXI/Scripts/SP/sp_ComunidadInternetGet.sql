if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ComunidadInternetGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ComunidadInternetGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ComunidadInternetGet  3

create procedure sp_ComunidadInternetGet (
  @@cmi_id  int
)
as

set nocount on

begin


  select 
          cmi.*,
          pr_nombreventa,
          doc_nombre,
          suc_nombre,
          lp_nombre,
          ld_nombre,
          depl_nombre

  from ComunidadInternet cmi
          inner join Producto pr           on cmi.pr_id = pr.pr_id
          inner join Documento doc         on cmi.doc_id = doc.doc_id
          inner join Sucursal suc         on cmi.suc_id = suc.suc_id
          left  join ListaPrecio lp       on cmi.lp_id = lp.lp_id
          left  join ListaDescuento ld     on cmi.ld_id = ld.ld_id
          left  join DepositoLogico depl   on cmi.depl_id = depl.depl_id

  where cmi.cmi_id = @@cmi_id


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



