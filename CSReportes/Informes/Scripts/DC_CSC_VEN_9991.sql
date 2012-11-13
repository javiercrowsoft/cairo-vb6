/*

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9991]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9991]


go
create procedure DC_CSC_VEN_9991 (

  @@us_id    		int,

  @@cli_id   				varchar(255),
  @@emp_id	   			varchar(255) 

)as 
begin

  set nocount on

declare @emp_id	  		int
declare @cli_id   		int

declare @ram_id_empresa      	int
declare @ram_id_cliente       int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out, 			@ram_id_empresa out
exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
  
exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end



  declare @cli_id2  int
	declare @emp_id2  int
  
  declare c_empcli insensitive cursor for 
  
    select cli_id, emp_id from cliente cli, empresa emp
    where cli_id not in (select cli_id from empresacliente where emp_id = emp.emp_id and cli_id = cli.cli_id)

      and   (cli_id = @cli_id or @cli_id = 0)
  
      and   (
    					(exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 28 
                      and  rptarb_hojaid = cli_id
    							   ) 
               )
            or 
    					 (@ram_id_cliente = 0)
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

  open c_empcli

	declare @empcli_id int
  
  fetch next from c_empcli into @cli_id2, @emp_id2
  while @@fetch_status = 0
  begin
  
  	exec sp_dbgetnewid 'EmpresaCliente','empcli_id',@empcli_id out, 0
  
		insert into EmpresaCliente (empcli_id, emp_id, cli_id, modifico) values (@empcli_id, @emp_id2, @cli_id2, @@us_id)  
  
  	fetch next from c_empcli into @cli_id2, @emp_id2
  
  end
  
  close c_empcli
  deallocate c_empcli

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los clientes han sido actualizados' as Info

end
go
 