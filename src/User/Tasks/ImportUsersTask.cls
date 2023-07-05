TasksClass User.Tasks.ImportUsersTask Extends %SYS.Task.Definition
{

Parameter TaskName = "Import IRIS Users";

ClassMethod FindMyID() As %String
{
	Set pQuery = "SELECT ID FROM %SYS.Task WHERE TaskClass = 'User.Tasks.ImportUsersTask'"
	Set pResult = ""
	Set rs = ##class(%ResultSet).%New()
	Set tSC = rs.Prepare(pQuery)
	If $$$ISOK(tSC) {
		Set tSC = rs.Execute()
		If $$$ISOK(tSC), rs.Next() Set pResult = rs.GetData(1)
	}
	Do rs.Close()
	Set rs = ""
	If (pResult '= "") { Quit pResult }
	Set objTask = ##class(%SYS.Task).%New()
	Set objTask.Description = "Create users from an OC secret mounted as a volume"
	Set objTask.MirrorStatus = 3  // "Any"
	Set objTask.Name = ..#TaskName
	Set objTask.NameSpace = "%SYS"
	Set objTask.RunAsUser = "_SYSTEM"
	Set objTask.TaskClass = "User.Tasks.ImportUsersTask"
	Set objTask.TimePeriod = 5  // "On Demand"
	Set tSC = objTask.%Save()
	Set pResult = objTask.%Id()
	Quit pResult
}

ClassMethod Import() As %Status
{
	//Create users from an OC secret mounted as a volume
	If (##class(%File).Exists("/opt/users/IRISusers.xml")=0) {
		Set tMessage = "/opt/users/IRISusers.xml file does not exist."
		Do ##class(%SYS.System).WriteToConsoleLog("User.Tasks.ImportUsersTask: "_tMessage,0,0)
	}
	If ##class(%File).Exists("/opt/users/IRISusers.xml") {
		Set tSC = ##class(Security.Users).Import("/opt/users/IRISusers.xml",.Num)
		If $$$ISERR(tSC) {
			Set tMessage = $System.Status.GetOneErrorText(tSC)
			Do ##class(%SYS.System).WriteToConsoleLog("User.Tasks.ImportUsersTask: "_tMessage,0,0)
		}
		$$$ThrowOnError(tSC)
		Set tMessage = $Get(Num,0)_" users imported."
		Do ##class(%SYS.System).WriteToConsoleLog("User.Tasks.ImportUsersTask: "_tMessage,0,0)
	}
	Quit $Get(tSC,$$$OK)
}

Method OnTask() As %Status
{
	Quit ##class(User.Tasks.ImportUsersTask).Import()
}

ClassMethod RunNow() As %Status
{
	Set tID = ..FindMyID()
	Set tSC = ##class(%SYS.Task).RunNow(tID)
	Quit tSC
}

}
