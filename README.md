# Windows_Any_Device_Connected_Notification
Show device info in windows notification when device is connected(new or already known).

## Step 1: Enable Plug and Play Auditing
As admin:
```powershell
auditpol /set /subcategory:"Plug and Play Events" /success:enable
```

## Step 2: Task Scheduler Configuration

Open Task Scheduler and Create Task.

General Tab:

Select "Run only when user is logged on". (If you select "Run whether logged on or not," the script runs in a hidden session and you won't see the pop-up).

Check "Run with highest privileges" (Necessary to read the Security Log).

Triggers Tab: New > On an event.

Log: Security

Source: Microsoft-Windows-Security-Auditing

Event ID: 6416

Actions Tab: New > Start a program.

Program/script: powershell.exe

Add arguments: -ExecutionPolicy Bypass -WindowStyle Hidden -File "path_to_script"
