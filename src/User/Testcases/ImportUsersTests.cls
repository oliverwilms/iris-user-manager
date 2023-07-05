Class User.Testcases.ImportUsersTests Extends %UnitTest.TestCase
{

ClassMethod Go() As %Status
{
	Set ^UnitTestRoot="/opt/unittests"
	Set tSC = ##class(%UnitTest.Manager).RunTest("iris-user-manager","/loadudl")
	Quit tSC
}

Method TestFile()
{
	Set tFile = "/opt/users/IRISusers.xml"
	Set tExists = ##class(%File).Exists(tFile)
	Set tMessage = $Select(tExists:" exists",1:" does not exist")
	Do ..LogMessage("The file "_tFile_tMessage_".")
	Do $$$AssertEquals(tExists,1,"TestFile")
}

}
