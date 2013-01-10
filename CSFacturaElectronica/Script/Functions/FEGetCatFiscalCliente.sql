if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetCatFiscalCliente]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetCatFiscalCliente]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function FEGetCatFiscalCliente  (

@@cli_catfiscal smallint

)

returns int

as
begin

/* Tabla AFIP

Código  Descripción
1  IVA Responsable Inscripto
2  IVA Responsable no Inscripto
3  IVA no Responsable
4  IVA Sujeto Exento
5  Consumidor Final
6  Responsable Monotributo
7  Sujeto no Categorizado
8  Proveedor del Exterior
9  Cliente del Exterior
10  IVA Liberado – Ley Nº 19.640
11  IVA Responsable Inscripto – Agente de Percepción
12  Pequeño Contribuyente Eventual
13  Monotributista Social
14  Pequeño Contribuyente Eventual Social

*/


  return case @@cli_catfiscal
                when 1  then 1 -- RI  Inscripto
                when 2  then 4 -- EX  Exento
                when 3  then 2 --RNI  No Inscripto
                when 4  then 5 --CF  Consumidor Final
                when 5  then 9 --EXT  Extranjero
                when 6  then 6 --MON  Monotributo
                when 7  then 9 --EXTIVA  Extranjero con IVA
                when 8  then 3 --NR  No Responsable
                when 9  then 3 --NRE  No Responsable Exento
                when 10  then 7 --NC  No Categorizado
                when 11  then 1 --RIM  Inscripto M
                when 99  then 7 --NN  Desconocido
         end  

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

