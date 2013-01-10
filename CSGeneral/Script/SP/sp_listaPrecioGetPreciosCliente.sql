if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_listaPrecioGetPreciosCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_listaPrecioGetPreciosCliente]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_listaPrecioGetPreciosCliente 2

create procedure sp_listaPrecioGetPreciosCliente (
  @@lp_id        int,
  @@lp_tipo     tinyint,
  @@pr_nombre    varchar(255)
)
as

set nocount on

begin

  if @@pr_nombre <> '' set @@pr_nombre = '%' + @@pr_nombre + '%'

  if @@lp_tipo = 1 begin 

    select top 50   lpi.*, 
                    pr_nombreventa    as pr_nombre,
                    lpm_nombre
  
    from ListaPrecioItem lpi inner join Producto p on lpi.pr_id = p.pr_id
                             left  join ListaPrecioMarcado lpm on lpi.lpm_id = lpm.lpm_id
    where lp_id = @@lp_id 
      and (      pr_nombreventa like @@pr_nombre or @@pr_nombre = ''
            or  pr_codigo      like @@pr_nombre or @@pr_nombre = ''
          )
    order by pr_nombreventa

  end else begin

    select top 50   lpi.*, 
                    pr_nombrecompra   as pr_nombre,
                    lpm_nombre
  
    from ListaPrecioItem lpi inner join Producto p on lpi.pr_id = p.pr_id
                             left  join ListaPrecioMarcado lpm on lpi.lpm_id = lpm.lpm_id
    where lp_id = @@lp_id
      and (pr_nombrecompra like @@pr_nombre or @@pr_nombre = ''
            or  pr_codigo      like @@pr_nombre or @@pr_nombre = ''
          )
    order by pr_nombrecompra
  end
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



