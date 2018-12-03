Get-VM | Get-VMSnapshot –Name BeforeUpdate | Restore-VMSnapshot
Get-VM | Get-VMSnapshot –Name BeforeUpdate |  Remove-VMSnapshot
Get-Service 'StorageCraft ImageManager' | start-service

