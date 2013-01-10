/*---------------------------------------------------------------------
Nombre: Crear articulo de Compra desde Cuenta
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_PRD_9999]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_PRD_9999]

/*

 select * from TmpStringToTable

 DC_CSC_PRD_9999 1,'', 'e10452,e10453,e10454,e10455,e10456,e10457,e10458,e10459'

 DC_CSC_PRD_9999 1, '2739696'

*/

go
create procedure DC_CSC_PRD_9999 (

  @@us_id          int,

  @@cue_id          varchar(255),
  @@un_id          varchar(5000),
  @@ti_idri        varchar(5000),
  @@ti_idrni       varchar(5000)
)as 
begin

set nocount on

create table #t_dc_csc_prd_9999 (pr_id int, cue_id int)

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id int

declare @ram_id_cuenta int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

--////////////////////////////////////////////////////////////////////////

declare  @un_id          int
declare  @ti_idri        int
declare  @ti_idrni       int
declare @cueg_id        int

if isnumeric(@@un_id) = 0 begin
  select 1, 'Debe indicar una unidad' as Error
end

if isnumeric(@@ti_idri) = 0 begin
  select 1, 'Debe indicar una tasa impositiva para el RI' as Error
end

if isnumeric(@@ti_idrni) = 0 begin
  select 1, 'Debe indicar una tasa impositiva para el RNI' as Error
end

set @un_id    = @@un_id
set @ti_idri  = @@ti_idri
set @ti_idrni = @@ti_idrni

declare c_cue insensitive cursor for 

select 
    cue_id,
    cue_nombre,
    cue_codigo,
    cue_identificacionexterna

from

    cuenta cue

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

       (cue.cue_id = @cue_id or @cue_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )


open c_cue

declare @pr_id                      int
declare @cue_nombre                  varchar(255) 
declare @cue_codigo                  varchar(255) 
declare @cue_identificacionexterna   varchar(255)

fetch next from c_cue into @cue_id, @cue_nombre, @cue_codigo, @cue_identificacionexterna
while @@fetch_status = 0
begin

  exec sp_dbgetnewid 'CuentaGrupo','cueg_id',@cueg_id out, 0

  if not exists (select cueg_id from CuentaGrupo where cueg_codigo = 'C-' + @cue_identificacionexterna) begin

    insert into CuentaGrupo (cueg_id, cueg_nombre, cueg_codigo, cue_id, modifico, cueg_tipo)
                  values    (@cueg_id, 'C-' + @cue_nombre, 'C-' + @cue_identificacionexterna, @cue_id, @@us_id, 2)
  
    exec sp_dbgetnewid 'Producto','pr_id', @pr_id out, 0

    if exists(select pr_id from Producto where pr_codigo = @cue_identificacionexterna) 
          set @cue_identificacionexterna = @cue_identificacionexterna + convert(varchar(8),getdate(),14)
  
    insert into Producto (pr_id, pr_nombrecompra, pr_nombreventa, pr_secompra, pr_codigo, ti_id_ivaricompra, ti_id_ivarnicompra, cueg_id_compra, un_id_compra, modifico)
                  values (@pr_id, @cue_nombre, @cue_nombre, 1, @cue_identificacionexterna, @ti_idri, @ti_idrni, @cueg_id, @un_id, @@us_id)

    insert into #t_dc_csc_prd_9999 (pr_id) values (@pr_id)

  end else

    insert into #t_dc_csc_prd_9999 (cue_id) values (@cue_id)

  fetch next from c_cue into @cue_id, @cue_nombre, @cue_codigo, @cue_identificacionexterna
end

close c_cue
deallocate c_cue

select 1, cue_nombre as [Cuentas que ya existian], pr_nombrecompra [Articulos creados], pr_codigo as [Codigo]
from #t_dc_csc_prd_9999 t left join cuenta cue on t.cue_id = cue.cue_id
                          left join producto pr on t.pr_id = pr.pr_id

end
go