if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetDigitoVerificador]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetDigitoVerificador]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*

select dbo.FEGetDigitoVerificador('01234567890')

*/

create function FEGetDigitoVerificador (

@@codigo_barra varchar(255)

)

returns smallint

as
begin

/*
    Se considera para efectuar el cálculo el siguiente ejemplo:

    01234567890

    Etapa 1: Comenzar desde la izquierda, sumar todos los caracteres ubicados en las posiciones impares.

    0 + 2 + 4 + 6 + 8 + 0 = 20

    Etapa 2: Multiplicar la suma obtenida en la etapa 1 por el número 3.

    20 x 3 = 60

    Etapa 3: Comenzar desde la izquierda, sumar todos los caracteres que están ubicados en las posiciones pares.

    1 + 3 + 5+ 7 + 9 = 25

    Etapa 4: Sumar los resultados obtenidos en las etapas 2 y 3.

    60 + 25 = 85

    Etapa 5: Buscar el menor número que sumado al resultado obtenido en la etapa 4 dé un número múltiplo de 10. Este será el valor del dígito verificador del módulo 10.

    85 + 5 = 90

    De esta manera se llega a que el número 5 es el dígito verificador módulo 10 para el código 01234567890

    Siendo el resultado final:

    012345678905
*/

	declare @sumImpar int
	declare @sumPar int
	declare @n int

	set @sumImpar = 0
	set @sumPar = 0

	set @n = 1

	--Etapa 1: Comenzar desde la izquierda, sumar todos los caracteres ubicados en las posiciones impares.

	while @n <= len(@@codigo_barra)
	begin

		set @sumImpar = @sumImpar + convert(int,substring(@@codigo_barra,@n,1))

		set @n = @n + 2
	end

	--Etapa 2: Multiplicar la suma obtenida en la etapa 1 por el número 3.

	set @sumImpar = @sumImpar * 3

	--Etapa 3: Comenzar desde la izquierda, sumar todos los caracteres que están ubicados en las posiciones pares.

	set @n = 2

	while @n <= len(@@codigo_barra)
	begin

		set @sumPar = @sumPar + convert(int,substring(@@codigo_barra,@n,1))

		set @n = @n + 2
	end

	--Etapa 4: Sumar los resultados obtenidos en las etapas 2 y 3.

	set @n = @sumImpar + @sumPar

	set @n = 10 - (@n % 10)

	--Etapa 5: Buscar el menor número que sumado al resultado obtenido en la etapa 4 dé un número múltiplo de 10. Este será el valor del dígito verificador del módulo 10.

	return @n

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

