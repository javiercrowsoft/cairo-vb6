-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_RCO_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_RCO_0010]

go
create procedure DC_CSC_RCO_0010 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@prov_id varchar(255),
@@est_id varchar(255),
@@ccos_id  varchar(255),
@@suc_id  varchar(255),
@@doc_id  varchar(255),
@@cpg_id  varchar(255), -- TODO:EMPRESA
@@emp_id  varchar(255)

)as 

begin 
  exec sp_lsdoc_RemitosCompra 
                          @@us_id,
                          @@Fini,
                          @@Ffin,

                          @@prov_id ,
                          @@est_id ,
                          @@ccos_id,
                          @@suc_id  ,
                          @@doc_id  ,
                          @@cpg_id  ,
                          @@emp_id


end
