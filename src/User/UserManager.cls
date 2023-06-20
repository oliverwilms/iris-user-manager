Class User.UserManager
{

ClassMethod GetUserData(
	Output pSC As %Status,
	Output pUserData As %String) As %Status
{
	New $NAMESPACE
	Set $NAMESPACE = "%SYS"
	Set tSC = $$$OK
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ "User.UserManager:GetUserData"
	Set q = """"
	Set qCheckbox = q_"checkbox"_q
	Set tNode = ""
	Set tQuery = ""
	Set tQuery($Increment(tQuery)) = "SELECT"
	Set tQuery($Increment(tQuery)) = "ID"
	Set tQuery($Increment(tQuery)) = "FROM Security.Users"
	Set tQuery($Increment(tQuery)) = "ORDER BY ID"
	Set tStatement = ##class(%SQL.Statement).%New()
	Set pSC = tStatement.%Prepare(.tQuery)  // Create a cached query
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ $System.Status.GetOneErrorText(pSC)
	If $$$ISERR(pSC) { Quit tNode }
	//Write "Default Select Mode = ",tStatement.%SelectMode,!  // 0=Logical, 1=ODBC, 2=Display
	#dim tResult As %SQL.StatementResult
	Set tResult = tStatement.%Execute()
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : %SQLCODE=" _ tResult.%SQLCODE
	IF (tResult.%SQLCODE=0) { /* WRITE !,"Created a query",! */ }
	ELSEIF (tResult.%SQLCODE=-361) { /* WRITE !,"Query exists: ",tResult.%Message */ }
	ELSE { /* WRITE !,"CREATE QUERY error: ",tResult.%SQLCODE," ",tResult.%Message */ QUIT tNode }
	Try {
		//Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ "TRY"
		Set myCheckbox = q_"checkbox"_q	
	 	While tResult.%Next() {
			//Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ "WHILE"	
			Set tNode = tResult.ID
			Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ tNode
			Set pUserData(tNode) = ""
			Write "<tr><td>",!
			Set myValue = q_tNode_q
			Set text = "<input type="_qCheckbox_" id="_myCheckbox_" name="_myCheckbox_" value="_myValue_">"
			Write text,!
			Set text = "<label for="_myCheckbox_">"_tNode_"</label><br>"
			Write text,!
			Write "</td></tr>",!
		}
	}
	Catch {
		Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ "CATCH"	
	}
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ $System.Status.GetOneErrorText(tSC)
	Quit tSC
}

ClassMethod GetUserExport(
	Output pFilename As %String = "UserManager.xml",
	Output pUsers As %String = "*") As %String
{
	New $NAMESPACE
	Set $NAMESPACE = "%SYS"
	Set tSC = $$$OK
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ "User.UserManager:GetUserExport"
	Set tSC = ##class(Security.Users).Export(pFilename,.numExported,pUsers)
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : numExported=" _ numExported
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : pFilename=" _ pFilename
	Quit pFilename
}

ClassMethod ReadFile(pFilename As %String = "UserManager.xml") As %String
{
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : " _ "User.UserManager:ReadFile"
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : pFilename=" _ pFilename
	Set x = ##class(User.Util).ReadJsonFile(pFilename)
	Set ^TEST($I(^TEST)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : x=" _ x
	Quit x
}

}
