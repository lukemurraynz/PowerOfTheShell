#Sets Password to account:
$RoomMailboxIdentity = 'MeetingRoom'
$RoomMailPassword = 'password'
Set-Mailbox -Identity $RoomMailboxIdentity -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString -String "$RoomMailPassword" -AsPlainText -Force)

#Set Meeting Room reqiremtns
Set-CalendarProcessing -Identity MeetingRoom@contoso.com -AutomateProcessing AutoAccept -AddOrganizerToSubject $false -DeleteComments $false -DeleteSubject $false
<#
AutomateProcessing: AutoAccept (Meeting organizers receive the room reservation decision directly without human intervention: free = accept; busy = decline.)
AddOrganizerToSubject: $false (The meeting organizer is not added to the subject of the meeting request.)
DeleteComments: $false (Keep any text in the message body of incoming meeting requests.)
DeleteSubject: $false (Keep the subject of incoming meeting requests.)
RemovePrivateProperty: $false (Ensures the private flag that was sent by the meeting organizer in the original meeting request remains as specified.)
AddAdditionalResponse: $true (The text specified by the AdditionalResponse parameter is added to meeting requests.)
AdditionalResponse: "This is a Teams Meeting room!" (The additional text to add to the meeting request.)
#>

#Set password to Never expire
$cred
Connect-MsolService -Credential $cred
Set-MsolUser -UserPrincipalName MeetingRoom@contoso.com -PasswordNeverExpires $true

#Allow forwarding, meeting invites from external domains
#To check status: 
Get-Mailbox MeetingRoom@contoso.com | Get-CalendarProcessing | Select *external*
#To allow external: 
Get-Mailbox MeetingRoom@contoso.com | Set-CalendarProcessing -ProcessExternalMeetingMessages $true

#MicrosoftTeamsPSTN

Import-Module SkypeOnlineConnector
$cssess=New-CsOnlineSession -Credential $cred
Import-PSSession $cssess -AllowClobber

#Find the registrar pool - take note of the result, you will need this shortly.
Get-CsOnlineUser -Identity $rm | Select -Expand RegistrarPool

#Enable the room account for teams, using the registrar pool name from above
Enable-CsMeetingRoom -Identity MeetingRoom@contoso.com -RegistrarPool "pool name from the above line of code" -SipAddressType EmailAddress