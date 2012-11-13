if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_strGetBusqueda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_strGetBusqueda]

go
create procedure sp_strGetBusqueda (
	@@prefix varchar (255),
	@@campos varchar (1000) output
)
as

set nocount on

declare @retval	varchar(5000)
declare @campo	varchar(5000)
declare @caracter varchar(1)
declare @i	int
declare @j	int
declare @z	int
declare @q	int
declare @r	int
declare @t	int
declare @p	int

set @i = 1
set @j = 0
set @z = 0

set @retval =''

--------------------------------------------
-- si no hay prefijo no toco los campos
if @@prefix is null or @@prefix = '' return
-- si no hay campos tampoco
if @@campos is null or @@campos = '' return
--------------------------------------------

set @j = isnull(charindex(',',@@campos,@j+1),0)
set @z = isnull(charindex('(',@@campos,@z+1),0)
--------------------------------------------
if @j = 0
begin

	if @i < @z begin
		--leeo caracter por caracter hasta encontrar el cierre del parentesis
		set @r = len(@@campos)+1
		set @t = @z
		while @t < @r
		begin
			set @caracter = substring(@@campos,@t,1)
			-- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
			if @caracter = '(' set @p = @p + 1
			if @caracter = ')' begin
				-- si encontre el cierre del primer parentesis termine con este campo
				if @p = 0 goto ExitWhile4
				-- sino sigo buscando el parentesis que cierra
				else set @p = @p - 1
			end
			set @t = @t+1
		end
		ExitWhile4:
		set @campo	= ltrim(substring(@@campos,@i,len(@@campos)))
		set @retval 	= @retval + @campo
		set @@campos = @retval
	end
	else	exec sp_strGetRealName @@prefix, @@campos out
	
	return
end
else
begin
	while @j <> 0
	begin	
		-- si hay un parentesis es por que hay un subselect, en cuyo caso no toco nada que este en
		-- el parentesis
		if @i < @z and @z < @j begin

			--leeo caracter por caracter hasta encontrar el cierre del parentesis
			set @r = len(@@campos)+1
			set @t = @z
			while @t < @r
			begin
				set @caracter = substring(@@campos,@t,1)
				-- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
				if @caracter = '(' set @p = @p + 1
				if @caracter = ')' begin
					-- si encontre el cierre del primer parentesis termine con este campo
					if @p = 0 goto ExitWhile1
					-- sino sigo buscando el parentesis que cierra
					else set @p = @p - 1
				end
				set @t = @t+1
			end
			ExitWhile1:
			-- ahora busco una coma a partir del ultimo parentesis
			set @j		= charindex(',',@@campos,@t+1)

			-- si la encuentro agrego el campo tal como esta a la sentencia
			if @j > 0 begin
				set @campo	= ltrim(substring(@@campos,@i,@j-@i+1))
				set @retval 	= @retval + @campo
				-- me preparo para buscar la proxima coma
				set @i 		= @j + 1
				set @j		= charindex(',',@@campos,@j+1)
				set @z = charindex('(',@@campos,@i+1)
			-- si no encuentro la coma es porque se terminaron los campos, asi que
			-- agrego el campo a la sentencia y termine
			end
			else
			begin
				set @campo	= ltrim(substring(@@campos,@i,len(@@campos)))
				set @retval 	= @retval + @campo
				-- con esto voy al final
				goto ExitWhile2
			end
			
		end
		else begin
			set @campo	= ltrim(substring(@@campos,@i,@j-@i+1))
			exec sp_strGetRealName @@prefix, @campo out
			set @retval 	= @retval + @campo
			set @i 		= @j + 1
			set @j		= charindex(',',@@campos,@j+1)
			-- busco el proximo parentesis
			set @z = charindex('(',@@campos,@i+1)
		end
	end

	if @i < @z begin
		--leeo caracter por caracter hasta encontrar el cierre del parentesis
		set @r = len(@@campos)+1
		set @t = @z
		while @t < @r
		begin
			set @caracter = substring(@@campos,@t,1)
			-- si encuentro un parentesis abierto, incremento un contador para buscar uno cerrado
			if @caracter = '(' set @p = @p + 1
			if @caracter = ')' begin
				-- si encontre el cierre del primer parentesis termine con este campo
				if @p = 0 goto ExitWhile3
				-- sino sigo buscando el parentesis que cierra
				else set @p = @p - 1
			end
			set @t = @t+1
		end
		ExitWhile3:
		set @campo	= ltrim(substring(@@campos,@i,len(@@campos)))
		set @retval 	= @retval + @campo
	end
	else begin
		set @campo	= ltrim(substring(@@campos,@i,len(@@campos)))
		exec sp_strGetRealName @@prefix, @campo out
		set @retval 	= @retval + @campo
	end
end
ExitWhile2:

--------------------------------------------
set @@campos = @retval
