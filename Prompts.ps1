# ██████╗░██╗░░░██╗███████╗███████╗  ███╗░░██╗███████╗██████╗░██████╗░
# ██╔══██╗██║░░░██║██╔════╝██╔════╝  ████╗░██║██╔════╝██╔══██╗██╔══██╗
# ██████╦╝██║░░░██║█████╗░░█████╗░░  ██╔██╗██║█████╗░░██████╔╝██║░░██║
# ██╔══██╗██║░░░██║██╔══╝░░██╔══╝░░  ██║╚████║██╔══╝░░██╔══██╗██║░░██║
# ██████╦╝╚██████╔╝██║░░░░░██║░░░░░  ██║░╚███║███████╗██║░░██║██████╔╝
# ╚═════╝░░╚═════╝░╚═╝░░░░░╚═╝░░░░░  ╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═════╝░

# PLUG&PLAY Sysadmin Basic Automation Script by Aaron Voborny (a.k.a. the "Buff Nerd")

# Initialize a variable to control the loop execution
$continue = $true

while ($continue) {
    # Display menu options
    Write-Host ""
    Write-Host "Menu:"
    Write-Host "1. List .log files in DailyLog.txt"
    Write-Host "2. List files in Requirements1 folder (sorted)"
    Write-Host "3. Display CPU and memory usage"
    Write-Host "4. List running processes (sorted by virtual size)"
    Write-Host "5. Exit"
    $choice = Read-Host "Enter your choice (1-5)"

    switch ($choice) {
        1 {
            # List .log files in DailyLog.txt
            try {
                $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                Get-ChildItem $PSScriptRoot -Filter "*.log" | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append
                Write-Host "Listing .log files in DailyLog.txt (Date: $date)"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Out of memory exception occurred. Please free up memory and try again."
            }
        }
        2 {
            # List files in Requirements1 folder (sorted)
            try {
                Get-ChildItem $PSScriptRoot | Sort-Object -Property Name | Format-Table | Out-File -FilePath $PSScriptRoot\contents.txt
                Write-Host "Listing files in Requirements1 folder (sorted)"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Out of memory exception occurred. Please free up memory and try again."
            }
        }
        3 {
            # Retrieve and display CPU usage data
            try {
                $cpuData = Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Processor | Select-Object -Property Name, PercentProcessorTime, PercentIdleTime, PercentUserTime
                $cpuData | Format-Table | Out-File -FilePath "$PSScriptRoot\CPU_Memory_Usage.txt"
                Write-Host "Displaying CPU usage data in CPU_Memory_Usage.txt"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Out of memory exception occurred while retrieving CPU usage data. Please free up memory and try again."
            }

            # Add a separator between CPU and memory usage data
            "`nMemory Usage`n" | Out-File -FilePath $PSScriptRoot\CPU_Memory_Usage.txt -Append

            # Retrieve and display memory usage data
            try {
                $memoryData = Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_Memory | Select-Object -Property AvailableMBytes, CommittedBytes
                $memoryData | Format-Table | Out-File -FilePath $PSScriptRoot\CPU_Memory_Usage.txt -Append
                Write-Host "Displaying memory usage data in CPU_Memory_Usage.txt"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Out of memory exception occurred while retrieving memory usage data. Please free up memory and try again."
            }
        }
        4 {
            # List running processes (sorted by virtual size)
            try {
                $processes = Get-Process | Where-Object { $_.Status -ne "Stopped" } | Sort-Object -Property VM
                $processes | Format-Table -Property Name, VM -AutoSize | Out-File -FilePath $PSScriptRoot\RunningProcesses.txt
                Write-Host "Listing running processes (sorted by virtual size)"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Out of memory exception occurred. Please free up memory and try again."
            }
        }
        5 {
            # Exit the script
            $continue = $false
            Write-Host "Exiting script..."
        }
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 5."
        }
    }
}
