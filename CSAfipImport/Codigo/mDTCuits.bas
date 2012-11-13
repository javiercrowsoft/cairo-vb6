'****************************************************************
'Microsoft SQL Server 2000
'Visual Basic file generated for DTS Package
'File Name: D:\Proyectos\CSAfipImport\mDTCuits.bas
'Package Name: New Package
'Package Description: DTS package description
'Generated Date: 5/18/2005
'Generated Time: 1:00:44 PM
'****************************************************************

Option Explicit
Public goPackageOld As New DTS.Package
Public goPackage As DTS.Package2
Private Sub Main()
	set goPackage = goPackageOld

	goPackage.Name = "New Package"
	goPackage.Description = "DTS package description"
	goPackage.WriteCompletionStatusToNTEventLog = False
	goPackage.FailOnError = False
	goPackage.PackagePriorityClass = 2
	goPackage.MaxConcurrentSteps = 4
	goPackage.LineageOptions = 0
	goPackage.UseTransaction = True
	goPackage.TransactionIsolationLevel = 4096
	goPackage.AutoCommitTransaction = True
	goPackage.RepositoryMetadataOptions = 0
	goPackage.UseOLEDBServiceComponents = True
	goPackage.LogToSQLServer = False
	goPackage.LogServerFlags = 0
	goPackage.FailPackageOnLogFailure = False
	goPackage.ExplicitGlobalVariables = False
	goPackage.PackageType = 0
	

Dim oConnProperty As DTS.OleDBProperty

'---------------------------------------------------------------------------
' create package connection information
'---------------------------------------------------------------------------

Dim oConnection as DTS.Connection2

'------------- a new connection defined below.
'For security purposes, the password is never scripted

Set oConnection = goPackage.Connections.New("DTSFlatFile")

	oConnection.ConnectionProperties("Data Source") = "D:\CrowSoft\Clientes\A.A.A.R.B.A\Elementos tecnicos\Datos\afip\cuits.tmp.txt"
	oConnection.ConnectionProperties("Mode") = 1
	oConnection.ConnectionProperties("Row Delimiter") = vbCrLf
	oConnection.ConnectionProperties("File Format") = 2
	oConnection.ConnectionProperties("Column Lengths") = "11,30,2,2,2,1,1"
	oConnection.ConnectionProperties("File Type") = 1
	oConnection.ConnectionProperties("Skip Rows") = 0
	oConnection.ConnectionProperties("First Row Column Name") = False
	oConnection.ConnectionProperties("Number of Column") = 7
	
	oConnection.Name = "Connection 1"
	oConnection.ID = 1
	oConnection.Reusable = True
	oConnection.ConnectImmediate = False
	oConnection.DataSource = "D:\CrowSoft\Clientes\A.A.A.R.B.A\Elementos tecnicos\Datos\afip\cuits.tmp.txt"
	oConnection.ConnectionTimeout = 60
	oConnection.UseTrustedConnection = False
	oConnection.UseDSL = False
	
	'If you have a password for this connection, please uncomment and add your password below.
	'oConnection.Password = "<put the password here>"

goPackage.Connections.Add oConnection
Set oConnection = Nothing

'------------- a new connection defined below.
'For security purposes, the password is never scripted

Set oConnection = goPackage.Connections.New("SQLOLEDB")

	oConnection.ConnectionProperties("Integrated Security") = "SSPI"
	oConnection.ConnectionProperties("Persist Security Info") = True
	oConnection.ConnectionProperties("Initial Catalog") = "cairoAAARBA"
	oConnection.ConnectionProperties("Data Source") = "(local)"
	oConnection.ConnectionProperties("Application Name") = "DTS  Import/Export Wizard"
	
	oConnection.Name = "Connection 2"
	oConnection.ID = 2
	oConnection.Reusable = True
	oConnection.ConnectImmediate = False
	oConnection.DataSource = "(local)"
	oConnection.ConnectionTimeout = 60
	oConnection.Catalog = "cairoAAARBA"
	oConnection.UseTrustedConnection = True
	oConnection.UseDSL = False
	
	'If you have a password for this connection, please uncomment and add your password below.
	'oConnection.Password = "<put the password here>"

goPackage.Connections.Add oConnection
Set oConnection = Nothing

'---------------------------------------------------------------------------
' create package steps information
'---------------------------------------------------------------------------

Dim oStep as DTS.Step2
Dim oPrecConstraint as DTS.PrecedenceConstraint

'------------- a new step defined below

Set oStep = goPackage.Steps.New

	oStep.Name = "Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Step"
	oStep.Description = "Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Step"
	oStep.ExecutionStatus = 1
	oStep.TaskName = "Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task"
	oStep.CommitSuccess = False
	oStep.RollbackFailure = False
	oStep.ScriptLanguage = "VBScript"
	oStep.AddGlobalVariables = True
	oStep.RelativePriority = 3
	oStep.CloseConnection = False
	oStep.ExecuteInMainThread = False
	oStep.IsPackageDSORowset = False
	oStep.JoinTransactionIfPresent = False
	oStep.DisableStep = False
	oStep.FailPackageOnError = False
	
goPackage.Steps.Add oStep
Set oStep = Nothing

'---------------------------------------------------------------------------
' create package tasks information
'---------------------------------------------------------------------------

'------------- call Task_Sub1 for task Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task (Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task)
Call Task_Sub1( goPackage	)

'---------------------------------------------------------------------------
' Save or execute package
'---------------------------------------------------------------------------

'goPackage.SaveToSQLServer "(local)", "sa", ""
goPackage.Execute
goPackage.Uninitialize
'to save a package instead of executing it, comment out the executing package line above and uncomment the saving package line
set goPackage = Nothing

