/*

DC_CSC_VEN_9730 1, '1', '0', 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9730]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9730]

go
create procedure DC_CSC_VEN_9730 (

@@us_id               int,
@@pr_id                varchar(255),
@@pr_activoweb        smallint

)as 
begin

  set nocount on

  if @@pr_activoweb <> 0 set @@pr_activoweb = 1

  declare @pr_id int

  declare @pr_id_param     int
  declare @ram_id_Producto int
  
  declare @clienteID   int
  declare @IsRaiz     tinyint

  exec sp_ArbConvertId @@pr_id, @pr_id_param out, @ram_id_Producto out

  exec sp_GetRptId @clienteID out

  if @ram_id_Producto <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
    end else 
      set @ram_id_Producto = 0
  end
  
  -----------------------------------------------------------------------------

  update producto set pr_activoweb = @@pr_activoweb          
  where pr_id in (

                    select pr_id from Producto 
                      where (      
                                      (pr_id = @pr_id_param or @pr_id_param=0)
                                
                                -- Arboles
                                and   (
                                          (exists(select rptarb_hojaid 
                                                  from rptArbolRamaHoja 
                                                  where
                                                       rptarb_cliente = @clienteID
                                                  and  tbl_id = 30 
                                                  and  rptarb_hojaid = pr_id
                                                 ) 
                                           )
                                        or 
                                           (@ram_id_Producto = 0)
                                       )
                            )

                  )

  -----------------------------------------------------------------------------

  select  pr.pr_id,
          pr_codigo          as Codigo,
          pr_nombrecompra   as [Nombre Compra],
          pr_nombreventa    as [Nombre Venta],
          pr_nombreweb      as [Nombre web],
          case when pr_activoweb = 0 then 'No' else 'Si' end 
                            as [Activo Web]
          
  from Producto pr 
  where pr.pr_id in (

                    select pr_id from Producto 
                      where (      
                                      (pr_id = @pr_id_param or @pr_id_param=0)
                                
                                -- Arboles
                                and   (
                                          (exists(select rptarb_hojaid 
                                                  from rptArbolRamaHoja 
                                                  where
                                                       rptarb_cliente = @clienteID
                                                  and  tbl_id = 30 
                                                  and  rptarb_hojaid = pr_id
                                                 ) 
                                           )
                                        or 
                                           (@ram_id_Producto = 0)
                                       )
                            )

                  )
end
go