if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Ejercicios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Ejercicios]

/*

sp_lsdoc_Ejercicios 1,'0'

*/

go
create procedure sp_lsdoc_Ejercicios (

  @@us_id    int,

	@@emp_id	varchar(255)

)as 
begin

declare @emp_id int

declare @ram_id_empresa int 

exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_GetRptId @clienteID out

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
			ejc_id,
			''									  as [TypeTask],
			ejc_codigo            as [Código],
			ejc_nombre					  as [Nombre],
			emp_nombre            as [Empresa],

			case when as_id_cierrepatrimonial is null 
						and as_id_cierreresultados is null then 'Abierto'
           else            													'Cierre'
			end										as [Estado],

			ap.as_nrodoc          as [Apertura],
			ap.as_fecha						as [Fecha Apertura],
			acp.as_nrodoc         as [Cierre Patrimonial],
			acp.as_fecha          as [Fecha Cierre Patrimonial],
			acr.as_nrodoc         as [Cierre Resultados],
      acr.as_fecha          as [Fecha Cierre Resultados],

			ejc.Creado,
			ejc.Modificado,
			us_nombre             as [Modifico],
			ejc_descrip						as [Observaciones]
from 
			EjercicioContable ejc

              inner join usuario       on ejc.modifico = usuario.us_id
							left  join empresa       on isnumeric(ejc.emp_id)<>0 and ejc.emp_id = convert(varchar,empresa.emp_id)
							left  join asiento ap    on ejc.as_id_apertura 					= ap.as_id
							left  join asiento acp   on ejc.as_id_cierrepatrimonial = acp.as_id
							left  join asiento acr	 on ejc.as_id_cierreresultados 	= acr.as_id
where 			  

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

		  (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

	order by ejc_codigo

end
