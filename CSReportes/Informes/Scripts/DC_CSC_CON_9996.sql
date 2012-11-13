
/*---------------------------------------------------------------------
Nombre: Balance
---------------------------------------------------------------------*/

/*
exec DC_CSC_CON_9996 

1,
'20000101',
'20100101',

'0',
'0',
'0',
'1'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9996]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9996]

go
create procedure DC_CSC_CON_9996 (

  @@us_id    				int,
	@@cue_id					varchar(255), 
	@@cuec_id  				int

)as 

begin

set nocount on

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

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

update cuenta set cuec_id = @@cuec_id

where 
   		(cue_id = @cue_id or @cue_id=0)
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


----------------------------------------------------------
select 1 as aux_id,
			 '' as Codigo,
			 '' as Cuenta,
			 '' as Categoria,
			 'Las cuentas se actualizaron con exito' as Info
union all
select 2 as aux_id,
			 cue_codigo,
			 cue_nombre,
			 cuec_nombre,
			 ''

from Cuenta cue inner join CuentaCategoria cuec on cue.cuec_id = cuec.cuec_id

where 
   		(cue_id = @cue_id or @cue_id=0)
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

end
go


