/*---------------------------------------------------------------------
Nombre: Ver Proveedors que tienen mal el cuit
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_COM_9983 1, 09009

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9983]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9983]

go
create procedure DC_CSC_COM_9983 (
	@@us_id 		int,

  @@prov_id   				varchar(255)

)as 

begin

  set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id   		int

declare @ram_id_Proveedor          int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id,  		 @prov_id out,  			@ram_id_Proveedor out

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
	end else 
		set @ram_id_Proveedor = 0
end

--//////////////////////////////////////////////////////////////////////////////////////////

	select 	prov_id,
					prov_nombre				as Proveedor,
					prov_razonsocial		as [Razon Social],
					replace(prov.prov_cuit,'-','')					
														as Cuit,

					case prov_catfiscal
						when 1 then 'Inscripto'
						when 2 then 'Exento'
						when 3 then 'No inscripto'
						when 4 then 'Consumidor Final'
						when 5 then 'Extranjero'
						when 6 then 'Mono Tributo'
						when 7 then 'Extranjero Iva'
						when 8 then 'No responsable'
						when 9 then 'No Responsable exento'
						when 10 then 'No categorizado'
						when 11 then 'Inscripto M'
		        else 'Sin categorizar'
					end 							as Categoria,

					case 
						when afip.iva = 'NI' then	'NI- No Inscripto'
						when afip.iva = 'AC' then	'AC- Activo'
						when afip.iva = 'EX' then	'EX- Exento'
						when afip.iva = 'NA' then	'NA- No Alcanzado'
						when afip.iva = 'XN' then	'XN- Exento no Alcanzado'
						when afip.iva = 'AN' then	'AN- Activo no Alcanzado'
					end								as [Categoria Afip Insc.],

					case 
						when afip.monotributo = 'NI' then	'NI- No Inscripto'
						else                              'Categoria ' + afip.monotributo
					end								as [Categoria Afip Mono.],

					case 
						when afip.cuit is null then 'No esta en AFIP'
						else												''
					end								as [En AFIP],
					''								as dummy_col

	from Proveedor prov left join afip..AfipInscripcion afip on replace(prov.prov_cuit,'-','') = afip.cuit


	where
					(
								(prov_catfiscal = 1 and afip.iva <> 'AC')
						or	(prov_catfiscal = 2 and afip.iva <> 'EX' and afip.iva <> 'XN')
						or	(prov_catfiscal = 6 and (afip.monotributo = 'NI' or afip.monotributo = ''))
					)

    and   (prov.prov_id  = @prov_id   or @prov_id=0)

    and   (
    					(exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 29 
                      and  rptarb_hojaid = prov.prov_id
    							   ) 
               )
            or 
    					 (@ram_id_Proveedor = 0)
    			 )

end
go
