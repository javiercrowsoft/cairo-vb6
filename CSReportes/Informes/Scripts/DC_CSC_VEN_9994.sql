/*

Permite asociar rapidamente una lista de precios a un conjunto de clientes.

[DC_CSC_VEN_9994] 1,'0','24',-1

OJO: Actualmente esta muy verde, y asocia a todos los clientes la lista 10.

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9994]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9994]


go
create procedure DC_CSC_VEN_9994 (

  @@us_id    		int,

  @@cli_id   				varchar(255),
  @@lp_id	   				varchar(255),
  @@listaDefault    smallint     

)as 
begin

  set nocount on

declare @lp_id	  		int
declare @cli_id   		int

declare @ram_id_listaPrecio      int
declare @ram_id_cliente          int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@lp_id,        @lp_id out, 				@ram_id_listaPrecio out
exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
  
exec sp_GetRptId @clienteID out

if @ram_id_listaPrecio <> 0 begin
  select 1 as aux_id, 'Usted debe indicar una sola lista de precios, no puede indicar una carpeta o múltiple selección.' as Error 
  return
end

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

  declare @lpcli_id int
  declare @cli_id2  int
  
  declare c_lpcli insensitive cursor for 
  
    select cli_id from cliente 
    where cli_id not in (select cli_id from listapreciocliente where lp_id = @lp_id)

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


  open c_lpcli
  
  fetch next from c_lpcli into @cli_id2
  while @@fetch_status = 0
  begin
  
  	exec sp_dbgetnewid 'listapreciocliente','lpcli_id',@lpcli_id out, 0
  
  	insert into listapreciocliente (lpcli_id,lp_id,cli_id,creado,modificado,modifico)
  					values (@lpcli_id, @lp_id, @cli_id2,getdate(),getdate(),1)
  
  
  	fetch next from c_lpcli into @cli_id2
  
  end
  
  close c_lpcli
  deallocate c_lpcli

  if @@listaDefault <> 0 begin
  
    update cliente set lp_id = @lp_id
    where 
                (cli_id = @cli_id or @cli_id = 0)
      
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
  end

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los clientes han sido actualizados' as Info

end
go
 