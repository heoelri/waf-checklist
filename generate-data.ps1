
$AllItems = @()
Get-ChildItem -Path "input/" | where { $_.Name -match ".data.json$" } | % {
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
        $_ | Add-Member -MemberType NoteProperty -Name tags -Value $_.pillars -Force
        $_ | Add-Member -MemberType NoteProperty -Name priority -Value "Medium" -Force
        $_ | Add-Member -MemberType NoteProperty -Name category -Value @($_.category) -Force

        #$_.category += "all"
        $_.tags += "all"
    }

    $AllItems = $AllItems |  Where-Object { $_.type -in ("Configuration Recommendations", "Design Considerations") }

    $AllItems | Where-Object { $_.pillars -contains $currentPillar } | ConvertTo-Json -depth 16 | Set-content "data/en/items/$currentPillar.json"
}