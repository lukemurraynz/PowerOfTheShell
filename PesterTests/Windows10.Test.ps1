Describe 'SMB1 Check' {

  Context 'Check the SMB1 protocol is enabled' {

  It 'Check the SMB1 protocol is enabled' {
   $a = Get-SmbServerConfiguration | Select EnableSMB1Protocol
      $a.EnableSMB1Protocol | Should -Be $false
  }

  }
  }
