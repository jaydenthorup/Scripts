Get-Service 'StorageCraft ImageManager' | stop-service
Get-VM | Checkpoint-VM –SnapshotName BeforeUpdate
