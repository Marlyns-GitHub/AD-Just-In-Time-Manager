# =============================================================================#
#                             AD Just-In-Time Manager                          #
#                          Developped by Marlyns NKUNGA                        #
#                              Free and Open Source                            #
#                                Copyright © 2026                              #
# =============================================================================#

# Load Assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Define xaml code from visual studio in here string 
[xml]$xaml = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="AD Just-In-Time Manager" Height="600" Width="450" FontFamily="Arial Narrow" FontSize="19" Background="#E5E4E2">
    <Grid>
        <Button x:Name="About" Content="About" HorizontalAlignment="Left" Margin="326,18,0,0" VerticalAlignment="Top" Height="30" Width="100"/>
        <Label x:Name="label1" Content="Select Username" HorizontalAlignment="Left" Margin="13,69,0,0" VerticalAlignment="Top"/>
        <Label x:Name="label2" Content="Select Group" HorizontalAlignment="Left" Margin="13,104,0,0" VerticalAlignment="Top"/>
        <Label x:Name="label3" Content="Time by minutes" HorizontalAlignment="Left" Margin="13,138,0,0" VerticalAlignment="Top"/>
        <ComboBox x:Name="selectusr" HorizontalAlignment="Left" Margin="176,69,0,0" VerticalAlignment="Top" Width="250"/>
        <ComboBox x:Name="selectgp" HorizontalAlignment="Left" Margin="176,104,0,0" VerticalAlignment="Top" Width="250"/>
        <TextBox x:Name="timer" HorizontalAlignment="Left" Margin="176,139,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="250" Height="30" BorderBrush="#000000"/>
        <CheckBox x:Name="checkbx" Content="Check to set the time" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="176,175,0,0" Width="250" Height="32" BorderBrush="#000000"/>
        <Label Content="Message" HorizontalAlignment="Left" Height="34" Margin="13,197,0,0" VerticalAlignment="Top" Width="173"/>
        <TextBox x:Name="outputbx" HorizontalAlignment="Center" Height="270" Margin="0,231,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="412" AcceptsReturn="True"/>
        <Button x:Name="button1" Content="Add Member" HorizontalAlignment="Left" Margin="288,506,0,0" VerticalAlignment="Top" Width="136" Height="30"/>
    </Grid>
</Window>
"@

# Clean up XAML & Load Window
$reader = New-Object System.Xml.XmlNodeReader($xaml)
$xamlForm = [System.Windows.Markup.XamlReader]::Load($reader)

$xaml.SelectNodes("//*[@*[name()='x:Name' or name()='Name']]") | ForEach-Object {
    $controlName = $_.Name
    if (-not $controlName) { $controlName = $_.Attributes['x:Name'].Value }
    Set-Variable -Name $controlName -Value $xamlForm.FindName($controlName) -Scope Script
}

# Code to run before button click event
function Import-Objects {
    $users = Get-ADUser -Filter 'Name -ne "Administrator" -and Name -ne "Guest" -and Name -ne "krbtgt"' -Properties name, samaccountname | ForEach-object -MemberName samaccountname
    $users | ForEach-object -Process {$selectusr.addtext($_)}

    $groups = Get-ADGroup -Filter * -Properties name, samaccountname | ForEach-Object -MemberName samaccountname
    $groups | ForEach-Object -Process {$selectgp.AddText($_)}
}

Import-Objects

# Function
function Show-About {
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="About" Height="250" Width="300" WindowStartupLocation="CenterScreen">
    <Grid Background="White">
        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Center">
            <TextBlock Text="AD Just-in-Time Manager" FontSize="18" FontWeight="Bold" Foreground="Black" TextAlignment="Center"/>
            <TextBlock Text="Version 1.0.0" FontSize="14" Foreground="Gray" TextAlignment="Center" Margin="0,5,0,5"/>
            <TextBlock Text="Created by Marlyns NKUNGA" FontSize="14" Foreground="Black" TextAlignment="Center"/>
            <TextBlock Text="Free, open source" FontSize="14" Foreground="Black" TextAlignment="Center"/>
            <TextBlock Text="Copyright © 2026" FontSize="12" Foreground="Gray" TextAlignment="Center"/>
            <Button Name="buttoncls" Content="Close" Width="100" Height="30" Margin="10" HorizontalAlignment="Center"/>
        </StackPanel>
    </Grid>
</Window>
"@
    # Clean the code and load window
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $About = [Windows.Markup.XamlReader]::Load($reader)

    # Close About Window
    $buttoncls = $About.FindName("buttoncls")
    $buttoncls.Add_Click({$About.Close()})

    # Show the informations
    $About.ShowDialog()
}

# Code to run when button is clicked
function jit {
    try {
        
        $IdUser = $selectusr.SelectedItem.ToString()
        $IdGroup = $selectgp.SelectedItem.ToString()

        if($checkbx.IsChecked)
            {
                $gpcheck = (Get-ADGroup -Identity "$IdGroup" -Properties name, samaccountname | Select-Object samaccountname).samaccountname
                if($gpcheck)
                    {
                        $time = $timer.Text
                        if ($time)
                            {
                                Add-ADGroupMember -Identity "$gpcheck" -Members $IdUser -MemberTimeToLive(New-TimeSpan -Minutes $time)
                                $message += "The account $IdUser was added to $gpcheck group just for $time minutes. The account will be automatically removed from this group."
                            }  
                    }
           }
        else 
           {
                $message += "Warning : Please checkbox must be checked"
                $outputbx.Text = $message
           }
        $outputbx.Text = $message
    }
  catch 
    {
        $message += "Warning : You cannot call a method on a null-valued expression"
        $outputbx.Text = $message
    }
}

# 6. Show the Window (Modal)
$button1.add_click({jit})
$About.add_click({Show-About})
$xamlForm.ShowDialog() | Out-Null