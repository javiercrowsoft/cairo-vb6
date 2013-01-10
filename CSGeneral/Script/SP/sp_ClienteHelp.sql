if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ClienteHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_ClienteHelp 1,1,0,'',0,0,'cli_id_padre is not null'

 sp_ClienteHelp 3,'',0,0,1 

  select * from usuario where us_nombre like '%ahidal%'

*/
create procedure sp_ClienteHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@cli_id          int           = 0,
  @@filter2         varchar(255)  = ''
)
as
begin

  set nocount on
  
  set @@filter = replace(@@filter,'''','''''')

  declare @us_EmpresaEx tinyint
  declare @us_EmpXDpto  tinyint

  declare @sqlstmt      varchar(5000)

  select @us_EmpresaEx = us_empresaex, @us_EmpXDpto = us_empxdpto from Usuario where us_id = @@us_id

  if @us_EmpresaEx <> 0 begin

    if @@check <> 0 begin

      set @sqlstmt = '

      select  cli_id,
              cli_nombre        as [Nombre],
              cli_codigo         as [Codigo]
  
      from Cliente
  
      where (cli_nombre = '''+@@filter+''' or cli_codigo = '''+@@filter+''')
        and (cli_id = '+convert(varchar(50),@@cli_id)+' or '+convert(varchar(50),@@cli_id)+'=0)
        and (      '+convert(varchar(50),@@bForAbm)+' <> 0 
              or (
                      activo <> 0
                  and (exists (select * from EmpresaCliente where cli_id = cliente.cli_id and emp_id = '+convert(varchar(50),@@emp_id)+'))
                  and (exists (select * from UsuarioEmpresa where cli_id = cliente.cli_id and us_id = '+convert(varchar(50),@@us_id)+') or '+convert(varchar(50),@@us_id)+' = 1)
                  )
            )'
  
    end else begin
        set @sqlstmt = '
        select top 50
               cli_id,
               cli_nombre        as Nombre,
               cli_razonsocial   as [Razon social],
               cli_cuit          as [CUIT],
               cli_codigo        as Codigo,
               case cli_catfiscal
                  when 1 then ''Inscripto''
                  when 2 then ''Exento''
                  when 3 then ''No inscripto''
                  when 4 then ''Consumidor Final''
                  when 5 then ''Extranjero''
                  when 6 then ''Mono Tributo''
                  when 7 then ''Extranjero Iva''
                  when 8 then ''No responsable''
                  when 9 then ''No Responsable exento''
                  when 10 then ''No categorizado''
                  else ''Sin categorizar''
               end as [Categoria Fiscal]

        from cliente 
  
        where (cli_codigo like ''%'''+@@filter+'''%'' or cli_nombre like ''%'''+@@filter+'''%'' 
                or cli_razonsocial like ''%'''+@@filter+'''%'' 
                or cli_cuit like ''%'''+@@filter+'''%'' 
                or '''+@@filter+''' = '''')
        and (@@bForAbm <> 0 or (
                  (exists (select * from EmpresaCliente where cli_id = cliente.cli_id and emp_id = '+convert(varchar(50),@@emp_id)+'))
              and (exists (select * from UsuarioEmpresa where cli_id = cliente.cli_id and us_id = '+convert(varchar(50),@@us_id)+') or '+convert(varchar(50),@@us_id)+' = 1)
              and activo <> 0
            ))'
    end

  end else begin 
    if @us_EmpXDpto <> 0 begin

      if @@check <> 0 begin
        set @sqlstmt = '
        select   cli_id,
                cli_nombre        as [Nombre],
                cli_codigo         as [Codigo]
    
        from Cliente
    
        where (cli_nombre = '''+@@filter+''' or cli_codigo = '''+@@filter+''')
          and (cli_id = '+convert(varchar(50),@@cli_id)+' or '+convert(varchar(50),@@cli_id)+'=0)
          and (      '+convert(varchar(50),@@bForAbm)+' <> 0 
                or (
                    activo <> 0
                and  (exists (select * from EmpresaCliente where cli_id = cliente.cli_id and emp_id = '+convert(varchar(50),@@emp_id)+'))
                and (exists (select * from DepartamentoCliente dc inner join UsuarioDepartamento ud on dc.dpto_id = ud.dpto_id
                              where cli_id = cliente.cli_id and us_id = '+convert(varchar(50),@@us_id)+'
                             ) 
                      or '+convert(varchar(50),@@us_id)+' = 1
                     )    
               ))'
    
      end else begin
        set @sqlstmt = '
        select top 50
               cli_id,
               cli_nombre        as Nombre,
               cli_razonsocial   as [Razon social],
               cli_cuit          as [CUIT],
               cli_codigo        as Codigo,
               case cli_catfiscal
                  when 1 then ''Inscripto''
                  when 2 then ''Exento''
                  when 3 then ''No inscripto''
                  when 4 then ''Consumidor Final''
                  when 5 then ''Extranjero''
                  when 6 then ''Mono Tributo''
                  when 7 then ''Extranjero Iva''
                  when 8 then ''No responsable''
                  when 9 then ''No Responsable exento''
                  when 10 then ''No categorizado''
                  else ''Sin categorizar''
               end as [Categoria Fiscal]
        from cliente 
  
        where (cli_codigo like ''%'+@@filter+'%'' or cli_nombre like ''%'+@@filter+'%'' 
                or cli_razonsocial like ''%'+@@filter+'%'' 
                or cli_cuit like ''%'+@@filter+'%'' 
                or '''+@@filter+''' = '''')
        and (@@bForAbm <> 0 or (
                     (exists (select * from EmpresaCliente where cli_id = cliente.cli_id and emp_id = '+convert(varchar(50),@@emp_id)+'))
                and (exists (select * from DepartamentoCliente dc inner join UsuarioDepartamento ud on dc.dpto_id = ud.dpto_id
                              where cli_id = cliente.cli_id and us_id = '+convert(varchar(50),@@us_id)+'
                             ) 
                      or '+convert(varchar(50),@@us_id)+' = 1
                     )    
                and activo <> 0
            ))'
      end    

    end else begin
  
      if @@check <> 0 begin
        set @sqlstmt = '
        select   cli_id,
                cli_nombre        as [Nombre],
                cli_codigo         as [Codigo]
    
        from Cliente
    
        where (cli_nombre = '''+@@filter+''' or cli_codigo = '''+@@filter+''')
          and (cli_id = '+convert(varchar(50),@@cli_id)+' or '+convert(varchar(50),@@cli_id)+'=0)
          and (
                  '+convert(varchar(50),@@bForAbm)+' <> 0 
                or 
                  (
                        activo <> 0
                    and  exists (select * from EmpresaCliente where cli_id = cliente.cli_id and emp_id = '+convert(varchar(50),@@emp_id)+')
                  )
              )'
    
      end else begin

        set @sqlstmt = '    
        select top 50
               cli_id,
               cli_nombre        as Nombre,
               cli_razonsocial   as [Razon social],
               cli_cuit          as [CUIT],
               cli_codigo        as Codigo,
               case cli_catfiscal
                  when 1 then ''Inscripto''
                  when 2 then ''Exento''
                  when 3 then ''No inscripto''
                  when 4 then ''Consumidor Final''
                  when 5 then ''Extranjero''
                  when 6 then ''Mono Tributo''
                  when 7 then ''Extranjero Iva''
                  when 8 then ''No responsable''
                  when 9 then ''No Responsable exento''
                  when 10 then ''No categorizado''
                  else ''Sin categorizar''
               end as [Categoria Fiscal]
        from cliente 
  
        where (cli_codigo like ''%'+@@filter+'%'' or cli_nombre like ''%'+@@filter+'%'' 
                or cli_razonsocial like ''%'+@@filter+'%'' 
                or cli_cuit like ''%'+@@filter+'%'' 
                or '''+@@filter+''' = '''')
        and (    '+convert(varchar(50),@@bForAbm)+' <> 0 
              or 
                (      exists (select * from EmpresaCliente where cli_id = cliente.cli_id and emp_id = '+convert(varchar(50),@@emp_id)+')
                  and activo <> 0
                )
            )'
    
      end    
    end
  end

  if @@filter2 <> '' set @sqlstmt = @sqlstmt + ' and (' + @@filter2 + ')'

  --print (@sqlstmt)
  exec (@sqlstmt)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

