#region Script header
<#
.SYNOPSIS
This PowerShell script prompts the user for input to perform various administrative tasks.
.DESCRIPTION
The script uses a switch statement to execute different tasks based on the user's input. The tasks include listing .log files, listing files in tabular format, listing CPU and memory usage, listing processes by virtual size, and exiting the script. The script uses exception handling to handle out of memory errors.
.PARAMETER Input
The user's choice of task to perform. It can be a number between 1 and 5.
#>

#region Script body

# Naveed Fayyaz
#Student ID: 010007666


# create a loop that prompts the user for input until they press 5
while ($true) {
    # prompt the user for input and store it in $input variable
    Write-Host "Please select an option:"
    Write-Host "1. List .log files in Requirements1 folder"
    Write-Host "2. List files in Requirements1 folder in tabular format"
    Write-Host "3. List current CPU and memory usage"
    Write-Host "4. List running processes by virtual size"
    Write-Host "5. Exit the script"
    $Choice = Read-Host "Enter your choice"
    
    # use a try-catch-finally block to handle errors and exceptions
    try {
      # use a switch statement to execute different tasks based on the input
      switch ($Choice) {
        1 { 
          # list files with .log extension using regex and append to DailyLog.txt
          Get-ChildItem -Path $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append
          # write the current date to the file
          Get-Date | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append
        }
        2 { 
          # list files in Requirements1 folder in tabular format and sort by name
          Get-ChildItem -Path $PSScriptRoot | Sort-Object Name | Format-Table | Write-Output
          # direct the output to a new file called C916contents.txt
          Get-ChildItem -Path $PSScriptRoot | Sort-Object Name | Format-Table | Out-File -FilePath $PSScriptRoot\C916contents.txt
        }
        3 { 
          # list current CPU and memory usage using Get-Counter cmdlet
          Get-Counter '\Memory\% Committed Bytes In Use','\Processor(_Total)\% Processor Time' | Format-List
        }
        4 { 
          # list running processes by virtual size using Get-Process cmdlet and display in grid format
          Get-Process | Sort-Object VM | Out-GridView
        }
        5 { 
          # exit the script using Exit keyword
          Exit
        }
        default { 
          # write an error message for invalid input
          Write-Error "Invalid choice. Please enter a number between 1 and 5."
        }
      }
      if ($input -eq 5) {
        break # exit the loop
      }
    }
    catch [System.OutOfMemoryException] {
      # handle the out of memory exception by writing a warning message and freeing up some memory
      Write-Warning "Out of memory error occurred. Please close some applications and try again."
      [System.GC]::Collect()
    }
    catch {
      # handle any other exception by writing an error message and the exception details
      Write-Error "An unexpected error occurred. Please check the exception details below."
      $_.Exception | Format-List -Force
    }
    finally {
      # do something that always runs, such as logging or cleaning up resources
      Write-Verbose "Script completed."
    }
  }
  #endregion