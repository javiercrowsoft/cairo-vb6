if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AjusteInflacionGetCuentasXramId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AjusteInflacionGetCuentasXramId]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

sp_AjusteInflacionGetCuentasXramId 539,1

*/

create procedure sp_AjusteInflacionGetCuentasXramId (
  @@ram_id  int,
  @@tipo    int
)
as

set nocount on

begin

  declare @clienteID int
  
  exec sp_GetRptId @clienteID out
  
  exec sp_ArbGetAllHojas @@ram_id, @clienteID 

  create table #t_cuentas (cue_id int, ajit_id int)

  insert into #t_cuentas (cue_id, ajit_id)

  select distinct cue.cue_id,
          case when @@tipo = 1 and cue.cuec_id = 5 then            5
               when @@tipo = 1 and cue.cuec_id = 6 then            6
                when @@tipo = 1 and cue.cuec_id not in (5,6) then  1
               when @@tipo = 3 then                                2
               when @@tipo = 2 and cue.cuec_id = 12 then          4
               when @@tipo = 2 and cue.cuec_id <> 12 then         7
          end  as ajit_id
  from Cuenta cue
  where
        exists(select rptarb_hojaid 
               from rptArbolRamaHoja 
               where
                    rptarb_cliente = @clienteID
               and  tbl_id = 17
               and  rptarb_hojaid = cue.cue_id
             ) 

  select   null as aje_id,
          null as aji_id,
          aji.ajit_id,
          ajit_nombre,
          cue.cue_id,
          cue_nombre,
          cuec_nombre,
          ajit_nombre

  from #t_cuentas aji  inner join Cuenta cue on aji.cue_id = cue.cue_id
                       inner join CuentaCategoria cuec on cue.cuec_id = cuec.cuec_id
                       left  join AjusteInflacionItemTipo ajit on aji.ajit_id = ajit.ajit_id
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



