if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ComunidadInternetProdutosGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ComunidadInternetProdutosGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ComunidadInternetProdutosGet  3

create procedure sp_ComunidadInternetProdutosGet

as

set nocount on

begin

  declare @fecha datetime
  set @fecha = dateadd(d,-5,getdate())

  select   
          cmipr.cmi_id,
          cmipr.cmipr_id,
          cmipr.cmipr_codigo,
          cmipr.cmipr_nombre,
          cmipr.pr_id,
          cmipr.creado,
          cmipr.modificado,
          cmipr.cmipr_finaliza,
          cmipr.cmipr_ofertas,
          cmipr.cmipr_visitas,
          cmipr.cmipr_ventas,
          cmipr.cmipr_disponible,
          case 
              when prdepl_reposicion is null then cmipr_reposicion 
              else prdepl_reposicion 
          end as cmipr_reposicion,
           cmi_nombre,
           pr_nombreventa,
           '' as Descrip
          
  from ComunidadInternetProducto cmipr 
          inner join ComunidadInternet cmi on cmipr.cmi_id = cmi.cmi_id
          left join Producto pr         on cmipr.pr_id = pr.pr_id
          left join ProductoDepositoLogico prdepl on   cmi.depl_id = prdepl.depl_id 
                                                  and cmipr.pr_id = prdepl.pr_id

  where cmipr.modificado >= @fecha
  order by convert(int,cmipr_codigo) desc

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



