# AD-Just-In-Time-Manager
Identity alone doesn't create risk. Privilege does

# Active Directory Just-in-Time

Just-In-Time (JIT) in the context of Active Directory (AD) refers to a model of granting privileges to a user for a limited period of time. This approach is supported by Privileged Access Management (PAM) feature.

JIT reduce the risk of unauthorized or unnecessary access to critical systems or data and ensuring that administrative privileges are granted only when necessary and only for a specific duration.

Active Directory Just-in-Time is native and managed via PowerShell cmdlet, it can be complex for a daily usage. I developped adjitmgr, a Graphical User Interface to make it easier to use.

# Benefit of Just-In-Time

Just-In-Time (JIT) align with the Auditing and compliance, it allows you to minimize security risks by granting privileges only when needed and for limited duration.

   # Enforce principe of least privilege
   # No permenant domain admins membership
   # Dynamic Privilege Assignment
   # Privileged access is granted only just-in-time and for limited duration
   # Reduces risk from credentials theft
   # Moving beyond standing privileged
   # Eliminating standing privileged
   # Falicitate Auditing and Compliance
   # Zero trust alignment

# AD Just-In-Time Process

<img width="1206" height="588" alt="Image" src="https://github.com/user-attachments/assets/4a5f8eea-7e88-4bda-bcd8-06d83e77b043" />

# How to use

Some requirements must be met before to use adjitmgr tool, make sure that PAM feature is enabled into Active Directory. Otherwise use adpam.ps1 script to enable PAM feature.

   # Forest functional level Windows Server 2016 or higher
   # Administrator privilege
   # Enable PAM feature using adpam.ps1 script
   # Run adjitmgr.ps1 via PowerShell as admin
   # Select Username and Group
   # Time by minutes cannot be empty
   # Checkbox must be ckeched