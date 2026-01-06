# Give the system a moment to write the full event data
Start-Sleep -Seconds 1

# Retrieve the latest PnP Audit event (6416)
$Event = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=6416} -MaxEvents 1

# Parse the XML data from the event
[xml]$xml = $Event.ToXml()
$eventData = $xml.Event.EventData.Data

# Extract specific details
$deviceName = ($eventData | Where-Object { $_.Name -eq 'DeviceDescription' }).'#text'
$deviceClass = ($eventData | Where-Object { $_.Name -eq 'ClassName' }).'#text'

# Fallback if names are empty
if (-not $deviceName) { $deviceName = "Unknown Device" }
if (-not $deviceClass) { $deviceClass = "Hardware" }

# Create the Windows Notification
$Title = "New Device Connected"
$Message = "Name: $deviceName `nType: $deviceClass"

# Using the built-in Windows notification system
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
$toastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
$toastXml.LoadXml($template.GetXml())

$toastTextElements = $toastXml.GetElementsByTagName("text")
$toastTextElements.Item(0).AppendChild($toastXml.CreateTextNode($Title)) | Out-Null
$toastTextElements.Item(1).AppendChild($toastXml.CreateTextNode($Message)) | Out-Null

$toast = [Windows.UI.Notifications.ToastNotification]::new($toastXml)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Windows Hardware Manager").Show($toast)