/*

Permite asociar rapidamente una lista de precios a un conjunto de clientes.

[DC_CSC_VEN_9989] 1,'0','24',-1

OJO: Actualmente esta muy verde, y asocia a todos los clientes la lista 10.

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9989]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9989]


go
create procedure DC_CSC_VEN_9989 (

  @@us_id        int,

  @@cli_id           varchar(255),
  @@inf_id           varchar(255) 

)as 
begin

  set nocount on

declare @inf_id        int
declare @cli_id       int

declare @ram_id_informe      int
declare @ram_id_cliente      int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@inf_id,       @inf_id out,       @ram_id_informe out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
  
exec sp_GetRptId @clienteID out

if @ram_id_informe <> 0 begin
  select 1 as aux_id, 'Usted debe indicar un solo informe, no puede indicar una carpeta o múltiple selección.' as Error 
  return
end

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

declare @cli_codigo       varchar(255)
declare @us_id_cli        int
declare @pre_id_informe    int

select @pre_id_informe = pre_id from Informe where inf_id = @inf_id

  declare c_cli insensitive cursor for 

    select   cli_id, 
            cli_codigo,
            us_id

    from Cliente 
    where      (cli_id = @cli_id or @cli_id = 0)
    
        and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 28 
                        and  rptarb_hojaid = cli_id
                       ) 
                 )
              or 
                 (@ram_id_cliente = 0)
             )

  open c_cli

  fetch next from c_cli into @cli_id, @cli_codigo, @us_id_cli 
  while @@fetch_status = 0
  begin

    -- Si el usuario no existe creamos uno nuevo
    --
    if @us_id_cli is null begin

      -- La primera vez lo mandamos activo para que lo cree
      --
      exec sp_clienteUsuarioWebSave @cli_id, @cli_codigo, '', 1, @@us_id

      -- Obtenemos el usuario
      --
      select @us_id_cli = us_id from Cliente where cli_id = @cli_id

      -- Luego lo desactivamos
      --
      update Usuario set Activo = 0 where us_id = @us_id_cli

    end

    -- Ahora asociamos el informe con el usuario
    --
    exec sp_clienteInformeSave @cli_id, @pre_id_informe, @@us_id

    fetch next from c_cli into @cli_id, @cli_codigo, @us_id_cli 
  end

  close c_cli
  deallocate c_cli

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los clientes han sido actualizados' as Info

end
go
 