set goPackageOld = Nothing

End Sub


'------------- define Task_Sub1 for task Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task (Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task)
Public Sub Task_Sub1(ByVal goPackage As Object)

Dim oTask As DTS.Task
Dim oLookup As DTS.Lookup

Dim oCustomTask1 As DTS.DataPumpTask2
Set oTask = goPackage.Tasks.New("DTSDataPumpTask")
Set oCustomTask1 = oTask.CustomTask

	oCustomTask1.Name = "Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task"
	oCustomTask1.Description = "Copy Data from cuits to [cairoAAARBA].[dbo].[cuits] Task"
	oCustomTask1.SourceConnectionID = 1
	oCustomTask1.SourceObjectName = "D:\CrowSoft\Clientes\A.A.A.R.B.A\Elementos tecnicos\Datos\afip\cuits.tmp.txt"
	oCustomTask1.DestinationConnectionID = 2
	oCustomTask1.DestinationObjectName = "[cairoAAARBA].[dbo].[cuits]"
	oCustomTask1.ProgressRowCount = 1000
	oCustomTask1.MaximumErrorCount = 0
	oCustomTask1.FetchBufferSize = 1
	oCustomTask1.UseFastLoad = True
	oCustomTask1.InsertCommitSize = 0
	oCustomTask1.ExceptionFileColumnDelimiter = "|"
	oCustomTask1.ExceptionFileRowDelimiter = vbCrLf
	oCustomTask1.AllowIdentityInserts = False
	oCustomTask1.FirstRow = 0
	oCustomTask1.LastRow = 0
	oCustomTask1.FastLoadOptions = 2
	oCustomTask1.ExceptionFileOptions = 1
	oCustomTask1.DataPumpOptions = 0
	
Call oCustomTask1_Trans_Sub1( oCustomTask1	)
		
		
goPackage.Tasks.Add oTask
Set oCustomTask1 = Nothing
Set oTask = Nothing

End Sub

Public Sub oCustomTask1_Trans_Sub1(ByVal oCustomTask1 As Object)

	Dim oTransformation As DTS.Transformation2
	Dim oTransProps as DTS.Properties
	Dim oColumn As DTS.Column
	Set oTransformation = oCustomTask1.Transformations.New("DTS.DataPumpTransformCopy")
		oTransformation.Name = "DirectCopyXform"
		oTransformation.TransformFlags = 63
		oTransformation.ForceSourceBlobsBuffered = 0
		oTransformation.ForceBlobsInMemory = False
		oTransformation.InMemoryBlobSize = 1048576
		oTransformation.TransformPhases = 4
		
		Set oColumn = oTransformation.SourceColumns.New("Col001" , 1)
			oColumn.Name = "Col001"
			oColumn.Ordinal = 1
			oColumn.Flags = 48
			oColumn.Size = 11
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.SourceColumns.New("Col002" , 2)
			oColumn.Name = "Col002"
			oColumn.Ordinal = 2
			oColumn.Flags = 48
			oColumn.Size = 30
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.SourceColumns.New("Col003" , 3)
			oColumn.Name = "Col003"
			oColumn.Ordinal = 3
			oColumn.Flags = 48
			oColumn.Size = 2
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.SourceColumns.New("Col004" , 4)
			oColumn.Name = "Col004"
			oColumn.Ordinal = 4
			oColumn.Flags = 48
			oColumn.Size = 2
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.SourceColumns.New("Col005" , 5)
			oColumn.Name = "Col005"
			oColumn.Ordinal = 5
			oColumn.Flags = 48
			oColumn.Size = 2
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.SourceColumns.New("Col006" , 6)
			oColumn.Name = "Col006"
			oColumn.Ordinal = 6
			oColumn.Flags = 48
			oColumn.Size = 1
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.SourceColumns.New("Col007" , 7)
			oColumn.Name = "Col007"
			oColumn.Ordinal = 7
			oColumn.Flags = 48
			oColumn.Size = 1
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.SourceColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col001" , 1)
			oColumn.Name = "Col001"
			oColumn.Ordinal = 1
			oColumn.Flags = 120
			oColumn.Size = 11
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col002" , 2)
			oColumn.Name = "Col002"
			oColumn.Ordinal = 2
			oColumn.Flags = 120
			oColumn.Size = 30
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col003" , 3)
			oColumn.Name = "Col003"
			oColumn.Ordinal = 3
			oColumn.Flags = 120
			oColumn.Size = 2
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col004" , 4)
			oColumn.Name = "Col004"
			oColumn.Ordinal = 4
			oColumn.Flags = 120
			oColumn.Size = 2
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col005" , 5)
			oColumn.Name = "Col005"
			oColumn.Ordinal = 5
			oColumn.Flags = 120
			oColumn.Size = 2
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col006" , 6)
			oColumn.Name = "Col006"
			oColumn.Ordinal = 6
			oColumn.Flags = 120
			oColumn.Size = 1
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

		Set oColumn = oTransformation.DestinationColumns.New("Col007" , 7)
			oColumn.Name = "Col007"
			oColumn.Ordinal = 7
			oColumn.Flags = 120
			oColumn.Size = 1
			oColumn.DataType = 129
			oColumn.Precision = 0
			oColumn.NumericScale = 0
			oColumn.Nullable = True
			
		oTransformation.DestinationColumns.Add oColumn
		Set oColumn = Nothing

	Set oTransProps = oTransformation.TransformServerProperties

		
	Set oTransProps = Nothing

	oCustomTask1.Transformations.Add oTransformation
	Set oTransformation = Nothing

End Sub

