/*

  Nombre: Historia de uso por usuario o departamento

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_IMP_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_IMP_0010]

/*

DC_CSC_IMP_0010 1,'20010101','20100101','0',1

*/

go
create procedure DC_CSC_IMP_0010 (

  @@us_id    					 int,
	@@Fini 		 					 datetime,
	@@Ffin 		 					 datetime,
	@@impp_id  					 varchar(255),
	@@impl_severidad     tinyint

)as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @impp_id int

declare @ram_id_importacionProceso int

declare @clienteID int
declare @IsRaiz    tinyint

set @@Ffin = DateAdd(d,1,@@Ffin)

exec sp_ArbConvertId @@impp_id, @impp_id out, @ram_id_importacionProceso out

exec sp_GetRptId @clienteID out

if @ram_id_importacionProceso <> 0 begin

--	exec sp_ArbGetGroups @ram_id_importacionProceso, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_importacionProceso, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_importacionProceso, @clienteID 
	end else 
		set @ram_id_importacionProceso = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

	impl_id,
	impl_fecha				as Fecha,
	case impl_severidad
		when   1 then  'Info'					-- LogSevInformation = 1
  	when   2 then  'Advertencia'	-- LogSevWarnning = 2
  	when 	 3 then  'Error'        -- LogSevError = 3
	end 							as Severidad,
	impl.impp_id,
	impl_severidad    as impl_severidad_id,
	impp_nombre 			as Proceso,
  impl_descrip 			as Observaciones

from ImportacionLog impl inner join ImportacionProceso impp on impl.impp_id = impp.impp_id

where 
				  impl_fecha >= @@Fini
			and	impl_fecha <= @@Ffin 
			and (impl_severidad = @@impl_severidad or @@impl_severidad = 0)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (impl.impp_id = @impp_id or @impp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 23002
                  and  rptarb_hojaid = impl.impp_id
							   ) 
           )
        or 
					 (@ram_id_importacionProceso = 0)
			 )

end

GO