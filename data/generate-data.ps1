          
          
          
          
$AllItems = @()
Get-ChildItem -Path "en/items" | where { $_.Name -match ".data.json$" } | % {
    Get-Content -Path $_.FullName | ConvertFrom-Json | %{
        if($_) 
        {
            $AllItems += $_
        }
    }
}

$AllPillars = ($AllItems.pillars | Group).Name

$AllPillars | % {
    $currentPillar = $_
    Write-Host "Combine data for $currentPillar pillar"

    $AllItems | % {
        $_ | Add-Member -MemberType NoteProperty -Name tags -Value @("all", $_.subCategory) -Force
        $_ | Add-Member -MemberType NoteProperty -Name priority -Value "medium" -Force
    }

    $AllItems | Where-Object { $_.pillars -contains $currentPillar } | ConvertTo-Json -depth 16 | Set-content "en/items/$currentPillar.json"
}