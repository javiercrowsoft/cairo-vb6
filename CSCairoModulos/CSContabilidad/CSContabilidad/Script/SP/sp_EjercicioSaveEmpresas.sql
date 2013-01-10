if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioSaveEmpresas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioSaveEmpresas]

-- sp_EjercicioSaveEmpresas 1,1

go
create procedure sp_EjercicioSaveEmpresas (

  @@ejc_id         int

)as 
begin

  set nocount on

  declare @@emp_id           varchar(50)
  declare @emp_id           int
  declare @ram_id_empresa   int

  select   @@emp_id = emp_id

  from EjercicioContable

  where ejc_id = @@ejc_id

  declare @clienteID         int
  declare @IsRaiz            tinyint

  exec sp_GetRptId @clienteID out

  exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

  if @ram_id_empresa <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
    end else 
      set @ram_id_empresa = 0
  end
  
  delete EjercicioContableEmpresa where ejc_id = @@ejc_id

  if @emp_id <> 0 begin

    insert into EjercicioContableEmpresa (ejc_id, emp_id) values(@@ejc_id, @emp_id)

  end else begin

    insert into EjercicioContableEmpresa (ejc_id, emp_id) 
    select @@ejc_id, rptarb_hojaid
    from rptArbolRamaHoja 
    where rptarb_cliente = @clienteID 
      and tbl_id = 1018 

  end
  
end
go