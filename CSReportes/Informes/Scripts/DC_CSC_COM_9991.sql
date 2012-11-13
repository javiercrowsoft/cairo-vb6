/*

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_9991]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_9991]


go
create procedure DC_CSC_COM_9991 (

  @@us_id    		int,

  @@prov_id   			varchar(255),
  @@emp_id	   			varchar(255) 

)as 
begin

  set nocount on

declare @emp_id	  		int
declare @prov_id   		int

declare @ram_id_empresa      		int
declare @ram_id_proveedor       	int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out, 			@ram_id_empresa out
exec sp_ArbConvertId @@prov_id,  		 @prov_id out,  		@ram_id_proveedor out
  
exec sp_GetRptId @clienteID out

if @ram_id_proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
	end else 
		set @ram_id_proveedor = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end



  declare @prov_id2  int
	declare @emp_id2  int
  
  declare c_empprov insensitive cursor for 
  
    select prov_id, emp_id from proveedor prov, empresa emp
    where prov_id not in (select prov_id from empresaproveedor where emp_id = emp.emp_id and prov_id = prov.prov_id)

      and   (prov_id = @prov_id or @prov_id = 0)
  
      and   (
    					(exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 29
                      and  rptarb_hojaid = prov_id
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
                      and  tbl_id = 1018 
                      and  rptarb_hojaid = emp_id
    							   ) 
               )
            or 
    					 (@ram_id_empresa = 0)
    			 )

  open c_empprov

	declare @empprov_id int
  
  fetch next from c_empprov into @prov_id2, @emp_id2
  while @@fetch_status = 0
  begin
  
  	exec sp_dbgetnewid 'empresaproveedor','empprov_id',@empprov_id out, 0
  
		insert into empresaproveedor (empprov_id, emp_id, prov_id, modifico) values (@empprov_id, @emp_id2, @prov_id2, @@us_id)  
  
  	fetch next from c_empprov into @prov_id2, @emp_id2
  
  end
  
  close c_empprov
  deallocate c_empprov

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los proveedores han sido actualizados' as Info

end
go
 