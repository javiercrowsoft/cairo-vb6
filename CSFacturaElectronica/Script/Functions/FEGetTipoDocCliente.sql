if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetTipoDocCliente]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetTipoDocCliente]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function FEGetTipoDocCliente (

@@cli_catfiscal smallint

)

returns int

as
begin

/* Tabla AFIP

Código  Descripción
0  CI Policía Federal
1  CI Buenos Aires
2  CI Catamarca
3  CI Córdoba
4  CI Corrientes
5  CI Entre Ríos
6  CI Jujuy
7  CI Mendoza
8  CI La Rioja
9  CI Salta
10  CI San Juan
11  CI San Luis
12  CI Santa Fe
13  CI Santiago del Estero
14  CI Tucumán
16  CI Chaco
17  CI Chubut
18  CI Formosa
19  CI Misiones
20  CI Neuquén
21  CI La Pampa
22  CI Río Negro
23  CI Santa Cruz
24  CI Tierra del Fuego
80  CUIT
86  CUIL
87  CDI
89  LE
90  LC
91  CI extranjera
92  en trámite
93  Acta nacimiento
94  Pasaporte
95  CI Bs. As. RNP
96  DNI
99  Sin identificar/venta global diaria
30  Certificado de Migración
88  Usado por Anses para Padrón

*/


  return case @@cli_catfiscal
                when 1  then 80 -- RI  Inscripto
                when 2  then 80 -- EX  Exento
                when 3  then 80 --RNI  No Inscripto
                when 4  then 96 --CF  Consumidor Final
                when 5  then 80 --EXT  Extranjero
                when 6  then 80 --MON  Monotributo
                when 7  then 80 --EXTIVA  Extranjero con IVA
                when 8  then 80 --NR  No Responsable
                when 9  then 80 --NRE  No Responsable Exento
                when 10  then 80 --NC  No Categorizado
                when 11  then 80 --RIM  Inscripto M
                when 99  then 80 --NN  Desconocido
         end  

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

