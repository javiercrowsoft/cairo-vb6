if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioSearch]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioSearch]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_ListaPrecioSearch 1,1,1,'notebook',0,0,''
 sp_listapreciosearch 1,1,1, 'noteboo',0,0

*/
create procedure sp_ListaPrecioSearch (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@lp_id           int           = 0,
  @@filter2         varchar(255)  = ''
)
as
begin

  set nocount on
    
  select top 50
         lp.lp_id,
         lp_nombre            as Nombre,
         lp_codigo            as Codigo,
         max(pr_nombrecompra) as Articulo,
         max(cli_nombre)       as Cliente,
         max(prov_nombre)     as Proveedor

  from ListaPrecio lp left join ListaPrecioItem lpi on lp.lp_id = lpi.lp_id
                      left join Producto pr         on lpi.pr_id = pr.pr_id

                      left join ListaPrecioCliente lpcli on lp.lp_id = lpcli.lp_id
                      left join Cliente cli              on lpcli.cli_id = cli.cli_id

                      left join ListaPrecioProveedor lpprov on lp.lp_id = lpprov.lp_id
                      left join Proveedor prov               on lpprov.prov_id = prov.prov_id
  
  where
    (
        (     lp_codigo like '%'+@@filter+'%' 
          or lp_nombre like '%'+@@filter+'%' 
          )
    or
        (     pr_codigo like '%'+@@filter+'%' 
          or pr_nombreventa like '%'+@@filter+'%' 
          or pr_nombrecompra like '%'+@@filter+'%' 
          )

    or
        (     cli_codigo like '%'+@@filter+'%' 
          or cli_nombre like '%'+@@filter+'%' 
          or cli_razonsocial like '%'+@@filter+'%' 
          )

    or
        (     prov_codigo like '%'+@@filter+'%' 
          or prov_nombre like '%'+@@filter+'%' 
          or prov_razonsocial like '%'+@@filter+'%' 
          )
    or @@filter = ''
    )
  group by
         lp.lp_id,
         lp_nombre,
         lp_codigo

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

