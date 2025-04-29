# Check WMI event subscriptions for persistence
Write-Host "Checking WMI Event Subscriptions..."
Get-WmiObject -Namespace root\Subscription -Class __EventFilter
Get-WmiObject -Namespace root\Subscription -Class __FilterToConsumerBinding
