/*---------------------------------------------------------------------
Nombre: Expiración de garantías
---------------------------------------------------------------------*/

/*DC_CSC_CXT_0010 1, 20050202,20060101,20050808,10*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CXT_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CXT_0010]

GO
create procedure DC_CSC_CXT_0010 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,
	@@Fvto 		 datetime,

@@prov_id varchar(255),
@@mon_id  varchar(255),
@@codigo  			varchar(255),
@@nropoliza  		varchar(255),
@@codigoaduana  varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id int
declare @mon_id int

declare @ram_id_proveedor int
declare @ram_id_moneda int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
exec sp_ArbConvertId @@mon_id, @mon_id out, @ram_id_moneda out

exec sp_GetRptId @clienteID out

if @ram_id_proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
	end else 
		set @ram_id_proveedor = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end


/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 
				gar_id                  as comp_id,							
				1                       as Orden_Id,							
				gar_codigo							as [Codigo],
				gar_nropoliza						as [Nro. Poliza],
				gar_codigoaduana				as [Codigo Aduana],
				gar_fecha								as [Fecha],
				gar_fechainicio					as [Fecha Inicio],
				gar_fechavto						as [Fecha Vto.],
				gar_monto								as [Monto],
				gar_cuota								as [Cuota],
				gar_diavtocuota					as [Dia Vto. Cuota],
				prov_nombre							as [Aseguradora],
				mon_nombre							as [Moneda],
				us_nombre								as [Modifico],
				Garantia.creado					as [Creado],
				Garantia.modificado			as [Modificado],
				gar_descrip							as [Observaciones]

from 

			Garantia inner join Proveedor on Garantia.prov_id = Proveedor.prov_id
               inner join Moneda    on Garantia.mon_id = Moneda.mon_id
               inner join Usuario   on Garantia.modifico = Usuario.us_id

where 

				  gar_fecha >= @@Fini
			and	gar_fecha <= @@Ffin 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Proveedor.prov_id = @prov_id or @prov_id=0)
and   (Moneda.mon_id 		 = @mon_id or @mon_id=0)
and   (gar_codigo 			like @@codigo or @@codigo = '')
and   (gar_nropoliza 		like @@nropoliza or @@nropoliza = '')
and   (gar_codigoaduana like @@codigoaduana or @@codigoaduana = '')
-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Garantia.prov_id
							   ) 
           )
        or 
					 (@ram_id_proveedor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Garantia.mon_id
							   ) 
           )
        or 
					 (@ram_id_moneda = 0)
			 )

GO