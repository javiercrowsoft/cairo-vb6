/*

declare @x varchar(4000)
exec InitCap 'Remedios de escalada del general jose de san martin', @x out
select @x

*/

alter procedure InitCap 
( 

	@InputString 		varchar(5000),
	@OutputString   varchar(5000) out

) 
AS
BEGIN

DECLARE @Index          INT
DECLARE @Char           CHAR(1)
DECLARE @PrevChar       CHAR(1)

SET @OutputString = LOWER(@InputString)
SET @Index = 1

WHILE @Index <= LEN(@InputString)
BEGIN
    SET @Char     = SUBSTRING(@InputString, @Index, 1)
    SET @PrevChar = CASE WHEN @Index = 1 THEN ' '
                         ELSE SUBSTRING(@InputString, @Index - 1, 1)
                    END

    IF @PrevChar IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
    BEGIN
        IF @PrevChar != '''' OR UPPER(@Char) != 'S'
            SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(@Char))
    END

		set @OutputString = replace(@OutputString,' En ', ' en ')
		set @OutputString = replace(@OutputString,' A ', ' a ')
		set @OutputString = replace(@OutputString,' El ', ' el ')
		set @OutputString = replace(@OutputString,' La ', ' la ')
		set @OutputString = replace(@OutputString,' De ', ' de ')
		set @OutputString = replace(@OutputString,' Un ', ' un ')
		set @OutputString = replace(@OutputString,' Una ', ' una ')
		set @OutputString = replace(@OutputString,' Del ', ' del ')
		set @OutputString = replace(@OutputString,' Por ', ' por ')
		set @OutputString = replace(@OutputString,' Para ', ' para ')

    SET @Index = @Index + 1
END

END
GO
