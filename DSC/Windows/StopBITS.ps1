configuration ExampleDSC
{
Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node localhost
    {
        Service StopBITS
        {
            Name = 'BITS'
            Ensure = 'Present'
            State = 'Stopped'
        }
    }
 
}
ExampleDSC
Start-DscConfiguration ExampleDSC -Wait -Verbose -Force