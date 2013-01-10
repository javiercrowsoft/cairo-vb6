if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9997]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9997]
GO
/*  

Para testear:

[DC_CSC_CON_9997] 70,'20051001 00:00:00','20060930 00:00:00','0','0','0','0','5'

DC_CSC_CON_9997 1, 
                '20060101',
                '20060120',
                '0', 
                '0',
                '0',
                '0',
                '0'
*/

create procedure DC_CSC_CON_9997 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,
  @@pro_id      varchar(255),
  @@perc_id       varchar(255),
  @@ret_id      varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pro_id         int
declare @ret_id         int
declare @perc_id        int
declare @rett_id        int
declare @perct_id       int

declare @ram_id_provincia         int
declare @ram_id_retencion         int
declare @ram_id_percepcion        int


declare @clienteID       int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,           @pro_id    out,         @ram_id_provincia out
exec sp_ArbConvertId @@ret_id,            @ret_id   out,         @ram_id_retencion out
exec sp_ArbConvertId @@perc_id,          @perc_id  out,         @ram_id_percepcion out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_provincia <> 0 begin

--  exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
  end else 
    set @ram_id_provincia = 0
end

if @ram_id_retencion <> 0 begin

--  exec sp_ArbGetGroups @ram_id_retencion, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_retencion, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_retencion, @clienteID 
  end else 
    set @ram_id_retencion = 0
end

if @ram_id_percepcion <> 0 begin

--  exec sp_ArbGetGroups @ram_id_retencion, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_percepcion, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_percepcion, @clienteID 
  end else 
    set @ram_id_percepcion = 0
end

if @perc_id = 0 begin

  select 1,'Debe indicar una percepcion. Recuerde que solo puede seleccionar una sola percepcion.' as Info, '' as dummycol
  return
end

if @ret_id = 0 begin

  select 1,'Debe indicar una percepcion. Recuerde que solo puede seleccionar una sola percepcion.' as Info, '' as dummycol
  return
end


select @rett_id = rett_id from Retencion where ret_id = @ret_id

select @perct_id = perct_id from Percepcion where perc_id = @perc_id

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

--////////////////////////////////////////////////////////////////////////////////////////////
--
-- clientes
--
--////////////////////////////////////////////////////////////////////////////////////////////

declare c_clientes insensitive cursor for

select distinct

      cli_id

from 

    cliente cli

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  (cli.pro_id = @pro_id   or @pro_id  =0)

-- Arboles

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 
                  and  rptarb_hojaid = cli.pro_id
                 ) 
           )
        or 
           (@ram_id_provincia = 0)
       )

open c_clientes

declare @cli_id int
declare @cliperc_id int

fetch next from c_clientes into @cli_id

while @@fetch_status=0
begin

  if not exists(select * from clientepercepcion cp left join percepcion perc on cp.perc_id = perc.perc_id
                where cliperc_desde >= @@Fini 
                  and cliperc_hasta <= @@Ffin 
                  and cli_id = @cli_id
                  and perc.perct_id = @perct_id
                ) 
  begin

    exec sp_dbgetnewid 'ClientePercepcion', 'cliperc_id', @cliperc_id out, 0

    insert into ClientePercepcion(cliperc_id, cli_id, perc_id, cliperc_desde, cliperc_hasta, modifico, cliperc_generadoporproceso)
                          values (@cliperc_id, @cli_id, @perc_id, @@Fini, @@Ffin, @@us_id, 1)

  end

  fetch next from c_clientes into @cli_id
end

close c_clientes

deallocate c_clientes

--////////////////////////////////////////////////////////////////////////////////////////////
--
-- proveedores
--
--////////////////////////////////////////////////////////////////////////////////////////////

declare c_proveedores insensitive cursor for

select distinct

      prov_id

from 

    proveedor prov

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  (prov.pro_id = @pro_id   or @pro_id  =0)

-- Arboles

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 
                  and  rptarb_hojaid = prov.pro_id
                 ) 
           )
        or 
           (@ram_id_provincia = 0)
       )

open c_proveedores

declare @prov_id int
declare @provret_id int

fetch next from c_proveedores into @prov_id

while @@fetch_status=0
begin

  if not exists(select * from ProveedorRetencion pr left join retencion ret on pr.ret_id = ret.ret_id
                where provret_desde >= @@Fini 
                  and provret_hasta <= @@Ffin 
                  and prov_id = @prov_id
                  and ret.rett_id = @rett_id
                ) 
  begin

    exec sp_dbgetnewid 'ProveedorRetencion', 'provret_id', @provret_id out, 0

    insert into ProveedorRetencion(provret_id, prov_id, ret_id, provret_desde, provret_hasta, modifico, provret_generadoporproceso)
                          values (@provret_id, @prov_id, @ret_id, @@Fini, @@Ffin, @@us_id, 1)

  end

  fetch next from c_proveedores into @prov_id
end

close c_proveedores

deallocate c_proveedores


select 1,'El proceso concluyo con exito' as Info, '' as dummycol

end
GO