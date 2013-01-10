if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ClienteGetDataAddCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteGetDataAddCairo]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

*/

create procedure sp_ClienteGetDataAddCairo (
  @@cli_id  int
)
as

set nocount on

begin

  declare @rz         varchar(255)
  declare @tel         varchar(255)
  declare @cuit        varchar(255)
  declare @dir         varchar(255)
  declare @tel2       varchar(255)
  declare @trans      varchar(255)

  declare @sucursales varchar(5000)
  declare @suc        varchar(5000)

  set @sucursales = ''

  declare c_suc insensitive cursor for 

      select clis_nombre
              + clis_calle
              + ' ' +clis_callenumero
              + ' ' +clis_piso
              + ' ' +clis_depto
              +clis_localidad
              +case when clis_codpostal<>'' then '('+clis_codpostal+')' else '' end
              + 'T: ' +clis_tel
              + 'E: ' +clis_email
              + 'C: ' +clis_contacto 
      from ClienteSucursal where cli_id = @@cli_id

  open c_suc
  fetch next from c_suc into @suc
  while @@fetch_status=0
  begin

    set @sucursales = @sucursales + @suc + char(13)+char(10)

    fetch next from c_suc into @suc
  end
  close c_suc
  deallocate c_suc

  select

            @rz   = 'RZ: ' + cli_razonsocial + ' -N: ' + cli_nombre,
            @cuit = '(' + cli_cuit + ')',
            @tel  = 'Tel: ' + cli_tel,

            @dir  = cli_calle + ' ' + 
                    cli_callenumero + ' ' + 
                    cli_piso + ' ' + 
                    cli_codpostal + ' ' + 
                    case when cli_localidad <> isnull(pro_nombre,'') then cli_localidad + ' ' 
                         else '' 
                    end  +                  
                    isnull(pro_nombre,'') + ' ' +
                    isnull(pa_nombre,''),

            @tel2 = 'Tel: ' + 
                    cli_tel  + ' fax:' + 
                    cli_fax  + ' mail: ' + 
                    cli_email  + ' web:' + 
                    cli_web + 'C: ' + 
                    cli_contacto,

            @trans = 'Transporte: ' 
                     + trans_nombre 
                     + ' (' + trans_direccion 
                     + ' - ' + trans_telefono
                     + ')'
            


  from Cliente cli left join Provincia pro       on cli.pro_id = pro.pro_id
                   left join Pais pa             on pro.pa_id  = pa.pa_id
                   left join Transporte trans    on cli.trans_id = trans.trans_id

  where cli_id = @@cli_id

  set @trans = isnull(@trans,'')
  select  ''
        +  @rz 
        --+ ' ' + @cuit
        --+ ' ' + @tel 
        + ' ' + @dir 
        + ' ' + @tel2 
        + ' ' + @trans
        +char(13)+char(10)
        +@sucursales

        as Info

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



